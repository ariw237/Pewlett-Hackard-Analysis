# Pewlett-Hackard-Analysis  
##  Overview  
We are given a list of employees from a hypothetical company, Pewlett-Hackard, from which we needed to obtain a list of current employees who are going to be retiring soon.  We previously generated this list and used several queries to generate several other tables filtering retiring employees based on department, manager status or to obtain the number of retiring employees in each department.  As an additional analysis we are now determining the number of employees who are retiring by their title and employees who are eligible to participate in a part time mentorship program to train employees who will replace them.  

##  Results  
- Employees with the title of Senior Engineer are going to experience the greatest number of upcoming retirements while Managers will experience the least number of upcoming retirements.  
- It appears that the Finance department has the fewest number of employees eligible to mentor the next wave of new hires    
- 1549 employees are eligible for the mentorship program  
- This data does not take into account hiring dates  

## Summary 
Ultimately it appears that 90,398 roles will need to be filled total as employees come up for retirement  
![sum](https://user-images.githubusercontent.com/60231630/141737145-ea04521e-712d-4c00-8773-192ecea46e71.png)  

Additionally, creating a pivot-like table using the groupby query reveals that each department has at least 70 employees who are eligible to mentor the next set of employees who will be hired. This is adequate for each department and appears to be proportional to employee counts in each department. Therefore there appears to be enough eligible retirement-ready employees in each department for mentorship purposes:  

![department_mentor_eligible](https://user-images.githubusercontent.com/60231630/141740874-c1e0627b-94fb-4038-a355-91b708f24e21.png)
