-- models/silver/silver_orders.sql
{{ config(materialized='table') }}

with deduped as (
    select
        order_id,
        customer_id,
        order_status,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date,
        row_number() over (
            partition by order_id
            order by order_purchase_timestamp desc
        ) as rn
    from {{ ref('stg_orders') }}
    where order_id is not null
      and customer_id is not null
      and order_purchase_timestamp is not null
)

select
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
from deduped
where rn = 1
