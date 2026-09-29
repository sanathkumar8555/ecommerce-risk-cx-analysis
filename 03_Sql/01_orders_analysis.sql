USE ecommerce_risk_cx;

/* Q1: Order Status Distribution */

SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;

/* Q2: Monthly Order Exceptions */

SELECT
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month,
    order_status,
    COUNT(*) AS order_count
FROM orders
WHERE order_status IN ('canceled', 'unavailable')
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp),
    order_status
ORDER BY
    order_year,
    order_month,
    order_status;

/* Q3: Monthly Order Exception Rate */

SELECT
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN order_status IN ('canceled', 'unavailable') THEN 1
            ELSE 0
        END
    ) AS exception_orders,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN order_status IN ('canceled', 'unavailable') THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS exception_rate
FROM orders
GROUP BY
    YEAR(order_purchase_timestamp),
    MONTH(order_purchase_timestamp)
ORDER BY
    order_year,
    order_month;