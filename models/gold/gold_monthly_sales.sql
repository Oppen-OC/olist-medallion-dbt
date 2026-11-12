with valid_orders as (
    select *
    from {{ ref('silver_orders') }}
    where order_status != 'canceled'
),

order_revenue as (
    select
        o.order_id,
        date_trunc('month', o.order_purchase_timestamp) as order_month,
        sum(i.price + i.freight_value) as order_revenue
    from valid_orders o
    join {{ ref('silver_order_items') }} i
        on o.order_id = i.order_id
    group by o.order_id, date_trunc('month', o.order_purchase_timestamp)
)

select
    order_month,
    count(distinct order_id) as total_orders,
    round(sum(order_revenue), 2) as total_revenue,
    round(avg(order_revenue), 2) as avg_order_value
from order_revenue
group by order_month
