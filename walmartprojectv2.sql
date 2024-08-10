USE walmart;
-- ========================================================================
-- Group the record by shift as morning, afternoon or night
select ordertime , (CASE
    WHEN ordertime BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
    WHEN ordertime BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
    ELSE'Night' END) as 'workshift' 
    from salesdata_o;

    -- ==========Return the sales record b/n jan and march for a specific shift== 
                -- use cte to write clear coode --
    -- ---------------------------------------------------------------------
WITH salesrecord as (
select *, 
(CASE
    WHEN ordertime BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
    WHEN ordertime BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
    ELSE'Night' END) as 'workshift' 
    from salesdata_o
)
select * from salesrecord 
where workshift= 'Morning' and orderDate between '2019-01-05' and '2019-03-31';

-- ===================== Which product line had the largest revenue====
                --Revenue = sum of total sales 
---------------------------------------------------------------------------
      SELECT Product_line, sum(total) as revenue
      from salesdata_o  
      GROUP BY Product_line
      ORDER BY revenue DESC;        
        -- ans: Food and beverages had the largest revenue, $56,144

-- =====================Productivity of each city by shift ================
                -- for each city check which shift gets more order 
-- ------------------------------------------------------------------------
                        
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
                -- create view for temporary use than using cte over and over again
-- -------------------------------------------------------------------------------
create view salesrecordbyshift as 
select *, 
(CASE
    WHEN ordertime BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
    WHEN ordertime BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
    ELSE'Night' END) as 'workshift' 
    from salesdata_o ;

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

-- =====================City with largest Revenue  =======================================
                -- ans: Napyitaw city  had the largest revenue, $110,568 
-- ------------------------------------------------------------------------
select city, sum(total) as Revenue
from salesdata_o
GROUP BY City
order by sum(total) desc;

-- =====================payment methods =======================================
                -- 3 known payment methods recorded
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

-- =====================Which month is productive ============================
                
-- ------------------------------------------------------------------------
select  YEAR(orderDate) AS orderyear, monthname(orderDate) as ordermonth,round(sum(total),2) as totaSale
from salesdata_o
group by YEAR(orderDate), monthname(orderDate)
        --- ans:January has highest sale-->  $116,292 

-- list order months in record --- 
select distinct monthname(orderdate) from salesdata_o;

-- ----------------------------------------------------------------------------
-- ============Which month has the largest Revenue &  COGS ,cost of goods sold?===
-- ----------------------------------------------------------------------------

select monthname(orderDate) as MonthName,sum(total) as Revenue,sum(COGS) as cogs_sold
from salesdata_o
GROUP BY monthname(orderDate)
ORDER BY Revenue DESC ;
   -- ans : Jan had  the highest Revenue,$116,292 &
   -- February has the highest COGS, $110,754

-- ------------------------------------------------------------------------
--===============which branch sold more product than average pdt sold?=====
            -- used view table to create  ----
 -- -----------------------------------------------------------------------
 create view sum_pdtsold as
    select branch,sum(Quantity) qntysold
    from salesdata_o
    group by branch;
 
SELECT branch,sum(Quantity) as qnty
FROM salesdata_o
GROUP BY branch
HAVING qnty > (select avg(qntysold) from sum_pdtsold);
 

-- --------------------------------------------------------------------------
-- =============label product line as good,and bad based on avg sales========
                -- use case statment --
-- --------------------------------------------------------------------------
 SELECT date(orderdate) as orderdate, product_line,total as sale,(
 CASE 
 WHEN total > (SELECT AVG(total) AS avgsale from salesdata_o) THEN 'Good'
 ELSE 'Bad' END) AS pdt_status
 from salesdata_o;


-- =========== create stored procudure to retrieve specific year data========
        -- This can help to create visuals faster    
-- -------------------------------------------------------------------------------
delimiter //
create procedure salesrecordwithshift1(In ord_year int)
begin 
select *, 
(CASE
    WHEN ordertime BETWEEN "00:00:00" AND "12:00:00" THEN 'Morning'
    WHEN ordertime BETWEEN "12:01:00" AND "16:00:00" THEN 'Afternoon'
    ELSE'Night' END) as 'workshift' 
    from salesdata_o where year(orderDate)= ord_year;
    end//
    delimiter ; 
    -- stored procedure named salesrecordwithshift1 created above with year as param.
    -- let's return only 2024 records
    call salesrecordwithshift1(2024);
    -- this will return only 2024 records 
-- --------------------------------------------------------------------------------

