-- Q6: Revenue and Order Contribution by Sales Channel (2024)
-- Purpose: Head of Marketing wants to know which sales channels drive
-- the most revenue and orders to inform channel investment decisions.
-- Scope: All non-cancelled orders. Full year 2024.

SELECT
  channel,
  COUNT(order_id)                                          AS total_orders,
  SUM(subtotal_idr)                                        AS gross_rev_idr,
  ROUND(SUM(subtotal_idr)
    / SUM(SUM(subtotal_idr)) OVER () * 100, 2)            AS rev_contribution_pct
FROM nusantara_store.orders
WHERE order_status != 'cancelled'
  AND EXTRACT(YEAR FROM CAST(order_date AS TIMESTAMP)) = 2024
GROUP BY channel
ORDER BY gross_rev_idr DESC