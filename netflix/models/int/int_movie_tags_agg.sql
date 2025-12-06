WITH tags AS (
    SELECT * FROM {{ ref('stg_tags') }}
)

SELECT
    movie_id,
    COUNT(*) AS total_tags,
    COUNT(DISTINCT user_id) AS unique_taggers,
    COUNT(DISTINCT tag) AS unique_tags,
    LISTAGG(DISTINCT tag, ', ') WITHIN GROUP (ORDER BY tag) AS all_tags,
    MIN(tagged_at) AS first_tagged_at,
    MAX(tagged_at) AS last_tagged_at
FROM tags
GROUP BY movie_id