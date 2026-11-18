-- Brazilian E-Commerce Intelligence
-- 02: Build typed analytical tables from raw text tables.
-- Safe to rerun: only analytics tables are dropped/recreated.
-- Raw source tables are never modified.

CREATE SCHEMA IF NOT EXISTS analytics;

DROP TABLE IF EXISTS analytics.orders_clean;
CREATE TABLE analytics.orders_clean AS
SELECT
    order_id,
    customer_id,
    LOWER(TRIM(order_status)) AS order_status,
    NULLIF(TRIM(order_purchase_timestamp), '')::timestamp AS purchase_timestamp,
    NULLIF(TRIM(order_approved_at), '')::timestamp AS approved_at,
    NULLIF(TRIM(order_delivered_carrier_date), '')::timestamp AS delivered_carrier_date,
    NULLIF(TRIM(order_delivered_customer_date), '')::timestamp AS delivered_customer_date,
    NULLIF(TRIM(order_estimated_delivery_date), '')::timestamp AS estimated_delivery_date
FROM raw.orders;

DROP TABLE IF EXISTS analytics.customers_clean;
CREATE TABLE analytics.customers_clean AS
SELECT
    customer_id,
    customer_unique_id,
    NULLIF(TRIM(customer_zip_code_prefix), '')::integer AS zip_code,
    customer_city,
    customer_state
FROM raw.customers;

DROP TABLE IF EXISTS analytics.products_clean;
CREATE TABLE analytics.products_clean AS
SELECT
    product_id,
    product_category_name,
    NULLIF(TRIM(product_name_lenght), '')::integer AS name_length,
    NULLIF(TRIM(product_description_lenght), '')::integer AS description_length,
    NULLIF(TRIM(product_photos_qty), '')::integer AS photos_qty,
    NULLIF(TRIM(product_weight_g), '')::numeric AS weight_g,
    NULLIF(TRIM(product_length_cm), '')::numeric AS length_cm,
    NULLIF(TRIM(product_height_cm), '')::numeric AS height_cm,
    NULLIF(TRIM(product_width_cm), '')::numeric AS width_cm
FROM raw.products;

DROP TABLE IF EXISTS analytics.sellers_clean;
CREATE TABLE analytics.sellers_clean AS
SELECT
    seller_id,
    NULLIF(TRIM(seller_zip_code_prefix), '')::integer AS zip_code,
    seller_city,
    seller_state
FROM raw.sellers;

DROP TABLE IF EXISTS analytics.order_items_clean;
CREATE TABLE analytics.order_items_clean AS
SELECT
    order_id,
    NULLIF(TRIM(order_item_id), '')::integer AS order_item_id,
    product_id,
    seller_id,
    NULLIF(TRIM(shipping_limit_date), '')::timestamp AS shipping_limit_date,
    NULLIF(TRIM(price), '')::numeric AS price,
    NULLIF(TRIM(freight_value), '')::numeric AS freight_value
FROM raw.order_items;

DROP TABLE IF EXISTS analytics.payments_clean;
CREATE TABLE analytics.payments_clean AS
SELECT
    order_id,
    NULLIF(TRIM(payment_sequential), '')::integer AS payment_sequential,
    LOWER(TRIM(payment_type)) AS payment_type,
    NULLIF(TRIM(payment_installments), '')::integer AS payment_installments,
    NULLIF(TRIM(payment_value), '')::numeric AS payment_value
FROM raw.payments;

DROP TABLE IF EXISTS analytics.reviews_clean;
CREATE TABLE analytics.reviews_clean AS
SELECT
    review_id,
    order_id,
    NULLIF(TRIM(review_score), '')::integer AS review_score,
    review_comment_title,
    review_comment_message,
    NULLIF(TRIM(review_creation_date), '')::timestamp AS review_creation_date,
    NULLIF(TRIM(review_answer_timestamp), '')::timestamp AS review_answer_timestamp
FROM raw.reviews;

DROP TABLE IF EXISTS analytics.category_translation_clean;
CREATE TABLE analytics.category_translation_clean AS
SELECT
    product_category_name,
    product_category_name_english
FROM raw.category_translation;

-- Verify cleaned table counts
SELECT 'orders_clean' AS table_name, COUNT(*) AS records FROM analytics.orders_clean
UNION ALL SELECT 'customers_clean', COUNT(*) FROM analytics.customers_clean
UNION ALL SELECT 'products_clean', COUNT(*) FROM analytics.products_clean
UNION ALL SELECT 'sellers_clean', COUNT(*) FROM analytics.sellers_clean
UNION ALL SELECT 'order_items_clean', COUNT(*) FROM analytics.order_items_clean
UNION ALL SELECT 'payments_clean', COUNT(*) FROM analytics.payments_clean
UNION ALL SELECT 'reviews_clean', COUNT(*) FROM analytics.reviews_clean
UNION ALL SELECT 'category_translation_clean', COUNT(*) FROM analytics.category_translation_clean
ORDER BY table_name;
