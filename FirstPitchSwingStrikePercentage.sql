SELECT
	d.batter_id as `Player`,
    (d.Single + d.Double + d.Triple + d.HomeRun) / (d.AtBat - d.SacFly - d.SacHit) AS `BA`,
    (d.TotalBases) / (d.AtBat - d.SacFly - d.SacHit) AS `Slugging`,
    (d.Single + d.Double + d.Triple + d.HomeRun + d.Walk + d.IntentionalWalk + d.HitByPitch) / (d.AtBat - d.SacFly - d.SacHit + d.Walk + d.IntentionalWalk + d.HitByPitch) + (1 * d.Single + 2 * d.Double + 3 * d.Triple + 4 * d.HomeRun) / (d.AtBat - d.SacFly - d.SacHit) AS `OPS`,
    d.FirstPitchSwingStrikePercentage
FROM
    (SELECT 
        BATTER_ID,
            SUM(CASE
                WHEN EVENT_ID NOT IN ('14' , '15', '16', '17') THEN 1
                ELSE 0
            END) AS `AtBat`,
            SUM(CASE
                WHEN EVENT_ID IN ('20' , '21', '22', '23', '3', '5', '15', '18', '14') THEN 1
                ELSE 0
            END) AS `PlateAppearance`,
            SUM(CASE
                WHEN EVENT_ID = '14' THEN 1
                ELSE 0
            END) AS `Walk`,
            SUM(CASE
                WHEN EVENT_ID = '15' THEN 1
                ELSE 0
            END) AS `IntentionalWalk`,
            SUM(CASE
                WHEN EVENT_ID = '16' THEN 1
                ELSE 0
            END) AS `HitByPitch`,
            SUM(CASE
                WHEN sacrifice_fly_fl = 'T' THEN 1
                ELSE 0
            END) AS `SacFly`,
            SUM(CASE
                WHEN sacrifice_hit_fl = 'T' THEN 1
                ELSE 0
            END) AS `SacHit`,
            SUM(CASE
                WHEN EVENT_ID = '20' THEN 1
                ELSE 0
            END) AS `Single`,
            SUM(CASE
                WHEN EVENT_ID = '21' THEN 1
                ELSE 0
            END) AS `Double`,
            SUM(CASE
                WHEN EVENT_ID = '22' THEN 1
                ELSE 0
            END) AS `Triple`,
            SUM(CASE
                WHEN EVENT_ID = '23' THEN 1
                ELSE 0
            END) AS `HomeRun`,
            SUM(CASE
                WHEN EVENT_ID = '20' THEN 1
                WHEN EVENT_ID = '21' THEN 2
                WHEN EVENT_ID = '22' THEN 3
                WHEN EVENT_ID = '23' THEN 4
                ELSE 0
            END) AS `TotalBases`,
            SUM(CASE
                WHEN pitch_1 IN ('F', 'B') THEN 1
                ELSE 0
            END) / (COUNT(pitch_1)) AS `FirstPitchSwingStrikePercentage`
    FROM
        MLB.mlbdatatransformations
    WHERE
        LEFT(GAME_ID, 4) = '2018'
    GROUP BY BATTER_ID
    ORDER BY HomeRun DESC) AS d
    ORDER BY d.AtBat DESC