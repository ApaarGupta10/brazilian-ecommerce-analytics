-- Brazilian E-Commerce Intelligence
-- 01: Raw data audit
-- Run against ecommerce_analytics in PostgreSQL.

-- 1. Row counts for source tables
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM raw.customers
UNION ALL SELECT 'sellers', COUNT(*) FROM raw.sellers
UNION ALL SELECT 'products', COUNT(*) FROM raw.products
UNION ALL SELECT 'orders', COUNT(*) FROM raw.orders
UNION ALL SELECT 'order_items', COUNT(*) FROM raw.order_items
UNION ALL SELECT 'payments', COUNT(*) FROM raw.payments
UNION ALL SELECT 'reviews', COUNT(*) FROM raw.reviews
UNION ALL SELECT 'category_translation', COUNT(*) FROM raw.category_translation
UNION ALL SELECT 'geolocation', COUNT(*) FROM raw.geolocation
ORDER BY table_name;

-- 2. Candidate key checks
SELECT
    COUNT(*) AS rows_total,
    COUNT(DISTINCT customer_id) AS distinct_customer_ids,
    COUNT(*) FILTER (WHERE customer_id IS NULL OR TRIM(customer_id) = '') AS missing_customer_ids
FROM raw.customers;

SELECT
    COUNT(*) AS rows_total,
    COUNT(DISTINCT order_id) AS distinct_order_ids,
    COUNT(*) FILTER (WHERE order_id IS NULL OR TRIM(order_id) = '') AS missing_order_ids
FROM raw.orders;

SELECT
    COUNT(*) AS rows_total,
    COUNT(DISTINCT (order_id, order_item_id)) AS distinct_order_item_keys
FROM raw.order_items;

SELECT
    COUNT(*) AS rows_total,
    COUNT(DISTINCT (order_id, payment_sequential)) AS distinct_payment_keys
FROM raw.payments;

-- 3. Order status distribution
SELECT
    LOWER(TRIM(order_status)) AS order_status,
    COUNT(*) AS order_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM raw.orders
GROUP BY LOWER(TRIM(order_status))
ORDER BY order_count DESC;

-- 4. Referential integrity checks (each result should be zero)
SELECT COUNT(*) AS orders_without_customer
FROM raw.orders o
LEFT JOIN raw.customers c ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS items_without_order
FROM raw.order_items i
LEFT JOIN raw.orders o ON o.order_id = i.order_id
WHERE o.order_id IS NULL;

SELECT COUNT(*) AS items_without_product
FROM raw.order_items i
LEFT JOIN raw.products p ON p.product_id = i.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) AS items_without_seller
FROM raw.order_items i
LEFT JOIN raw.sellers s ON s.seller_id = i.seller_id
WHERE s.seller_id IS NULL;

-- 5. Numeric validation examples
SELECT
    COUNT(*) FILTER (WHERE NULLIF(TRIM(price), '') IS NOT NULL
        AND TRIM(price) !~ '^[0-9]+([.][0-9]+)?$') AS invalid_prices,
    COUNT(*) FILTER (WHERE NULLIF(TRIM(freight_value), '') IS NOT NULL
        AND TRIM(freight_value) !~ '^[0-9]+([.][0-9]+)?$') AS invalid_freight_values
FROM raw.order_items;
