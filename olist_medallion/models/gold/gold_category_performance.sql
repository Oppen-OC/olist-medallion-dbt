-- models/gold/gold_category_performance.sql
{{ config(materialized='table') }}

with valid_orders as (
    select order_id
    from {{ ref('silver_orders') }}
    where order_status != 'canceled'
)

select
    p.product_category,
    count(distinct i.order_id) as total_orders,
    count(*) as total_items_sold,
    round(sum(i.price), 2) as total_revenue,
    round(avg(i.price), 2) as avg_item_price
from {{ ref('silver_order_items') }} i
join valid_orders o
    on i.order_id = o.order_id
join {{ ref('silver_products') }} p
    on i.product_id = p.product_id
group by p.product_category
order by total_revenue desc
