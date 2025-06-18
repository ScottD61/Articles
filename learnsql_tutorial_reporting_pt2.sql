-- Code for the LearnSQL.com Data Analyst Study Guide walkthrough Pt.2
-- Data: Tableau Superstore - Orders
-- Language: MySQL on MySQL Workbench


/*
Content:
Analyzing Customers
	-Finance Metrics
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
Create a report of customer-based finance metrics
TO WRITE
*/


