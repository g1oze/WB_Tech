WITH sums AS
	(SELECT DISTINCT "SHOPNUMBER", 
		SUM("QTY") OVER(PARTITION BY "SHOPNUMBER") AS "SUM_QTY", 
		SUM("QTY" * "PRICE") OVER(PARTITION BY "SHOPNUMBER") AS "SUM_QTY_PRICE" 
		FROM "SALES" s
			JOIN "GOODS" g 
			ON s."ID_GOOD" = g."ID_GOOD"
		-- Данные нужны за 02.01.2016 (DD-MM-YYYY)
		WHERE "DATE" = '2016-01-02') -- Формат YYYY-MM-DD
	
SELECT sh."SHOPNUMBER", "CITY", "ADDRESS", "SUM_QTY", "SUM_QTY_PRICE" FROM "SHOPS" sh
JOIN sums ON sums."SHOPNUMBER" = sh."SHOPNUMBER"