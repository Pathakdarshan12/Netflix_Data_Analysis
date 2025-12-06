WITH movies AS (
    SELECT * FROM {{ ref('stg_movies') }}
),

genres_split AS (
    SELECT
        movie_id,
        title,
        release_year,
        genre.value::STRING AS genre
    FROM movies,
    LATERAL FLATTEN(input => genre_array) genre
)

SELECT
    movie_id,
    title,
    release_year,
    genre
FROM genres_split