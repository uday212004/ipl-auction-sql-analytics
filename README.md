# ipl-auction-sql-analytics
Advanced MySQL analytics project focused on IPL auction spending, player performance evaluation, team efficiency, KPI reporting, window functions, CTEs, ranking analysis, and business intelligence insights using IPL Auction and Performance datasets.


IPL Auction Business Intelligence & Advanced SQL Analytics
-- Project Overview

This project focuses on transforming IPL Auction and Player Performance data into actionable business insights using MySQL. The objective is to analyze franchise spending patterns, player performance, team efficiency, and auction investment strategies through advanced SQL analytics.

The project demonstrates database design, data modeling, complex SQL querying, KPI generation, and business intelligence reporting.

-- Business Problem

IPL franchises spend millions of rupees every year during player auctions. However, an important question remains:

Do teams actually receive value from their auction investments?

This project helps answer:

Which teams spend the most?
Which roles attract the highest investments?
Which players justify their auction price?
How efficiently do teams allocate their budgets?
What performance trends can be observed across seasons?
-- Datasets Used
Auction Dataset

Contains:

Player Name
Sold Price
Team Name
Role
Nationality
Auction Year
Base Price
Capped Status
Player Performance Dataset

Contains:

Runs Scored
Strike Rate
Fours & Sixes
Wickets Taken
Overs Bowled
Economy Rate
Matches Played
Performance Score
--  Database Design
Tables
auction

Stores player auction information.

player_performance

Stores batting and bowling performance metrics.

Future Table (Planned)
auction_roi

Will combine auction spending and player performance to evaluate return on investment (ROI).

--  SQL Analytics Performed
Auction Analytics
Most Expensive Players
Team-wise Spending Analysis
Role-wise Spending Analysis
Nationality-wise Spending
Capped vs Uncapped Spending
Year-wise Auction Trends
Performance Analytics
Top Run Scorers
Top Wicket Takers
Best Strike Rates
Best Economy Rates
All-Rounder Rankings
Performance Score Rankings
Advanced SQL Concepts
Joins
Aggregate Functions
Subqueries
Common Table Expressions (CTEs)
Window Functions
RANK()
DENSE_RANK()
ROW_NUMBER()
Running Totals
Team Ranking Analysis
-- Key Business Insights
Certain franchises consistently dominate auction spending.
All-Rounders command the highest average auction prices.
Overseas players often receive premium bids.
Some players deliver exceptional performance despite lower auction prices.
Team spending does not always guarantee superior player performance.
🛠️ Technologies Used
MySQL 8.0
SQL
Python
Pandas
Jupyter Notebook


README.md
-- Future Scope
Auction ROI Analysis
Player Value-for-Money Ranking
Overpriced vs Underpriced Player Analysis
Team Spending Efficiency Score
Power BI Dashboard Development
Predictive Auction Price Modeling
-- Author
Uday Deshmukh

LinkedIN : https://www.linkedin.com/in/deshmukh-ud/

Business Intelligence & Sports Analytics project focused on SQL, Database Design, KPI Development, and Decision-Making Insights using IPL Auction Data.
