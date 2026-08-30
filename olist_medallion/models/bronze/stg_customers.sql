-- models/bronze/stg_customers.sql
{{ config(materialized='table') }}
select * from read_csv_auto('../data/raw/olist_customers_dataset.csv')
