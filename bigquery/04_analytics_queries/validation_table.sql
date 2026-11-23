

-- Step-1: Verify all created tables
SELECT
    table_name

FROM
`ecommerce-sales-nabin-2026.github_activity_analytics.INFORMATION_SCHEMA.TABLES`

ORDER BY table_name;


-- Step-2.Run final validation queries

-- Check the base table:


SELECT
    COUNT(*) AS total_events,
    COUNT(DISTINCT developer) AS total_developers,
    COUNT(DISTINCT repository) AS total_repositories,
    MIN(activity_date) AS first_activity_date,
    MAX(activity_date) AS last_activity_date
FROM
`ecommerce-sales-nabin-2026.github_activity_analytics.github_activity_events`;


-- - Check the event distribution:

SELECT
    event_type,
    COUNT(*) AS total_events
FROM
`ecommerce-sales-nabin-2026.github_activity_analytics.github_activity_events`
GROUP BY event_type
ORDER BY total_events DESC;



--- Check the top 10 developers

SELECT *
FROM
`ecommerce-sales-nabin-2026.github_activity_analytics.developer_activity_summary`
ORDER BY total_events DESC
LIMIT 10;


--- Check the top 10 repositories:

SELECT *
FROM
`ecommerce-sales-nabin-2026.github_activity_analytics.repository_engagement_summary`
ORDER BY total_events DESC
LIMIT 10;
