WITH ratings AS (
    SELECT * FROM {{ ref('stg_ratings') }}
),

movies_genres AS (
    SELECT * FROM {{ ref('int_movies_with_genres') }}
),

user_genre_ratings AS (
    SELECT
        r.user_id,
        mg.genre,
        AVG(r.rating) AS avg_rating,
        COUNT(*) AS rating_count
    FROM ratings r
    JOIN movies_genres mg ON r.movie_id = mg.movie_id
    GROUP BY r.user_id, mg.genre
)

SELECT
    user_id,
    genre,
    avg_rating,
    rating_count,
    RANK() OVER (PARTITION BY user_id ORDER BY avg_rating DESC) AS genre_preference_rank
FROM user_genre_ratings