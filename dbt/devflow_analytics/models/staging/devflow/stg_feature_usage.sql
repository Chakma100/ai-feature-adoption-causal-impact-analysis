
WITH source AS (

    SELECT *
    FROM {{ source('devflow_raw', 'feature_usage') }}

),

cleaned AS (

    SELECT
        CAST(usage_id AS STRING) AS usage_id,

        CAST(user_id AS STRING) AS user_id,

        TRIM(feature_name) AS feature_name,

        SAFE_CAST(first_used_at AS TIMESTAMP) AS first_used_at,

        SAFE_CAST(usage_count AS INT64) AS usage_count,

        SAFE_CAST(last_used_at AS TIMESTAMP) AS last_used_at

    FROM source

)

SELECT *
FROM cleaned
