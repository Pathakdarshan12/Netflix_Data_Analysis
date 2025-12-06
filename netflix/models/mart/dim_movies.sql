WITH movies AS (
    SELECT * FROM {{ ref('stg_movies') }}
),

links AS (
    SELECT * FROM {{ ref('stg_links') }}
),

ratings_agg AS (
    SELECT * FROM {{ ref('int_movie_ratings_agg') }}
),

tags_agg AS (
    SELECT * FROM {{ ref('int_movie_tags_agg') }}
),

top_genome_tags AS (
    SELECT
        movie_id,
        LISTAGG(tag, ', ') WITHIN GROUP (ORDER BY relevance_rank) AS top_genome_tags
    FROM {{ ref('int_movie_genome_tags') }}
    WHERE relevance_rank <= 5
    GROUP BY movie_id
)

SELECT
    m.movie_id,
    m.title,
    m.genres,
    m.release_year,
    l.imdb_id,
    l.tmdb_id,
    
    -- Rating metrics
    COALESCE(r.total_ratings, 0) AS total_ratings,
    COALESCE(r.unique_users, 0) AS unique_raters,
    r.avg_rating,
    r.median_rating,
    r.rating_stddev,
    
    -- Tag metrics
    COALESCE(t.total_tags, 0) AS total_tags,
    COALESCE(t.unique_tags, 0) AS unique_tags,
    t.all_tags AS user_tags,
    
    -- Genome tags
    gt.top_genome_tags,
    
    -- Categories
    CASE
        WHEN r.avg_rating >= 4.0 THEN 'Excellent'
        WHEN r.avg_rating >= 3.5 THEN 'Good'
        WHEN r.avg_rating >= 3.0 THEN 'Average'
        WHEN r.avg_rating >= 2.0 THEN 'Below Average'
        ELSE 'Poor'
    END AS rating_category,
    
    CASE
        WHEN r.total_ratings >= 1000 THEN 'Very Popular'
        WHEN r.total_ratings >= 100 THEN 'Popular'
        WHEN r.total_ratings >= 10 THEN 'Moderate'
        ELSE 'Niche'
    END AS popularity_tier,
    
    CURRENT_TIMESTAMP() AS created_at
    
FROM movies m
LEFT JOIN links l ON m.movie_id = l.movie_id
LEFT JOIN ratings_agg r ON m.movie_id = r.movie_id
LEFT JOIN tags_agg t ON m.movie_id = t.movie_id
LEFT JOIN top_genome_tags gt ON m.movie_id = gt.movie_id