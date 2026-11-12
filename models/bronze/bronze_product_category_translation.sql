-- models/bronze/stg_product_category_translation.sql
{{ config(materialized='table') }}
select * from read_csv_auto('{{ var("raw_path") }}/product_category_name_translation.csv')
