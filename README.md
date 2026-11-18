# SQL Scripts — Brazilian E-Commerce Intelligence

These PostgreSQL scripts document the data audit, typed analytics layer, and business analysis for the Brazilian Olist e-commerce project.

## Execution order

1. `01_data_audit.sql` — inspect raw row counts, candidate keys, status distribution, referential integrity, and numeric values.
2. `02_data_cleaning.sql` — create typed tables in the `analytics` schema from the `raw` schema. This script drops and recreates only the named `analytics` tables.
3. `03_sales_analysis.sql` — monthly sales, revenue, freight, order counts, and average order value.
4. `04_customer_analysis.sql` — repeat purchasing and customer-level RFM base metrics.
5. `05_product_seller_analysis.sql` — category and seller revenue performance.
6. `06_payment_analysis.sql` — payment methods, installments, and payment value.
7. `07_delivery_review_analysis.sql` — delivery timing and review scores.

## Important metric definitions

- Product revenue is calculated as the sum of order-item `price`.
- Freight is calculated separately from `freight_value`.
- Payment value is calculated from `payments_clean.payment_value`; it is a different measure and should not be treated as product revenue.
- Completed-sales analyses generally filter to `order_status = 'delivered'`.
- RFM recency uses the latest purchase date in the dataset plus one day as its reference date.

Run these scripts in the `ecommerce_analytics` PostgreSQL database. The raw source tables are not modified.
