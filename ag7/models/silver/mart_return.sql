{{
    config(
        materialized="incremental",
        unique_key="stg_returns_sk",
        incremental_strategy="merge",
        description="Incremental mart table for returns data enriched with batch ID and ETL timestamp.",
        tags=["mart", "incremental"],
    )
}}

with
    source_data as (
        select
            stg_returns_sk,  -- Use the surrogate key defined in stg_returns
            order_id,
            count(*) as number_of_products_returned,
            '{{ invocation_id }}' as batch_id,  -- Add the batch ID to track the dbt run
            {{ dbt_utils.pretty_time("now()") }} as etl_timestamp  -- Add the ETL timestamp to track the loading time
        from {{ ref("stg_returns") }}

        {% if is_incremental() %}
            where stg_returns_sk not in (select stg_returns_sk from {{ this }})
        {% endif %}

        group by order_id, stg_returns_sk
    )

select *
from source_data
