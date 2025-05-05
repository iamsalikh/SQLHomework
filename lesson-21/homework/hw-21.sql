/* Homework 21 */
-- 1. Write a query to assign a row number to each sale based on the SaleDate. 
select *, row_number() over (order by SaleDate) as RowNum
from ProductSales

-- 2. Write a query to rank products based on the total quantity sold. give the same rank for the same amounts without skipping numbers.
select ProductName, sum(Quantity) as TotalQuantity,
dense_rank() over (order by sum(Quantity) desc) as Rank
from ProductSales
group by ProductName

-- 3. Write a query to identify the top sale for each customer based on the SaleAmount.
select SaleID, ProductName, SaleDate, SaleAmount, Quantity, CustomerID
from (
    select *,
    rank() over (partition by CustomerID order by SaleAmount desc) as rnk
    from ProductSales
) as t
where rnk = 1

-- 4. Write a query to display each sale's amount along with the next sale amount in the order of SaleDate.
select SaleID, ProductName, SaleDate, SaleAmount,
       lead(SaleAmount) over (order by SaleDate) as NextSaleAmount
from ProductSales

-- 5. Write a query to display each sale's amount along with the previous sale amount in the order of SaleDate.
select SaleID, ProductName, SaleDate, SaleAmount,
       lag(SaleAmount) over (order by SaleDate) as PreviousSaleAmount
from ProductSales

-- 6. Write a query to identify sales amounts that are greater than the previous sale's amount
select SaleID, ProductName, SaleDate, SaleAmount
from (
    select SaleID, ProductName, SaleDate, SaleAmount,
           lag(SaleAmount) over (order by SaleDate) as PreviousSaleAmount
    from ProductSales
) t
where SaleAmount > PreviousSaleAmount

-- 7. Write a query to calculate the difference in sale amount from the previous sale for every product
select SaleID, ProductName, SaleDate, SaleAmount,
       SaleAmount - lag(SaleAmount) over (partition by ProductName order by SaleDate) as DifferenceFromPrevious
from ProductSales

-- 8. Write a query to compare the current sale amount with the next sale amount in terms of percentage change.
select SaleID, ProductName, SaleDate, SaleAmount,
       ((lead(SaleAmount) over (partition by ProductName order by SaleDate) - SaleAmount) * 100.0) / SaleAmount as PercentageChange
from ProductSales

-- 9. Write a query to calculate the ratio of the current sale amount to the previous sale amount within the same product.
select SaleID, ProductName, SaleDate, SaleAmount,
       cast(SaleAmount as decimal(10,2)) / lag(SaleAmount) over (partition by ProductName order by SaleDate) as SaleRatio
from ProductSales

-- 10. Write a query to calculate the difference in sale amount from the very first sale of that product.
select SaleID, ProductName, SaleDate, SaleAmount,
       SaleAmount - first_value(SaleAmount) over (partition by ProductName order by SaleDate) as DifferenceFromFirstSale
from ProductSales

-- 11. Write a query to find sales that have been increasing continuously for a product (i.e., each sale amount is greater than the previous sale amount for that product).
with salecomparison as (
    select saleid, productname, saledate, saleamount,
           lag(saleamount) over (partition by productname order by saledate) as previoussaleamount
    from productsales
)
select saleid, productname, saledate, saleamount
from salecomparison
where saleamount > previoussaleamount
  and previoussaleamount is not null
order by productname, saledate;

-- 12. Write a query to calculate a "closing balance"(running total) for sales amounts which adds the current sale amount to a running total of previous sales.
select saleid, productname, saledate, saleamount,
       sum(saleamount) over (partition by productname order by saledate) as closingbalance
from productsales
order by productname, saledate;

-- 13. Write a query to calculate the moving average of sales amounts over the last 3 sales.
select saleid, productname, saledate, saleamount,
       avg(saleamount) over (partition by productname order by saledate rows between 2 preceding and current row) as movingaverage
from productsales
order by productname, saledate;

-- 14. Write a query to show the difference between each sale amount and the average sale amount.
select employeeid, name, department, salary,
       salary - avg(salary) over () as difference_from_avg
from employees1
order by salary;


-- 15. Find Employees Who Have the Same Salary Rank
select employeeid, name, department, salary,
       rank() over (order by salary) as salary_rank
from employees1
where salary in (
    select salary
    from employees1
    group by salary
    having count(*) > 1
)
order by salary_rank;

-- 16. Identify the Top 2 Highest Salaries in Each Department
select employeeid, name, department, salary
from (
    select employeeid, name, department, salary,
           row_number() over (partition by department order by salary desc) as salary_rank
    from employees1
) as ranked_salaries
where salary_rank <= 2
order by department, salary desc;

-- 17. Find the Lowest-Paid Employee in Each Department
select employeeid, name, department, salary
from (
    select employeeid, name, department, salary,
           row_number() over (partition by department order by salary asc) as salary_rank
    from employees1
) as ranked_salaries
where salary_rank = 1
order by department;

-- 18. Calculate the Running Total of Salaries in Each Department
select employeeid, name, department, salary,
       sum(salary) over (partition by department order by hiredate) as running_total_salary
from employees1
order by department, hiredate;

-- 19. Find the Total Salary of Each Department Without GROUP BY
select distinct department,
       sum(salary) over (partition by department) as total_salary
from employees1;

-- 20. Calculate the Average Salary in Each Department Without GROUP BY
select distinct department,
       avg(salary) over (partition by department) as avg_salary
from employees1;

-- 21. Find the Difference Between an Employee’s Salary and Their Department’s Average
select employeeid, name, department, salary,
       salary - avg(salary) over (partition by department) as salary_difference
from employees1;

-- 22. Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
select employeeid, name, department, salary,
       avg(salary) over (order by hiredate rows between 1 preceding and 1 following) as moving_avg_salary
from employees1;

-- 23. Find the Sum of Salaries for the Last 3 Hired Employees
select sum(salary) as total_salary_last_3_hired
from (
    select salary
    from employees1
    order by hiredate desc
    fetch first 3 rows only
) as last_3_hired_employees;
