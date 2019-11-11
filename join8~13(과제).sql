--join 8
SELECT * FROM countries;
SELECT * FROM regions;
--ANSI
SELECT a.region_id, b.region_name, a.country_name
FROM countries a join regions b on (a.region_id = b.region_id AND b.region_id = 1);
--ORACLE
SELECT a.region_id, region_name, country_name
FROM countries a, regions b
WHERE a.region_id = b.region_id
  AND region_name = 'Europe';

--join 9
SELECT * FROM countries;
SELECT * FROM regions;
SELECT * FROM locations;
--ANSI
SELECT a.region_id, b.region_name, a.country_name, c.city
FROM countries a join regions b on (a.region_id = b.region_id AND b.region_id = 1)
     join locations c on (a.country_id = c.country_id);
--ORACLE
SELECT a.region_id, b.region_name, a.country_name, c.city
FROM countries a, regions b, locations c
WHERE a.region_id = b.region_id
  AND a.country_id = c.country_id
  AND b.region_name = 'Europe';

--join10
SELECT * FROM countries;
SELECT * FROM regions;
SELECT * FROM locations;
SELECT * FROM departments;
--ANSI
SELECT a.region_id, b.region_name, a.country_name, c.city, department_name
FROM countries a join regions b on (a.region_id = b.region_id AND b.region_id = 1)
     join locations c on (a.country_id = c.country_id) join departments d on (c.location_id = d.location_id);
--ORACLE
SElECT  a.region_id, b.region_name, a.country_name, c.city, department_name
FROM countries a, regions b, locations c, departments d
WHERE a.region_id = b.region_id
  AND a.country_id = c.country_id
  AND b.region_name = 'Europe'
  AND c.location_id = d.location_id;

--join11
SELECT * FROM countries;
SELECT * FROM regions;
SELECT * FROM locations;
SELECT * FROM departments;
SELECT * FROM employees;
--ANSI
SELECT a.region_id, b.region_name, a.country_name, c.city, department_name, concat(first_name, last_name)name 
FROM countries a join regions b on (a.region_id = b.region_id AND b.region_id = 1)
     join locations c on (a.country_id = c.country_id) join departments d on (c.location_id = d.location_id)
     join employees e on (d.department_id = e.department_id);
--ORACLE
SElECT  a.region_id, b.region_name, a.country_name, c.city, department_name, CONCAT(first_name, last_name)name
FROM countries a, regions b, locations c, departments d, employees e
WHERE a.region_id = b.region_id
  AND a.country_id = c.country_id
  AND b.region_name = 'Europe'
  AND c.location_id = d.location_id
  AND d.department_id = e.department_id;

--join12
SELECT * FROM employees;
SELECT * FROM jobs;
--ANSI
SELECT employee_id, CONCAT(first_name, last_name)name, b.job_id, b.job_title
FROM employees a join jobs b on (a.job_id = b.job_id);
--ORACLE
SELECT employee_id, CONCAT(first_name,last_name)name, b.job_id, job_title
FROM employees a, jobs b
WHERE a.job_id = b.job_id; 


--join13
SELECT * FROM employees;
SELECT * FROM jobs;
--ANSI
SELECT 100 mng_id, 'StevenKing' MGR_NAME, employee_id, concat(first_name, last_name)name, a.job_id, job_title
FROM employees a join jobs b on (a.job_id = b.job_id AND a.job_id in('ST_MAN','SA_MAN'))
ORDER BY EMPLOYEE_ID;
--ORACLE
SELECT  100 mng_id,'StevenKing' mgr_name, employee_id, CONCAT(first_name,last_name)name, b.job_id, job_title
FROM employees a, jobs b
WHERE a.job_id = b.job_id 
  AND a.job_id in ('ST_MAN','SA_MAN')
ORDER BY employee_id;


  