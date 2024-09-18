{{ config(materialized="incremental", unique_key="shipping_sk") }}

with
    shipping_data as (
        select
            shipping_sk,  -- Generate a unique surrogate key for each shipping mode
            max(ship_mode) as ship_mode,
            '{{ invocation_id }}' as batch_id,
            {{ dbt_utils.pretty_time("now()") }} as etl_timestamp
        from {{ ref("mart_order") }}

        {% if is_incremental() %}
            where shipping_sk not in (select shipping_sk from {{ this }})
        {% endif %}
        group by shipping_sk

    )

select *
from shipping_data
