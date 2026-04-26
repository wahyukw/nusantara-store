-- Q1: Full Year P&L Summary 2024 with USD Conversion
-- Purpose: CFO needs a single financial snapshot of realized revenue,
-- cost, and margin for completed orders only.
-- Exchange rate: 1 USD = Rp 15,750 (fixed, Dec 2024)

SELECT
  DATE_TRUNC(DATE(order_date), YEAR)               AS year,
  SUM(subtotal_idr)                                AS gross_revenue_idr,
  SUM(cogs_idr)                                    AS cogs_idr,
  SUM(gross_profit_idr)                            AS gross_profit_idr,
  ROUND(SUM(gross_profit_idr) / SUM(subtotal_idr) * 100, 2) AS profit_margin_pct,
  ROUND(SUM(subtotal_idr) / 15750, 2)              AS gross_revenue_usd,
  ROUND(SUM(cogs_idr) / 15750, 2)                  AS cogs_usd,
  ROUND(SUM(gross_profit_idr) / 15750, 2)          AS gross_profit_usd
FROM nusantara_store.orders
WHERE order_status = 'completed'
GROUP BY 1
ORDER BY 1