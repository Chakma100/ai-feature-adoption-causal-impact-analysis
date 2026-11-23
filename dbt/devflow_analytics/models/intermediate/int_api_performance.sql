
WITH api_usage AS (

    SELECT
        api_usage_id,
        user_id,
        request_timestamp,
        endpoint,
        request_count,
        success_count,
        error_count,
        response_time_ms

    FROM {{ ref('stg_api_usage') }}

),

endpoint_performance AS (

    SELECT
        endpoint,

        COUNT(*) AS total_api_records,

        COUNT(DISTINCT user_id) AS total_users,

        SUM(request_count) AS total_requests,

        SUM(success_count) AS successful_requests,

        SUM(error_count) AS failed_requests,

        AVG(response_time_ms) AS average_response_time_ms,

        MAX(response_time_ms) AS maximum_response_time_ms

    FROM api_usage

    GROUP BY endpoint

)

SELECT
    endpoint,

    total_api_records,

    total_users,

    total_requests,

    successful_requests,

    failed_requests,

    ROUND(
        SAFE_DIVIDE(
            failed_requests,
            total_requests
        ) * 100,
        2
    ) AS error_rate_percentage,

    ROUND(average_response_time_ms, 2)
        AS average_response_time_ms,

    maximum_response_time_ms

FROM endpoint_performance
