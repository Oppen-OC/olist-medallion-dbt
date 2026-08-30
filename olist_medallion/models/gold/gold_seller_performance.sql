-- models/gold/gold_seller_performance.sql
{{ config(materialized='table') }}

with valid_orders as (
    select order_id
    from {{ ref('silver_orders') }}
    where order_status != 'canceled'
),

seller_reviews as (
    select
        i.seller_id,
        avg(r.review_score) as avg_review_score
    from {{ ref('silver_order_items') }} i
    join {{ ref('silver_order_reviews') }} r
        on i.order_id = r.order_id
    group by i.seller_id
)

select
    s.seller_id,
    s.seller_city,
    s.seller_state,
    count(distinct i.order_id) as total_orders,
    round(sum(i.price), 2) as total_revenue,
    round(sr.avg_review_score, 2) as avg_review_score
from {{ ref('silver_order_items') }} i
join valid_orders o
    on i.order_id = o.order_id
join {{ ref('silver_sellers') }} s
    on i.seller_id = s.seller_id
left join seller_reviews sr
    on i.seller_id = sr.seller_id
group by s.seller_id, s.seller_city, s.seller_state, sr.avg_review_score
order by total_revenue desc
