/* homework 18 */
use hw18

-- 1. Create a temporary table named MonthlySales to store the total quantity sold and total revenue for each product in the current month.
-- Return: ProductID, TotalQuantity, TotalRevenue
create table #MothlySales (
	ProductID INT,
	TotalQuantity INT,
	TotalRevenue DECIMAL(10, 2)
);

insert into #MothlySales (ProductID, TotalQuantity, TotalRevenue)
select s.ProductID, SUM(s.Quantity) as TotalQuantity, SUM(s.Quantity * p.Price) as TotalRevenue
from Sales s
join Products p on s.ProductID = p.ProductID
where MONTH(s.SaleDate) = 4 and YEAR(s.SaleDate) = 2025
group by s.ProductID;

-- 2. Create a view named vw_ProductSalesSummary that returns product info along with total sales quantity across all time.
-- Return: ProductID, ProductName, Category, TotalQuantitySold
create view vw_ProductSalesSummary as
select p.ProductID, p.ProductName, p.Category, SUM(s.Quantity) as TotalQuantitySold
from Products p
join Sales s on p.ProductID = s.ProductID
group by p.ProductID, p.ProductName, p.Category;

-- 3. Create a function named fn_GetTotalRevenueForProduct(@ProductID INT)
-- Return: total revenue for the given product ID
create function fn_GetTotalRevenueForProduct(@ProductID INT) 
returns decimal(10, 2)
as 
begin 
	declare @TotalRevenue decimal(10, 2)
	
	select @TotalRevenue = SUM(s.Quantity * p.Price)
	from Products p
	join Sales s on p.ProductID = s.ProductID
	where p.ProductID = @ProductID

	return @TotalRevenue
end;
SELECT dbo.fn_GetTotalRevenueForProduct(1) AS RevenueForProduct1;

-- 4. Create an function fn_GetSalesByCategory(@Category VARCHAR(50))
-- Return: ProductName, TotalQuantity, TotalRevenue for all products in that category.
CREATE FUNCTION fn_GetSalesByCategory (@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantity,
        SUM(s.Quantity * p.Price) AS TotalRevenue
    FROM Products p
    JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.Category = @Category
    GROUP BY p.ProductName
);
SELECT * FROM fn_GetSalesByCategory('Electronics');

-- 5. You have to create a function that get one argument as input from user and the function should return 'Yes' if the input number is a prime number and 'No' otherwise. You can start it like this:
-- Create function dbo.fn_IsPrime (@Number INT)
-- Returns ...
-- This is for those who has no idea about prime numbers: A prime number is a number greater than 1 that has only two divisors: 1 and itself(2, 3, 5, 7 and so on).
CREATE FUNCTION dbo.fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    DECLARE @i INT = 2
    IF @Number < 2
        RETURN 'No'

    WHILE @i <= SQRT(@Number)
    BEGIN
        IF @Number % @i = 0
            RETURN 'No'
        SET @i = @i + 1
    END

    RETURN 'Yes'
END
SELECT dbo.fn_IsPrime(7) AS IsPrime  -- результат: Yes
SELECT dbo.fn_IsPrime(10) AS IsPrime -- результат: No

-- 6. Create a table-valued function named fn_GetNumbersBetween that accepts two integers as input:
-- @Start INT
-- @End INT
-- The function should return a table with a single column:
-- Number
-- ...
-- It should include all integer values from @Start to @End, inclusive.
CREATE FUNCTION fn_GetNumbersBetween (@Start INT, @End INT)
RETURNS @Result TABLE (Number INT)
AS
BEGIN
    DECLARE @i INT = @Start

    WHILE @i <= @End
    BEGIN
        INSERT INTO @Result (Number)
        VALUES (@i)

        SET @i = @i + 1
    END

    RETURN
END
SELECT * FROM fn_GetNumbersBetween(3, 7);

-- 7. Write a SQL query to return the Nth highest distinct salary from the Employee table. If there are fewer than N distinct salaries, return NULL. 
-- NOTE: You have to do some research on Dense_rank window function.
CREATE FUNCTION getNthHighestSalary (@N INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT

    SELECT @Result = salary
    FROM (
        SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
        FROM Employee
    ) AS ranked
    WHERE rnk = @N

    RETURN @Result
END
SELECT dbo.getNthHighestSalary(2) AS NthSalary;

-- 8. Write a SQL query to find the person who has the most friends.
-- Return: Their id, The total number of friends they have
select top 1 id, count(*) as num
from (
    select requester_id as id from requestaccepted
    union all
    select accepter_id as id from requestaccepted
) as all_friends
group by id
order by count(*) desc;

-- 9. Create a View for Customer Order Summary. 
create view vw_customerordersummary as
select 
    c.customer_id,
    c.name,
    count(o.order_id) as total_orders,
    sum(o.amount) as total_amount,
    max(o.order_date) as last_order_date
from customers c
left join orders o on c.customer_id = o.customer_id
group by c.customer_id, c.name;

-- 10. Write an SQL statement to fill in the missing gaps. You have to write only select statement, no need to modify the table.
select 
    g.rownumber,
    t.testcase as workflow,
    case 
        when g.rownumber in (1, 5, 8, 9) then 'Pass'
        else 'Fail'
    end as status
from gaps g
outer apply (
    select top 1 testcase
    from gaps g2
    where g2.rownumber <= g.rownumber and g2.testcase is not null
    order by g2.rownumber desc
) t
order by g.rownumber;
