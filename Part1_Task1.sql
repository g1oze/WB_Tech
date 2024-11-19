SELECT city, age, COUNT(*) as "quantity" FROM users
GROUP BY city, age
ORDER BY quantity DESC