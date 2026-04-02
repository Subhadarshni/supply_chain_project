SELECT
    product_id,
    product_name,
    category,
    price
FROM {{ source('supply_chain_src','products') }}

