-- models/bronze/stg_product_category_translation.sql
{{ config(materialized='table') }}
select * from read_csv_auto('../data/raw/product_category_name_translation.csv')
