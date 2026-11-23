
WITH source AS (

    SELECT *
    FROM {{ source('devflow_raw', 'api_usage') }}

),

cleaned AS (

    SELECT
        CAST(api_usage_id AS STRING) AS api_usage_id,

        CAST(user_id AS STRING) AS user_id,

        SAFE_CAST(request_timestamp AS TIMESTAMP) AS request_timestamp,

        TRIM(endpoint) AS endpoint,

        SAFE_CAST(request_count AS INT64) AS request_count,

        SAFE_CAST(success_count AS INT64) AS success_count,

        SAFE_CAST(error_count AS INT64) AS error_count,

        SAFE_CAST(response_time_ms AS FLOAT64) AS response_time_ms

    FROM source

)

SELECT *
FROM cleaned
