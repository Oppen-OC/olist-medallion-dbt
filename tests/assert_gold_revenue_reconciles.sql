-- Tolerance of 1.0: gold rounds each group to 2 decimals, so per-group rounding error accumulates in the total.
with silver_total as (
    select sum(i.price) as total
    from {{ ref('silver_order_items') }} i
    join {{ ref('silver_orders') }} o
        on i.order_id = o.order_id
    where o.order_status != 'canceled'
),

gold_totals as (
    select 'gold_monthly_sales' as gold_table, sum(total_revenue) as total from {{ ref('gold_monthly_sales') }}
    union all
    select 'gold_category_performance', sum(total_revenue) from {{ ref('gold_category_performance') }}
    union all
    select 'gold_seller_performance', sum(total_revenue) from {{ ref('gold_seller_performance') }}
)

select g.gold_table, g.total as gold_total, s.total as silver_total
from gold_totals g
cross join silver_total s
where abs(g.total - s.total) > 1.0
