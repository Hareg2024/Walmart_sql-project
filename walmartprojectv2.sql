USE walmart;
-- =======================================================
-- Group the record by shift as morning, afternoon or night
select ordertime , (CASE
    WHEN ordertime BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
    WHEN ordertime BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
    ELSE'Night' END) as 'timeordered' 
    from salesdata_o;
-- anlayse the reocrds by specific date intervals and shift 

WITH salesrecord as (
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
        -- ans: Mandalay city gets the highest order in the night shift, 148 orders

-- =====================Productivity by product line by workshift ================
                -- create view for temporary use 
-- ------------------------------------------------------------------------
create view salesrecordbyshift as 
select *, 
(CASE
    WHEN ordertime BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
    WHEN ordertime BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
    ELSE'Night' END) as 'workshift' 
    from salesdata_o ;
select * from salesrecordbyshift; 

SELECT product_line,count(*) as pdtline_cnt, workshift
FROM salesrecordbyshift
WHERE workshift ='Morning'
GROUP BY product_line
ORDER BY count(*) desc;

           -- ans: 1.--Food and Bevarages gets the most order during night shift
                    -- while Home and lifestyleget the least order.
                --2. Afternoon sale in all product is moderate while the morning shift
                     -- Fashion and accessories prdt is higest selling & x 
                     -- Food and Beverage the least selling in the afternoon
                --3. Morning sell: Home and lifestyle prdt is the highest
                     -- Health and beauty being the least selling

-- =====================payment methods =======================================
                -- use view table salesrecordbyshift
-- ------------------------------------------------------------------------
SELECT Payment, count(*) as pymtcount
from salesdata_o
GROUP BY Payment
ORDER BY count(*) desc;
            -- 3 payment methods has been recorded
            -- Ewallet with 345 orders payments
            -- Cash with 344 orders payments
            -- Credit card with 311 order payments


-- =====================Which branch gets more payment by Ewallet =========
                -- use view table salesrecordbyshift
-- ------------------------------------------------------------------------
SELECT branch,payment, count(*) as ordercount
from salesrecordbyshift
GROUP BY branch,payment
HAVING payment='Ewallet'
ORDER BY branch,count(*) desc

        -- ans: Branch A get the most paymanets by Ewallet= 126 orders-- 
-- ---------------------------------------------------------------------------

-- =====================whcih month is productive ================
                
-- ------------------------------------------------------------------------
select  YEAR(orderDate) AS orderyear, monthname(orderDate) as ordermonth, count(*) as ordercount
from salesdata_o
group by YEAR(orderDate), monthname(orderDate)
        --- ans: Month January has highest order , 352 orders 

-- list order months in record --- 
select distinct monthname(orderdate) from salesdata_o;