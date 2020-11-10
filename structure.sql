-- --------------------------------------------------------
-- Host:                         192.168.1.139
-- Versión del servidor:         10.3.17-MariaDB-0+deb10u1 - Raspbian 10
-- SO del servidor:              debian-linux-gnueabihf
-- HeidiSQL Versión:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Volcando estructura de base de datos para videogames
CREATE DATABASE IF NOT EXISTS `videogames` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `videogames`;

-- Volcando estructura para tabla videogames.developer
CREATE TABLE IF NOT EXISTS `developer` (
  `game` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '""',
  `developer` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '""',
  PRIMARY KEY (`game`,`developer`) USING BTREE,
  CONSTRAINT `FK_developer_games` FOREIGN KEY (`game`) REFERENCES `games` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla videogames.games
CREATE TABLE IF NOT EXISTS `games` (
  `name` varchar(100) NOT NULL,
  `platform` varchar(10) NOT NULL,
  `release_date` date DEFAULT NULL,
  `edition` varchar(20) NOT NULL DEFAULT 'normal',
  `case` varchar(50) NOT NULL DEFAULT 'Completa',
  `manual` varchar(50) NOT NULL DEFAULT 'si',
  `ESRB` varchar(15) DEFAULT NULL,
  `PEGI` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`name`,`platform`),
  KEY `FK_games_platforms` (`platform`),
  CONSTRAINT `FK_games_platforms` FOREIGN KEY (`platform`) REFERENCES `platforms` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Deca Sports Extreme = Sport Island 3D';

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para vista videogames.games_per_platform
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `games_per_platform` (
	`Game` VARCHAR(100) NOT NULL COLLATE 'utf8_general_ci',
	`Platform` VARCHAR(10) NOT NULL COLLATE 'utf8_general_ci',
	`Release date` DATE NULL,
	`Edition` VARCHAR(20) NOT NULL COLLATE 'utf8_general_ci',
	`Case` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`Manual` VARCHAR(50) NOT NULL COLLATE 'utf8_general_ci',
	`Rating` VARCHAR(15) NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;

-- Volcando estructura para tabla videogames.game_modes
CREATE TABLE IF NOT EXISTS `game_modes` (
  `game` varchar(100) NOT NULL,
  `mode` varchar(50) NOT NULL DEFAULT 'f',
  PRIMARY KEY (`game`,`mode`),
  KEY `Índice 1` (`game`),
  CONSTRAINT `FK_game_modes_games` FOREIGN KEY (`game`) REFERENCES `games` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla videogames.genre
CREATE TABLE IF NOT EXISTS `genre` (
  `game` varchar(100) NOT NULL,
  `genre` varchar(100) NOT NULL DEFAULT 'f',
  PRIMARY KEY (`genre`,`game`) USING BTREE,
  KEY `FK_genre_games` (`game`),
  CONSTRAINT `FK_genre_games` FOREIGN KEY (`game`) REFERENCES `games` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla videogames.hardware
CREATE TABLE IF NOT EXISTS `hardware` (
  `name` varchar(50) NOT NULL,
  `model` varchar(30) NOT NULL,
  `serial` varchar(20) DEFAULT NULL,
  `platform` varchar(10) NOT NULL,
  PRIMARY KEY (`name`,`model`,`platform`),
  KEY `platform` (`platform`),
  CONSTRAINT `hardware_ibfk_1` FOREIGN KEY (`platform`) REFERENCES `platforms` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para función videogames.p1
DELIMITER //
CREATE FUNCTION `p1`() RETURNS varchar(10) CHARSET utf8
RETURN @p1//
DELIMITER ;

-- Volcando estructura para tabla videogames.platforms
CREATE TABLE IF NOT EXISTS `platforms` (
  `name` varchar(10) NOT NULL,
  `owned` int(11) NOT NULL DEFAULT 0,
  `release_date` date DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla videogames.publisher
CREATE TABLE IF NOT EXISTS `publisher` (
  `game` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '""',
  `publisher` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '""',
  PRIMARY KEY (`game`,`publisher`),
  CONSTRAINT `FK__games` FOREIGN KEY (`game`) REFERENCES `games` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla videogames.traduction
CREATE TABLE IF NOT EXISTS `traduction` (
  `name` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '',
  `traduction` varchar(100) CHARACTER SET utf8 NOT NULL DEFAULT '""',
  `language` varchar(30) CHARACTER SET utf8 NOT NULL DEFAULT 'SPANISH',
  PRIMARY KEY (`name`,`traduction`),
  CONSTRAINT `FK_traduction_games` FOREIGN KEY (`name`) REFERENCES `games` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para procedimiento videogames.update_platform
DELIMITER //
CREATE PROCEDURE `update_platform`(
	IN `c` VARCHAR(20)






)
BEGIN 
		declare currentOwn varchar(20);
		set currentOwn = (select count(*) from games where platform like c);
		UPDATE platforms SET `owned` = currentOwn WHERE `name` LIKE c;
	END//
DELIMITER ;

-- Volcando estructura para disparador videogames.update_platform_trigger
SET @OLDTMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
DELIMITER //
CREATE TRIGGER `update_platform_trigger` AFTER INSERT ON `games` FOR EACH ROW BEGIN 
		CALL update_platform(new.platform);
	END//
DELIMITER ;
SET SQL_MODE=@OLDTMP_SQL_MODE;

-- Volcando estructura para vista videogames.games_per_platform
-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `games_per_platform`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `games_per_platform` AS select `games`.`name` AS `Game`,`games`.`platform` AS `Platform`,`games`.`release_date` AS `Release date`,`games`.`edition` AS `Edition`,`games`.`case` AS `Case`,`games`.`manual` AS `Manual`,`games`.`PEGI` AS `Rating` from `games` where `games`.`platform` like `p1`();

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
