-- Creating tables for ph_employee_db
CREATE TABLE departments(                                   --Creates a table called departments
	                    dept_no VARCHAR(4) NOT NULL,        --Specifies a column named 'dept_name' which contains four varying characters
						dept_name VARCHAR(40) NOT NULL,     --Same as above but with 40 varying chars; NOT NULL not to allow null fields when importing data
						PRIMARY KEY (dept_no),              --Specifies which column is primary key
						UNIQUE (dept_name)                  --Adds the UNIQUE constraint to the dept_name column
);

CREATE TABLE employees(emp_no INT NOT NULL,
					   birth_date DATE NOT NULL,
					   first_name VARCHAR NOT NULL,
					   last_name  VARCHAR NOT NULL,
					   gender VARCHAR NOT NULL,
					   hire_date DATE NOT NULL,
					   PRIMARY KEY (emp_no)
);

CREATE TABLE department_managers(dept_no VARCHAR(4) NOT NULL,
								 emp_no INT NOT NULL,
								 from_date DATE NOT NULL,
								 to_date DATE NOT NULL,
								 PRIMARY KEY(dept_no, emp_no),
								 FOREIGN KEY(dept_no) REFERENCES departments(dept_no),
								 FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE titles(
	                emp_no INT NOT NULL,
					title  VARCHAR NOT NULL,
					from_date DATE NOT NULL,
					to_date DATE NOT NULL,
	                PRIMARY KEY (emp_no, from_date),
	                FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

CREATE TABLE department_employees (
	                emp_no INT NOT NULL,
					dept_no  VARCHAR(4) NOT NULL,
					from_date DATE NOT NULL,
					to_date DATE NOT NULL,
	                PRIMARY KEY (emp_no, dept_no),
	                FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	                FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);



SELECT * FROM departments; --performs a query to select all columns from departments (see data Data Output header)
DROP TABLE department_employees CASCADE;	--Deletes a table and all connections (if CASCADE included)

--Now we can query for a specific situation
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';


--Query for employees born during 1952 only:

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

--Query for employees born during 1953 only:
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';



--Query for employees born during 1954 only:
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';


--Query for employees born during 1955 only:
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

--Query for employees born between 1952 and 1955 AND hired between 1985 and 1988 (retirement eligible):
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Count the number of employees that meet the preceding condition
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--If we want to save our selection to a table
SELECT first_name, last_name
INTO retirement_info  --This is the critical change that creates a table called retirement_info with the data
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Lets query that table to see if it is correct:
SELECT * FROM retirement_info;
--A new table has also been created with we refresh our tables in left side GUI


--Modify the retirement_info table to include emp_no (employee number) column
DROP TABLE retirement_info;

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Check table
SELECT * FROM retirement_info

--Join dept_name from departments to department managers

SELECT d.dept_name,
       dm.emp_no,
       dm.from_date,
	   dm.to_date   --Selecting the columns we want to view from each table
FROM departments AS d  --Left
INNER JOIN department_managers AS dm --Right Also note the use of aliases to make writing easier
ON d.dept_no = d.dept_no; --Check this column for matches

--Join retirement_info and dept_emp tables to find employees currently employed (to_date = 9999-01-01)

SELECT ri.emp_no,
       ri.first_name,
	   ri.last_name,
	   de.to_date
FROM retirement_info AS ri --Left
LEFT JOIN department_employees AS de --Left join which means everything from retirement info is kept
ON ri.emp_no = de.emp_no; --Main difference between this and inner join is that all from retirement info is retained

--Create a table with only the currently employed retirement eligible employees
SELECT ri.emp_no,
       ri.first_name,
	   ri.last_name,
	   de.to_date
INTO current_emp  --This creates the table of current employees (current_emp) and the code below executes into this table
FROM retirement_info AS ri
LEFT JOIN department_employees AS de
ON ri.emp_no = de.emp_no
WHERE de.to_date =('9999-01-01');

--View current employees table
SELECT * FROM current_emp;


--Now we need to get the eligible employees grouped by department following up on the previous query

SELECT COUNT(ce.emp_no), de.dept_no
INTO employee_count_by_dep
FROM current_emp as ce
LEFT JOIN department_employees as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;  --dept_no is put in alphanumeric order


--Now we need to add salary information to the employee data:


SELECT * FROM salaries
ORDER BY to_date DESC;  --descending

--A look at the dates in the Salaries shows that they are innaccurate spanning only one year

--Lets pull up our earlier retirement data which is more accurate and modify from there by adding gender first:
--Do not run this query. It is simply here for reference as we will be modifying it
SELECT emp_no, first_name, last_name, gender
INTO emp_info  --Here we create a temporary table that stores the info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Now we can merge emp_info with salaries and department emp info (which contains the correct dates)
--To do this we modify the above query
SELECT e.emp_no,
       e.first_name,
	   e.last_name,
	   e.gender,
	   sal.salary,
	   de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as sal
ON e.emp_no = sal.emp_no
INNER JOIN department_employees as de  --Note that we perform two joins
ON e.emp_no = de.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') --And now we add our retirement criteria as before
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND(de.to_date = '9999-01-01');

--We now have an updated table (emp_info) that we exported as updated_retirement_info.csv

--Now we must check to see which of the retiring employees are part of the management
--To do this we must inspect the department_managers table
--Into the managers table we need dept_name from departments, and employee first and last name from employees
--We are working now with three tables

--List Managers per department

SELECT dm.dept_no,
       d.dept_name,
	   dm.emp_no,
	   ce.last_name,
	   ce.first_name,
	   dm.from_date,
	   dm.to_date
INTO manager_info --create the table we need
FROM department_managers as dm
	INNER JOIN departments as d --We do inner join because we only retain managers who are retiring
		ON dm.dept_no = d.dept_no
	INNER JOIN current_emp AS ce
		ON dm.emp_no = ce.emp_no;

--Our final list adds department names to the retiring employees table (current_emp)
--In this case we need data department_employees, departments, and employees

SELECT ce.emp_no,
       ce.first_name,
	   ce.last_name,
	   d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN department_employees AS de
ON ce.emp_no = de.emp_no
INNER JOIN departments AS d
ON de.dept_no = d.dept_no

--A look at the list shows some employees being listed twice due to the department employee table
--Basically you have employees that worked in more than one department which affects the merge

--Now lets try to create lists of retiring based filtered on a single department (sales)

SELECT ce.emp_no,
       ce.first_name,
	   ce.last_name,
	   d.dept_name
--INTO sales_info
FROM current_emp as ce
INNER JOIN department_employees AS de
ON ce.emp_no = de.emp_no
INNER JOIN departments AS d
ON de.dept_no = d.dept_no
WHERE d.dept_name =('Sales');

--We can also do this for sales and development
SELECT ce.emp_no,
       ce.first_name,
	   ce.last_name,
	   d.dept_name
--INTO sales_development_info
FROM current_emp as ce
INNER JOIN department_employees AS de
ON ce.emp_no = de.emp_no
INNER JOIN departments AS d
ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales', 'Development');
