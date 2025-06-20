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

/*
Who are the top 3 accounts/customers by profit margin, total profit, total sales, sales frequency?
*/

-- WITH customer_metrics AS (
-- 	SELECT 
-- 		customer_name, 
-- 		ROUND(SUM(Sales), 1) AS sales_total,
-- 		ROUND(SUM(Profit), 1) AS profit_total,
-- 		ROUND(SUM(Profit)/SUM(Sales), 1) as profit_margin,
-- 		COUNT(order_id) AS sales_frequency
-- 	FROM 
-- 		`Tableau Superstore`.orders
-- 	GROUP BY 
-- 		1
-- ),
-- ranked_customers AS (
--     SELECT 
--         customer_name, 
--         'Profit Margin' AS metric, 
--         profit_margin AS amount,
--         DENSE_RANK() OVER (ORDER BY profit_margin DESC) AS customer_rank
--     FROM 
--         customer_metrics

--     UNION ALL

--     SELECT 
--         customer_name, 
--         'Total Profit' AS metric, 
--         profit_total AS amount,
--         DENSE_RANK() OVER (ORDER BY profit_total DESC) AS customer_rank
--     FROM 
--         customer_metrics

--     UNION ALL

--     SELECT 
--         customer_name, 
--         'Total Sales' AS metric, 
--         sales_total AS amount,
--         DENSE_RANK() OVER (ORDER BY sales_total DESC) AS customer_rank
--     FROM 
--         customer_metrics

--     UNION ALL

--     SELECT 
--         customer_name, 
--         'Sales Frequency' AS metric, 
--         sales_frequency AS amount,
--         DENSE_RANK() OVER (ORDER BY sales_frequency DESC) AS customer_rank
--     FROM 
--         customer_metrics
-- )
-- SELECT 
--     customer_name, 
--     metric, 
--     amount,
--     customer_rank
-- FROM 
--     ranked_customers
-- WHERE 
--     customer_rank <= 3
-- ORDER BY 
--     2, 4

/*
Segmentation
*/

/*
Customer Segmentation: Find high-priority customers by customers with the most 
profit - highest profit margin, highest frequency. Use sales, profit, quantity sold, 
state, city, and region to make your best segmentation - ex. Low, Medium, High
*/

-- WITH customer_metrics AS (
--     SELECT 
-- 		customer_name, 
--  		ROUND(SUM(Sales), 1) AS sales_total,
-- 		ROUND(SUM(Profit), 1) AS profit_total,
-- 		ROUND(SUM(Profit)/SUM(Sales), 1) as profit_margin,
-- 		COUNT(order_id) AS sales_frequency
--     FROM 
--         `Tableau Superstore`.orders
--     GROUP BY 
--         1
-- ),
-- ranked_customers AS (
--     SELECT 
--         customer_name, 
--         sales_total, 
--         profit_total, 
-- 		profit_margin,
--         sales_frequency, 
--         PERCENT_RANK() OVER (ORDER BY profit_margin DESC) AS profit_rank,
--         PERCENT_RANK() OVER (ORDER BY sales_frequency DESC) AS frequency_rank
--     FROM 
--         customer_metrics
-- ),
-- segmented_customers AS (
-- 	SELECT 
-- 		customer_name, 
-- 		sales_total, 
-- 		profit_total, 
-- 		profit_margin,
-- 		sales_frequency,
-- 		CASE 
-- 			WHEN profit_rank <= 0.1 AND frequency_rank <= 0.1 THEN 'High Profit & High Frequency'
-- 			WHEN profit_rank <= 0.1 THEN 'High Profit'
-- 			WHEN frequency_rank <= 0.1 THEN 'High Frequency'
-- 			ELSE 'Low Profit & Low Frequency'
-- 		END AS customer_segment
-- 	FROM 
-- 		ranked_customers
-- )
-- SELECT 
--     customer_name, 
--     sales_total, 
--     profit_total, 
--     profit_margin,
--     sales_frequency,
--     customer_segment
-- FROM 
--     segmented_customers
-- WHERE 
--     customer_segment = 'High Profit & High Frequency'
-- ORDER BY 
--     3 DESC;

/*
Analyzing Products
Easy
/*

/*
How many different products are ordered and by time period?
*/

-- SELECT 
--     EXTRACT(YEAR FROM DATE(STR_TO_DATE(order_date, '%m/%d/%Y'))) AS order_Year,
--     EXTRACT(MONTH FROM DATE(STR_TO_DATE(order_date, '%m/%d/%Y'))) AS order_Month,
--     COUNT(DISTINCT product_id) AS unique_items
-- FROM 
--     `Tableau Superstore`.orders
-- GROUP BY 1, 2
-- ORDER BY 1, 2 DESC;

/*
Create a report of the sales, profit, and profit margin for each product with it's category and sub-category
*/

-- SELECT 
-- 	product_id,
--     Category,
--     Sub_Category,
-- 	ROUND(SUM(Sales), 1) AS sales_total,
-- 	ROUND(SUM(Profit), 1) AS profit_total,
-- 	ROUND(SUM(Profit)/SUM(Sales), 1) as profit_margin
-- FROM `Tableau Superstore`.orders
-- GROUP BY 1, 2, 3
-- ORDER BY 4 DESC;

/*
Hard
*/


/*
What are the 3 items with the lowest profit margin by location? This considers item-location combinations and if there are products 
with ties show them
*/

WITH product_metrics AS (
    SELECT 
        product_id, 
        state,
        city,
        ROUND(SUM(Sales), 1) AS sales_total,
        ROUND(SUM(Profit), 1) AS profit_total,
        ROUND(SUM(Profit)/SUM(Sales), 2) as profit_margin
    FROM 
        `Tableau Superstore`.orders
    GROUP BY 1, 2, 3
),
ranked_products AS (
    SELECT 
        product_id,
        state,
        city, 
        sales_total, 
        profit_total,
        profit_margin,
--         DENSE_RANK() OVER (ORDER BY sales_total ASC) AS sales_rank,
        DENSE_RANK() OVER (ORDER BY profit_margin ASC) AS profit_rank
    FROM 
        product_metrics
	WHERE profit_margin IS NOT NULL
)
SELECT 
    product_id,
    state,
    city,
    sales_total, 
    profit_margin,
--     sales_rank,
    profit_rank
FROM 
    ranked_products
WHERE 
    profit_rank <= 3
ORDER BY 5 ASC;