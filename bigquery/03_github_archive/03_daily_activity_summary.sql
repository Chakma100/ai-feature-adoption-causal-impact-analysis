CREATE OR REPLACE TABLE
`ecommerce-sales-nabin-2026.github_activity_analytics.daily_activity_summary`
AS

SELECT
    activity_date,

    COUNT(*) AS total_events,

    COUNT(DISTINCT developer) AS active_developers,

    COUNT(DISTINCT repository) AS active_repositories,

    COUNTIF(event_type = 'PushEvent') AS push_events,

    COUNTIF(event_type = 'PullRequestEvent') AS pull_request_events,

    COUNTIF(event_type = 'IssuesEvent') AS issue_events,

    COUNTIF(event_type = 'WatchEvent') AS watch_events,

    COUNTIF(event_type = 'ForkEvent') AS fork_events

FROM
`ecommerce-sales-nabin-2026.github_activity_analytics.github_activity_events`

GROUP BY activity_date
ORDER BY activity_date;