
WITH subscriptions AS (

    SELECT
        subscription_id,
        organization_id,
        plan_type,
        start_date,
        end_date,
        monthly_price,
        subscription_status

    FROM {{ ref('stg_subscriptions') }}

),

subscription_metrics AS (

    SELECT
        plan_type,

        COUNT(DISTINCT subscription_id)
            AS total_subscriptions,

        COUNT(DISTINCT organization_id)
            AS total_organizations,

        COUNTIF(
            end_date IS NOT NULL
            AND end_date < CURRENT_DATE()
        ) AS churned_subscriptions,

        COUNTIF(
            end_date IS NULL
            OR end_date >= CURRENT_DATE()
        ) AS non_churned_subscriptions,

        SUM(monthly_price) AS total_monthly_subscription_value,

        AVG(monthly_price) AS average_monthly_price,

        MIN(start_date) AS first_subscription_date,

        MAX(start_date) AS latest_subscription_date

    FROM subscriptions

    GROUP BY plan_type

),

final AS (

    SELECT
        plan_type,

        total_subscriptions,

        total_organizations,

        churned_subscriptions,

        non_churned_subscriptions,

        ROUND(
            SAFE_DIVIDE(
                churned_subscriptions,
                total_subscriptions
            ) * 100,
            2
        ) AS churn_rate_percentage,

        ROUND(
            SAFE_DIVIDE(
                non_churned_subscriptions,
                total_subscriptions
            ) * 100,
            2
        ) AS non_churn_rate_percentage,

        ROUND(
            total_monthly_subscription_value,
            2
        ) AS total_monthly_subscription_value,

        ROUND(
            average_monthly_price,
            2
        ) AS average_monthly_price,

        first_subscription_date,

        latest_subscription_date,

        DENSE_RANK() OVER (
            ORDER BY
                SAFE_DIVIDE(
                    churned_subscriptions,
                    total_subscriptions
                ) DESC
        ) AS churn_risk_rank

    FROM subscription_metrics

)

SELECT *
FROM final
