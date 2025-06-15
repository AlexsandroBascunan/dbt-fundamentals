{{
  config(
    materialized='table',
    description='The month-over-month revenue growth rate for Swile'
  )
}}

WITH monthly_revenue AS (
  SELECT
    month,
    SUM(revenue) AS total_revenue
  FROM {{ ref('fct_credits') }}
  WHERE status = 'Approved'
  GROUP BY 1
),

revenue_with_growth AS (
  SELECT
    month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY month) AS previous_month_revenue
  FROM monthly_revenue
)

SELECT
  month,
  total_revenue,
  previous_month_revenue,
  ROUND(SAFE_DIVIDE((total_revenue - previous_month_revenue), previous_month_revenue) * 100, 2) AS growth_rate_pct,
  CURRENT_TIMESTAMP() AS analysis_time
FROM revenue_with_growth
WHERE previous_month_revenue IS NOT NULL