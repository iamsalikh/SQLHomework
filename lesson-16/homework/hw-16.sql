/* Homework 16 */
use hw16;

-- 1. Write an SQL Statement to de-group the following data.
with cte as (
Select Product, Quantity from Grouped
union all
Select Product, Quantity - 1 from cte where Quantity - 1 > 0
)
Select Product, 1 as Quantity from cte;

-- 2. You must provide a report of all distributors and their sales by region. 
-- If a distributor did not have any sales for a region, rovide a zero-dollar value for that day. 
-- Assume there is at least one sale for each region
with Allregions as (
Select distinct region from #RegionSales
),
Alldistributors as (
Select distinct Distributor from #RegionSales
)
Select Allregions.Region, Alldistributors.Distributor, isnull(#RegionSales.Sales, 0) from Allregions cross join Alldistributors left join #RegionSales
on 
	Allregions.Region = #RegionSales.Region
and 
	Alldistributors.Distributor = #RegionSales.Distributor;

-- 3. Find managers with at least five direct reports
select 
    e2.managerId as managerID,
    count(e2.id) as numOfEmployees
from employee e2
where e2.managerId is not null
group by e2.managerId
having count(e2.id) >= 5;

-- 4. Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.
select p.product_name, sum(o.unit) as totalOrders
from Products p
join Orders o on p.product_id=o.product_id
where year(o.order_date) = 2020 and MONTH(o.order_date) = 2 
group by p.product_name
having sum(o.unit) >= 100;

-- 5. Write an SQL statement that returns the vendor from which each customer has placed the most orders
with vendor as (
	select 
		customerID, 
		vendor,
		SUM(count) as total_orders,
		rank() over (partition by customerID order by sum(count) desc) as rnk
	from orders
	group by customerID, vendor
)
select customerID, vendor
from vendor
where rnk = 1;

-- 6. You will be given a number as a variable called @Check_Prime check if this number is prime then return 
-- 'This number is prime' else eturn 'This number is not prime'
DECLARE @Check_Prime INT = 91; 
DECLARE @i INT = 2;
DECLARE @isPrime BIT = 1;  

IF @Check_Prime < 2
BEGIN
    SET @isPrime = 0;
END
ELSE
BEGIN
    WHILE @i <= SQRT(@Check_Prime)  
    BEGIN
        IF @Check_Prime % @i = 0
        BEGIN
            SET @isPrime = 0; 
            BREAK;            
        END
        SET @i = @i + 1;
    END
END

IF @isPrime = 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';

-- 7. Write an SQL query to return the number of locations,in which location most signals sent, and total number of signal 
-- for each device from the given table.
WITH signal_count AS (
    SELECT 
        Device_id, 
        Locations, 
        COUNT(*) AS signals
    FROM Device
    GROUP BY Device_id, Locations
),
max_signal_location AS (
    SELECT 
        Device_id,
        Locations AS max_signal_location,
        signals,
        RANK() OVER (PARTITION BY Device_id ORDER BY signals DESC) AS rnk
    FROM signal_count
)
SELECT 
    sc.Device_id,
    COUNT(DISTINCT sc.Locations) AS no_of_location,
    msl.max_signal_location,
    SUM(sc.signals) AS no_of_signals
FROM signal_count sc
JOIN max_signal_location msl ON sc.Device_id = msl.Device_id
WHERE msl.rnk = 1
GROUP BY sc.Device_id, msl.max_signal_location;

-- 8. Write a SQL to find all Employees who earn more than the average salary in their corresponding department. 
-- Return EmpID, EmpName,Salary in your output
select empId, empname, salary
from employee e
where salary > (select AVG(salary) from employee where DeptID = e.DeptID)

-- 9. You are part of an office lottery pool where you keep a table of the winning lottery numbers along with a table of each ticket’s chosen numbers. If a ticket has some but not all the winning numbers, you win $10. If a ticket has all the winning numbers, you win $100. Calculate the total winnings for today’s drawing.
WITH TicketMatches AS (
    SELECT 
        t.TicketID,
        COUNT(w.Number) AS matches
    FROM Tickets t
    LEFT JOIN WinningNumbers w ON t.Number = w.Number
    GROUP BY t.TicketID
)
SELECT 
    SUM(
        CASE 
            WHEN matches = 3 THEN 100
            WHEN matches > 0 THEN 10
            ELSE 0
        END
    ) AS total_winnings
FROM TicketMatches;

-- 10. The Spending table keeps the logs of the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile devices.
with platform_usage as (
    select 
        user_id, 
        spend_date,
        sum(case when platform = 'mobile' then amount else 0 end) as mobile_amount,
        sum(case when platform = 'desktop' then amount else 0 end) as desktop_amount,
        count(distinct platform) as platform_count
    from spending
    group by user_id, spend_date
),
labeled_usage as (
    select 
        spend_date,
        case 
            when platform_count = 2 then 'both'
            when mobile_amount > 0 then 'mobile'
            when desktop_amount > 0 then 'desktop'
        end as platform,
        mobile_amount + desktop_amount as total_amount,
        user_id
    from platform_usage
)
select 
    row_number() over(order by spend_date, platform) as row,
    spend_date,
    platform,
    sum(total_amount) as total_amount,
    count(distinct user_id) as total_users
from labeled_usage
group by spend_date, platform
order by spend_date, platform;
