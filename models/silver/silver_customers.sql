with deduped as (
    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        trim(customer_city) as customer_city,
        upper(trim(customer_state)) as customer_state,
        row_number() over (partition by customer_id order by customer_unique_id) as rn
    from {{ ref('bronze_customers') }}
    where customer_id is not null
)

select
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
from deduped
where rn = 1
