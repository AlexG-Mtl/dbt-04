-- models/gold/dim_geo.sql
{{ config(materialized="incremental", unique_key="geo_sk") }}

with
    geo_data as (
        select
            geo_sk,
            country,
            city,
            state,
            region,
            '{{ invocation_id }}' as batch_id,
            etl_timestamp,
            row_number() over (partition by geo_sk order by etl_timestamp desc) as rn
        from {{ ref("mart_order") }}
    ),

    filtered_geo_data as (
        select geo_sk, country, city, state, region, batch_id, etl_timestamp
        from geo_data
        where rn = 1  -- Keep only the most recent record per geo_sk
    )

select *
from filtered_geo_data

{% if is_incremental() %}
    where geo_sk not in (select geo_sk from {{ this }})
{% endif %}
