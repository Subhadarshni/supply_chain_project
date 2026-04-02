


-- =========================================================
-- 1. Top Selling Products
-- =========================================================

SELECT
    product_id,
    SUM(quantity) AS total_quantity_sold,
    RANK() OVER (ORDER BY SUM(quantity) DESC) AS product_rank
FROM {{ ref('fact_orders') }}
GROUP BY product_id
ORDER BY product_rank;



-- =========================================================
-- 2. Order Growth Trend (Running Total)
-- =========================================================

SELECT
    order_date,
    COUNT(order_id) AS daily_orders,
    SUM(COUNT(order_id)) OVER (
        ORDER BY order_date
    ) AS cumulative_orders
FROM {{ ref('fact_orders') }}
GROUP BY order_date
ORDER BY order_date;



-- =========================================================
-- 3. Shipment Carrier Performance
-- =========================================================

SELECT
    carrier,
    COUNT(shipment_id) AS total_shipments,
    RANK() OVER (
        ORDER BY COUNT(shipment_id) DESC
    ) AS carrier_rank
FROM {{ ref('fact_shipments') }}
GROUP BY carrier
ORDER BY carrier_rank;



-- =========================================================
-- 4. Inventory Ranking by Warehouse
-- =========================================================

SELECT
    warehouse,
    product_id,
    stock_qty,
    RANK() OVER (
        PARTITION BY warehouse
        ORDER BY stock_qty DESC
    ) AS stock_rank
FROM {{ ref('fact_inventory') }}
ORDER BY warehouse, stock_rank;



-- =========================================================
-- 5. Latest Shipment Status Per Order
-- =========================================================

SELECT *
FROM (
    SELECT
        order_id,
        shipment_date,
        delivery_status,
        ROW_NUMBER() OVER (
            PARTITION BY order_id
            ORDER BY shipment_date DESC
        ) AS rn
    FROM {{ ref('fact_shipments') }}
)
WHERE rn = 1;


-------------------------------
--Moving Average Sales
---------------------------------

SELECT
order_date,
SUM(quantity) AS daily_sales,
AVG(SUM(quantity)) OVER (
ORDER BY order_date
ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
) AS moving_avg_7_days
FROM {{ ref('fact_orders') }}
GROUP BY order_date;