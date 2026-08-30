-- models/bronze/stg_products.sql
{{ config(materialized='table') }}
select * from read_csv_auto('../data/raw/olist_products_dataset.csv')
