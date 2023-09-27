![image](https://github.com/AnhDuyVu/Data-Analysis-Projects/assets/119872105/4ffc02fb-0375-47d0-9146-69fbf9beab3f)

## Table of Contents
- [Problem Statement](#Problem-Statement)
- [Entity Relationship Diagram](#Entity-Relationship-Diagram)
- [Questions and my solutions](#questions-and-my-solutions)

All source data is in link: [here](https://8weeksqlchallenge.com/case-study-1/). 

# Problem Statement

Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.


Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.


Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.


Danny has provided us with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for us to write fully functioning SQL queries to help him answer his questions.

# Entity Relationship Diagram  
![image](https://github.com/AnhDuyVu/Data-Analysis-Projects/assets/119872105/b542d482-5671-4c6d-97c7-117eb769bd9d)

# Questions and my solution
- [1. What is the total amount each customer spent at the restaurant?](#1-what-is-the-total-amount-each-customer-spent-at-the-restaurant)
- [2. How many days has each customer visited the restaurant?](#2-how-many-days-has-each-customer-visited-the-restaurant)

# **1. What is the total amount each customer spent at the restaurant?**

````sql

Select sales.customer_id,
       sum(price) as total_spent
from dannys_diner.sales as sales
join dannys_diner.menu as menu on sales.product_id = menu.product_id
group by sales.customer_id
order by sales.customer_id asc;

````
## Steps:

1. Use join to merge dannys_diner.sales with dannys_diner.menu on product_id to get the price of dishes on dannys_diner.menu table.
2. Group sales.customer_id to calculate sum of price by customer_id to get total amount each customer spent at the restaurant.
3. Order by sales.customer_id to display the data ascending by customer_id

## Results:
| customer_id | total_sales |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |

Customer A spent 76$ at the restaurant


Customer B spent 74$ at the restaurant


Customer C spent 36$ at the restaurant

# **2. How many days has each customer visited the restaurant?**

````sql

Select sales.customer_id,
       count(distinct order_date) as number_day_customer_visited
       from dannys_diner.sales
       group by sales.customer_id
       order by sales.customer_id asc;

````
## Steps:

1. Group sales.customer_id to calculate count distinct order date by customer_id to get total days each customer visited the restaurant.
   
2. Order by sales.customer_id to display the data ascending by customer_id.

## Results:
| customer_id	| number_day_customer_visited |
| ----------- | --------------------------- |
|A            | 4                           |
|B	       | 6                           |
|C            | 2                           |

Customer A has visỉted the restaurant 4 days

Customer B has visỉted the restaurant 6 days

Customer C has visỉted the restaurant 2 days

**3. What was the first item from the menu purchased by each customer?**

````sql

with order_date_rank as (
       Select customer_id,
       order_date,
       dense_rank() over(order by order_date asc) as order_date_rank,
       product_name
       from dannys_diner.sales as sales
       inner join dannys_diner.menu as menu on sales.product_id = menu.product_id
       order by customer_id asc, order_date_rank asc)
Select distinct customer_id,
	   product_name
from order_date_rank
where order_date_rank = 1;

````
## Steps:

1. Create a Common Table Expression (CTE) with name 'order_date_rank', create new column order_date_rank using dense_rank() to rank by the order_date ascending from the merge table between sales and menu.
   
2. From 'order_date_rank' CTE table, select distinct customer_id with filter order_date_rank = 1 to find the first item from the menu purchased by each customer.

## Results:

| customer_id	| product_name |
| ----------- | ------------ |
| A	       | curry        |
| A	       | sushi        |
| B	       | curry        |
| C	       | ramen        |

Customer A placed an order for both curry and sushi simultaneously, making them the first items in the order.

Customer B's first order is curry.

Customer C's first order is ramen.

**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

````sql

Select menu.product_name,
       sales.product_id,
       count(sales.product_id) as most_purchased_product
from dannys_diner.sales as sales
inner join dannys_diner.menu as menu on sales.product_id = menu.product_id
group by menu.product_name,sales.product_id
order by most_purchased_product desc limit 1;
Select menu.product_name,
       count(product_name) as total_time_purchased
from dannys_diner.sales as sales
inner join dannys_diner.menu as menu on sales.product_id = menu.product_id
group by menu.product_name
order by menu.product_name asc;

````
## Steps:

1. Write inner join dannys_diner.menu with dannys_diner.sales on product_id to get the product_name on menu table.
   
2. Group by menu.product_name, sales.product_id to calculate count product_id, finding the most purchased item on the menu by all customers.
 
3. group by menu.product_name to calculate count product_name, finding how many times the products were purchased by all customer.

## Results:

| product_name | product_id | most_purchased_product |
| ------------ | ---------- | ---------------------- |
| ramen        | 3	    | 8                      |

| product_name | total_time_purchased |
| ------------ | -------------------- |
| curry	       | 4                    |
| ramen	       | 8                    |
| sushi	       | 3                    |

 Most purchased item on the menu is ramen which is 8 times

 Total purchased for curry is 4 times

 Total purchased for ramen is 8 times

 Total purchased for sushi is 8 times

 **5. Which item was the most popular for each customer?**
 
 ````sql
with rank_item_purchased as (
       Select sales.customer_id,
       menu.product_name,
       dense_rank() over(partition by sales.customer_id order by count(product_name) asc) as rank_item_purchased
       from dannys_diner.sales as sales
       inner join dannys_diner.menu as menu on sales.product_id = menu.product_id
       group by sales.customer_id, menu.product_name
       order by customer_id asc, product_name asc)
Select customer_id,
	   product_name,
       rank_item_purchased
from rank_item_purchased
where rank_item_purchased = 1
order by customer_id asc, product_name asc;

 ````
## Steps:
1. Create a Common Table Expression (CTE) named `rank_item_purchased` to rank item_ purchased by each customer from merge table between sales and menu table on product_id.
2. From 'rank_item_purchased' table select customer_id and product_name with filter rank_item_purchased = 1 to filter the first rank in the product each customer bought.
3. Order by customer_id and product_name in ascending orders.

## Results:


| customer_id | product_name | rank_item_purchased |
| ----------- | ------------ | ------------------- |
| A           |	sushi        |	1                  |
| B           |	curry        | 	1                  |
| B           |	ramen        |	1                  |
| B           |	sushi        |	1                  |
| C           |	ramen        |	1                  |

Customer A's favourite item is sushi.

Customer C's favourite item is ramen.

Customer B's favourite are all items in the menu.

**6. Which item was purchased first by the customer after they became a member?**

 ````sql

with total_day_after_become_member as (
  	   Select sales.customer_id,
       menu.product_name,
       min(order_date - join_date) as min_total_day_after_become_member
       from dannys_diner.sales as sales
       inner join dannys_diner.menu as menu on sales.product_id = menu.product_id
       inner join dannys_diner.members as members on sales.customer_id = members.customer_id
       where (sales.order_date - members.join_date) >=0
       group by sales.customer_id, menu.product_name),
rank_purchase as (
       Select customer_id,
       product_name,
       dense_rank() over(partition by customer_id order by min_total_day_after_become_member asc) as rank_purchase
       from total_day_after_become_member
       group by customer_id, product_name, min_total_day_after_become_member)
Select customer_id, 
       product_name as first_purchase
from rank_purchase
where rank_purchase = 1;

````
## Steps:
1. Create a CTE name 'total_day_after_become_member' to add column min_total_day_after_become_member to merge table between sales, menu, and members table on product_id, customer_id.
2. From 'total_day_after_become_member' use dense_rank() function to rank by customer_id order by min_total_day_after_become_member ascending order.
3. Group customer_id, product_name to calculate rank_purchase
4. Create a CTE name 'rank_purchase' to add column 'rank_purchase' to the 'total_day_after_become_member' table
5. From rank_purchase, select customer_id, product_name where rank_purchase = 1 to filter the products was purchased first by the customer after they became a member.

## Results:
| customer_id | first_purchase |
| ----------- | -------------- |
| A	      | curry          |
| B	      | sushi          |

The first item bought by customer A after they became a member is curry
The first item bought by customer B after they became a member is sushi
The customer C is not a member of the restaurant so he/she does not have data of first buy.

**7. Which item was purchased just before the customer became a member?**

 ````sql
with total_day_before_become_member as (
  	   Select sales.customer_id,
       menu.product_name,
       min(join_date - order_date) as min_total_day_before_become_member
       from dannys_diner.sales as sales
       inner join dannys_diner.menu as menu on sales.product_id = menu.product_id
       inner join dannys_diner.members as members on sales.customer_id = members.customer_id
       where (sales.order_date - members.join_date) <0
       group by sales.customer_id, menu.product_name),
rank_purchase as (
       Select customer_id,
       product_name,
       rank() over(partition by customer_id order by min_total_day_before_become_member asc) as rank_purchase
       from total_day_before_become_member
       group by customer_id, product_name, min_total_day_before_become_member)
Select customer_id, 
       product_name as purchase_just_before_become_member
from rank_purchase
where rank_purchase = 1;

````

## Steps:

1. Create a CTE name 'total_day_before_become_member' to add column min_total_day_before_become_member to merge table between sales, menu, and members table on product_id, customer_id.
2. From 'total_day_before_become_member' use dense_rank() function to rank by customer_id order by min_total_day_before_become_member ascending order.
3. Group customer_id, product_name to calculate rank_purchase
4. Create a CTE name 'rank_purchase' to add column 'rank_purchase' to the 'total_day_before_become_member' table
5. From rank_purchase, select customer_id, product_name where rank_purchase = 1 to filter the products was purchased by the customer just before they became a member.

## Results:
| customer_id |	purchase_just_before_become_member |
| ----------- | ---------------------------------- |
| A	      | curry                              |
| A           |	sushi                              |
| B	      | sushi                              |

Customer A bought curry and sushi just before become member.

Customer B bought sushi just before become member.

Customer C is not a member of the restaurant, so that he/she does not have the data of purchased before become member.

# **8. What is the total items and amount spent for each member before they became a member?**

````sql

Select distinct sales.customer_id,
       count(sales.product_id) over(partition by sales.customer_id) as total_product,
       sum(menu.price) over(partition by sales.customer_id) as total_amount_spent
from   dannys_diner.sales as sales
inner  join dannys_diner.menu as menu on sales.product_id = menu.product_id
inner  join dannys_diner.members as members on sales.customer_id = members.customer_id
where  (sales.order_date - members.join_date) <0
order by sales.customer_id asc;

````
## Steps:

1. Merge table between sales, menu, members on product_id, customer_id to get the data of price, product_id
2. Filter with criteria order_date < join_date to get the data before the customer became a member.
3. Use window function to calculate count product_id partition by customer_id and sum price partition by customer_id to add new column total_product and total_amount_spent.
4. Select customer_id, total_product, total_amount_spent to get the total items and amount spent for each customer before they became a member.

## Results:

| customer_id | total_product |	total_amount_spent |
| ----------- | ------------- | ------------------ |
| A           |	2             |	25                 |
| B           |	3             |	40                 |

Before they became a member:

Customer A bought 2 products and spent 25$ at the restaurant.

Customer B bought 3 products and spent 40$ at the restaurant.

# **9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?**

````sql

with purchase_point as (
      Select *,
             case 
             when product_name = 'sushi' then price *10 *2
             else price*10
             end as purchase_point
      from dannys_diner.sales as sales
      inner join dannys_diner.menu as menu on sales.product_id = menu.product_id)
Select distinct customer_id,
       sum(purchase_point) over(partition by customer_id) as total_purchase_point
from purchase_point
order by customer_id asc;

````
## Steps:

1. Merge table between sales, menu on product_id to get the data of price, product_name
2. Use case when for sushi product to calculate purchase_point for each product
3. Create a CTE name 'purchase_point' to add purchase_point to merge table.
4. From 'purchase_point' table, select distinct customer_id, use window function calculate total_purchase_ point for each customer.

## Results:

| customer_id | total_purchase_point |
| ----------- | -------------------- |
| A           |	860                  |
| B           |	940                  |
| C           |	360                  |

Customer A had  860 purchase point.

Customer B had  940 purchase point.

Customer C had  360 purchase point.


















