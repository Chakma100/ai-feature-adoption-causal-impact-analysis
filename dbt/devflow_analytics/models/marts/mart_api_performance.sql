
WITH api_performance AS (

    SELECT
        endpoint,
        total_api_records,
        total_users,
        total_requests,
        successful_requests,
        failed_requests,
        error_rate_percentage,
        average_response_time_ms,
        maximum_response_time_ms

    FROM {{ ref('int_api_performance') }}

),

final AS (

    SELECT
        endpoint,

        total_api_records,

        total_users,

        total_requests,

        successful_requests,

        failed_requests,

        error_rate_percentage,

        ROUND(
            SAFE_DIVIDE(
                successful_requests,
                total_requests
            ) * 100,
            2
        ) AS success_rate_percentage,

        average_response_time_ms,

        maximum_response_time_ms,

        DENSE_RANK() OVER (
            ORDER BY error_rate_percentage DESC
        ) AS error_rate_rank,

        DENSE_RANK() OVER (
            ORDER BY average_response_time_ms DESC
        ) AS response_time_rank,

        CASE
            WHEN error_rate_percentage >= 10
                THEN 'Critical'

            WHEN error_rate_percentage >= 5
                THEN 'Needs Improvement'

            ELSE 'Healthy'
        END AS api_health_status

    FROM api_performance

)

SELECT *
FROM final
