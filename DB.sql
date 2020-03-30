-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.7.29-log - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             10.3.0.5771
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for covid-19
DROP DATABASE IF EXISTS `covid-19`;
CREATE DATABASE IF NOT EXISTS `covid-19` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `covid-19`;

-- Dumping structure for procedure covid-19.ApproveUser
DROP PROCEDURE IF EXISTS `ApproveUser`;
DELIMITER //
CREATE PROCEDURE `ApproveUser`(IN _id int)
BEGIN
update users set approved=1 where id=_id;
END//
DELIMITER ;

-- Dumping structure for table covid-19.countries
DROP TABLE IF EXISTS `countries`;
CREATE TABLE IF NOT EXISTS `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) DEFAULT NULL,
  `createdat` datetime DEFAULT CURRENT_TIMESTAMP,
  `createdby` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_user_idx` (`createdby`)
) ENGINE=InnoDB AUTO_INCREMENT=228 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for procedure covid-19.DeleteUser
DROP PROCEDURE IF EXISTS `DeleteUser`;
DELIMITER //
CREATE PROCEDURE `DeleteUser`(IN _id int)
BEGIN
update users set deleted=1 where id=_id;

END//
DELIMITER ;

-- Dumping structure for procedure covid-19.GetCountries
DROP PROCEDURE IF EXISTS `GetCountries`;
DELIMITER //
CREATE PROCEDURE `GetCountries`()
BEGIN
select * from countries where deleted=0;
END//
DELIMITER ;

-- Dumping structure for procedure covid-19.Getmedicalcategories
DROP PROCEDURE IF EXISTS `Getmedicalcategories`;
DELIMITER //
CREATE PROCEDURE `Getmedicalcategories`()
BEGIN
select * from medicalcategories where deleted=0;
END//
DELIMITER ;

-- Dumping structure for procedure covid-19.GetOfficersByCategory
DROP PROCEDURE IF EXISTS `GetOfficersByCategory`;
DELIMITER //
CREATE PROCEDURE `GetOfficersByCategory`()
BEGIN
select count(*) y,medicalcategories.description as label from medicalofficers
 inner join medicalcategories on medicalcategories.id=medicalofficers.categoryid group by categoryid;
END//
DELIMITER ;

-- Dumping structure for procedure covid-19.GetOfficersByCategoryUnEmployed
DROP PROCEDURE IF EXISTS `GetOfficersByCategoryUnEmployed`;
DELIMITER //
CREATE PROCEDURE `GetOfficersByCategoryUnEmployed`()
BEGIN
select count(*) y,medicalcategories.description as label from medicalofficers
 inner join medicalcategories on medicalcategories.id=medicalofficers.categoryid
 where medicalofficers.employed='No' group by categoryid;
END//
DELIMITER ;

-- Dumping structure for procedure covid-19.GetOneCountry
DROP PROCEDURE IF EXISTS `GetOneCountry`;
DELIMITER //
CREATE PROCEDURE `GetOneCountry`(IN _id int)
BEGIN
select * from countries where deleted=0 and id=_id;
END//
DELIMITER ;

-- Dumping structure for procedure covid-19.GetTotalOfficers
DROP PROCEDURE IF EXISTS `GetTotalOfficers`;
DELIMITER //
CREATE PROCEDURE `GetTotalOfficers`()
BEGIN
select count(*) from medicalofficers into @Total;
select count(*) as count,employed,@Total as Total from medicalofficers group by employed;
END//
DELIMITER ;

-- Dumping structure for procedure covid-19.GetUsers
DROP PROCEDURE IF EXISTS `GetUsers`;
DELIMITER //
CREATE PROCEDURE `GetUsers`()
BEGIN
select * from users where deleted=0;
END//
DELIMITER ;

-- Dumping structure for table covid-19.medicalcategories
DROP TABLE IF EXISTS `medicalcategories`;
CREATE TABLE IF NOT EXISTS `medicalcategories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(100) NOT NULL,
  `deleted` int(11) NOT NULL DEFAULT '0',
  `createdat` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `createdby` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user_idx` (`createdby`),
  CONSTRAINT `fk_user` FOREIGN KEY (`createdby`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for table covid-19.medicalofficers
DROP TABLE IF EXISTS `medicalofficers`;
CREATE TABLE IF NOT EXISTS `medicalofficers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `categoryid` int(11) NOT NULL,
  `countryid` int(11) NOT NULL,
  `mobile` varchar(45) NOT NULL,
  `address` varchar(45) NOT NULL,
  `employed` varchar(45) NOT NULL,
  `graduationdate` datetime NOT NULL,
  `qualification` varchar(100) NOT NULL,
  `registered` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_country_idx` (`countryid`),
  KEY `fk_categories_idx` (`categoryid`),
  CONSTRAINT `fk_categories` FOREIGN KEY (`categoryid`) REFERENCES `medicalcategories` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_officer_country` FOREIGN KEY (`countryid`) REFERENCES `countries` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

-- Dumping structure for procedure covid-19.Savemedicalofficers
DROP PROCEDURE IF EXISTS `Savemedicalofficers`;
DELIMITER //
CREATE PROCEDURE `Savemedicalofficers`(IN _name varchar(100),IN _email varchar(100),IN _categoryid int,IN _countryid int,IN _mobile varchar(45),IN _address varchar(45),IN _employed varchar(45),IN _graduationdate DateTime,IN _qualification varchar(100),IN _registered Boolean )
BEGIN
INSERT INTO `covid-19`.`medicalofficers`
(
`name`,
`email`,
`categoryid`,
`countryid`,
`mobile`,
`address`,
`employed`,
`graduationdate`,
`qualification`,
`registered`)
VALUES
(
_name,
_email,
_categoryid,
_countryid,
_mobile,
_address,
_employed,
_graduationdate,
_qualification,
_registered);

END//
DELIMITER ;

-- Dumping structure for procedure covid-19.SaveUser
DROP PROCEDURE IF EXISTS `SaveUser`;
DELIMITER //
CREATE PROCEDURE `SaveUser`(IN _name varchar(100),IN _email varchar(45),IN _password varchar(200),IN _countryid int,IN _mobile varchar(45))
BEGIN
INSERT INTO `covid-19`.`users`
(
`name`,
`email`,
`password`,
`countryid`,
`approved`,
`createdat`,
`deleted`
,role
,mobile)
VALUES
(
_name,
_email,
_password,
_countryid,
0,
now(),
0
,2
,_mobile);

END//
DELIMITER ;

-- Dumping structure for procedure covid-19.SPgetMedicalOfficers
DROP PROCEDURE IF EXISTS `SPgetMedicalOfficers`;
DELIMITER //
CREATE PROCEDURE `SPgetMedicalOfficers`()
BEGIN
select medicalofficers.name,medicalofficers.email,medicalofficers.mobile,medicalofficers.address,medicalofficers.employed,medicalofficers.graduationdate,medicalofficers.qualification,
registered,medicalcategories.description as category,countries.name as country
from medicalofficers inner join medicalcategories on medicalcategories.id=medicalofficers.categoryid
inner join countries on countries.id=medicalofficers.countryid;
END//
DELIMITER ;

-- Dumping structure for procedure covid-19.SPGetOneUser
DROP PROCEDURE IF EXISTS `SPGetOneUser`;
DELIMITER //
CREATE PROCEDURE `SPGetOneUser`(IN _email varchar(45))
BEGIN
select * from users where deleted=0 and email=_email;
END//
DELIMITER ;

-- Dumping structure for table covid-19.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(45) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL,
  `countryid` int(11) DEFAULT NULL,
  `approved` int(11) DEFAULT '0',
  `createdat` datetime DEFAULT CURRENT_TIMESTAMP,
  `deleted` int(11) DEFAULT '0',
  `role` int(11) NOT NULL DEFAULT '2',
  `mobile` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Country_idx` (`countryid`),
  CONSTRAINT `fk_Country` FOREIGN KEY (`countryid`) REFERENCES `countries` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

-- Data exporting was unselected.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
