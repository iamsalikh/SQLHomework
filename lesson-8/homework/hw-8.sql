/* Homework 8 */

use homeWorksDb

/* Easy-Level Tasks */
-- 1. total number of products available in each category
select category, count(*) as total_products
from products
group by category;

-- 2. average price of products in 'electronics' category
select avg(price) as avg_price
from products
where category = 'electronics';

-- 3. customers from cities starting with 'l'
select *
from customers
where city like 'l%';

-- 4. product names ending with 'er'
select productname
from products
where productname like '%er';

-- 5. customers from countries ending with 'a'
select *
from customers
where country like '%a';

-- 6. highest product price
select max(price) as highest_price
from products;

-- 7. iif to label stock
select productname,
       quantity,
       iif(quantity < 30, 'low stock', 'sufficient') as stock_status
from products;

-- 8. total number of customers in each country
select country, count(*) as total_customers
from customers
group by country;

-- 9. min and max quantity ordered
select min(quantity) as min_qty,
       max(quantity) as max_qty
from orders;

/* Medium Level */
-- 1. customer ids who ordered in 2023 but have no invoices
select distinct customerid
from orders
where year(orderdate) = 2023

except

select distinct customerid
from invoices;

-- 2. combine all product names with duplicates
select productname from products
union all
select productname from products_discounted;

-- 3. combine all product names without duplicates
select productname from products
union
select productname from products_discounted;

-- 4. average order amount by year
select year(orderdate) as order_year,
       avg(amount) as avg_amount
from orders
group by year(orderdate);

-- 5. group products by price
select productname,
       case
           when price < 100 then 'low'
           when price between 100 and 500 then 'mid'
           else 'high'
       end as price_group
from products;

-- 6. unique cities of customers sorted
select distinct city
from customers
order by city;

-- 7. total sales per product id
select productid, sum(amount) as total_sales
from sales
group by productid;

-- 8. products with 'oo' in name
select productname
from products
where productname like '%oo%';

-- 9. intersect product ids
select productid
from products
intersect
select productid
from products_discounted;

/* Hard Level */
-- 1. top 3 customers by invoice total
select top 3 customerid,
       sum(amount) as total_spent
from invoices
group by customerid
order by total_spent desc;

-- 2. products in products but not in products_discounted
select productid, productname
from products
where productid not in (
    select productid from products_discounted
);

-- 3. product names and times sold
select p.productname,
       count(s.saleid) as times_sold
from products p
join sales s on p.productid = s.productid
group by p.productname;

-- 4. top 5 products by order quantity
select top 5 productid,
       sum(quantity) as total_ordered
from orders
group by productid
order by total_ordered desc;
