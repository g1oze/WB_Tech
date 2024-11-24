-- Раз расчёты требуеются только по направлению ЧИСТОТА и требуется вывести CITY, то, полагаю,
-- искомая доля за каждую дату должна искаться с агрегацией по городу (т.е будет доля продаж (в рублях) в данном городе в данный день от продаж по всем городам в данный день)

-- Для наглядности итоговую долю нахожу после абсолютных значений:
SELECT "DATE", "CITY", 
	ROUND(CAST("DATE_CITY_SUM_QTY_PRICE" AS DECIMAL(10, 2)) / "DATE_SUM_QTY_PRICE", 2)  AS "SUM_SALES_REL" 
FROM
(
	-- Таблица с абсолютными значениями сумм продаж (в рублях) в категории ЧИСТОТА по (дате) и по (дате и городу)
	SELECT DISTINCT "DATE", "CITY", 
		SUM("QTY" * "PRICE") OVER(PARTITION BY "DATE") AS "DATE_SUM_QTY_PRICE",
		SUM("QTY" * "PRICE") OVER(PARTITION BY "DATE", "CITY") AS "DATE_CITY_SUM_QTY_PRICE" FROM "SHOPS" sh
	JOIN
		(SELECT "DATE", s."ID_GOOD", "SHOPNUMBER", g."CATEGORY", "QTY", "PRICE" FROM "SALES" s
			JOIN "GOODS" g ON s."ID_GOOD" = g."ID_GOOD"
		WHERE "CATEGORY" = 'ЧИСТОТА') t
	ON t."SHOPNUMBER" = sh."SHOPNUMBER"
)
ORDER BY "DATE"