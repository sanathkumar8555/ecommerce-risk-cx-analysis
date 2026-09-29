USE ecommerce_risk_cx;

/* Q1: Delivery Status vs Review Score */

SELECT
    o.Delivery_Status,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(AVG(r.review_score), 2) AS avg_review_score
FROM orders o
JOIN reviews r
    ON o.order_id = r.order_id
WHERE o.Delivery_Status IN ('Early', 'On Time', 'Late')
GROUP BY o.Delivery_Status
ORDER BY avg_review_score DESC;

 /* Q2: Low-Rated Orders */

SELECT
    review_score,
    COUNT(DISTINCT order_id) AS low_rated_orders
FROM reviews
WHERE review_score IN (1, 2)
GROUP BY review_score
ORDER BY review_score;

 /* Q3: Review Score Distribution */

SELECT
    review_score,
    COUNT(DISTINCT order_id) AS orders
FROM reviews
GROUP BY review_score
ORDER BY review_score;