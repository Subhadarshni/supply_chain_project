{{ config(materialized='incremental', unique_key='return_id') }}

WITH returns AS (

    SELECT
        return_id,
        order_id,
        return_date,
        reason
    FROM {{ ref('stg_returns') }}

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
    r.return_id,
    r.order_id,
    o.product_id,
    p.product_name,
    p.category,
    r.return_date,
    r.reason
FROM returns r
LEFT JOIN orders o
    ON r.order_id = o.order_id
LEFT JOIN products p
    ON o.product_id = p.product_id

)

SELECT * FROM final

{% if is_incremental() %}

WHERE return_date > (SELECT MAX(return_date) FROM {{ this }})

{% endif %}