{{ config(materialized="view", unique_key="dwh_id", alias="stg_orders_valid_state") }}

with
    source as (
        select
            {{
                dbt_utils.generate_surrogate_key(
                    ["order_id", "customer_id", "product_id"]
                )
            }} as dwh_id,
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
            {{ dbt_utils.pretty_time("now()") }} as etl_timestamp
        from {{ source("ag7", "orders") }}
    ),

    state_conversions as (
        select
            *,
            case
                when state = 'Alabama'
                then 'AL'
                when state = 'Alaska'
                then 'AK'
                when state = 'Arizona'
                then 'AZ'
                when state = 'Arkansas'
                then 'AR'
                when state = 'California'
                then 'CA'
                when state = 'Colorado'
                then 'CO'
                when state = 'Connecticut'
                then 'CT'
                when state = 'Delaware'
                then 'DE'
                when state = 'Florida'
                then 'FL'
                when state = 'Georgia'
                then 'GA'
                when state = 'Hawaii'
                then 'HI'
                when state = 'Idaho'
                then 'ID'
                when state = 'Illinois'
                then 'IL'
                when state = 'Indiana'
                then 'IN'
                when state = 'Iowa'
                then 'IA'
                when state = 'Kansas'
                then 'KS'
                when state = 'Kentucky'
                then 'KY'
                when state = 'Louisiana'
                then 'LA'
                when state = 'Maine'
                then 'ME'
                when state = 'Maryland'
                then 'MD'
                when state = 'Massachusetts'
                then 'MA'
                when state = 'Michigan'
                then 'MI'
                when state = 'Minnesota'
                then 'MN'
                when state = 'Mississippi'
                then 'MS'
                when state = 'Missouri'
                then 'MO'
                when state = 'Montana'
                then 'MT'
                when state = 'Nebraska'
                then 'NE'
                when state = 'Nevada'
                then 'NV'
                when state = 'New Hampshire'
                then 'NH'
                when state = 'New Jersey'
                then 'NJ'
                when state = 'New Mexico'
                then 'NM'
                when state = 'New York'
                then 'NY'
                when state = 'North Carolina'
                then 'NC'
                when state = 'North Dakota'
                then 'ND'
                when state = 'Ohio'
                then 'OH'
                when state = 'Oklahoma'
                then 'OK'
                when state = 'Oregon'
                then 'OR'
                when state = 'Pennsylvania'
                then 'PA'
                when state = 'Rhode Island'
                then 'RI'
                when state = 'South Carolina'
                then 'SC'
                when state = 'South Dakota'
                then 'SD'
                when state = 'Tennessee'
                then 'TN'
                when state = 'Texas'
                then 'TX'
                when state = 'Utah'
                then 'UT'
                when state = 'Vermont'
                then 'VT'
                when state = 'Virginia'
                then 'VA'
                when state = 'Washington'
                then 'WA'
                when state = 'West Virginia'
                then 'WV'
                when state = 'Wisconsin'
                then 'WI'
                when state = 'Wyoming'
                then 'WY'
                when state = 'District of Columbia'
                then 'DC'
                else null
            end as state_abbr
        from source
    )

select
    dwh_id, row_id, order_id, order_date, state as state_full, state_abbr, etl_timestamp
from state_conversions
