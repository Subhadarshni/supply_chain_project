{% snapshot snap_inventory %}

{{
config(
  target_schema='snapshots',
  unique_key='inventory_id',
  strategy='check',
  check_cols=['stock_qty']
)
}}

WITH inventory AS (

SELECT
    inventory_id,
    product_id,
    warehouse,
    stock_qty,
    updated_at
FROM {{ ref('stg_inventory') }}

),

ranked AS (

SELECT
    inventory_id,
    product_id,
    warehouse,
    stock_qty,
    updated_at,
    ROW_NUMBER() OVER(
        PARTITION BY product_id
        ORDER BY updated_at DESC
    ) AS rn
FROM inventory

)

SELECT
inventory_id,
product_id,
warehouse,
stock_qty,
updated_at
FROM ranked

{% endsnapshot %}