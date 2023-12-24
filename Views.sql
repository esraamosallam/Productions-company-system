--extracting cinemas with their countries


create or alter view vcinema 
as
select c.cinema_name, c.Country, c.CID
from Cinema c
where c.Country in ('Manchester', 'Philadelphia', 'London', 'New York')


select * from vcinema


--Creating two table (2016, 2015)

create or alter view v2016 
as
select top (10) round(m.Rating,2) TopRated, m.Title, m.Description, m.Year
from Movie m
where m.Year  = 2016
go

create or alter view v2015 
as
select top (10) round(m.Rating,2) TopRated, m.Title, m.Description, m.Year
from Movie m
where m.Year  = 2015
go

create or alter view top15_16
as
select *  from v2016 
union all 
select * from v2015

select * from top15_16



