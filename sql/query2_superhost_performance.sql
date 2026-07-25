
WITH borough_stats AS (
    SELECT
        neighbourhood_cleansed AS borough,
        host_is_superhost,
        COUNT(*) AS n_listings,
        ROUND(AVG(review_scores_rating), 3) AS avg_rating,
        ROUND(AVG(reviews_per_month), 2) AS avg_reviews_pm,
        ROUND(AVG(price), 2) AS avg_price
    FROM listings
    WHERE review_scores_rating IS NOT NULL
      AND host_is_superhost IS NOT NULL
    GROUP BY neighbourhood_cleansed, host_is_superhost
    HAVING COUNT(*) >= 30
)
SELECT
    borough,
    host_is_superhost,
    n_listings,
    avg_rating,
    avg_reviews_pm,
    avg_price,
    RANK() OVER (PARTITION BY host_is_superhost ORDER BY avg_rating DESC) AS rating_rank
FROM borough_stats
ORDER BY borough, host_is_superhost DESC
LIMIT 30
