{{ config(materialized="view") }}

with source as (select * from {{ source("ag7", "returns") }})

select returned, order_id
from source
