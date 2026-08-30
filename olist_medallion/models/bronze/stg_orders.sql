-- models/bronze/stg_orders.sql
{{ config(materialized='table') }}
select * from read_csv_auto('../data/raw/olist_orders_dataset.csv')
