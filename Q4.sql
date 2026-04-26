-- Q4: Top 10 Best Selling Products by Revenue (Q4 2024)
-- Purpose: Head of Product wants to identify top performers by revenue,
-- units sold, and margin to inform inventory and production decisions.
-- Scope: Completed orders only. Triple join to get order date context.

SELECT
  p.product_name,
  p.category,
  SUM(oi.quantity)                                              AS units_sold,
  SUM(oi.line_total_idr)                                       AS gross_revenue_idr,
  SUM(oi.cogs_idr)                                             AS total_cogs_idr,
  ROUND((SUM(oi.line_total_idr) - SUM(oi.cogs_idr)) 
    / SUM(oi.line_total_idr) * 100, 2)                         AS margin_pct
FROM nusantara_store.orders o
JOIN nusantara_store.order_items oi ON o.order_id = oi.order_id
JOIN nusantara_store.products p ON oi.product_id = p.product_id
WHERE o.order_status != 'cancelled'
  AND EXTRACT(YEAR FROM CAST(o.order_date AS TIMESTAMP)) = 2024 -- Filter based on year
  AND EXTRACT(MONTH FROM CAST(o.order_date AS TIMESTAMP)) IN (10, 11, 12) -- Filter based on month
GROUP BY p.product_name, p.category
ORDER BY gross_revenue_idr DESC
LIMIT 10