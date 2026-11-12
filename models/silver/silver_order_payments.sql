-- models/silver/silver_order_payments.sql
{{ config(materialized='table') }}

select
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
from {{ ref('stg_order_payments') }}
where order_id is not null
  and payment_value >= 0
qualify row_number() over (
    partition by order_id, payment_sequential
    order by payment_value desc
) = 1
