{{
    config(
        materialized="incremental",
        unique_key="stg_people_sk",
        incremental_strategy="merge",
        description="Incremental mart table for people data enriched with batch ID and ETL timestamp.",
        tags=["mart", "incremental"],
    )
}}

with
    source_data as (
        select
            stg_people_sk,  -- Surrogate key from stg_people
            regional_mngr,
            region,
            '{{ invocation_id }}' as batch_id,  -- Add the batch ID to track the dbt run
            {{ dbt_utils.pretty_time("now()") }} as etl_timestamp  -- Add the ETL timestamp to track the loading time
        from {{ ref("stg_people") }}  -- Reference the staging model

        {% if is_incremental() %}
            -- This filter will only be applied on an incremental run
            where stg_people_sk not in (select stg_people_sk from {{ this }})
        {% endif %}
    )

select *
from source_data
