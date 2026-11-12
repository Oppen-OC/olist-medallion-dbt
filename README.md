# Olist Medallion Pipeline

Bronze/Silver/Gold pipeline built with **DuckDB + dbt** over the [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

Schema definitions: see [SCHEMA.md](SCHEMA.md).
Validation queries and business-value outputs: see [VALIDATION.md](VALIDATION.md).

## Setup

All commands run from the repo root.

```bash
py -3.11 -m venv .venv
.venv\Scriptsctivate          # Windows
source .venv/bin/activate        # macOS/Linux
pip install -r requirements.txt
```

## Data

Download the [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) from Kaggle and extract the zip into `data/raw/` (gitignored, not committed):

```bash
unzip brazilian-ecommerce.zip -d data/raw
```

Expected files: `olist_customers_dataset.csv`, `olist_geolocation_dataset.csv`, `olist_order_items_dataset.csv`, `olist_order_payments_dataset.csv`, `olist_order_reviews_dataset.csv`, `olist_orders_dataset.csv`, `olist_products_dataset.csv`, `olist_sellers_dataset.csv`, `product_category_name_translation.csv`.

The dbt profile ships in the repo (`profiles.yml`), so no `~/.dbt` setup is needed.

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
