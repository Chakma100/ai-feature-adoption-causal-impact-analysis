-- Step : User Journey Analysis

-- 1. Explore Available Event Names
SELECT
    event_name,
    COUNT(*) AS total_events,
    COUNT(DISTINCT user_id) AS unique_users
FROM product_events
GROUP BY event_name
ORDER BY total_events DESC;

-- 2. Signup to First Product Activity 
WITH FirstActivity AS
(
    SELECT
        user_id,
        MIN(event_timestamp) AS first_activity_date
    FROM product_events
    GROUP BY user_id
)
SELECT
    COUNT(*) AS total_registered_users,
    COUNT(f.user_id) AS users_with_activity,
    COUNT(*) - COUNT(f.user_id) AS users_without_activity,
    CAST(
        COUNT(f.user_id) * 100.0 /
        NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS activity_conversion_rate
FROM users u
LEFT JOIN FirstActivity f
    ON u.user_id = f.user_id;

-- 3. User Journey Summary
WITH UserJourney AS
(
    SELECT
        u.user_id,
        u.signup_date,
        COUNT(DISTINCT pe.event_id) AS total_events,
        COUNT(DISTINCT fu.feature_name) AS features_adopted,
        COALESCE(SUM(au.request_count), 0) AS total_api_requests
    FROM users u
    LEFT JOIN product_events pe
        ON u.user_id = pe.user_id
    LEFT JOIN feature_usage fu
        ON u.user_id = fu.user_id
    LEFT JOIN api_usage au
        ON u.user_id = au.user_id
    GROUP BY
        u.user_id,
        u.signup_date
)
SELECT
    COUNT(*) AS total_users,
    SUM(CASE WHEN total_events > 0 THEN 1 ELSE 0 END)
        AS users_with_product_activity,
    SUM(CASE WHEN features_adopted > 0 THEN 1 ELSE 0 END)
        AS users_adopting_features,
    SUM(CASE WHEN total_api_requests > 0 THEN 1 ELSE 0 END)
        AS users_using_apis
FROM UserJourney;

-- 4. Correct User Journey Summary
WITH EventMetrics AS
(
    SELECT
        user_id,
        COUNT(*) AS total_events
    FROM product_events
    GROUP BY user_id
),
FeatureMetrics AS
(
    SELECT
        user_id,
        COUNT(DISTINCT feature_name) AS features_adopted
    FROM feature_usage
    GROUP BY user_id
),
APIMetrics AS
(
    SELECT
        user_id,
        SUM(request_count) AS total_api_requests
    FROM api_usage
    GROUP BY user_id
)
SELECT
    COUNT(*) AS total_users,
    SUM(CASE WHEN e.total_events > 0 THEN 1 ELSE 0 END)
        AS users_with_product_activity,
    SUM(CASE WHEN f.features_adopted > 0 THEN 1 ELSE 0 END)
        AS users_adopting_features,
    SUM(CASE WHEN a.total_api_requests > 0 THEN 1 ELSE 0 END)
        AS users_using_apis
FROM users u
LEFT JOIN EventMetrics e
    ON u.user_id = e.user_id
LEFT JOIN FeatureMetrics f
    ON u.user_id = f.user_id
LEFT JOIN APIMetrics a
    ON u.user_id = a.user_id;

-- 5. User Journey by Acquisition Channel
WITH EventMetrics AS
(
    SELECT
        user_id,
        COUNT(*) AS total_events
    FROM product_events
    GROUP BY user_id
),
FeatureMetrics AS
(
    SELECT
        user_id,
        COUNT(DISTINCT feature_name) AS features_adopted
    FROM feature_usage
    GROUP BY user_id
),
APIMetrics AS
(
    SELECT
        user_id,
        SUM(request_count) AS total_api_requests
    FROM api_usage
    GROUP BY user_id
)
SELECT
    u.acquisition_channel,
    COUNT(*) AS total_signups,
    SUM(CASE WHEN e.total_events > 0 THEN 1 ELSE 0 END)
        AS active_users,
    SUM(CASE WHEN f.features_adopted > 0 THEN 1 ELSE 0 END)
        AS feature_adopters,
    SUM(CASE WHEN a.total_api_requests > 0 THEN 1 ELSE 0 END)
        AS api_users,
    CAST(
        SUM(CASE WHEN e.total_events > 0 THEN 1.0 ELSE 0 END)
        * 100.0 / NULLIF(COUNT(*), 0)
        AS DECIMAL(10,2)
    ) AS activity_rate_percentage
FROM users u
LEFT JOIN EventMetrics e
    ON u.user_id = e.user_id
LEFT JOIN FeatureMetrics f
    ON u.user_id = f.user_id
LEFT JOIN APIMetrics a
    ON u.user_id = a.user_id
GROUP BY u.acquisition_channel
ORDER BY activity_rate_percentage DESC;

-- 6. Time to First Product Activity
WITH FirstActivity AS
(
    SELECT
        user_id,
        MIN(event_timestamp) AS first_activity_timestamp
    FROM product_events
    GROUP BY user_id
)
SELECT
    u.user_id,
    u.signup_date,
    f.first_activity_timestamp,
    DATEDIFF(
        DAY,
        u.signup_date,
        f.first_activity_timestamp
    ) AS days_to_first_activity
FROM users u
INNER JOIN FirstActivity f
    ON u.user_id = f.user_id
ORDER BY days_to_first_activity;

-- 7. Time to First Feature Adoption
WITH FirstFeature AS
(
    SELECT
        user_id,
        MIN(first_used_at) AS first_feature_timestamp
    FROM feature_usage
    GROUP BY user_id
)
SELECT
    u.user_id,
    u.signup_date,
    f.first_feature_timestamp,
    DATEDIFF(
        DAY,
        u.signup_date,
        f.first_feature_timestamp
    ) AS days_to_first_feature
FROM users u
INNER JOIN FirstFeature f
    ON u.user_id = f.user_id
ORDER BY days_to_first_feature;

-- 8. Users Who Have Not Adopted Features
SELECT
    u.user_id,
    u.signup_date,
    u.user_role,
    u.acquisition_channel,
    u.country
FROM users u
LEFT JOIN feature_usage f
    ON u.user_id = f.user_id
WHERE f.user_id IS NULL
ORDER BY u.signup_date;

-- 9. User Journey Segmentation
WITH EventMetrics AS
(
    SELECT
        user_id,
        COUNT(*) AS total_events
    FROM product_events
    GROUP BY user_id
),
FeatureMetrics AS
(
    SELECT
        user_id,
        COUNT(DISTINCT feature_name) AS features_adopted
    FROM feature_usage
    GROUP BY user_id
),
APIMetrics AS
(
    SELECT
        user_id,
        SUM(request_count) AS total_api_requests
    FROM api_usage
    GROUP BY user_id
),
UserJourney AS
(
    SELECT
        u.user_id,
        COALESCE(e.total_events, 0) AS total_events,
        COALESCE(f.features_adopted, 0) AS features_adopted,
        COALESCE(a.total_api_requests, 0) AS total_api_requests
    FROM users u
    LEFT JOIN EventMetrics e
        ON u.user_id = e.user_id
    LEFT JOIN FeatureMetrics f
        ON u.user_id = f.user_id
    LEFT JOIN APIMetrics a
        ON u.user_id = a.user_id
)
SELECT
    CASE
        WHEN total_events = 0
            THEN 'No Product Activity'
        WHEN features_adopted = 0
             AND total_api_requests = 0
            THEN 'Basic Activity Only'
        WHEN features_adopted > 0
             AND total_api_requests = 0
            THEN 'Feature Adopter'
        WHEN features_adopted = 0
             AND total_api_requests > 0
            THEN 'API User'
        ELSE 'Feature and API Adopter'
    END AS journey_stage,
    COUNT(*) AS total_users
FROM UserJourney
GROUP BY
    CASE
        WHEN total_events = 0
            THEN 'No Product Activity'
        WHEN features_adopted = 0
             AND total_api_requests = 0
            THEN 'Basic Activity Only'
        WHEN features_adopted > 0
             AND total_api_requests = 0
            THEN 'Feature Adopter'
        WHEN features_adopted = 0
             AND total_api_requests > 0
            THEN 'API User'
        ELSE 'Feature and API Adopter'
    END
ORDER BY total_users DESC;

-- 