/* Homework 14 */
use hw14;

/* Easy tasks */ 
--  1.Write a SQL query to split the Name column by a comma into two separate columns: Name and Surname.(TestMultipleColumns)
SELECT 
    LEFT(FullName, CHARINDEX(',', FullName) - 1) AS Surname,
    RIGHT(FullName, LEN(FullName) - CHARINDEX(',', FullName)) AS Name
FROM TestMultipleColumns;

-- 2.Write a SQL query to find strings from a table where the string itself contains the % character.(TestPercent)
select * 
from TestPercent
where CHARINDEX('%', Strs) > 0;

-- 3.In this puzzle you will have to split a string based on dot(.).(Splitter) 
SELECT
  PARSENAME(Vals, 3) AS Part1,
  PARSENAME(Vals, 2) AS Part2,
  PARSENAME(Vals, 1) AS Part3
FROM Splitter;

-- 4. Write a SQL query to replace all integers (digits) in the string with 'X'.(1234ABC123456XYZ1234567890ADS)
select 
	REPLACE(
	REPLACE(
	REPLACE(
	REPLACE(
	REPLACE(
	REPLACE(
	REPLACE(
	REPLACE(
	REPLACE(
	REPLACE(val, '0', 'X'), '1', 'X'), '2', 'X'), '3', 'X'), '4', 'X'), '5', 'X'), '6', 'X'), '7', 'X'), '8', 'X'), '9', 'X')
from (select '1234ABC123456XYZ1234567890ADS' as val) as t;

-- 5. Write a SQL query to return all rows where the value in the Vals column contains more than two dots (.).(testDots)
select * 
from testDots
where LEN(vals) - LEN(REPLACE(vals, '.', '')) > 2;

-- 6. Write a SQL query to count the occurrences of a substring within a string in a given column.(Not table)
select 
    (len(column_name) - len(replace(column_name, 'substring', ''))) / len('substring') as occurrence_count
from table_name;

-- 7. Write a SQL query to count the spaces present in the string.(CountSpaces)
select 
    (len(texts) - len(replace(texts, ' ', ''))) as countspaces
from countspaces;

-- 8. write a SQL query that finds out employees who earn more than their managers.(Employee)
select e1.name
from Employee e1
join Employee e2 on e1.managerId = e2.id
where e1.salary > e2.salary;

/* Medium Tasks */
-- 1. Write a SQL query to separate the integer values and the character values into two different columns.(SeperateNumbersAndCharcters)
select
    replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
    value, '0', ''), '1', ''), '2', ''), '3', ''), '4', ''), '5', ''), '6', ''), '7', ''), '8', ''), '9', '') as only_letters,
    
    replace(replace(replace(replace(replace(replace(replace(replace(replace(replace(
    value, 'a', ''), 'b', ''), 'c', ''), 'd', ''), 'e', ''), 'f', ''), 'g', ''), 'h', ''), 'i', ''), 'j', '') -- и дальше все буквы до 'z'
    as only_numbers
from seperatenumbersandcharcters;

-- 2. write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.(weather)
select w1.id, w1.recordDate
from weather w1
join weather w2 on w1.recordDate = dateadd(day, 1, w2.recordDate)
where w1.temperature > w2.temperature;

-- 3. Write a SQL query that reports the device that is first logged in for each player.(Activity)
select player_id, device_id, min(event_date) as first_login
from Activity
group by player_id, device_id;

-- 4. Write an SQL query that reports the first login date for each player.(Activity)
select player_id, min(event_date) as first_login_date
from Activity
group by player_id;

-- 5. Your task is to split the string into a list using a specific separator (such as a space, comma, etc.), and then return the third item from that list.(fruits)
select value
from (select row_number() over (order by (select null)) as rn, value
      from string_split('apple,banana,orange,grape', ',')) as split_values
where rn = 3;

-- 6. Write a SQL query to create a table where each character from the string will be converted into a row, with each row having a single column.(sdgfhsdgfhs@121313131)
select substring('sdgfhsdgfhs@121313131', number, 1) as character
from master.dbo.spt_values
where type = 'P' and number <= len('sdgfhsdgfhs@121313131');

-- 7. You are given two tables: p1 and p2. Join these tables on the id column. The catch is: when the value of p1.code is 0, replace it with the value of p2.code.(p1,p2)
select p1.id, 
       case when p1.code = 0 then p2.code else p1.code end as code
from p1
left join p2 on p1.id = p2.id;

-- 8. You are given a sales table. Calculate the week-on-week percentage of sales per area for each financial week. For each week, the total sales will be considered 100%, and the percentage sales for each day of the week should be calculated based on the area sales for that week.(WeekPercentagePuzzle)
with weekly_sales as (
    select Area, FinancialWeek, sum(SalesLocal + SalesRemote) as total_sales
    from WeekPercentagePuzzle
    group by Area, FinancialWeek
),
daily_sales as (
    select Area, FinancialWeek, sum(SalesLocal + SalesRemote) as daily_sales
    from WeekPercentagePuzzle
    group by Area, FinancialWeek, Date
)
select d.Area, d.FinancialWeek, 
       (d.daily_sales * 100.0 / w.total_sales) as sales_percentage
from daily_sales d
join weekly_sales w 
    on d.Area = w.Area and d.FinancialWeek = w.FinancialWeek;

/* Difficult Tasks */ 
-- 1. In this puzzle you have to swap the first two letters of the comma separated string.(MultipleVals)
with split_values as (
    select row_number() over (order by (select null)) as rn, value
    from string_split('apple,banana,orange', ',') -- здесь твоя строка
)
select 
    case 
        when rn = 1 then concat(substring(value, 2, 1), substring(value, 1, 1), substring(value, 3, len(value)-2))
        else value
    end as swapped_values
from split_values;

-- 2. Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)
select value
from string_split('aa,bbb,cccc,abcd', ',')  -- замените на нужную строку
where len(value) > 1
  and not exists (
    select 1
    from (select distinct substring(value, 1, 1) as char) as subquery
    where len(subquery.char) > 1
  );

-- 3. Write a T-SQL query to remove the duplicate integer values present in the string column. Additionally, remove the single integer character that appears in the string.(RemoveDuplicateIntsFromNames)
with split_values as (
    select value
    from string_split('1 2 3 2 4 4 5', ' ')  -- замените на вашу строку
),
counted_values as (
    select value, count(*) as value_count
    from split_values
    group by value
)
select string_agg(value, ' ') as cleaned_values
from counted_values
where value_count > 1;

-- 4. Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)
select value
from string_split('aa,bbb,cccc,abcd', ',')  -- замените на вашу строку
where len(value) > 1
  and not exists (
    select 1
    from (select distinct substring(value, 1, 1) as char) as subquery
    where len(subquery.char) > 1
  );

-- 5. Write a SQL query to extract the integer value that appears at the start of the string in a column named Vals.(GetIntegers)
select 
    case 
        when PATINDEX('%[0-9]%', Vals) > 0 
        then 
            CAST(
                SUBSTRING(Vals, 
                          PATINDEX('%[0-9]%', Vals), 
                          -- Если после числа идут символы, обрезаем всё, что после первого нецифрового символа
                          PATINDEX('%[^0-9]%', Vals + 'a') - PATINDEX('%[0-9]%', Vals)
                ) 
            AS int)
        else null
    end as ExtractedInteger
from GetIntegers;
