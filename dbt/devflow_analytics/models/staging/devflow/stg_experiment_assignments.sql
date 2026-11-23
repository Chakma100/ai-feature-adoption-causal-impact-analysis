
WITH source AS (

    SELECT *
    FROM {{ source('devflow_raw', 'experiment_assignments') }}

),

cleaned AS (

    SELECT
        CAST(assignment_id AS STRING) AS assignment_id,

        TRIM(experiment_id) AS experiment_id,

        CAST(user_id AS STRING) AS user_id,

        TRIM(variant) AS variant,

        SAFE_CAST(assigned_at AS TIMESTAMP) AS assigned_at

    FROM source

)

SELECT *
FROM cleaned
