Select *
from olist_orders_dataset
where order_status = 'delivered'
order by order_purchase_timestamp desc;

Select * from olist_order_items_dataset;

--Step 01: Determine which sellers has the dominant proportion of orders
with count_order as (Select seller_id,
       count(order_id) as count_order
from olist_order_items_dataset
group by seller_id)
Select seller_id, count_order,
sum(count_order) over() as total_order,
format(count_order*1.0/(sum(count_order) over()),'p') as pct
from count_order
order by count_order desc;
--> the figure shows that no dominant seller for orders

--Step 02: Find the total transaction of seller of their order has been delivered to customer in 2017
with full_transaction_2017 as (Select olist_order.*,seller_id
from olist_orders_dataset as olist_order
inner join olist_order_items_dataset as olist_order_items
on olist_order.order_id = olist_order_items.order_id
where year(order_purchase_timestamp) = 2017 and order_status = 'delivered'),
--Step 03: Find total transaction of delivered order in 01/2017 in full_transaction_2017
seller_list as (Select distinct seller_id
from  full_transaction_2017
where month(order_purchase_timestamp) =1),
full_trans as (Select full_transaction_2017.*
from seller_list
join full_transaction_2017
on seller_list.seller_id=full_transaction_2017.seller_id
where order_status = 'delivered'),
--Step 04: count the seller at the begining each month in 2017
sub_month as (Select month(order_purchase_timestamp) as subsequence_month,
       count(distinct seller_id) as retained_users
from full_trans
group by month(order_purchase_timestamp))
--Step 05: calculate the retention rate of sellers in 01/2017 through the year 2017
Select *,
       (select retained_users from sub_month where subsequence_month = 1) as original_users,
       format(retained_users*1.0/(select retained_users from sub_month where subsequence_month = 1),'p') as pct
from sub_month
order by subsequence_month;

--Step 06: We calculate the seller retention rate of 12 month in 2017

-- Step 06.1: Find the first time purchase of each month in 2017 by seller_id

with full_transaction_2017 as (Select olist_order.*,seller_id
from olist_orders_dataset as olist_order
inner join olist_order_items_dataset as olist_order_items
on olist_order.order_id = olist_order_items.order_id
where year(order_purchase_timestamp) = 2017 and order_status = 'delivered'),

first_time_purchase as (Select order_id,seller_id,
       order_purchase_timestamp as purchase_time,
       min(order_purchase_timestamp) over (partition by seller_id) as first_time,
       datediff(month,min(order_purchase_timestamp) over (partition by seller_id),order_purchase_timestamp) as subsequence_month
from full_transaction_2017),

sub_month as (Select month(first_time) as acquisition_month,
       subsequence_month,
       count(distinct seller_id) as retained_user
       from first_time_purchase
       group by month(first_time), subsequence_month)

--Step 06.02: Calculate retention rate of 12 month in 2017
Select *,
       first_value (retained_user) over(partition by acquisition_month order by subsequence_month) as original_users,
       format(retained_user*1.0/first_value(retained_user) over(partition by acquisition_month order by subsequence_month),'p') as pct
into #retention_table1
from sub_month
order by acquisition_month;

--Step 06.03: pivot table: Use result from #retention_table1

Select acquisition_month,original_users,
       "0","1","2","3","4","5","6","7","8","9","10","11"
from (Select acquisition_month,subsequence_month,original_users, pct
       from #retention_table1
     ) as source_table
pivot (min(pct) 
       for subsequence_month in ("0","1","2","3","4","5","6","7","8","9","10","11")
       ) pivot_table
order by acquisition_month
