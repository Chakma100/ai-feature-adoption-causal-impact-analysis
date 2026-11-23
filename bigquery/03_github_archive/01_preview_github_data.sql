
SELECT
    type AS event_type,
    COUNT(*) AS total_events
FROM `githubarchive.day.202501*`
WHERE _TABLE_SUFFIX BETWEEN '01' AND '07'
GROUP BY event_type
ORDER BY total_events DESC;


SELECT
    id,
    type,
    created_at,
    actor.login AS developer,
    repo.name AS repository
FROM `githubarchive.day.202501*`
WHERE _TABLE_SUFFIX BETWEEN '01' AND '07'
LIMIT 100;