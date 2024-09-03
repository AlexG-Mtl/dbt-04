{{
  config(
    materialized='view',
    unique_key='dwh_id',
    alias='stg_orders'
  )
}}

with source as (
    select * from {{ source('ag7', 'orders') }}
)

select
    {{ dbt_utils.generate_surrogate_key(
        ['order_id', 'customer_id', 'product_id']
    ) }} as dwh_id,
    row_id,
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region,
    product_id,
    category,
    sub_category,
    product_name,
    sales,
    quantity,
    discount,
    profit,
    {{ dbt_utils.pretty_time("now()") }} as etl_timestamp
from source