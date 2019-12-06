SELECT 
    pitcher_id,
    COUNT(*) AS 'TotalPitches',
    SUM(CASE
        WHEN d.pitch_1 IN ('C' , 'F', 'L', 'M', 'O', 'R', 'S', 'T') THEN 1
        WHEN
            (d.pitch_1 = 'X'
                AND d.event_id IN ('2' , '18', '19'))
        THEN
            1
        ELSE 0
    END) AS 'FirstPitchStrikes',
    (SUM(CASE
        WHEN d.pitch_1 IN ('C' , 'F', 'L', 'M', 'O', 'R', 'S', 'T') THEN 1
        WHEN
            (d.pitch_1 = 'X'
                AND d.event_id IN ('2' , '18', '19'))
        THEN
            1
        ELSE 0
    END)) / COUNT(*) AS 'FirstPitchStrikePercentage',
    (SUM(CASE
        WHEN
            d.pitch_1 IN ('C' , 'F', 'L', 'M', 'O', 'R', 'S', 'T', 'X')
                AND d.event_id IN ('20' , '21', '22', '23')
        THEN
            1
        ELSE 0
    END)) / COUNT(*) AS 'HitPercentageAfterFirstPitchStrike',
    SUM(CASE
        WHEN EVENT_ID = '3' THEN 1
        ELSE 0
    END) AS `Strikeout`,
    SUM(CASE
        WHEN EVENT_ID = '14' THEN 1
        ELSE 0
    END) AS `Walk`,
    SUM(CASE
        WHEN EVENT_ID = '3' THEN 1
        ELSE 0
    END) / SUM(CASE
        WHEN EVENT_ID = '14' THEN 1
        ELSE 0
    END) AS `StrikeoutToWalkRatio`
FROM
    (SELECT 
        *
    FROM
        MLB.mlbdatatransformations
    WHERE
        pitch_1 NOT IN ('N' , 'V', '')
            AND LEFT(game_id, 4) = '2018') d
GROUP BY pitcher_id
ORDER BY TotalPitches DESC
LIMIT 15