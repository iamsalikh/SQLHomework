/* Lesson 6 */
-- Puzzle 1.
-- Question: If all the columns have zero values, then don’t show that row. In this case, we have to remove the 5th row while selecting data.
create table TestMultipleZero (
    A int NULL,
    B int NULL,
    C int NULL,
    D int NULL
);

insert into TestMultipleZero(A,B,C,D)
values 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);

select * 
from TestMultipleZero
where A <> 0 OR B <> 0 OR C <> 0 OR D <> 0;

-- Puzzle 2.
-- Question: Explain at least two ways to find distinct values based on two columns.
create table InputTbl (
    col1 varchar(10),
    col2 varchar(10)
);

insert into InputTbl (col1, col2) values 
('a', 'b'),
('a', 'b'),
('b', 'a'),
('c', 'd'),
('c', 'd'),
('m', 'n'),
('n', 'm');

select distinct 
    least(col1, col2) as col1, 
    greatest(col1, col2) as col2
from InputTbl;

-- Puzzle 3.
-- Find those with odd ids
create table section1(id int, name varchar(20))
insert into section1 values (1, 'Been'),
       (2, 'Roma'),
       (3, 'Steven'),
       (4, 'Paulo'),
       (5, 'Genryh'),
       (6, 'Bruno'),
       (7, 'Fred'),
       (8, 'Andro')
select * from section1
where id % 2 = 1

-- Puzzle 4.
-- Person with the smallest id (use the table in puzzle 3)
select * from section1 
select top 1 * from section1 
order by id asc 

-- Puzzle 5. 
-- Person with the highest id (use the table in puzzle 3)
select top 1 * from section1 order by id desc 

-- Puzzle 6. 
-- People whose name starts with b (use the table in puzzle 3)
select * from section1
where name like 'b%'

-- Puzle 7.
-- Write a query to return only the rows where the code contains the literal underscore _ (not as a wildcard).
create table ProductCodes (
    Code varchar(20)
);

insert into ProductCodes (Code) values
('X-123'),
('X_456'),
('X#789'),
('X-001'),
('X%202'),
('X_ABC'),
('X#DEF'),
('X-999');

select * from ProductCodes
where Code like '%\_%' escape '\'
