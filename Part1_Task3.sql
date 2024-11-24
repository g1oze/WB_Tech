SELECT res.customer_id, customers_new_3.name, res. delayed_orders, res.canceled_orders, res.sum_orders
FROM
	(SELECT COALESCE(t_delayed.customer_id, t_canceled.customer_id) as customer_id, 
	COALESCE(t_delayed.delayed_orders, 0) AS delayed_orders, COALESCE(t_canceled.canceled_orders, 0) AS canceled_orders, 
	-- Полагаю, речь про сумму для каждого клиента: сумма количества отмененных заказов + сумма количества заказов с задержкой более чем на 5 дней
	(COALESCE(t_delayed.delayed_orders, 0) + COALESCE(t_canceled.canceled_orders, 0)) AS sum_orders 
	FROM
		-- Ищем клиентов, у которых были заказы, доставленные с задержкой более чем на 5 дней
		(SELECT customer_id, COUNT(order_id) AS delayed_orders FROM orders_new_3 
		WHERE shipment_date - order_date > INTERVAL '5 days'
		-- Считаем количество заказов с задержкой более чем на 5 дней для таких клиентов
		GROUP BY customer_id) t_delayed
	FULL JOIN
		-- Ищем клиентов, у которых были отмененные заказы
		(SELECT customer_id, COUNT(order_id) AS canceled_orders FROM orders_new_3 
		WHERE order_status = 'Cancel'
		-- Считаем количество отмененных заказов для каждого такого клиента
		GROUP BY customer_id) t_canceled
	ON 	t_canceled.customer_id = t_delayed.customer_id) res
JOIN customers_new_3 ON res.customer_id = customers_new_3.customer_id
-- Опять же: интерепретирую условие на сортировку как по убыванию той суммы двух количеств (кол-во отмененных + кол-во с задержкой)
ORDER BY sum_orders DESC
