-- Brazilian E-Commerce Intelligence
-- 03: Sales and revenue analysis
-- Revenue definition: sum of item prices. Freight is reported separately.
-- Delivered orders are used for completed-sales reporting.

-- Monthly sales performance
SELECT
    DATE_TRUNC('month', o.purchase_timestamp)::date AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(*) AS total_items_sold,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(SUM(oi.freight_value), 2) AS total_freight,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_sales_including_freight,
    ROUND(SUM(oi.price) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS average_order_value
FROM analytics.orders_clean o
JOIN analytics.order_items_clean oi ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_TRUNC('month', o.purchase_timestamp)
ORDER BY sales_month;

-- Overall sales KPIs
SELECT
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    COUNT(DISTINCT o.customer_id) AS purchasing_customer_accounts,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(SUM(oi.freight_value), 2) AS total_freight,
    ROUND(SUM(oi.price) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS average_order_value
FROM analytics.orders_clean o
JOIN analytics.order_items_clean oi ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- Order status distribution
SELECT
    order_status,
    COUNT(*) AS orders
FROM analytics.orders_clean
GROUP BY order_status
ORDER BY orders DESC;
