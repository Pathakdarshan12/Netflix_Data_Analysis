WITH raw_ratings AS (
    select * from MOVIELENS.RAW.RAW_RATINGS
)

SELECT
    userId AS user_id,
    movieId AS movie_id,
    rating,
    TO_TIMESTAMP(timestamp) AS rated_at,
    CURRENT_TIMESTAMP() AS loaded_at
FROM raw_ratings
