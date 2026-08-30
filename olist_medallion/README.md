# Olist Medallion Pipeline

Bronze/Silver/Gold pipeline built with **DuckDB + dbt** over the [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

Schema definitions: see [SCHEMA.md](SCHEMA.md).
Validation queries and business-value outputs: see [VALIDATION.md](VALIDATION.md).

## Setup

```bash
# from module-3/
py -3.11 -m venv .venv
.venv/Scripts/activate
pip install dbt-duckdb
```

## Data

Download the [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) from Kaggle, extract the zip into `../data/raw/` (one level up from this project, gitignored — not committed):

```bash
# from module-3/
mkdir -p data/raw
unzip brazilian-ecommerce.zip -d data/raw
```

Expected files: `olist_customers_dataset.csv`, `olist_geolocation_dataset.csv`, `olist_order_items_dataset.csv`, `olist_order_payments_dataset.csv`, `olist_order_reviews_dataset.csv`, `olist_orders_dataset.csv`, `olist_products_dataset.csv`, `olist_sellers_dataset.csv`, `product_category_name_translation.csv`.

`profiles.yml` lives at `~/.dbt/profiles.yml`:
```yaml
olist_medallion:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: 'olist.duckdb'
      threads: 4
```

## Run

```bash
dbt debug          # verify connection
dbt run            # build bronze -> silver -> gold
dbt test           # run schema/data tests
dbt docs generate && dbt docs serve   # interactive schema + lineage graph
```

Run a single layer: `dbt run --select bronze` / `silver` / `gold`.

## Structure

```
models/
  bronze/   9 models, 1:1 with each raw CSV, materialized as tables
  silver/   7 models, deduped/filtered/typed/enriched
  gold/     3 models, business aggregates joined from silver
```
