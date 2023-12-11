CREATE TABLE IF NOT EXISTS `gangmenu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gang` text DEFAULT NULL,
  `balance` int(11) NOT NULL DEFAULT 0,
  `safelv` int(11) DEFAULT NULL,
  `securitylv` int(11) DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `last_updated` (`last_updated`)
) ENGINE=InnoDB AUTO_INCREMENT=1;

CREATE TABLE IF NOT EXISTS `gangtransactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gang` text DEFAULT NULL,
  `name` text DEFAULT NULL,
  `type` text DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `last_updated` (`last_updated`)
) ENGINE=InnoDB AUTO_INCREMENT=1;