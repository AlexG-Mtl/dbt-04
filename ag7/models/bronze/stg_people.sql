{{ config(materialized="view", unique_key="stg_people", alias="stg_people") }}

with source as (select * from {{ source("ag7", "people") }})

select
    {{ dbt_utils.generate_surrogate_key(["regional_mngr", "region"]) }}
    as stg_people_sk,
    regional_mngr,
    region
from source
