-- models/bronze/stg_sellers.sql
{{ config(materialized='table') }}
select * from read_csv_auto('{{ var("raw_path") }}/olist_sellers_dataset.csv')
