{{ config(materialized='incremental', unique_key='shipment_id') }}

WITH shipments AS (

    SELECT
        shipment_id,
        order_id,
        shipment_date,
        carrier,
        delivery_status
    FROM {{ ref('stg_shipments') }}

),

orders AS (

    SELECT
        order_id,
        product_id,
        order_date
    FROM {{ ref('stg_orders') }}

),

products AS (

    SELECT
        product_id,
        product_name,
        category
    FROM {{ ref('dim_products') }}

),

final AS (

SELECT
    s.shipment_id,
    s.order_id,
    o.product_id,
    p.product_name,
    p.category,
    s.shipment_date,
    s.carrier,
    CASE 
        WHEN LOWER(s.delivery_status) = 'delivered' THEN 'delivered'
        WHEN LOWER(s.delivery_status) = 'in transit' THEN 'shipped'
        WHEN LOWER(s.delivery_status) = 'delayed' THEN 'pending'
    END AS delivery_status
FROM shipments s
LEFT JOIN orders o
    ON s.order_id = o.order_id
LEFT JOIN products p
    ON o.product_id = p.product_id

)

SELECT * FROM final

{% if is_incremental() %}

WHERE shipment_date > (SELECT MAX(shipment_date) FROM {{ this }})

{% endif %}
