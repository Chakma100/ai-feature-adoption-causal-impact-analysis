-- Step 9: Funnel Analysis

-- 1. Build the Overall Product Funnel
WITH EventUsers AS
(
    SELECT DISTINCT user_id
    FROM product_events
),
FeatureUsers AS
(
    SELECT DISTINCT user_id
    FROM feature_usage
),
APIUsers AS
(
    SELECT
        user_id
    FROM api_usage
    WHERE request_count > 0
    GROUP BY user_id
)
SELECT
    COUNT(*) AS registered_users,

    SUM(CASE
        WHEN e.user_id IS NOT NULL THEN 1
        ELSE 0
    END) AS active_users,

    SUM(CASE
        WHEN f.user_id IS NOT NULL THEN 1
        ELSE 0
    END) AS feature_adopters,

    SUM(CASE
        WHEN a.user_id IS NOT NULL THEN 1
        ELSE 0
    END) AS api_users

FROM users u
LEFT JOIN EventUsers e
    ON u.user_id = e.user_id
LEFT JOIN FeatureUsers f
    ON u.user_id = f.user_id
LEFT JOIN APIUsers a
    ON u.user_id = a.user_id;

-- 2. Calculate Funnel Conversion Rates
WITH EventUsers AS
(
    SELECT DISTINCT user_id
    FROM product_events
),
FeatureUsers AS
(
    SELECT DISTINCT user_id
    FROM feature_usage
),
APIUsers AS
(
    SELECT DISTINCT user_id
    FROM api_usage
    WHERE request_count > 0
),
Funnel AS
(
    SELECT
        COUNT(*) AS registered_users,
        SUM(CASE WHEN e.user_id IS NOT NULL THEN 1 ELSE 0 END)
            AS active_users,
        SUM(CASE WHEN f.user_id IS NOT NULL THEN 1 ELSE 0 END)
            AS feature_adopters,
        SUM(CASE WHEN a.user_id IS NOT NULL THEN 1 ELSE 0 END)
            AS api_users
    FROM users u
    LEFT JOIN EventUsers e
        ON u.user_id = e.user_id
    LEFT JOIN FeatureUsers f
        ON u.user_id = f.user_id
    LEFT JOIN APIUsers a
        ON u.user_id = a.user_id
)
SELECT
    registered_users,
    active_users,
    feature_adopters,
    api_users,

    CAST(
        active_users * 100.0 /
        NULLIF(registered_users, 0)
        AS DECIMAL(10,2)
    ) AS signup_to_activity_rate,

    CAST(
        feature_adopters * 100.0 /
        NULLIF(active_users, 0)
        AS DECIMAL(10,2)
    ) AS activity_to_feature_rate,

    CAST(
        api_users * 100.0 /
        NULLIF(feature_adopters, 0)
        AS DECIMAL(10,2)
    ) AS feature_to_api_rate

FROM Funnel;

-- 3. Calculate Drop-off Rates
WITH EventUsers AS
(
    SELECT DISTINCT user_id
    FROM product_events
),
FeatureUsers AS
(
    SELECT DISTINCT user_id
    FROM feature_usage
),
Funnel AS
(
    SELECT
        COUNT(*) AS registered_users,
        SUM(CASE WHEN e.user_id IS NOT NULL THEN 1 ELSE 0 END)
            AS active_users,
        SUM(CASE WHEN f.user_id IS NOT NULL THEN 1 ELSE 0 END)
            AS feature_adopters
    FROM users u
    LEFT JOIN EventUsers e
        ON u.user_id = e.user_id
    LEFT JOIN FeatureUsers f
        ON u.user_id = f.user_id
)
SELECT
    'Registration to Activity' AS funnel_stage,
    registered_users AS previous_stage_users,
    active_users AS current_stage_users,
    registered_users - active_users AS dropped_users,
    CAST(
        (registered_users - active_users) * 100.0 /
        NULLIF(registered_users, 0)
        AS DECIMAL(10,2)
    ) AS dropoff_rate_percentage
FROM Funnel

UNION ALL

SELECT
    'Activity to Feature Adoption',
    active_users,
    feature_adopters,
    active_users - feature_adopters,
    CAST(
        (active_users - feature_adopters) * 100.0 /
        NULLIF(active_users, 0)
        AS DECIMAL(10,2)
    )
FROM Funnel;

-- 4. Funnel Analysis by Acquisition Channel
WITH EventUsers AS
(
    SELECT DISTINCT user_id
    FROM product_events
),
FeatureUsers AS
(
    SELECT DISTINCT user_id
    FROM feature_usage
),
APIUsers AS
(
    SELECT DISTINCT user_id
    FROM api_usage
    WHERE request_count > 0
)
SELECT
    u.acquisition_channel,
    COUNT(*) AS registered_users,

    SUM(CASE WHEN e.user_id IS NOT NULL THEN 1 ELSE 0 END)
        AS active_users,

    SUM(CASE WHEN f.user_id IS NOT NULL THEN 1 ELSE 0 END)
        AS feature_adopters,

    SUM(CASE WHEN a.user_id IS NOT NULL THEN 1 ELSE 0 END)
        AS api_users,

    CAST(
        SUM(CASE WHEN e.user_id IS NOT NULL THEN 1.0 ELSE 0 END)
        * 100.0 / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS activity_conversion_rate

FROM users u
LEFT JOIN EventUsers e
    ON u.user_id = e.user_id
LEFT JOIN FeatureUsers f
    ON u.user_id = f.user_id
LEFT JOIN APIUsers a
    ON u.user_id = a.user_id
GROUP BY u.acquisition_channel
ORDER BY activity_conversion_rate DESC;

-- 5. Funnel Analysis by User Role
WITH EventUsers AS
(
    SELECT DISTINCT user_id
    FROM product_events
),
FeatureUsers AS
(
    SELECT DISTINCT user_id
    FROM feature_usage
),
APIUsers AS
(
    SELECT DISTINCT user_id
    FROM api_usage
    WHERE request_count > 0
)
SELECT
    u.user_role,
    COUNT(*) AS registered_users,

    SUM(CASE WHEN e.user_id IS NOT NULL THEN 1 ELSE 0 END)
        AS active_users,

    SUM(CASE WHEN f.user_id IS NOT NULL THEN 1 ELSE 0 END)
        AS feature_adopters,

    SUM(CASE WHEN a.user_id IS NOT NULL THEN 1 ELSE 0 END)
        AS api_users

FROM users u
LEFT JOIN EventUsers e
    ON u.user_id = e.user_id
LEFT JOIN FeatureUsers f
    ON u.user_id = f.user_id
LEFT JOIN APIUsers a
    ON u.user_id = a.user_id
GROUP BY u.user_role
ORDER BY registered_users DESC;

-- 6. Feature Adoption Funnel by Feature
WITH ActiveUsers AS
(
    SELECT DISTINCT user_id
    FROM product_events
),
FeatureAdoption AS
(
    SELECT
        feature_name,
        COUNT(DISTINCT user_id) AS adopted_users
    FROM feature_usage
    GROUP BY feature_name
),
ActiveUserCount AS
(
    SELECT COUNT(*) AS total_active_users
    FROM ActiveUsers
)
SELECT
    f.feature_name,
    f.adopted_users,
    a.total_active_users,

    CAST(
        f.adopted_users * 100.0 /
        NULLIF(a.total_active_users, 0)
        AS DECIMAL(10,2)
    ) AS active_user_feature_adoption_rate

FROM FeatureAdoption f
CROSS JOIN ActiveUserCount a
ORDER BY active_user_feature_adoption_rate DESC;

-- 7. Identify Users Who Drop Off Before Feature Adoption
SELECT
    u.user_id,
    u.user_role,
    u.acquisition_channel,
    u.signup_date,
    COUNT(pe.event_id) AS total_events
FROM users u
INNER JOIN product_events pe
    ON u.user_id = pe.user_id
LEFT JOIN feature_usage fu
    ON u.user_id = fu.user_id
WHERE fu.user_id IS NULL
GROUP BY
    u.user_id,
    u.user_role,
    u.acquisition_channel,
    u.signup_date
ORDER BY total_events DESC;

-- 8. Check Whether Funnel Stages Are Nested
SELECT
    'Feature Users Without Product Events' AS validation_check,
    COUNT(DISTINCT f.user_id) AS affected_users
FROM feature_usage f
LEFT JOIN product_events p
    ON f.user_id = p.user_id
WHERE p.user_id IS NULL

UNION ALL

SELECT
    'API Users Without Product Events',
    COUNT(DISTINCT a.user_id)
FROM api_usage a
LEFT JOIN product_events p
    ON a.user_id = p.user_id
WHERE a.request_count > 0
  AND p.user_id IS NULL;

-- 