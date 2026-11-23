CREATE OR REPLACE TABLE
`ecommerce-sales-nabin-2026.github_activity_analytics.push_pull_request_summary`
AS

SELECT
    repository,

    COUNTIF(event_type = 'PushEvent') AS total_push_events,

    COUNTIF(event_type = 'PullRequestEvent') AS total_pull_request_events,

    COUNT(DISTINCT IF(
        event_type = 'PushEvent',
        developer,
        NULL
    )) AS developers_who_pushed,

    COUNT(DISTINCT IF(
        event_type = 'PullRequestEvent',
        developer,
        NULL
    )) AS developers_who_created_pr_events,

    MAX(activity_date) AS last_activity_date

FROM
`ecommerce-sales-nabin-2026.github_activity_analytics.github_activity_events`

WHERE event_type IN ('PushEvent', 'PullRequestEvent')

GROUP BY repository
ORDER BY total_push_events DESC;