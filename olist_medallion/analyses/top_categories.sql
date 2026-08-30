-- Business question: which product categories generate the most revenue?
select
    product_category,
    total_orders,
    total_items_sold,
    total_revenue,
    avg_item_price
from {{ ref('gold_category_performance') }}
order by total_revenue desc
limit 10
