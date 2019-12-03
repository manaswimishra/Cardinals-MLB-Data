select
pitcher_id,
count(*) as 'TotalPitches',
sum(case when d.pitch_1 in ('C','F','L','M','O','R','S','T') then 1 when (d.pitch_1 = 'X' and d.event_id in ('2','18','19')) then 1 else 0 end) as 'FirstPitchStrikes',
(sum(case when d.pitch_1 in ('C','F','L','M','O','R','S','T') then 1 when (d.pitch_1 = 'X' and d.event_id in ('2','18','19')) then 1 else 0 end))/count(*) as 'FirstPitchStrikePercentage',
(sum(case when d.pitch_1 in ('C','F','L','M','O','R','S','T','X') and d.event_id in ('20','21','22','23') then 1 else 0 end))/count(*) as 'HitPercentageAfterFirstPitchStrike'
from
(select * from MLB.mlbdatatransformations 
where pitch_1 not in ('N', 'V', '') and left(game_id, 4) = '2018') d
group by pitcher_id
order by TotalPitches DESC
limit 15