WITH ratings AS (
    SELECT * FROM {{ ref('stg_ratings') }}
),

tags AS (
    SELECT * FROM {{ ref('stg_tags') }}
),

user_ratings AS (
    SELECT
        user_id,
        COUNT(*) AS total_ratings,
        AVG(rating) AS avg_rating_given,
        MIN(rated_at) AS first_activity,
        MAX(rated_at) AS last_activity
    FROM ratings
    GROUP BY user_id
),

user_tags AS (
    SELECT
        user_id,
        COUNT(*) AS total_tags
    FROM tags
    GROUP BY user_id
)

SELECT
    COALESCE(ur.user_id, ut.user_id) AS user_id,
    COALESCE(ur.total_ratings, 0) AS total_ratings,
    ur.avg_rating_given,
    COALESCE(ut.total_tags, 0) AS total_tags,
    ur.first_activity,
    ur.last_activity,
    DATEDIFF(day, ur.first_activity, ur.last_activity) AS active_days
FROM user_ratings ur
FULL OUTER JOIN user_tags ut ON ur.user_id = ut.user_id