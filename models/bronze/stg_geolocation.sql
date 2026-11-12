-- models/bronze/stg_geolocation.sql
{{ config(materialized='table') }}
select * from read_csv_auto('{{ var("raw_path") }}/olist_geolocation_dataset.csv')
