-- Q7: Campaign Performance vs Non-Campaign Orders (2024)
-- Purpose: Marketing Manager wants to evaluate which campaigns drove
-- the most revenue and orders, and compare against non-campaign baseline.
-- Scope: All non-cancelled orders. Full year 2024.

SELECT
  COALESCE(c.campaign_name, 'No Campaign')              AS campaign_name,
  COUNT(o.order_id)                                     AS total_orders,
  SUM(o.subtotal_idr)                                   AS gross_rev_idr,
  CAST(SUM(o.subtotal_idr) / COUNT(o.order_id) AS INT64) AS aov_idr
FROM nusantara_store.orders o
LEFT JOIN nusantara_store.campaigns c ON o.campaign_id = c.campaign_id
WHERE o.order_status != 'cancelled'
  AND EXTRACT(YEAR FROM CAST(o.order_date AS TIMESTAMP)) = 2024
GROUP BY COALESCE(c.campaign_name, 'No Campaign')
ORDER BY gross_rev_idr DESC