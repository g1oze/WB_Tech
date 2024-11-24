SELECT res.customer_id, t.name, res.avg_time, res.sum_orders
FROM
	(SELECT t1.customer_id, t2.avg_time, t2.sum_orders
	FROM
		(
		SELECT customer_id 
		FROM 
			(SELECT customer_id, COUNT(order_id) as num_orders FROM orders_new_3
			GROUP BY customer_id) 
		WHERE num_orders = (SELECT MAX(num_orders) FROM 
				(SELECT customer_id, COUNT(order_id) as num_orders FROM orders_new_3
				GROUP BY customer_id))
		)t1
	JOIN
		(SELECT customer_id, AVG(shipment_date - order_date) AS avg_time, SUM(order_ammount) AS sum_orders FROM orders_new_3
		GROUP BY customer_id) t2 
	ON t1.customer_id = t2.customer_id) res
--Опять же, выведу клиентов с их именами:
JOIN customers_new_3 t ON t.customer_id = res.customer_id
--Сортируем по убыванию суммы заказов:
ORDER BY res.sum_orders DESC