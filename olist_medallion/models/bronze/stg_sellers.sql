-- models/bronze/stg_sellers.sql
{{ config(materialized='table') }}
select * from read_csv_auto('../data/raw/olist_sellers_dataset.csv')
