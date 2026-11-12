select order_id, order_item_id, count(*) as n
from {{ ref('silver_order_items') }}
group by order_id, order_item_id
having count(*) > 1
