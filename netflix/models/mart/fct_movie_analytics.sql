WITH movies AS (
    SELECT * FROM {{ ref('dim_movies') }}
),

genres AS (
    SELECT * FROM {{ ref('int_movies_with_genres') }}
),

genre_performance AS (
    SELECT
        g.genre,
        COUNT(DISTINCT g.movie_id) AS total_movies,
        AVG(m.avg_rating) AS avg_genre_rating,
        SUM(m.total_ratings) AS total_genre_ratings,
        AVG(m.total_ratings) AS avg_ratings_per_movie,
        COUNT(DISTINCT CASE WHEN m.rating_category = 'Excellent' THEN g.movie_id END) AS excellent_movies
    FROM genres g
    JOIN movies m ON g.movie_id = m.movie_id
    GROUP BY g.genre
),

year_performance AS (
    SELECT
        release_year,
        COUNT(*) AS movies_released,
        AVG(avg_rating) AS avg_year_rating,
        SUM(total_ratings) AS total_year_ratings
    FROM movies
    WHERE release_year IS NOT NULL
    GROUP BY release_year
)

SELECT
    gp.genre,
    gp.total_movies,
    ROUND(gp.avg_genre_rating, 2) AS avg_rating,
    gp.total_genre_ratings,
    ROUND(gp.avg_ratings_per_movie, 0) AS avg_ratings_per_movie,
    gp.excellent_movies,
    ROUND(gp.excellent_movies * 100.0 / gp.total_movies, 1) AS excellent_movie_pct,
    RANK() OVER (ORDER BY gp.avg_genre_rating DESC) AS genre_rank_by_rating,
    RANK() OVER (ORDER BY gp.total_genre_ratings DESC) AS genre_rank_by_popularity,
    CURRENT_TIMESTAMP() AS created_at
FROM genre_performance gp
ORDER BY avg_rating DESC