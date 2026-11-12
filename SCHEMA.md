# Schema Definitions — Olist Medallion Pipeline

Source: [Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle).

## Bronze Layer

Raw CSV loaded as-is via `read_csv_auto`, no transformation. One table per source file. Full descriptions and column-level tests in [`models/bronze/_bronze__models.yml`](models/bronze/_bronze__models.yml).

| Table | Key columns | Constraints |
|---|---|---|
| `bronze_orders` | `order_id` VARCHAR, `customer_id` VARCHAR, `order_status` VARCHAR, 5x TIMESTAMP (purchase/approved/delivered/estimated dates) | none (raw) |
| `bronze_customers` | `customer_id` VARCHAR, `customer_unique_id` VARCHAR, `customer_zip_code_prefix` VARCHAR, `customer_city` VARCHAR, `customer_state` VARCHAR | none (raw) |
| `bronze_sellers` | `seller_id` VARCHAR, `seller_zip_code_prefix` VARCHAR, `seller_city` VARCHAR, `seller_state` VARCHAR | none (raw) |
| `bronze_products` | `product_id` VARCHAR, `product_category_name` VARCHAR, 5x BIGINT (name/description length, photos qty, weight, dimensions) | none (raw) |
| `bronze_order_items` | `order_id` VARCHAR, `order_item_id` BIGINT, `product_id` VARCHAR, `seller_id` VARCHAR, `shipping_limit_date` TIMESTAMP, `price` DOUBLE, `freight_value` DOUBLE | none (raw) |
| `bronze_order_payments` | `order_id` VARCHAR, `payment_sequential` BIGINT, `payment_type` VARCHAR, `payment_installments` BIGINT, `payment_value` DOUBLE | none (raw) |
| `bronze_order_reviews` | `review_id` VARCHAR, `order_id` VARCHAR, `review_score` BIGINT, comment title/message VARCHAR, 2x TIMESTAMP | none (raw) |
| `bronze_geolocation` | `geolocation_zip_code_prefix` VARCHAR, lat/lng DOUBLE, city/state VARCHAR | none (raw) — loaded but not promoted to silver/gold |
| `bronze_product_category_translation` | `product_category_name` VARCHAR, `product_category_name_english` VARCHAR | none (raw) — used only as a lookup inside `silver_products` |

## Silver Layer

Deduplicated, null-filtered, typed, enriched. Full descriptions and tests in [`models/silver/_silver__models.yml`](models/silver/_silver__models.yml).

| Table | Columns (type) | Cleaning applied |
|---|---|---|
| `silver_orders` | `order_id` VARCHAR **PK**, `customer_id` VARCHAR, `order_status` VARCHAR, 4x TIMESTAMP | Dedup by `order_id` (latest `order_purchase_timestamp` wins). Drops rows with null `order_id`/`customer_id`/`order_purchase_timestamp`. |
| `silver_customers` | `customer_id` VARCHAR **PK**, `customer_unique_id` VARCHAR, `customer_zip_code_prefix` VARCHAR, `customer_city` VARCHAR, `customer_state` VARCHAR | Dedup by `customer_id`. Trims city, uppercases state. |
| `silver_sellers` | `seller_id` VARCHAR **PK**, `seller_zip_code_prefix` VARCHAR, `seller_city` VARCHAR, `seller_state` VARCHAR | Dedup by `seller_id`. Trims city, uppercases state. |
| `silver_products` | `product_id` VARCHAR **PK**, `product_category` VARCHAR, `product_weight_g/length_cm/height_cm/width_cm` BIGINT | Dedup by `product_id`. Enriched: `product_category_name` translated PT→EN via `bronze_product_category_translation`, falls back to `'unknown'` if missing. |
| `silver_order_items` | `order_id` VARCHAR **FK**, `order_item_id` BIGINT, `product_id` VARCHAR **FK**, `seller_id` VARCHAR **FK**, `shipping_limit_date` TIMESTAMP, `price` DOUBLE, `freight_value` DOUBLE | Dedup by `(order_id, order_item_id)`. Drops negative `price`. |
| `silver_order_payments` | `order_id` VARCHAR **FK**, `payment_sequential` BIGINT, `payment_type` VARCHAR, `payment_installments` BIGINT, `payment_value` DOUBLE | Dedup by `(order_id, payment_sequential)`. Drops negative `payment_value`. |
| `silver_order_reviews` | `review_id` VARCHAR **PK**, `order_id` VARCHAR **FK**, `review_score` BIGINT, comment fields, 2x TIMESTAMP | Dedup by `review_id`. Restricts `review_score` to 1-5. |

## Gold Layer

Business aggregates, joined from silver. Full descriptions and tests in [`models/gold/_gold__models.yml`](models/gold/_gold__models.yml).

| Table | Columns (type) | Business question answered |
|---|---|---|
| `gold_monthly_sales` | `order_month` TIMESTAMP **PK**, `total_orders` BIGINT, `total_revenue` DOUBLE, `avg_order_value` DOUBLE | Monthly sales trend: how much revenue and how many orders per calendar month? |
| `gold_category_performance` | `product_category` VARCHAR **PK**, `total_orders` BIGINT, `total_items_sold` BIGINT, `total_revenue` DOUBLE, `avg_item_price` DOUBLE | Which product categories drive the most revenue? |
| `gold_seller_performance` | `seller_id` VARCHAR **PK**, `seller_city` VARCHAR, `seller_state` VARCHAR, `total_orders` BIGINT, `total_revenue` DOUBLE, `avg_review_score` DOUBLE | Which sellers generate the most revenue, and how satisfied are their customers? |

All gold tables exclude orders with `order_status = 'canceled'`.

Metric definitions:

- `total_revenue` (all three tables) is merchandise revenue: `sum(price)` over non-canceled order items, freight excluded.
- `avg_order_value` is the mean of per-order `sum(price)` in the month, so freight is also excluded.
- `avg_review_score` averages review scores over non-canceled orders only. Scores are first averaged per `(seller_id, order_id)` and then per seller, so each order counts once however many items it holds.

## Lineage

```
bronze (9 tables, raw CSV)
  └─ silver (7 tables: dedupe + filter + enrich)
       └─ gold (3 tables: joined aggregates)
```

Full interactive DAG: `dbt docs generate && dbt docs serve`.
