-- Q2: Monthly Revenue Trend 2024 with Above/Below Average Flag
-- Purpose: CEO wants to identify which months are outperforming or
-- underperforming relative to the annual monthly average.
-- Scope: Completed orders only. Revenue = subtotal_idr (excludes shipping).

SELECT
  -- Returns the first of the month as a Date object (YYYY-MM-01)
  DATE_TRUNC(DATE(order_date), MONTH) AS month_date, 
  SUM(subtotal_idr)                                   AS monthly_rev,
  CAST(AVG(SUM(subtotal_idr)) OVER () AS INT64)       AS avg_monthly_rev,
  CASE
    WHEN SUM(subtotal_idr) > AVG(SUM(subtotal_idr)) OVER () THEN 'Above Average'
    ELSE 'Below Average'
  END                                                 AS performance_flag
FROM nusantara_store.orders
WHERE
  EXTRACT(YEAR FROM CAST(order_date AS TIMESTAMP)) = 2024
  AND order_status = 'completed'
GROUP BY 1  -- Groups by the first column (month_date)
ORDER BY 1