
WITH experiment_assignments AS (

    SELECT
        assignment_id,
        experiment_id,
        user_id,
        variant,
        assigned_at

    FROM {{ ref('stg_experiment_assignments') }}

),

experiment_outcomes AS (

    SELECT
        outcome_id,
        assignment_id,
        user_id,
        sdk_integrated,
        first_api_request,
        adopted_feature,
        retained_d7,
        measured_at

    FROM {{ ref('stg_experiment_outcomes') }}

),

experiment_results AS (

    SELECT
        a.assignment_id,
        a.experiment_id,
        a.user_id,
        a.variant,
        a.assigned_at,

        o.outcome_id,
        o.sdk_integrated,
        o.first_api_request,
        o.adopted_feature,
        o.retained_d7,
        o.measured_at

    FROM experiment_assignments AS a

    LEFT JOIN experiment_outcomes AS o
        ON a.assignment_id = o.assignment_id
        AND a.user_id = o.user_id

)

SELECT *
FROM experiment_results