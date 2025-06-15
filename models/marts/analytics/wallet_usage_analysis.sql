{{
  config(
    materialized='table',
    description='The most used wallets in number of approved orders and their TCA per month'
  )
}}

SELECT
  wallet_id,
  wallet_name,
  month,
  COUNT(DISTINCT order_credit_id) AS approved_orders_count,
  COUNT(DISTINCT order_credit_item_id) AS approved_orders_items_count,
  SUM(tca) AS total_credited_amount,
  RANK() OVER (PARTITION BY month ORDER BY COUNT(DISTINCT order_credit_id) DESC) AS monthly_orders_rank,
  CURRENT_TIMESTAMP() AS analysis_time
FROM {{ ref('fct_credits') }}
WHERE status = 'Approved'
GROUP BY 1, 2, 3