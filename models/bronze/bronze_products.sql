-- models/bronze/stg_products.sql
{{ config(materialized='table') }}
select * from read_csv_auto('{{ var("raw_path") }}/olist_products_dataset.csv')
