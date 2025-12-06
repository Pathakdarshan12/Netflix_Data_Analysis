WITH user_activity AS (
    SELECT * FROM {{ ref('int_user_activity') }}
),

user_preferences AS (
    SELECT
        user_id,
        LISTAGG(genre, ', ') WITHIN GROUP (ORDER BY genre_preference_rank) AS top_genres
    FROM {{ ref('int_user_preferences') }}
    WHERE genre_preference_rank <= 3
    GROUP BY user_id
)

SELECT
    ua.user_id,
    ua.total_ratings,
    ua.avg_rating_given,
    ua.total_tags,
    ua.first_activity,
    ua.last_activity,
    ua.active_days,
    up.top_genres AS favorite_genres,
    
    CASE
        WHEN ua.total_ratings >= 500 THEN 'Power User'
        WHEN ua.total_ratings >= 100 THEN 'Active User'
        WHEN ua.total_ratings >= 20 THEN 'Regular User'
        ELSE 'Casual User'
    END AS user_segment,
    
    CASE
        WHEN ua.total_tags > 0 THEN TRUE
        ELSE FALSE
    END AS is_tagger,
    
    CURRENT_TIMESTAMP() AS created_at
    
FROM user_activity ua
LEFT JOIN user_preferences up ON ua.user_id = up.user_id