-- В условии не вполне чётко сказано про то, смотрим ли мы на следующие запросы именно этого пользователя и именно с этого устройства, когда определяем next_query. Полагаю, что да:
-- Таким образом, в next_query я помещаю следующий запрос данного пользователя с данного устройства.
WITH t AS
	(SELECT 
		*, 
		LEAD(query, 1) OVER(PARTITION BY userid, devicetype ORDER BY searchid ASC) AS next_query,
		-- Сюда помещаю время следующего запроса данного пользователя с данного устройства.
		LEAD(ts, 1) OVER(PARTITION BY userid, devicetype ORDER BY searchid ASC) AS next_query_ts
	FROM query 
	ORDER BY searchid)

-- Исходя из определенных мной next_query и next_query_ts определяю is_final
SELECT "year", "month", "day", userid, ts, devicetype, deviceid, "query", next_query,
CASE 
	WHEN next_query IS NULL OR next_query_ts - ts > 60 * 3 THEN 1
	WHEN LENGTH(next_query) < LENGTH(query) AND next_query_ts - ts > 60 THEN 2 -- Пробелы тоже считаю в длине запроса; разница времен в формате unix есть количество секунд
	ELSE 0
END AS is_final
FROM t