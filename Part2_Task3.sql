SELECT seller_id, res.category_pair
FROM
-- Подзапрос на нужных продавцов
(SELECT seller_id, STRING_AGG(category, ' - ') as category_pair, COUNT(category) as total_categ, SUM(revenue) as total_revenue, EXTRACT(YEAR FROM MIN(date_reg)) as year_reg
FROM sellers
-- WHERE category != 'Bedding' В пункте(3) про эту категорию уже ничего не сказано
GROUP BY seller_id
HAVING COUNT(category) = 2 AND SUM(revenue) > 75000 AND EXTRACT(YEAR FROM MIN(date_reg)) = 2012) res --Тестирую на 2012, потому что 2022 выдаёт 0 таких продавцов
--Сортировка по возрастанию seller_id
ORDER BY seller_id ASC