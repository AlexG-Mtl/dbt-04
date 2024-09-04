{{
    config(
        tags=["daily"],
        materialized="incremental",
        incremental_strategy="merge",
        unique_key="dwh_id",
        description="This model is expected to be fresh within 24 hours based on etl_timestamp.",
        post_hook="         {% if var('should_delete') %}         delete from {{ this }} where dwh_id not in (select dwh_id from {{ ref('stg_orders') }});         {% endif %}     ",
    )
}}

with
    orders as (
        select *
        from {{ ref("stg_orders") }}

        {% if is_incremental() %}
            -- This filter will only be applied on an incremental run
            -- (uses >= to include records arriving later on the same day as the last
            -- run of this model)
            where
                order_date
                > (select coalesce(max(order_date), '1900-01-01') from {{ this }})
        {% endif %}
    ),
    final as (
        select
            dwh_id,
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
            etl_timestamp,  -- Include the freshness timestamp
            '{{ invocation_id }}' as batch_id
        from orders
    )

select *
from final
