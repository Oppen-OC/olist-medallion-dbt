-- models/bronze/stg_order_reviews.sql
{{ config(materialized='table') }}
select * from read_csv_auto('{{ var("raw_path") }}/olist_order_reviews_dataset.csv')
