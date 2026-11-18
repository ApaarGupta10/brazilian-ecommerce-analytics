# Brazilian E-Commerce Intelligence

An end-to-end e-commerce analytics project using the Brazilian Olist dataset. This project explores sales performance, customer behavior, product categories, seller performance, payment methods, and delivery satisfaction using PostgreSQL, SQL, and Tableau.

## Project Overview

The goal is to transform raw e-commerce data into actionable business insights through data auditing, cleaning, SQL analysis, and dashboard development.

## Tools & Technologies

- PostgreSQL
- SQL
- DBeaver
- Tableau Public
- GitHub

## Dataset

Brazilian E-Commerce Public Dataset by Olist, available on Kaggle.

The dataset contains information about customers, orders, order items, products, sellers, payments, reviews, geolocation, and product category translations.

## Project Structure

```text
brazilian-ecommerce-intelligence/
├── sql/
│   ├── 01_data_audit.sql
│   ├── 02_data_cleaning.sql
│   ├── 03_sales_analysis.sql
│   ├── 04_customer_analysis.sql
│   ├── 05_product_seller_analysis.sql
│   ├── 06_payment_analysis.sql
│   └── 07_delivery_review_analysis.sql
├── tableau/
│   └── dashboard_screenshot.png
└── README.md
```

## Business Questions

1. How are sales and revenue changing over time?
2. Which product categories generate the most revenue?
3. Which sellers contribute most to sales?
4. What payment methods do customers use?
5. How many customers make repeat purchases?
6. How does delivery performance relate to customer reviews?

## Key Findings

- Product revenue across the analyzed categories: **R$13.22 million**.
- The analysis covers **74 product categories**.
- **96,478 delivered orders** were identified.
- Approximately **91.89%** of delivered orders with available delivery dates arrived on time.
- Customer reviews were predominantly positive, with **57.78%** receiving a score of 5.

## SQL Analysis

The SQL scripts cover:
- Data quality auditing
- Data cleaning and transformation
- Sales and revenue analysis
- Customer analysis
- Product and seller analysis
- Payment analysis
- Delivery and review analysis

## Dashboard

The Tableau dashboard provides an executive overview of sales, orders, customers, categories, sellers, payment methods, and delivery satisfaction.

A dashboard screenshot will be added in the `tableau/` folder.

## Dataset Source

[Olist Brazilian E-Commerce Public Dataset — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

---

**Project Status:** SQL analysis and Tableau dashboard created. Portfolio documentation in progress.
