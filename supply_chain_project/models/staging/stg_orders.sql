{# {{ config(materialized='table') }} #}

SELECT
    order_id,
    product_id,
    customer_id,
    order_date,
    quantity,
    LOWER(order_status) AS order_status
FROM {{ source('supply_chain_src','orders') }}