SELECT
    inventory_id,
    product_id,
    warehouse,
    stock_qty,
    updated_at
FROM {{ source('supply_chain_src','inventory') }}


