-- models/silver/silver_products.sql
{{ config(materialized='table') }}

with deduped as (
    select
        p.product_id,
        p.product_category_name,
        p.product_weight_g,
        p.product_length_cm,
        p.product_height_cm,
        p.product_width_cm,
        row_number() over (partition by p.product_id order by p.product_id) as rn
    from {{ ref('stg_products') }} p
    where p.product_id is not null
)

select
    d.product_id,
    coalesce(t.product_category_name_english, d.product_category_name, 'unknown') as product_category,
    d.product_weight_g,
    d.product_length_cm,
    d.product_height_cm,
    d.product_width_cm
from deduped d
left join {{ ref('stg_product_category_translation') }} t
    on d.product_category_name = t.product_category_name
where d.rn = 1
