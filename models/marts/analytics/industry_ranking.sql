{{
  config(
    materialized='table',
    description='The top industries by number of organizations'
  )
}}

SELECT
  industry,
  COUNT(DISTINCT organization_id) AS organization_count,
  RANK() OVER (ORDER BY COUNT(DISTINCT organization_id) DESC) AS industry_rank,
  CURRENT_TIMESTAMP() AS analysis_time
FROM {{ ref('fct_credits') }}
GROUP BY 1