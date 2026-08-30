-- models/bronze/stg_order_reviews.sql
{{ config(materialized='table') }}
select * from read_csv_auto('../data/raw/olist_order_reviews_dataset.csv')
