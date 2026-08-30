-- Business question: which sellers drive the most revenue, and are they well reviewed?
select
    seller_id,
    seller_city,
    seller_state,
    total_orders,
    total_revenue,
    avg_review_score
from {{ ref('gold_seller_performance') }}
order by total_revenue desc
limit 10
