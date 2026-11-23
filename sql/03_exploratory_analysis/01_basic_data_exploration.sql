-- Step — Basic Data Exploration:

-- A. Check All Table Row Counts
SELECT 'organizations' AS table_name, COUNT(*) AS total_rows
FROM organizations

UNION ALL
SELECT 'users', COUNT(*) FROM users

UNION ALL
SELECT 'subscriptions', COUNT(*) FROM subscriptions

UNION ALL
SELECT 'product_events', COUNT(*) FROM product_events

UNION ALL
SELECT 'feature_usage', COUNT(*) FROM feature_usage

UNION ALL
SELECT 'api_usage', COUNT(*) FROM api_usage

UNION ALL
SELECT 'experiment_assignments', COUNT(*) FROM experiment_assignments

UNION ALL
SELECT 'experiment_outcomes', COUNT(*) FROM experiment_outcomes;

-- B. View Sample Records
SELECT TOP 10 * FROM organizations;

SELECT TOP 10 * FROM users;

SELECT TOP 10 * FROM subscriptions;

SELECT TOP 10 * FROM product_events;

SELECT TOP 10 * FROM feature_usage;

SELECT TOP 10 * FROM api_usage;

SELECT TOP 10 * FROM experiment_assignments;

SELECT TOP 10 * FROM experiment_outcomes;

-- C. Check User Signup Date Range
SELECT
    MIN(signup_date) AS first_signup_date,
    MAX(signup_date) AS latest_signup_date,
    COUNT(*) AS total_users
FROM users;

-- D. Check Organization Distribution
SELECT
    industry,
    COUNT(*) AS total_organizations
FROM organizations
GROUP BY industry
ORDER BY total_organizations DESC;


-- E. Check User Role Distribution
SELECT
    user_role,
    COUNT(*) AS total_users
FROM users
GROUP BY user_role
ORDER BY total_users DESC;

-- F. Check Acquisition Channel
SELECT
    acquisition_channel,
    COUNT(*) AS total_users
FROM users
GROUP BY acquisition_channel
ORDER BY total_users DESC;

-- G. Check Product Event Distribution
SELECT
    event_name,
    COUNT(*) AS total_events
FROM product_events
GROUP BY event_name
ORDER BY total_events DESC;

-- H. Check Feature Distribution
SELECT
    feature_name,
    COUNT(*) AS total_records,
    SUM(usage_count) AS total_feature_usage
FROM feature_usage
GROUP BY feature_name
ORDER BY total_feature_usage DESC;

-- I. Check API Endpoint Distribution
SELECT
    endpoint,
    SUM(request_count) AS total_requests,
    SUM(error_count) AS total_errors
FROM api_usage
GROUP BY endpoint
ORDER BY total_requests DESC;
