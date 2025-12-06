WITH movies AS (
    SELECT * FROM {{ ref('stg_movies') }}
),

links AS (
    SELECT * FROM {{ ref('stg_links') }}
)

SELECT
    m.movie_id,
    m.title,
    m.genres,
    m.release_year,
    l.imdb_id,
    l.tmdb_id,
    CONCAT('https://www.imdb.com/title/tt', LPAD(l.imdb_id, 7, '0')) AS imdb_url,
    CONCAT('https://www.themoviedb.org/movie/', l.tmdb_id) AS tmdb_url
FROM movies m
LEFT JOIN links l ON m.movie_id = l.movie_id