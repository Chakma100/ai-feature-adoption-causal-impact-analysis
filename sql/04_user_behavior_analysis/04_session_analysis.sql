-- Step 5: Session Analysis

-- 1. Total Sessions
SELECT
    COUNT(DISTINCT session_id) AS total_sessions
FROM product_events
WHERE session_id IS NOT NULL;

-- 2. Total Users With Sessions
SELECT
    COUNT(DISTINCT user_id) AS users_with_sessions
FROM product_events
WHERE session_id IS NOT NULL;

-- 3. Events Per Session
SELECT
    session_id,
    user_id,
    COUNT(*) AS total_events,
    MIN(event_timestamp) AS session_start,
    MAX(event_timestamp) AS session_end
FROM product_events
WHERE session_id IS NOT NULL
GROUP BY
    session_id,
    user_id
ORDER BY total_events DESC;

-- 4. Average Events Per Session
WITH SessionMetrics AS
(
    SELECT
        session_id,
        user_id,
        COUNT(*) AS total_events
    FROM product_events
    WHERE session_id IS NOT NULL
    GROUP BY
        session_id,
        user_id
)
SELECT
    COUNT(*) AS total_sessions,
    CAST(
        AVG(CAST(total_events AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS avg_events_per_session
FROM SessionMetrics;

-- 5. Session Duration
WITH SessionMetrics AS
(
    SELECT
        session_id,
        user_id,
        MIN(event_timestamp) AS session_start,
        MAX(event_timestamp) AS session_end
    FROM product_events
    WHERE session_id IS NOT NULL
    GROUP BY
        session_id,
        user_id
)
SELECT
    session_id,
    user_id,
    session_start,
    session_end,
    DATEDIFF(
        SECOND,
        session_start,
        session_end
    ) / 60.0 AS session_duration_minutes
FROM SessionMetrics
ORDER BY session_duration_minutes DESC;

-- 6. Average Session Duration
WITH SessionMetrics AS
(
    SELECT
        session_id,
        user_id,
        DATEDIFF(
            SECOND,
            MIN(event_timestamp),
            MAX(event_timestamp)
        ) / 60.0 AS duration_minutes
    FROM product_events
    WHERE session_id IS NOT NULL
    GROUP BY
        session_id,
        user_id
)
SELECT
    COUNT(*) AS total_sessions,
    CAST(
        AVG(duration_minutes)
        AS DECIMAL(10,2)
    ) AS avg_session_duration_minutes
FROM SessionMetrics;

-- 7. Most Active Users by Session Count
SELECT TOP 20
    user_id,
    COUNT(DISTINCT session_id) AS total_sessions,
    COUNT(*) AS total_events
FROM product_events
WHERE session_id IS NOT NULL
GROUP BY user_id
ORDER BY total_sessions DESC;

-- 8. Session Analysis by Platform
SELECT
    platform,
    COUNT(DISTINCT session_id) AS total_sessions,
    COUNT(DISTINCT user_id) AS unique_users,
    COUNT(*) AS total_events,
    CAST(
        COUNT(*) * 1.0 /
        NULLIF(COUNT(DISTINCT session_id), 0)
        AS DECIMAL(10,2)
    ) AS avg_events_per_session
FROM product_events
WHERE session_id IS NOT NULL
GROUP BY platform
ORDER BY total_sessions DESC;

-- 9. Session Analysis by Device Type
SELECT
    device_type,
    COUNT(DISTINCT session_id) AS total_sessions,
    COUNT(DISTINCT user_id) AS unique_users,
    COUNT(*) AS total_events,
    CAST(
        COUNT(*) * 1.0 /
        NULLIF(COUNT(DISTINCT session_id), 0)
        AS DECIMAL(10,2)
    ) AS avg_events_per_session
FROM product_events
WHERE session_id IS NOT NULL
GROUP BY device_type
ORDER BY total_sessions DESC;

-- 10. Session Duration Distribution
WITH SessionMetrics AS
(
    SELECT
        session_id,
        DATEDIFF(
            SECOND,
            MIN(event_timestamp),
            MAX(event_timestamp)
        ) / 60.0 AS duration_minutes
    FROM product_events
    WHERE session_id IS NOT NULL
    GROUP BY session_id
)
SELECT
    CASE
        WHEN duration_minutes = 0
            THEN '0 Minutes'
        WHEN duration_minutes > 0
             AND duration_minutes <= 5
            THEN '1-5 Minutes'
        WHEN duration_minutes > 5
             AND duration_minutes <= 15
            THEN '6-15 Minutes'
        WHEN duration_minutes > 15
             AND duration_minutes <= 30
            THEN '16-30 Minutes'
        ELSE 'Above 30 Minutes'
    END AS session_duration_group,
    COUNT(*) AS total_sessions
FROM SessionMetrics
GROUP BY
    CASE
        WHEN duration_minutes = 0
            THEN '0 Minutes'
        WHEN duration_minutes > 0
             AND duration_minutes <= 5
            THEN '1-5 Minutes'
        WHEN duration_minutes > 5
             AND duration_minutes <= 15
            THEN '6-15 Minutes'
        WHEN duration_minutes > 15
             AND duration_minutes <= 30
            THEN '16-30 Minutes'
        ELSE 'Above 30 Minutes'
    END
ORDER BY total_sessions DESC;

