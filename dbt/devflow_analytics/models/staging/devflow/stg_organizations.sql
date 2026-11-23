
WITH source AS (

    SELECT *
    FROM {{ source('devflow_raw', 'organizations') }}

),

cleaned AS (

    SELECT
        CAST(organization_id AS STRING) AS organization_id,

        TRIM(organization_name) AS organization_name,

        TRIM(industry) AS industry,

        TRIM(company_size) AS company_size,

        SAFE_CAST(created_date AS DATE) AS created_date,

        UPPER(TRIM(country)) AS country

    FROM source

)

SELECT *
FROM cleaned
