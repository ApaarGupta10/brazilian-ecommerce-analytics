-- Brazilian E-Commerce Intelligence
-- 06: Payment method analysis
-- Payment value is not the same metric as product revenue.

SELECT
    payment_type,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(*) AS payment_records,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS average_payment_record_value
FROM analytics.payments_clean
GROUP BY payment_type
ORDER BY total_payment_value DESC;

-- Payment installment distribution
SELECT
    payment_installments,
    COUNT(*) AS payment_records,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM analytics.payments_clean
GROUP BY payment_installments
ORDER BY payment_installments;

-- Overall payment KPIs
SELECT
    COUNT(DISTINCT order_id) AS orders_with_payment_records,
    COUNT(*) AS payment_records,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(AVG(payment_value), 2) AS average_payment_record_value
FROM analytics.payments_clean;
