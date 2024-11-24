-- С использованием MIN без оконных функций
WITH t_h AS	
	(SELECT t.industry, (first_name || ' ' || last_name) AS name_highest_sal FROM salary 
		JOIN
			(SELECT industry, MIN(salary) as highest_sal FROM salary
				GROUP BY industry) t
		ON t.highest_sal = salary.salary AND salary.industry = t.industry)

SELECT init.first_name, init.last_name, init.salary, init.industry, t_h.name_highest_sal FROM salary init
JOIN t_h
ON init.industry = t_h.industry
ORDER BY industry