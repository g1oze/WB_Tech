-- Нужны топ-3 товаров по продажам в штуках в каждом магазине в каждую дату
WITH sorted AS
	-- Ранжируем по убыванию продаж в штуках в каждом магазине в каждую дату
	(SELECT 
		"DATE", 
		"SHOPNUMBER", 
		"QTY", 
		"ID_GOOD", 
		RANK() OVER 
			(PARTITION BY "SHOPNUMBER", "DATE" ORDER BY "QTY" DESC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS "NUM_SEQ"
	FROM "SALES")

SELECT "DATE", "SHOPNUMBER", "ID_GOOD" FROM sorted
--Использовали RANK(), поэтому фильтруем так, чтобы его значение не превышало 3. 
WHERE "NUM_SEQ" <= 3
--Например, если 4 первых товара одинаковой цены, то все они имеют ранг 1, и все они попадут. 
--Но следующий по количеству продаж товар уже имеет ранг 5, а не 2 (в отличие от DENSE_RANK()), так что он уже не попадёт.