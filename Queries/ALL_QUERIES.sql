--extracting cinemas with their countries
use Ninja
go
create or alter view vcinema 
as
select c.cinema_name, c.Country, c.CID
from Cinema c
where c.Country in ('Manchester', 'Philadelphia', 'London', 'New York')
go

select * from vcinema


--Creating two table (2016, 2015)
go
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
go

select * from top15_16
order by TopRated desc






--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################


--Functions
--Functions
--Functions
--Functions
go
-----scalar function
CREATE or alter Function highest_revenue_of_film(@y int )
returns varchar(50)
		begin
			declare @name varchar(50)
			select @name = title from movie where year = @y
			order by Revenue_Millions 
			return @name
		end 
go
select dbo.highest_revenue_of_film(2014)

---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------



---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------

select title from movie where year = 2014
			order by Revenue_Millions desc

---- inline Function 
go
CREATE or alter Function awarded_Movie(@awid int )
returns Table
as
return
(
select title,year,rating, A.name 
from movie M , awards A , [Movie-Award] MA
where M.MID=MA.MID and MA.AWID=A.AWID and A.AWID=@awid
)
 go
 select * from awarded_Movie(5)



go
--------- Multi statment Function 
CREATE or ALTER Function get_Total_revenue_by_each_Country(@n varchar(50))
returns @a table 
				(
				Total_revenue Float 
				)
as
	begin
		if @n = 'Manchester'
		insert into @a 
		select sum(M.Revenue_Millions) as Total_revenue from Movie M , Cinema C ,[Movie-Cinema] MC
		where C.CID=MC.CID and M.MID=MC.MID and C.Country= 'Manchester'
		group by C.Country

		else if @n = 'Oxford'
		insert into @a
		select sum(M.Revenue_Millions) as Total_revenue from Movie M , Cinema C ,[Movie-Cinema] MC
		where C.CID=MC.CID and M.MID=MC.MID and C.Country= 'Oxford'
		group by C.Country
		else if @n = 'Nice'
		insert into @a
		select sum(M.Revenue_Millions) as Total_revenue from Movie M , Cinema C ,[Movie-Cinema] MC
		where C.CID=MC.CID and M.MID=MC.MID and C.Country= 'Nice'
		group by C.Country
		return
	end

go

select * from get_Total_revenue_by_each_Country('Oxford')		





--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################


--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################

--Ranking
--Ranking
--Ranking
--Ranking
--Ranking
--Ranking
--Ranking
--Ranking
--Ranking


--RANK(), DENSE_RANK(), ROW_NUMBER(), NTILE()
select * , ROW_NUMBER() over (order by Rating desc) as RN
from evaluation

select * , DENSE_RANK() over (order by Rating desc) as DR
from evaluation 

select * , RANK() over (order by Rating desc) as R
from evaluation

select * , Ntile(3) over (order by Rating DESC) as G
from evaluation 

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

go
--create view includes ranking with row (partition by year)
create or alter view new_vyear 
as
select * , ROW_NUMBER() over (partition by m.year order by m.revenue_millions) as RN
from movie m
go
select * from new_vyear

---ranking by rank() for name of movie
select * , RANK() over (order by m.runtime_minutes desc) as R
from movie m

--ranking by row for revenue in each cinema
select * , ROW_NUMBER() over (partition by country order by revenue_millions) as RN
from [Movie-Cinema],Movie M,Cinema C
where M.MID=C.CID
----




--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################


--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################

---------------------Triggers-----------------------------
go
--Detect any Insert and time of it
create TABLE notifications2(MSG VARCHAR(50),DATEE datetime)
go
create or alter trigger DetectInsert
ON Movie 
AFTER INSERT 
AS 
BEGIN
INSERT INTO notifications2 (MSG, DATEE)
VALUES (SUSER_NAME(),SYSDATETIME())
END 

INSERT INTO Movie(MID,Title)
VALUES (1013,'NINJA')

SELECT * FROM notifications2

------------------------PreventNegValues--------------------
go
CREATE OR ALTER TRIGGER PreventNegValues 
ON Movie 
for INSERT
as    
begin
IF EXISTS (SELECT * FROM inserted WHERE Revenue_Millions < 0)
   BEGIN
      SELECT 'No negative Revenue is allowed'
      ROLLBACK;
      RETURN
   END
   END
GO
insert into Movie (Revenue_Millions,MID)
VAlues (-10,1006)

select Revenue_Millions from Movie
-------------------Prevent alter or add any table----------------
go
create or alter trigger t2
on database
for alter_table 
as 
select'Not allowd to alter any table '
rollback




--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################


--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################


--Get Director's Top Rated Movies
go
CREATE or ALTER PROCEDURE GetDirectorsTopRatedMovies
    @directorName NVARCHAR(100)
AS
BEGIN
    SELECT TOP 5
        M.Title,
        M.Year,
        M.Rating
    FROM
        movie AS M
    JOIN
        Director AS D ON M.DID = D.DID
    WHERE
        D.name = @directorName
    ORDER BY
        M.Rating DESC;
END;
go
GetDirectorsTopRatedMovies 'Christopher Nolan'


go
--Get Movies by Actor
CREATE or ALTER PROCEDURE GetMoviesByActor
    @actorName NVARCHAR(100)
AS
BEGIN
    SELECT
        M.Title,
        M.Year
    FROM
        movie AS M
    JOIN
        [Actor-movie] AS AM ON M.MID = AM.MID
    JOIN
        Actor AS A ON AM.AID = A.AID
    WHERE
        A.name = @actorName;
END;

go
GetMoviesByActor 'Chris Evans'


--Get Average Ratings by Genre
go
CREATE or ALTER PROCEDURE GetAverageRatingsByGenre
AS
BEGIN
    SELECT
        G.Genre AS Genre,
        round(AVG(M.Rating),2) AS AverageRating
    FROM
        Genre AS G
    JOIN
        [dbo].[Movie-Genre] AS GM ON G.GID = GM.GID
    JOIN
        movie AS M ON GM.MID = M.MID 
    GROUP BY
        G.Genre

	order BY
		AverageRating
END;
go

GetAverageRatingsByGenre 



--Update Movie Revenue
go
CREATE or ALTER PROCEDURE UpdateMovieRevenue
    @movieID INT,
    @newRevenue MONEY
AS
BEGIN
    UPDATE movie
    SET Revenue_Millions = @newRevenue
    WHERE MID = @movieID;
END;

go
UpdateMovieRevenue 3, 200

select Movie.Revenue_Millions
from Movie
where Movie.MID = 3




--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################


--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################


---------------- Cursors -------------------
-- Cursor for selecting movies with Sci-Fi genre
declare c1 cursor
for
	select m.Title, g.Genre
	from Movie m, Genre g, [Movie-Genre] mg
	where m.MID = mg.MID and g.GID = mg.GID and g.Genre = 'Sci-Fi'
for read only
declare @title nvarchar(100), @genre nvarchar(50)
open c1
fetch c1 into @title, @genre
while @@FETCH_STATUS = 0
	begin
		select @title Movie_title, @genre Movie_genre
		fetch c1 into @title, @genre
	end
close c1
deallocate c1
go

------------------------- Cursor for updating rating values-------------------------------------------------------------
declare c3 cursor
for
	select e.Rating
	from Evaluation e
for update
declare @rating float
open c3
fetch c3 into @rating
while @@FETCH_STATUS = 0
	begin
		 UPDATE Evaluation
		 SET Rating = ROUND(Rating, 2)
		 WHERE CURRENT OF c3
		 fetch c3 into @rating
	end
close c3
deallocate c3

select * from Evaluation
select rating from Movie

--------------------------------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------------------------------


declare c4 cursor
for
	select m.Rating
	from Movie m
for update
declare @ratingm float
open c4
fetch c4 into @ratingm
while @@FETCH_STATUS = 0
	begin
		 UPDATE Movie
		 SET Rating = ROUND(Rating, 2)
		 WHERE CURRENT OF c4
		 fetch c4 into @ratingm
	end
close c4
deallocate c4

select rating from movie

--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################
--###############################################################################
go
create or alter function get_per(@x float)
returns float
  begin 
    declare @sum float, @total float, @per float
	select @sum = count(*) from Movie m where m.Rating >= @x
	select @total = count(rating) from Movie
	select @per = (@sum/@total)*100
	return round(@per,2) 
  end
  go
SELECT dbo.get_per(8)







