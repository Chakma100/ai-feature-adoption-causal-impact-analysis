WITH experiment_results AS (

    SELECT
        experiment_id,
        variant,
        assignment_id,
        user_id,
        sdk_integrated,
        first_api_request,
        adopted_feature,
        retained_d7

    FROM {{ ref('int_experiment_results') }}

),

experiment_summary AS (

    SELECT
        experiment_id,
        variant,

        COUNT(DISTINCT assignment_id) AS assigned_users,

        COUNT(sdk_integrated) AS users_with_sdk_outcome,
        COUNT(first_api_request) AS users_with_api_outcome,
        COUNT(adopted_feature) AS users_with_adoption_outcome,
        COUNT(retained_d7) AS users_with_retention_outcome,

        SUM(sdk_integrated) AS sdk_integrations,
        SUM(first_api_request) AS first_api_requests,
        SUM(adopted_feature) AS feature_adoptions,
        SUM(retained_d7) AS retained_users_d7

    FROM experiment_results

    GROUP BY
        experiment_id,
        variant

)

SELECT
    experiment_id,
    variant,

    assigned_users,

    sdk_integrations,

    ROUND(
        SAFE_DIVIDE(
            sdk_integrations,
            users_with_sdk_outcome
        ) * 100,
        2
    ) AS sdk_integration_rate_pct,

    first_api_requests,

    ROUND(
        SAFE_DIVIDE(
            first_api_requests,
            users_with_api_outcome
        ) * 100,
        2
    ) AS first_api_request_rate_pct,

    feature_adoptions,

    ROUND(
        SAFE_DIVIDE(
            feature_adoptions,
            users_with_adoption_outcome
        ) * 100,
        2
    ) AS feature_adoption_rate_pct,

    retained_users_d7,

    ROUND(
        SAFE_DIVIDE(
            retained_users_d7,
            users_with_retention_outcome
        ) * 100,
        2
    ) AS d7_retention_rate_pct

FROM experiment_summary