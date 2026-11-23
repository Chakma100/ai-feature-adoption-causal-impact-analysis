
WITH events AS (

    SELECT
        user_id,
        DATE(event_timestamp) AS activity_date,
        COUNT(*) AS total_events,
        COUNT(DISTINCT session_id) AS total_sessions

    FROM {{ ref('stg_product_events') }}

    WHERE event_timestamp IS NOT NULL

    GROUP BY
        user_id,
        activity_date

),

api_activity AS (

    SELECT
        user_id,
        DATE(request_timestamp) AS activity_date,
        SUM(request_count) AS total_api_requests,
        SUM(success_count) AS successful_requests,
        SUM(error_count) AS failed_requests

    FROM {{ ref('stg_api_usage') }}

    WHERE request_timestamp IS NOT NULL

    GROUP BY
        user_id,
        activity_date

)

SELECT
    COALESCE(e.user_id, a.user_id) AS user_id,

    COALESCE(e.activity_date, a.activity_date) AS activity_date,

    COALESCE(e.total_events, 0) AS total_events,

    COALESCE(e.total_sessions, 0) AS total_sessions,

    COALESCE(a.total_api_requests, 0) AS total_api_requests,

    COALESCE(a.successful_requests, 0) AS successful_requests,

    COALESCE(a.failed_requests, 0) AS failed_requests

FROM events e

FULL OUTER JOIN api_activity a

    ON e.user_id = a.user_id
    AND e.activity_date = a.activity_date
