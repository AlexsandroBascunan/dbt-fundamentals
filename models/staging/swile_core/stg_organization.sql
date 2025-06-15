{{
  config(
    materialized='view',
    schema='staging'
  )
}}

SELECT
  CAST(ORGANIZATION_ID AS STRING) AS organization_id,
  ORGANIZATION_NAME AS organization_name,
  ORGANIZATION_INDUSTRY AS industry
FROM {{ source('swile_core_raw', 'organization') }}