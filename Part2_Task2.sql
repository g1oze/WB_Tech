-- Задание выполняю 16.11.2024

SELECT seller_id, EXTRACT(DAY FROM (NOW() - date_reg) / 30) as month_from_registration,   
	-- Вывод max_delivery_difference по всем неуспешным продавцам (то есть глобальный максимум - глобалтный минимум по всем неуспешным)
	(SELECT MAX(delivery_days) - MIN(delivery_days) as max_delivery_difference FROM sellers 
	WHERE seller_id IN (SELECT res.seller_id FROM 
	(SELECT seller_id, COUNT(category) as total_categ, SUM(revenue) as total_revenue
	FROM sellers
	WHERE category != 'Bedding'
	GROUP BY seller_id
	HAVING COUNT(category) > 1 AND SUM(revenue) < 50000) res))
	--
FROM
-- Таблица из (1), но только с 'poor' продавцами и нужными данными
(SELECT seller_id, COUNT(category) as total_categ, SUM(revenue) as total_revenue, MIN(date_reg) as date_reg
FROM sellers
WHERE category != 'Bedding'
GROUP BY seller_id
HAVING COUNT(category) > 1 AND SUM(revenue) < 50000) res
--Сортировка по возрастанию seller_id
ORDER BY seller_id ASC