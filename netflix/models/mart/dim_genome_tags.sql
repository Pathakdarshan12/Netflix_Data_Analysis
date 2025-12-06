WITH genome_tags AS (
    SELECT * FROM {{ ref('stg_genome_tags') }}
),

genome_usage AS (
    SELECT
        tag_id,
        COUNT(DISTINCT movie_id) AS movies_tagged,
        AVG(relevance) AS avg_relevance,
        MAX(relevance) AS max_relevance
    FROM {{ ref('stg_genome_scores') }}
    GROUP BY tag_id
)

SELECT
    gt.tag_id,
    gt.tag,
    gu.movies_tagged,
    gu.avg_relevance,
    gu.max_relevance,
    
    CASE
        WHEN gu.movies_tagged >= 1000 THEN 'Common'
        WHEN gu.movies_tagged >= 100 THEN 'Moderate'
        ELSE 'Rare'
    END AS tag_frequency,
    
    CURRENT_TIMESTAMP() AS created_at
    
FROM genome_tags gt
LEFT JOIN genome_usage gu ON gt.tag_id = gu.tag_id