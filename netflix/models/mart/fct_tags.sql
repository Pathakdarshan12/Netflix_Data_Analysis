WITH tags AS (
    SELECT * FROM {{ ref('stg_tags') }}
),

movies AS (
    SELECT * FROM {{ ref('dim_movies') }}
),

users AS (
    SELECT * FROM {{ ref('dim_users') }}
)

SELECT
    MD5(CONCAT(t.user_id, '-', t.movie_id, '-', t.tag, '-', t.tagged_at)) AS tag_id,
    t.user_id,
    t.movie_id,
    t.tag,
    t.tagged_at,
    
    -- Movie context
    m.title AS movie_title,
    m.genres AS movie_genres,
    m.avg_rating AS movie_avg_rating,
    
    -- User context
    u.user_segment,
    u.total_tags AS user_total_tags,
    
    -- Check if tag matches genome tags
    CASE
        WHEN m.top_genome_tags LIKE '%' || t.tag || '%' THEN TRUE
        ELSE FALSE
    END AS matches_genome_tag
    
FROM tags t
LEFT JOIN movies m ON t.movie_id = m.movie_id
LEFT JOIN users u ON t.user_id = u.user_id