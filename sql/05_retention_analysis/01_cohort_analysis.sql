-- Step: Cohort Analysis

-- 1.Inspect the date ranges

-- Check user signup date range
SELECT
    MIN(signup_date) AS first_signup_date,
    MAX(signup_date) AS last_signup_date
FROM users;


-- Check product event date range
SELECT
    MIN(event_timestamp) AS first_event_date,
    MAX(event_timestamp) AS last_event_date
FROM product_events;


-- Check events occurring before signup
SELECT
    COUNT(*) AS events_before_signup
FROM product_events pe
INNER JOIN users u
    ON pe.user_id = u.user_id
WHERE pe.event_timestamp < CAST(u.signup_date AS DATETIME2);

-- 2. Calculate signup cohorts
SELECT
    DATEFROMPARTS(
        YEAR(signup_date),
        MONTH(signup_date),
        1
    ) AS cohort_month,

    COUNT(DISTINCT user_id) AS total_users

FROM users

GROUP BY
    DATEFROMPARTS(
        YEAR(signup_date),
        MONTH(signup_date),
        1
    )

ORDER BY cohort_month;

-- 3. Calculate monthly user activity
WITH UserActivity AS
(
    SELECT DISTINCT
        u.user_id,

        DATEFROMPARTS(
            YEAR(u.signup_date),
            MONTH(u.signup_date),
            1
        ) AS cohort_month,

        DATEFROMPARTS(
            YEAR(pe.event_timestamp),
            MONTH(pe.event_timestamp),
            1
        ) AS activity_month

    FROM users u

    INNER JOIN product_events pe
        ON u.user_id = pe.user_id

    WHERE pe.event_timestamp >= CAST(u.signup_date AS DATETIME2)
)

SELECT
    cohort_month,
    activity_month,

    DATEDIFF(
        MONTH,
        cohort_month,
        activity_month
    ) AS cohort_index,

    COUNT(DISTINCT user_id) AS active_users

FROM UserActivity

GROUP BY
    cohort_month,
    activity_month

ORDER BY
    cohort_month,
    activity_month;

-- 4. Calculate cohort retention rate 
WITH Cohorts AS
(
    SELECT
        user_id,

        DATEFROMPARTS(
            YEAR(signup_date),
            MONTH(signup_date),
            1
        ) AS cohort_month

    FROM users
),

CohortSize AS
(
    SELECT
        cohort_month,
        COUNT(DISTINCT user_id) AS cohort_size

    FROM Cohorts

    GROUP BY cohort_month
),

UserActivity AS
(
    SELECT DISTINCT
        c.user_id,
        c.cohort_month,

        DATEFROMPARTS(
            YEAR(pe.event_timestamp),
            MONTH(pe.event_timestamp),
            1
        ) AS activity_month

    FROM Cohorts c

    INNER JOIN product_events pe
        ON c.user_id = pe.user_id

    WHERE pe.event_timestamp >=
          CAST(c.cohort_month AS DATETIME2)
),

MonthlyRetention AS
(
    SELECT
        cohort_month,

        DATEDIFF(
            MONTH,
            cohort_month,
            activity_month
        ) AS cohort_index,

        COUNT(DISTINCT user_id) AS active_users

    FROM UserActivity

    GROUP BY
        cohort_month,
        DATEDIFF(MONTH, cohort_month, activity_month)
)

SELECT
    mr.cohort_month,
    mr.cohort_index,
    cs.cohort_size,
    mr.active_users,

    CAST(
        mr.active_users * 100.0 /
        NULLIF(cs.cohort_size, 0)
        AS DECIMAL(10,2)
    ) AS retention_rate

FROM MonthlyRetention mr

INNER JOIN CohortSize cs
    ON mr.cohort_month = cs.cohort_month

ORDER BY
    mr.cohort_month,
    mr.cohort_index;

-- 5. Create a cohort retention matrix
WITH Cohorts AS
(
    SELECT
        user_id,

        DATEFROMPARTS(
            YEAR(signup_date),
            MONTH(signup_date),
            1
        ) AS cohort_month

    FROM users
),

CohortSize AS
(
    SELECT
        cohort_month,
        COUNT(DISTINCT user_id) AS cohort_size

    FROM Cohorts

    GROUP BY cohort_month
),

UserActivity AS
(
    SELECT DISTINCT
        c.user_id,
        c.cohort_month,

        DATEFROMPARTS(
            YEAR(pe.event_timestamp),
            MONTH(pe.event_timestamp),
            1
        ) AS activity_month

    FROM Cohorts c

    INNER JOIN product_events pe
        ON c.user_id = pe.user_id

    WHERE pe.event_timestamp >=
          CAST(c.cohort_month AS DATETIME2)
),

Retention AS
(
    SELECT
        ua.cohort_month,

        DATEDIFF(
            MONTH,
            ua.cohort_month,
            ua.activity_month
        ) AS cohort_index,

        COUNT(DISTINCT ua.user_id) * 100.0 /
        NULLIF(cs.cohort_size, 0) AS retention_rate

    FROM UserActivity ua

    INNER JOIN CohortSize cs
        ON ua.cohort_month = cs.cohort_month

    GROUP BY
        ua.cohort_month,
        DATEDIFF(
            MONTH,
            ua.cohort_month,
            ua.activity_month
        ),
        cs.cohort_size
)

SELECT
    cohort_month,

    CAST(MAX(CASE WHEN cohort_index = 0
        THEN retention_rate END) AS DECIMAL(10,2)) AS Month_0,

    CAST(MAX(CASE WHEN cohort_index = 1
        THEN retention_rate END) AS DECIMAL(10,2)) AS Month_1,

    CAST(MAX(CASE WHEN cohort_index = 2
        THEN retention_rate END) AS DECIMAL(10,2)) AS Month_2,

    CAST(MAX(CASE WHEN cohort_index = 3
        THEN retention_rate END) AS DECIMAL(10,2)) AS Month_3,

    CAST(MAX(CASE WHEN cohort_index = 4
        THEN retention_rate END) AS DECIMAL(10,2)) AS Month_4,

    CAST(MAX(CASE WHEN cohort_index = 5
        THEN retention_rate END) AS DECIMAL(10,2)) AS Month_5,

    CAST(MAX(CASE WHEN cohort_index = 6
        THEN retention_rate END) AS DECIMAL(10,2)) AS Month_6

FROM Retention

GROUP BY cohort_month

ORDER BY cohort_month;

-- 