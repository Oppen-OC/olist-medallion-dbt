select order_id, payment_sequential, count(*) as n
from {{ ref('silver_order_payments') }}
group by order_id, payment_sequential
having count(*) > 1
