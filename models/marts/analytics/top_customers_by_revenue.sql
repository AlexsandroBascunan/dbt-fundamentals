{{
  config(
    materialized='table',
    description='Top 3 corporate customers by Revenue per month in the last 3 months'
  )
}}

WITH last_3_months AS (
  SELECT DISTINCT month
  FROM {{ ref('fct_credits') }}
  ORDER BY month DESC
  LIMIT 3
),

org_revenue AS (
  SELECT
    fc.organization_id,
    fc.organization_name,
    fc.month,
    SUM(fc.revenue) AS total_revenue,
    RANK() OVER (PARTITION BY fc.month ORDER BY SUM(fc.revenue) DESC) AS rank
  FROM {{ ref('fct_credits') }} fc
  JOIN last_3_months l3m ON fc.month = l3m.month
  WHERE fc.status = 'Approved'
  GROUP BY 1, 2, 3
)

SELECT
  month,
  organization_id,
  organization_name,
  total_revenue,
  rank AS monthly_rank,
  CURRENT_TIMESTAMP() AS analysis_time
FROM org_revenue
WHERE rank <= 3