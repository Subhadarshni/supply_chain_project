WITH products AS (

    SELECT
        product_id,
        product_name,
        category,
        price
    FROM {{ ref('stg_products') }}

),

deduplicated AS (

    SELECT
        product_id,
        product_name,
        category,
        price,
        ROW_NUMBER() OVER(
            PARTITION BY product_id
            ORDER BY product_name
        ) AS rn
    FROM products

)

SELECT
product_id,
product_name,
category,
price
FROM deduplicated
WHERE rn = 1