SELECT t1.customer_id, t2.name FROM (SELECT customer_id FROM orders_new_3
WHERE shipment_date - order_date = (SELECT MAX(shipment_date - order_date) as max_time FROM orders_new_3)) t1
-- Полагаю, нас интереусуют имена этих клиентов
JOIN customers_new_3 t2 ON t1.customer_id = t2.customer_id
