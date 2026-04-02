WITH dates AS (

    SELECT DISTINCT
        order_date AS date
    FROM {{ ref('stg_orders') }}

)

SELECT
date,
YEAR(date) AS year,
MONTH(date) AS month,
DAY(date) AS day,
QUARTER(date) AS quarter,
DAYOFWEEK(date) AS weekday
FROM dates