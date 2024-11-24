-- Удобно прибегнуть к использованию CTE:
	-- Для (1):
WITH sum_cats AS
	-- Нужно вытащить order_ammount и product_category
	(SELECT product_category, SUM(order_ammount) AS cat_total_sum FROM orders_2 t1 
		JOIN products_3 t2 ON t1.product_id = t2.product_id
		GROUP BY product_category),
	-- Для (2):
	sum_products AS
	(SELECT product_name, SUM(order_ammount) AS sum_product FROM products_3 t1
		JOIN orders_2 t2 ON t1.product_id = t2.product_id
		GROUP BY product_name),
	-- Для (3):
	sum_pr AS
	(SELECT product_name, product_category, SUM(order_ammount) AS sum_product FROM products_3 t1
		JOIN orders_2 t2 ON t1.product_id = t2.product_id
		GROUP BY product_name, product_category)

--Итоговый запрос:
SELECT t1.product_category, t1.cat_total_sum, t1.max_cat, t2.product_name FROM
	(
	-- (1) и (2):
	SELECT * FROM sum_cats, 
		(SELECT product_category AS max_cat FROM sum_cats WHERE cat_total_sum = (SELECT MAX(cat_total_sum) FROM sum_cats))
	) t1

JOIN
-- (3): Запрос на имена продуктов с максимальной суммой продаж для каждой категории.
 	(SELECT sum_pr.product_category, product_name FROM sum_pr
 	JOIN
 		-- Здесь смотрим сумму продаж для продукта с максимальной суммой продаж в каждой категории.
 		(SELECT product_category, MAX(sum_product) AS max_sum_pr FROM sum_pr
 			GROUP BY product_category)
	ON max_sum_pr = sum_pr.sum_product) t2
ON t1.product_category = t2.product_category

--Отсортирую по убыванию суммы продаж:
ORDER BY cat_total_sum DESC