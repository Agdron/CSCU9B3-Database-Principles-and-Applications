CREATE TABLE tableASNF
(
	ID INT,
	`Player Name` VARCHAR(50),
	`Date of Birth` DATE,
	Team VARCHAR(20),
	Status VARCHAR(20),
	Skill VARCHAR(50),
	Name VARCHAR(20),
	Town VARCHAR(50),
	Postcode VARCHAR(15),
	`Venue Name` VARCHAR(50),
	`Venue Room` VARCHAR(6),
	`Date` DATE,
	Points INT,
);
-------------------------------------------------------------------------------------
--Create the three extra tables which the data will be separated into

CREATE TABLE Team
(
	Name VARCHAR(20),
	Town VARCHAR(50),
	Postcode VARCHAR(15),
	PRIMARY KEY (Name)
);

--DATA INSERTION

INSERT INTO Team
SELECT DISTINCT Name, Town, Postcode
FROM tableASNF;
-------------------------------------------------------------------------------------
CREATE TABLE Player
(
	`Player ID` INT,
	`Player Name` VARCHAR(50),
	`Date of Birth` DATE,
	Team VARCHAR(20),
	Status VARCHAR(20),
	PRIMARY KEY (`Player ID`)
);

--Table Alter Query for Player table

ALTER TABLE Player
ADD FOREIGN KEY (Team)
REFERENCES Team(Name);

--DATA INSERTION

INSERT INTO Player
SELECT DISTINCT ID, `Player Name`, `Date of Birth`, Team, Status
FROM tableASNF;
-------------------------------------------------------------------------------------

--Game Table, this is annoying, but it's a way of doing it

CREATE TABLE Game
(
	Date DATE,
	`Player ID` INT,
	`Venue Name` VARCHAR(50),
	Room VARCHAR(6),
	Points INT,
	PRIMARY KEY (Date, `Player ID`)
);

ALTER TABLE Game
ADD FOREIGN KEY (`Player ID`)
REFERENCES Player(`Player ID`);


--DATA INSERTION
INSERT INTO Game
SELECT DISTINCT `Date`, ID, `Venue Name`, `Venue Room`, Points
FROM tableASNF;
-------------------------------------------------------------------------------------
CREATE TABLE Games
(
	Date DATE,
	`Player ID` INT,
	`Venue Name` VARCHAR(50),
	Room VARCHAR(6),
	Points INT,
	Team VARCHAR(20),
	PRIMARY KEY (Date, `Player ID`)
);

--Adding Foreign Keys

ALTER TABLE Games
ADD FOREIGN KEY (`Player ID`)
REFERENCES Player(`Player ID`);

ALTER TABLE Games
ADD FOREIGN KEY (Team)
REFERENCES Team(Name);

--DATA INSERTION
INSERT INTO Games
SELECT DISTINCT `Date`, ID, `Venue Name`, `Venue Room`, Points, Team
FROM tableASNF;
-------------------------------------------------------------------------------------


CREATE TABLE Skill
(
	`Player ID` INT,
	Skill VARCHAR(50),
	PRIMARY KEY (`Player ID`, Skill)
);

--Add Foreign Keys

ALTER TABLE Skill
ADD FOREIGN KEY (`Player ID`)
REFERENCES Player(`Player ID`);

--DATA INSERTION

INSERT INTO Skill
SELECT DISTINCT ID, Skill
FROM tableASNF;



-------------------------------------------------------------------------------------
--Searches 

--SEARCH 1--

SELECT `Player Name`, `Date of Birth`
FROM Player
WHERE `Date of Birth` > '1990-01-01'

--SEARCH 2--

SELECT Team, COUNT(DISTINCT Team, `Date`) AS DaysPlayed 
FROM Games 
GROUP BY Team

--SEARCH 3--
--List Team Name, Location and Total Number of Games and Points

SELECT Team, Town, COUNT(DISTINCT Team, `Date`) AS GamesPlayed, SUM(Points) AS TotalPoints 
FROM Games, team 
WHERE team.Name=games.Team 
GROUP BY Team

-------------------------------------------------------------------

SELECT DISTINCT Player.`Player ID`, `Player Name`, `Date of Birth`, Team, Status, skill.Skill 
FROM player, skill 
WHERE `Player Name` LIKE '%".$name."%' AND Player.`Player ID`=Skill.`Player ID` 
ORDER BY `Player ID` ASC;




------------------------
COUNT(DISTINCT `Player ID`, UniqueRoom)=COUNT(DISTINCT `Player ID` WHERE Team <>"Rockets" OR Team <>"Sharks") AND