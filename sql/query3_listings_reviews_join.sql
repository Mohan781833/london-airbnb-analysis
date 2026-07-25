
SELECT
    l.neighbourhood_cleansed AS borough,
    l.room_type,
    COUNT(DISTINCT l.id) AS n_listings,
    COUNT(r.id) AS total_reviews,
    ROUND(COUNT(r.id) * 1.0 / COUNT(DISTINCT l.id), 1) AS reviews_per_listing,
    ROUND(AVG(l.review_scores_rating), 3) AS avg_rating
FROM listings l
INNER JOIN reviews r
    ON l.id = r.listing_id
WHERE l.review_scores_rating IS NOT NULL
GROUP BY l.neighbourhood_cleansed, l.room_type
HAVING COUNT(DISTINCT l.id) >= 30
ORDER BY reviews_per_listing DESC
LIMIT 20
