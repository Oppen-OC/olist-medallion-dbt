-- models/bronze/stg_order_items.sql
{{ config(materialized='table') }}
select * from read_csv_auto('{{ var("raw_path") }}/olist_order_items_dataset.csv')
