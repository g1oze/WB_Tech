-- Расчёт с использованием last_value
SELECT init.first_name, init.last_name, init.salary, init.industry, t_h.name_lowest_sal FROM salary init
JOIN
	(SELECT DISTINCT s.industry, (first_name || ' ' || last_name) AS name_lowest_sal FROM salary s
			JOIN
				(SELECT industry, LAST_VALUE(salary) OVER (PARTITION BY industry ORDER BY salary DESC RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lowest_sal FROM salary) t
			ON s.industry = t.industry AND s.salary = t.lowest_sal) t_h
ON init.industry = t_h.industry
ORDER BY industry