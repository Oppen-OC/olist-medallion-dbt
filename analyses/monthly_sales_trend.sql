-- Business question: how did revenue and order volume evolve month over month?
select
    order_month,
    total_orders,
    total_revenue,
    avg_order_value
from {{ ref('gold_monthly_sales') }}
order by order_month
