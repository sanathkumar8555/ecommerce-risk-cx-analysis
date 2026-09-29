 /* Q1: High-Risk Seller Patterns */

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
HAVING COUNT(DISTINCT oi.order_id) >= 100
   AND (
       100.0 * COUNT(DISTINCT CASE
           WHEN o.Delivery_Status = 'Late' THEN oi.order_id
       END) / COUNT(DISTINCT oi.order_id)
   ) > 6.77
ORDER BY late_delivery_rate DESC;

/* Q2: Product Category Risk Patterns */

SELECT
    p.product_category_name,
    COUNT(DISTINCT r.order_id) AS reviewed_orders,
    COUNT(DISTINCT CASE
        WHEN r.review_score IN (1, 2) THEN r.order_id
    END) AS low_rated_orders,
    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN r.review_score IN (1, 2) THEN r.order_id
        END) / COUNT(DISTINCT r.order_id),
        2
    ) AS low_rating_rate
FROM reviews r
JOIN order_items oi
    ON r.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NOT NULL
GROUP BY p.product_category_name
HAVING COUNT(DISTINCT r.order_id) >= 100
ORDER BY low_rating_rate DESC;

/* Q3: Seller + Category Risk Analysis */

SELECT
    oi.seller_id,
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
GROUP BY
    oi.seller_id,
    p.product_category_name
HAVING COUNT(DISTINCT oi.order_id) >= 50
ORDER BY late_delivery_rate DESC;

