{{
  config(
    materialized='table',
    partition_by={
      "field": "schedule_date",
      "data_type": "date",
      "granularity": "month"
    },
    cluster_by=["employee_id", "wallet_id", "organization_id"]
  )
}}

SELECT
  oci.order_credit_item_id,
  oci.order_credit_id,
  oci.employee_id,
  o.organization_id,
  o.organization_name,
  o.industry,
  org_monthly.org_size_category,
  org_monthly.revenue_rate,
  oci.wallet_id,
  w.wallet_name,
  oci.schedule_date,
  DATE_TRUNC(oci.schedule_date, MONTH) AS month,
  oci.status,
  oci.credited_value,
  CASE WHEN oci.status = 'Approved' THEN oci.credited_value ELSE 0 END AS tca,
  CASE WHEN oci.status = 'Approved' THEN oci.credited_value * org_monthly.revenue_rate ELSE 0 END AS revenue
FROM {{ ref('stg_order_credit_item') }} oci
LEFT JOIN {{ ref('stg_employee') }} e ON oci.employee_id = e.employee_id
LEFT JOIN {{ ref('stg_organization') }} o ON e.organization_id = o.organization_id
LEFT JOIN {{ ref('stg_wallet') }} w ON oci.wallet_id = w.wallet_id
LEFT JOIN {{ ref('int_monthly_org_metrics') }} org_monthly ON (
    o.organization_id = org_monthly.organization_id
    AND DATE_TRUNC(oci.schedule_date, MONTH) = org_monthly.month
)