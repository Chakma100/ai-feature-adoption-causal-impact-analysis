
WITH feature_usage AS (

    SELECT
        user_id,
        feature_name,
        first_used_at,
        last_used_at,
        usage_count

    FROM {{ ref('stg_feature_usage') }}

),

user_features AS (

    SELECT
        user_id,

        COUNT(DISTINCT feature_name) AS total_features_adopted,

        SUM(usage_count) AS total_feature_usage,

        MIN(first_used_at) AS first_feature_adoption_date,

        MAX(last_used_at) AS last_feature_usage_date

    FROM feature_usage

    GROUP BY user_id

),

feature_summary AS (

    SELECT
        feature_name,

        COUNT(DISTINCT user_id) AS total_adopting_users,

        SUM(usage_count) AS total_usage_count,

        AVG(usage_count) AS average_usage_per_record,

        MIN(first_used_at) AS first_adoption_date,

        MAX(last_used_at) AS latest_usage_date

    FROM feature_usage

    GROUP BY feature_name

)

SELECT
    f.feature_name,

    f.total_adopting_users,

    f.total_usage_count,

    ROUND(f.average_usage_per_record, 2) AS average_usage_per_record,

    f.first_adoption_date,

    f.latest_usage_date

FROM feature_summary f
