SELECT
    shipment_id,
    order_id,
    shipment_date,
    carrier,
    delivery_status
    
FROM {{ source('supply_chain_src','shipments') }}



