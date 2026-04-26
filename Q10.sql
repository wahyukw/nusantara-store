-- Q10: Payment Method Performance by Orders, Revenue, and AOV (2024)
-- Purpose: COO wants to understand payment method preferences to optimize
-- checkout experience and negotiate better rates with payment providers.
-- Scope: Non-cancelled orders. Full year 2024.

SELECT
  payment_method,
  COUNT(DISTINCT order_id)                               AS total_orders,
  SUM(subtotal_idr)                                      AS gross_rev_idr,
  ROUND(SUM(subtotal_idr)
    / SUM(SUM(subtotal_idr)) OVER () * 100, 2)          AS rev_contribution_pct,
  CAST(SUM(subtotal_idr) / COUNT(order_id) AS INT64)    AS aov_idr
FROM nusantara_store.orders
WHERE order_status != 'cancelled'
  AND EXTRACT(YEAR FROM CAST(order_date AS TIMESTAMP)) = 2024
GROUP BY 1
ORDER BY rev_contribution_pct DESC