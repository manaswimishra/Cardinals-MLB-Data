select d.batter_id, 
count(*) as 'AtBatWithRunnersInScoringPosition',
sum(case when event_id in ('20','21','22','23') then 1 else 0 end) as 'HitWithRunnersInScoringPosition',
sum(case when event_id in ('20','21','22','23') then 1 else 0 end)/count(*) as 'BattingAverageWithRunnersInScoringPosition'
from 
(select * from MLB.mlbdatatransformations
where left(date, 4) = '2018'
and (base2_run_id != '' or base3_run_id != '')) d
group by d.batter_id
order by AtBatWithRunnersInScoringPosition desc