--  Step — Signup Analysis:

-- A. Total User Signups
SELECT
    COUNT(*) AS total_signups
FROM users;

-- B. Daily Signup Analysis
SELECT
    signup_date,
    COUNT(*) AS daily_signups
FROM users
GROUP BY signup_date
ORDER BY signup_date;

-- C. Monthly Signup Analysis
SELECT
    YEAR(signup_date) AS signup_year,
    MONTH(signup_date) AS signup_month,
    COUNT(*) AS monthly_signups
FROM users
GROUP BY
    YEAR(signup_date),
    MONTH(signup_date)
ORDER BY
    signup_year,
    signup_month;

-- D. Yearly Signup Analysis
SELECT
    YEAR(signup_date) AS signup_year,
    COUNT(*) AS yearly_signups
FROM users
GROUP BY YEAR(signup_date)
ORDER BY signup_year;

-- E. Signup by Country
SELECT
    country,
    COUNT(*) AS total_signups
FROM users
GROUP BY country
ORDER BY total_signups DESC;

-- F. Signup by User Role
SELECT
    user_role,
    COUNT(*) AS total_signups
FROM users
GROUP BY user_role
ORDER BY total_signups DESC;

-- G. Signup by Acquisition Channel
SELECT
    acquisition_channel,
    COUNT(*) AS total_signups
FROM users
GROUP BY acquisition_channel
ORDER BY total_signups DESC;

-- H. Verified vs Unverified Users
SELECT
    is_verified,
    COUNT(*) AS total_users,
    CAST(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()
        AS DECIMAL(5,2)
    ) AS percentage
FROM users
GROUP BY is_verified;

-- I. Monthly Signup Growth Rate
WITH monthly_signup AS
(
    SELECT
        DATEFROMPARTS(
            YEAR(signup_date),
            MONTH(signup_date),
            1
        ) AS signup_month,
        COUNT(*) AS total_signups
    FROM users
    GROUP BY
        YEAR(signup_date),
        MONTH(signup_date)
),
signup_growth AS
(
    SELECT
        signup_month,
        total_signups,
        LAG(total_signups) OVER (
            ORDER BY signup_month
        ) AS previous_month_signups
    FROM monthly_signup
)
SELECT
    signup_month,
    total_signups,
    previous_month_signups,
    CAST(
        (total_signups - previous_month_signups) * 100.0
        / NULLIF(previous_month_signups, 0)
        AS DECIMAL(10,2)
    ) AS growth_rate_percentage
FROM signup_growth
ORDER BY signup_month;

-- J. Signup by Organization Industry
SELECT
    o.industry,
    COUNT(u.user_id) AS total_signups
FROM users u
JOIN organizations o
    ON u.organization_id = o.organization_id
GROUP BY o.industry
ORDER BY total_signups DESC;