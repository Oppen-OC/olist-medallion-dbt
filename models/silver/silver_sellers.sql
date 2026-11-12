with deduped as (
    select
        seller_id,
        seller_zip_code_prefix,
        trim(seller_city) as seller_city,
        upper(trim(seller_state)) as seller_state,
        row_number() over (partition by seller_id order by seller_id) as rn
    from {{ ref('bronze_sellers') }}
    where seller_id is not null
)

select
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
from deduped
where rn = 1
