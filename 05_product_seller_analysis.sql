-- Brazilian E-Commerce Intelligence
-- 05: Product category and seller performance
-- Revenue is based on order item price, excluding freight.

-- Product category performance
SELECT
    COALESCE(ct.product_category_name_english, p.product_category_name, 'unknown') AS product_category,
    COUNT(DISTINCT oi.product_id) AS distinct_products,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS product_revenue
FROM analytics.order_items_clean oi
JOIN analytics.orders_clean o ON o.order_id = oi.order_id
JOIN analytics.products_clean p ON p.product_id = oi.product_id
LEFT JOIN analytics.category_translation_clean ct
    ON ct.product_category_name = p.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY COALESCE(ct.product_category_name_english, p.product_category_name, 'unknown')
ORDER BY product_revenue DESC;

-- Top 10 product categories by revenue
SELECT
    COALESCE(ct.product_category_name_english, p.product_category_name, 'unknown') AS product_category,
    ROUND(SUM(oi.price), 2) AS product_revenue
FROM analytics.order_items_clean oi
JOIN analytics.orders_clean o ON o.order_id = oi.order_id
JOIN analytics.products_clean p ON p.product_id = oi.product_id
LEFT JOIN analytics.category_translation_clean ct
    ON ct.product_category_name = p.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY COALESCE(ct.product_category_name_english, p.product_category_name, 'unknown')
ORDER BY product_revenue DESC
LIMIT 10;

-- Seller performance
SELECT
    oi.seller_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS product_revenue
FROM analytics.order_items_clean oi
JOIN analytics.orders_clean o ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
ORDER BY product_revenue DESC;

-- Top 10 sellers by revenue
SELECT
    oi.seller_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS product_revenue
FROM analytics.order_items_clean oi
JOIN analytics.orders_clean o ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
ORDER BY product_revenue DESC
LIMIT 10;
