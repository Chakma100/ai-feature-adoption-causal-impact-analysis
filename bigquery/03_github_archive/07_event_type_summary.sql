

CREATE OR REPLACE TABLE
`ecommerce-sales-nabin-2026.github_activity_analytics.event_type_summary`
AS

SELECT
    event_type,

    COUNT(*) AS total_events,

    COUNT(DISTINCT developer) AS unique_developers,

    COUNT(DISTINCT repository) AS unique_repositories,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS event_percentage

FROM
`ecommerce-sales-nabin-2026.github_activity_analytics.github_activity_events`

GROUP BY event_type
ORDER BY total_events DESC;