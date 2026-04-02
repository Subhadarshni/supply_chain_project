{{ config(materialized='incremental', unique_key='inventory_id') }}

WITH inventory AS (

    SELECT
        inventory_id,
        product_id,
        warehouse,
        stock_qty,
        updated_at
    FROM {{ ref('stg_inventory') }}

),

products AS (

    SELECT
        product_id,
        product_name,
        category
    FROM {{ ref('dim_products') }}

),

warehouse AS (

    SELECT
        warehouse
    FROM {{ ref('dim_warehouse') }}

),

final AS (

SELECT
    i.inventory_id,
    i.product_id,
    p.product_name,
    p.category,
    i.warehouse,
    i.stock_qty,
    i.updated_at
FROM inventory i
LEFT JOIN products p
    ON i.product_id = p.product_id
LEFT JOIN warehouse w
    ON i.warehouse = w.warehouse

)

SELECT * FROM final

{% if is_incremental() %}

WHERE updated_at > (SELECT MAX(updated_at) FROM {{ this }})

{% endif %}