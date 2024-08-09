-use walmart;

-- Create a shift column as morning, afternoon, evening 

WITH  salesrecord as (
select *, 
(CASE
    WHEN ordertime BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
    WHEN ordertime BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
    ELSE'Night' END) as 'workshift' 
    from salesdata_o
)
select * from salesrecord 
where workshift='Morning' and orderDate between '2019-01-05' and '2019-03-31';


-- Which shift is more productive for each city 
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
order by ordercount desc limit 10;
