{{ config(materialized="incremental", unique_key="customer_id") }}

with
    customer_data as (
        select
            customer_id,
            customer_name,
            segment,
            country,
            city,
            state,
            postal_code,
            '{{ invocation_id }}' as batch_id,
            etl_timestamp,
            row_number() over (
                partition by customer_id order by etl_timestamp desc
            ) as rn
        from {{ ref("mart_order") }}
    ),

    filtered_customer_data as (
        select
            customer_id,
            customer_name,
            segment,
            country,
            city,
            state,
            postal_code,
            batch_id,
            etl_timestamp
        from customer_data
        where rn = 1  -- Keep only the most recent record per customer_id
    )

select *
from filtered_customer_data

{% if is_incremental() %}
    where customer_id not in (select customer_id from {{ this }})
{% endif %}
