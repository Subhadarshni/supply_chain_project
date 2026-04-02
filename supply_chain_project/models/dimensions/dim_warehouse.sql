WITH warehouses AS (

    SELECT
        warehouse,
        updated_at
    FROM {{ ref('stg_inventory') }}

),

ranked AS (

    SELECT
        warehouse,
        updated_at,
        ROW_NUMBER() OVER(
            PARTITION BY warehouse
            ORDER BY updated_at DESC
        ) AS rn
    FROM warehouses

)

SELECT
warehouse,
updated_at
FROM ranked
WHERE rn = 1