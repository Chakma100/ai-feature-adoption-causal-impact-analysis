-- Step 2: Verify dataset creation

SELECT
    schema_name AS dataset_name
FROM
    `ecommerce-sales-nabin-2026.INFORMATION_SCHEMA.SCHEMATA`
WHERE
    schema_name IN (
        'devflow_raw',
        'devflow_staging',
        'devflow_analytics',
        'github_activity_analytics'
    )
ORDER BY dataset_name;