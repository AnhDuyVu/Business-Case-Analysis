# Business Case
## 1. Introduction

The company would like to know the behaviour of purchase from customer after 2 years 2010, 2011 running business to evaluate business performance as well as promote sale strategies in the future. This project was undertaken to analyze user behavior over time by grouping them into cohorts based on their signup dates. Cohort Analysis helps identify trends, evaluate the effectiveness of marketing campaigns, and develop strategies to improve user experience and retention.

## 2. Objectives

The objectives of this project are:

1. To analyze user groups based on their signup dates.
2. To evaluate user retention rates over different time periods.
3. To identify factors affecting user retention.

## 3. Insights:
Customer purchase behavior at an online shop in 2010 and 2011

# About Dataset

**Source:**
Dr Daqing Chen, Director: Public Analytics group. chend '@' lsbu.ac.uk, School of Engineering, London South Bank University, London SE1 0AA, UK.

**Data Set Information:**
This is a transnational data set which contains all the transactions occurring between 01/12/2010 and 09/12/2011 for a UK-based and registered non-store online retail.The company mainly sells unique all-occasion gifts. Many customers of the company are wholesalers.

**Attribute Information:**
InvoiceNo: Invoice number. Nominal, a 6-digit integral number uniquely assigned to each transaction. If this code starts with letter 'c', it indicates a cancellation.
StockCode: Product (item) code. Nominal, a 5-digit integral number uniquely assigned to each distinct product.
Description: Product (item) name. Nominal.
Quantity: The quantities of each product (item) per transaction. Numeric.
InvoiceDate: Invice Date and time. Numeric, the day and time when each transaction was generated.
UnitPrice: Unit price. Numeric, Product price per unit in sterling.
CustomerID: Customer number. Nominal, a 5-digit integral number uniquely assigned to each customer.
Country: Country name. Nominal, the name of the country where each customer resides.

**Relevant Papers:**
The evolution of direct, data and digital marketing, Richard Webber, Journal of Direct, Data and Digital Marketing Practice (2013) 14, 291â€“309.
Clustering Experiments on Big Transaction Data for Market Segmentation,
Ashishkumar Singh, Grace Rumantir, Annie South, Blair Bethwaite, Proceedings of the 2014 International Conference on Big Data Science and Computing.
A decision-making framework for precision marketing, Zhen You, Yain-Whar Si, Defu Zhang, XiangXiang Zeng, Stephen C.H. Leung c, Tao Li, Expert Systems with Applications, 42 (2015) 3357â€“3367.

**Citation Request:**
Daqing Chen, Sai Liang Sain, and Kun Guo, Data mining for the online retail industry: A case study of RFM model-based customer segmentation using data mining, Journal of Database Marketing and Customer Strategy Management, Vol. 19, No. 3, pp. 197â€“208, 2012 (Published online before print: 27 August 2012. doi: 10.1057/dbm.2012.17).



# Data Analysis 
**1. Exploratory Data Analysis**

**2. Build Customer Cohort**

**3. Build Retention Cohort**

**4. Build Churn Cohort**

**5. Build Revenue Cohort**

**6. Calculate AOV Rate**

**7. Insights from analysis**
# SQL Code in BigQuerry

[SQL Code](https://github.com/AnhDuyVu/Business-Case-Analysis/blob/main/SQL%20Project/SQL%20code.sql)

# Result
## 1. Customer Cohort
![Customer Cohort](https://github.com/AnhDuyVu/Business-Case-Analysis/blob/main/SQL%20Project/1.%20Customer_Cohort_picture.png)

## 2. Retention Cohort
![Retention Cohort](https://github.com/AnhDuyVu/Business-Case-Analysis/blob/main/SQL%20Project/2.%20Retention_Cohort_picture.png)

## 3. Churn Cohort
![Churn Cohort](https://github.com/AnhDuyVu/Business-Case-Analysis/blob/main/SQL%20Project/3.%20Churn_Cohort_picture.png)

## 4. Revenue Cohort

![Revenue Cohort](https://github.com/AnhDuyVu/Business-Case-Analysis/blob/main/SQL%20Project/4.%20Revenue_Cohort_picture.png)

## 5. AOV table
![AOV table](https://github.com/AnhDuyVu/Business-Case-Analysis/blob/main/SQL%20Project/AOV_table_1.png)
![AOV table 2](https://github.com/AnhDuyVu/Business-Case-Analysis/blob/main/SQL%20Project/AOV_table_2.png)

# 6. Insights from analysis

Analyzing customer purchasing behavior with an online retail shop in the years 2010 and 2011:

**Horizontal Analysis:**

1. From January to October 2010, customers hardly return to make purchases immediately after their first purchase (the rate of returning in the second month after the first month is very low, 0-6%).

2. During this period, as the company is newly established, the market reach might be low, leading to mostly new customers who tend to make a one-time purchase to experience the product.
Starting from December 2010, there are returning customers in the second month after their first purchase (in January 2011, 33% of December 2010 customers return to make a purchase).

3. The months of June, July, and November after the first purchase fall within the summer period (May-July) and the year-end holiday season (November-December), where the number of returning customers increases significantly. For instance, in June following October 2010, the returning customer rate increases by 7% from 33% to 40%, contributing to 63% revenue compared to October 2010. In July following December 2010, the returning customer rate increases by 6% from 30% to 36%, contributing to 76% revenue compared to December 2010. During the year-end in December following October 2010, the returning customer rate increases by 12% from 23% to 35%, contributing to 81% revenue compared to October 2010, and in December following December 2010, the returning customer rate increases by 10% from 29% to 39%, contributing to 81% revenue compared to December 2010.

**Vertical Analysis:**

1. From January to October 2010, the number of new customers fluctuates each month, with both increases and decreases. By October 2010, the number of customers decreases, with only 40 new customers compared to 95 in January 2010, a decrease of 55 customers.

2. At the end of 2010, the number of new customers increases dramatically from 270 in December 2010 to 543 new customers in January 2011.

3. In 2011, the number of new customers sharply decreases by December 2011, with only 31 new customers compared to 543 at the beginning of 2011, a decrease of 512 customers.

**Trends in customer purchasing:**

Existing customers tend to order a large quantity but with low order values, while new customers tend to order high-value items.

Through cohort analysis, it is evident that the current business situation is not favorable, with a downward trend in returning customer rates. The company needs to focus on peak seasons, namely May to July and the year-end months of November and December. Additionally:

For existing customers: Implement promotions, bundling high-value items to increase the Average Order Value (AOV) per order, thus generating more profit for the company. Also, prioritize loyalty programs and rewards to enhance the returning customer rate.
For new customers: Launch attractive promotions for low-value items, offer discounts for first-time purchases, and improve customer care quality to retain their interest in making future purchases on the website.

