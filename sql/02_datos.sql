-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: alchemy
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `alchemy`
--

USE `alchemy`;

--
-- Dumping data for table `carta_centro`
--

LOCK TABLES `carta_centro` WRITE;
/*!40000 ALTER TABLE `carta_centro` DISABLE KEYS */;
INSERT INTO `carta_centro` VALUES (1,1,'2026-09-07',1),(1,2,'2026-09-07',1),(1,3,'2026-09-07',1),(1,4,'2026-09-07',1),(2,1,'2026-09-07',1),(2,2,'2026-09-07',1),(2,3,'2026-09-07',1),(2,5,'2026-09-07',1),(3,1,'2026-09-07',1),(3,2,'2026-09-07',1),(3,4,'2026-09-07',1),(3,6,'2026-09-07',1);
/*!40000 ALTER TABLE `carta_centro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (1,'Clásicos','Cócteles tradicionales de la barra'),(2,'Tropicales','Bebidas elaboradas con sabores tropicales'),(3,'Sin alcohol','Bebidas que no contienen alcohol');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `centros_consumo`
--

LOCK TABLES `centros_consumo` WRITE;
/*!40000 ALTER TABLE `centros_consumo` DISABLE KEYS */;
INSERT INTO `centros_consumo` VALUES (1,'Lobby Bar','Lobby',1),(2,'Pool Bar','Alberca',1),(3,'Sports Bar','Zona deportiva',1);
/*!40000 ALTER TABLE `centros_consumo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `ingredientes`
--

LOCK TABLES `ingredientes` WRITE;
/*!40000 ALTER TABLE `ingredientes` DISABLE KEYS */;
INSERT INTO `ingredientes` VALUES (1,'Tequila blanco','Destilado','ml',1),(2,'Licor de naranja','Licor','ml',1),(3,'Jugo de limón','Jugo','ml',0),(4,'Jarabe simple','Endulzante','ml',0),(5,'Ron blanco','Destilado','ml',1),(6,'Hierbabuena','Hierba','hojas',0),(7,'Agua mineral','Mezclador','ml',0),(8,'Crema de coco','Crema','ml',0),(9,'Jugo de piña','Jugo','ml',0),(10,'Refresco de jengibre','Refresco','ml',0),(11,'Granadina','Jarabe','ml',0),(12,'Cereza','Garnitura','pieza',0),(13,'Sal fina','Condimento','g',0);
/*!40000 ALTER TABLE `ingredientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `procedimientos`
--

LOCK TABLES `procedimientos` WRITE;
/*!40000 ALTER TABLE `procedimientos` DISABLE KEYS */;
INSERT INTO `procedimientos` VALUES (1,1,1,'Agregar tequila, licor de naranja, jugo de limón y jarabe a la coctelera.',30),(2,1,2,'Agregar hielo y agitar los ingredientes.',15),(3,1,3,'Colar y servir en una copa.',20),(4,2,1,'Colocar hierbabuena, jarabe y jugo de limón en el vaso.',30),(5,2,2,'Agregar ron blanco y hielo.',20),(6,2,3,'Completar con agua mineral y mezclar suavemente.',15),(7,3,1,'Agregar ron, jugo de limón y jarabe a la coctelera.',20),(8,3,2,'Agregar hielo y agitar.',15),(9,3,3,'Colar y servir en una copa fria.',15),(10,4,1,'Agregar ron, crema de coco y jugo de piña a la licuadora.',20),(11,4,2,'Agregar hielo y licuar hasta obtener una mezcla uniforme.',30),(12,4,3,'Servir la mezcla en un vaso.',15),(13,5,1,'Agregar jugo de limón y jarabe al vaso.',15),(14,5,2,'Agregar hielo y completar con agua mineral.',15),(15,5,3,'Mezclar suavemente.',10),(16,6,1,'Agregar la granadina al vaso.',10),(17,6,2,'Agregar hielo y completar con refresco de jengibre.',15),(18,6,3,'Decorar con una cereza.',10);
/*!40000 ALTER TABLE `procedimientos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `receta_ingrediente`
--

LOCK TABLES `receta_ingrediente` WRITE;
/*!40000 ALTER TABLE `receta_ingrediente` DISABLE KEYS */;
INSERT INTO `receta_ingrediente` VALUES (1,1,50.00,NULL),(1,2,20.00,NULL),(1,3,25.00,NULL),(1,4,10.00,NULL),(1,13,2.00,'Escarchar vaso'),(2,3,25.00,NULL),(2,4,15.00,NULL),(2,5,50.00,NULL),(2,6,8.00,NULL),(2,7,60.00,NULL),(3,3,25.00,NULL),(3,4,15.00,NULL),(3,5,50.00,NULL),(4,5,50.00,NULL),(4,8,40.00,NULL),(4,9,80.00,NULL),(5,3,30.00,NULL),(5,4,15.00,NULL),(5,7,150.00,NULL),(6,10,150.00,NULL),(6,11,15.00,NULL),(6,12,1.00,NULL);
/*!40000 ALTER TABLE `receta_ingrediente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `recetas`
--

LOCK TABLES `recetas` WRITE;
/*!40000 ALTER TABLE `recetas` DISABLE KEYS */;
INSERT INTO `recetas` VALUES (1,1,'Margarita','Agitado',1,1),(2,1,'Mojito','Directo',1,1),(3,1,'Daiquiri','Agitado',1,1),(4,2,'Piña Colada','Licuado',1,1),(5,3,'Limonada mineral','Directo',0,1),(6,3,'Shirley Temple','Directo',0,1);
/*!40000 ALTER TABLE `recetas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `versiones_receta`
--

LOCK TABLES `versiones_receta` WRITE;
/*!40000 ALTER TABLE `versiones_receta` DISABLE KEYS */;
INSERT INTO `versiones_receta` VALUES (1,1,1,'2026-09-07',1,'Versión inicial'),(2,2,1,'2026-09-07',1,'Versión inicial'),(3,3,1,'2026-09-07',1,'Versión inicial'),(4,4,1,'2026-09-07',1,'Versión inicial'),(5,5,1,'2026-09-07',1,'Versión inicial'),(6,6,1,'2026-09-07',1,'Versión inicial');
/*!40000 ALTER TABLE `versiones_receta` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06 12:28:43
