SELECT res.seller_id, res.total_categ, res.avg_rating, res.total_revenue,
CASE
	WHEN res.total_revenue >= 50000 THEN 'rich' --По условию выходит, что оба неравенства строгие, но я отнесу 50000 к rich
	ELSE 'poor' --Здесь имеем только тех продавцов, которые продают более одной категории товаров, так что можно применить ELSE
END AS seller_type
FROM 

--Подзапрос для определения типа продавца
(SELECT seller_id, COUNT(category) as total_categ, ROUND(AVG(rating), 1) as avg_rating, SUM(revenue) as total_revenue
FROM sellers
WHERE category != 'Bedding' --Исключаем категорию "Bedding" из расчётов
GROUP BY seller_id
HAVING COUNT(category) > 1) res --Выбираем тех продацов, что продают более одной категории товаров

--Итоговые данные сортируем по возрастанию seller_id
ORDER BY seller_id ASC