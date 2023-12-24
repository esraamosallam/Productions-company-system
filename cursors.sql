use Ninja
---------------- Cursors -------------------
-- Cursor for selecting movies with Sci-Fi genre
declare c1 cursor
for
	select m.Title, g.Genre
	from Movie m, Genre g, [Movie-Genre] mg
	where m.MID = mg.Rank and g.GID = mg.GID and g.Genre = 'Sci-Fi'
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

-- Cursor for updating rating values
-- Updating Evaluation
declare c3 cursor
for
	select e.Rating
	from Evalution e
for update
declare @rating float
open c3
fetch c3 into @rating
while @@FETCH_STATUS = 0
	begin
		 UPDATE Evalution
		 SET Rating = ROUND(Rating, 2)
		 WHERE CURRENT OF c3
		 fetch c3 into @rating
	end
close c3
deallocate c3

-- Updating Movies
select * from Evalution
select rating from Movie

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