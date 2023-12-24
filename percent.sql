create or alter function get_per(@x float)
returns float
  begin 
    declare @sum float, @total float, @per float
	select @sum = count(*) from Movie m where m.Rating > @x or m.Rating = @x
	select @total = count(rating) from Movie
	select @per = (@sum/@total)*100
	return round(@per,2)
  end

go
SELECT dbo.get_per(7)