
-- select top 10 * from match_data
----------------------------------
-- vwMatches
----------------------------------
CREATE OR ALTER VIEW dbo.vwMatches as
select 
m.match_id as MatchID, m.date as MatchDate, m.Round, YEAR(m.date) AS Season,
m.home_team as HomeTeam, m.home_team_score as HomeTeamScore, 
m.away_team as AwayTeam, m.away_team_score as AwayTeamScore,
iif(m.home_team_score = m.away_team_score,1,0) AS IsDraw,
iif(m.home_team_score > m.away_team_score, m.home_team, iif(m.home_team_score = m.away_team_score, '', m.away_team)) as Winner,
iif(m.home_team_score > m.away_team_score, m.away_team, iif(m.home_team_score = m.away_team_score, '', m.home_team)) as Loser,
r.full_name as RefName
from match_data m
    left outer join ref_match_data rm
        on m.match_id = rm.match_id
    left outer join ref_data r
        on r.ref_id = rm.ref_id
GO

----------------------------------
-- vwGrandFinals
----------------------------------
CREATE OR ALTER VIEW dbo.vwGrandFinals AS
SELECT * 
FROM vwMatches
WHERE round = 'Grand Final'
GO

select distinct * from vwMatches

select * from vwGrandFinals
order by matchdate desc



--select * from ref_data

 -- just 2000's to dev with
-- select * from vwMatches 
-- where matchdate > '01-01-2000'
-- order by matchdate desc
 
 -- are the team names ok? just warriors , or NZ Warriors elsewhere
 /*
 select distinct home_team from match_data
 UNION
 select DISTINCT away_team from match_data
 order by home_team
*/
