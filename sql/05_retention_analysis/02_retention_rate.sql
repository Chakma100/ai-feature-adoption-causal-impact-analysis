--Step: Retention Rate Analysis

-- 1. Calculate overall user retention
WITH FirstActivity AS
(
    SELECT
        user_id,
        MIN(event_timestamp) AS first_activity_date
    FROM product_events
    GROUP BY user_id
),

UserReturn AS
(
    SELECT
        f.user_id,
        f.first_activity_date,

        MAX(
            CASE
                WHEN pe.event_timestamp >=
                     DATEADD(DAY, 1, f.first_activity_date)
                THEN 1
                ELSE 0
            END
        ) AS returned_after_first_activity

    FROM FirstActivity f

    LEFT JOIN product_events pe
        ON f.user_id = pe.user_id

    GROUP BY
        f.user_id,
        f.first_activity_date
)

SELECT
    COUNT(*) AS total_users,

    SUM(returned_after_first_activity) AS returning_users,

    COUNT(*) - SUM(returned_after_first_activity)
        AS non_returning_users,

    CAST(
        SUM(returned_after_first_activity) * 100.0 /
        NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS overall_return_rate

FROM UserReturn;

-- 2. Calculate Day 7 retention
WITH FirstActivity AS
(
    SELECT
        user_id,
        MIN(event_timestamp) AS first_activity_date
    FROM product_events
    GROUP BY user_id
),

Day7Retention AS
(
    SELECT
        f.user_id,

        MAX(
            CASE
                WHEN pe.event_timestamp >=
                     DATEADD(DAY, 7, f.first_activity_date)

                 AND pe.event_timestamp <
                     DATEADD(DAY, 8, f.first_activity_date)

                THEN 1
                ELSE 0
            END
        ) AS retained_d7

    FROM FirstActivity f

    LEFT JOIN product_events pe
        ON f.user_id = pe.user_id

    WHERE DATEADD(DAY, 8, f.first_activity_date)
          <= (SELECT MAX(event_timestamp) FROM product_events)

    GROUP BY
        f.user_id,
        f.first_activity_date
)

SELECT
    COUNT(*) AS eligible_users,
    SUM(retained_d7) AS retained_users,

    CAST(
        SUM(retained_d7) * 100.0 /
        NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS day_7_retention_rate

FROM Day7Retention;

-- 3. Calculate Day 30 retention
WITH FirstActivity AS
(
    SELECT
        user_id,
        MIN(event_timestamp) AS first_activity_date
    FROM product_events
    GROUP BY user_id
),

Day30Retention AS
(
    SELECT
        f.user_id,

        MAX(
            CASE
                WHEN pe.event_timestamp >=
                     DATEADD(DAY, 30, f.first_activity_date)

                 AND pe.event_timestamp <
                     DATEADD(DAY, 31, f.first_activity_date)

                THEN 1
                ELSE 0
            END
        ) AS retained_d30

    FROM FirstActivity f

    LEFT JOIN product_events pe
        ON f.user_id = pe.user_id

    WHERE DATEADD(DAY, 31, f.first_activity_date)
          <= (SELECT MAX(event_timestamp) FROM product_events)

    GROUP BY
        f.user_id,
        f.first_activity_date
)

SELECT
    COUNT(*) AS eligible_users,
    SUM(retained_d30) AS retained_users,

    CAST(
        SUM(retained_d30) * 100.0 /
        NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS day_30_retention_rate

FROM Day30Retention;

-- 4. Calculate monthly retention
WITH MonthlyActivity AS
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

MonthlyRetention AS
(
    SELECT
        current_month.activity_month,

        COUNT(DISTINCT current_month.user_id)
            AS active_users,

        COUNT(DISTINCT next_month.user_id)
            AS returning_users

    FROM MonthlyActivity current_month

    LEFT JOIN MonthlyActivity next_month
        ON current_month.user_id = next_month.user_id
        AND next_month.activity_month =
            DATEADD(MONTH, 1, current_month.activity_month)

    GROUP BY current_month.activity_month
)

SELECT
    activity_month,
    active_users,
    returning_users,

    CAST(
        returning_users * 100.0 /
        NULLIF(active_users, 0)
        AS DECIMAL(10,2)
    ) AS next_month_retention_rate

FROM MonthlyRetention

ORDER BY activity_month;

-- 5. Compare retention by acquisition channel
WITH FirstActivity AS
(
    SELECT
        user_id,
        MIN(event_timestamp) AS first_activity_date
    FROM product_events
    GROUP BY user_id
),

UserRetention AS
(
    SELECT
        u.user_id,
        u.acquisition_channel,

        MAX(
            CASE
                WHEN pe.event_timestamp >
                     f.first_activity_date
                THEN 1
                ELSE 0
            END
        ) AS returned

    FROM users u

    INNER JOIN FirstActivity f
        ON u.user_id = f.user_id

    LEFT JOIN product_events pe
        ON u.user_id = pe.user_id

    GROUP BY
        u.user_id,
        u.acquisition_channel,
        f.first_activity_date
)

SELECT
    acquisition_channel,

    COUNT(*) AS total_users,

    SUM(returned) AS returning_users,

    CAST(
        SUM(returned) * 100.0 /
        NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS return_rate

FROM UserRetention

GROUP BY acquisition_channel

ORDER BY return_rate DESC;
