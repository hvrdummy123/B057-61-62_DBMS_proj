
-- Finding the least popular genre based on the total number of songs within each genre:
SELECT g.GenreName, COUNT(s.SongID) AS TotalSongs
FROM Genre g
LEFT JOIN Song s ON g.GenreID = s.GenreID
GROUP BY g.GenreID
ORDER BY TotalSongs ASC
LIMIT 1;

	

	-- Calculating the average duration of songs in each playlist:
SELECT p.PlaylistName, SEC_TO_TIME(AVG(TIME_TO_SEC(s.Duration))) AS AvgDuration
FROM Playlist p
JOIN PlaylistSong ps ON p.PlaylistID = ps.PlaylistID
JOIN Song s ON ps.SongID = s.SongID
GROUP BY p.PlaylistID;



-- Listing the top 5 most downloaded songs offline:
SELECT s.SongTitle, COUNT(od.DownloadID) AS TotalDownloads
FROM Song s
JOIN OfflineDownloads od ON s.SongID = od.SongID
GROUP BY s.SongID
ORDER BY TotalDownloads DESC
LIMIT 5;

	

 	-- Identifying the most active day of the week for song plays:
SELECT DAYNAME(Timestamp) AS DayOfWeek, COUNT(HistoryID) AS TotalPlays
FROM UserHistory
WHERE Action = 'Played'
GROUP BY DayOfWeek
ORDER BY TotalPlays DESC
LIMIT 1;
	


 -- Get the average duration of songs in each genre, but only for genres with more than 10 songs and only include songs released before 2019:

SELECT g.GenreName, AVG(TIME_TO_SEC(s.Duration)) AS AvgDurationInSeconds
FROM Genre g
JOIN Song s ON g.GenreID = s.GenreID
WHERE s.ReleaseDate < '2019-01-01'
GROUP BY g.GenreID, g.GenreName
HAVING COUNT(s.SongID) > 10;


	
-- Identifying playlists that contain songs from only one genre:
SELECT p.PlaylistID, p.PlaylistName
FROM Playlist p
JOIN PlaylistSong ps ON p.PlaylistID = ps.PlaylistID
JOIN Song s ON ps.SongID = s.SongID
JOIN Genre g ON s.GenreID = g.GenreID
GROUP BY p.PlaylistID, p.PlaylistName
HAVING COUNT(DISTINCT g.GenreID) = 1;



-- Calculating total clicks and impressions for each advertiser in advertisements:
SELECT Advertiser, SUM(Clicks) AS TotalClicks, SUM(Impressions) AS TotalImpressions
FROM Advertisement
GROUP BY Advertiser;



-- Retrieving all songs with their associated languages:
SELECT s.SongID, s.SongTitle, GROUP_CONCAT(tl.LanguageName SEPARATOR ', ') AS Languages
FROM Song s
LEFT JOIN SongLanguage sl ON s.SongID = sl.SongID
LEFT JOIN TextLanguage tl ON sl.LanguageID = tl.LanguageID
GROUP BY s.SongID, s.SongTitle;



-- Updating a user's subscription end date after making a payment:
UPDATE User
SET SubscriptionEndDate = DATE_ADD(SubscriptionEndDate, INTERVAL 1 MONTH)
WHERE UserID = 1;

INSERT INTO Payment (paymentId ,UserID, Amount, PaymentDate, PaymentMethod)
VALUES (11, 1, 9.99, CURDATE(), 'Credit Card');

select * from payment;

	

-- Inserting a new user, creating a playlist for that user, and adding songs to the playlist:
START TRANSACTION;

INSERT INTO User (Username, Email, Password, SubscriptionType, SubscriptionEndDate)
VALUES ('JohnDoe', 'john.doe@example.com', 'password123', 'Premium', '2025-03-18');

SET @UserID = LAST_INSERT_ID();

INSERT INTO Playlist (PlaylistName, CreationDate, UserID)
VALUES ('My Favorites', CURDATE(), @UserID);

SET @PlaylistID = LAST_INSERT_ID();

INSERT INTO PlaylistSong (PlaylistID, SongID)
SELECT @PlaylistID, SongID
FROM Song
WHERE ArtistID = (
    SELECT MIN(ArtistID) FROM Artist WHERE ArtistName = 'Ed Sheeran'
);

COMMIT;



-- Find the top 5 most listened to songs along with the corresponding artist and genre, but only include songs released after 2018

SELECT s.SongTitle, a.ArtistName, g.GenreName, ListenCount
FROM (
    SELECT SongID, COUNT(*) AS ListenCount
    FROM UserHistory
    WHERE Action = 'played'
    AND SongID IN (
        SELECT SongID FROM Song WHERE ReleaseDate > '2017-01-01'
    )
    GROUP BY SongID
    ORDER BY ListenCount DESC
    LIMIT 5
) AS TopSongs
JOIN Song s ON TopSongs.SongID = s.SongID
JOIN Artist a ON s.ArtistID = a.ArtistID
JOIN Genre g ON s.GenreID = g.GenreID;





-- Finding the most popular genre based on the total number of songs within each genre:
SELECT g.GenreName, COUNT(s.SongID) AS TotalSongs
FROM Genre g
LEFT JOIN Song s ON g.GenreID = s.GenreID
GROUP BY g.GenreID
ORDER BY TotalSongs DESC
LIMIT 1;




-- Counting the number of distinct artists for first 10 user's playlist:
SELECT p.UserID, p.PlaylistID, COUNT(DISTINCT a.ArtistID) AS UniqueArtists
FROM Playlist p
JOIN PlaylistSong ps ON p.PlaylistID = ps.PlaylistID
JOIN Song s ON ps.SongID = s.SongID
JOIN Artist a ON s.ArtistID = a.ArtistID
WHERE p.userid <=10
GROUP BY p.UserID, p.PlaylistID;



-- Identifying the top 3 users who have downloaded the most songs offline:
SELECT u.UserID, u.Username, COUNT(od.DownloadID) AS TotalDownloads
FROM User u
JOIN OfflineDownloads od ON u.UserID = od.UserID
GROUP BY u.UserID, u.Username
ORDER BY TotalDownloads DESC
LIMIT 3;


-- Identifying the most active users based on the total number of songs they have listened to:
SELECT uh.UserID, u.Username, COUNT(uh.SongID) AS TotalListened
FROM UserHistory uh
JOIN User u ON uh.UserID = u.UserID
GROUP BY uh.UserID
ORDER BY TotalListened DESC;

	



-- Identifying the top 3 devices with most downloaded songs offline:
SELECT d.DeviceType, COUNT(od.DownloadID) AS TotalDownloads
FROM Device d
LEFT JOIN OfflineDownloads od ON d.DeviceID = od.DeviceID
GROUP BY d.DeviceType
LIMIT 3;



-- Identifying playlists that have been created but do not contain any songs:
-- can be used to delete redundant playlists

SELECT p.PlaylistID, p.PlaylistName
FROM Playlist p
LEFT JOIN PlaylistSong ps ON p.PlaylistID = ps.PlaylistID
WHERE ps.PlaylistID IS NULL;

	



-- This query finds the language most frequently associated with songs in each genre.
SELECT g.GenreName, tl.LanguageName, COUNT(sl.SongID) AS NumSongs
FROM Genre g
JOIN SongGenre sg ON g.GenreID = sg.GenreID
JOIN SongLanguage sl ON sg.SongID = sl.SongID
JOIN TextLanguage tl ON sl.LanguageID = tl.LanguageID
GROUP BY g.GenreName, tl.LanguageName
HAVING COUNT(sl.SongID) = (
    SELECT MAX(SubCount)
    FROM (
        SELECT COUNT(sl.SongID) AS SubCount
        FROM Genre g
        JOIN SongGenre sg ON g.GenreID = sg.GenreID
        JOIN SongLanguage sl ON sg.SongID = sl.SongID
        JOIN TextLanguage tl ON sl.LanguageID = tl.LanguageID
        GROUP BY g.GenreName, tl.LanguageName
    ) AS SubQuery
    WHERE g.GenreID = Genre.GenreID
);


	
-- This query calculates the average number of songs added to playlists each day.
SELECT AVG(SongsAdded) AS AvgSongsPerDay
FROM (
    SELECT COUNT(ps.SongID) AS SongsAdded, DATE(p.CreationDate) AS PlaylistDate
    FROM Playlist p
    JOIN PlaylistSong ps ON p.PlaylistID = ps.PlaylistID
    GROUP BY PlaylistDate
) AS DailySongsAdded;

	
-- Calculate average song duration and total songs per artist
SELECT a.ArtistName, 
       COUNT(s.SongID) AS TotalSongs, 
       SEC_TO_TIME(AVG(TIME_TO_SEC(s.Duration))) AS AvgDuration
FROM Artist a
JOIN Song s ON a.ArtistID = s.ArtistID
GROUP BY a.ArtistID;

	



-- This query calculates the average duration of songs in playlists created by users with basic subscriptions.
SELECT p.PlaylistID, AVG(s.Duration) AS AvgDuration
FROM Playlist p
JOIN PlaylistSong ps ON p.PlaylistID = ps.PlaylistID
JOIN Song s ON ps.SongID = s.SongID
JOIN User u ON p.UserID = u.UserID
WHERE u.SubscriptionType = 'Basic'
GROUP BY p.PlaylistID;

	

-- This query finds the most active genre for each user based on the number of plays.
SELECT u.UserID, g.GenreName, COUNT(*) AS PlayCount
FROM User u
JOIN UserHistory uh ON u.UserID = uh.UserID
JOIN Song s ON uh.SongID = s.SongID
JOIN Genre g ON s.GenreID = g.GenreID
GROUP BY u.UserID, g.GenreName
ORDER BY PlayCount DESC;



-- This query calculates the average number of songs added to playlists per user.
SELECT UserID, AVG(PlaylistCount) AS AvgPlaylistSize
FROM (
    SELECT UserID, COUNT(PlaylistID) AS PlaylistCount
    FROM Playlist
    GROUP BY UserID
) AS SubQuery
GROUP BY UserID;



-- This query finds the most active genre for each user based on the number of plays.
SELECT u.UserID, g.GenreName, COUNT(*) AS PlayCount
FROM User u
JOIN UserHistory uh ON u.UserID = uh.UserID
JOIN Song s ON uh.SongID = s.SongID
JOIN Genre g ON s.GenreID = g.GenreID
GROUP BY u.UserID, g.GenreName
ORDER BY PlayCount DESC;
