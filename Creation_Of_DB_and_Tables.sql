create database proj;
use proj;

CREATE TABLE user (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    SubscriptionType ENUM('Free', 'Basic', 'Premium') NOT NULL,
    SubscriptionEndDate DATE
);
CREATE TABLE Playlist (
    PlaylistID INT AUTO_INCREMENT PRIMARY KEY,
    PlaylistName VARCHAR(255) NOT NULL,
    CreationDate DATE,
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);
CREATE TABLE Artist (
    ArtistID INT AUTO_INCREMENT PRIMARY KEY,
    ArtistName VARCHAR(255) NOT NULL,
    Biography TEXT
);
CREATE TABLE Album (
    AlbumID INT AUTO_INCREMENT PRIMARY KEY,
    AlbumTitle VARCHAR(255) NOT NULL,
    ReleaseDate DATE,
    ArtistID INT,
    FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID)
);
CREATE TABLE Genre (
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    GenreName VARCHAR(255) NOT NULL
);
CREATE TABLE Song (
    SongID INT AUTO_INCREMENT PRIMARY KEY,
    SongTitle VARCHAR(255) NOT NULL,
    Duration TIME,
    ReleaseDate DATE,
    ArtistID INT,
    AlbumID INT,
    GenreID INT,
    FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID),
    FOREIGN KEY (AlbumID) REFERENCES Album(AlbumID),
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID)
);

CREATE TABLE PlaylistSong (
    PlaylistID INT,
    SongID INT,
    FOREIGN KEY (PlaylistID) REFERENCES Playlist(PlaylistID),
    FOREIGN KEY (SongID) REFERENCES Song(SongID),
    PRIMARY KEY (PlaylistID, SongID)
);

CREATE TABLE SubscriptionPlan (
    PlanID INT PRIMARY KEY,
    PlanName VARCHAR(50),
    MonthlyPrice DECIMAL(10, 2),
    Features TEXT
);

-- Payment table
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    UserID INT,
    Amount DECIMAL(10, 2),
    PaymentDate DATE,
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

CREATE TABLE Device (
    DeviceID INT PRIMARY KEY,
    UserID INT,
    DeviceName VARCHAR(50),
    DeviceType VARCHAR(50),
    LastAccessed TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);

-- Artist Genre table (Association Entity)
CREATE TABLE ArtistGenre (
    ArtistID INT,
    GenreID INT,
    FOREIGN KEY (ArtistID) REFERENCES Artist(ArtistID),
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID),
    PRIMARY KEY (ArtistID, GenreID)
);


CREATE TABLE UserHistory (
    HistoryID INT PRIMARY KEY,
    UserID INT,
    SongID INT,
    Timestamp TIMESTAMP,
    Action VARCHAR(20),
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (SongID) REFERENCES Song(SongID)
);

CREATE TABLE Advertisement (
    AdID INT PRIMARY KEY,
    Advertiser VARCHAR(100),
    AdType VARCHAR(50),
    Duration INT,
    Clicks INT,
    Impressions INT
);


CREATE TABLE OfflineDownloads (
    DownloadID INT PRIMARY KEY,
    UserID INT,
    SongID INT,
    DownloadDate DATE,
    DeviceID INT,
    FOREIGN KEY (UserID) REFERENCES User(UserID),
    FOREIGN KEY (SongID) REFERENCES Song(SongID),
    FOREIGN KEY (DeviceID) REFERENCES Device(DeviceID)
);


CREATE TABLE TextLanguage (
    LanguageID INT PRIMARY KEY,
    LanguageName VARCHAR(50)
);

CREATE TABLE SongLanguage (
    SongID INT,
    LanguageID INT,
    PRIMARY KEY (SongID, LanguageID),
    FOREIGN KEY (SongID) REFERENCES Song(SongID),
    FOREIGN KEY (LanguageID) REFERENCES TextLanguage(LanguageID)
);
