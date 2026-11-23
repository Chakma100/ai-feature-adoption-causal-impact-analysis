SELECT
    'organizations' AS table_name,
    COUNT(*) AS total_rows
FROM `ecommerce-sales-nabin-2026.devflow_raw.organizations`

UNION ALL

SELECT
    'users',
    COUNT(*)
FROM `ecommerce-sales-nabin-2026.devflow_raw.users`

UNION ALL

SELECT
    'subscriptions',
    COUNT(*)
FROM `ecommerce-sales-nabin-2026.devflow_raw.subscriptions`

UNION ALL

SELECT
    'product_events',
    COUNT(*)
FROM `ecommerce-sales-nabin-2026.devflow_raw.product_events`

UNION ALL

SELECT
    'feature_usage',
    COUNT(*)
FROM `ecommerce-sales-nabin-2026.devflow_raw.feature_usage`

UNION ALL

SELECT
    'api_usage',
    COUNT(*)
FROM `ecommerce-sales-nabin-2026.devflow_raw.api_usage`

UNION ALL

SELECT
    'experiment_assignments',
    COUNT(*)
FROM `ecommerce-sales-nabin-2026.devflow_raw.experiment_assignments`

UNION ALL

SELECT
    'experiment_outcomes',
    COUNT(*)
FROM `ecommerce-sales-nabin-2026.devflow_raw.experiment_outcomes`;