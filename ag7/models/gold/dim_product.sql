-- models/gold/dim_product.sql
{{ config(materialized="incremental", unique_key="product_id") }}

with
    product_data as (
        select
            product_id,
            product_name,
            category,
            sub_category,
            '{{ invocation_id }}' as batch_id,  -- Add batch ID for tracking
            etl_timestamp,
            row_number() over (
                partition by product_id order by etl_timestamp desc
            ) as rn
        from {{ ref("mart_order") }}  -- Reference to your mart table with product information
    ),

    filtered_product_data as (
        select product_id, product_name, category, sub_category, batch_id, etl_timestamp
        from product_data
        where rn = 1  -- Keep only the most recent record per product_id
    )

select *
from filtered_product_data

{% if is_incremental() %}
    where product_id not in (select product_id from {{ this }})
{% endif %}
