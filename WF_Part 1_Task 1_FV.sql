-- Расчёт с использованием first_value
SELECT init.first_name, init.last_name, init.salary, init.industry, T_h.name_highest_sal FROM salary init
JOIN
	(SELECT DISTINCT s.industry, (first_name || ' ' || last_name) AS name_highest_sal FROM salary s
			JOIN
				(SELECT industry, FIRST_VALUE(salary) OVER (PARTITION BY industry ORDER BY salary DESC) AS highest_sal FROM salary) t
			ON s.industry = t.industry AND s.salary = t.highest_sal) t_h
ON init.industry = t_h.industry
--ORDER BY industry