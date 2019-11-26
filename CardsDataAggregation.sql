SELECT 
    d.batter_id,
    d.Single AS `1B`,
    d.Double AS `2B`,
    d.Triple AS `3B`,
    d.HomeRun AS `HomeRun`,
    d.RBI AS `RBI`,
    (d.Single + d.Double + d.Triple + d.HomeRun) / (d.AtBat - d.SacFly - d.SacHit) AS `BA`,
    (d.Single + d.Double + d.Triple + d.HomeRun + d.Walk + d.IntentionalWalk + d.HitByPitch) / (d.AtBat - d.SacFly - d.SacHit + d.Walk + d.IntentionalWalk + d.HitByPitch) AS `OBS`,
    (d.TotalBases) / (d.AtBat - d.SacFly - d.SacHit) AS `Slugging`,
    (d.Single + d.Double + d.Triple + d.HomeRun + d.Walk + d.IntentionalWalk + d.HitByPitch) / (d.AtBat - d.SacFly - d.SacHit + d.Walk + d.IntentionalWalk + d.HitByPitch) + (1 * d.Single + 2 * d.Double + 3 * d.Triple + 4 * d.HomeRun) / (d.AtBat - d.SacFly - d.SacHit) AS 'OPS',
    d.StrikeOut AS `StrikeOut`,
    d.TotalBases AS `TotalBases`,
    d.GroundedDoublePlay AS `GroundedDoublePlay`,
    d.HitByPitch AS `HitByPitch`,
    d.StrikeOut AS `StrikeOut`,
    d.SacFly AS `SacFly`,
    d.SacHit AS `SacHit`,
    d.FirstPitchSwingMissPercentage AS `FirstPitchSwingMissPercentage`,
    d.FirstPitchCalledStrikePercentage AS `FirstPitchCalledStrikePercentage`,
    d.FirstPitchFoulBallPercentage AS `FirstPitchFoulBallPercentage`,
    d.FirstPitchBallPercentage AS `FirstPitchBallPercentage`
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
                WHEN EVENT_ID = '3' THEN 1
                ELSE 0
            END) AS `StrikeOut`,
            SUM(CASE
                WHEN sacrifice_fly_fl = 'T' THEN 1
                ELSE 0
            END) AS `SacFly`,
            SUM(CASE
                WHEN sacrifice_hit_fl = 'T' THEN 1
                ELSE 0
            END) AS `SacHit`,
            SUM(CASE
                WHEN double_play_fl = 'true' THEN 1
                ELSE 0
            END) AS `GroundedDoublePlay`,
            SUM(CASE
                WHEN triple_play_fl = 'true' THEN 1
                ELSE 0
            END) AS `GroundedTriplePlay`,
            SUM(CASE
                WHEN pitch_1 = 'S' THEN 1
                ELSE 0
            END) / (COUNT(pitch_1)) AS `FirstPitchSwingMissPercentage`,
            SUM(CASE
                WHEN pitch_1 = 'C' THEN 1
                ELSE 0
            END) / (COUNT(pitch_1)) AS `FirstPitchCalledStrikePercentage`,
            SUM(CASE
                WHEN pitch_1 = 'F' THEN 1
                ELSE 0
            END) / (COUNT(pitch_1)) AS `FirstPitchFoulBallPercentage`,
            SUM(CASE
                WHEN pitch_1 = 'B' THEN 1
                ELSE 0
            END) / (COUNT(pitch_1)) AS `FirstPitchBallPercentage`,
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
            SUM(rbi_ct) AS `RBI`,
            SUM(CASE
                WHEN EVENT_ID = '20' THEN 1
                WHEN EVENT_ID = '21' THEN 2
                WHEN EVENT_ID = '22' THEN 3
                WHEN EVENT_ID = '23' THEN 4
                ELSE 0
            END) AS `TotalBases`
    FROM
        mlb_cardinals.`mlb_cardsdata_2010_18`
    WHERE
        LEFT(GAME_ID, 4) = '2018'
    GROUP BY BATTER_ID
    ORDER BY HomeRun DESC) AS d