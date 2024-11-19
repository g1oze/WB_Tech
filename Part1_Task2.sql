SELECT category, ROUND(AVG(price),2) AS "avg_price" FROM products 
WHERE name LIKE '%Hair%' OR name LIKE '%Home%'
GROUP BY category