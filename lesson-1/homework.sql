-- Easy Level

-- 1. Definitions:
-- Data – Any kind of information stored in a computer.
-- Database – A place where data is stored in an organized way.
-- Relational Database – A type of database where data is kept in tables that are connected to each other.
-- Table – A structure inside a database that holds data in rows and columns.

-- 2. Five important things about SQL Server:
-- - Works fast and can handle a lot of data
-- - Keeps data safe with encryption and authentication
-- - Allows using stored procedures and triggers to automate tasks
-- - Can work with other Microsoft products
-- - Supports backup and replication to prevent data loss

-- 3. Ways to log in to SQL Server:
-- - Windows Authentication 
-- - SQL Server Authentication 

-- Medium Level

-- 4. Creating a database
CREATE DATABASE SchoolDB;

-- 5. Creating the Students table
USE SchoolDB;

CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT
);

-- 6. Differences between SQL Server, SSMS, and SQL:
-- SQL Server – A program that stores and manages data.
-- SSMS – A tool used to interact with SQL Server easily.
-- SQL – The language used to communicate with databases, like asking for or changing data.

-- Hard Level

-- 7. Types of SQL commands:
-- DQL (Data Query Language) – Used to get data (e.g., SELECT)
-- DML (Data Manipulation Language) – Used to change data (INSERT, UPDATE, DELETE)
-- DDL (Data Definition Language) – Used to define database structure (CREATE, ALTER, DROP)
-- DCL (Data Control Language) – Used to control access to data (GRANT, REVOKE)
-- TCL (Transaction Control Language) – Used to manage transactions (COMMIT, ROLLBACK, SAVEPOINT)

-- 8. Adding students to the table
INSERT INTO Students (StudentID, Name, Age) VALUES (1, 'Amir', 20);
INSERT INTO Students (StudentID, Name, Age) VALUES (2, 'Mariam', 22);
INSERT INTO Students (StudentID, Name, Age) VALUES (3, 'Imran', 19);
