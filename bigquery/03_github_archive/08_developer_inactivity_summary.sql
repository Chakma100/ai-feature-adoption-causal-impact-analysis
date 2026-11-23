

CREATE OR REPLACE TABLE
`ecommerce-sales-nabin-2026.github_activity_analytics.developer_inactivity_summary`
AS

WITH developer_last_activity AS (

    SELECT
        developer,

        COUNT(*) AS total_events,

        COUNT(DISTINCT repository) AS repositories_contributed,

        MIN(activity_date) AS first_activity_date,

        MAX(activity_date) AS last_activity_date

    FROM
    `ecommerce-sales-nabin-2026.github_activity_analytics.github_activity_events`

    GROUP BY developer
)

SELECT
    developer,

    total_events,

    repositories_contributed,

    first_activity_date,

    last_activity_date,

    DATE_DIFF(
        DATE '2025-01-31',
        last_activity_date,
        DAY
    ) AS days_since_last_activity

FROM developer_last_activity

WHERE DATE_DIFF(
    DATE '2025-01-31',
    last_activity_date,
    DAY
) >= 7

ORDER BY days_since_last_activity DESC;