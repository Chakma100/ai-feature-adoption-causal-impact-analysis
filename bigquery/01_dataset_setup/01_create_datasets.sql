--Create all four datasets

-- 1. Raw dataset
CREATE SCHEMA IF NOT EXISTS
`ecommerce-sales-nabin-2026.devflow_raw`
OPTIONS(location = 'US');


-- 2. Staging dataset
CREATE SCHEMA IF NOT EXISTS
`ecommerce-sales-nabin-2026.devflow_staging`
OPTIONS(location = 'US');


-- 3. Analytics dataset
CREATE SCHEMA IF NOT EXISTS
`ecommerce-sales-nabin-2026.devflow_analytics`
OPTIONS(location = 'US');


-- 4. GitHub activity dataset
CREATE SCHEMA IF NOT EXISTS
`ecommerce-sales-nabin-2026.github_activity_analytics`
OPTIONS(location = 'US');