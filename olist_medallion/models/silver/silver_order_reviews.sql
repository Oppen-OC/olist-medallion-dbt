-- models/silver/silver_order_reviews.sql
{{ config(materialized='table') }}

select
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
from {{ ref('stg_order_reviews') }}
where review_id is not null
  and order_id is not null
  and review_score between 1 and 5
qualify row_number() over (
    partition by review_id
    order by review_answer_timestamp desc
) = 1
