
WITH daily_activity AS (

    SELECT
        user_id,
        activity_date,
        total_events,
        total_sessions,
        total_api_requests,

        successful_requests AS successful_api_requests,

        failed_requests AS failed_api_requests

    FROM {{ ref('int_user_activity') }}

),

user_engagement AS (

    SELECT
        user_id,

        COUNT(DISTINCT activity_date) AS active_days,

        SUM(total_events) AS total_events,

        SUM(total_sessions) AS total_sessions,

        SUM(total_api_requests) AS total_api_requests,

        SUM(successful_api_requests) AS successful_api_requests,

        SUM(failed_api_requests) AS failed_api_requests,

        MIN(activity_date) AS first_activity_date,

        MAX(activity_date) AS last_activity_date

    FROM daily_activity

    GROUP BY user_id

)

SELECT
    user_id,

    active_days,

    total_events,

    total_sessions,

    total_api_requests,

    successful_api_requests,

    failed_api_requests,

    ROUND(
        SAFE_DIVIDE(
            successful_api_requests,
            total_api_requests
        ) * 100,
        2
    ) AS api_success_rate_percentage,

    first_activity_date,

    last_activity_date,

    DATE_DIFF(
        last_activity_date,
        first_activity_date,
        DAY
    ) AS activity_lifespan_days,

    CASE
        WHEN active_days >= 20 THEN 'Highly Engaged'
        WHEN active_days >= 10 THEN 'Moderately Engaged'
        WHEN active_days >= 3 THEN 'Low Engagement'
        ELSE 'Very Low Engagement'
    END AS engagement_segment

FROM user_engagement
