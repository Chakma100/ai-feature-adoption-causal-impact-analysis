-- Step: Feature Usage Analysis

-- 1. Explore Available Features
SELECT DISTINCT
    feature_name
FROM feature_usage
ORDER BY feature_name;

-- 2. Total Feature Usage
SELECT
    COUNT(*) AS total_feature_records,
    COUNT(DISTINCT user_id) AS total_users_using_features,
    COUNT(DISTINCT feature_name) AS total_features,
    SUM(usage_count) AS total_feature_usage
FROM feature_usage;

-- 3. Feature Popularity Analysis
SELECT
    feature_name,
    COUNT(DISTINCT user_id) AS unique_users,
    SUM(usage_count) AS total_usage,
    AVG(CAST(usage_count AS DECIMAL(10,2))) AS avg_usage_per_record
FROM feature_usage
GROUP BY feature_name
ORDER BY total_usage DESC;

-- 4. Feature Adoption Rate
WITH TotalUsers AS
(
    SELECT COUNT(*) AS total_users
    FROM users
),
FeatureAdoption AS
(
    SELECT
        feature_name,
        COUNT(DISTINCT user_id) AS adopted_users
    FROM feature_usage
    GROUP BY feature_name
)
SELECT
    f.feature_name,
    f.adopted_users,
    t.total_users,
    CAST(
        f.adopted_users * 100.0 /
        NULLIF(t.total_users, 0)
        AS DECIMAL(10,2)
    ) AS adoption_rate_percentage
FROM FeatureAdoption f
CROSS JOIN TotalUsers t
ORDER BY adoption_rate_percentage DESC;

-- 5. First Feature Adoption Analysis
SELECT
    feature_name,
    MIN(first_used_at) AS first_adoption_date,
    MAX(first_used_at) AS latest_first_adoption_date,
    COUNT(DISTINCT user_id) AS adopted_users
FROM feature_usage
GROUP BY feature_name
ORDER BY first_adoption_date;

-- 6. Feature Usage by User Role
SELECT
    u.user_role,
    f.feature_name,
    COUNT(DISTINCT u.user_id) AS unique_users,
    SUM(f.usage_count) AS total_usage,
    CAST(
        AVG(CAST(f.usage_count AS DECIMAL(10,2)))
        AS DECIMAL(10,2)
    ) AS avg_usage_per_record
FROM users u
INNER JOIN feature_usage f
    ON u.user_id = f.user_id
GROUP BY
    u.user_role,
    f.feature_name
ORDER BY
    u.user_role,
    total_usage DESC;

-- 7. Feature Usage by Acquisition Channel
SELECT
    u.acquisition_channel,
    f.feature_name,
    COUNT(DISTINCT u.user_id) AS adopted_users,
    SUM(f.usage_count) AS total_usage
FROM users u
INNER JOIN feature_usage f
    ON u.user_id = f.user_id
GROUP BY
    u.acquisition_channel,
    f.feature_name
ORDER BY
    u.acquisition_channel,
    adopted_users DESC;

-- 8. Top 20 Users by Feature Usage
SELECT TOP 20
    user_id,
    COUNT(DISTINCT feature_name) AS unique_features_used,
    SUM(usage_count) AS total_usage,
    MAX(last_used_at) AS latest_feature_activity
FROM feature_usage
GROUP BY user_id
ORDER BY total_usage DESC;

-- 9. Users Who Have Not Adopted Any Feature
SELECT
    u.user_id,
    u.user_role,
    u.acquisition_channel,
    u.signup_date
FROM users u
LEFT JOIN feature_usage f
    ON u.user_id = f.user_id
WHERE f.user_id IS NULL
ORDER BY u.signup_date;

-- 10. Feature Usage Frequency Segmentation
WITH UserFeatureUsage AS
(
    SELECT
        user_id,
        SUM(usage_count) AS total_usage
    FROM feature_usage
    GROUP BY user_id
)
SELECT
    CASE
        WHEN total_usage BETWEEN 1 AND 10
            THEN 'Low Usage'
        WHEN total_usage BETWEEN 11 AND 50
            THEN 'Medium Usage'
        WHEN total_usage BETWEEN 51 AND 100
            THEN 'High Usage'
        ELSE 'Very High Usage'
    END AS usage_segment,
    COUNT(*) AS total_users
FROM UserFeatureUsage
GROUP BY
    CASE
        WHEN total_usage BETWEEN 1 AND 10
            THEN 'Low Usage'
        WHEN total_usage BETWEEN 11 AND 50
            THEN 'Medium Usage'
        WHEN total_usage BETWEEN 51 AND 100
            THEN 'High Usage'
        ELSE 'Very High Usage'
    END
ORDER BY total_users DESC;