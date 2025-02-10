#Revenue Keymetrics
#business total revenue, average oder value, total unique customer and total number of transaction.

SELECT 
Count(transactionid) as total_trasncation,
ROUND(SUM(transactionamount),2) as total_revenue,
ROUND(AVG(transactionamount),2) as AOV
from Sales_Data;

#total sales, feedback score and total return by store type

SELECT StoreType, round(AVG(FeedbackScore),3) as avg_feedback,
COUNT(CASE WHEN Returned = 'Yes' THEN 1 END) as returns,
COUNT(*) as total_transactions
FROM Sales_Data
GROUP BY 1;


#Top 5 city by Sales

SELECT SUM(transactionamount) as total_sales, city
from Sales_Data
group by city
order by total_sales desc
limit 5


#Average delivery cost and average time to delivery a product for online orders

SELECT 
ROUND(AVG(DeliveryTimeDays),2) as avg_delivery_time,
ROUND(AVG(ShippingCost),2) as avg_shipping_cost,
StoreType
FROM Sales_Data
WHERE StoreType = 'Online'
GROUP BY storetype;

#Customer Analysis
#Total number of customers, unique customer, repeat customer and repeat rate 

With customers AS(
SELECT 
COUNT(DISTINCT customerid) as unique_customer,
COUNT(customerid) as total_customer
from Sales_Data)

Select *, total_customer - unique_customer as repeat_customer,
((total_customer - unique_customer)*100/total_customer) as repeat_rate
from customers;


#Customer Segment Analysis 

Select AgeGroup, COUNT(DISTINCT CustomerID) AS customer_total
FROM (
    SELECT CustomerID, 
           CASE 
               WHEN CustomerAge BETWEEN 13 AND 28 THEN 'Gen Z'
               WHEN CustomerAge BETWEEN 29 AND 44 THEN 'Millenials'
               WHEN CustomerAge BETWEEN 45 AND 60 THEN 'Gen X'
               ELSE 'Boomer II'
           END AS AgeGroup
    FROM sales_data) AS AgeSegments
GROUP BY AgeGroup
ORDER BY AgeGroup;



#Average Spend by Gender

SELECT customergender, avg(transactionamount) as average_spend
from Sales_Data
GROUP by customergender;

#payment method used by customer

SELECT PaymentMethod, COUNT(*) as usage_count, 
AVG(TransactionAmount) as avg_transaction_value
FROM Sales_Data
GROUP BY paymentmethod
ORDER by usage_count DESC;


#top 10 customer with highest loyalty point 
SELECT sum(loyaltypoints) as total_loyalty_pts, customerid
from Sales_Data
GROUP by customerid
order by total_loyalty_pts desc
limit 10;


#product performance

# Contribution to revenue bytop 2 product 

SELECT 
  productname AS product_name, 
  ROUND(((SUM(transactionamount) / (SELECT SUM(transactionamount) FROM Sales_Data)) * 100),2) AS revenue_contribution
FROM Sales_Data
GROUP BY productname
ORDER BY revenue_contribution DESC
limit 2;



#Total product sold in each product category sort by highest selling products to lowest

SELECT productname, SUM(quantity) as total_product_sold
from Sales_Data
group by productname



