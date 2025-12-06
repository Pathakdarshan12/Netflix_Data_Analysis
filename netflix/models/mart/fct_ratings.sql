{{ config(materialized='incremental', unique_key='rating_id') }}

WITH ratings AS (
    SELECT * FROM {{ ref('stg_ratings') }}
),

movies AS (
    SELECT * FROM {{ ref('dim_movies') }}
),

users AS (
    SELECT * FROM {{ ref('dim_users') }}
)

{% if is_incremental() %}
, max_date AS (
    SELECT MAX(rated_at) AS max_rated_at
    FROM {{ this }}
)
{% endif %}

SELECT
    MD5(CONCAT(r.user_id, '-', r.movie_id, '-', r.rated_at)) AS rating_id,
    r.user_id,
    r.movie_id,
    r.rating,
    r.rated_at,
    
    -- Movie context
    m.title AS movie_title,
    m.genres AS movie_genres,
    m.avg_rating AS movie_avg_rating,
    m.rating_category,
    
    -- User context
    u.user_segment,
    u.avg_rating_given AS user_avg_rating,
    
    -- Calculations
    r.rating - m.avg_rating AS rating_vs_avg,
    r.rating - u.avg_rating_given AS rating_vs_user_avg,
    
    CASE
        WHEN r.rating >= 4.0 THEN 'Positive'
        WHEN r.rating >= 3.0 THEN 'Neutral'
        ELSE 'Negative'
    END AS rating_sentiment
    
FROM ratings r
LEFT JOIN movies m ON r.movie_id = m.movie_id
LEFT JOIN users u ON r.user_id = u.user_id

{% if is_incremental() %}
CROSS JOIN max_date
WHERE r.rated_at > max_date.max_rated_at
{% endif %}