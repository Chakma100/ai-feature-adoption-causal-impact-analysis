-- Check missing values

-- A. Organizations
SELECT
    COUNTIF(organization_id IS NULL) AS null_organization_id,
    COUNTIF(organization_name IS NULL) AS null_organization_name,
    COUNTIF(industry IS NULL) AS null_industry,
    COUNTIF(created_date IS NULL) AS null_created_date
FROM `ecommerce-sales-nabin-2026.devflow_raw.organizations`;

-- B.  users
SELECT
    COUNTIF(subscription_id IS NULL) AS null_subscription_id,
    COUNTIF(organization_id IS NULL) AS null_organization_id,
    COUNTIF(plan_type IS NULL) AS null_plan_type,
    COUNTIF(start_date IS NULL) AS null_start_date,
    COUNTIF(end_date IS NULL) AS null_end_date,
    COUNTIF(monthly_price IS NULL) AS null_monthly_price
FROM `ecommerce-sales-nabin-2026.devflow_raw.subscriptions`;

-- C. Subscriptions
SELECT
    COUNTIF(subscription_id IS NULL) AS null_subscription_id,
    COUNTIF(organization_id IS NULL) AS null_organization_id,
    COUNTIF(plan_type IS NULL) AS null_plan_type,
    COUNTIF(start_date IS NULL) AS null_start_date,
    COUNTIF(end_date IS NULL) AS null_end_date,
    COUNTIF(monthly_price IS NULL) AS null_monthly_price
FROM `ecommerce-sales-nabin-2026.devflow_raw.subscriptions`;

--D. Product events
SELECT
    COUNTIF(event_id IS NULL) AS null_event_id,
    COUNTIF(user_id IS NULL) AS null_user_id,
    COUNTIF(event_name IS NULL) AS null_event_name,
    COUNTIF(event_timestamp IS NULL) AS null_event_timestamp
FROM `ecommerce-sales-nabin-2026.devflow_raw.product_events`;


-- E. Remaining tables
-- Feature usage
SELECT
    COUNTIF(usage_id IS NULL) AS null_usage_id,
    COUNTIF(user_id IS NULL) AS null_user_id,
    COUNTIF(feature_name IS NULL) AS null_feature_name,
    COUNTIF(first_used_at IS NULL) AS null_first_used_at
FROM `ecommerce-sales-nabin-2026.devflow_raw.feature_usage`;


-- API usage
SELECT
    COUNTIF(api_usage_id IS NULL) AS null_api_usage_id,
    COUNTIF(user_id IS NULL) AS null_user_id,
    COUNTIF(request_timestamp IS NULL) AS null_request_timestamp
FROM `ecommerce-sales-nabin-2026.devflow_raw.api_usage`;


-- Experiment assignments
SELECT
    COUNTIF(assignment_id IS NULL) AS null_assignment_id,
    COUNTIF(experiment_id IS NULL) AS null_experiment_id,
    COUNTIF(user_id IS NULL) AS null_user_id,
    COUNTIF(variant IS NULL) AS null_variant
FROM `ecommerce-sales-nabin-2026.devflow_raw.experiment_assignments`;


-- Experiment outcomes
SELECT
    COUNTIF(outcome_id IS NULL) AS null_outcome_id,
    COUNTIF(assignment_id IS NULL) AS null_assignment_id,
    COUNTIF(user_id IS NULL) AS null_user_id
FROM `ecommerce-sales-nabin-2026.devflow_raw.experiment_outcomes`;