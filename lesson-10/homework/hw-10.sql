/* Homework 10 */

use homeWorksDb

/* Easy-Level Tasks */
-- 1. Using the Employees and Departments tables, write a query to return the names and salaries of employees whose salary is greater than 50000, along with their department names.
-- Expected Output: EmployeeName, Salary, DepartmentName
select e.Name as EmployeeName, e.Salary, d.DepartmentName
from Employees e
join Departments d on e.DepartmentID = d.DepartmentID
where e.Salary > 50000
 
-- 2. Using the Customers and Orders tables, write a query to display customer names and order dates for orders placed in the year 2023.
-- Expected Output: FirstName, LastName, OrderDate
select c.FirstName, c.LastName, o.OrderDate
from Customers c
join Orders o on o.CustomerID = c.CustomerID
where YEAR(o.OrderDate) = 2023

-- 3. Using the Employees and Departments tables, write a query to show all employees along with their department names. Include employees who do not belong to any department.
-- Expected Output: EmployeeName, DepartmentName
-- (Hint: Use a LEFT OUTER JOIN)
select e.Name as EmployeeName, d.DepartmentName
from Employees e
left join Departments d on e.DepartmentID = d.DepartmentID

-- 4. Using the Products and Suppliers tables, write a query to list all suppliers and the products they supply. Show suppliers even if they don’t supply any product.
-- Expected Output: SupplierName, ProductName
select s.SupplierName, p.ProductName
from Suppliers s
left join Products p on s.SupplierID = p.SupplierID

-- 5. Using the Orders and Payments tables, write a query to return all orders and their corresponding payments. Include orders without payments and payments not linked to any order.
-- Expected Output: OrderID, OrderDate, PaymentDate, Amount
select o.OrderID, o.OrderDate, p.PaymentDate, p.Amount
from Orders o
full join Payments p on o.OrderID = p.OrderID

-- 6. Using the Employees table, write a query to show each employee's name along with the name of their manager.
-- Expected Output: EmployeeName, ManagerName
select e1.Name as EmployeeName, e2.Name as ManagerName
from Employees e1
join Employees e2 on e1.ManagerID = e2.EmployeeID

-- 7. Using the Students, Courses, and Enrollments tables, write a query to list the names of students who are enrolled in the course named 'Math 101'.
-- Expected Output: StudentName, CourseName
select s.Name as StudentName, c.CourseName
from Students s
join Enrollments e on e.StudentID = s.StudentID
join Courses c on c.CourseID = e.CourseID
where c.CourseName = 'Math 101'

-- 8. Using the Customers and Orders tables, write a query to find customers who have placed an order with more than 3 items. Return their name and the quantity they ordered.
-- Expected Output: FirstName, LastName, Quantity
select c.FirstName, c.LastName, o.Quantity
from Customers c
join Orders o on c.CustomerID = o.CustomerID
where o.Quantity > 3

-- 9. Using the Employees and Departments tables, write a query to list employees working in the 'Human Resources' department.
-- Expected Output: EmployeeName, DepartmentName
select e.Name as EmployeeName, d.DepartmentName
from Employees e
join Departments d on e.DepartmentID = d.DepartmentID
where d.DepartmentName = 'Marketing'

/* Medium-Level Tasks */
-- 10. Using the Employees and Departments tables, write a query to return department names that have more than 10 employees.
-- Expected Output: DepartmentName, EmployeeCount
select d.DepartmentName, COUNT(e.EmployeeID) as EmployeeCount
from Departments d
join Employees e on d.DepartmentID = e.DepartmentID
group by d.DepartmentName
having COUNT(e.EmployeeID) > 10

-- 11. Using the Products and Sales tables, write a query to find products that have never been sold.
-- Expected Output: ProductID, ProductName
select p.ProductID, p.ProductName
from Products p
left join Sales s on p.ProductID = s.ProductID
where s.SaleID is null

-- 12. Using the Customers and Orders tables, write a query to return customer names who have placed at least one order.
-- Expected Output: FirstName, LastName, TotalOrders
select c.FirstName, c.LastName, SUM(o.Quantity) as TotalOrders
from Customers c
join Orders o on c.CustomerID = o.CustomerID
group by c.FirstName, c.LastName
having SUM(o.Quantity) > 0

-- 13. Using the Employees and Departments tables, write a query to show only those records where both employee and department exist (no NULLs).
-- Expected Output: EmployeeName, DepartmentName
select e.Name as EmployeeName, d.DepartmentName
from Employees e
join Departments d on e.DepartmentID = d.DepartmentID

-- 14. Using the Employees table, write a query to find pairs of employees who report to the same manager.
-- Expected Output: Employee1, Employee2, ManagerID
select distinct e1.Name as Employee1, e2.Name as Employee2, e1.ManagerID
from Employees e1
join Employees e2 on e1.ManagerID = e2.ManagerID
where e1.EmployeeID <> e2.EmployeeID

-- 15. Using the Orders and Customers tables, write a query to list all orders placed in 2022 along with the customer name.
-- Expected Output: OrderID, OrderDate, FirstName, LastName
select o.OrderID, o.OrderDate, c.FirstName, c.LastName
from Orders o
join Customers c on o.CustomerID = c.CustomerID
where YEAR(o.OrderDate) = 2022

-- 16. Using the Employees and Departments tables, write a query to return employees from the 'Sales' department whose salary is above 60000.
-- Expected Output: EmployeeName, Salary, DepartmentName
select e.Name as EmployeeName, e.Salary, d.DepartmentName
from Employees e
join Departments d on e.DepartmentID = d.DepartmentID
where d.DepartmentName = 'Sales' 
and e.Salary > 60000

-- 17. Using the Orders and Payments tables, write a query to return only those orders that have a corresponding payment.
-- Expected Output: OrderID, OrderDate, PaymentDate, Amount
select o.OrderID, o.OrderDate, p.PaymentDate, p.Amount
from Orders o
join Payments p on o.OrderID = p.OrderID

-- 18. Using the Products and Orders tables, write a query to find products that were never ordered.
-- Expected Output: ProductID, ProductName
select p.ProductID, p.ProductName
from Products p 
left join Orders o on p.ProductID = o.ProductID
where o.ProductID is null

/* Hard-Level Tasks */
-- 19. Using the Employees table, write a query to find employees whose salary is greater than the average salary of all employees.
-- Expected Output: EmployeeName, Salary
select e1.Name as EmployeeName, e1.Salary
from Employees e1
join Employees e2 on e1.Salary > e2.Salary
group by e1.Name, e1.Salary
having e1.Salary > (select avg(Salary) from Employees)

-- 20. Using the Orders and Payments tables, write a query to list all orders placed before 2020 that have no corresponding payment.
-- Expected Output: OrderID, OrderDate
select o.OrderID, o.OrderDate
from Orders o
left join Payments p on o.OrderID = p.OrderID
where YEAR(o.OrderDate) < 2020
and p.PaymentID is null

-- 21. Using the Products and Categories tables, write a query to return products that do not have a matching category.
-- Expected Output: ProductID, ProductName
select p.ProductID, p.ProductName
from Products p
left join Categories c on p.CategoryID = c.CategoryID
where c.CategoryID is null

-- 22. Using the Employees table, write a query to find employees who report to the same manager and earn more than 60000.
-- Expected Output: Employee1, Employee2, ManagerID, Salary
select e1.Name as Employee1, e2.Name as Employee2, e1.ManagerID, e1.Salary
from Employees e1
join Employees e2 on e1.ManagerID = e2.ManagerID
where e1.Name <> e2.Name
and e1.Salary > 60000
and e2.Salary > 60000

-- 23. Using the Employees and Departments tables, write a query to return employees who work in departments whose name starts with the letter 'M'.
-- Expected Output: EmployeeName, DepartmentName
select e.Name as EmployeeName, d.DepartmentName
from Employees e
join Departments d on e.DepartmentID = d.DepartmentID
where d.DepartmentName like 'M%'

-- 24. Using the Products and Sales tables, write a query to list sales where the amount is greater than 500, including product names.
-- Expected Output: SaleID, ProductName, SaleAmount
select s.SaleID, p.ProductName, s.SaleAmount
from Sales s
join Products p on s.ProductID = p.ProductID
where s.SaleAmount > 500

-- 25. Using the Students, Courses, and Enrollments tables, write a query to find students who have not enrolled in the course 'Math 101'.
-- Expected Output: StudentID, StudentName
select s.StudentID, s.Name as StudentName
from Students s
left join Enrollments e on s.StudentID = e.StudentID
left join Courses c on e.CourseID = c.CourseID
where c.CourseName != 'Math 101' or c.CourseName is null

-- 26. Using the Orders and Payments tables, write a query to return orders that are missing payment details.
-- Expected Output: OrderID, OrderDate, PaymentID
select o.OrderID, o.OrderDate, p.PaymentID
from Orders o
left join Payments p on o.OrderID = p.OrderID
where p.PaymentID is null

-- 27. Using the Products and Categories tables, write a query to list products that belong to either the 'Electronics' or 'Furniture' category.
-- Expected Output: ProductID, ProductName, CategoryName
select p.ProductID, p.ProductName, c.CategoryName
from Products p
join Categories c on p.CategoryID = c.CategoryID
where c.CategoryName IN('Electronics', 'Furniture')
