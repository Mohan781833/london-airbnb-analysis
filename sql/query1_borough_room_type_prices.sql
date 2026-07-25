
SELECT
     neighbourhood_cleansed AS borough,
     room_type,
     COUNT(*) AS n_listings,
     ROUND(AVG(price), 2) AS avg_price,
     ROUND(MIN(price), 2) AS min_price,
     ROUND(MAX(price), 2) AS max_price
FROM listings
WHERE price IS NOT NULL
GROUP BY neighbourhood_cleansed, room_type
HAVING COUNT(*) >= 30
ORDER BY avg_price DESC
LIMIT 20
