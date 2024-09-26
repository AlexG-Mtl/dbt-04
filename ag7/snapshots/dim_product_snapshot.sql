{% snapshot dim_product_snapshot %}
    {{
        config(
            target_schema="stg",
            unique_key="product_id",
            strategy="check",
            check_cols=["product_name", "category", "sub_category"],
        )
    }}

    select product_id, product_name, category, sub_category, etl_timestamp  -- Any other columns you want to track
    from {{ ref("dim_product") }}  -- Replace this with the actual source table
{% endsnapshot %}
