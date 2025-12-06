WITH genome_scores AS (
    SELECT * FROM {{ ref('stg_genome_scores') }}
),

genome_tags AS (
    SELECT * FROM {{ ref('stg_genome_tags') }}
)

SELECT
    gs.movie_id,
    gt.tag_id,
    gt.tag,
    gs.relevance,
    RANK() OVER (PARTITION BY gs.movie_id ORDER BY gs.relevance DESC) AS relevance_rank
FROM genome_scores gs
JOIN genome_tags gt ON gs.tag_id = gt.tag_id