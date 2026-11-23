-- Step : API Usage Analysis

-- 1. Total API Usage
SELECT
    COUNT(*) AS total_api_records,
    COUNT(DISTINCT user_id) AS unique_api_users,
    COUNT(DISTINCT endpoint) AS total_endpoints,
    SUM(request_count) AS total_requests,
    SUM(success_count) AS total_success_requests,
    SUM(error_count) AS total_error_requests
FROM api_usage;

-- 2. API Usage by Endpoint
SELECT
    endpoint,
    COUNT(*) AS total_records,
    COUNT(DISTINCT user_id) AS unique_users,
    SUM(request_count) AS total_requests,
    SUM(success_count) AS successful_requests,
    SUM(error_count) AS failed_requests
FROM api_usage
GROUP BY endpoint
ORDER BY total_requests DESC;

-- 3. API Success Rate
SELECT
    SUM(request_count) AS total_requests,
    SUM(success_count) AS successful_requests,
    CAST(
        SUM(success_count) * 100.0 /
        NULLIF(SUM(request_count), 0)
        AS DECIMAL(10,2)
    ) AS success_rate_percentage
FROM api_usage;

-- 4. API Error Rate
SELECT
    SUM(request_count) AS total_requests,
    SUM(error_count) AS failed_requests,
    CAST(
        SUM(error_count) * 100.0 /
        NULLIF(SUM(request_count), 0)
        AS DECIMAL(10,2)
    ) AS error_rate_percentage
FROM api_usage;

-- 5. API Performance by Endpoint
SELECT
    endpoint,
    SUM(request_count) AS total_requests,
    AVG(response_time_ms) AS avg_response_time_ms,
    MIN(response_time_ms) AS min_response_time_ms,
    MAX(response_time_ms) AS max_response_time_ms
FROM api_usage
GROUP BY endpoint
ORDER BY avg_response_time_ms DESC;

-- 6. API Performance Summary
SELECT
    COUNT(*) AS total_api_records,
    AVG(response_time_ms) AS avg_response_time_ms,
    MIN(response_time_ms) AS min_response_time_ms,
    MAX(response_time_ms) AS max_response_time_ms
FROM api_usage;

-- 7. API Usage by User
SELECT TOP 20
    user_id,
    COUNT(*) AS total_api_records,
    SUM(request_count) AS total_requests,
    SUM(success_count) AS successful_requests,
    SUM(error_count) AS failed_requests,
    AVG(response_time_ms) AS avg_response_time_ms
FROM api_usage
GROUP BY user_id
ORDER BY total_requests DESC;

-- 8. API Error Analysis by Endpoint
SELECT
    endpoint,
    SUM(request_count) AS total_requests,
    SUM(error_count) AS total_errors,
    CAST(
        SUM(error_count) * 100.0 /
        NULLIF(SUM(request_count), 0)
        AS DECIMAL(10,2)
    ) AS error_rate_percentage
FROM api_usage
GROUP BY endpoint
ORDER BY error_rate_percentage DESC;

-- 9. Daily API Usage Trend
SELECT
    CAST(request_timestamp AS DATE) AS activity_date,
    SUM(request_count) AS total_requests,
    SUM(success_count) AS successful_requests,
    SUM(error_count) AS failed_requests,
    COUNT(DISTINCT user_id) AS active_api_users
FROM api_usage
GROUP BY CAST(request_timestamp AS DATE)
ORDER BY activity_date;

-- 10. API Usage by User Role
SELECT
    u.user_role,
    COUNT(DISTINCT u.user_id) AS unique_users,
    SUM(a.request_count) AS total_requests,
    SUM(a.success_count) AS successful_requests,
    SUM(a.error_count) AS failed_requests,
    AVG(a.response_time_ms) AS avg_response_time_ms
FROM users u
INNER JOIN api_usage a
    ON u.user_id = a.user_id
GROUP BY u.user_role
ORDER BY total_requests DESC;

-- 11. API Usage by Subscription Plan
SELECT
    s.plan_type,
    COUNT(DISTINCT a.user_id) AS unique_api_users,
    SUM(a.request_count) AS total_requests,
    SUM(a.success_count) AS successful_requests,
    SUM(a.error_count) AS failed_requests,
    AVG(a.response_time_ms) AS avg_response_time_ms
FROM subscriptions s
INNER JOIN users u
    ON s.organization_id = u.organization_id
INNER JOIN api_usage a
    ON u.user_id = a.user_id
GROUP BY s.plan_type
ORDER BY total_requests DESC;

-- 