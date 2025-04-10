/* Homework 11 */

use homeWorksDb

/* Easy-Level Tasks */
-- 1. orders after 2022 with customer names
select o.orderid, c.customername, o.orderdate
from orders o
join customers c on o.customerid = c.customerid
where year(o.orderdate) > 2022;

-- 2. employees in sales or marketing
select e.employeename, d.departmentname
from employees e
join departments d on e.departmentid = d.departmentid
where d.departmentname in ('sales', 'marketing');

-- 3. top earning employee in each department
select d.departmentname, e.employeename as topemployeename, e.salary as maxsalary
from departments d
join (
    select departmentid, employeename, salary
    from employees e1
    where salary = (
        select max(salary)
        from employees e2
        where e1.departmentid = e2.departmentid
    )
) e on d.departmentid = e.departmentid;

-- 4. customers from USA who ordered in 2023
select c.customername, o.orderid, o.orderdate
from customers c
join orders o on c.customerid = o.customerid
where c.country = 'usa' and year(o.orderdate) = 2023;

-- 5. number of orders per customer
select c.customername, count(o.orderid) as totalorders
from customers c
left join orders o on c.customerid = o.customerid
group by c.customername;

-- 6. products from specific suppliers
select p.productname, s.suppliername
from products p
join suppliers s on p.supplierid = s.supplierid
where s.suppliername in ('gadget supplies', 'clothing mart');

-- 7. most recent order per customer (include those with no orders)
select c.customername,
       max(o.orderdate) as mostrecentorderdate,
       (
           select top 1 orderid
           from orders o2
           where o2.customerid = c.customerid
           order by o2.orderdate desc
       ) as orderid
from customers c
left join orders o on c.customerid = o.customerid
group by c.customername;

/* Medium level */
-- 1. orders with amount > 500
select c.customername, o.orderid, o.amount as ordertotal
from orders o
join customers c on o.customerid = c.customerid
where o.amount > 500;

-- 2. product sales in 2022 or amount > 400
select p.productname, s.saledate, s.amount as saleamount
from sales s
join products p on s.productid = p.productid
where year(s.saledate) = 2022 or s.amount > 400;

-- 3. total sales amount per product
select p.productname, sum(s.amount) as totalsalesamount
from products p
join sales s on p.productid = s.productid
group by p.productname;

-- 4. hr employees with salary > 50000
select e.employeename, d.departmentname, e.salary
from employees e
join departments d on e.departmentid = d.departmentid
where d.departmentname = 'hr' and e.salary > 50000;

-- 5. products sold in 2023 and stock > 50 at that time
select p.productname, s.saledate, p.quantity as stockquantity
from products p
join sales s on p.productid = s.productid
where year(s.saledate) = 2023 and p.quantity > 50;

-- 6. sales employees or hired after 2020
select e.employeename, d.departmentname, e.hiredate
from employees e
join departments d on e.departmentid = d.departmentid
where d.departmentname = 'sales' or year(e.hiredate) > 2020;

/* Hard level */
-- 1. usa customers with address starting with 4 digits
select c.customername, o.orderid, c.address, o.orderdate
from customers c
join orders o on c.customerid = o.customerid
where c.country = 'usa' and c.address like '[0-9][0-9][0-9][0-9]%';

-- 2. electronics category or sales > 350
select p.productname, p.category, s.amount as saleamount
from sales s
join products p on s.productid = p.productid
where p.category = 'electronics' or s.amount > 350;

-- 3. product count per category
select cat.categoryname, count(p.productid) as productcount
from categories cat
left join products p on cat.categoryid = p.categoryid
group by cat.categoryname;

-- 4. los angeles customers with amount > 300
select c.customername, c.city, o.orderid, o.amount
from customers c
join orders o on c.customerid = o.customerid
where c.city = 'los angeles' and o.amount > 300;

-- 5. hr or finance or name with 4+ vowels
select e.employeename, d.departmentname
from employees e
join departments d on e.departmentid = d.departmentid
where d.departmentname in ('hr', 'finance')
   or len(replace(replace(replace(replace(replace(lower(e.employeename), 'a', ''), 'e', ''), 'i', ''), 'o', ''), 'u', '')) <= len(e.employeename) - 4;

-- 6. products with quantity sold > 100 and price > 500
select p.productname, sum(s.quantity) as quantitysold, p.price
from products p
join sales s on p.productid = s.productid
group by p.productname, p.price
having sum(s.quantity) > 100 and p.price > 500;

-- 7. sales or marketing employees with salary > 60000
select e.employeename, d.departmentname, e.salary
from employees e
join departments d on e.departmentid = d.departmentid
where d.departmentname in ('sales', 'marketing') and e.salary > 60000; from Departments
