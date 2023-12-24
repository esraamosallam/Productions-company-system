
--Get Director's Top Rated Movies

CREATE or ALTER PROCEDURE GetDirectorsTopRatedMovies
    @directorName NVARCHAR(100)
AS
BEGIN
    SELECT TOP 5
        M.Title,
        M.Year,
        E.Rating
    FROM
        movie AS M
    JOIN
        Director AS D ON M.DID = D.DID
    JOIN
        Evaluation AS E ON M.Rating = E.Rating AND M.Votes = E.Votes AND M.Metascore = E.Metascore
    WHERE
        D.name = @directorName
    ORDER BY
        E.Rating DESC;
END;

GetDirectorsTopRatedMovies 'Chris Evans'



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
        [dbo].[Movie-Actor] AS AM ON M.MID = AM.MID
    JOIN
        Actor AS A ON AM.AWID = A.AID
    WHERE
        A.name = @actorName;
END;

GetMoviesByActor 'Will smith'


--Get Average Ratings by Genre
CREATE or ALTER PROCEDURE GetAverageRatingsByGenre
AS
BEGIN
    SELECT
        G.Genre AS Genre,
        AVG(E.Rating) AS AverageRating
    FROM
        Genre AS G
    JOIN
        [dbo].[Movie-Genre] AS GM ON G.GID = GM.GID
    JOIN
        movie AS M ON GM.MID = M.MID
    JOIN
        Evaluation AS E ON M.Rating = E.Rating AND M.Votes = E.Votes AND M.Metascore = E.Metascore
    GROUP BY
        G.Genre;
END;


GetAverageRatingsByGenre 



--Update Movie Revenue

CREATE or ALTER PROCEDURE UpdateMovieRevenue
    @movieID INT,
    @newRevenue MONEY
AS
BEGIN
    UPDATE movie
    SET Revenue_Millions = @newRevenue
    WHERE MID = @movieID;
END;


UpdateMovieRevenue 
