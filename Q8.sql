-- Q8: Repeat vs First-Time Customer Revenue Split (2024)
-- Purpose: Head of CRM wants to understand revenue contribution from
-- repeat customers vs first-time buyers to inform retention strategy.
-- Scope: Non-cancelled orders. Full year 2024.

WITH customer_label AS (
  SELECT
    customer_id,
    CASE
      WHEN COUNT(order_id) >= 2 THEN 'Repeat Customer'
      ELSE 'First Time Buyer'
    END AS customer_flag
  FROM nusantara_store.orders
  WHERE order_status != 'cancelled'
    AND EXTRACT(YEAR FROM CAST(order_date AS TIMESTAMP)) = 2024
  GROUP BY customer_id
)
SELECT
  cl.customer_flag,
  COUNT(DISTINCT o.customer_id)                          AS total_customers,
  SUM(o.subtotal_idr)                                    AS gross_rev_idr,
  ROUND(SUM(o.subtotal_idr)
    / SUM(SUM(o.subtotal_idr)) OVER () * 100, 2)        AS rev_pct
FROM nusantara_store.orders o
JOIN customer_label cl ON o.customer_id = cl.customer_id
WHERE o.order_status != 'cancelled'
  AND EXTRACT(YEAR FROM CAST(order_date AS TIMESTAMP)) = 2024
GROUP BY cl.customer_flag
ORDER BY gross_rev_idr DESC