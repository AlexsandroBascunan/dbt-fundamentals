{{
  config(
    materialized='table',
    description='The top 3 corporate customers by TCA per month'
  )
}}

WITH monthly_tca AS (
  SELECT
    organization_id,
    organization_name,
    month,
    SUM(tca) AS total_credited_amount,
    RANK() OVER (PARTITION BY month ORDER BY SUM(tca) DESC) AS rank
  FROM {{ ref('fct_credits') }}
  WHERE status = 'Approved'
  GROUP BY 1, 2, 3
)

SELECT
  month,
  organization_id,
  organization_name,
  total_credited_amount,
  rank AS monthly_rank,
  CURRENT_TIMESTAMP() AS analysis_time
FROM monthly_tca
WHERE rank <= 3