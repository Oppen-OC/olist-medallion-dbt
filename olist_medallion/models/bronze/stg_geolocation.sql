-- models/bronze/stg_geolocation.sql
{{ config(materialized='table') }}
select * from read_csv_auto('../data/raw/olist_geolocation_dataset.csv')
