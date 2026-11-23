-- check duplicate users

SELECT
    user_id,
    COUNT(*) AS duplicate_count

FROM `ecommerce-sales-nabin-2026.devflow_raw.users`

GROUP BY user_id

HAVING COUNT(*) > 1;

-- Check duplicate IDs across all tables
-- Organizations
SELECT organization_id, COUNT(*) AS duplicate_count
FROM `ecommerce-sales-nabin-2026.devflow_raw.organizations`
GROUP BY organization_id
HAVING COUNT(*) > 1;


-- Product events
SELECT event_id, COUNT(*) AS duplicate_count
FROM `ecommerce-sales-nabin-2026.devflow_raw.product_events`
GROUP BY event_id
HAVING COUNT(*) > 1;


-- Subscriptions
SELECT subscription_id, COUNT(*) AS duplicate_count
FROM `ecommerce-sales-nabin-2026.devflow_raw.subscriptions`
GROUP BY subscription_id
HAVING COUNT(*) > 1;


-- API usage
SELECT api_usage_id, COUNT(*) AS duplicate_count
FROM `ecommerce-sales-nabin-2026.devflow_raw.api_usage`
GROUP BY api_usage_id
HAVING COUNT(*) > 1;S