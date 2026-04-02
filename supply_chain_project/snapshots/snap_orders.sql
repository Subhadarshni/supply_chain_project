{% snapshot snap_orders %}

{{
config(
  target_schema='snapshots',
  unique_key='order_id',
  strategy='check',
  check_cols=['order_status']
)
}}

WITH orders AS (

SELECT
    order_id,
    product_id,
    customer_id,
    order_date,
    quantity,
    order_status
FROM {{ ref('stg_orders') }}

),

ranked AS (

SELECT
    order_id,
    product_id,
    customer_id,
    order_date,
    quantity,
    order_status,
    ROW_NUMBER() OVER(
        PARTITION BY order_id
        ORDER BY order_date DESC
    ) AS rn
FROM orders

)

SELECT
order_id,
product_id,
customer_id,
order_date,
quantity,
order_status
FROM ranked

{% endsnapshot %}