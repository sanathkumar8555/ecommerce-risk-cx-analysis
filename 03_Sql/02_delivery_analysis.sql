USE ecommerce_risk_cx;

/* Q1: Overall Late-Delivery Rate */

SELECT
    COUNT(*) AS delivered_orders,
    SUM(CASE
        WHEN Delivery_Status = 'Late' THEN 1
        ELSE 0
    END) AS late_orders,
    ROUND(
        100.0 * SUM(CASE
            WHEN Delivery_Status = 'Late' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS late_delivery_rate
FROM orders
WHERE Delivery_Status IN ('Early', 'On Time', 'Late');

/* Q2: Seller Delivery Performance */

SELECT
    oi.seller_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(DISTINCT CASE
        WHEN o.Delivery_Status = 'Late' THEN oi.order_id
    END) AS late_orders,
    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN o.Delivery_Status = 'Late' THEN oi.order_id
        END) / COUNT(DISTINCT oi.order_id),
        2
    ) AS late_delivery_rate
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.Delivery_Status IN ('Early', 'On Time', 'Late')
GROUP BY oi.seller_id
HAVING COUNT(DISTINCT oi.order_id) >= 50
ORDER BY late_delivery_rate DESC;

/* Q3: Category Delivery Performance */

SELECT
    p.product_category_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(DISTINCT CASE
        WHEN o.Delivery_Status = 'Late' THEN oi.order_id
    END) AS late_orders,
    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN o.Delivery_Status = 'Late' THEN oi.order_id
        END) / COUNT(DISTINCT oi.order_id),
        2
    ) AS late_delivery_rate
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.Delivery_Status IN ('Early', 'On Time', 'Late')
  AND p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING COUNT(DISTINCT oi.order_id) >= 100
ORDER BY late_delivery_rate DESC;

/* Q4: Freight vs Delivery Performance */

WITH order_freight AS (
    SELECT
        order_id,
        SUM(freight_value) AS total_freight
    FROM order_items
    GROUP BY order_id
)
SELECT
    CASE
        WHEN f.total_freight < 20 THEN 'Under 20'
        WHEN f.total_freight < 50 THEN '20-49'
        WHEN f.total_freight < 100 THEN '50-99'
        ELSE '100+'
    END AS freight_bucket,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT CASE
        WHEN o.Delivery_Status = 'Late' THEN o.order_id
    END) AS late_orders,
    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN o.Delivery_Status = 'Late' THEN o.order_id
        END) / COUNT(DISTINCT o.order_id),
        2
    ) AS late_delivery_rate
FROM orders o
JOIN order_freight f
    ON o.order_id = f.order_id
WHERE o.Delivery_Status IN ('Early', 'On Time', 'Late')
GROUP BY freight_bucket
ORDER BY
    CASE freight_bucket
        WHEN 'Under 20' THEN 1
        WHEN '20-49' THEN 2
        WHEN '50-99' THEN 3
        WHEN '100+' THEN 4
    END;