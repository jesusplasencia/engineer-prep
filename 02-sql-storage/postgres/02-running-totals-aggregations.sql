-- ==============================================================================
-- 02-running-totals-aggregations.sql
-- Running totals, Moving averages, and Frame clauses (ROWS/RANGE BETWEEN)
-- ==============================================================================

-- Problem 1: Cumulative Running Total of sales by employee and date
SELECT 
    employee_id,
    sale_date,
    sale_amount,
    SUM(sale_amount) OVER (
        PARTITION BY employee_id 
        ORDER BY sale_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM sales
ORDER BY employee_id, sale_date;

-- Problem 2: 3-Day Moving Average of sales per region
SELECT 
    region,
    sale_date,
    sale_amount,
    ROUND(AVG(sale_amount) OVER (
        PARTITION BY region
        ORDER BY sale_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3_sales
FROM sales
ORDER BY region, sale_date;

-- Problem 3: Delta vs Previous Sale (LAG / LEAD)
SELECT 
    employee_id,
    sale_date,
    sale_amount,
    LAG(sale_amount, 1) OVER (PARTITION BY employee_id ORDER BY sale_date) AS prev_sale_amount,
    sale_amount - COALESCE(LAG(sale_amount, 1) OVER (PARTITION BY employee_id ORDER BY sale_date), sale_amount) AS growth_vs_prev
FROM sales
ORDER BY employee_id, sale_date;

