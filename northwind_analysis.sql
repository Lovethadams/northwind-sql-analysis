-- Query 1: Rank employees by total sales
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    COUNT(o.order_id) AS total_orders,
    RANK() OVER (ORDER BY COUNT(o.order_id) DESC) AS sales_rank
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name;



-- Query 2: Running total of revenue by month
SELECT 
    TO_CHAR(DATE_TRUNC('month', o.order_date), 'YYYY-MM') AS month,
    ROUND(CAST(SUM(od.unit_price * od.quantity) AS NUMERIC), 2) AS monthly_revenue,
    ROUND(CAST(SUM(SUM(od.unit_price * od.quantity)) OVER (ORDER BY DATE_TRUNC('month', o.order_date)) AS NUMERIC), 2) AS running_total
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY DATE_TRUNC('month', o.order_date);


-- Query 3: Customers above average order value
SELECT 
    c.company_name,
    AVG(od.unit_price * od.quantity) AS avg_order_value,
    AVG(AVG(od.unit_price * od.quantity)) OVER () AS overall_avg
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.company_name
ORDER BY avg_order_value DESC;



-- Query 4: Top product per category
SELECT 
    category_name,
    product_name,
    total_sales,
    product_rank
FROM (
    SELECT 
        cat.category_name,
        p.product_name,
        SUM(od.unit_price * od.quantity) AS total_sales,
        ROW_NUMBER() OVER (PARTITION BY cat.category_id ORDER BY SUM(od.unit_price * od.quantity) DESC) AS product_rank
    FROM products p
    JOIN categories cat ON p.category_id = cat.category_id
    JOIN order_details od ON p.product_id = od.product_id
    GROUP BY cat.category_id, cat.category_name, p.product_id, p.product_name
) ranked
WHERE product_rank = 1;


-- Query 5: Month over month sales growth
SELECT 
    month,
    ROUND(CAST(monthly_revenue AS NUMERIC), 2) AS monthly_revenue,
    ROUND(CAST(LAG(monthly_revenue) OVER (ORDER BY month) AS NUMERIC), 2) AS previous_month,
    ROUND(CAST((monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month)) / LAG(monthly_revenue) OVER (ORDER BY month) * 100 AS NUMERIC), 2) AS growth_percentage
FROM (
    SELECT 
        TO_CHAR(DATE_TRUNC('month', o.order_date), 'YYYY-MM') AS month,
        SUM(od.unit_price * od.quantity) AS monthly_revenue
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY DATE_TRUNC('month', o.order_date)
    ORDER BY DATE_TRUNC('month', o.order_date)
) monthly_sales
ORDER BY month;