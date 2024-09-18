{{ config(materialized="view", unique_key="stg_returns_sk", alias="stg_returns") }}

with source as (select * from {{ source("ag7", "returns") }})

select
    {{ dbt_utils.generate_surrogate_key(["order_id"]) }} as stg_returns_sk,
    order_id,
    count(*) as number_of_products_returned

from source
group by order_id
