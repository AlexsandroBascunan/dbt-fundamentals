{{
  config(
    materialized='table'
  )
}}

WITH monthly_credited_employees AS (
  SELECT
    o.organization_id,
    DATE_TRUNC(oci.schedule_date, MONTH) AS month,
    COUNT(DISTINCT oci.employee_id) AS credited_employees_count
  FROM {{ ref('stg_order_credit_item') }} oci
  JOIN {{ ref('stg_employee') }} e ON oci.employee_id = e.employee_id
  JOIN {{ ref('stg_organization') }} o ON e.organization_id = o.organization_id
  WHERE oci.status = 'Approved'
  GROUP BY 1, 2
)

SELECT
  *,
  CASE
    WHEN credited_employees_count > 800 THEN 'Large'
    WHEN credited_employees_count > 100 THEN 'Medium'
    ELSE 'Small'
  END AS org_size_category,
  CASE
    WHEN credited_employees_count > 800 THEN 0.0070
    WHEN credited_employees_count > 100 THEN 0.0075
    ELSE 0.0090
  END AS revenue_rate
FROM monthly_credited_employees