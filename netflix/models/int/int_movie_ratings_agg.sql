WITH ratings AS (
    SELECT * FROM {{ ref('stg_ratings') }}
)

SELECT
    movie_id,
    COUNT(*) AS total_ratings,
    COUNT(DISTINCT user_id) AS unique_users,
    AVG(rating) AS avg_rating,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    STDDEV(rating) AS rating_stddev,
    MEDIAN(rating) AS median_rating,
    MIN(rated_at) AS first_rated_at,
    MAX(rated_at) AS last_rated_at
FROM ratings
GROUP BY movie_id