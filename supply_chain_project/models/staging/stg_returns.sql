SELECT
    return_id,
    order_id,
    return_date,
    reason
FROM {{ source('supply_chain_src','returns') }}

