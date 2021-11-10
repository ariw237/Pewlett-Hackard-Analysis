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
	                PRIMARY KEY (emp_no),
	                FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

CREATE TABLE department_employees (
	                emp_no INT NOT NULL,
					dept_no  VARCHAR(4) NOT NULL,
					from_date DATE NOT NULL,
					to_date DATE NOT NULL,
	                PRIMARY KEY (emp_no),
	                FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	                FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);
