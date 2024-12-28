CREATE TABLE departments ( 
    id int, -- идентификатор департамента    
	name varchar(100), -- наименование департамента 
    loc varchar(100), -- местонахождение департамента    
	est_dt date -- дата основания департамента 
); 

-- Таблица с описанием сотрудников компании 
CREATE TABLE employees ( 
    id int, -- идентификатор сотрудника    
	name varchar(100), -- имя сотрудника 
    salary int, -- месячная зп    
	hired_dt date, -- дата трудоустройства сотрудника 
    fired_dt date, -- дата увольнения сотрудника    
	dep_id int, -- департамент, в котором работает сотрудник 
    manager_id int -- руководитель сотрудника. Ссылка на id этой же таблицы employees
); 
	
INSERT INTO departments VALUES  
 	(1, 'IT', 'Sydney', '2016-10-01'),     
	(2, 'Product', 'Melbourne', '2012-07-05'),  
    (3, 'Marketing', 'Perth', '2014-05-08'),     
	(4, 'Finance', 'Brisbane', '2011-02-15'),  
    (5, 'Sales', 'Adelaide', '2010-08-23'),     
	(6, 'Hr', 'Canberra', '2013-03-28'); 
 
INSERT INTO employees VALUES  
	(1, 'Ivan', 100, '2022-06-30', null, 1, 7),  
    (2, 'Peter', 150, '2019-01-16', null, 4, 10),     
	(3, 'Sergey', 160, '2018-12-02', null, 1, 7),  
    (4, 'Olga', 210, '2016-02-17', '2023-07-13', 1, 7),     
	(5, 'Alexander', 190, '2020-11-04', null, 5, 14),  
    (6, 'Dmitriy', 140, '2017-03-14', null, 5, 14),     
	(7, 'Maria', 500, '2018-10-03', null, 1, null),  
    (8, 'Nikita', 400, '2023-04-19', null, 3, null),  
    (9, 'Natalya', 110, '2014-09-05', '2019-08-19', 5, 14),     
	(10, 'Stepan', 300, '2022-05-10', null, 4, null),  
    (11, 'Marina', 200, '2023-08-30', null, 6, null),     
	(12, 'Michael', 220, '2019-06-11', null, 3, 8),  
    (13, 'Vladimir', 250, '2016-07-06', '2023-01-11', 1, 7),     
	(14, 'Irina', 500, '2019-01-28', null, 5, null),  
    (15, 'Vasiliy', 130, '2023-12-07', null, 6, 11),     
	(16, 'Maxim', 100, '2020-02-21', null, 1, 7),  
    (17, 'Elena', 135, '2022-11-22', null, 4, 10),     
	(18, 'Diana', 118, '2024-10-24', null, 3, 8),  
    (19, 'Alena', 120, '2015-03-30', '2022-04-27', 5, 14),     
	(20, 'Kirill', 143, '2024-09-09', null, 6, 11) 

--Задачи:
--1. Вывести имена всех не уволенных сотрудников, имеющих зарплату более 200. Результат отсортировать по имени.

SELECT 
	name 
FROM 
	employees
WHERE 
	fired_dt IS null AND salary > 200
ORDER BY 
	name ASC

--2. Вывести имена сотрудников, уволенных в 2023 году. Ответ отсортировать в обратном алфавитном порядке

SELECT
	name
FROM
	employees
WHERE
	EXTRACT(YEAR FROM fired_dt) = 2023
ORDER BY
	name DESC

--3. Не используя join-ы и подзапросы, вывести id департаментов (без повторов), в которых работает хотя бы один сотрудник.

SELECT
	DISTINCT dep_id
FROM
	employees

--4. Вывести наименования департаментов (без повторов), у которых есть сотрудники, устроившиеся на работу после 2022 года и в которых никогда не было увольнений

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
	
--5. Двумя разными способами выведите имена департаментов, в которых не работает ни одного сотрудника. Первый SQL выполнить через join. Второй - через подзапрос без join-a

--w Join

SELECT
	a.name
FROM
	departments AS a
	LEFT JOIN
	employees AS b
	ON a.id = b.dep_id
WHERE
	b.dep_id IS null

--wo Join

SELECT
	name
FROM
	departments
WHERE
	id NOT IN (SELECT DISTINCT dep_id FROM employees)

--6. Напишите имена сотрудников чьи руководители были трудоустроены в течение 2019 года

SELECT
	name
FROM 
	employees 
WHERE
	manager_id IN (SELECT id FROM employees WHERE EXTRACT(YEAR FROM hired_dt) = 2019)

--7. Для каждого сотрудника выведите имя его руководителя. Если руководителя нет - вывести null. То есть на выходе должно быть две колонки: «Имя сотрудника», «Имя руководителя»

SELECT
	b.name AS "Имя Сотрудника",
	a.name AS "Имя Руководителя"
FROM
	employees AS a
	RIGHT JOIN
	employees AS b
	ON a.id = b.manager_id