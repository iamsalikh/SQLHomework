/* Homework 15 */
/* CTE, derived table */
use hw15

/* Easy Tasks */ 
-- 1. Create a numbers table using a recursive query.
with numbers as (
	select 1 as number
	union all
	select number + 1
	from numbers 
	where number < 100
)
select * from numbers;

-- 2. Beginning at 1, this script uses a recursive statement to double the number for each record
with cte as (
	select 1 as num
	union all
	select num * 2
	from cte
	where num < 100
)
select * from cte;

-- 3. Write a query to find the total sales per employee using a derived table.(Sales, Employees)
select employeeid, TotalSalesAmount 
from (
	select employeeid, SUM(SalesAmount) as TotalSalesAmount 
	from sales 
	group by employeeid) as TotalSales

-- 4. Create a CTE to find the average salary of employees.(Employees)
with avgSalary as (
	select AVG(salary) as avgSalary
	from employees
)
select * from avgSalary;

-- 5. Write a query using a derived table to find the highest sales for each product.(Sales, Products)
select ProductId, HighestSales 
from
	(select PRODUCtId, max(salesamount) as HighestSales
	from sales
	group by productID) as High;

-- 6. Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)
with cte as (
	select employeeId, COUNT(*) as salesCount
	from sales
	group by employeeId
)
select e.FirstName
from employees e
join cte c on e.employeeId = c.employeeId
where c.salesCount > 5;

-- 7. Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)
with cte as (
    select productID, sum(salesAmount) as totalSales
    from sales
    group by productID
    having sum(salesAmount) > 500
)
select p.ProductName, cte.totalSales
from products p
join cte c on p.productID = c.productID;

-- 8. Create a CTE to find employees with salaries above the average salary.(Employees)
with cte as (
	select AVG(salary) as AvgSalary
	from employees
)
select e.employeeID, e.salary
from employees e
cross join cte 
where e.salary > cte.AvgSalary

-- 9. Write a query to find the total number of products sold using a derived table.(Sales, Products)
select ProductId, TotalSales
from
	(select productID, SUM(salesAmount) as TotalSales
	from sales
	group by productID) as dt

-- 10. Use a CTE to find the names of employees who have not made any sales.(Sales, Employees)
with cte as (
	select employeeID, FirstName
	from employees
)
select cte.FirstName
from cte
left join sales s on cte.EmployeeID = s.EmployeeID
where s.SalesID is null;

/* Medium tasks */
-- 1. This script uses recursion to calculate factorials
with factorial_cte as (
	select 1 as num, 1 as factorial
	union all
	select num + 1, factorial * (num + 1) 
	from factorial_cte
	where num < 5
)
select * from factorial_cte;

-- 2. This script uses recursion to calculate Fibonacci numbers
with fibonacci_cte as (
	select 0 as first, 1 second
	union all
	select second, first + second
	from fibonacci_cte
	where first + second < 100
)
select * from fibonacci_cte

-- 3. This script uses recursion to split a string into rows of substrings for each character in the string.(Example)
WITH cte AS (
    SELECT 
        Id,
        1 AS position,
        SUBSTRING(String, 1, 1) AS letter,
        String AS full_string
    FROM Example

    UNION ALL

    SELECT 
        Id,
        position + 1,
        SUBSTRING(full_string, position + 1, 1),
        full_string
    FROM cte
    WHERE position < LEN(full_string)
)
SELECT letter
FROM cte
WHERE letter <> ''

-- 4. Create a CTE to rank employees based on their total sales.(Employees, Sales)
with salesRank as (
	select e.employeeId, e.FirstName, SUM(s.salesAmount) as totalSales, RANK() over (order by sum(s.salesAmount) desc) as SalesRank
	from employees e
	join sales s on e.employeeId = s.employeeId
	group by e.employeeId, e.FirstName
)
select * from salesRank order by salesRank

-- 5. Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)
select top 5
    e.employeeid, 
    e.FirstName, 
    count(s.salesid) as ordercount
from employees e
left join sales s on e.employeeid = s.employeeid
group by e.employeeid, e.FirstName
order by ordercount desc;

-- 6. Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)
with sales_cte as (
    select 
        year(saledate) as saleyear,
        month(saledate) as salemonth,
        sum(salesamount) as totalsales
    from sales
    group by year(saledate), month(saledate)
)
select 
    c.saleyear,
    c.salemonth,
    c.totalsales as currentmonthsales,
    p.totalsales as previousmonthsales,
    (c.totalsales - p.totalsales) as salesdifference
from sales_cte c
left join sales_cte p 
    on (c.saleyear = p.saleyear and c.salemonth = p.salemonth + 1)
order by c.saleyear, c.salemonth;

-- 7. Write a query using a derived table to find the sales per product category.(Sales, Products)
select p.CategoryID, SUM(s.salesAmount) as totalAmount
from Products p
join Sales s on p.ProductID = s.ProductID
group by p.CategoryID;

-- 8. Use a CTE to rank products based on total sales in the last year.(Sales, Products)
with cte as (
	select p.ProductName, YEAR(s.SaleDate) as saleYear, SUM(SalesAmount) as totalSales
	from Products p
	join Sales s on p.ProductID = s.ProductID
	group by p.ProductName, YEAR(s.SaleDate)
)
select ProductName, saleYear, totalSales, RANK() over (partition by saleYear order by totalSales desc) as salesRank
from cte
where saleYear = YEAR(GETDATE()) - 1
order by salesRank;

-- 9. Create a derived table to find employees with sales over $5000 in each quarter.(Sales, Employees)
select * from (
	select 
		e.FirstName as Employee,
		DATEPART(quarter, s.SaleDate) as SaleQuarter,
		SUM(s.SalesAmount) as TotalSales
	from Employees e
	join Sales s on e.EmployeeID = s.EmployeeID
	group by e.FirstName, DATEPART(quarter, s.SaleDate)
) as dt 
where totalSales > 5000
order by employee, salequarter;

-- 10. Use a derived table to find the top 3 employees by total sales amount in the last month.(Sales, Employees)
select top 3 * 
from (
	select 
		e.FirstName as Employee,
		MONTH(s.SaleDate) as MonthSale,
		SUM(s.SalesAmount) as TotalSales
	from Employees e
	join Sales s on e.EmployeeID = s.EmployeeID
	group by e.FirstName, MONTH(s.SaleDate)
) dt
where MonthSale = MONTH(getdate()) - 1
order by totalsales desc;

/* Hard tasks */ 
-- 1. Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.
-- (Example:n=5 | 1, 12, 123, 1234, 12345)
with numbers_cte as (
    select 1 as num
    union all
    select cast(cast(num as varchar) + cast(next_num as varchar) as int)
    from (
        select num, num + 1 as next_num
        from numbers_cte
    ) t
    where num < 5
)
select num
from numbers_cte
option (maxrecursion 100)

-- 2. Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales) 
select * from (
	select 
		e.FirstName as Employee, 
		SUM(s.SalesAmount) as TotalSales
	from Employees e
	join Sales s on e.EmployeeID = s.EmployeeID
	where s.SaleDate >= DATEADD(month, -6, GETDATE())
	group by e.FirstName
) dt
order by TotalSales

-- 3. This script uses recursion to display a running total where the sum cannot go higher than 10 or lower than 0.(Numbers)
with running_sum as (
    select 0 as current_sum
    union all
    select case
             when current_sum + 1 <= 10 then current_sum + 1
             else current_sum - 1
           end
    from running_sum
    where current_sum >= 0 and current_sum <= 10
)
select current_sum
from running_sum
option (maxrecursion 100)

-- 4. Given a table of employee shifts, and another table of their activities, merge the two tables and write an SQL statement that produces the desired output. If an employee is scheduled and does not have an activity planned, label the time frame as “Work”. (Schedule,Activity)
select 
    s.ScheduleID,
    s.StartTime,
    s.EndTime,
    isnull(a.ActivityName, 'Work') as Activity
from Schedule s
left join Activity a 
    on s.ScheduleID = a.ScheduleID 
    and a.StartTime >= s.StartTime 
    and a.EndTime <= s.EndTime

-- 5. Create a complex query that uses both a CTE and a derived table to calculate sales totals for each department and product.(Employees, Sales, Products, Departments)
with product_sales as (
    select 
        p.productid,
        p.productname,
        sum(s.salesamount) as total_sales
    from products p
    join sales s on p.productid = s.productid
    group by p.productid, p.productname
)

select 
    d.departmentname,
    ps.productname,
    ps.total_sales
from (
    select 
        e.departmentid,
        s.productid
    from employees e
    join sales s on e.employeeid = s.employeeid
) ed
join departments d on ed.departmentid = d.departmentid
join product_sales ps on ed.productid = ps.productid
order by d.departmentname, ps.productname
