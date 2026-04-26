-- Q5: Revenue, Units, Margin, and Return Rate by Product Category (Q4 2024)
-- Purpose: Category Manager wants to identify the most profitable categories
-- and flag those with high return rates for operational review.
-- Scope: Completed and returned orders. Approved returns only. Q4 2024.

SELECT
  p.category,
  SUM(oi.quantity)                                               AS total_units_sold,
  SUM(oi.line_total_idr)                                         AS gross_rev_idr,
  ROUND((SUM(oi.line_total_idr) - SUM(oi.cogs_idr))
    / SUM(oi.line_total_idr) * 100, 2)                          AS avg_margin_pct,
  ROUND(COALESCE(SUM(r.refund_amount_idr), 0)
    / SUM(oi.line_total_idr) * 100, 2)                          AS return_rate_pct
FROM nusantara_store.orders o
JOIN nusantara_store.order_items oi ON o.order_id = oi.order_id
JOIN nusantara_store.products p ON oi.product_id = p.product_id
LEFT JOIN nusantara_store.returns r
  ON o.order_id = r.order_id
  AND r.return_status = 'approved'
WHERE o.order_status != 'cancelled'
  AND EXTRACT(YEAR FROM CAST(o.order_date AS TIMESTAMP)) = 2024
  AND EXTRACT(MONTH FROM CAST(o.order_date AS TIMESTAMP)) IN (10, 11, 12)
GROUP BY p.category
ORDER BY gross_rev_idr DESC