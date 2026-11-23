
WITH source AS (

    SELECT *
    FROM {{ source('devflow_raw', 'users') }}

),

cleaned AS (

    SELECT
        CAST(user_id AS STRING) AS user_id,

        CAST(organization_id AS STRING) AS organization_id,

        SAFE_CAST(signup_date AS DATE) AS signup_date,

        UPPER(TRIM(country)) AS country,

        TRIM(user_role) AS user_role,

        TRIM(acquisition_channel) AS acquisition_channel,

        SAFE_CAST(is_verified AS INT64) AS is_verified

    FROM source

)

SELECT *
FROM cleaned
