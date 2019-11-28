use MLB;
SELECT * FROM mlb.mlbdatatransformations;
SELECT * FROM teamid;
SELECT * FROM ballparkid;
SELECT DISTINCT GAME_ID FROM 2018stlouscardinalsatbat; 

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

INSERT INTO cardinals_at_bats.dim_player (    
	player_id,
    first_name,
    last_name)
(SELECT 
    ID, First, Last
FROM
    mlb.playerids);
    
SELECT * FROM cardinals_at_bats.dim_player WHERE player_id LIKE "mur%" ;

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

INSERT INTO cardinals_at_bats.dim_ballpark (    
	ballpark_id,
    ballpark_name,
    ballpark_nickname)
(SELECT 
    PARKID, NAME, AKA
FROM
    mlb.ballparkid);
    
SELECT * FROM cardinals_at_bats.dim_ballpark;

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`numbers_small`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`numbers_small` (
  `number` INT(11) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO numbers_small VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`numbers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`numbers` (
  `number` BIGINT(20) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

INSERT INTO numbers
SELECT 
    thousands.number * 1000 + hundreds.number * 100 + tens.number * 10 + ones.number
FROM
    numbers_small thousands,
    numbers_small hundreds,
    numbers_small tens,
    numbers_small ones
LIMIT 1000000;

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`dim_team`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`dim_team` (
  `team_id` VARCHAR(3) NOT NULL,
  `league` ENUM('NL','AL') NOT NULL,
  `city` VARCHAR(50) NOT NULL,
  #`state` VARCHAR(3) NOT NULL, # state not available, will need census or something to match city to state
  `mascot` VARCHAR(25) NOT NULL,
  #`ballpark_id` VARCHAR(5) NOT NULL, # need to match team to ballpark
  PRIMARY KEY (`team_id`))
  #CONSTRAINT `dim_ballpark_dim_team_fk` FOREIGN KEY (`ballpark_id`)
	#REFERENCES `cardinals_at_bats`.`dim_ball_park` (`ballpark_id`)
	#ON DELETE NO ACTION ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

#CREATE INDEX `dim_ballpark_dim_team_fk` ON `cardinals_at_bats`.`dim_team` (`ballpark_id` ASC);

INSERT INTO cardinals_at_bats.dim_team (    
	team_id,
    league,
    city,
    mascot)
(SELECT 
    TeamAbbreviation, League, City, Nickname
FROM
    mlb.teamid);
    
SELECT * FROM cardinals_at_bats.dim_team;

-- -----------------------------------------------------
-- Table `cardinals_at_bats`.`dim_game`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cardinals_at_bats`.`dim_game` (
  `game_id` varchar(15) NOT NULL,
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
    
INSERT INTO cardinals_at_bats.dim_game (    
	game_id,
    home_team_id,
    away_team_id)
(SELECT 
    GAME_ID_AWAY_TEAM_ID,
    substring(GAME_ID_AWAY_TEAM_ID, 1, 3) as home_team_id,
    substring(GAME_ID_AWAY_TEAM_ID, -3, 3) as away_team_id
FROM
	(SELECT DISTINCT GAME_ID_AWAY_TEAM_ID
    FROM mlb.2018stlouscardinalsatbat) as games
    );    
    
SELECT * FROM cardinals_at_bats.dim_game;

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
 
INSERT INTO cardinals_at_bats.dim_event (    
	event_id,
    event_description)
(SELECT 
    event_id,
    event_description
FROM
	mlb.eventid
    );    
    
SELECT * FROM cardinals_at_bats.dim_event;

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
  CONSTRAINT `dim_player_dim_in_field_position_2_fk` FOREIGN KEY (`pos2_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position_3_fk` FOREIGN KEY (`pos3_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position_4_fk` FOREIGN KEY (`pos4_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position_5_fk` FOREIGN KEY (`pos5_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position_6_fk` FOREIGN KEY (`pos6_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position_7_fk` FOREIGN KEY (`pos7_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position_8_fk` FOREIGN KEY (`pos8_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `dim_player_dim_in_field_position_9_fk` FOREIGN KEY (`pos9_fld_id`)
    REFERENCES `cardinals_at_bats`.`dim_player` (`player_id`)
    ON DELETE NO ACTION ON UPDATE NO ACTION
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

#CREATE INDEX `FILLER` ON `cardinals_at_bats`.`dim_in_field_position` (`FILLER` ASC);
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
	POS2_FLD_ID,
	POS3_FLD_ID,
    POS4_FLD_ID,
    POS5_FLD_ID,
    POS6_FLD_ID,
    POS7_FLD_ID,
    POS8_FLD_ID,
    POS9_FLD_ID
FROM
	(SELECT 
		POS2_FLD_ID,
		POS3_FLD_ID,
		POS4_FLD_ID,
		POS5_FLD_ID,
		POS6_FLD_ID,
		POS7_FLD_ID, 
		POS8_FLD_ID,
		POS9_FLD_ID  
	FROM MLB. 2018stlouscardinalsatbat
    GROUP BY POS2_FLD_ID, POS3_FLD_ID, POS4_FLD_ID, POS5_FLD_ID,
    POS6_FLD_ID, POS7_FLD_ID, POS8_FLD_ID, POS9_FLD_ID) as uniq_field_pos
    ); 
    
SELECT * FROM cardinals_at_bats.dim_in_field_position;

SELECT * FROM cardinals_at_bats.dim_pitch_sequence;

SELECT * 
FROM mlb.mlbdatatransformations
WHERE leadoff_fl = 'TRUE';

SELECT batter_team FROM mlb.mlbdatatransformations;

SELECT home_team_id, away_team_id FROM  mlb.mlbdatatransformations WHERE home_team_id = 'FLO' or away_team_id = 'FLO';

SELECT * FROM cardinals_at_bats.fact_at_bat; 

SELECT * FROM mlb.pitchid;

SELECT * FROM mlb.eventid;

