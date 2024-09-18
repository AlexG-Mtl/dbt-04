{{ config(materialized="incremental", unique_key="stg_order_sk") }}

with
    source_data as (
        select
            mo.stg_order_sk,  -- Use existing surrogate key from mart_orders
            mo.product_id,  -- No Surrogate key for product
            mo.customer_id,  -- No  Surrogate key for customer
            mo.geo_sk,  -- Surrogate key for geography
            mo.shipping_sk,  -- Surrogate key for shipping
            mo.order_id,
            mo.order_date,
            mo.sales,
            mo.quantity,
            mo.profit,
            '{{ invocation_id }}' as batch_id,
            {{ dbt_utils.pretty_time("now()") }} as etl_timestamp
        from {{ ref("mart_order") }} mo

        {% if is_incremental() %}
            -- Only load records that do not already exist in the fact_sales table
            where mo.stg_order_sk not in (select stg_order_sk from {{ this }})
        {% endif %}
    )

select *
from source_data
