-- models/bronze/stg_customers.sql
{{ config(materialized='table') }}
select * from read_csv_auto('{{ var("raw_path") }}/olist_customers_dataset.csv')
