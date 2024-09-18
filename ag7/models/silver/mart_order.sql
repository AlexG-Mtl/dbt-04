-- models/silver/mart_orders.sql
{{
    config(
        materialized="incremental",
        unique_key="stg_order_sk",
        incremental_strategy="merge",
        description="Incremental mart table for orders data enriched with batch ID and ETL timestamp.",
        tags=["mart", "incremental"],
    )
}}

with
    source_data as (
        select
            stg_order_sk,  -- Use the existing surrogate key from stg_orders
            {{
                dbt_utils.generate_surrogate_key(
                    ["country", "city", "state", "region"]
                )
            }} as geo_sk,
            {{ dbt_utils.generate_surrogate_key(["ship_mode"]) }} as shipping_sk,
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
            '{{ invocation_id }}' as batch_id,  -- Track the dbt run
            {{ dbt_utils.pretty_time("now()") }} as etl_timestamp  -- Record the loading time
        from {{ ref("stg_orders") }}  -- Reference the source model
    )

select *
from source_data
{% if is_incremental() %}
    where stg_order_sk not in (select stg_order_sk from {{ this }})
{% endif %}
