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

-- Volcando estructura para tabla videogames.games
CREATE TABLE IF NOT EXISTS `games` (
  `name` varchar(100) NOT NULL,
  `platform` varchar(10) NOT NULL,
  `release_date` date DEFAULT NULL,
  `publisher` varchar(50) DEFAULT NULL,
  `developer` varchar(50) DEFAULT NULL,
  `edition` varchar(20) NOT NULL DEFAULT 'normal',
  `case` varchar(50) NOT NULL DEFAULT 'Completa',
  `manual` varchar(50) NOT NULL DEFAULT 'si',
  PRIMARY KEY (`name`,`platform`),
  KEY `FK_games_platforms` (`platform`),
  CONSTRAINT `FK_games_platforms` FOREIGN KEY (`platform`) REFERENCES `platforms` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para vista videogames.games_per_platform
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `games_per_platform` (
	`Game` VARCHAR(100) NOT NULL COLLATE 'utf8_general_ci',
	`platform` VARCHAR(10) NOT NULL COLLATE 'utf8_general_ci',
	`release_date` DATE NULL,
	`edition` VARCHAR(20) NOT NULL COLLATE 'utf8_general_ci'
) ENGINE=MyISAM;

-- Volcando estructura para tabla videogames.game_modes
CREATE TABLE IF NOT EXISTS `game_modes` (
  `game` varchar(100) NOT NULL,
  `mode` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`game`),
  CONSTRAINT `FK_game_modes_games` FOREIGN KEY (`game`) REFERENCES `games` (`name`)
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
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `games_per_platform` AS select `games`.`name` AS `Game`,`games`.`platform` AS `platform`,`games`.`release_date` AS `release_date`,`games`.`edition` AS `edition` from `games` where `games`.`platform` like `p1`();

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
