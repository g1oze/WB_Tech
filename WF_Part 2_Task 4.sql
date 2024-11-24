--Для наглядности использую CTE:
WITH t_sales AS
	--Ищем для каждого магазина и товарного направления сумму продаж в рублях за данную дату
	(SELECT DISTINCT
		"DATE", 
		"SHOPNUMBER", 
		"CATEGORY", 
		SUM("QTY" * "PRICE") OVER (PARTITION BY "DATE", "SHOPNUMBER", "CATEGORY") AS "THIS_DAY_SALES" FROM "SALES" s
			JOIN "GOODS" g ON s."ID_GOOD" = g."ID_GOOD"
			WHERE "SHOPNUMBER" IN 
			(
				--Отбираем магазины Санкт-Петербурга
				SELECT "SHOPNUMBER" FROM "SHOPS"
				WHERE "CITY" = 'СПб'
			)
	ORDER BY "SHOPNUMBER", "DATE")

-- Итоговый запрос суммы продаж в рублях за предыдущую дату для каждого магазина СПб и товарного направления
SELECT 
	"DATE", 
	"SHOPNUMBER", 
	"CATEGORY",
	LAG("THIS_DAY_SALES", 1) OVER (PARTITION BY "SHOPNUMBER", "CATEGORY" ORDER BY "DATE" ASC) AS "PREV_SALES"
FROM t_sales

--Обнаружил недостаток, что скрипт выдаёт именно информацию по предудыщей дате, в которую были покупки в данной категории, а не по вчерашней дате.
--Соответственно, если в этот день нет покупок в данной категории, то и за вчера информацию тоже не выводит.
--Впрочем, не знаю, проблема ли это, или именно это и спрашивалось.
--Например, 2 января в магазине 1 было не было продано товаров в категории ДЕКОР, и потому скрипт возвращает не 0, а выручку с 1 января.