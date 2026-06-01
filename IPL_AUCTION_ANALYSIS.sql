-- Phase 1: Create Database

CREATE DATABASE ipl_auction_analytics;

USE ipl_auction_analytics;

-- Phase 2: Create Auction Table

CREATE TABLE auction (
    PlayerName VARCHAR(150),
    SoldPrice BIGINT,
    Role VARCHAR(50),
    TeamName VARCHAR(100),
    Nationality VARCHAR(50),
    BasePrice BIGINT,
    CappedStatus VARCHAR(50),
    AuctionYear INT
);


-- Phase 3: Create Performance Table

CREATE TABLE player_performance (
    PlayerName VARCHAR(150),
    Runs FLOAT,
    BallsFaced FLOAT,
    Fours FLOAT,
    Sixes FLOAT,
    StrikeRate FLOAT,
    Wickets FLOAT,
    Economy FLOAT,
    Overs FLOAT,
    Matches_Batting FLOAT,
    Matches_Bowling FLOAT,
    PerformanceScore FLOAT
);


SHOW VARIABLES LIKE "secure_file_priv";

-- Phase 4: Import Data Files

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/auction_cleaned.csv'
INTO TABLE auction
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


DROP TABLE auction;

CREATE TABLE auction (
    PlayerName VARCHAR(150),
    SoldPrice BIGINT,
    Role VARCHAR(50),
    TeamName VARCHAR(100),
    Nationality VARCHAR(50),
    BasePrice BIGINT NULL,
    CappedStatus VARCHAR(50),
    AuctionYear INT
);





-- Phase 4: Import Data Files

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/auction_cleaned.csv'
INTO TABLE auction
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
PlayerName,
SoldPrice,
Role,
TeamName,
Nationality,
@BasePrice,
CappedStatus,
AuctionYear
)
SET BasePrice = NULLIF(@BasePrice,'');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/player_performance.csv'
INTO TABLE player_performance
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Phase 5: Data Validation Queries

SELECT COUNT(*) FROM auction;
SELECT COUNT(*) FROM player_performance;
SELECT * FROM auction LIMIT 5;
SELECT * FROM player_performance LIMIT 5;

-- Phase 6: Business SQL Analytics

-- Top 10 Most Expensive Players
SELECT PlayerName,
       TeamName,
       SoldPrice
FROM auction
ORDER BY SoldPrice DESC
LIMIT 10;

-- Total Auction Spending
SELECT SUM(SoldPrice) AS TotalSpending
FROM auction;

-- Role-wise Spending
SELECT Role,
       SUM(SoldPrice) AS Spending
FROM auction
GROUP BY Role
ORDER BY Spending DESC;

-- Nationality-wise Spending
SELECT Nationality,
       SUM(SoldPrice) AS Spending
FROM auction
GROUP BY Nationality;

-- LEVEL 2: Performance Analytics

-- Top Run Scorers
SELECT PlayerName,
       Runs
FROM player_performance
ORDER BY Runs DESC
LIMIT 10;

-- Top Wicket Takers
SELECT PlayerName,
       Wickets
FROM player_performance
ORDER BY Wickets DESC
LIMIT 10;

-- Best Strike Rate
SELECT PlayerName,
       StrikeRate
FROM player_performance
WHERE Runs >= 1000
ORDER BY StrikeRate DESC;

-- Best Economy Bowlers  NOT SHOWING ANYTHING
SELECT PlayerName,
       Economy
FROM player_performance
WHERE Overs >= 200
ORDER BY Economy;


-- LEVEL 3: Intermediate SQL

-- Average Auction Price by Role
SELECT Role,
       ROUND(AVG(SoldPrice),0) AS AvgPrice
FROM auction
GROUP BY Role
ORDER BY AvgPrice DESC;

-- Most Expensive Player per Year
SELECT AuctionYear,
       PlayerName,
       SoldPrice
FROM auction a
WHERE SoldPrice =
(
SELECT MAX(SoldPrice)
FROM auction b
WHERE a.AuctionYear=b.AuctionYear
);

-- Team Buying Trends
SELECT AuctionYear,
       TeamName,
       SUM(SoldPrice) AS Spending
FROM auction
GROUP BY AuctionYear, TeamName
ORDER BY AuctionYear;


-- LEVEL 4: Window Functions


-- Team Spending Ranking
SELECT TeamName,
       SUM(SoldPrice) AS Spending,
       RANK() OVER(
       ORDER BY SUM(SoldPrice) DESC
       ) AS TeamRank
FROM auction
GROUP BY TeamName;


-- Dense Rank for Players
SELECT PlayerName,
       Runs,
       DENSE_RANK() OVER(
       ORDER BY Runs DESC
       ) AS RunRank
FROM player_performance;



-- LEVEL 5: CTE Analytics

-- Top Spending Teams
WITH TeamSpending AS
(
SELECT TeamName,
       SUM(SoldPrice) AS Spending
FROM auction
GROUP BY TeamName
)

SELECT *
FROM TeamSpending
ORDER BY Spending DESC;


-- LEVEL 6: Join Analytics

-- Highest Paid Players Who Also Performed Well
SELECT
a.PlayerName,
a.SoldPrice,
p.Runs,
p.Wickets,
p.PerformanceScore

FROM auction a
INNER JOIN player_performance p
ON a.PlayerName = p.PlayerName

ORDER BY p.PerformanceScore DESC;

-- ADVANCED AUCTION ANALYTICS

-- Top 5 Most Expensive Players Bought By Each Team
WITH RankedPlayers AS (
    SELECT TeamName,
           PlayerName,
           SoldPrice,
           ROW_NUMBER() OVER(
               PARTITION BY TeamName
               ORDER BY SoldPrice DESC
           ) AS rn
    FROM auction
)

SELECT *
FROM RankedPlayers
WHERE rn <= 5;

-- Insight :Which players each franchise invested in the most.

-- 2. Which Team Spent The Most Per Auction Year?
WITH TeamSpend AS (
    SELECT AuctionYear,
           TeamName,
           SUM(SoldPrice) AS Spending,
           RANK() OVER(
               PARTITION BY AuctionYear
               ORDER BY SUM(SoldPrice) DESC
           ) AS rnk
    FROM auction
    GROUP BY AuctionYear, TeamName
)

SELECT *
FROM TeamSpend
WHERE rnk = 1;

-- 3. Highest Average Spending Per Player
SELECT TeamName,
       ROUND(AVG(SoldPrice),0) AS AvgPlayerPrice
FROM auction
GROUP BY TeamName
ORDER BY AvgPlayerPrice DESC;


-- 4. Teams Investing Most In Overseas Players
SELECT TeamName,
       SUM(SoldPrice) AS OverseasSpending
FROM auction
WHERE Nationality='Overseas'
GROUP BY TeamName
ORDER BY OverseasSpending DESC;

-- 5. Teams Investing Most In Indian Players
SELECT TeamName,
       SUM(SoldPrice) AS IndianSpending
FROM auction
WHERE Nationality='Indian'
GROUP BY TeamName
ORDER BY IndianSpending DESC;

-- ADVANCED PERFORMANCE ANALYTICS

-- 6. Batters With Highest Runs Per Match
SELECT PlayerName,
       Runs,
       Matches_Batting,
       ROUND(Runs/Matches_Batting,2) AS RunsPerMatch
FROM player_performance
WHERE Matches_Batting >= 20
ORDER BY RunsPerMatch DESC;

-- 7.. Bowlers With Highest Wickets Per Match
SELECT PlayerName,
       Wickets,
       Matches_Bowling,
       ROUND(Wickets/Matches_Bowling,2) AS WicketsPerMatch
FROM player_performance
WHERE Matches_Bowling >= 20
ORDER BY WicketsPerMatch DESC;

-- 8. Boundary Kings
SELECT PlayerName,
       Fours,
       Sixes,
       (Fours + Sixes) AS TotalBoundaries
FROM player_performance
ORDER BY TotalBoundaries DESC
LIMIT 20;

-- 9. Most Dangerous Six Hitters
SELECT PlayerName,
       Sixes
FROM player_performance
ORDER BY Sixes DESC
LIMIT 20;

-- 10. Strike Rate Monsters
SELECT PlayerName,
       Runs,
       StrikeRate
FROM player_performance
WHERE Runs >= 1000
ORDER BY StrikeRate DESC;

-- JOIN ANALYTICS
-- 11. Most Expensive Players Who Underperformed
SELECT
a.PlayerName,
a.SoldPrice,
p.PerformanceScore

FROM auction a
JOIN player_performance p
ON a.PlayerName = p.PlayerName

ORDER BY a.SoldPrice DESC,
         p.PerformanceScore ASC;
-- Insight :Players getting huge money but low performance.

-- 12. Best Value For Money Players
SELECT
a.PlayerName,
a.SoldPrice,
p.PerformanceScore,
ROUND(
    p.PerformanceScore /
    (a.SoldPrice/1000000),
    2
) AS ROI_Score

FROM auction a
JOIN player_performance p
ON a.PlayerName=p.PlayerName

ORDER BY ROI_Score DESC;

-- 13. Team-Wise ROI
SELECT
a.TeamName,

SUM(a.SoldPrice) AS TotalSpent,

SUM(p.PerformanceScore) AS TotalPerformance,

ROUND(
SUM(p.PerformanceScore)/
SUM(a.SoldPrice)*1000000,
2
) AS TeamROI

FROM auction a
JOIN player_performance p
ON a.PlayerName=p.PlayerName

GROUP BY a.TeamName

ORDER BY TeamROI DESC;

-- 14. Which Role Gives Best ROI?
SELECT
a.Role,

AVG(a.SoldPrice) AS AvgPrice,

AVG(p.PerformanceScore) AS AvgPerformance,

ROUND(
AVG(p.PerformanceScore)/
AVG(a.SoldPrice)*1000000,
2
) AS ROI

FROM auction a
JOIN player_performance p
ON a.PlayerName=p.PlayerName

GROUP BY a.Role

ORDER BY ROI DESC;

-- 15. Top Performer In Every Team
WITH TeamRank AS
(
SELECT
a.TeamName,
p.PlayerName,
p.PerformanceScore,

ROW_NUMBER() OVER(
PARTITION BY a.TeamName
ORDER BY p.PerformanceScore DESC
) rn

FROM auction a
JOIN player_performance p
ON a.PlayerName=p.PlayerName
)

SELECT *
FROM TeamRank
WHERE rn=1;

-- 16. Team Dependence Analysis

-- Which teams depend heavily on a few stars?

SELECT
a.TeamName,

MAX(p.PerformanceScore) AS BestPlayer,

AVG(p.PerformanceScore) AS AvgTeamPerformance

FROM auction a
JOIN player_performance p
ON a.PlayerName=p.PlayerName

GROUP BY a.TeamName;


-- 17. Performance Distribution
SELECT
CASE
WHEN PerformanceScore > 3000 THEN 'Elite'
WHEN PerformanceScore > 1000 THEN 'Great'
WHEN PerformanceScore > 500 THEN 'Good'
ELSE 'Average'
END AS Category,

COUNT(*) AS Players

FROM player_performance

GROUP BY Category;


-- 18. Top Auction Bargains
SELECT
a.PlayerName,
a.TeamName,
a.SoldPrice,
p.PerformanceScore

FROM auction a
JOIN player_performance p
ON a.PlayerName=p.PlayerName

WHERE a.SoldPrice < 10000000

ORDER BY p.PerformanceScore DESC;

-- 19. Most Consistent Players
SELECT
PlayerName,
Runs,
Wickets,
Matches_Batting,
Matches_Bowling

FROM player_performance

WHERE Matches_Batting >= 100
   OR Matches_Bowling >= 100

ORDER BY PerformanceScore DESC;


-- 20. Dream Team Query
SELECT *
FROM player_performance
ORDER BY PerformanceScore DESC
LIMIT 11;