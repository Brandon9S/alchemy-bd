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

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `alchemy` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `alchemy`;

--
-- Table structure for table `carta_centro`
--

DROP TABLE IF EXISTS `carta_centro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carta_centro` (
  `id_centro` int NOT NULL,
  `id_receta` int NOT NULL,
  `fecha_alta` date NOT NULL,
  `disponible` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_centro`,`id_receta`),
  KEY `fk_carta_centro_recetas` (`id_receta`),
  CONSTRAINT `fk_carta_centro_centros` FOREIGN KEY (`id_centro`) REFERENCES `centros_consumo` (`id_centro`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_carta_centro_recetas` FOREIGN KEY (`id_receta`) REFERENCES `recetas` (`id_receta`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nombre_categoria` varchar(60) NOT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_categoria`),
  UNIQUE KEY `uq_categorias_nombre` (`nombre_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `centros_consumo`
--

DROP TABLE IF EXISTS `centros_consumo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `centros_consumo` (
  `id_centro` int NOT NULL AUTO_INCREMENT,
  `nombre_centro` varchar(100) NOT NULL,
  `ubicacion` varchar(100) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_centro`),
  UNIQUE KEY `uq_centros_consumo_nombre` (`nombre_centro`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ingredientes`
--

DROP TABLE IF EXISTS `ingredientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ingredientes` (
  `id_ingrediente` int NOT NULL AUTO_INCREMENT,
  `nombre_ingrediente` varchar(100) NOT NULL,
  `tipo` varchar(50) NOT NULL,
  `unidad_base` varchar(20) NOT NULL,
  `alcoholico` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_ingrediente`),
  UNIQUE KEY `uq_ingredientes_nombre` (`nombre_ingrediente`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `procedimientos`
--

DROP TABLE IF EXISTS `procedimientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `procedimientos` (
  `id_procedimiento` int NOT NULL AUTO_INCREMENT,
  `id_version` int NOT NULL,
  `numero_paso` smallint NOT NULL,
  `instruccion` varchar(500) NOT NULL,
  `duracion_segundos` smallint DEFAULT NULL,
  PRIMARY KEY (`id_procedimiento`),
  UNIQUE KEY `uq_procedimiento_paso` (`id_version`,`numero_paso`),
  CONSTRAINT `fk_procedimientos_versiones` FOREIGN KEY (`id_version`) REFERENCES `versiones_receta` (`id_version`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_procedimiento_duracion` CHECK (((`duracion_segundos` is null) or (`duracion_segundos` >= 0))),
  CONSTRAINT `chk_procedimiento_numero` CHECK ((`numero_paso` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `receta_ingrediente`
--

DROP TABLE IF EXISTS `receta_ingrediente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receta_ingrediente` (
  `id_receta` int NOT NULL,
  `id_ingrediente` int NOT NULL,
  `cantidad` decimal(8,2) NOT NULL,
  `observaciones` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_receta`,`id_ingrediente`),
  KEY `fk_receta_ingrediente_ingredientes` (`id_ingrediente`),
  CONSTRAINT `fk_receta_ingrediente_ingredientes` FOREIGN KEY (`id_ingrediente`) REFERENCES `ingredientes` (`id_ingrediente`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_receta_ingrediente_recetas` FOREIGN KEY (`id_receta`) REFERENCES `recetas` (`id_receta`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_receta_ingrediente_cantidad` CHECK ((`cantidad` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recetas`
--

DROP TABLE IF EXISTS `recetas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `recetas` (
  `id_receta` int NOT NULL AUTO_INCREMENT,
  `id_categoria` int NOT NULL,
  `nombre_receta` varchar(100) NOT NULL,
  `tecnica` varchar(50) NOT NULL,
  `alcoholica` tinyint(1) NOT NULL DEFAULT '1',
  `rendimiento_porciones` smallint NOT NULL DEFAULT '1',
  PRIMARY KEY (`id_receta`),
  UNIQUE KEY `uq_recetas_nombre` (`nombre_receta`),
  KEY `fk_recetas_categorias` (`id_categoria`),
  CONSTRAINT `fk_recetas_categorias` FOREIGN KEY (`id_categoria`) REFERENCES `categorias` (`id_categoria`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_recetas_rendimiento` CHECK ((`rendimiento_porciones` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `versiones_receta`
--

DROP TABLE IF EXISTS `versiones_receta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `versiones_receta` (
  `id_version` int NOT NULL AUTO_INCREMENT,
  `id_receta` int NOT NULL,
  `numero_version` smallint NOT NULL,
  `fecha_creacion` date NOT NULL,
  `vigente` tinyint(1) NOT NULL DEFAULT '1',
  `motivo_cambio` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_version`),
  UNIQUE KEY `uq_version_receta_numero` (`id_receta`,`numero_version`),
  CONSTRAINT `fk_versiones_recetas` FOREIGN KEY (`id_receta`) REFERENCES `recetas` (`id_receta`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_version_numero` CHECK ((`numero_version` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-06 12:25:50
