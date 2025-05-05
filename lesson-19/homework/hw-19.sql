/* Homework 19 */
-- Task 1:
create procedure sp_get_employee_bonus
as
begin
    create table #employeebonus (
        employeeid int,
        fullname nvarchar(101),
        department nvarchar(50),
        salary decimal(10,2),
        bonusamount decimal(10,2)
    )

    insert into #employeebonus (employeeid, fullname, department, salary, bonusamount)
    select 
        e.employeeid,
        e.firstname + ' ' + e.lastname as fullname,
        e.department,
        e.salary,
        e.salary * db.bonuspercentage / 100 as bonusamount
    from employees e
    join departmentbonus db on e.department = db.department

    select * from #employeebonus
end

exec sp_get_employee_bonus


-- Task 2:
create procedure sp_update_salary_by_department
    @dept nvarchar(50),
    @increase decimal(5,2)
as
begin
    update employees
    set salary = salary + (salary * @increase / 100)
    where department = @dept

    select * from employees
    where department = @dept
end

exec sp_update_salary_by_department 'sales', 5

-- Task 3:
create table products_current (
    productid int primary key,
    productname nvarchar(100),
    price decimal(10,2)
);

create table products_new (
    productid int,
    productname nvarchar(100),
    price decimal(10,2)
);

insert into products_current values
(1, 'laptop', 1000),
(2, 'mouse', 25),
(3, 'keyboard', 45);

insert into products_new values
(1, 'laptop pro', 1200),
(2, 'mouse', 25),
(4, 'monitor', 300);

merge products_current as target
using products_new as source
on target.productid = source.productid
when matched then
    update set 
        target.productname = source.productname,
        target.price = source.price
when not matched by target then
    insert (productid, productname, price)
    values (source.productid, source.productname, source.price)
when not matched by source then
    delete;

select * from products_current;

-- Task 4:
create table if not exists tree (id int, p_id int);
truncate table tree;
insert into tree (id, p_id) values (1, null);
insert into tree (id, p_id) values (2, 1);
insert into tree (id, p_id) values (3, 1);
insert into tree (id, p_id) values (4, 2);
insert into tree (id, p_id) values (5, 2);

select 
    t.id,
    case 
        when t.p_id is null then 'root'
        when t.id in (select distinct p_id from tree where p_id is not null) then 'inner'
        else 'leaf'
    end as type
from tree t
order by t.id;

-- Task 5:
create table if not exists signups (user_id int, time_stamp datetime);
create table if not exists confirmations (user_id int, time_stamp datetime, action enum('confirmed','timeout'));

truncate table signups;
insert into signups (user_id, time_stamp) values 
(3, '2020-03-21 10:16:13'),
(7, '2020-01-04 13:57:59'),
(2, '2020-07-29 23:09:44'),
(6, '2020-12-09 10:39:37');

truncate table confirmations;
insert into confirmations (user_id, time_stamp, action) values 
(3, '2021-01-06 03:30:46', 'timeout'),
(3, '2021-07-14 14:00:00', 'timeout'),
(7, '2021-06-12 11:57:29', 'confirmed'),
(7, '2021-06-13 12:58:28', 'confirmed'),
(7, '2021-06-14 13:59:27', 'confirmed'),
(2, '2021-01-22 00:00:00', 'confirmed'),
(2, '2021-02-28 23:59:59', 'timeout');

select 
    s.user_id,
    round(
        ifnull(sum(c.action = 'confirmed') * 1.0 / count(c.user_id), 0)
    , 2) as confirmation_rate
from signups s
left join confirmations c on s.user_id = c.user_id
group by s.user_id
order by s.user_id;

-- Task 6:
create table employees (
    id int primary key,
    name varchar(100),
    salary decimal(10,2)
);

insert into employees (id, name, salary) values
(1, 'alice', 50000),
(2, 'bob', 60000),
(3, 'charlie', 50000);

select * from employees
where salary = (
    select min(salary) from employees
);

-- Task 7:
create table products (
    productid int primary key,
    productname nvarchar(100),
    category nvarchar(50),
    price decimal(10,2)
);

create table sales (
    saleid int primary key,
    productid int foreign key references products(productid),
    quantity int,
    saledate date
);

insert into products (productid, productname, category, price) values
(1, 'laptop model a', 'electronics', 1200),
(2, 'laptop model b', 'electronics', 1500),
(3, 'tablet model x', 'electronics', 600),
(4, 'tablet model y', 'electronics', 700),
(5, 'smartphone alpha', 'electronics', 800),
(6, 'smartphone beta', 'electronics', 850),
(7, 'smartwatch series 1', 'wearables', 300),
(8, 'smartwatch series 2', 'wearables', 350),
(9, 'headphones basic', 'accessories', 150),
(10, 'headphones pro', 'accessories', 250),
(11, 'wireless mouse', 'accessories', 50),
(12, 'wireless keyboard', 'accessories', 80),
(13, 'desktop pc standard', 'computers', 1000),
(14, 'desktop pc gaming', 'computers', 2000),
(15, 'monitor 24 inch', 'displays', 200),
(16, 'monitor 27 inch', 'displays', 300),
(17, 'printer basic', 'office', 120),
(18, 'printer pro', 'office', 400),
(19, 'router basic', 'networking', 70),
(20, 'router pro', 'networking', 150);

insert into sales (saleid, productid, quantity, saledate) values
(1, 1, 2, '2024-01-15'),
(2, 1, 1, '2024-02-10'),
(3, 1, 3, '2024-03-08'),
(4, 2, 1, '2024-01-22'),
(5, 3, 5, '2024-01-20'),
(6, 5, 2, '2024-02-18'),
(7, 5, 1, '2024-03-25'),
(8, 6, 4, '2024-04-02'),
(9, 7, 2, '2024-01-30'),
(10, 7, 1, '2024-02-25'),
(11, 7, 1, '2024-03-15'),
(12, 9, 8, '2024-01-18'),
(13, 9, 5, '2024-02-20'),
(14, 10, 3, '2024-03-22'),
(15, 11, 2, '2024-02-14'),
(16, 13, 1, '2024-03-10'),
(17, 14, 2, '2024-03-22'),
(18, 15, 5, '2024-02-01'),
(19, 15, 3, '2024-03-11'),
(20, 19, 4, '2024-04-01');

create procedure getproductsalessummary (@productid int)
as
begin
    select 
        p.productname,
        sum(s.quantity) as total_quantity_sold,
        sum(s.quantity * p.price) as total_sales_amount,
        min(s.saledate) as first_sale_date,
        max(s.saledate) as last_sale_date
    from products p
    left join sales s on p.productid = s.productid
    where p.productid = @productid
    group by p.productname
end;
