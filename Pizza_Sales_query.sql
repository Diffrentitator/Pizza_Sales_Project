
-- WE Have created a table and imported the CSV file 

CREATE TABLE pizza_sales
(
pizza_id INT,
order_id int,
pizza_name_id VARCHAR(50),
quantity INT,
order_date DATE,
order_time TIME,
unit_price FLOAT,
total_price FLOAT,
pizza_size VARCHAR(50),
pizza_category VARCHAR(50),
pizza_ingredients VARCHAR(200),
pizza_name VARCHAR(100)
)
SELECT * FROM pizza_sales
-- Problem statement FOR KPIs
-- we need to analyse key indicators for our pizza sales data to gain insights into our business performance.
-- Q1) Calculate the  Total revenue

SELECT ROUND(CAST(SUM(total_price) AS numeric), 2) AS total_revenue
FROM pizza_sales;

-- 817860.05

--  Calculate Average Order Value
SELECT ROUND(CAST(SUM(total_price) / COUNT(DISTINCT order_id) AS numeric), 2) AS AVG_order_value
FROM pizza_sales

-- 38.31

--  calculate the total pizza sold

SELECT SUM(quantity) AS total_pizzas_sold
FROM pizza_sales

-- 49574

--Q4) Calculate the total orders
SELECT COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales

-- 21350

-- Calculate Average Pizzas per order

SELECT (CAST(SUM(quantity) / COUNT(DISTINCT order_id) AS numeric), 2) AS average_pizzas_per_order
FROM pizza_sales
-- 2.2

-- CHARTS Requirements
-- WE would like to visualize various aspects of our pizza sales data to gain insights and understand key trends.
-- We need to find the daily trend for total orders

SELECT TO_CHAR(order_date, 'Day') AS order_day,
       COUNT(DISTINCT order_id) AS total_orders
FROM pizza_sales
GROUP BY TO_CHAR(order_date, 'Day'), EXTRACT(DOW FROM order_date)
ORDER BY EXTRACT(DOW FROM order_date);

-- Monthly Trend for Total Orders

SELECT To_CHAR(order_date, 'Month') AS Month_Name, 
COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY TO_CHAR(order_date, 'Month')
ORDER BY Total_Orders DESC


-- Percentage of sales by Pizza_category
SELECT pizza_category, SUM(total_price) * 100 / (SELECT SUM(total_price)) AS category_percentage
FROM pizza_sales
GROUP BY pizza_category

SELECT pizza_category, 
     ROUND(CAST (SUM(total_price) AS numeric), 2) AS total_sales, 
       (SUM(total_price) * 100.0 / (
           SELECT SUM(total_price) 
           FROM pizza_sales 
           WHERE EXTRACT(MONTH FROM order_date) = 1
       ), 2) AS category_percentage
FROM pizza_sales
WHERE EXTRACT(MONTH FROM order_date) = 1
GROUP BY pizza_category;

-- Percentage per pizza size


SELECT pizza_size, 
       CAST(SUM(total_price) AS NUMERIC(10, 2)) AS total_sale_per_pizza_size, 
       CAST(SUM(total_price) * 100.0 / (SELECT SUM(total_price) FROM pizza_sales) AS NUMERIC(5, 2)) AS pct
FROM pizza_sales 
WHERE EXTRACT(MONTH FROM order_date) IN (1,2,3)
GROUP BY pizza_size
ORDER BY CASE pizza_size
            WHEN 'Small' THEN 1
            WHEN 'Medium' THEN 2
            WHEN 'Large' THEN 3
            WHEN 'XLarge' THEN 4
            ELSE 5
         END;

-- Top 5 Best sellers by Revenue, Total Quantity and Total Orders

SELECT pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC
LIMIT 5

-- By total quantity
SELECT pizza_name, SUM(quantity) AS Total_Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity DESC
LIMIT 5

-- By total orders

SELECT pizza_name, COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC
LIMIT 5
















