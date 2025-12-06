WITH raw_movies AS (
        SELECT * FROM MOVIELENS.RAW.RAW_MOVIES
)
SELECT
    movieId AS movie_id,
    title,
    genres,
    SPLIT(genres, '|') AS genre_array,
    REGEXP_SUBSTR(title, '\\((\\d{4})\\)', 1, 1, 'e') AS release_year,
    CURRENT_TIMESTAMP() AS loaded_at
FROM raw_movies
