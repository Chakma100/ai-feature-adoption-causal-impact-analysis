

CREATE OR REPLACE TABLE
`ecommerce-sales-nabin-2026.github_activity_analytics.github_activity_events`
AS

SELECT
    id AS event_id,
    type AS event_type,
    created_at,
    DATE(created_at) AS activity_date,
    actor.login AS developer,
    repo.name AS repository

FROM `githubarchive.day.202501*`

WHERE
    _TABLE_SUFFIX BETWEEN '01' AND '07'
    AND actor.login IS NOT NULL
    AND repo.name IS NOT NULL;