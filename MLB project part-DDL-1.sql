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
  `city` VARCHAR(50) NULL DEFAULT NULL,
  `state` VARCHAR(3) NULL DEFAULT NULL,
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
  `state` VARCHAR(3) NOT NULL,
  `mascot` VARCHAR(25) NOT NULL,
  `ballpark_id` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`team_id`),
  CONSTRAINT `dim_ballpark_dim_team_fk` FOREIGN KEY (`ballpark_id`)
	REFERENCES `cardinals_at_bats`.`dim_ball_park` (`ballpark_id`)
	ON DELETE NO ACTION ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `dim_ballpark_dim_team_fk` ON `cardinals_at_bats`.`dim_team` (`ballpark_id` ASC);

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`dim_game`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`dim_game` (
  `game_id` INT(9) NOT NULL,
  `home_team_id` VARCHAR(3) NOT NULL,
  `away_team_id` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`game_id`),
  CONSTRAINT `dim_team_dim_game_fk` FOREIGN KEY (`home_team_id`)
        REFERENCES `cardinals_at_bats`.`dim_team` (`team_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_team_dim_game_fk` FOREIGN KEY (`away_team_id`)
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
  CONSTRAINT `dim_player_dim_in_field_position_fk` FOREIGN KEY (`pos2_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position_fk` FOREIGN KEY (`pos3_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position_fk` FOREIGN KEY (`pos4_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position_fk` FOREIGN KEY (`pos5_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position_fk` FOREIGN KEY (`pos6_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position_fk` FOREIGN KEY (`pos7_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position_fk` FOREIGN KEY (`pos8_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position_fk` FOREIGN KEY (`pos9_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

#CREATE INDEX `FILLER` ON `cardinals_at_bats`.`dim_in_field_position` (`FILLER` ASC);

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`dim_film`
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
  PRIMARY KEY (`pitch_sequence_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

#CREATE INDEX `FILLER` ON `cardinals_at_bats`.`dim_in_field_position` (`FILLER` ASC);


-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`dim_pitch`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`dim_pitch` (
  `pitch_event` VARCHAR(45) NOT NULL,
  `description` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`pitch_event`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`fact_at_bat`
-- -----------------------------------------------------

CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`fact_at_bat` (
  `at_bat_id` INT(15) NOT NULL AUTO_INCREMENT,
  `game_id` INT(9) NOT NULL,
  `inning` TINYINT(1) NOT NULL,
  `batter_id` VARCHAR(8) NOT NULL,
  `batter_hand`	ENUM('L','R') NOT NULL,
  `result_batter_id` VARCHAR(8) NOT NULL,
  `result_batter_hand` ENUM('L','R') NOT NULL,
  `pitcher_id` VARCHAR(8) NOT NULL,

  `pitcher_hand` ENUM('L','R') NOT NULL,
  `result_pitcher_id` VARCHAR(8) NOT NULL,
  `result_pitcher_hand` ENUM('L','R') NOT NULL,
  `batter_team` BINARY(2) NOT NULL,
  `outs_ct` SMALLINT(2) NOT NULL,
  `balls_ct` SMALLINT(2) NOT NULL,
  `strikes_ct` SMALLINT(2) NOT NULL,
  `pitch_sequence_id` INT(10) NOT NULL,
  `away_score_ct` INT(2) NOT NULL,
  `home_score_ct` INT(2) NOT NULL,
  `in_field_position_id` INT(10) NOT NULL,
  `base1_run_id` VARCHAR(8) NOT NULL,
  `base2_run_id` VARCHAR(8) NOT NULL,
  `base3_run_id` VARCHAR(8) NOT NULL,
  `event_tx` VARCHAR(45) NOT NULL,
  `event_id` INT(2) NOT NULL,
  `leadoff_fl` ENUM('T','F') NOT NULL,
  `pinch_hit_fl` ENUM('T','F') NOT NULL,
  `batter_field_position` INT(2) NOT NULL,
  `batter_lineup` INT(2) NOT NULL,
  `batter_event_fl` ENUM('T','F') NOT NULL,
  `hit_value` SMALLINT(2) NOT NULL,
  `sacrifice_hit_fl` ENUM('T','F') NOT NULL,
  `sacrifice_fly_fl` ENUM('T','F') NOT NULL,
  `event_outs_ct` SMALLINT(2) NOT NULL,
  `double_play_fl` ENUM('T','F') NOT NULL,
  `triple_play_fl` ENUM('T','F') NOT NULL,
  `rbi_ct` SMALLINT(2) NOT NULL,
  `wild_pitch_fl` ENUM('T','F') NOT NULL,
  `passed_ball_fl` ENUM('T','F') NOT NULL,
  `fielder_position` VARCHAR(8) NOT NULL,
  `batted_ball_type` VARCHAR(1) NOT NULL,
  `bunt_fl` ENUM('T','F') NOT NULL,
  `foul_fl` ENUM('T','F') NOT NULL,
  `battedball_loc_tx` VARCHAR(3) NOT NULL,
  `error_ct` SMALLINT(2) NOT NULL,
  `error1_fielder` INT(1) NOT NULL,
  `error1_type` VARCHAR(1) NOT NULL,
  `error2_fielder` INT(1) NOT NULL,
  `error2_type` VARCHAR(1) NOT NULL,
  `error3_fielder` INT(1) NOT NULL,
  `error3_type` VARCHAR(1) NOT NULL,
  `batter_destination` INT(1) NOT NULL,
  `runner1_destination` INT(1) NOT NULL,
  `runner2_destination` INT(1) NOT NULL,
  `runner3_destination` INT(1) NOT NULL,
  `bat_play_tx` VARCHAR(50) NOT NULL,
  `run1_play_tx` VARCHAR(50) NOT NULL,
  `run2_play_tx` VARCHAR(50) NOT NULL,
  `run3_play_tx` VARCHAR(50) NOT NULL,
  `runner1_stolen_base_fl` ENUM('T','F') NOT NULL,
  `runner2_stolen_base_fl` ENUM('T','F') NOT NULL,
  `runner3_stolen_base_fl` ENUM('T','F') NOT NULL,
  `runner1_caught_stealing_fl` ENUM('T','F') NOT NULL,
  `runner2_caught_stealing_fl` ENUM('T','F') NOT NULL,
  `runner3_caught_stealing_fl` ENUM('T','F') NOT NULL,
  `runner1_picked_off_fl` ENUM('T','F') NOT NULL,
  `runner2_picked_off_fl` ENUM('T','F') NOT NULL,
  `runner3_picked_off_fl` ENUM('T','F') NOT NULL,
  `run1_resp_pit_id` VARCHAR(8) NOT NULL,
  `run2_resp_pit_id` VARCHAR(8) NOT NULL,
  `run3_resp_pit_id` VARCHAR(8) NOT NULL,
  `pinch_runner1_fl` ENUM('T','F') NOT NULL,
  `pinch_runner2_fl` ENUM('T','F') NOT NULL,
  `pinch_runner3_fl` ENUM('T','F') NOT NULL,
  `removed_for_pinch_runner1_id` VARCHAR(8) NOT NULL,
  `removed_for_pinch_runner2_id` VARCHAR(8) NOT NULL,
  `removed_for_pinch_runner3_id` VARCHAR(8) NOT NULL,
  `removed_for_pinch_hitter_id` VARCHAR(8) NOT NULL,
  `removed_for_pinch_hitter_batter_field_position` INT(1) NOT NULL,
  `po1_fld_cd` INT(1) NOT NULL,
  `po2_fld_cd` INT(1) NOT NULL,
  `po3_fld_cd` INT(1) NOT NULL,
  `ass1_fld_cd` INT(1) NOT NULL,
  `ass2_fld_cd` INT(1) NOT NULL,
  `ass3_fld_cd` INT(1) NOT NULL,
  `ass4_fld_cd` INT(1) NOT NULL,
  `ass5_fld_cd` INT(1) NOT NULL,
  `at_bat_counter` INT(3) NOT NULL,

  
  PRIMARY KEY (`at_bat_id`),
	INDEX `fk_fact_at_bat_dim_game_idx` (`game_id` ASC),
    INDEX `fk_fact_at_bat_dim_Player_idx1` (`batter_id` ASC),
    INDEX `fk_fact_at_bat_dim_Player_idx2` (`result_batter_id` ASC),
    
    CONSTRAINT `fk_fact_at_bat_dim_game` FOREIGN KEY (`game_id`)
        REFERENCES `cardinals_at_bats`.`dim_game` (`game_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_fact_at_bat_dim_batter` FOREIGN KEY (`batter_id`)
        REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `fk_fact_at_bat_dim_result_batter` FOREIGN KEY (`result_batter_id`)
        REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,

#foreign key for result pitcher id to dim player-player id key
    CONSTRAINT `fk_fact_at_bat_dim_result_pitcher_id` FOREIGN KEY (`result_pitcher_id`)
        REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
#foreign key for pitch_sequence_id to dim_pitch_sequence-pitch_sequence_id
    CONSTRAINT `fk_fact_at_bat_dim_pitch_sequence_id` FOREIGN KEY (`pitch_sequence_id`)
        REFERENCES `cardinals_at_bats`.`dim_pitch_sequence` (`pitch_sequence_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
#foreign key for in_field_position_id to dim_in_field_position-pitch_sequence_id
    CONSTRAINT `fk_fact_at_bat_dim_in_field_position_id` FOREIGN KEY (`in_field_position_id`)
        REFERENCES `cardinals_at_bats`.`dim_in_field_position` (`in_field_position_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
#foreign key for base1_run_id to dim_player-player_id
    CONSTRAINT `fk_fact_at_bat_dim_base1_run_id` FOREIGN KEY (`base1_run_id`)
        REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
#foreign key for base2_run_id to dim_player-player_id
    CONSTRAINT `fk_fact_at_bat_dim_base2_run_id` FOREIGN KEY (`base2_run_id`)
        REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
#foreign key for base3_run_id to dim_player-player_id
    CONSTRAINT `fk_fact_at_bat_dim_base3_run_id` FOREIGN KEY (`base3_run_id`)
        REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
#foreign key for event_id to dim_player-player_id
    CONSTRAINT `fk_fact_at_bat_dim_event_id` FOREIGN KEY (`event_id`)
        REFERENCES `cardinals_at_bats`.`dim_event` (`player_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION

        
        ) 
ENGINE = InnoDB DEFAULT CHARACTER SET = latin1;

CREATE INDEX `dim_game_fact_at_bat_fk` ON `cardinals_at_bats`.`fact_at_bat` (`game_id` ASC);
#CREATE INDEX `dim_player_fact_at_bat_fk_batter` ON `cardinals_at_bats`.`fact_at_bat` (`batter_id` ASC);
#CREATE INDEX `dim_player_fact_at_bat_fk_result_batter` ON `cardinals_at_bats`.`fact_at_bat` (`result_batter_id` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;