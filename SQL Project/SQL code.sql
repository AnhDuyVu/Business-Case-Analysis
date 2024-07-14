/*I. Exploratory Data Analysis*/
/* Change approriate data type*/

with raw_data_type as (SELECT invoiceNo,
stockcode,
description,
quantity,
UnitPrice,
DATE(timestamp(invoicedate)) as date,
CustomerID
 FROM `my-project-business-case.Online_Retail_2.Online_Retail_2`)

/* Check negative value and null value in quantity, unitprice, customerID*/
Select *
from raw_data_type
where quantity <= 0 or unitprice <=0 or customerID is Null;

/* Nhận xét; data có quantity <= 0, unitprice <= 0 và customerID missing value -> cần loại bỏ những data này vì những data này là những data không chính xác sẽ làm ảnh hưởng đến kết quả phân tích về sau */
/* data sau khi loại bỏ những dữ liệu negatve và missing value và dữ liệu trùng lặp */
with raw_data as (SELECT distinct *
 FROM `my-project-business-case.Online_Retail_2.Online_Retail_2`
where quantity >0 and unitprice > 0 and customerID is not Null),
/* Tìm và loại bỏ outlier bằng z-score*/
avg_stddev as (Select *,
(Select avg(quantity) from `my-project-business-case.Online_Retail_2.Online_Retail_2`) as avg,
(Select stddev(quantity) from `my-project-business-case.Online_Retail_2.Online_Retail_2`) as sttdev
from raw_data),
raw_data_2 as (Select * from (Select *,
(quantity-avg)/sttdev as z_score
from avg_stddev) as z_score_table
where abs(z_score) <3),
/* invoice date có những ngày format lỗi cần định dạng lại format*/
raw_data_3 as (Select * except(InvoiceDate),
cast(Invoicedate as string) as Invoicedate
from raw_data_2),
raw_data_4 as (SELECT *,
concat(replace (left(invoicedate,4),'0011','2011'), substring(Invoicedate,5,length(Invoicedate) - length(left(invoicedate,4)))) as invoice_date_1
from raw_data_3 
where left(invoicedate,4) <>'0010'
union distinct
SELECT *,
concat(replace (left(invoicedate,4),'0010','2010'), substring(Invoicedate,5,length(Invoicedate) - length(left(invoicedate,4)))) as invoice_date_1
from raw_data_3 
where left(invoicedate,4) <>'0011'),
data_clean as (Select * except(InvoiceDate,invoice_date_1),
cast (invoice_date_1 as timestamp) as invoicedate
from raw_data_4),
  
/*.2 tạo retention cohort analyst*/
  
/* customer cohort 12 month*/
stt as (Select *,
row_number() over(partition by customerID,invoicedate order by invoicedate) as stt
from data_clean),
retail_index as (Select customerID,
round(Revenue,2) as Revenue,
extract(year from first_purchase_date) || '-' || lpad(cast(extract(month from first_purchase_date) as string),2,'0') as cohort_date,
purchase_date,
(extract(year from purchase_date) - extract(year from first_purchase_date))* 12 + (extract(month from purchase_date) - extract(month from first_purchase_date)) +1 as index 
from (Select customerID, 
Quantity* UnitPrice as Revenue,
min(invoicedate) over(partition by customerID) as first_purchase_date,
invoicedate as purchase_date
from stt) a),
index_table as (Select cohort_date,
index,
count(distinct customerID) as count,
sum(Revenue) as revenue
from retail_index
group by cohort_date, 2),
new_index_table as (Select cohort_date,
index,
row_number() over(partition by cohort_date order by cohort_date, index) as new_index,
count,
revenue
from index_table
order by cohort_date),
index_12_month as (Select *
from new_index_table
where new_index <=13)
Select cohort_date,
sum(case when index = 1 then count else 0 end) as m1,
sum(case when index = 2 then count else 0 end) as m2,
sum(case when index = 3 then count else 0 end) as m3,
sum(case when index = 4 then count else 0 end) as m4,
sum(case when index = 5 then count else 0 end) as m5,
sum(case when index = 6 then count else 0 end) as m6,
sum(case when index = 7 then count else 0 end) as m7,
sum(case when index = 8 then count else 0 end) as m8,
sum(case when index = 9 then count else 0 end) as m9,
sum(case when index = 10 then count else 0 end) as m10,
sum(case when index = 11 then count else 0 end) as m11,
sum(case when index = 12 then count else 0 end) as m12,
sum(case when index = 13 then count else 0 end) as m13
from index_12_month
group by cohort_date
order by cohort_date;

/*rentention cohort*/
with raw_data as (SELECT distinct *
 FROM `my-project-business-case.Online_Retail_2.Online_Retail_2`
where quantity >0 and unitprice > 0 and customerID is not Null),
avg_stddev as (Select *,
(Select avg(quantity) from `my-project-business-case.Online_Retail_2.Online_Retail_2`) as avg,
(Select stddev(quantity) from `my-project-business-case.Online_Retail_2.Online_Retail_2`) as sttdev
from raw_data),
raw_data_2 as (Select * from (Select *,
(quantity-avg)/sttdev as z_score
from avg_stddev) as z_score_table
where abs(z_score) <3),
raw_data_3 as (Select * except(InvoiceDate),
cast(Invoicedate as string) as Invoicedate
from raw_data_2),
raw_data_4 as (SELECT *,
concat(replace (left(invoicedate,4),'0011','2011'), substring(Invoicedate,5,length(Invoicedate) - length(left(invoicedate,4)))) as invoice_date_1
from raw_data_3 
where left(invoicedate,4) <>'0010'
union distinct
SELECT *,
concat(replace (left(invoicedate,4),'0010','2010'), substring(Invoicedate,5,length(Invoicedate) - length(left(invoicedate,4)))) as invoice_date_1
from raw_data_3 
where left(invoicedate,4) <>'0011'),
data_clean as (Select * except(InvoiceDate,invoice_date_1),
cast (invoice_date_1 as timestamp) as invoicedate
from raw_data_4),
stt as (Select *,
row_number() over(partition by customerID,invoicedate order by invoicedate) as stt
from data_clean),
retail_index as (Select customerID,
round(Revenue,2) as Revenue,
extract(year from first_purchase_date) || '-' || lpad(cast(extract(month from first_purchase_date) as string),2,'0') as cohort_date,
purchase_date,
(extract(year from purchase_date) - extract(year from first_purchase_date))* 12 + (extract(month from purchase_date) - extract(month from first_purchase_date)) +1 as index 
from (Select customerID, 
Quantity* UnitPrice as Revenue,
min(invoicedate) over(partition by customerID) as first_purchase_date,
invoicedate as purchase_date
from stt) a),
index_table as (Select cohort_date,
index,
count(distinct customerID) as count,
sum(Revenue) as revenue
from retail_index
group by cohort_date, 2),
new_index_table as (Select cohort_date,
index,
row_number() over(partition by cohort_date order by cohort_date, index) as new_index,
count,
revenue
from index_table
order by cohort_date),
index_12_month as (Select *
from new_index_table
where new_index <=13),
customer_cohort as (
Select cohort_date,
sum(case when index = 1 then count else 0 end) as m1,
sum(case when index = 2 then count else 0 end) as m2,
sum(case when index = 3 then count else 0 end) as m3,
sum(case when index = 4 then count else 0 end) as m4,
sum(case when index = 5 then count else 0 end) as m5,
sum(case when index = 6 then count else 0 end) as m6,
sum(case when index = 7 then count else 0 end) as m7,
sum(case when index = 8 then count else 0 end) as m8,
sum(case when index = 9 then count else 0 end) as m9,
sum(case when index = 10 then count else 0 end) as m10,
sum(case when index = 11 then count else 0 end) as m11,
sum(case when index = 12 then count else 0 end) as m12,
sum(case when index = 13 then count else 0 end) as m13
from index_12_month
group by cohort_date
order by cohort_date)
/* Các bước trên giông với customer cohort, tính thêm tỉ lệ phần trăm của retention phía dưới */
Select cohort_date,
(100* m1/m1) || '%' as m1,
round(100* m2/m1) || '%' as m2,
round(100* m3/m1) || '%' as m3,
round(100* m4/m1) || '%' as m4,
round(100* m5/m1) || '%' as m5,
round(100* m6/m1) || '%' as m6,
round(100* m7/m1) || '%' as m7,
round(100* m8/m1) || '%' as m8,
round(100* m9/m1) || '%' as m9,
round(100* m10/m1) || '%' as m10,
round(100* m11/m1) || '%' as m11,
round(100* m12/m1) || '%' as m12,
round(100* m13/m1) || '%' as m13
from customer_cohort;

/* churn cohort*/

with raw_data as (SELECT distinct *
 FROM `my-project-business-case.Online_Retail_2.Online_Retail_2`
where quantity >0 and unitprice > 0 and customerID is not Null),
avg_stddev as (Select *,
(Select avg(quantity) from `my-project-business-case.Online_Retail_2.Online_Retail_2`) as avg,
(Select stddev(quantity) from `my-project-business-case.Online_Retail_2.Online_Retail_2`) as sttdev
from raw_data),
raw_data_2 as (Select * from (Select *,
(quantity-avg)/sttdev as z_score
from avg_stddev) as z_score_table
where abs(z_score) <3),
raw_data_3 as (Select * except(InvoiceDate),
cast(Invoicedate as string) as Invoicedate
from raw_data_2),
raw_data_4 as (SELECT *,
concat(replace (left(invoicedate,4),'0011','2011'), substring(Invoicedate,5,length(Invoicedate) - length(left(invoicedate,4)))) as invoice_date_1
from raw_data_3 
where left(invoicedate,4) <>'0010'
union distinct
SELECT *,
concat(replace (left(invoicedate,4),'0010','2010'), substring(Invoicedate,5,length(Invoicedate) - length(left(invoicedate,4)))) as invoice_date_1
from raw_data_3 
where left(invoicedate,4) <>'0011'),
data_clean as (Select * except(InvoiceDate,invoice_date_1),
cast (invoice_date_1 as timestamp) as invoicedate
from raw_data_4),
stt as (Select *,
row_number() over(partition by customerID,invoicedate order by invoicedate) as stt
from data_clean),
retail_index as (Select customerID,
round(Revenue,2) as Revenue,
extract(year from first_purchase_date) || '-' || lpad(cast(extract(month from first_purchase_date) as string),2,'0') as cohort_date,
purchase_date,
(extract(year from purchase_date) - extract(year from first_purchase_date))* 12 + (extract(month from purchase_date) - extract(month from first_purchase_date)) +1 as index 
from (Select customerID, 
Quantity* UnitPrice as Revenue,
min(invoicedate) over(partition by customerID) as first_purchase_date,
invoicedate as purchase_date
from stt) a),
index_table as (Select cohort_date,
index,
count(distinct customerID) as count,
sum(Revenue) as revenue
from retail_index
group by cohort_date, 2),
new_index_table as (Select cohort_date,
index,
row_number() over(partition by cohort_date order by cohort_date, index) as new_index,
count,
revenue
from index_table
order by cohort_date),
index_12_month as (Select *
from new_index_table
where new_index <=13),
customer_cohort as (
Select cohort_date,
sum(case when index = 1 then count else 0 end) as m1,
sum(case when index = 2 then count else 0 end) as m2,
sum(case when index = 3 then count else 0 end) as m3,
sum(case when index = 4 then count else 0 end) as m4,
sum(case when index = 5 then count else 0 end) as m5,
sum(case when index = 6 then count else 0 end) as m6,
sum(case when index = 7 then count else 0 end) as m7,
sum(case when index = 8 then count else 0 end) as m8,
sum(case when index = 9 then count else 0 end) as m9,
sum(case when index = 10 then count else 0 end) as m10,
sum(case when index = 11 then count else 0 end) as m11,
sum(case when index = 12 then count else 0 end) as m12,
sum(case when index = 13 then count else 0 end) as m13
from index_12_month
group by cohort_date
order by cohort_date)

/* Các bước trên giông với customer cohort, tính thêm tỉ lệ phần trăm khách hàng rời bỏ phía dưới */

Select cohort_date,
(100-(100* m1/m1)) || '%' as m1,
(100- (round(100* m2/m1) )) || '%' as m2,
(100- (round(100* m3/m1,2) )) || '%' as m3,
(100- (round(100* m4/m1,2) )) || '%' as m4,
(100- (round(100* m5/m1,2) )) || '%' as m5,
(100- (round(100* m6/m1,2) )) || '%' as m6,
(100- (round(100* m7/m1,2) )) || '%' as m7,
(100- (round(100* m8/m1,2) )) || '%' as m8,
(100- (round(100* m9/m1,2) )) || '%' as m9,
(100- (round(100* m10/m1,2) )) || '%' as m10,
(100- (round(100* m11/m1,2) )) || '%' as m11,
(100- (round(100* m12/m1,2) )) || '%' as m12,
(100- (round(100* m13/m1,2) )) || '%' as m13
from customer_cohort;

/* net revenue by cohort*/
with raw_data as (SELECT distinct *
 FROM `my-project-business-case.Online_Retail_2.Online_Retail_2`
where quantity >0 and unitprice > 0 and customerID is not Null),
avg_stddev as (Select *,
(Select avg(quantity) from `my-project-business-case.Online_Retail_2.Online_Retail_2`) as avg,
(Select stddev(quantity) from `my-project-business-case.Online_Retail_2.Online_Retail_2`) as sttdev
from raw_data),
raw_data_2 as (Select * from (Select *,
(quantity-avg)/sttdev as z_score
from avg_stddev) as z_score_table
where abs(z_score) <3),
raw_data_3 as (Select * except(InvoiceDate),
cast(Invoicedate as string) as Invoicedate
from raw_data_2),
raw_data_4 as (SELECT *,
concat(replace (left(invoicedate,4),'0011','2011'), substring(Invoicedate,5,length(Invoicedate) - length(left(invoicedate,4)))) as invoice_date_1
from raw_data_3 
where left(invoicedate,4) <>'0010'
union distinct
SELECT *,
concat(replace (left(invoicedate,4),'0010','2010'), substring(Invoicedate,5,length(Invoicedate) - length(left(invoicedate,4)))) as invoice_date_1
from raw_data_3 
where left(invoicedate,4) <>'0011'),
data_clean as (Select * except(InvoiceDate,invoice_date_1),
cast (invoice_date_1 as timestamp) as invoicedate
from raw_data_4),
stt as (Select *,
row_number() over(partition by customerID,invoicedate order by invoicedate) as stt
from data_clean),
retail_index as (Select customerID,
round(Revenue,2) as Revenue,
extract(year from first_purchase_date) || '-' || lpad(cast(extract(month from first_purchase_date) as string),2,'0') as cohort_date,
purchase_date,
(extract(year from purchase_date) - extract(year from first_purchase_date))* 12 + (extract(month from purchase_date) - extract(month from first_purchase_date)) +1 as index 
from (Select customerID, 
Quantity* UnitPrice as Revenue,
min(invoicedate) over(partition by customerID) as first_purchase_date,
invoicedate as purchase_date
from stt) a),
index_table as (Select cohort_date,
index,
count(distinct customerID) as count,
sum(Revenue) as revenue
from retail_index
group by cohort_date, 2),
new_index_table as (Select cohort_date,
index,
row_number() over(partition by cohort_date order by cohort_date, index) as new_index,
count,
revenue
from index_table
order by cohort_date),
index_12_month as (Select *
from new_index_table
where new_index <=13)
Select cohort_date,
round(sum(case when index = 1 then revenue else 0 end),2) || ' ' || '$'as m1,
round(sum(case when index = 2 then revenue else 0 end),2) || ' ' || '$'as m2,
round(sum(case when index = 3 then revenue else 0 end),2) || ' ' || '$'as m3,
round(sum(case when index = 4 then revenue else 0 end),2) || ' ' || '$'as m4,
round(sum(case when index = 5 then revenue else 0 end),2) || ' ' || '$'as m5,
round(sum(case when index = 6 then revenue else 0 end),2) || ' ' || '$'as m6,
round(sum(case when index = 7 then revenue else 0 end),2) || ' ' || '$'as m7,
round(sum(case when index = 8 then revenue else 0 end),2) || ' ' || '$'as m8,
round(sum(case when index = 9 then revenue else 0 end),2) || ' ' || '$'as m9,
round(sum(case when index = 10 then revenue else 0 end),2)|| ' ' || '$'as m10,
round(sum(case when index = 11 then revenue else 0 end),2)|| ' ' || '$'as m11,
round(sum(case when index = 12 then revenue else 0 end),2)|| ' ' || '$'as m12,
round(sum(case when index = 13 then revenue else 0 end),2)|| ' ' || '$'as m13
from index_12_month
group by cohort_date
order by cohort_date;

/* net revenue by cohort theo phần trăm */

with raw_data as (SELECT distinct *
 FROM `my-project-business-case.Online_Retail_2.Online_Retail_2`
where quantity >0 and unitprice > 0 and customerID is not Null),
avg_stddev as (Select *,
(Select avg(quantity) from `my-project-business-case.Online_Retail_2.Online_Retail_2`) as avg,
(Select stddev(quantity) from `my-project-business-case.Online_Retail_2.Online_Retail_2`) as sttdev
from raw_data),
raw_data_2 as (Select * from (Select *,
(quantity-avg)/sttdev as z_score
from avg_stddev) as z_score_table
where abs(z_score) <3),
raw_data_3 as (Select * except(InvoiceDate),
cast(Invoicedate as string) as Invoicedate
from raw_data_2),
raw_data_4 as (SELECT *,
concat(replace (left(invoicedate,4),'0011','2011'), substring(Invoicedate,5,length(Invoicedate) - length(left(invoicedate,4)))) as invoice_date_1
from raw_data_3 
where left(invoicedate,4) <>'0010'
union distinct
SELECT *,
concat(replace (left(invoicedate,4),'0010','2010'), substring(Invoicedate,5,length(Invoicedate) - length(left(invoicedate,4)))) as invoice_date_1
from raw_data_3 
where left(invoicedate,4) <>'0011'),
data_clean as (Select * except(InvoiceDate,invoice_date_1),
cast (invoice_date_1 as timestamp) as invoicedate
from raw_data_4),
stt as (Select *,
row_number() over(partition by customerID,invoicedate order by invoicedate) as stt
from data_clean),
retail_index as (Select customerID,
round(Revenue,2) as Revenue,
extract(year from first_purchase_date) || '-' || lpad(cast(extract(month from first_purchase_date) as string),2,'0') as cohort_date,
purchase_date,
(extract(year from purchase_date) - extract(year from first_purchase_date))* 12 + (extract(month from purchase_date) - extract(month from first_purchase_date)) +1 as index 
from (Select customerID, 
Quantity* UnitPrice as Revenue,
min(invoicedate) over(partition by customerID) as first_purchase_date,
invoicedate as purchase_date
from stt) a),
index_table as (Select cohort_date,
index,
count(distinct customerID) as count,
sum(Revenue) as revenue
from retail_index
group by cohort_date, 2),
new_index_table as (Select cohort_date,
index,
row_number() over(partition by cohort_date order by cohort_date, index) as new_index,
count,
revenue
from index_table
order by cohort_date),
index_12_month as (Select *
from new_index_table
where new_index <=13),
revenue_cohort_table as (
Select cohort_date,
round(sum(case when index = 1 then revenue else 0 end),2) as m1,
round(sum(case when index = 2 then revenue else 0 end),2) as m2,
round(sum(case when index = 3 then revenue else 0 end),2) as m3,
round(sum(case when index = 4 then revenue else 0 end),2) as m4,
round(sum(case when index = 5 then revenue else 0 end),2) as m5,
round(sum(case when index = 6 then revenue else 0 end),2) as m6,
round(sum(case when index = 7 then revenue else 0 end),2) as m7,
round(sum(case when index = 8 then revenue else 0 end),2) as m8,
round(sum(case when index = 9 then revenue else 0 end),2) as m9,
round(sum(case when index = 10 then revenue else 0 end),2) as m10,
round(sum(case when index = 11 then revenue else 0 end),2) as m11,
round(sum(case when index = 12 then revenue else 0 end),2) as m12,
round(sum(case when index = 13 then revenue else 0 end),2) as m13
from index_12_month
group by cohort_date
order by cohort_date)
Select 
cohort_date,
(100* m1/m1) || '%' as m1,
(round(100* m2/m1) ) || '%' as m2,
(round(100* m3/m1) ) || '%' as m3,
(round(100* m4/m1) ) || '%' as m4,
(round(100* m5/m1) ) || '%' as m5,
(round(100* m6/m1) ) || '%' as m6,
(round(100* m7/m1) ) || '%' as m7,
(round(100* m8/m1) ) || '%' as m8,
(round(100* m9/m1) ) || '%' as m9,
(round(100* m10/m1) ) || '%' as m10,
(round(100* m11/m1) ) || '%' as m11,
(round(100* m12/m1) ) || '%' as m12,
(round(100* m13/m1) ) || '%' as m13
from revenue_cohort_table;

Select * from `my-project-business-case.Online_Retail_2.Online_Retail_2` order by description desc;

/* AOV table */
with raw_data as (SELECT distinct *
 FROM `my-project-business-case.Online_Retail_2.Online_Retail_2`
where quantity >0 and unitprice > 0 and customerID is not Null),
avg_stddev as (Select *,
(Select avg(quantity) from `my-project-business-case.Online_Retail_2.Online_Retail_2`) as avg,
(Select stddev(quantity) from `my-project-business-case.Online_Retail_2.Online_Retail_2`) as sttdev
from raw_data),
raw_data_2 as (Select * from (Select *,
(quantity-avg)/sttdev as z_score
from avg_stddev) as z_score_table
where abs(z_score) <3),
raw_data_3 as (Select * except(InvoiceDate),
cast(Invoicedate as string) as Invoicedate
from raw_data_2),
raw_data_4 as (SELECT *,
concat(replace (left(invoicedate,4),'0011','2011'), substring(Invoicedate,5,length(Invoicedate) - length(left(invoicedate,4)))) as invoice_date_1
from raw_data_3 
where left(invoicedate,4) <>'0010'
union distinct
SELECT *,
concat(replace (left(invoicedate,4),'0010','2010'), substring(Invoicedate,5,length(Invoicedate) - length(left(invoicedate,4)))) as invoice_date_1
from raw_data_3 
where left(invoicedate,4) <>'0011'),
data_clean as (Select * except(InvoiceDate,invoice_date_1),
cast (invoice_date_1 as timestamp) as invoicedate
from raw_data_4),
time_differ_table as (
Select *,
cast(date_diff(next_invoicedate, invoicedate, day) as numeric) as time_differ
from (Select customerID,
invoiceNo,
quantity * unitprice as revenue,
invoicedate,
lead(invoicedate) over(partition by customerID order by customerID,invoicedate) as next_invoicedate
from data_clean) as a),
customer_revenue as (Select extract(year from invoicedate) || '-' || lpad(cast(extract(month from invoicedate) as string),2,'0') as year_month_invoicedate,
round(sum(revenue),2) as revenue,
count(distinct invoiceNo) as count_order,
count(distinct if( time_differ = 0,invoiceNo,null)) as count_order_new_customer,
count(distinct if( time_differ > 0,invoiceNo,null)) as count_order_old_customer,
round(sum(if (time_differ = 0,revenue,0)),2) as new_customer_revenue,
round(sum(if (time_differ >0,revenue,0)),2) as old_customer_revenue,
from time_differ_table
group by 1
order by 1),
customer_contribution as (Select *,
round((new_customer_revenue/ revenue)*100,2) || '%' as percentage_new_customer_rev,
round((old_customer_revenue/ revenue)*100,2) || '%' as percentage_old_customer_rev,
round((count_order_new_customer/ count_order)*100,2) || '%' as percentage_new_customer_order,
round((count_order_old_customer/ count_order)*100,2) || '%' as percentage_old_customer_order
from customer_revenue)
Select *,
round(revenue/count_order,2) as AOV,
round(new_customer_revenue/ count_order_new_customer,2)  as AOV_new_customer,
round(old_customer_revenue/ count_order_old_customer,2) as AOV_old_customer
from customer_contribution

