{% snapshot snap_products %}

{{
config(
  target_schema='snapshots',
  unique_key='product_id',
  strategy='check',
  check_cols=['price','category']
)
}}

WITH products AS (

SELECT
    product_id,
    product_name,
    category,
    price
FROM {{ ref('stg_products') }}

),

ranked AS (

SELECT
    product_id,
    product_name,
    category,
    price,
    ROW_NUMBER() OVER(
        PARTITION BY product_id
        ORDER BY price DESC
    ) AS rn
FROM products

)

SELECT
product_id,
product_name,
category,
price
FROM ranked
WHERE rn = 1

{% endsnapshot %}