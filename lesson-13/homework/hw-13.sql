/* Homework 13 String Functions, Mathematical Functions, Date and time Functions */ 

use homeWorksDb

/* Easy Tasks */
-- 1.You need to write a query that outputs "100-Steven King", meaning emp_id + first_name + last_name in that format using employees table.
select concat_ws(' ', employee_id, first_name, last_name) 
from Employees
where employee_id = 100

-- 2.Update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'
select replace(phone_number, 124, 999)
from employees

-- 3. That displays the first name and the length of the first name for all employees whose name starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees' first names.(Employees)
select first_name, len(first_name) as lenght_FN
from employees
where left(first_name, 1) IN ('A', 'J', 'M')
order by first_name 

-- 4.Write an SQL query to find the total salary for each manager ID.(Employees table)
select manager_id, sum(salary) as total_salary
from Employees
group by manager_id

-- 5.Write a query to retrieve the year and the highest value from the columns Max1, Max2, and Max3 for each row in the TestMax table
select year1, maxvalue = max(val)
from testmax
cross apply (values(max1), (max2), (max3)) as AllValues(val)
group by year1

-- 6.Find me odd numbered movies description is not boring.(cinema)
select * from cinema
where id % 2 = 1 
and charindex('boring', description) = 0

--7.You have to sort data based on the Id but Id with 0 should always be the last row. Now the question is can you do that with a single order by column.(SingleOrder)
select * from singleorder
order by id desc

-- 8.Write an SQL query to select the first non-null value from a set of columns. If the first column is null, move to the next, and so on. If all columns are null, return null.(person)
select coalesce(ssn, passportID, itin) 
from person

-- 9.Find the employees who have been with the company for more than 10 years, but less than 15 years. Display their Employee ID, First Name, Last Name, Hire Date, and the Years of Service (calculated as the number of years between the current date and the hire date, rounded to two decimal places).(Employees)
select Employee_id, first_name, last_name, hire_date,
datediff(year, hire_date, getDate()) as years_of_service
from Employees
where datediff(year, hire_date, getdate()) - 
        case 
            when month(hire_date) > month(getdate()) or (month(hire_date) = month(getdate()) and day(hire_date) > day(getdate())) 
            then 1
            else 0
        end > 10
  and datediff(year, hire_date, getdate()) - 
        case 
            when month(hire_date) > month(getdate()) or (month(hire_date) = month(getdate()) and day(hire_date) > day(getdate())) 
            then 1
            else 0
        end < 15 

-- 10.Find the employees who have a salary greater than the average salary of their respective department.(Employees)
select e.employee_id, e.first_name, e.last_name, e.department_id, e.salary
from Employees e
where e.salary > (
    select AVG(e2.salary)
    from Employees e2
    where e2.department_id = e.department_id
)
 
/* Medium Tasks */
-- 1.Write an SQL query that separates the uppercase letters, lowercase letters, numbers, and other characters from the given string  'tf56sd#%OqH' into separate columns.
WITH CharCTE AS (
    SELECT 1 AS pos,
           SUBSTRING('tf56sd#%OqH', 1, 1) AS ch,
           LEN('tf56sd#%OqH') AS total_len
    UNION ALL
    SELECT pos + 1,
           SUBSTRING('tf56sd#%OqH', pos + 1, 1),
           total_len
    FROM CharCTE
    WHERE pos < total_len
)
SELECT 
    ch,
    ASCII(ch) AS ascii_code,
    CASE 
        WHEN ASCII(ch) BETWEEN 65 AND 90 THEN 'Uppercase'
        WHEN ASCII(ch) BETWEEN 97 AND 122 THEN 'Lowercase'
        WHEN ASCII(ch) BETWEEN 48 AND 57 THEN 'Number'
        ELSE 'Other'
    END AS char_type
FROM CharCTE

-- 2.split column FullName into 3 part ( Firstname, Middlename, and Lastname).(Students Table)
select *, 
substring(FullName, 1, charindex(' ', FullName) - 1) as FirstName,
substring(
	FullName,
	charindex(' ', FullName) + 1,
	charindex(' ', FullName, charindex(' ', FullName) + 1) - charindex(' ', FullName) - 1
	) as MiddleName,
substring(
	FullName,
	charindex(' ', fullname, charindex(' ', fullname) + 1) + 1,
	len(fullname)
	) as LastName
from Students

-- 3.For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas. (Orders Table)
select distinct o2.CustomerID, o2.OrderID, o2.DeliveryState, o2.Amount
from Orders o1
join Orders o2 on o1.CustomerID = o2.CustomerID
where o1.DeliveryState = 'CA'
and o2.DeliveryState = 'TX'

-- 4.Write an SQL query to transform a table where each product has a total quantity into a new table where each row represents a single unit of  that product.For example, if A and B, it should be A,B and B,A.(Ungroup)
with ProductCTE as (
	select ProductDescription, Quantity, 1 as counter
	from Ungroup
	union all
	select ProductDescription, Quantity, counter + 1
	from ProductCTE
	where counter < Quantity 
)
select ProductDescription 
from ProductCTE
order by ProductDescription

-- 5.Write an SQL statement that can group concatenate the following values.(DMLTable)
SELECT STRING_AGG(ColumnName, ', ') AS ConcatenatedValues
FROM (
    SELECT 
        'SELECT' AS ColumnName UNION ALL
    SELECT 'Product' UNION ALL
    SELECT 'UnitPrice' UNION ALL
    SELECT 'EffectiveDate' UNION ALL
    SELECT 'FROM' UNION ALL
    SELECT 'Products' UNION ALL
    SELECT 'WHERE' UNION ALL
    SELECT 'UnitPrice' UNION ALL
    SELECT '> 100'
) AS DMLTable;

-- 6.Write an SQL query to determine the Employment Stage for each employee based on their HIRE_DATE. The stages are defined as follows:
-- If the employee has worked for less than 1 year → 'New Hire'
-- If the employee has worked for 1 to 5 years → 'Junior'
-- If the employee has worked for 5 to 10 years → 'Mid-Level'
-- If the employee has worked for 10 to 20 years → 'Senior'
-- If the employee has worked for more than 20 years → 'Veteran'(Employees)
select 
	Employee_Id,
	Hire_date,
	DATEDIFF(YEAR, hire_date, GETDATE()) as YearsWorked,
	case 
		when DATEDIFF(YEAR, hire_date, GETDATE()) < 1 then 'New Hire'
		when DATEDIFF(YEAR, hire_date, GETDATE()) between 1 and 5 then 'Junior'
		when DATEDIFF(YEAR, hire_date, GETDATE()) between 5 and 10 then 'Mid-level'
		when DATEDIFF(YEAR, hire_date, GETDATE()) between 10 and 20 then 'Senior'
		else 'Veteran'
	end as EmployeeStage
from Employees

-- 7.Find the employees who have a salary greater than the average salary of their respective department(Employees)
select * 
from Employees e
where e.salary > (select AVG(e2.salary) from Employees e2 where e2.DEPARTMENT_ID=e.department_id)

-- 8.Find all employees whose names (concatenated first and last) contain the letter "a" and whose salary is divisible by 5(Employees)
select 
	CONCAT(first_name, last_name) as Full_Name, 
	SALARY
from Employees 
where 
	CONCAT(first_name, last_name) like '%a%' 
	and Cast(SALARY as int) % 5 = 0

-- 9.The total number of employees in each department and the percentage of those employees who have been with the company for more than 3 years(Employees)
select DEPARTMENT_ID, COUNT(employee_id) as TotalEmployees,
cast(SUM(case
			when datediff(year, hire_date, getdate()) > 3 then 1
			else 0
		end) * 100.0/count(employee_id) as decimal(5,2)) as PerсentageOver3Years
from Employees
group by DEPARTMENT_ID

-- 10.Write an SQL statement that determines the most and least experienced Spaceman ID by their job description.(Personal)
select p.SpacemanID, p.JobDescription, p.MissionCount, 'Most Experienced' as ExperienceLevel 
from Personal p
join (
	select Jobdescription, MAX(MissionCount) as MaxMission
	from Personal
	group by JobDescription)
	max_mission on p.JobDescription = max_mission.JobDescription and p.MissionCount = max_mission.MaxMission
union all		
select p.JobDescription, p.SpacemanID, p.MissionCount, 'Least Experienced' as ExperienceLevel
from Personal p
join (
    select JobDescription,  min(MissionCount) as MinMission
    from Personal
    group by JobDescription
) min_mission on p.JobDescription = min_mission.JobDescription and p.MissionCount = min_mission.MinMission;

/* Difficult tasks */
-- 1.Write an SQL query that replaces each row with the sum of its value and the previous row's value. (Students table)
with ValueSums as (
    select
		StudentID,
        Grade + isnull(lag(Grade) over (order by StudentID), 0) as UpGrades
    from
        Students
)
update S
set Grade = V.UpGrades
from Students S
join ValueSums V on S.StudentID = V.StudentID;

-- 2.Given the following hierarchical table, write an SQL statement that determines the level of depth each employee has from the president. (Employee table)
with hierarchical_cte as (
	select EmployeeID, ManagerID, 0 as level
	from Employee
	where ManagerID is NULL
	union all
	select e.employeeid, e.managerid, cte.level + 1 as level
	from Employee e
	join hierarchical_cte cte on e.managerID = cte.EmployeeID
)
select * from hierarchical_cte

-- 3.You are given the following table, which contains a VARCHAR column that contains mathematical equations. 
-- Sum the equations and provide the answers in the output.(Equations)
SELECT 
    equation,
    CASE 
        WHEN CHARINDEX('+', equation) > 0 THEN 
            CAST(LEFT(equation, CHARINDEX('+', equation) - 1) AS FLOAT) +
            CAST(RIGHT(equation, LEN(equation) - CHARINDEX('+', equation)) AS FLOAT)

        WHEN CHARINDEX('-', equation) > 0 THEN 
            CAST(LEFT(equation, CHARINDEX('-', equation) - 1) AS FLOAT) -
            CAST(RIGHT(equation, LEN(equation) - CHARINDEX('-', equation)) AS FLOAT)

        WHEN CHARINDEX('*', equation) > 0 THEN 
            CAST(LEFT(equation, CHARINDEX('*', equation) - 1) AS FLOAT) *
            CAST(RIGHT(equation, LEN(equation) - CHARINDEX('*', equation)) AS FLOAT)

        WHEN CHARINDEX('/', equation) > 0 THEN 
            CAST(LEFT(equation, CHARINDEX('/', equation) - 1) AS FLOAT) /
            CAST(RIGHT(equation, LEN(equation) - CHARINDEX('/', equation)) AS FLOAT)
    END AS result
FROM Equations

-- 4.Given the following dataset, find the students that share the same birthday.(Student Table)
SELECT s.*
FROM Student s
JOIN (
    SELECT Birthday
    FROM Student
    GROUP BY Birthday
    HAVING COUNT(*) >= 2
) dup ON s.Birthday = dup.Birthday;

-- 5.You have a table with two players (Player A and Player B) and their scores. If a pair of players have multiple entries, aggregate their scores into a single row for each unique pair of players. Write an SQL query to calculate the total score for each unique player pair(PlayerScores)
SELECT
    CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END AS Player1,
    CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END AS Player2,
    SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY
    CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END,
    CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END;
