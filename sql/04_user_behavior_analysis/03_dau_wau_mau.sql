-- Step : DAU, WAU, and MAU Analysis

-- 1. Daily Active Users (DAU)
SELECT
    CAST(event_timestamp AS DATE) AS activity_date,
    COUNT(DISTINCT user_id) AS DAU
FROM product_events
GROUP BY CAST(event_timestamp AS DATE)
ORDER BY activity_date;

-- 2. Weekly Active Users (WAU)
WITH WeeklyActivity AS
(
    SELECT
        DATEADD(
            DAY,
            -(DATEDIFF(DAY, '19000101',
                CAST(event_timestamp AS DATE)) % 7),
            CAST(event_timestamp AS DATE)
        ) AS week_start,
        user_id
    FROM product_events
)
SELECT
    week_start,
    COUNT(DISTINCT user_id) AS WAU
FROM WeeklyActivity
GROUP BY week_start
ORDER BY week_start;

-- 3. Monthly Active Users (MAU)
SELECT
    DATEFROMPARTS(
        YEAR(event_timestamp),
        MONTH(event_timestamp),
        1
    ) AS month_start,
    COUNT(DISTINCT user_id) AS MAU
FROM product_events
GROUP BY
    YEAR(event_timestamp),
    MONTH(event_timestamp)
ORDER BY month_start;

-- 4. DAU Trend Analysis
WITH DailyActivity AS
(
    SELECT
        CAST(event_timestamp AS DATE) AS activity_date,
        COUNT(DISTINCT user_id) AS DAU
    FROM product_events
    GROUP BY CAST(event_timestamp AS DATE)
),
DailyTrend AS
(
    SELECT
        activity_date,
        DAU,
        LAG(DAU) OVER (
            ORDER BY activity_date
        ) AS previous_day_DAU
    FROM DailyActivity
)
SELECT
    activity_date,
    DAU,
    previous_day_DAU,
    DAU - previous_day_DAU AS user_change,
    CAST(
        (DAU - previous_day_DAU) * 100.0 /
        NULLIF(previous_day_DAU, 0)
        AS DECIMAL(10,2)
    ) AS growth_percentage
FROM DailyTrend
ORDER BY activity_date;

-- 5. WAU Trend Analysis
WITH WeeklyActivity AS
(
    SELECT
        DATEADD(
            DAY,
            -(DATEDIFF(DAY, '19000101',
                CAST(event_timestamp AS DATE)) % 7),
            CAST(event_timestamp AS DATE)
        ) AS week_start,
        user_id
    FROM product_events
),
WeeklyMetrics AS
(
    SELECT
        week_start,
        COUNT(DISTINCT user_id) AS WAU
    FROM WeeklyActivity
    GROUP BY week_start
),
WeeklyTrend AS
(
    SELECT
        week_start,
        WAU,
        LAG(WAU) OVER (
            ORDER BY week_start
        ) AS previous_week_WAU
    FROM WeeklyMetrics
)
SELECT
    week_start,
    WAU,
    previous_week_WAU,
    WAU - previous_week_WAU AS user_change,
    CAST(
        (WAU - previous_week_WAU) * 100.0 /
        NULLIF(previous_week_WAU, 0)
        AS DECIMAL(10,2)
    ) AS growth_percentage
FROM WeeklyTrend
ORDER BY week_start;

-- 6. MAU Trend Analysis
WITH MonthlyActivity AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(event_timestamp),
            MONTH(event_timestamp),
            1
        ) AS month_start,
        COUNT(DISTINCT user_id) AS MAU
    FROM product_events
    GROUP BY
        YEAR(event_timestamp),
        MONTH(event_timestamp)
),
MonthlyTrend AS
(
    SELECT
        month_start,
        MAU,
        LAG(MAU) OVER (
            ORDER BY month_start
        ) AS previous_month_MAU
    FROM MonthlyActivity
)
SELECT
    month_start,
    MAU,
    previous_month_MAU,
    MAU - previous_month_MAU AS user_change,
    CAST(
        (MAU - previous_month_MAU) * 100.0 /
        NULLIF(previous_month_MAU, 0)
        AS DECIMAL(10,2)
    ) AS growth_percentage
FROM MonthlyTrend
ORDER BY month_start;

-- 7. Average DAU and MAU Summary
WITH DailyActivity AS
(
    SELECT
        CAST(event_timestamp AS DATE) AS activity_date,
        COUNT(DISTINCT user_id) AS DAU
    FROM product_events
    GROUP BY CAST(event_timestamp AS DATE)
),
MonthlyDAU AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(activity_date),
            MONTH(activity_date),
            1
        ) AS month_start,
        AVG(CAST(DAU AS DECIMAL(18,2))) AS average_DAU
    FROM DailyActivity
    GROUP BY
        YEAR(activity_date),
        MONTH(activity_date)
),
MonthlyMAU AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(event_timestamp),
            MONTH(event_timestamp),
            1
        ) AS month_start,
        COUNT(DISTINCT user_id) AS MAU
    FROM product_events
    GROUP BY
        YEAR(event_timestamp),
        MONTH(event_timestamp)
)
SELECT
    d.month_start,
    d.average_DAU,
    m.MAU
FROM MonthlyDAU d
JOIN MonthlyMAU m
    ON d.month_start = m.month_start
ORDER BY d.month_start;

-- 8. DAU/MAU Engagement Ratio
WITH DailyActivity AS
(
    SELECT
        CAST(event_timestamp AS DATE) AS activity_date,
        COUNT(DISTINCT user_id) AS DAU
    FROM product_events
    GROUP BY CAST(event_timestamp AS DATE)
),
MonthlyDAU AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(activity_date),
            MONTH(activity_date),
            1
        ) AS month_start,
        AVG(CAST(DAU AS DECIMAL(18,2))) AS average_DAU
    FROM DailyActivity
    GROUP BY
        YEAR(activity_date),
        MONTH(activity_date)
),
MonthlyMAU AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(event_timestamp),
            MONTH(event_timestamp),
            1
        ) AS month_start,
        COUNT(DISTINCT user_id) AS MAU
    FROM product_events
    GROUP BY
        YEAR(event_timestamp),
        MONTH(event_timestamp)
)
SELECT
    d.month_start,
    d.average_DAU,
    m.MAU,
    CAST(
        d.average_DAU * 100.0 /
        NULLIF(m.MAU, 0)
        AS DECIMAL(10,2)
    ) AS DAU_MAU_Ratio_Percentage
FROM MonthlyDAU d
JOIN MonthlyMAU m
    ON d.month_start = m.month_start
ORDER BY d.month_start;

