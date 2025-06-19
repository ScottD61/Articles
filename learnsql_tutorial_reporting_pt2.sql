-- Code for the LearnSQL.com Data Analyst Study Guide walkthrough Pt.2
-- Data: Tableau Superstore - Orders
-- Language: MySQL on MySQL Workbench

/*
Content:
Analyzing Customers
	-Customers
    -Orders
    -Segmentation

Analyzing Products
	-Product Reports
    -Case Question
*/

/*
Analyzing Customers
Easy
*/

/*
How many customers are there and by time period?
*/

-- SELECT
-- 	EXTRACT(YEAR FROM DATE(STR_TO_DATE(order_date, '%m/%d/%Y'))) AS order_Year,
-- 	EXTRACT(MONTH FROM DATE(STR_TO_DATE(order_date, '%m/%d/%Y'))) AS order_Month,
-- 	COUNT(DISTINCT(Customer_ID)) AS active_customers
-- FROM `Tableau Superstore`.orders
-- GROUP BY 
-- 	1, 2
-- ORDER BY 
-- 	1, 2


/*
Create a report of customer-based finance metrics per product category and sub category:
-Average Revenue Per User (ARPU)
-Average Profit Per User (APPU)
*/

-- SELECT
-- 	  Category,
--       Sub_Category,
--       ROUND(SUM(Sales) / COUNT(DISTINCT `Customer_ID`), 1) AS ARPU,
--       ROUND(SUM(Profit) / COUNT(DISTINCT `Customer_ID`), 1) AS APPU,
-- FROM 
--     `Tableau Superstore`.orders
-- GROUP BY
-- 	1, 2
-- ORDER BY 
-- 	1, 2

/*
Orders
*/

/*
Create a report of order-based finance metrics
-- Average Quantity Per User (AQPU)
-- Average Order Value (AOV)
*/

-- SELECT
-- 	ROUND(SUM(Quantity) / COUNT(DISTINCT `Customer_ID`), 1) AS AQPU,
-- 	ROUND(SUM(Sales)/COUNT(order_id), 2) as average_order_value
-- FROM 
--     `Tableau Superstore`.orders;

/*
Medium
*/