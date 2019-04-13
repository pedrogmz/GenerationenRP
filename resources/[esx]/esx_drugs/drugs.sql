CREATE TABLE IF NOT EXISTS `drug_farms` (
  `id` text,
  `type` text,
  `task` text,
  `tasksLeft` int(11) DEFAULT NULL,
  `delay` bigint(20) DEFAULT NULL
)

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
('weed_seed', 'Weed frö', 1, 0, 1),
('coke_ingredients', 'Koks Ingredienser', 1, 0, 1),
('meth_ingredients', 'Meth Ingredientsr', 1, 0, 1)