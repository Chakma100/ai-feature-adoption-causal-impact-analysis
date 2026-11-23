CREATE OR REPLACE TABLE
`ecommerce-sales-nabin-2026.github_activity_analytics.repository_engagement_summary`
AS

SELECT
    repository,

    COUNT(*) AS total_events,

    COUNT(DISTINCT developer) AS unique_developers,

    COUNTIF(event_type = 'PushEvent') AS push_events,

    COUNTIF(event_type = 'PullRequestEvent') AS pull_request_events,

    COUNTIF(event_type = 'IssuesEvent') AS issue_events,

    COUNTIF(event_type = 'WatchEvent') AS watch_events,

    COUNTIF(event_type = 'ForkEvent') AS fork_events,

    MAX(activity_date) AS last_activity_date

FROM
`ecommerce-sales-nabin-2026.github_activity_analytics.github_activity_events`

GROUP BY repository
ORDER BY total_events DESC;