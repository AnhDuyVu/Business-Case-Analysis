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
- [1. How many pizzas were ordered?]

- [2. How many unique customer orders were made?]

- [3. How many successful orders were delivered by each runner?]

- [4. How many of each type of pizza was delivered?]

- [5. How many Vegetarian and Meatlovers were ordered by each customer?]

- [6. What was the maximum number of pizzas delivered in a single order?]

- [7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?]

- [8. How many pizzas were delivered that had both exclusions and extras?]

- [9. What was the total volume of pizzas ordered for each hour of the day?]

- [10. What was the volume of orders for each day of the week?]

### 1. How many pizzas were ordered?





