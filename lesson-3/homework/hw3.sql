-- EASY LEVEL TASKS (10)

-- 1. Define and explain the purpose of BULK INSERT in SQL Server.
-- BULK INSERT is used to quickly load large amounts of data from a file into a SQL Server table.

-- 2. List four file formats that can be imported into SQL Server.
-- Common formats:
-- - CSV
-- - TXT
-- - JSON
-- - XML

-- 3. Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price DECIMAL(10,2)
);

-- 4. Insert three records into the Products table using INSERT INTO.
INSERT INTO Products (ProductID, ProductName, Price)
VALUES 
    (1, 'Laptop', 999.99),
    (2, 'Mouse', 19.99),
    (3, 'Keyboard', 49.99);

-- 5. Explain the difference between NULL and NOT NULL with examples.
-- NULL means no value is assigned.
-- NOT NULL forces a value to be provided.

-- Example:
CREATE TABLE ExampleTable (
    ID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,  -- Cannot be NULL
    Description VARCHAR(255) NULL -- Can be NULL
);

-- 6. Add a UNIQUE constraint to the ProductName column in the Products table.
ALTER TABLE Products 
ADD CONSTRAINT UQ_ProductName UNIQUE (ProductName);

-- 7. Write a comment in a SQL query explaining its purpose.
-- This query selects all products with a price greater than 50.
SELECT * FROM Products WHERE Price > 50;

-- 8. Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);

-- 9. Explain the purpose of the IDENTITY column in SQL Server.
-- IDENTITY generates unique values automatically for each new row.

-- Example:
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    OrderDate DATE NOT NULL
);


-- MEDIUM LEVEL TASKS (10)

-- 10. Use BULK INSERT to import data from a text file into the Products table.
BULK INSERT Products
FROM 'C:\data\products.txt'
WITH (FORMAT = 'CSV', FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n');

-- 11. Create a FOREIGN KEY in the Products table that references the Categories table.
ALTER TABLE Products 
ADD CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID);

-- 12. Explain the differences between PRIMARY KEY and UNIQUE KEY with examples.
-- PRIMARY KEY: Ensures uniqueness and does not allow NULLs.
-- UNIQUE KEY: Ensures uniqueness but allows NULLs.

-- Example:
CREATE TABLE ExampleKeys (
    ID INT PRIMARY KEY, -- Only one per table
    Email VARCHAR(100) UNIQUE -- Allows NULL
);

-- 13. Add a CHECK constraint to the Products table ensuring Price > 0.
ALTER TABLE Products 
ADD CONSTRAINT CHK_Price CHECK (Price > 0);

-- 14. Modify the Products table to add a column Stock (INT, NOT NULL).
ALTER TABLE Products 
ADD Stock INT NOT NULL DEFAULT 0;

-- 15. Use the ISNULL function to replace NULL values in a column with a default value.
SELECT ProductName, ISNULL(Price, 0) AS Price 
FROM Products;

-- 16. Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.
-- A FOREIGN KEY links tables to enforce referential integrity.

-- Example:
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID)
);


-- HARD LEVEL TASKS (10)

-- 17. Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT CHECK (Age >= 18)
);

-- 18. Create a table with an IDENTITY column starting at 100 and incrementing by 10.
CREATE TABLE Employees (
    EmpID INT IDENTITY(100,10) PRIMARY KEY,
    Name VARCHAR(100)
);

-- 19. Write a query to create a composite PRIMARY KEY in a new table OrderDetails.
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID) -- Composite Key
);

-- 20. Explain with examples the use of COALESCE and ISNULL functions for handling NULL values.
-- COALESCE returns the first non-null value from a list.
-- ISNULL replaces NULL with a specified value.

-- Example:
SELECT COALESCE(NULL, 'Default', 'Another Value') AS Result; -- Returns 'Default'
SELECT ISNULL(NULL, 'Default') AS Result; -- Returns 'Default'

-- 21. Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100) UNIQUE
);

-- 22. Write a query to create a FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE options.
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID) 
    ON DELETE CASCADE 
    ON UPDATE CASCADE
);
