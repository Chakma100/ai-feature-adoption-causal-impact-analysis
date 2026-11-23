
WITH source AS (

    SELECT *
    FROM {{ source('devflow_raw', 'product_events') }}

),

cleaned AS (

    SELECT
        CAST(event_id AS STRING) AS event_id,

        CAST(user_id AS STRING) AS user_id,

        TRIM(event_name) AS event_name,

        SAFE_CAST(event_timestamp AS TIMESTAMP) AS event_timestamp,

        CAST(session_id AS STRING) AS session_id,

        TRIM(platform) AS platform,

        TRIM(device_type) AS device_type,

        event_properties

    FROM source

)

SELECT *
FROM cleaned
