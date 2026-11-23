-- Check invalid values

--- A. Negative API usage
SELECT *
FROM `ecommerce-sales-nabin-2026.devflow_raw.api_usage`
WHERE request_count < 0
   OR success_count < 0
   OR error_count < 0
   OR response_time_ms < 0;

-- B. API count inconsistency
SELECT *
FROM `ecommerce-sales-nabin-2026.devflow_raw.api_usage`
WHERE success_count + error_count != request_count;

-- C. Invalid feature usage
SELECT *
FROM `ecommerce-sales-nabin-2026.devflow_raw.feature_usage`
WHERE usage_count < 0
   OR first_used_at > last_used_at;

-- D. Invalid subscription values
SELECT *
FROM `ecommerce-sales-nabin-2026.devflow_raw.subscriptions`
WHERE monthly_price < 0
   OR (end_date IS NOT NULL AND end_date < start_date);


--- E. Invalid experiment variants
SELECT *
FROM `ecommerce-sales-nabin-2026.devflow_raw.experiment_assignments`
WHERE variant NOT IN ('Control', 'Treatment')
   OR variant IS NULL;


--- F. Invalid experiment outcomes
SELECT *
FROM `ecommerce-sales-nabin-2026.devflow_raw.experiment_outcomes`
WHERE sdk_integrated NOT IN (0, 1)
   OR first_api_request NOT IN (0, 1)
   OR adopted_feature NOT IN (0, 1)
   OR retained_d7 NOT IN (0, 1);