-- Q3: Monthly Net Revenue After Approved Returns
-- Purpose: Finance needs to understand true realized revenue after
-- subtracting approved refunds, and identify months with high return rates.
-- Scope: Completed orders only. Approved returns only.

SELECT
  DATE_TRUNC(DATE(o.order_date), MONTH)                   AS month_date, 
  FORMAT_TIMESTAMP('%B', CAST(o.order_date AS TIMESTAMP)) AS month,
  SUM(o.subtotal_idr)                                     AS gross_rev_idr,
  COALESCE(SUM(r.refund_amount_idr), 0)                   AS amount_returned_idr,
  SUM(o.subtotal_idr) - COALESCE(SUM(r.refund_amount_idr), 0) AS net_rev_idr,
  ROUND(COALESCE(SUM(r.refund_amount_idr), 0) 
    / SUM(o.subtotal_idr) * 100, 2) AS return_pct,
  COUNT(r.order_id) AS returned_orders
FROM nusantara_store.orders o
LEFT JOIN nusantara_store.returns r
  ON o.order_id = r.order_id
  AND r.return_status = 'approved'
WHERE o.order_status != 'cancelled'
GROUP BY 1, 2
ORDER BY 1