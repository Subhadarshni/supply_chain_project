{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

WITH orders_cte AS (

    SELECT
        order_id,
        product_id,
        customer_id,
        order_date,
        quantity,
        order_status
    FROM {{ ref('stg_orders') }}

)

SELECT
    order_id,
    product_id,
    customer_id,
    order_date,
    quantity,
    order_status
FROM orders_cte

{% if is_incremental() %}

WHERE order_date > (SELECT MAX(order_date) FROM {{ this }})

{% endif %}