-- Brazilian E-Commerce Intelligence
-- 07: Delivery performance and customer review analysis

-- Delivery performance for delivered orders with both timestamps
WITH delivery_metrics AS (
    SELECT
        order_id,
        delivered_customer_date::date AS delivered_date,
        estimated_delivery_date::date AS estimated_date,
        delivered_customer_date::date - estimated_delivery_date::date AS delivery_variance_days
    FROM analytics.orders_clean
    WHERE order_status = 'delivered'
      AND delivered_customer_date IS NOT NULL
      AND estimated_delivery_date IS NOT NULL
)
SELECT
    CASE
        WHEN delivery_variance_days <= 0 THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    COUNT(*) AS orders,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage_of_orders,
    ROUND(AVG(delivery_variance_days), 2) AS average_variance_days
FROM delivery_metrics
GROUP BY
    CASE WHEN delivery_variance_days <= 0 THEN 'On Time' ELSE 'Late' END
ORDER BY delivery_status;

-- Average review score by delivery status
WITH delivery_status AS (
    SELECT
        o.order_id,
        CASE
            WHEN o.delivered_customer_date::date <= o.estimated_delivery_date::date
                THEN 'On Time'
            ELSE 'Late'
        END AS delivery_status
    FROM analytics.orders_clean o
    WHERE o.order_status = 'delivered'
      AND o.delivered_customer_date IS NOT NULL
      AND o.estimated_delivery_date IS NOT NULL
)
SELECT
    ds.delivery_status,
    COUNT(DISTINCT ds.order_id) AS reviewed_or_delivered_orders,
    COUNT(r.review_score) AS review_records,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM delivery_status ds
LEFT JOIN analytics.reviews_clean r ON r.order_id = ds.order_id
GROUP BY ds.delivery_status
ORDER BY ds.delivery_status;

-- Review score distribution
SELECT
    review_score,
    COUNT(*) AS review_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM analytics.reviews_clean
WHERE review_score BETWEEN 1 AND 5
GROUP BY review_score
ORDER BY review_score DESC;
