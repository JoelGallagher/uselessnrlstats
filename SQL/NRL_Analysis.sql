
-- select top 10 * from match_data
----------------------------------
-- vwMatches
----------------------------------
CREATE OR ALTER VIEW dbo.vwMatches as
select 
date as MatchDate, Round, YEAR(date) AS Season,
 home_team as HomeTeam, away_team as AwayTeam, home_team_score as HomeTeamScore, away_team_score as AwayTeamScore,
iif(home_team_score = away_team_score,1,0) AS IsDraw,
iif(home_team_score > away_team_score, home_team, iif(home_team_score = away_team_score, '', away_team)) as Winner,
iif(home_team_score > away_team_score, away_team, iif(home_team_score = away_team_score, '', home_team)) as Loser
from match_data
GO

----------------------------------
-- vwGrandFinals
----------------------------------
CREATE OR ALTER VIEW dbo.vwGrandFinals AS
SELECT * 
FROM vwMatches
WHERE round = 'Grand Final'
GO

select * from vwGrandFinals
order by matchdate desc

 -- just 2000's to dev with
-- select * from vwMatches 
-- where matchdate > '01-01-2000'
-- order by matchdate desc
 