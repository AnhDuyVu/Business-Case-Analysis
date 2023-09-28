![image](https://github.com/AnhDuyVu/Data-Analysis-Projects/assets/119872105/54048600-a0c5-4372-953b-90b6b5d7fbf8)

## Table of Contents
- [Problem Statement](#Problem-Statement)
- [Entity Relationship Diagram](#Entity-Relationship-Diagram)
- [Data Cleaning and Transformation](#data-cleaning-and-transformation)
- [Questions and my solutions](#questions-and-my-solutions)

All source data is in link: [here](https://8weeksqlchallenge.com/case-study-2/)

# Problem Statement

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire - so he had one more genius idea to combine with it - he was going to Uberize it - and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

He has prepared for us an entity relationship diagram of his database design but requires further assistance to clean his data and apply some basic calculations so he can better direct his runners and optimise Pizza Runner’s operations.

# Entity Relationship Diagram

![image](https://github.com/AnhDuyVu/Data-Analysis-Projects/assets/119872105/dae30cd3-c4f5-4c28-afce-b3f9588162bc)


# Data Cleaning and Transformation

Because the data has Null and uncorect format type so I need to do data cleaning and transformation before using SQL to extract data to answer questions.

## 1. Table: Customer Order

I create temp table name 'customer_orders_temp' to replace null value with blank value

````sql

CREATE TEMP TABLE customer_orders_temp AS
SELECT 
  order_id, 
  customer_id, 
  pizza_id, 
  CASE
	  WHEN exclusions IS null OR exclusions LIKE 'null' THEN ''
	  ELSE exclusions
	  END AS exclusions,
  CASE
	  WHEN extras IS NULL or extras LIKE 'null' THEN ''
	  ELSE extras
	  END AS extras,
	order_time
FROM pizza_runner.customer_orders;

````
## 2. Table: runner_orders

I create temp table name 'runner_orders_temp' to replace null value with blank value and remove uneccesary charaters from data.

````sql
CREATE TEMP TABLE runner_orders_temp AS
SELECT 
  order_id, 
  runner_id,  
  CASE
	  WHEN pickup_time LIKE 'null' THEN ''
	  ELSE pickup_time
	  END AS pickup_time,
  CASE
	  WHEN distance LIKE 'null' THEN ''
	  WHEN distance LIKE '%km' THEN TRIM('km' from distance)
	  ELSE distance 
    END AS distance,
  CASE
	  WHEN duration LIKE 'null' THEN ''
	  WHEN duration LIKE '%mins' THEN TRIM('mins' from duration) 
	  WHEN duration LIKE '%minute' THEN TRIM('minute' from duration) 
	  WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration) 
	  ELSE duration
	  END AS duration,
  CASE
	  WHEN cancellation IS NULL or cancellation LIKE 'null' THEN ''
	  ELSE cancellation
	  END AS cancellation
FROM pizza_runner.runner_orders;

````
Other tables I keep the same schema.

# Questions and my solutions
## A. Pizza Metrics
- [1. How many pizzas were ordered?](#1-how-many-pizzas-were-ordered)

- [2. How many unique customer orders were made?](#2-how-many-unique-customer-orders-were-made)

- [3. How many successful orders were delivered by each runner?](#3-how-many-successful-orders-were-delivered-by-each-runner)

- [4. How many of each type of pizza was delivered?](#4-how-many-of-each-type-of-pizza-was-delivered)

- [5. How many Vegetarian and Meatlovers were ordered by each customer?](#5-how-many-vegetarian-and-meatlovers-were-ordered-by-each-customer)

- [6. What was the maximum number of pizzas delivered in a single order?](#6-what-was-the-maximum-number-of-pizzas-delivered-in-a-single-order)

- [7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?](#7-for-each-customer-how-many-delivered-pizzas-had-at-least-1-change-and-how-many-had-no-changes)

- [8. How many pizzas were delivered that had both exclusions and extras?](#8-how-many-pizzas-were-delivered-that-had-both-exclusions-and-extras)

- [9. What was the total volume of pizzas ordered for each hour of the day?](#9-what-was-the-total-volume-of-pizzas-ordered-for-each-hour-of-the-day)

- [10. What was the volume of orders for each day of the week?]

### 1. How many pizzas were ordered?

````sql
Select count(pizza_id) as number_pizzas_ordered
from customer_orders_temp;
````
#### Steps:
1. From table customer_orders_temp select count number of pizza_id to answer how many pizzas were ordered.

#### Results:

| number_pizzas_ordered |
| --------------------- |
| 14                    |

There are 14 pizzas were ordered.

### 2. How many unique customer orders were made?

````sql
Select count(distinct order_id) as number_unique_customer_orders
from customer_orders_temp;
````
#### Steps:
1. From table customer_orders_temp count distinct number of order_id to answer how many unique customer orders were made.

#### Results:
| number_unique_customer_orders |
| ----------------------------- |
| 10                            |

There are 10 unique customer orders were made.

### 3. How many successful orders were delivered by each runner?
````sql
Select runner.runner_id,
       count(distinct orders.order_id) as successful_orders
from customer_orders_temp as orders
inner join runner_orders_temp as runner on orders.order_id = runner.order_id
where runner.cancellation not like '%Cancellation'
group by runner.runner_id;
````
#### Steps:
1. Merge table customer_orders_temp with runner_orders_temp on order_id to get the data of runner_id and cancellation
2. Filter the orders not have cancellation in delivery.
3. Group by runner_id to count distinct order_id to answer how many successful orders were delivered by each runner.

#### Results: 
| runner_id | successful_orders |
| --------- | ----------------- |
| 1         | 4                 |
| 2         | 3                 |
| 3         | 1                 |

Runner_id 1 has delivered successfull 4 orders.

Runner_id 2 has delivered successfull 3 orders.

Runner_id 3 has delivered successfull 1 orders.

### 4. How many of each type of pizza was delivered?
````sql
Select pizza_names.pizza_name,
       count(orders.pizza_id) as successful_orders
from customer_orders_temp as orders
inner join runner_orders_temp as runner on orders.order_id = runner.order_id
inner join pizza_runner.pizza_names as pizza_names on orders.pizza_id = pizza_names.pizza_id
where runner.cancellation not like '%Cancellation'
group by pizza_names.pizza_name;
````
#### Steps:
1. Merge table customer_orders_temp with runner_orders_temp on order_id to get the data of cancellation
2. Merge table customer_orders_temp with pizza_names to get the data of pizza_name
3. Filter the orders not have cancellation in delivery.
4. Group by pizza_name to count pizza_id to answer How many of each type of pizza was delivered.

#### Results: 
| pizza_name | successful_orders |
| ---------- | ----------------- |
| Meatlovers | 9                 |
| Vegetarian | 3                 |

Meatlovers was ordered 9.

Vegetarian was ordered 3.

### 5. How many Vegetarian and Meatlovers were ordered by each customer?
````sql
Select orders.customer_id,
       pizza_name,
       count(pizza_name)  as orders_count
from customer_orders_temp as orders
inner join pizza_runner.pizza_names using(pizza_id)
group by orders.customer_id,pizza_name
order by orders.customer_id asc;
````
#### Steps:
1. Merge table customer_orders_temp with pizza_names on pizza_id to get the data of pizza_name
2. Group by orders.customer_id,pizza_name to count pizza_name to get answer how many Vegetarian and Meatlovers were ordered by each customer.

#### Results: 
| customer_id | pizza_name | orders_count |
| ----------- | ---------- | ------------ |
| 101	      | Meatlovers | 2            |
| 101 	      | Vegetarian | 1            |
| 102         |	Meatlovers | 2            |
| 102         |	Vegetarian | 1            |
| 103 	      | Meatlovers | 3            |
| 103 	      | Vegetarian | 1            |
| 104         | Meatlovers | 3            |
| 105	      | Vegetarian | 1            |

### 6. What was the maximum number of pizzas delivered in a single order?
````sql
with count_pizza_delivered as (
       Select orders.order_id,
       count(pizza_id) as count_pizza_delivered
       from customer_orders_temp as orders
       inner join runner_orders_temp as runner on orders.order_id = runner.order_id
       where runner.cancellation not like '%Cancellation'
       group by orders.order_id)
Select max(count_pizza_delivered) as max_pizza_delivered_single_order  
from count_pizza_delivered;
````
#### Steps:
1. Merge table customer_orders_temp with runner_orders_temp on order_id to get the data of cancellation
2. Filter the orders not have cancellation in delivery.
3. Group by order_id to count pizza_id to get how many pizza delivered for each order
4. Create a CTE table name 'count_pizza_delivered'
5. From count_pizza_delivered filter maximum value of count_pizza_delivered column to answer what was the maximum number of pizzas delivered in a single order.

#### Results:
| max_pizza_delivered_single_order |
| 3                                |

the maximum number of pizzas delivered in a single order was 3 pizzas.

### 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
````sql
Select orders.customer_id,
     sum(case when exclusions <>'' or extras <> '' then 1
         else 0 end) as at_least_1_change,
     sum(case when exclusions ='' and extras = '' then 1
         else 0 end) as no_change
from customer_orders_temp as orders
group by orders.customer_id
order by orders.customer_id asc;
````
#### Steps:
1. Group by custoner_id to calculate sum to sum all pizza have exclusions or extras by each customer to get at least 1 change in pizza topping
2. Group by custoner_id to calculate sum to sum all pizza no have exclusions and extras by each customer to get no change in pizza topping
3. Order by customer_id to answer for each customer, how many delivered pizzas had at least 1 change and how many had no changes.

#### Results:
| customer_id | at_least_1_change | no_change |
| ----------- | ----------------- | --------- |
| 101         |	0  	          | 3         |
| 102	      | 0	          | 3         |
| 103         | 4	          | 0         |
| 104	      | 2	          | 1         |
| 105	      | 1	          | 0         |

### 8. How many pizzas were delivered that had both exclusions and extras?
````sql
Select sum(case when exclusions <>'' and extras <> '' then 1
         else 0 end) as pizza_deivered_both_exclusion_and_extras_count
from customer_orders_temp as orders
inner join runner_orders_temp as runner on orders.order_id = runner.order_id
where runner.cancellation not like '%Cancellation';
````
#### Steps:
1. Merge table customer_orders_temp with runner_orders_temp to get the data of cancellation
2. Filter the orders not have cancellation in delivery.
3. Calculate sum to sum all pizza have both exclusions and extras by each customer to answer how many pizzas were delivered that had both exclusions and extras.

#### Results:
| pizza_deivered_both_exclusion_and_extras_count |
| ---------------------------------------------- |
| 1                                              |
Just 1 pizza was delivered that had both exclusions and extras.

### 9. What was the total volume of pizzas ordered for each hour of the day?
````sql
with hour_of_day_ordered as (
     Select *,
     extract(hour from order_time) as hour_of_day
     from customer_orders_temp)
Select hour_of_day,
       count(order_id) as total_volume_pizza_ordered_each_hour
from hour_of_day_ordered
group by hour_of_day
order by hour_of_day asc;
````
#### Steps:
1. Extract hour from order_time of customer_orders_temp to get hour information.
2. Create a CTE name 'hour_of_day_ordered'
3. From 'hour_of_day_ordered' table, group by hour_of_day to count the number of order each hour of day to answer what was the total volume of pizzas ordered for each hour of the day
4. Order by hour_of_day ascending order.

#### Results:
| hour_of_day | total_volume_pizza_ordered_each_hour |
| ----------- | ------------------------------------ |
| 11          |	1                                    |
| 13          | 3                                    |
| 18  	      | 3                                    |
| 19	      | 1                                    |
| 21	      | 3                                    |
| 23	      | 3                                    |

Busy hour with highest pizzas ordered was 13:00, 18:00, 21:00, and 23:00 with 3 pizzas ordered at those time.

### 10. What was the volume of orders for each day of the week?
````sql
with order_time_timestamp as (Select *,
     cast(order_time as timestamp) as order_time_timestamp
     from customer_orders_temp)
Select TO_CHAR(order_time_timestamp + INTERVAL '2 days', 'Day') AS day_of_week, 
       COUNT(order_id) AS total_pizza_ordered
FROM order_time_timestamp
GROUP BY TO_CHAR(order_time_timestamp + INTERVAL '2 days', 'Day')
order by total_pizza_ordered desc;

#### Steps:
1. Change format type of order_time from varchar to timestamp with cast() function.
2. Create a CTE name 'order_time_timestamp'
3. Change display of order_time_timestamp to day of week with to_char() function
4. group by day of week to count the number of order for each day of the week.
5 order by total_pizza_ordered descending order.

#### Results:
| day_of_week | total_pizza_ordered |
| ----------- | ------------------- |
| Monday      | 5                   |
| Friday      | 5                   |
| Saturday    | 3                   |
| Sunday      | 1                   |

Monday and Friday are the highest day for orders of the week with 5 orders.

 
















