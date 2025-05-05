/* Homework 20 */ 
-- 1. Find customers who purchased at least one item in March 2024 using EXISTS
select distinct s.customername
from #sales s
where exists (
    select 1
    from #sales x
    where x.customername = s.customername
      and x.saledate >= '2024-03-01'
      and x.saledate < '2024-04-01'
);

-- 2. Find the product with the highest total sales revenue using a subquery.
select top 1 product
from #sales s
where s.price * s.quantity = (
    select max(price * quantity)
    from #sales
    where product = s.product
)

-- 3. Find the second highest sale amount using a subquery
select max(price * quantity) as second_highest_sale
from #sales
where price * quantity < (
    select max(price * quantity)
    from #sales
)

-- 4. Find the total quantity of products sold per month using a subquery
select 
    month(s.saledate) as sale_month,
    sum(s.quantity) as total_quantity_sold
from #sales s
group by month(s.saledate)

-- 5. Find customers who bought same products as another customer using EXISTS
select distinct s.customername
from #sales s
where exists (
    select 1
    from #sales x
    where x.product = s.product
      and x.customername <> s.customername
)

-- 6. Return how many fruits does each person have in individual fruit level
select 
    name,
    sum(case when fruit = 'Apple' then 1 else 0 end) as Apple,
    sum(case when fruit = 'Orange' then 1 else 0 end) as Orange,
    sum(case when fruit = 'Banana' then 1 else 0 end) as Banana
from Fruits
group by name

-- 7. Return older people in the family with younger ones
select f1.ParentId as PID, f2.ChildID as CHID
from Family f1, Family f2
where f1.ParentId = f2.ParentId
  and f1.ChildID < f2.ChildID

-- 8. Write an SQL statement given the following requirements. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas
select o1.CustomerID, o1.OrderID, o1.DeliveryState, o1.Amount
from #Orders o1
where o1.CustomerID in (select distinct o2.CustomerID 
                        from #Orders o2
                        where o2.DeliveryState = 'CA')
  and o1.DeliveryState = 'TX'

-- 9. Insert the names of residents if they are missing
insert into #residents (fullname, address)
select 'Unknown', address
from #residents
where fullname is null

-- 10. Write a query to return the route to reach from Tashkent to Khorezm. The result should include the cheapest and the most expensive routes
with recursive routepaths as (
    select departurecity, arrivalcity, cost, cast(departurecity as varchar(max)) + ' - ' + arrivalcity as route
    from #routes
    where departurecity = 'Tashkent'
    union all
    select r.departurecity, r.arrivalcity, rp.cost + r.cost, rp.route + ' - ' + r.arrivalcity as route
    from #routes r
    inner join routepaths rp on r.departurecity = rp.arrivalcity
    where r.arrivalcity != 'Tashkent'
)
select route, cost
from routepaths
where arrivalcity = 'Khorezm'
order by cost
offset 0 rows fetch next 1 rows only
union all
select route, cost
from routepaths
where arrivalcity = 'Khorezm'
order by cost desc
offset 0 rows fetch next 1 rows only

-- 11. Rank products based on their order of insertion.
select ID, Vals, row_number() over (order by ID) as Rank
from #RankingPuzzle

-- 12. Find employees whose sales were higher than the average sales in their department
select EmployeeID, EmployeeName, Department, SalesAmount
from #EmployeeSales e
where SalesAmount > (
    select avg(SalesAmount)
    from #EmployeeSales
    where Department = e.Department
)

-- 13. Find employees who had the highest sales in any given month using EXISTS
select EmployeeID, EmployeeName, Department, SalesAmount, SalesMonth, SalesYear
from #EmployeeSales e1
where exists (
    select 1
    from #EmployeeSales e2
    where e1.SalesMonth = e2.SalesMonth
    and e1.SalesYear = e2.SalesYear
    and e1.SalesAmount = (select max(SalesAmount) from #EmployeeSales where SalesMonth = e2.SalesMonth and SalesYear = e2.SalesYear)
)

-- 14. Find employees who made sales in every month using NOT EXISTS
select EmployeeID, EmployeeName
from #EmployeeSales e1
where not exists (
    select 1
    from #EmployeeSales e2
    where e2.EmployeeID = e1.EmployeeID
    and not exists (
        select 1
        from #EmployeeSales e3
        where e3.EmployeeID = e1.EmployeeID
        and e3.SalesMonth = e2.SalesMonth
    )
)

-- 15. Retrieve the names of products that are more expensive than the average price of all products.
select Name
from Products
where Price > (select avg(Price) from Products)

-- 16. Find the products that have a stock count lower than the highest stock count.
select Name
from Products
where Stock < (select max(Stock) from Products)

-- 17. Get the names of products that belong to the same category as 'Laptop'.
select Name
from Products
where Category = (select Category from Products where Name = 'Laptop')

-- 18. Retrieve products whose price is greater than the lowest price in the Electronics category.
select Name
from Products
where Price > (select min(Price) from Products where Category = 'Electronics')

-- 19. Find the products that have a higher price than the average price of their respective category.
select p.Name
from Products p
where p.Price > (
    select avg(Price)
    from Products
    where Category = p.Category
)

-- 20. Find the products that have been ordered at least once.
select distinct p.Name
from Products p
join Orders o on p.ProductID = o.ProductID

-- 21. Retrieve the names of products that have been ordered more than the average quantity ordered.
select p.Name
from Products p
join Orders o on p.ProductID = o.ProductID
group by p.Name
having sum(o.Quantity) > (select avg(Quantity) from Orders)

-- 22. Find the products that have never been ordered.
select p.Name
from Products p
left join Orders o on p.ProductID = o.ProductID
where o.ProductID is null

-- 23. Retrieve the product with the highest total quantity ordered.
select top 1 p.Name
from Products p
join Orders o on p.ProductID = o.ProductID
group by p.Name
order by sum(o.Quantity) desc
