USE walmart;
SELECT *,monthname(orderdate) as monthname 
from salesdata_o;


select distinct monthname(orderdate) from salesdata_o;

-- group the record by shift as morning, afternoon or night
select ordertime , (CASE
    WHEN ordertime BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
    WHEN ordertime BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
    ELSE'Night' END) as 'timeordered' 
    from salesdata_o;
-- anlayse the reocrds by specific fate intervals and shift 

WITH    salesrecord as (
select *, 
(CASE
    WHEN ordertime BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
    WHEN ordertime BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
    ELSE'Night' END) as 'timeordered' 
    from salesdata_o
)
select * from salesrecord 
where timeordered='Morning' and orderDate between '2019-01-05' and '2019-03-31';

-- =====================productivity of each city by shift ================
-- ------------------------------------------------------------------------
-- for each city check which shift gets more order 
WITH  salesrecord as (
select *, 
(CASE
    WHEN ordertime BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
    WHEN ordertime BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
    ELSE'Night' END) as workshift 
    from salesdata_o
)
select city, workshift,count(*) as ordercount
from salesrecord
GROUP BY city, workshift
order by ordercount desc;

-- =====================productivity by proctline by shift ================
                -- create view fro temporary use 
-- ------------------------------------------------------------------------
create view salesrecordbyshift as 
select *, 
(CASE
    WHEN ordertime BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
    WHEN ordertime BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
    ELSE'Night' END) as 'workshift' 
    from salesdata_o ;
select * from salesrecordbyshift; 

SELECT product_line, workshift,count(*) as pdtline_cnt from salesrecordbyshift
group by product_line, workshift
ORDER BY count(*) desc;

-- =====================payment methods ================
                -- use view table salesrecordbyshift
-- ------------------------------------------------------------------------
SELECT Payment, count(*) as pymtcount
from salesdata_o
GROUP BY Payment
ORDER BY count(*)

-- =====================whcih month is productive ================
                
-- ------------------------------------------------------------------------
select  YEAR(orderDate) AS orderyear, monthname(orderDate) as ordermonth, count(*) as ordercount
from salesdata_o
group by YEAR(orderDate), monthname(orderDate)


-- list order months in record --- 
select distinct monthname(orderdate) from salesdata_o;
