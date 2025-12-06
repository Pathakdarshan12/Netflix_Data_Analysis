{{ config(materialized = 'table') }}
WITH raw_tags AS (
    SELECT * FROM movielens.raw.raw_tags
)
SELECT
    userId AS user_id,
    movieId AS movie_id,
    LOWER(TRIM(tag)) AS tag,
    TO_TIMESTAMP(timestamp) AS tagged_at,
    CURRENT_TIMESTAMP() AS loaded_at
FROM raw_tags
WHERE tag IS NOT NULL