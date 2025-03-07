-- Code for the LearnSQL.com Data Analyst Study Guide walkthrough
-- Data: Tableau Superstore - Orders
-- Language: MySQL on MySQL Workbench

/*
Overall Trends
Easy
*/

/*
What is the total sales/profit/quantity sold/days to ship?
*/

-- SELECT 
--   ROUND(SUM(Sales), 0) AS sales_total,
--   ROUND(SUM(Profit), 0) AS profit_total,
--   ROUND(SUM(Quantity), 0) AS quantity_total
-- FROM `Tableau Superstore`.orders;

/*
What was the monthly/yearly sales/profit/quantity sold?
*/

-- SELECT 
-- EXTRACT(YEAR FROM DATE(STR_TO_DATE(order_date, '%m/%d/%Y'))) AS order_Year,
-- EXTRACT(MONTH FROM DATE(STR_TO_DATE(order_date, '%m/%d/%Y'))) AS order_Month,
--   ROUND(SUM(Sales), 0) AS sales_month,
--   ROUND(SUM(Profit), 0) AS profit_month,
--   ROUND(SUM(Quantity), 0) AS quantity_month
-- FROM `Tableau Superstore`.orders
-- GROUP BY 
--   1, 2
-- ORDER BY 
--   1, 2;

/*
What was the average sales/profit/quantity sold?
*/

-- SELECT 
--   ROUND(SUM(Sales), 0) AS sales_total,
--   ROUND(SUM(Profit), 0) AS profit_total,
--   ROUND(SUM(Quantity), 0) AS quantity_total
-- FROM `Tableau Superstore`.orders;

/*
medium
*/

/*
What is the moving average of sales by month?
*/

-- SELECT 
-- 	EXTRACT(YEAR FROM DATE(STR_TO_DATE(order_date, '%m/%d/%Y'))) AS order_Year,
--  	EXTRACT(MONTH FROM DATE(STR_TO_DATE(order_date, '%m/%d/%Y'))) AS order_Month,
-- 	ROUND(SUM(Sales), 0) AS sales_total,
-- 	ROUND(AVG(SUM(sales)) OVER(ORDER BY EXTRACT(MONTH FROM DATE(STR_TO_DATE(order_date, '%m/%d/%Y'))) ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
--     ), 0) AS moving_average
-- FROM `Tableau Superstore`.orders
-- GROUP BY 1, 2
-- ORDER BY 1, 2

/*hard*/

/*
What is the cumulative sum of sales for 2017? Show by month
*/

-- WITH monthly_report AS (
-- SELECT 
-- 	EXTRACT(YEAR FROM DATE(STR_TO_DATE(order_date, '%m/%d/%Y'))) AS order_Year,
-- 	EXTRACT(MONTH FROM DATE(STR_TO_DATE(order_date, '%m/%d/%Y'))) AS order_Month,
-- 	ROUND(SUM(Sales), 0) AS yearly_sales_total
-- -- 	ROUND(SUM(Profit), 0) AS yearly_profit_total,
-- -- 	ROUND(SUM(Quantity), 0) AS yearly_quantity_total
-- -- 	ROUND(SUM(Profit), 0) AS profit_total,
-- -- 	ROUND(SUM(Quantity), 0) AS quantity_total,
-- FROM `Tableau Superstore`.orders
-- WHERE EXTRACT(YEAR FROM DATE(STR_TO_DATE(order_date, '%m/%d/%Y'))) = 2017
-- GROUP BY 1, 2
-- )
-- SELECT
-- 	order_month,
-- 	yearly_sales_total,
-- 	SUM(yearly_sales_total) OVER(ORDER BY order_Year) AS running_sales_total
-- 	FROM yearly_report
-- ORDER BY 
-- 1,3 DESC;

/*
Sales Trends
Easy
*/

/*
What are the total sales for each region?
*/
-- SELECT 
--   Region,
--   ROUND(SUM(Sales), 0) AS sales_total,
--   ROUND(SUM(Profit), 0) AS profit_total,
--   ROUND(SUM(Quantity), 0) AS quantity_total
-- FROM `Tableau Superstore`.orders
-- GROUP BY 1
-- ORDER BY 2 DESC;

/*
What is the profit margin for each product category
*/
-- SELECT
-- 	Category,
--     ROUND(SUM(Sales), 0) AS sales_total,
--     ROUND(SUM(Profit), 0) AS profit_total,
--     ROUND(SUM(Profit)/SUM(Sales), 2) as profit_margin
-- FROM `Tableau Superstore`.orders
-- GROUP BY 1
-- ORDER BY 4 DESC;

/*
Medium
*/



/*
Create a report showing sales and MoM change (delta) by month and year
*/

-- SELECT DISTINCT
--     EXTRACT(YEAR FROM DATE(STR_TO_DATE(order_date, '%m/%d/%Y'))) AS order_Year,
--     ROUND(SUM(sales), 0) AS sales_total,
--     ROUND(LAG(SUM(SALES)) OVER(ORDER BY EXTRACT(YEAR FROM DATE(STR_TO_DATE(order_date, '%m/%d/%Y')))), 0) AS sales_prev_year,
-- 	(ROUND(SUM(sales), 0)) -  (ROUND(LAG(SUM(SALES)) OVER(ORDER BY EXTRACT(YEAR FROM DATE(STR_TO_DATE(order_date, '%m/%d/%Y')))), 0)) AS sales_yoy_difference
-- FROM `Tableau Superstore`.orders
-- GROUP BY 1
-- ORDER BY 1;


/*
What is the % of total sales for each category
*/
-- SELECT DISTINCT
--     category,
--     ROUND(SUM(sales), 0) AS sales_total,
--     ROUND((SUM(sales) / (SELECT SUM(sales) FROM `Tableau Superstore`.orders)) * 100, 0) AS percent_oftotal
-- FROM `Tableau Superstore`.orders
-- GROUP BY 1;


/*
Hard
*/

/*
What are the top two selling sub-categories within each category?
*/

-- WITH category_ranking AS (
-- SELECT
-- 	Category,
--     Sub_Category,
--     ROUND(SUM(Sales), 0) AS sales_total,
-- 	DENSE_RANK() OVER(PARTITION BY Category ORDER BY SUM(SALES) DESC) AS sub_category_rank
-- FROM `Tableau Superstore`.orders
-- GROUP BY 1, 2
-- )
-- SELECT
-- 	Category,
--     Sub_Category,
--     sales_total
-- FROM category_ranking
-- WHERE sub_category_rank <= 2
-- ORDER BY 
-- 1, 3 DESC;