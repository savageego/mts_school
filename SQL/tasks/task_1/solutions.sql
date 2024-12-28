/* 

1. Вывести имена всех не уволенных сотрудников, имеющих зарплату более 200. 
Результат отсортировать по имени.

*/

SELECT 
	name 
FROM 
	employees
WHERE 
	fired_dt IS null AND salary > 200
ORDER BY 
	name ASC

/*

2. Вывести имена сотрудников, уволенных в 2023 году. 
Ответ отсортировать в обратном алфавитном порядке

*/

SELECT
	name
FROM
	employees
WHERE
	EXTRACT(YEAR FROM fired_dt) = 2023
ORDER BY
	name DESC

/*

3. Не используя join-ы и подзапросы, 
вывести id департаментов (без повторов), в которых работает хотя бы один сотрудник.

*/

SELECT
	DISTINCT dep_id
FROM
	employees

/*

4. Вывести наименования департаментов (без повторов), у которых есть сотрудники, 
устроившиеся на работу после 2022 года и в которых никогда не было увольнений

*/

SELECT
	DISTINCT a.name
FROM
	departments AS a
	JOIN
	employees AS b
	ON a.id = b.dep_id
WHERE
	EXTRACT(YEAR FROM b.hired_dt) > 2022
	AND 
	dep_id NOT IN (SELECT dep_id FROM employees WHERE fired_dt IS NOT null)
	
/*

5.1 Двумя разными способами выведите имена департаментов, 
в которых не работает ни одного сотрудника. 
Первый SQL выполнить через join. Второй - через подзапрос без join-a

w Join

*/

SELECT
	a.name
FROM
	departments AS a
	LEFT JOIN
	employees AS b
	ON a.id = b.dep_id
WHERE
	b.dep_id IS null

/*

5.2 Двумя разными способами выведите имена департаментов, 
в которых не работает ни одного сотрудника. 
Первый SQL выполнить через join. Второй - через подзапрос без join-a

wo Join

*/

SELECT
	name
FROM
	departments
WHERE
	id NOT IN (SELECT DISTINCT dep_id FROM employees)

/*

6. Напишите имена сотрудников чьи руководители были трудоустроены в течение 2019 года

*/

SELECT
	name
FROM 
	employees 
WHERE
	manager_id IN (SELECT id FROM employees WHERE EXTRACT(YEAR FROM hired_dt) = 2019)

/* 

7. Для каждого сотрудника выведите имя его руководителя. 
Если руководителя нет - вывести null. 
То есть на выходе должно быть две колонки: «Имя сотрудника», «Имя руководителя»

*/

SELECT
	b.name AS "Имя Сотрудника",
	a.name AS "Имя Руководителя"
FROM
	employees AS a
	RIGHT JOIN
	employees AS b
	ON a.id = b.manager_id