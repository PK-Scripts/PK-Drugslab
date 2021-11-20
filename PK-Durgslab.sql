-- --------------------------------------------------------
-- Host:                         91.238.92.65
-- Server version:               10.6.5-MariaDB-1:10.6.5+maria~bionic - mariadb.org binary distribution
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             10.2.0.5599
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for s4_CityTown
CREATE DATABASE IF NOT EXISTS `s4_CityTown` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `s4_CityTown`;

-- Dumping structure for table s4_CityTown.pk_drugslab
CREATE TABLE IF NOT EXISTS `pk_drugslab` (
  `owner` varchar(50) DEFAULT NULL,
  `id` varchar(50) NOT NULL DEFAULT '{}',
  `pos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`pos`)),
  `price` varchar(50) DEFAULT NULL,
  `shell` varchar(50) DEFAULT NULL,
  `pincode` varchar(50) DEFAULT NULL,
  `stash` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`stash`)),
  `witwaslevel` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dumping data for table s4_CityTown.pk_drugslab: ~7 rows (approximately)
/*!40000 ALTER TABLE `pk_drugslab` DISABLE KEYS */;
INSERT INTO `pk_drugslab` (`owner`, `id`, `pos`, `price`, `shell`, `pincode`, `stash`, `witwaslevel`) VALUES
	('b8ae76d2ae23c60e63721af23b742cc4a81cb1c5', 'PK-2072', '{"x":-590.2153930664063,"y":-1621.859375,"z":33.003662109375}', '0', 'k4weed_shell', '5636', '{}', 0),
	('3a0c02ff9409793b7116c79e80f09b196fd289e3', 'PK-6247', '{"x":1529.156005859375,"y":3794.940673828125,"z":34.4527587890625}', '100', 'k4weed_shell', '1423', '[{"name":"drugsbagweed","count":15,"label":"Zakje Weed"},{"name":"drugsbagcoke","count":10,"label":"Zakje Coke"}]', 0),
	('cc7cbb8560a3cdacfc9a71f4358d76185ae1ff4f', 'PK-7566', '{"x":-315.74505615234377,"y":-2698.628662109375,"z":7.5435791015625}', '100', 'k4weed_shell', '3214', '{}', 0),
	('3a0c02ff9409793b7116c79e80f09b196fd289e3', 'PK-8044', '{"x":-1146.751708984375,"y":4940.95361328125,"z":222.2608642578125}', '10', 'k4weed_shell', '1999', '{}', 0),
	('fa320d36006d22227eea65c56c68e0508c61d486', 'PK-8172', '{"x":-438.4483642578125,"y":-2184.25048828125,"z":10.5091552734375}', '10', 'k4coke_shell', '7410', '{}', 0),
	('fa320d36006d22227eea65c56c68e0508c61d486', 'PK-8558', '{"x":-445.0813293457031,"y":-2184.10546875,"z":10.4923095703125}', '10', 'k4weed_shell', '9630', '{}', 0),
	('1a5a942a877eadf68888d2e62f6da28106b060ba', 'PK-9116', '{"x":-448.74725341796877,"y":-2176.3515625,"z":11.4359130859375}', '1', 'k4meth_shell', '7410', '{}', 0);
/*!40000 ALTER TABLE `pk_drugslab` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
