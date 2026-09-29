/* Q1: Multi-Factor Seller Risk Analysis */

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
    ) AS late_delivery_rate,

    COUNT(DISTINCT CASE
        WHEN r.review_score IN (1, 2) THEN r.order_id
    END) AS low_rated_orders

FROM order_items oi

JOIN orders o
    ON oi.order_id = o.order_id

LEFT JOIN reviews r
    ON oi.order_id = r.order_id

WHERE o.Delivery_Status IN ('Early', 'On Time', 'Late')

GROUP BY oi.seller_id

HAVING COUNT(DISTINCT oi.order_id) >= 100

   AND (
       100.0 * COUNT(DISTINCT CASE
           WHEN o.Delivery_Status = 'Late' THEN oi.order_id
       END) / COUNT(DISTINCT oi.order_id)
   ) > 6.77

   AND COUNT(DISTINCT CASE
       WHEN r.review_score IN (1, 2) THEN r.order_id
   END) >= 20

ORDER BY
    late_delivery_rate DESC;


/* Q2: Multi-Factor Seller Ranking */

WITH seller_metrics AS (
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
        ) AS late_delivery_rate,

        COUNT(DISTINCT CASE
            WHEN r.review_score IN (1, 2) THEN r.order_id
        END) AS low_rated_orders

    FROM order_items oi

    JOIN orders o
        ON oi.order_id = o.order_id

    LEFT JOIN reviews r
        ON oi.order_id = r.order_id

    WHERE o.Delivery_Status IN ('Early', 'On Time', 'Late')

    GROUP BY oi.seller_id

    HAVING COUNT(DISTINCT oi.order_id) >= 100

       AND (
           100.0 * COUNT(DISTINCT CASE
               WHEN o.Delivery_Status = 'Late' THEN oi.order_id
           END) / COUNT(DISTINCT oi.order_id)
       ) > 6.77

       AND COUNT(DISTINCT CASE
           WHEN r.review_score IN (1, 2) THEN r.order_id
       END) >= 20
)

SELECT
    seller_id,
    total_orders,
    late_orders,
    late_delivery_rate,
    low_rated_orders,

    RANK() OVER (
        ORDER BY late_orders DESC
    ) AS late_order_rank,

    RANK() OVER (
        ORDER BY low_rated_orders DESC
    ) AS low_rating_rank

FROM seller_metrics

ORDER BY late_order_rank;


/* Q3: Final Seller-Category Investigation */

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
    ) AS late_delivery_rate,

    COUNT(DISTINCT CASE
        WHEN r.review_score IN (1, 2) THEN r.order_id
    END) AS low_rated_orders

FROM order_items oi

JOIN orders o
    ON oi.order_id = o.order_id

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN reviews r
    ON oi.order_id = r.order_id

WHERE o.Delivery_Status IN ('Early', 'On Time', 'Late')
  AND p.product_category_name IS NOT NULL

GROUP BY
    oi.seller_id,
    p.product_category_name

HAVING COUNT(DISTINCT oi.order_id) >= 50

   AND COUNT(DISTINCT CASE
       WHEN o.Delivery_Status = 'Late' THEN oi.order_id
   END) >= 10

   AND COUNT(DISTINCT CASE
       WHEN r.review_score IN (1, 2) THEN r.order_id
   END) >= 10

ORDER BY
    late_orders DESC,
    low_rated_orders DESC;