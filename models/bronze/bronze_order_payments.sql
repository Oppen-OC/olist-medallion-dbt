-- models/bronze/stg_order_payments.sql
{{ config(materialized='table') }}
select * from read_csv_auto('{{ var("raw_path") }}/olist_order_payments_dataset.csv')
