--1 MatchData scores, need to make numeric the text fields
select distinct home_team_score from match_data ORDER by home_team_score
update match_data set home_team_score = null where home_team_score = 'NA'
update match_data set away_team_score = null where away_team_score = 'NA'
update match_data set home_team_ht_score = null where home_team_ht_score = 'NA'
update match_data set away_team_ht_score = null where away_team_ht_score = 'NA'
-- now change datatype to int, allow nulls