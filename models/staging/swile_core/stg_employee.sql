{{
  config(
    materialized='view',
    schema='staging'
  )
}}

SELECT
  CAST(ID_EMPLOYEE AS STRING) AS employee_id,
  CAST(ORGANIZATION_ID AS STRING) AS organization_id,
  EMPLOYEE_GENDER AS gender,
  EMPLOYEE_MOBILE_APP AS mobile_app
FROM {{ source('swile_core_raw', 'employee') }}