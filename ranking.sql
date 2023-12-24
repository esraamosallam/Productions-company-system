--RANK(), DENSE_RANK(), ROW_NUMBER(), NTILE()
select * , ROW_NUMBER() over (order by Rating desc) as RN
from evalution

select * , DENSE_RANK() over (order by Rating desc) as DR
from evalution 

select * , RANK() over (order by Rating desc) as R
from evalution

select * , Ntile(3) over (order by Rating DESC) as G
from evalution 

--Find third avg of rating of movie for production company with repeating
select * from 
(
select  p.name,
    AVG(m.rating) AS avg_rating,
    DENSE_RANK() OVER (ORDER BY AVG(m.Rating) DESC) AS DN
FROM
    production_company p,movie m
   where  p.PID = m.PID
GROUP BY p.name
) as newTable
where DN = 3

--Find third rating of movies with dense_rank for  production company  
select top (1)* from
(
select  p.name,
    AVG(m.rating) AS avg_rating,
    DENSE_RANK() OVER (ORDER BY AVG(m.Rating) DESC) AS DN
FROM
    production_company p,movie m
   where  p.PID = m.PID
GROUP BY p.name
) as newTable
where DN = 3

--create view includes ranking with row (partition by year)
create or alter view new_vyear 
as
select * , ROW_NUMBER() over (partition by m.year order by m.revenue_millions) as RN
from movie m
select * from new_vyear

---ranking by rank() for name of movie
select * , RANK() over (order by m.runtime_minutes desc) as R
from movie m

--ranking by row for revenue in each cinema
select * , ROW_NUMBER() over (partition by country order by revenue_millions) as RN
from [Movie-Cinema],Movie M,Cinema C
where M.MID=C.CID
----