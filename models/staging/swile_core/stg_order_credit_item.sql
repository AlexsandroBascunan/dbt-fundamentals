{{
  config(
    materialized='view',
    schema='staging'
  )
}}

SELECT
  CAST(ORDER_CREDIT_ITEM_ID AS STRING) AS order_credit_item_id,
  CAST(ORDER_CREDIT_ID AS STRING) AS order_credit_id,
  CAST(ID_EMPLOYEE AS STRING) AS employee_id,
  DT_SCHEDULE AS schedule_date,
  STATUS AS status,
  TOTAL_CREDITED_VALUE AS credited_value,
  CAST(WALLET_ID AS STRING) AS wallet_id
FROM {{ source('swile_core_raw', 'order_credit_item') }}