

CREATE OR ALTER VIEW dbo.vwMatches as
select 
date as MatchDate, home_team as HomeTeam, away_team as AwayTeam, home_team_score as HomeTeamScore, away_team_score as AwayTeamScore,
iif(home_team_score = away_team_score,1,0) AS IsDraw
from match_data


GO
 -- just 2000's to dev with
select * from vwMatches 
where matchdate > '01-01-2000'
order by matchdate desc
 