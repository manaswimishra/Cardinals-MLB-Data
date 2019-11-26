/***********************************************
**                MSc ANALYTICS 
**     DATA ENGINEERING PLATFORMS (MSCA 31012)
** File:   Saint Louis Cardinal At-Bat Schema Creation
** Desc:   Creating the Snowflake Dimensional model
** Auth:   Meghna Diwan, Manaswi Mishra, Aalok Patel, Abhishek Yadav
** Date:   11/12/2019
************************************************/

# NOT ENTIRELY SURE WHAT THESE DO
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema cardinals_at_bats_snowflake
-- -----------------------------------------------------

DROP SCHEMA IF EXISTS cardinals_at_bats;

CREATE SCHEMA IF NOT EXISTS `cardinals_at_bats` DEFAULT CHARACTER SET latin1 ;
USE `cardinals_at_bats` ;

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`dim_player`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`dim_player` (
  `player_id` VARCHAR(8) NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`player_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

#CREATE INDEX `FILLER` ON `cardinals_at_bats`.`dim_player` (`FILLER` ASC);

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`dim_ballpark`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`dim_ballpark` (
  `ballpark_id` VARCHAR(5) NOT NULL,
  `ballpark_name` VARCHAR(50) NOT NULL,
  `ballpark_nickname` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`ballpark_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

#CREATE INDEX `FILLER` ON `cardinals_at_bats`.`dim_ballpark` (`FILLER` ASC);

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`dim_team`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`dim_team` (
  `team_id` VARCHAR(3) NOT NULL,
  `league` ENUM('NL','AL') NOT NULL,
  `city` VARCHAR(50) NOT NULL,
  `mascot` VARCHAR(25) NOT NULL,
  PRIMARY KEY (`team_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

#CREATE INDEX `dim_ballpark_dim_team_fk` ON `cardinals_at_bats`.`dim_team` (`ballpark_id` ASC);

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`dim_game`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`dim_game` (
  `game_id` INT(9) NOT NULL,
  `home_team_id` VARCHAR(3) NOT NULL,
  `away_team_id` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`game_id`),
  CONSTRAINT `dim_home_team_dim_game_fk` FOREIGN KEY (`home_team_id`)
        REFERENCES `cardinals_at_bats`.`dim_team` (`team_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_away_team_dim_game_fk` FOREIGN KEY (`away_team_id`)
    REFERENCES `cardinals_at_bats`.`dim_team` (`team_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

# NOT SURE ABOUT THESE INDEXES
CREATE INDEX `dim_home_team_dim_game_fk` ON `cardinals_at_bats`.`dim_game` (`home_team_id` ASC);
CREATE INDEX `dim_away_team_dim_game_fk` ON `cardinals_at_bats`.`dim_game` (`away_team_id` ASC);

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`dim_event`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`dim_event` (
  `event_id` INT(2) NOT NULL,
  `event_description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`event_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

#CREATE INDEX `FILLER` ON `cardinals_at_bats`.`dim_event` (`FILLER` ASC);

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`dim_in_field_position`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`dim_in_field_position` (
  `in_field_position_id` INT(10) NOT NULL AUTO_INCREMENT,
  `pos2_fld_id` VARCHAR(8) NOT NULL,
  `pos3_fld_id` VARCHAR(8) NOT NULL,
  `pos4_fld_id` VARCHAR(8) NOT NULL,
  `pos5_fld_id` VARCHAR(8) NOT NULL,
  `pos6_fld_id` VARCHAR(8) NOT NULL,
  `pos7_fld_id` VARCHAR(8) NOT NULL,
  `pos8_fld_id` VARCHAR(8) NOT NULL,
  `pos9_fld_id` VARCHAR(8) NOT NULL,
  PRIMARY KEY (`in_field_position_id`),
  CONSTRAINT `dim_player_dim_in_field_position2_fk` FOREIGN KEY (`pos2_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position3_fk` FOREIGN KEY (`pos3_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position4_fk` FOREIGN KEY (`pos4_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position5_fk` FOREIGN KEY (`pos5_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position6_fk` FOREIGN KEY (`pos6_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position7_fk` FOREIGN KEY (`pos7_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position8_fk` FOREIGN KEY (`pos8_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position9_fk` FOREIGN KEY (`pos9_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

#CREATE INDEX `FILLER` ON `cardinals_at_bats`.`dim_in_field_position` (`FILLER` ASC);

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`dim_pitch`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`dim_pitch` (
  `pitch_id` VARCHAR(10) NOT NULL,
  `pitch_description` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`pitch`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`dim_pitch_sequence`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`dim_pitch_sequence` (
  `pitch_sequence_id` INT(10) NOT NULL AUTO_INCREMENT,
  `pitch_sequence` VARCHAR(80) NOT NULL,
  `pitch_1` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_2` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_3` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_4` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_5` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_6` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_7` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_8` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_9` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_10` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_11` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_12` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_13` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_14` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_15` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_16` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_17` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_18` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_19` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_20` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_21` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_22` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_23` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_24` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_25` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_26` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_27` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_28` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_29` VARCHAR(10) NULL DEFAULT NULL,
  `pitch_30` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`pitch_sequence_id`),
  CONSTRAINT `dim_pitch_dim_pitch_1` FOREIGN KEY (`pitch_1`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_2` FOREIGN KEY (`pitch_2`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_3` FOREIGN KEY (`pitch_3`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_4` FOREIGN KEY (`pitch_4`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_5` FOREIGN KEY (`pitch_5`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_6` FOREIGN KEY (`pitch_6`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_7` FOREIGN KEY (`pitch_7`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_8` FOREIGN KEY (`pitch_8`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_9` FOREIGN KEY (`pitch_9`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_10` FOREIGN KEY (`pitch_10`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_11` FOREIGN KEY (`pitch_11`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_12` FOREIGN KEY (`pitch_12`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_13` FOREIGN KEY (`pitch_13`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_14` FOREIGN KEY (`pitch_14`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_15` FOREIGN KEY (`pitch_15`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_16` FOREIGN KEY (`pitch_16`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_17` FOREIGN KEY (`pitch_17`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_18` FOREIGN KEY (`pitch_18`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_19` FOREIGN KEY (`pitch_19`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_20` FOREIGN KEY (`pitch_20`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_21` FOREIGN KEY (`pitch_21`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_22` FOREIGN KEY (`pitch_22`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_23` FOREIGN KEY (`pitch_23`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_24` FOREIGN KEY (`pitch_24`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_25` FOREIGN KEY (`pitch_25`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_26` FOREIGN KEY (`pitch_26`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_27` FOREIGN KEY (`pitch_27`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_28` FOREIGN KEY (`pitch_28`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_29` FOREIGN KEY (`pitch_29`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_pitch_dim_pitch_30` FOREIGN KEY (`pitch_30`)
    REFERENCES `cardinals_at_bats`.`dim_pitch` (`pitch_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

#CREATE INDEX `FILLER` ON `cardinals_at_bats`.`dim_in_field_position` (`FILLER` ASC);

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`fact_at_bat`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`fact_at_bat` (
  `at_bat_id` INT(15) NOT NULL AUTO_INCREMENT,
  `game_id` INT(9) NOT NULL,
  `inning` SMALLINT(1) NULL,
  `batter_id` VARCHAR(8) NOT NULL,
  `batter_hand`	ENUM('L','R') NULL,
  `result_batter_id` VARCHAR(8) NOT NULL,
  `result_batter_hand` ENUM('L','R') NULL,
  `pitcher_id` VARCHAR(8) NOT NULL,
  `pitcher_hand` ENUM('L','R') NULL,
  `result_pitcher_id` VARCHAR(8) NOT NULL,
  `result_pitcher_hand` ENUM('L','R') NULL,
  `batter_team` BINARY(2) NULL,
  `outs_ct` SMALLINT(1) NULL,
  `balls_ct` SMALLINT(1) NULL,
  `strikes_ct` SMALLINT(1) NULL,
  `pitch_sequence_id` INT(10) NOT NULL,
  `away_score_ct` INT(2) NULL,
  `home_score_ct` INT(2) NULL,
  `in_field_position_id` INT(10) NOT NULL,
  `base1_run_id` VARCHAR(8) NOT NULL,
  `base2_run_id` VARCHAR(8) NOT NULL,
  `base3_run_id` VARCHAR(8) NOT NULL,
  `event_tx` VARCHAR(45) NULL,
  `event_id` INT(2) NOT NULL,
  `leadoff_fl` TINYINT(1) NULL,
  `pinch_hit_fl` TINYINT(1) NULL,
  `batter_field_position` INT(2) NULL,
  `batter_lineup` INT(2) NULL,
  `batter_event_fl`	TINYINT(1) NULL,
  `hit_value` SMALLINT(5) NULL,
  `sacrifice_hit_fl` TINYINT(1) NULL,
  `sacrifice_fly_fl` TINYINT(1) NULL,
  `event_outs_ct` SMALLINT(5) NULL,
  `double_play_fl` TINYINT(1) NULL,
  `triple_play_fl` TINYINT(1) NULL,
  `rbi_ct` SMALLINT(1) NULL,
  `wild_pitch_fl` TINYINT(1) NULL,
  `passed_ball_fl` TINYINT(1) NULL,
  `fielder_position` VARCHAR(8) NULL,
  `batted_ball_type` VARCHAR(1) NULL,
  `bunt_fl` TINYINT(1) NULL,
  `foul_fl` TINYINT(1) NULL,
  `battedball_loc_tx` VARCHAR(3) NULL,
  `error_ct` SMALLINT(1) NULL,
  `error1_fielder` INT(1) NULL,
  `error1_type`	VARCHAR(1) NULL,
  `error2_fielder` INT(1) NULL,
  `error2_type`	VARCHAR(1) NULL,
  `error3_fielder` INT(1) NULL,
  `error3_type`	VARCHAR(1) NULL,
  `batter_destination` INT(1) NULL,
  `runner1_destination`	INT(1) NULL,
  `runner2_destination`	INT(1) NULL,
  `runner3_destination`	INT(1) NULL,
  `bat_play_tx`	VARCHAR(50) NULL,
  `run1_play_tx` VARCHAR(50) NULL,
  `run2_play_tx` VARCHAR(50) NULL,
  `run3_play_tx` VARCHAR(50) NULL,
  `runner1_stolen_base_fl` TINYINT(1) NULL,
  `runner2_stolen_base_fl` TINYINT(1) NULL,
  `runner3_stolen_base_fl` TINYINT(1) NULL,
  `runner1_caught_stealing_fl` TINYINT(1) NULL,
  `runner2_caught_stealing_fl` TINYINT(1) NULL,
  `runner3_caught_stealing_fl` TINYINT(1) NULL,
  `runner1_picked_off_fl` TINYINT(1) NULL,
  `runner2_picked_off_fl` TINYINT(1) NULL,
  `runner3_picked_off_fl` TINYINT(1) NULL,
  `run1_resp_pit_id` VARCHAR(8) NULL,
  `run2_resp_pit_id` VARCHAR(8) NULL,
  `run3_resp_pit_id` VARCHAR(8) NULL,
  `pinch_runner1_fl` TINYINT(1) NULL,
  `pinch_runner2_fl` TINYINT(1) NULL,
  `pinch_runner3_fl` TINYINT(1) NULL,
  `removed_for_pinch_runner1_id` VARCHAR(8) NULL,
  `removed_for_pinch_runner2_id` VARCHAR(8) NULL,
  `removed_for_pinch_runner3_id` VARCHAR(8) NULL,
  `removed_for_pinch_hitter_id`	VARCHAR(8) NULL,
  `removed_for_pinch_hitter_batter_field_position` INT(1) NULL,
  `po1_fld_cd` INT(1) NULL,
  `po2_fld_cd` INT(1) NULL,
  `po3_fld_cd` INT(1) NULL,
  `ass1_fld_cd`	INT(1) NULL,
  `ass2_fld_cd`	INT(1) NULL,
  `ass3_fld_cd`	INT(1) NULL,
  `ass4_fld_cd`	INT(1) NULL,
  `ass5_fld_cd`	INT(1) NULL,
  `at_bat_counter` INT(3) NULL,
  PRIMARY KEY (`at_bat_id`),
	INDEX `fk_fact_at_bat_dim_game_idx` (`game_id` ASC),
    INDEX `fk_fact_at_bat_dim_Player_idx1` (`batter_id` ASC),
    INDEX `fk_fact_at_bat_dim_Player_idx2` (`result_batter_id` ASC),
    INDEX `fk_fact_at_bat_dim_Player_idx3` (`pitcher_id` ASC),
	INDEX `fk_fact_at_bat_dim_Player_idx4` (`result_pitcher_id` ASC),
    INDEX `fk_fact_at_bat_pitch_sequence` (`pitch_sequence_id` ASC),
    INDEX `fl_fact_at_bad_in_field_position` (`in_field_position_id` ASC),
    INDEX `fk_fact_at_bat_dim_Player_idx5` (`base1_run_id` ASC),
    INDEX `fk_fact_at_bat_dim_Player_idx6` (`base2_run_id` ASC),
    INDEX `fk_fact_at_bat_dim_Player_idx7` (`base3_run_id` ASC),
    INDEX `fk_fact_at_bat_dim_event` (`event_id` ASC),
    CONSTRAINT `fk_fact_at_bat_dim_game` FOREIGN KEY (`game_id`)
        REFERENCES `cardinals_at_bats`.`dim_game` (`game_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_fact_at_bat_dim_batter` FOREIGN KEY (`batter_id`)
        REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_fact_at_bat_dim_result_batter` FOREIGN KEY (`result_batter_id`)
        REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `fk_fact_at_bat_dim_pitcher` FOREIGN KEY (`pitcher_id`)
        REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `fk_fact_at_bat_dim_result_pitcher` FOREIGN KEY (`result_pitcher_id`)
        REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `fk_fact_at_bat_dim_pitch_sequence` FOREIGN KEY (`pitch_sequence_id`)
        REFERENCES `cardinals_at_bats`.`dim_pitch_sequence` (`pitch_sequence_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `fk_fact_at_bat_dim_in_field_position` FOREIGN KEY (`in_field_position_id`)
        REFERENCES `cardinals_at_bats`.`dim_in_field_position` (`in_field_position_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `fk_fact_at_bat_dim_base1_run` FOREIGN KEY (`base1_run_id`)
        REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `fk_fact_at_bat_dim_base2_run` FOREIGN KEY (`base2_run_id`)
        REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `fk_fact_at_bat_dim_base3_run` FOREIGN KEY (`base3_run_id`)
        REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT `fk_fact_at_bat_dim_event` FOREIGN KEY (`event_id`)
        REFERENCES `cardinals_at_bats`.`dim_event` (`event_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
        ) 
ENGINE = InnoDB DEFAULT CHARACTER SET = latin1;

CREATE INDEX `dim_game_fact_at_bat_fk` ON `cardinals_at_bats`.`fact_at_bat` (`game_id` ASC);
#CREATE INDEX `dim_player_fact_at_bat_fk_batter` ON `cardinals_at_bats`.`fact_at_bat` (`batter_id` ASC);
#CREATE INDEX `dim_player_fact_at_bat_fk_result_batter` ON `cardinals_at_bats`.`fact_at_bat` (`result_batter_id` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;