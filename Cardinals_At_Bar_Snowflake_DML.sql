/***********************************************
**                MSc ANALYTICS 
**     DATA ENGINEERING PLATFORMS (MSCA 31012)
** File:   Saint Louis Cardinal At-Bat Schema Creation
** Desc:   Inserting data into the Snowflake Dimensional model
** Auth:   Meghna Diwan, Manaswi Mishra, Aalok Patel, Abhishek Yadav
** Date:   11/23/2019
************************************************/

USE `cardinals_at_bats` ;

-- -----------------------------------------------------
-- Insert into Table `cardinals_at_bats`.`dim_player`
-- -----------------------------------------------------

INSERT INTO cardinals_at_bats.dim_player (    
	player_id,
    first_name,
    last_name)
(SELECT 
    ID, First, Last
FROM
    mlb.playerids);
    
-- -----------------------------------------------------
-- Insert into Table `cardinals_at_bats`.`dim_ballpark`
-- -----------------------------------------------------

INSERT INTO cardinals_at_bats.dim_ballpark (    
	ballpark_id,
    ballpark_name,
    ballpark_nickname)
(SELECT 
    PARKID, NAME, AKA
FROM
    mlb.ballparkid);
    
-- -----------------------------------------------------
-- Insert into Table `cardinals_at_bats`.`dim_team`
-- -----------------------------------------------------

INSERT INTO cardinals_at_bats.dim_team (    
	team_id,
    league,
    city,
    mascot)
(SELECT 
    TeamAbbreviation, League, City, Nickname
FROM
    mlb.teamid);
    
-- -----------------------------------------------------
-- Insert into Table `cardinals_at_bats`.`dim_game`
-- -----------------------------------------------------

INSERT INTO cardinals_at_bats.dim_game (    
	game_id,
    home_team_id,
    away_team_id)
(SELECT 
    game_id,
    home_team_id,
    away_team_id
FROM
	(SELECT DISTINCT game_id, home_team_id, away_team_id
    FROM mlb.mlbdatatransformations_2010) as games
    );

-- -----------------------------------------------------
-- Insert into Table `cardinals_at_bats`.`dim_event`
-- -----------------------------------------------------

INSERT INTO cardinals_at_bats.dim_event (    
	event_id,
    event_description)
(SELECT 
    event_id,
    event_description
FROM
	mlb.eventid); 
    
-- -------------------------------------------------------------
-- Insert into Table `cardinals_at_bats`.`dim_in_field_position`
-- -------------------------------------------------------------

INSERT INTO cardinals_at_bats.dim_in_field_position (    
	pos2_fld_id,
    pos3_fld_id,
    pos4_fld_id,
    pos5_fld_id,
    pos6_fld_id,
    pos7_fld_id,
    pos8_fld_id,
    pos9_fld_id)
(SELECT 
	pos2_fld_id,
	pos3_fld_id,
    pos4_fld_id,
    pos5_fld_id,
    pos6_fld_id,
    pos7_fld_id,
    pos8_fld_id,
    pos9_fld_id
FROM
	(SELECT 
		pos2_fld_id,
		pos3_fld_id,
		pos4_fld_id,
		pos5_fld_id,
		pos6_fld_id,
		pos7_fld_id, 
		pos8_fld_id,
		pos9_fld_id  
	FROM mlb.mlbdatatransformations_2010
    GROUP BY pos2_fld_id, pos3_fld_id, pos4_fld_id,
		pos5_fld_id, pos6_fld_id, pos7_fld_id, 
		pos8_fld_id, pos9_fld_id ) as uniq_field_pos
    );
    
-- -----------------------------------------------------
-- Insert into Table `cardinals_at_bats`.`dim_pitch`
-- -----------------------------------------------------

INSERT INTO cardinals_at_bats.dim_pitch (    
	pitch,
    pitch_description)
(SELECT 
    pitch_id,
    pitch_description
FROM
	mlb.pitchid); 
    
-- ----------------------------------------------------------
-- Insert into Table `cardinals_at_bats`.`dim_pitch_sequence`
-- ----------------------------------------------------------

INSERT INTO cardinals_at_bats.dim_pitch_sequence (    
	pitch_sequence,
    pitch_1, pitch_2, pitch_3, pitch_4, pitch_5, pitch_6, pitch_7,
    pitch_8, pitch_9, pitch_10, pitch_11, pitch_12, pitch_13, pitch_14,
    pitch_15, pitch_16, pitch_17, pitch_18, pitch_19, pitch_20, pitch_21,
    pitch_22, pitch_23, pitch_24, pitch_25, pitch_26, pitch_27, pitch_28,
    pitch_29, pitch_30)
(SELECT 
    pitch_sequence,
    pitch_1, pitch_2, pitch_3, pitch_4, pitch_5, pitch_6, pitch_7,
    pitch_8, pitch_9, pitch_10, pitch_11, pitch_12, pitch_13, pitch_14,
    pitch_15, pitch_16, pitch_17, pitch_18, pitch_19, pitch_20, pitch_21,
    pitch_22, pitch_23, pitch_24, pitch_25, pitch_26, pitch_27, pitch_28,
    pitch_29, pitch_30
FROM
	mlb.mlbdatatransformations_2010);
    
-- -----------------------------------------------------
-- Insert into Table `cardinals_at_bats`.`fact_at_bat`
-- -----------------------------------------------------

INSERT INTO cardinals_at_bats.fact_at_bat (    
	game_id, inning, batter_id, batter_hand, result_batter_id,
	result_batter_hand, pitcher_id, pitcher_hand, result_pitcher_id,
	result_pitcher_hand, batter_team, outs_ct, balls_ct, strikes_ct, 
    pitch_sequence_id, away_score_ct, home_score_ct, in_field_position_id, 
    base1_run_id, base2_run_id, base3_run_id, event_tx, event_id, leadoff_fl, 
    pinch_hit_fl, batter_field_position, batter_lineup, batter_event_fl, 
    hit_value, sacrifice_hit_fl, sacrifice_fly_fl, event_outs_ct, double_play_fl, 
    triple_play_fl, rbi_ct, wild_pitch_fl, passed_ball_fl, fielder_position, 
    batted_ball_type, bunt_fl, foul_fl, battedball_loc_tx, error_ct, error1_fielder, 
    error1_type, error2_fielder, error2_type, error3_fielder, error3_type, 
    batter_destination, runner1_destination, runner2_destination, runner3_destination, 
    bat_play_tx, run1_play_tx, run2_play_tx, run3_play_tx, runner1_stolen_base_fl, 
    runner2_stolen_base_fl, runner3_stolen_base_fl, runner1_caught_stealing_fl, 
    runner2_caught_stealing_fl, runner3_caught_stealing_fl, runner1_picked_off_fl, 
    runner2_picked_off_fl, runner3_picked_off_fl, run1_resp_pit_id, run2_resp_pit_id, 
    run3_resp_pit_id, pinch_runner1_fl, pinch_runner2_fl, pinch_runner3_fl, 
    removed_for_pinch_runner1_id, removed_for_pinch_runner2_id, removed_for_pinch_runner3_id, 
    removed_for_pinch_hitter_id, removed_for_pinch_hitter_batter_field_position, po1_fld_cd, 
    po2_fld_cd, po3_fld_cd, ass1_fld_cd, ass2_fld_cd, ass3_fld_cd, ass4_fld_cd, ass5_fld_cd, at_bat_counter)
(SELECT 
    m.game_id, m.inning, m.batter_id, m.bat_hand_cd, m.result_batter_id,
	m.result_batter_hand, m.pitcher_id, m.pitcher_hand, m.result_pitcher_id,
	m.result_pitcher_hand, m.batter_team, m.outs_ct, m.balls_ct, m.strikes_ct, 
    p.pitch_sequence_id, m.away_score_ct, m.home_score_ct, f.in_field_position_id, 
    m.base1_run_id, m.base2_run_id, m.base3_run_id, m.event_tx, m.event_id, m.leadoff_fl, 
    m.pinch_hit_fl, m.batter_field_position, m.batter_lineup, m.batter_event_fl, 
    m.hit_value, m.sacrifice_hit_fl, m.sacrifice_fly_fl, m.event_outs_ct, m.double_play_fl, 
    m.triple_play_fl, m.rbi_ct, m.wild_pitch_fl, m.passed_ball_fl, m.fielder_position, 
    m.batted_ball_type, m.bunt_fl, m.foul_fl, m.battedball_loc_tx, m.error_ct, m.error1_fielder, 
    m.error1_type, m.error2_fielder, m.error2_type, m.error3_fielder, m.error3_type, 
    m.batter_destination, m.runner1_destination, m.runner2_destination, m.runner3_destination, 
    m.bat_play_tx, m.run1_play_tx, m.run2_play_tx, m.run3_play_tx, m.runner1_stolen_base_fl, 
    m.runner2_stolen_base_fl, m.runner3_stolen_base_fl, m.runner1_caught_stealing_fl, 
    m.runner2_caught_stealing_fl, m.runner3_caught_stealing_fl, m.runner1_picked_off_fl, 
    m.runner2_picked_off_fl, m.runner3_picked_off_fl, m.run1_resp_pit_id, m.run2_resp_pit_id, 
    m.run3_resp_pit_id, m.pinch_runner1_fl, m.pinch_runner2_fl, m.pinch_runner3_fl, 
    m.removed_for_pinch_runner1_id, m.removed_for_pinch_runner2_id, m.removed_for_pinch_runner3_id, 
    m.removed_for_pinch_hitter_id, m.removed_for_pinch_hitter_batter_field_position, m.po1_fld_cd, 
    m.po2_fld_cd, m.po3_fld_cd, m.ass1_fld_cd, m.ass2_fld_cd, m.ass3_fld_cd, m.ass4_fld_cd, m.ass5_fld_cd, m.at_bat_counter
FROM
	mlb.mlbdatatransformations_2010 as m
    INNER JOIN
    dim_pitch_sequence as p ON p.pitch_sequence = m.pitch_sequence
    INNER JOIN
    dim_in_field_position as f ON (f.pos2_fld_id=m.pos2_fld_id AND f.pos3_fld_id=m.pos3_fld_id AND 
    f.pos4_fld_id=m.pos4_fld_id AND f.pos5_fld_id=m.pos5_fld_id AND f.pos6_fld_id=m.pos6_fld_id AND 
    f.pos7_fld_id=m.pos7_fld_id AND f.pos8_fld_id=m.pos8_fld_id AND f.pos9_fld_id=m.pos9_fld_id)
    );
