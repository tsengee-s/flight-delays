/***********************************************
**                MSc ANALYTICS 
**     DATA ENGINEERING PLATFORMS (MSCA 31012)
** File:   Flights Star DDL
** Desc:   Creating the Model for Final Project
** Auth:   Eva Burns, Haoyang Zhang, Nina Zhang, Tianqi Jiao, Tsengee Sundui
** Date:   12/07/2022
************************************************/

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema flights
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS `flights` DEFAULT CHARACTER SET latin1 ;
USE `flights` ;


CREATE TABLE IF NOT EXISTS `flights`.`airline` (
    `airline_id` SMALLINT NOT NULL AUTO_INCREMENT,
    `dot_id` SMALLINT NOT NULL,
    `carrier_code` VARCHAR(8) NOT NULL,
    `name` VARCHAR(45) NOT NULL,
    `operated_or_branded_code_share_partners` VARCHAR(12) NOT NULL,
    PRIMARY KEY (`airline_id`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=LATIN1;


CREATE TABLE IF NOT EXISTS `flights`.`state` (
    `state_id` TINYINT NOT NULL,
    `state_code` CHAR(2) NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `world_area_code` TINYINT NOT NULL,
    PRIMARY KEY (`state_id`)
)  ENGINE=INNODB DEFAULT CHARACTER SET=LATIN1;


CREATE TABLE IF NOT EXISTS `flights`.`city` (
    `city_id` SMALLINT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(45) NOT NULL,
    `state_id` TINYINT NOT NULL,
    PRIMARY KEY (`city_id`),
    CONSTRAINT `state_city_fk` FOREIGN KEY (`state_id`)
        REFERENCES `flights`.`state` (`state_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
)  ENGINE=INNODB DEFAULT CHARACTER SET=LATIN1;

CREATE INDEX `state_city_fk` ON `flights`.`city` (`state_id` ASC);


CREATE TABLE IF NOT EXISTS `flights`.`airport` (
    `airport_id` SMALLINT NOT NULL,
    `airport_code` CHAR(3) NOT NULL,
    `city_id` SMALLINT NOT NULL,
    PRIMARY KEY (`airport_id`),
    CONSTRAINT `city_airport_fk` FOREIGN KEY (`city_id`)
        REFERENCES `flights`.`city` (`city_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
)  ENGINE=INNODB DEFAULT CHARACTER SET=LATIN1;

CREATE INDEX `city_airport_fk` ON `flights`.`airport` (`city_id` ASC);


CREATE TABLE IF NOT EXISTS `flights`.`flight` (
    `flight_id` MEDIUMINT NOT NULL AUTO_INCREMENT,
    `flight_date` DATE NOT NULL,
    `operating_airline_id` SMALLINT NOT NULL,
    `operating_flight_number` SMALLINT NOT NULL,
    `origin_airport_id` SMALLINT NOT NULL,
    `dest_airport_id` SMALLINT NOT NULL,
    `cancelled` TINYINT(1) NOT NULL,
    `diverted` TINYINT(1) NOT NULL,
    `distance` DECIMAL(5 , 1) NOT NULL,
    `div_airport_landings` TINYINT NOT NULL,
    `CRS_dep_time` TIME NOT NULL,
    `dep_time` TIME,
    `dep_delay` SMALLINT,
    `dep_delay_minutes` SMALLINT,
    `CRS_arr_time` TIME NOT NULL,
    `arr_time` TIME,
    `arr_delay` SMALLINT,
    `arr_delay_minutes` SMALLINT,
    PRIMARY KEY (`flight_id`),
    CONSTRAINT `origin_airport_flight_fk` FOREIGN KEY (`origin_airport_id`)
        REFERENCES `flights`.`airport` (`airport_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `dest_airport_flight_fk` FOREIGN KEY (`dest_airport_id`)
        REFERENCES `flights`.`airport` (`airport_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `operating_airline_flight_fk` FOREIGN KEY (`operating_airline_id`)
        REFERENCES `flights`.`airline` (`airline_id`)
        ON DELETE NO ACTION ON UPDATE NO ACTION
)  ENGINE=INNODB DEFAULT CHARACTER SET=LATIN1;


CREATE INDEX `origin_airport_flight_fk` ON `flights`.`flight` (`origin_airport_id` ASC);
CREATE INDEX `dest_airport_flight_fk` ON `flights`.`flight` (`dest_airport_id` ASC);
CREATE INDEX `operating_airline_flight_fk` ON `flights`.`flight` (`operating_airline_id` ASC);

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;