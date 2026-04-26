-- Q9: Top 10 Cities by Gross Revenue and Unique Customers (2024)
-- Purpose: Regional Manager wants to identify highest revenue cities
-- to prioritize regional marketing and logistics investment.
-- Scope: Non-cancelled orders. Full year 2024.

SELECT
  c.city,
  c.province,
  COUNT(DISTINCT o.customer_id)  AS unique_customers,
  COUNT(o.order_id)              AS total_orders,
  SUM(o.subtotal_idr)            AS gross_rev_idr
FROM nusantara_store.orders o
JOIN nusantara_store.customers c ON o.customer_id = c.customer_id
WHERE o.order_status != 'cancelled'
  AND EXTRACT(YEAR FROM CAST(o.order_date AS TIMESTAMP)) = 2024
GROUP BY 1, 2
ORDER BY gross_rev_idr DESC
LIMIT 10