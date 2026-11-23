-- Step : User Activity Analysis:

-- 1. Total Product Events
SELECT
    COUNT(*) AS total_events
FROM product_events;

-- 2. Total Active Users
SELECT
    COUNT(DISTINCT user_id) AS total_active_users
FROM product_events;

-- 3. Event Type Analysis
SELECT
    event_name,
    COUNT(*) AS total_events,
    COUNT(DISTINCT user_id) AS unique_users
FROM product_events
GROUP BY event_name
ORDER BY total_events DESC;

-- 4. Daily User Activity
SELECT
    CAST(event_timestamp AS DATE) AS activity_date,
    COUNT(*) AS total_events,
    COUNT(DISTINCT user_id) AS active_users
FROM product_events
GROUP BY CAST(event_timestamp AS DATE)
ORDER BY activity_date;

-- 5. Monthly User Activity
SELECT
    YEAR(event_timestamp) AS activity_year,
    MONTH(event_timestamp) AS activity_month,
    COUNT(*) AS total_events,
    COUNT(DISTINCT user_id) AS active_users
FROM product_events
GROUP BY
    YEAR(event_timestamp),
    MONTH(event_timestamp)
ORDER BY
    activity_year,
    activity_month;

-- 6. Top 20 Most Active Users
SELECT TOP 20
    user_id,
    COUNT(*) AS total_events,
    COUNT(DISTINCT event_name) AS unique_event_types,
    MIN(event_timestamp) AS first_activity,
    MAX(event_timestamp) AS last_activity
FROM product_events
GROUP BY user_id
ORDER BY total_events DESC;

-- 7. User Activity Distribution
WITH UserActivity AS
(
    SELECT
        user_id,
        COUNT(*) AS total_events
    FROM product_events
    GROUP BY user_id
)
SELECT
    CASE
        WHEN total_events BETWEEN 1 AND 10
            THEN '1-10 Events'
        WHEN total_events BETWEEN 11 AND 50
            THEN '11-50 Events'
        WHEN total_events BETWEEN 51 AND 100
            THEN '51-100 Events'
        ELSE '100+ Events'
    END AS activity_group,
    COUNT(*) AS total_users
FROM UserActivity
GROUP BY
    CASE
        WHEN total_events BETWEEN 1 AND 10
            THEN '1-10 Events'
        WHEN total_events BETWEEN 11 AND 50
            THEN '11-50 Events'
        WHEN total_events BETWEEN 51 AND 100
            THEN '51-100 Events'
        ELSE '100+ Events'
    END
ORDER BY total_users DESC;

-- 8. User Activity Details
SELECT
    u.user_role,
    u.acquisition_channel,
    COUNT(DISTINCT u.user_id) AS total_users,
    COUNT(pe.event_id) AS total_events,
    CAST(
        COUNT(pe.event_id) * 1.0 /
        NULLIF(COUNT(DISTINCT u.user_id), 0)
        AS DECIMAL(10,2)
    ) AS avg_events_per_user
FROM users u
LEFT JOIN product_events pe
    ON u.user_id = pe.user_id
GROUP BY
    u.user_role,
    u.acquisition_channel
ORDER BY avg_events_per_user DESC;
