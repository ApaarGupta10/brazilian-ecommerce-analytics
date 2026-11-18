-- Brazilian E-Commerce Intelligence
-- 04: Customer behavior, repeat purchase and RFM analysis

-- Customer-level order frequency
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count,
        MAX(o.purchase_timestamp) AS last_purchase
    FROM analytics.customers_clean c
    JOIN analytics.orders_clean o ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS unique_customers,
    COUNT(*) FILTER (WHERE order_count > 1) AS repeat_customers,
    COUNT(*) FILTER (WHERE order_count = 1) AS one_time_customers,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE order_count > 1) / NULLIF(COUNT(*), 0),
        2
    ) AS repeat_customer_rate_pct
FROM customer_orders;

-- Distribution of customer order frequency
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS order_count
    FROM analytics.customers_clean c
    JOIN analytics.orders_clean o ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    order_count,
    COUNT(*) AS customers
FROM customer_orders
GROUP BY order_count
ORDER BY order_count;

-- RFM base: recency, frequency and monetary value.
-- Monetary value uses item price and delivered orders.
WITH customer_metrics AS (
    SELECT
        c.customer_unique_id,
        MAX(o.purchase_timestamp)::date AS last_purchase_date,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.price) AS monetary_value
    FROM analytics.customers_clean c
    JOIN analytics.orders_clean o ON o.customer_id = c.customer_id
    JOIN analytics.order_items_clean oi ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
reference_date AS (
    SELECT MAX(purchase_timestamp)::date + 1 AS as_of_date
    FROM analytics.orders_clean
)
SELECT
    cm.customer_unique_id,
    (rd.as_of_date - cm.last_purchase_date) AS recency_days,
    cm.frequency,
    ROUND(cm.monetary_value, 2) AS monetary_value
FROM customer_metrics cm
CROSS JOIN reference_date rd
ORDER BY recency_days, frequency DESC;
