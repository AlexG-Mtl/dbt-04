{{
  config(
    materialized='view'

  )
}}

with source as (
    select * from {{ source('ag7','people') }}

)

select
    regional_mngr,
    region
from source