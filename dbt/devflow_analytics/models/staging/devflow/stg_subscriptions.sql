
WITH source AS (

    SELECT *
    FROM {{ source('devflow_raw', 'subscriptions') }}

),

cleaned AS (

    SELECT
        CAST(subscription_id AS STRING) AS subscription_id,

        CAST(organization_id AS STRING) AS organization_id,

        TRIM(plan_type) AS plan_type,

        SAFE_CAST(start_date AS DATE) AS start_date,

        SAFE_CAST(end_date AS DATE) AS end_date,

        SAFE_CAST(monthly_price AS NUMERIC) AS monthly_price,

        TRIM(subscription_status) AS subscription_status

    FROM source

)

SELECT *
FROM cleaned
