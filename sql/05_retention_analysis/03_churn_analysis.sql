-- Step : Churn Analysis

-- 1: Identify user activity status
DECLARE @ObservationDate DATE = '2026-11-15';

WITH LastActivity AS
(
    SELECT
        user_id,
        MAX(event_timestamp) AS last_activity_date
    FROM product_events
    GROUP BY user_id
)

SELECT
    u.user_id,
    u.signup_date,
    la.last_activity_date,

    DATEDIFF(
        DAY,
        CAST(la.last_activity_date AS DATE),
        @ObservationDate
    ) AS inactive_days,

    CASE
        WHEN la.last_activity_date IS NULL
            THEN 'Never Active'
        WHEN DATEDIFF(
            DAY,
            CAST(la.last_activity_date AS DATE),
            @ObservationDate
        ) >= 60
            THEN 'Churned'
        WHEN DATEDIFF(
            DAY,
            CAST(la.last_activity_date AS DATE),
            @ObservationDate
        ) >= 30
            THEN 'At Risk'
        ELSE 'Active'
    END AS user_status

FROM users u

LEFT JOIN LastActivity la
    ON u.user_id = la.user_id

ORDER BY inactive_days DESC;

GO

--2: User status distribution
DECLARE @ObservationDate DATE = '2026-11-15';

WITH LastActivity AS
(
    SELECT
        user_id,
        MAX(event_timestamp) AS last_activity_date
    FROM product_events
    GROUP BY user_id
),

UserStatus AS
(
    SELECT
        u.user_id,

        CASE
            WHEN la.last_activity_date IS NULL
                THEN 'Never Active'
            WHEN DATEDIFF(
                DAY,
                CAST(la.last_activity_date AS DATE),
                @ObservationDate
            ) >= 60
                THEN 'Churned'
            WHEN DATEDIFF(
                DAY,
                CAST(la.last_activity_date AS DATE),
                @ObservationDate
            ) >= 30
                THEN 'At Risk'
            ELSE 'Active'
        END AS user_status

    FROM users u

    LEFT JOIN LastActivity la
        ON u.user_id = la.user_id
)

SELECT
    user_status,
    COUNT(*) AS total_users,

    CAST(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER ()
        AS DECIMAL(10,2)
    ) AS percentage_of_users

FROM UserStatus

GROUP BY user_status

ORDER BY total_users DESC;

GO

-- 3: Calculate inactivity-based churn rate
DECLARE @ObservationDate DATE = '2026-11-15';

WITH LastActivity AS
(
    SELECT
        user_id,
        MAX(event_timestamp) AS last_activity_date
    FROM product_events
    GROUP BY user_id
),

UserStatus AS
(
    SELECT
        u.user_id,
        la.last_activity_date,

        CASE
            WHEN la.last_activity_date IS NOT NULL
             AND DATEDIFF(
                    DAY,
                    CAST(la.last_activity_date AS DATE),
                    @ObservationDate
                 ) >= 60
            THEN 1
            ELSE 0
        END AS is_churned

    FROM users u

    LEFT JOIN LastActivity la
        ON u.user_id = la.user_id
)

SELECT
    COUNT(last_activity_date) AS users_with_activity,

    SUM(is_churned) AS churned_users,

    CAST(
        SUM(is_churned) * 100.0 /
        NULLIF(COUNT(last_activity_date), 0)
        AS DECIMAL(10,2)
    ) AS inactive_user_churn_rate

FROM UserStatus;

GO

-- 4: Analyze cancellation by subscription plan

-- Inspect subscription status values first

SELECT DISTINCT
    subscription_status
FROM subscriptions;

GO

-- Cancellation analysis

SELECT
    plan_type,

    COUNT(*) AS total_subscriptions,

    SUM(
        CASE
            WHEN subscription_status = 'Cancelled'
            THEN 1
            ELSE 0
        END
    ) AS cancelled_subscriptions,

    CAST(
        SUM(
            CASE
                WHEN subscription_status = 'Cancelled'
                THEN 1
                ELSE 0
            END
        ) * 100.0 /
        NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS cancellation_rate

FROM subscriptions

GROUP BY plan_type

ORDER BY cancellation_rate DESC;

GO

-- 5: Identify high-risk organizations
DECLARE @ObservationDate DATE = '2026-11-15';

WITH LastActivity AS
(
    SELECT
        user_id,
        MAX(event_timestamp) AS last_activity_date
    FROM product_events
    GROUP BY user_id
),

UserStatus AS
(
    SELECT
        u.user_id,
        u.organization_id,

        CASE
            WHEN la.last_activity_date IS NULL
                THEN 'Never Active'
            WHEN DATEDIFF(
                DAY,
                CAST(la.last_activity_date AS DATE),
                @ObservationDate
            ) >= 60
                THEN 'Churned'
            WHEN DATEDIFF(
                DAY,
                CAST(la.last_activity_date AS DATE),
                @ObservationDate
            ) >= 30
                THEN 'At Risk'
            ELSE 'Active'
        END AS user_status

    FROM users u

    LEFT JOIN LastActivity la
        ON u.user_id = la.user_id
)

SELECT
    o.organization_id,
    o.organization_name,

    COUNT(us.user_id) AS total_users,

    SUM(
        CASE
            WHEN us.user_status = 'Churned'
            THEN 1 ELSE 0
        END
    ) AS churned_users,

    SUM(
        CASE
            WHEN us.user_status = 'At Risk'
            THEN 1 ELSE 0
        END
    ) AS at_risk_users,

    CAST(
        SUM(
            CASE
                WHEN us.user_status = 'Churned'
                THEN 1 ELSE 0
            END
        ) * 100.0 /
        NULLIF(COUNT(us.user_id), 0)
        AS DECIMAL(10,2)
    ) AS churned_user_percentage

FROM organizations o

INNER JOIN UserStatus us
    ON o.organization_id = us.organization_id

GROUP BY
    o.organization_id,
    o.organization_name

ORDER BY churned_user_percentage DESC;

GO

-- 6: Identify users for retention campaigns
DECLARE @ObservationDate DATE = '2026-11-15';

WITH LastActivity AS
(
    SELECT
        user_id,
        MAX(event_timestamp) AS last_activity_date
    FROM product_events
    GROUP BY user_id
)

SELECT
    u.user_id,
    u.organization_id,
    u.user_role,
    u.acquisition_channel,
    la.last_activity_date,

    DATEDIFF(
        DAY,
        CAST(la.last_activity_date AS DATE),
        @ObservationDate
    ) AS inactive_days

FROM users u

INNER JOIN LastActivity la
    ON u.user_id = la.user_id

WHERE DATEDIFF(
    DAY,
    CAST(la.last_activity_date AS DATE),
    @ObservationDate
) BETWEEN 30 AND 59

ORDER BY inactive_days DESC;

GO

-- 