
# 1. Situation
This project aims to analyze customer behavior using the RFM (Recency, Frequency, Monetary) model to segment customers and understand their purchasing patterns. The RFM model helps in identifying valuable customer segments, developing targeted marketing strategies, and improving customer retention.

# 2. Objectives
The objectives of this project are:

1. To segment customers based on their recency, frequency, and monetary value.
2. To identify the most valuable customer segments.
3. To identify strategies for targeted marketing and customer retentions.

# 3. Results
1. Created an RFM segmentation model to categorize customers into different segments.
2. Identified high-value customer segments with high recency, frequency, and monetary scores.
3. Identified targeted marketing strategies to improve customer engagement and retention.

# 4. Insights
Suggest recommendation for marketing team to target customers in campaign
The potential customer segments for the company's marketing campaign are as follows:

1. Potential Loyalist: This customer segment represents the largest portion of customers (14.9%), consisting of 118 customers who made their most recent purchases within 45 days (ranked 5th). Although they contribute a relatively small revenue of $1,345.49, the marketing team should consider implementing cross-selling strategies for this customer segment.

2. Champion: The second-largest customer segment (13.1%) includes 104 customers who made their most recent purchases within 27 days (ranked 2nd). They contribute the highest average revenue of $4,435.91. This segment consists of customers who make frequent purchases, so there should be priority customer care programs for this segment, such as product discounts.

3. Loyal: This customer segment has a relatively low proportion (8.6%) with an average purchase frequency of 7.7 days, but they contribute the second-highest revenue of $3,948.21. To further assess the products for this segment, conducting product evaluation surveys is recommended in order to create suitable cross-selling and up-selling programs.

4. Cannot Lose Them: This customer segment has the lowest proportion (4.7%), but they have a higher purchase frequency than the "Loyal" segment (4.78 > 7.75). However, these customers made transactions 265 days ago. Therefore, new campaign strategies based on rewards, discounts, and special incentives for this customer group can be planned to attract and retain them. These strategies could be designed to make them feel special and appealing, ultimately encouraging their loyalty.

# 5. Steps for RFM Analysis

***1. Import necessary library

***2. Exploratory Data Analysis:

Overvỉew the data:Taking an overview of the data types, the number of columns, and the number of data rows to see if there is a need to change data types to align with the analysis, is it necessary?

Detect and solve missing values: Check if there are any missing values in the data, and determine whether these missing values impact the analysis results or not.

Detect and solve outlier values: Check if there are any outlier values in the data and assess whether these outlier values impact the analysis results or not.

3. Preparing data for RFM Analysis

4. Calculate RFM metric

Recency: For each customer group, when was the most recent purchase made?

Frequency: What is the frequency of purchases for each customer group?

Monetary: How much revenue does each customer group generate?

5. Customer segmentation base on RFM score

Grouping customers based on RFM scores:

Champions:The customers who have made the most recent purchases, most frequent purchases, and spent the most.

Loyal customers: Frequent buyers who are often interested in promotional campaigns.

Potential loyalist: Customers who have recent activity with average frequency.

New/Recent customers: Most recent buyers but not frequent shoppers.

Promising: Those who have shopped recently but haven't spent much.

Needs attention: The value of the most recent purchase, frequency, and monetary value are around average. It's possible that they haven't made a purchase very recently.

About to sleep: Frequency and recent frequency are below average. These customers might churn if there are no actions to re-engage them.

At risk: Customers who haven't made a purchase in a long time and need to be encouraged to start shopping again.

Can’t lose them: Frequent buyers who haven't returned for a while.

Hibernating: Last purchase was a long time ago, and the number of orders is low. They may be at risk of churn.

Lost: Customers who have already churned/left us.

6. RFM Analysis and Customer segmentation visualization

7. Suggest recommendation for marketing team to target customers in campaign

[RFM analysis code]()

