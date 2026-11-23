
WITH feature_adoption AS (

    SELECT
        feature_name,
        total_adopting_users,
        total_usage_count,
        average_usage_per_record,
        first_adoption_date,
        latest_usage_date

    FROM {{ ref('int_feature_adoption') }}

),

user_base AS (

    SELECT
        COUNT(DISTINCT user_id) AS total_users

    FROM {{ ref('stg_users') }}

),

final AS (

    SELECT
        f.feature_name,

        f.total_adopting_users,

        u.total_users,

        f.total_usage_count,

        ROUND(
            SAFE_DIVIDE(
                f.total_adopting_users,
                u.total_users
            ) * 100,
            2
        ) AS adoption_rate_percentage,

        ROUND(
            SAFE_DIVIDE(
                f.total_usage_count,
                f.total_adopting_users
            ),
            2
        ) AS average_usage_per_adopting_user,

        f.average_usage_per_record,

        f.first_adoption_date,

        f.latest_usage_date,

        DENSE_RANK() OVER (
            ORDER BY f.total_adopting_users DESC
        ) AS adoption_rank

    FROM feature_adoption AS f

    CROSS JOIN user_base AS u

)

SELECT *
FROM final