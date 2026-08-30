-- models/silver/silver_order_items.sql
{{ config(materialized='table') }}

with deduped as (
    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price,
        freight_value,
        row_number() over (
            partition by order_id, order_item_id
            order by shipping_limit_date desc
        ) as rn
    from {{ ref('stg_order_items') }}
    where order_id is not null
      and product_id is not null
      and price >= 0
)

select
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
from deduped
where rn = 1
