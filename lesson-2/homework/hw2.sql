-- DBMS: Microsoft SQL Server
use MyDatabase 
-- Basic-Level Tasks
-- 1. Create a table Employees with columns: EmpID INT, Name (VARCHAR(50)), and Salary (DECIMAL(10,2)).
create table Employee (
	EmpID INT,
	Name Varchar(50),
	Salary Decimal(10,2))

-- 2. Insert three records into the Employees table using different INSERT INTO approaches (single-row insert and multiple-row insert).
insert into Employee (EmpID, Name, Salary, Department) values (1, 'Salikh', 1300, 'lala')
insert into Employee values (6, 'Faina', 5100, 'mamamia')
insert into Employee values (3, 'Enrique', 2410), (4, 'Hulio', 3914)

-- 3. Update the Salary of an employee where EmpID = 1.
update Employee
set Salary = 5900
where EmpID = 1

-- 4. Delete a record from the Employees table where EmpID = 2.
delete Employee
where EmpID = 2

-- 5. Demonstrate the difference between DELETE, TRUNCATE, and DROP commands on a test table.
create table TestTable (
	ID INT PRIMARY KEY,
	Name Varchar(50)
	)
insert into TestTable values (1, 'Sadr'), (2, 'Faqr'), (3, 'Badr')

-- DELETE: Deletes only certain rows, but the table stays
delete from TestTable where id = 2;
select * from TestTable
-- now Bob (ID = 2) is gone, but Alice and Charlie are still there.
-- you can undo DELETE if you use a TRANSACTION.

-- TRUNCATE: Removes all rows but keeps the table.
truncate table TestTable 
select * from TestTable
-- Now the table is empty, but it's still in the database.
-- You can't undo TRUNCATE, and IDs will reset.

-- DROP: Deletes the whole table forever.
drop table TestTable
-- Now the table is gone, and you can't get it back.

-- 6. Modify the Name column in the Employees table to VARCHAR(100).
alter table employee 
alter column Name Varchar(100)

-- 7. Add a new column Department (VARCHAR(50)) to the Employees table.
alter table employee
add Department Varchar(50)

-- 8. Change the data type of the Salary column to FLOAT.
alter table employee
alter column Salary FLOAT

-- 9. Create another table Departments with columns DepartmentID (INT, PRIMARY KEY) and DepartmentName (VARCHAR(50)).
create table Department (
	DepartmentID INT Primary Key,
	DepartmentName Varchar(50)
	)
-- 10. Remove all records from the Employees table without deleting its structure.
truncate table employee
select * from Employee

-- Intermediate-Level Tasks
-- 11. Insert five records into the Departments table using INSERT INTO SELECT from an existing table.
insert into Department (DepartmentID, DepartmentName)
select EmpID, Name from Employee
where EmpID <= 5

-- 12. Update the Department of all employees where Salary > 5000 to 'Management'.
update Employee
set Department = 'Management'
where salary > 5000

select * from Employee

-- 13. Write a query that removes all employees but keeps the table structure intact.
truncate table Employee 
select * from Employee

-- 14. Drop the Department column from the Employees table.
alter table employee 
drop column department 

-- 15. Rename the Employees table to StaffMembers using SQL commands.
exec sp_rename 'Employee', 'StaffMembers'

-- 16. Write a query to completely remove the Departments table from the database.
drop table Department

-- Advanced-Level Tasks
-- 17. Create a table named Products with at least 5 columns, including: ProductID (Primary Key), ProductName (VARCHAR), Category (VARCHAR), Price (DECIMAL)
create table Products (
	ProductID int primary key,
	productname varchar(50),
	category varchar(50),
	price decimal(10,2)
	)

-- 18. Add a CHECK constraint to ensure Price is always greater than 0.
alter table Products
add constraint chk_price check (Price > 0)

-- 19. Modify the table to add a StockQuantity column with a DEFAULT value of 50.
alter table Products
add StockQuantity INT default 50

-- 20. Rename Category to ProductCategory
exec sp_rename 'Products.category', 'productCategory', 'Column'

-- 21. Insert 5 records into the Products table using standard INSERT INTO queries.
insert into Products values 
(1, 'Laptop', 'Electronics', 1200, 30),
(2, 'Smartphone', 'Electronics', 800, 50),
(3, 'Desk Chair', 'Furniture', 150, 20),
(4, 'Washing Machine', 'Home Appliances', 600, 10),
(5, 'Air Conditioner', 'Home Appliances', 1000, 15)

-- 22. Use SELECT INTO to create a backup table called Products_Backup containing all Products data.
select * into Products_Backup from Products

-- 23. Rename the Products table to Inventory.
exec sp_rename 'Products', 'Inventory'

-- 24. Alter the Inventory table to change the data type of Price from DECIMAL(10,2) to FLOAT.
alter table Inventory 
alter column Price Float

-- 25. Add an IDENTITY column named ProductCode that starts from 1000 and increments by 5.
alter table Inventory
add productCode int identity(1000, 5)

select * from Inventory
