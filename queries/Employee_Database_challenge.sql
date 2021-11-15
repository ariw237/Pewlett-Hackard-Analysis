--Create a table (retirement_titles) of employees titles, start dates and end dates
SELECT e.emp_no,
       e.first_name,
	     e.last_name,
	     t.title
       t.from_date
       t.to_date
INTO retirement_titles
FROM employees as e
LEFT JOIN titles AS t
ON e.emp_no = t.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no ASC;

--Remove duplicate entries and store results in new table called unique_titles
SELECT DISTINCT ON (emp_no)
       emp_no,
       first_name,
	     last_name,
       title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no ASC, to_date DESC;

--Retrieve number of employees per each title who are about to retire
SELECT COUNT(emp_no), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

--Create a mentorship eligibility table of eligible employees to be in program
SELECT DISTINCT ON (emp_no)
e.emp_no,
e.first_name,
e.last_name,
e.birth_date,
de.from_date,
de.to_date,
ti.title
INTO mentorship_eligibility
FROM employees AS e
LEFT JOIN department_employees AS de
ON e.emp_no = de.emp_no
LEFT JOIN titles AS ti
ON de.emp_no = ti.emp_no
WHERE de.to_date = ('9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no ASC;
