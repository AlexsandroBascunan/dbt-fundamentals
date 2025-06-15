{{
  config(
    materialized='view',
    schema='staging'
  )
}}

SELECT
  CAST(WALLET_ID AS STRING) AS wallet_id,
  NAME AS wallet_name,
  DESCRIPTION AS wallet_description
FROM {{ source('swile_core_raw', 'wallet') }}