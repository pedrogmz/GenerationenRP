CREATE TABLE `svartamarknaden` (
  
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  
  PRIMARY KEY (`id`)
);

INSERT INTO `svartamarknaden` (name, item, price) VALUES
	('Svartamarknaden','grip',10000),
	('Svartamarknaden','yusuf',10000),
	('Svartamarknaden','flashlight',10000),
	('Svartamarknaden','silencieux',50000),
	('Svartamarknaden','drill',75000),
;