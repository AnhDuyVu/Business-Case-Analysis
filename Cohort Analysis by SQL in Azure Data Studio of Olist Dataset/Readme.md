# Olist dataset Overview
Welcome! This is a Brazilian ecommerce public dataset of orders made at Olist Store. The dataset has information of 100k orders from 2016 to 2018 made at multiple marketplaces in Brazil. Its features allows viewing an order from multiple dimensions: from order status, price, payment and freight performance to customer location, product attributes and finally reviews written by customers. We also released a geolocation dataset that relates Brazilian zip codes to lat/lng coordinates.

This is real commercial data, it has been anonymised, and references to the companies and partners in the review text have been replaced with the names of Game of Thrones great houses.

# Context
This dataset was generously provided by Olist, the largest department store in Brazilian marketplaces. Olist connects small businesses from all over Brazil to channels without hassle and with a single contract. Those merchants are able to sell their products through the Olist Store and ship them directly to the customers using Olist logistics partners. See more on our website: www.olist.com

After a customer purchases the product from Olist Store a seller gets notified to fulfill that order. Once the customer receives the product, or the estimated delivery date is due, the customer gets a satisfaction survey by email where he can give a note for the purchase experience and write down some comments.


# Attention
1. An order might have multiple items.
2. Each item might be fulfilled by a distinct seller.
3. All text identifying stores and partners where replaced by the names of Game of Thrones great houses.

# Dataset explorer
1. Olist_customer_dataset: dataset of customer information
2. Olist_geolocation_dataset: dataset of geolocation city
3. Olist_order_items_dataset: dataset of order items information
4. Olist_order_payments_datatet: dataset of order payment information
5. Olist_order_reviews_datatet: dataset of order review information
6. Olist_order_datatet: dataset of order detail information
7. Olist_products_datatet: dataset of product detail information
8. Olist_sellers_dataset: dataset of seller detail information
9. Olist_product_category_name: dataset of translate product_category_name into English.

# Cohort Analysis

What is cohort Analysis:

Cohort analysis is a useful way to compare groups of entities over time. Many important behaviors take weeks, months, or years to occur or evolve, and cohort analysis is a way to understand these changes. Cohort analysis provides a framework for detecting correlations between cohort characteristics and these long-term trends, which can lead to hypotheses about the causal drivers. For example, customers acquired through a marketing campaign may have different long-term purchase patterns than those who were persuaded by a friend to try a company’s products. Cohort analysis can be used to monitor new cohorts of users or customers and assess how they compare to previous cohorts.
Cohort analysis help us have an overview of customer retention after a specifict period of time to have further customer behaviour analysis to make action plans to attract more cusstomers.

# Cohort Analysis context
The Olist platform connects small business sellers in Brazil with customers, these sellers will sell their products on Olist platform, so understanding wether sellers come back to the Olist platform is a important question for Olist company.
I wwill work with Olist public dataset in Kaggle, using Olist_order_items_dataset.csv and Olist_order_datatet to do cohort analysis of sellers in 2017 to see the retention rate of sellers and suggest recommendations.



