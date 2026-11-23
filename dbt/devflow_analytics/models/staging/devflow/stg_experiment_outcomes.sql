
WITH source AS (

    SELECT *
    FROM {{ source('devflow_raw', 'experiment_outcomes') }}

),

cleaned AS (

    SELECT
        CAST(outcome_id AS STRING) AS outcome_id,

        CAST(assignment_id AS STRING) AS assignment_id,

        CAST(user_id AS STRING) AS user_id,

        SAFE_CAST(sdk_integrated AS INT64) AS sdk_integrated,

        SAFE_CAST(first_api_request AS INT64) AS first_api_request,

        SAFE_CAST(adopted_feature AS INT64) AS adopted_feature,

        SAFE_CAST(retained_d7 AS INT64) AS retained_d7,

        SAFE_CAST(measured_at AS TIMESTAMP) AS measured_at

    FROM source

)

SELECT *
FROM cleaned
