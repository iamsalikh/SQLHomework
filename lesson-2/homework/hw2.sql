-- 1. Create a table Employees
create table Employee (
	EmpID INT,
	Name Varchar(50),
	Salary Decimal(10,2))

-- 2. Insert three records into the Employees
insert into Employee (EmpID, Name, Salary) values (1, 'Salikh', 1300)
insert into Employee values (2, 'Rizvan', 1439)
insert into Employee values (3, 'Enrique', 2410), (4, 'Hulio', 3914)

-- 3. Update the Salary
update Employee
set Salary = 5900
where EmpID = 1

-- 4. Delete a record from the Employees
delete Employee
where EmpID = 2

-- 5. Demonstrate the difference between DELETE, TRUNCATE, and DROP commands on a test table
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
