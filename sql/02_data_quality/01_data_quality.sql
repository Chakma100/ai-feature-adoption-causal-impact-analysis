-- Step 1 — Row Count Validation:

SELECT 'organizations' AS table_name,
       COUNT(*) AS total_rows
FROM organizations

UNION ALL

SELECT 'users', COUNT(*) FROM users

UNION ALL

SELECT 'subscriptions', COUNT(*) FROM subscriptions

UNION ALL

SELECT 'product_events', COUNT(*) FROM product_events

UNION ALL

SELECT 'feature_usage', COUNT(*) FROM feature_usage

UNION ALL

SELECT 'api_usage', COUNT(*) FROM api_usage

UNION ALL

SELECT 'experiment_assignments',
       COUNT(*) FROM experiment_assignments

UNION ALL

SELECT 'experiment_outcomes',
       COUNT(*) FROM experiment_outcomes;


-- Step 2 — Duplicate Check:

-- Organizations
SELECT organization_id, COUNT(*) AS duplicate_count
FROM organizations
GROUP BY organization_id
HAVING COUNT(*) > 1;

-- Users
SELECT user_id, COUNT(*) AS duplicate_count
FROM users
GROUP BY user_id
HAVING COUNT(*) > 1;

-- Subscriptions
SELECT subscription_id, COUNT(*) AS duplicate_count
FROM subscriptions
GROUP BY subscription_id
HAVING COUNT(*) > 1;

-- Product Events
SELECT event_id, COUNT(*) AS duplicate_count
FROM product_events
GROUP BY event_id
HAVING COUNT(*) > 1;

-- Feature Usage
SELECT usage_id, COUNT(*) AS duplicate_count
FROM feature_usage
GROUP BY usage_id
HAVING COUNT(*) > 1;

-- API Usage
SELECT api_usage_id, COUNT(*) AS duplicate_count
FROM api_usage
GROUP BY api_usage_id
HAVING COUNT(*) > 1;

-- Experiment Assignments
SELECT assignment_id, COUNT(*) AS duplicate_count
FROM experiment_assignments
GROUP BY assignment_id
HAVING COUNT(*) > 1;

-- Experiment Outcomes
SELECT outcome_id, COUNT(*) AS duplicate_count
FROM experiment_outcomes
GROUP BY outcome_id
HAVING COUNT(*) > 1;

-- Step 3 — NULL Value Check:

-- Users table
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END)
        AS null_user_id,
    SUM(CASE WHEN organization_id IS NULL THEN 1 ELSE 0 END)
        AS null_organization_id,
    SUM(CASE WHEN signup_date IS NULL THEN 1 ELSE 0 END)
        AS null_signup_date
FROM users;

-- Product Events table
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN event_id IS NULL THEN 1 ELSE 0 END)
        AS null_event_id,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END)
        AS null_user_id,
    SUM(CASE WHEN event_timestamp IS NULL THEN 1 ELSE 0 END)
        AS null_timestamp
FROM product_events;

-- Subscriptions table
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN subscription_id IS NULL THEN 1 ELSE 0 END)
        AS null_subscription_id,
    SUM(CASE WHEN organization_id IS NULL THEN 1 ELSE 0 END)
        AS null_organization_id,
    SUM(CASE WHEN end_date IS NULL THEN 1 ELSE 0 END)
        AS null_end_date
FROM subscriptions;

-- Organizations table 
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN organization_id IS NULL THEN 1 ELSE 0 END) AS null_organization_id,
    SUM(CASE WHEN organization_name IS NULL THEN 1 ELSE 0 END) AS null_organization_name,
    SUM(CASE WHEN created_date IS NULL THEN 1 ELSE 0 END) AS null_created_date
FROM organizations;

-- Feature Usage table 
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN usage_id IS NULL THEN 1 ELSE 0 END) AS null_usage_id,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN feature_name IS NULL THEN 1 ELSE 0 END) AS null_feature_name,
    SUM(CASE WHEN first_used_at IS NULL THEN 1 ELSE 0 END) AS null_first_used_at
FROM feature_usage;

-- API Usage table 
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN api_usage_id IS NULL THEN 1 ELSE 0 END) AS null_api_usage_id,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN request_timestamp IS NULL THEN 1 ELSE 0 END) AS null_request_timestamp,
    SUM(CASE WHEN endpoint IS NULL THEN 1 ELSE 0 END) AS null_endpoint
FROM api_usage;

-- Experiment Assignments
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN assignment_id IS NULL THEN 1 ELSE 0 END) AS null_assignment_id,
    SUM(CASE WHEN experiment_id IS NULL THEN 1 ELSE 0 END) AS null_experiment_id,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN variant IS NULL THEN 1 ELSE 0 END) AS null_variant
FROM experiment_assignments;

-- Experiment Outcomes
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN outcome_id IS NULL THEN 1 ELSE 0 END) AS null_outcome_id,
    SUM(CASE WHEN assignment_id IS NULL THEN 1 ELSE 0 END) AS null_assignment_id,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN measured_at IS NULL THEN 1 ELSE 0 END) AS null_measured_at
FROM experiment_outcomes;

-- Step 4 — Complete Invalid Value Check

-- A. Negative API Usage
SELECT *
FROM api_usage
WHERE request_count < 0
   OR success_count < 0
   OR error_count < 0
   OR response_time_ms < 0;

-- B. API Request Calculation
SELECT *
FROM api_usage
WHERE success_count + error_count <> request_count;

-- C. Invalid Feature Usage
SELECT *
FROM feature_usage
WHERE usage_count < 0
   OR first_used_at > last_used_at;

-- D. Invalid Subscription Price
SELECT *
FROM subscriptions
WHERE monthly_price < 0;

-- E. Invalid Experiment Variants
SELECT *
FROM experiment_assignments
WHERE variant NOT IN ('Control', 'Treatment')
   OR variant IS NULL;

-- F. Invalid User Role 
SELECT *
FROM users
WHERE user_role NOT IN (
    'Developer',
    'Admin',
    'Manager'
);

-- G. Invalid Subscription Dates
SELECT *
FROM subscriptions
WHERE end_date < start_date;

-- H. Invalid Signup Date
SELECT *
FROM users
WHERE signup_date > CAST(GETDATE() AS DATE);

-- I. Invalid Event Timestamp
SELECT *
FROM product_events
WHERE event_timestamp > SYSDATETIME();

-- J. Invalid API Timestamp
SELECT *
FROM api_usage
WHERE request_timestamp > SYSDATETIME();

-- K. Invalid Experiment Outcome Values
SELECT *
FROM experiment_outcomes
WHERE sdk_integrated NOT IN (0, 1)
   OR first_api_request NOT IN (0, 1)
   OR adopted_feature NOT IN (0, 1)
   OR retained_d7 NOT IN (0, 1);

-- L. Experiment Assignment and Outcome Consistency
SELECT
    eo.outcome_id,
    eo.assignment_id,
    eo.user_id AS outcome_user_id,
    ea.user_id AS assigned_user_id
FROM experiment_outcomes eo
JOIN experiment_assignments ea
    ON eo.assignment_id = ea.assignment_id
WHERE eo.user_id <> ea.user_id;

-- Step 5 — Primary Key Check:

-- A. Check Primary Keys in All 8 Tables
SELECT
    TABLE_NAME,
    CONSTRAINT_NAME,
    CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE CONSTRAINT_TYPE = 'PRIMARY KEY'
ORDER BY TABLE_NAME;

-- B. Check Primary Key Columns
SELECT
    TABLE_NAME,
    COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE CONSTRAINT_NAME IN (
    SELECT CONSTRAINT_NAME
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_TYPE = 'PRIMARY KEY'
)
ORDER BY TABLE_NAME;

-- C. Check Duplicate Primary Key Values
SELECT organization_id, COUNT(*) AS duplicate_count
FROM organizations
GROUP BY organization_id
HAVING COUNT(*) > 1;

SELECT user_id, COUNT(*) AS duplicate_count
FROM users
GROUP BY user_id
HAVING COUNT(*) > 1;

SELECT subscription_id, COUNT(*) AS duplicate_count
FROM subscriptions
GROUP BY subscription_id
HAVING COUNT(*) > 1;

SELECT event_id, COUNT(*) AS duplicate_count
FROM product_events
GROUP BY event_id
HAVING COUNT(*) > 1;

SELECT usage_id, COUNT(*) AS duplicate_count
FROM feature_usage
GROUP BY usage_id
HAVING COUNT(*) > 1;

SELECT api_usage_id, COUNT(*) AS duplicate_count
FROM api_usage
GROUP BY api_usage_id
HAVING COUNT(*) > 1;

SELECT assignment_id, COUNT(*) AS duplicate_count
FROM experiment_assignments
GROUP BY assignment_id
HAVING COUNT(*) > 1;

SELECT outcome_id, COUNT(*) AS duplicate_count
FROM experiment_outcomes
GROUP BY outcome_id
HAVING COUNT(*) > 1;

-- D. Check NULL Primary Key Values
SELECT 'organizations' AS table_name, COUNT(*) AS null_primary_keys
FROM organizations
WHERE organization_id IS NULL

UNION ALL

SELECT 'users', COUNT(*)
FROM users
WHERE user_id IS NULL

UNION ALL

SELECT 'subscriptions', COUNT(*)
FROM subscriptions
WHERE subscription_id IS NULL

UNION ALL

SELECT 'product_events', COUNT(*)
FROM product_events
WHERE event_id IS NULL

UNION ALL

SELECT 'feature_usage', COUNT(*)
FROM feature_usage
WHERE usage_id IS NULL

UNION ALL

SELECT 'api_usage', COUNT(*)
FROM api_usage
WHERE api_usage_id IS NULL

UNION ALL

SELECT 'experiment_assignments', COUNT(*)
FROM experiment_assignments
WHERE assignment_id IS NULL

UNION ALL

SELECT 'experiment_outcomes', COUNT(*)
FROM experiment_outcomes
WHERE outcome_id IS NULL;

-- Step 6 — Foreign Key Validation 

-- A. Users → Organizations
SELECT
    u.user_id,
    u.organization_id
FROM users u
LEFT JOIN organizations o
    ON u.organization_id = o.organization_id
WHERE o.organization_id IS NULL;

-- B. Subscriptions → Organizations
SELECT
    s.subscription_id,
    s.organization_id
FROM subscriptions s
LEFT JOIN organizations o
    ON s.organization_id = o.organization_id
WHERE o.organization_id IS NULL;

-- C. Product Events → Users
SELECT
    pe.event_id,
    pe.user_id
FROM product_events pe
LEFT JOIN users u
    ON pe.user_id = u.user_id
WHERE u.user_id IS NULL;

-- D. Feature Usage → Users
SELECT
    fu.usage_id,
    fu.user_id
FROM feature_usage fu
LEFT JOIN users u
    ON fu.user_id = u.user_id
WHERE u.user_id IS NULL;

-- E. API Usage → Users
SELECT
    a.api_usage_id,
    a.user_id
FROM api_usage a
LEFT JOIN users u
    ON a.user_id = u.user_id
WHERE u.user_id IS NULL;

-- F. Experiment Assignments → Users
SELECT
    ea.assignment_id,
    ea.user_id
FROM experiment_assignments ea
LEFT JOIN users u
    ON ea.user_id = u.user_id
WHERE u.user_id IS NULL;

-- G. Experiment Outcomes → Experiment Assignments
SELECT
    eo.outcome_id,
    eo.assignment_id
FROM experiment_outcomes eo
LEFT JOIN experiment_assignments ea
    ON eo.assignment_id = ea.assignment_id
WHERE ea.assignment_id IS NULL;

-- H. Experiment Outcomes → Users
SELECT
    eo.outcome_id,
    eo.user_id
FROM experiment_outcomes eo
LEFT JOIN users u
    ON eo.user_id = u.user_id
WHERE u.user_id IS NULL;

-- I. Additional Consistency Check
SELECT
    eo.outcome_id,
    eo.assignment_id,
    eo.user_id AS outcome_user_id,
    ea.user_id AS assigned_user_id
FROM experiment_outcomes eo
INNER JOIN experiment_assignments ea
    ON eo.assignment_id = ea.assignment_id
WHERE eo.user_id <> ea.user_id;