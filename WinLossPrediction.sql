SELECT 
    Wins.Year,
    Wins.RunsScored,
    Wins.RunsAllowed,
    Wins.Win,
    Wins.Loss,
    Wins.PythogoreanWinPercentage,
    (Wins.Win + Wins.Loss) * Wins.PythogoreanWinPercentage AS 'PredictedWin',
    (Wins.Win + Wins.Loss) * (1 - Wins.PythogoreanWinPercentage) AS 'PredictedLoss'
FROM
    (SELECT 
        LEFT(runs.game_id, 4) AS 'Year',
            SUM(runs.RunScoredHome + runs.RunScoredAway) AS 'RunsScored',
            SUM(runs.RunAllowedHome + runs.RunAllowedAway) AS 'RunsAllowed',
            SUM(CASE
                WHEN runs.RunScoredHome > runs.RunAllowedHome THEN 1
                WHEN runs.RunScoredAway > runs.RunAllowedAway THEN 1
                ELSE 0
            END) AS 'Win',
            SUM(CASE
                WHEN runs.RunScoredHome < runs.RunAllowedHome THEN 1
                WHEN runs.RunScoredAway < runs.RunAllowedAway THEN 1
                ELSE 0
            END) AS 'Loss',
            ROUND(POWER(SUM(runs.RunScoredHome + runs.RunScoredAway), 1.8) / (POWER(SUM(runs.RunScoredHome + runs.RunScoredAway), 1.8) + POWER(SUM(runs.RunAllowedHome + runs.RunAllowedAway), 1.8)), 3) AS 'PythogoreanWinPercentage'
    FROM
        (SELECT 
        game_id,
            CASE
                WHEN home_team_id = 'SLN' THEN home_score_ct
                ELSE 0
            END AS 'RunScoredHome',
            CASE
                WHEN home_team_id = 'SLN' THEN away_score_ct
                ELSE 0
            END AS 'RunAllowedHome',
            CASE
                WHEN home_team_id != 'SLN' THEN away_score_ct
                ELSE 0
            END AS 'RunScoredAway',
            CASE
                WHEN home_team_id != 'SLN' THEN home_score_ct
                ELSE 0
            END AS 'RunAllowedAway'
    FROM
        MLB.mlbdatatransformations
    WHERE
        game_end_fl = 'true'
    GROUP BY game_id) runs
    GROUP BY LEFT(runs.game_id, 4)) Wins