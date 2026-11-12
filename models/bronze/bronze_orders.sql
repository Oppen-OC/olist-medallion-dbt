-- models/bronze/stg_orders.sql
{{ config(materialized='table') }}
select * from read_csv_auto('{{ var("raw_path") }}/olist_orders_dataset.csv')
