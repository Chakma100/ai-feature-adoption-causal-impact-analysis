-- Step: New vs Returning Users Analysis

-- 1. First Activity Date of Each User
WITH FirstActivity AS
(
    SELECT
        user_id,
        MIN(event_timestamp) AS first_activity_date
    FROM product_events
    GROUP BY user_id
)
SELECT
    user_id,
    first_activity_date
FROM FirstActivity
ORDER BY first_activity_date;

-- 2. Monthly New Active Users
WITH FirstActivity AS
(
    SELECT
        user_id,
        MIN(event_timestamp) AS first_activity_date
    FROM product_events
    GROUP BY user_id
)
SELECT
    YEAR(first_activity_date) AS activity_year,
    MONTH(first_activity_date) AS activity_month,
    COUNT(*) AS new_active_users
FROM FirstActivity
GROUP BY
    YEAR(first_activity_date),
    MONTH(first_activity_date)
ORDER BY
    activity_year,
    activity_month;

-- 3. Monthly Returning Users
WITH FirstActivity AS
(
    SELECT
        user_id,
        MIN(event_timestamp) AS first_activity_date
    FROM product_events
    GROUP BY user_id
),
MonthlyActivity AS
(
    SELECT DISTINCT
        user_id,
        DATEFROMPARTS(
            YEAR(event_timestamp),
            MONTH(event_timestamp),
            1
        ) AS activity_month
    FROM product_events
)
SELECT
    m.activity_month,
    COUNT(*) AS returning_users
FROM MonthlyActivity m
INNER JOIN FirstActivity f
    ON m.user_id = f.user_id
WHERE f.first_activity_date < m.activity_month
GROUP BY m.activity_month
ORDER BY m.activity_month;

-- 4. Monthly New vs Returning Users
WITH FirstActivity AS
(
    SELECT
        user_id,
        MIN(event_timestamp) AS first_activity_date
    FROM product_events
    GROUP BY user_id
),
MonthlyActivity AS
(
    SELECT DISTINCT
        user_id,
        DATEFROMPARTS(
            YEAR(event_timestamp),
            MONTH(event_timestamp),
            1
        ) AS activity_month
    FROM product_events
)
SELECT
    m.activity_month,

    COUNT(CASE
        WHEN f.first_activity_date >= m.activity_month
         AND f.first_activity_date < DATEADD(MONTH, 1, m.activity_month)
        THEN 1
    END) AS new_users,

    COUNT(CASE
        WHEN f.first_activity_date < m.activity_month
        THEN 1
    END) AS returning_users,

    COUNT(*) AS total_active_users

FROM MonthlyActivity m
INNER JOIN FirstActivity f
    ON m.user_id = f.user_id
GROUP BY m.activity_month
ORDER BY m.activity_month;

-- 5. Returning User Percentage
WITH FirstActivity AS
(
    SELECT
        user_id,
        MIN(event_timestamp) AS first_activity_date
    FROM product_events
    GROUP BY user_id
),
MonthlyActivity AS
(
    SELECT DISTINCT
        user_id,
        DATEFROMPARTS(
            YEAR(event_timestamp),
            MONTH(event_timestamp),
            1
        ) AS activity_month
    FROM product_events
),
MonthlyMetrics AS
(
    SELECT
        m.activity_month,
        COUNT(*) AS total_active_users,

        SUM(CASE
            WHEN f.first_activity_date < m.activity_month
            THEN 1 ELSE 0
        END) AS returning_users,

        SUM(CASE
            WHEN f.first_activity_date >= m.activity_month
             AND f.first_activity_date < DATEADD(MONTH, 1, m.activity_month)
            THEN 1 ELSE 0
        END) AS new_users

    FROM MonthlyActivity m
    INNER JOIN FirstActivity f
        ON m.user_id = f.user_id
    GROUP BY m.activity_month
)
SELECT
    activity_month,
    new_users,
    returning_users,
    total_active_users,
    CAST(
        returning_users * 100.0 /
        NULLIF(total_active_users, 0)
        AS DECIMAL(10,2)
    ) AS returning_user_rate_percentage
FROM MonthlyMetrics
ORDER BY activity_month;

-- 6. New vs Returning Users by Acquisition Channel
WITH FirstActivity AS
(
    SELECT
        user_id,
        MIN(event_timestamp) AS first_activity_date
    FROM product_events
    GROUP BY user_id
),
MonthlyActivity AS
(
    SELECT DISTINCT
        user_id,
        DATEFROMPARTS(
            YEAR(event_timestamp),
            MONTH(event_timestamp),
            1
        ) AS activity_month
    FROM product_events
)
SELECT
    u.acquisition_channel,

    COUNT(DISTINCT CASE
        WHEN f.first_activity_date >= m.activity_month
         AND f.first_activity_date < DATEADD(MONTH, 1, m.activity_month)
        THEN u.user_id
    END) AS new_users,

    COUNT(DISTINCT CASE
        WHEN f.first_activity_date < m.activity_month
        THEN u.user_id
    END) AS returning_users,

    COUNT(DISTINCT m.user_id) AS total_active_users

FROM users u
INNER JOIN MonthlyActivity m
    ON u.user_id = m.user_id
INNER JOIN FirstActivity f
    ON u.user_id = f.user_id
GROUP BY u.acquisition_channel
ORDER BY returning_users DESC;

-- 7. Returning Users by User Role
WITH FirstActivity AS
(
    SELECT
        user_id,
        MIN(event_timestamp) AS first_activity_date
    FROM product_events
    GROUP BY user_id
),
MonthlyActivity AS
(
    SELECT DISTINCT
        user_id,
        DATEFROMPARTS(
            YEAR(event_timestamp),
            MONTH(event_timestamp),
            1
        ) AS activity_month
    FROM product_events
)
SELECT
    u.user_role,
    COUNT(DISTINCT CASE
        WHEN f.first_activity_date < m.activity_month
        THEN m.user_id
    END) AS returning_users,
    COUNT(DISTINCT m.user_id) AS total_active_users
FROM users u
INNER JOIN MonthlyActivity m
    ON u.user_id = m.user_id
INNER JOIN FirstActivity f
    ON u.user_id = f.user_id
GROUP BY u.user_role
ORDER BY returning_users DESC;

-- 8. User Activity Frequency 
WITH UserActivity AS
(
    SELECT
        user_id,
        COUNT(DISTINCT CAST(event_timestamp AS DATE))
            AS active_days
    FROM product_events
    GROUP BY user_id
)
SELECT
    CASE
        WHEN active_days = 1
            THEN 'One Active Day'
        WHEN active_days BETWEEN 2 AND 5
            THEN '2-5 Active Days'
        WHEN active_days BETWEEN 6 AND 15
            THEN '6-15 Active Days'
        ELSE 'More Than 15 Active Days'
    END AS activity_frequency,
    COUNT(*) AS total_users
FROM UserActivity
GROUP BY
    CASE
        WHEN active_days = 1
            THEN 'One Active Day'
        WHEN active_days BETWEEN 2 AND 5
            THEN '2-5 Active Days'
        WHEN active_days BETWEEN 6 AND 15
            THEN '6-15 Active Days'
        ELSE 'More Than 15 Active Days'
    END
ORDER BY total_users DESC;

-- 9. Identify Users Who Returned After Their First Activity
SELECT
    user_id,
    COUNT(DISTINCT CAST(event_timestamp AS DATE))
        AS active_days,
    MIN(event_timestamp) AS first_activity,
    MAX(event_timestamp) AS latest_activity
FROM product_events
GROUP BY user_id
HAVING COUNT(DISTINCT CAST(event_timestamp AS DATE)) >= 2
ORDER BY active_days DESC;

-- 
