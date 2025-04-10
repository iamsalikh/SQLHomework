/* Homework */

use homeWorksDb

-- 1. Combine Two Tables
select p.firstName, p.lastName, a.city, a.state
from Person p
left join Address a on p.personId = a.personId

-- 2. Employees Earning More Than Their Managers
select e.name as Employee
from Employee e
join Employee m on e.managerId = m.id
where e.salary > m.salary

-- 3. Duplicate Emails
select email from Person
group by email
having COUNT(*) > 1

-- 4. Delete Duplicate Emails
delete from Person
where id NOT IN (SELECT MIN(id) FROM Person GROUP BY email)

-- 5. Find those parents who has only girls.
select g.ParentName from girls g
left join boys b on b.ParentName = g.ParentName
where b.ParentName is null

-- 6. Total over 50 and least
select o.CustomerID, sum(o.SalesAmount) as TotalSalesAmount, min(o.Weight) as LeastWeight
from Sales.Orders o
where o.Weight > 50
group by o.CustomerID;

-- 7. Carts
select 
    COALESCE(c1.Item, '') as [Item Cart 1],
    COALESCE(c2.Item, '') as [Item Cart 2]
from Cart1 c1
full OUTER JOIN Cart2 c2
    on c1.Item = c2.Item;

-- 8. Second Highest Salary
select 
    MatchID,
    Match,
    Score,
    case 
        when cast(left(Score, CHARINDEX(':', Score) - 1) as int) > cast(RIGHT(Score, len(Score) - CHARINDEX(':', Score)) as int)
            then left(Match, CHARINDEX('-', Match) - 1)
        when cast(left(Score, CHARINDEX(':', Score) - 1) as int) < cast(RIGHT(Score, len(Score) - CHARINDEX(':', Score)) as int)
            then right(Match, LEN(Match) - CHARINDEX('-', Match))
        else 'Draw'
    end as Result
from match1;

-- 9. Customers Who Never Order
select name AS Customers
from Customers c
left join Orders o on c.id = o.customerId
where o.id IS NULL;
