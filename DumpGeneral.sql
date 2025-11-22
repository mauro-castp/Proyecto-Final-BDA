/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ProyectoFinalBDA
-- ------------------------------------------------------
-- Server version	10.11.14-MariaDB-0+deb12u2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `acciones_auditoria`
--

DROP TABLE IF EXISTS `acciones_auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `acciones_auditoria` (
  `id_accion` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_accion` varchar(20) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `id_estado` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_accion`),
  UNIQUE KEY `nombre_accion` (`nombre_accion`),
  KEY `id_estado` (`id_estado`),
  CONSTRAINT `acciones_auditoria_ibfk_1` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `acciones_auditoria`
--

LOCK TABLES `acciones_auditoria` WRITE;
/*!40000 ALTER TABLE `acciones_auditoria` DISABLE KEYS */;
/*!40000 ALTER TABLE `acciones_auditoria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aud_entregas`
--

DROP TABLE IF EXISTS `aud_entregas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `aud_entregas` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `id_entrega` int(11) DEFAULT NULL,
  `accion` varchar(10) DEFAULT NULL,
  `valores_anteriores` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`valores_anteriores`)),
  `valores_nuevos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`valores_nuevos`)),
  `usuario` varchar(100) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aud_entregas`
--

LOCK TABLES `aud_entregas` WRITE;
/*!40000 ALTER TABLE `aud_entregas` DISABLE KEYS */;
/*!40000 ALTER TABLE `aud_entregas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aud_incidencias`
--

DROP TABLE IF EXISTS `aud_incidencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `aud_incidencias` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `id_incidencia` int(11) DEFAULT NULL,
  `accion` varchar(10) DEFAULT NULL,
  `valores_anteriores` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`valores_anteriores`)),
  `valores_nuevos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`valores_nuevos`)),
  `usuario` varchar(100) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aud_incidencias`
--

LOCK TABLES `aud_incidencias` WRITE;
/*!40000 ALTER TABLE `aud_incidencias` DISABLE KEYS */;
/*!40000 ALTER TABLE `aud_incidencias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aud_pedidos`
--

DROP TABLE IF EXISTS `aud_pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `aud_pedidos` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `id_pedido` int(11) DEFAULT NULL,
  `accion` varchar(10) DEFAULT NULL,
  `valores_anteriores` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`valores_anteriores`)),
  `valores_nuevos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`valores_nuevos`)),
  `usuario` varchar(100) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aud_pedidos`
--

LOCK TABLES `aud_pedidos` WRITE;
/*!40000 ALTER TABLE `aud_pedidos` DISABLE KEYS */;
/*!40000 ALTER TABLE `aud_pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `aud_rutas`
--

DROP TABLE IF EXISTS `aud_rutas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `aud_rutas` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `id_ruta` int(11) DEFAULT NULL,
  `accion` varchar(10) DEFAULT NULL,
  `valores_anteriores` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`valores_anteriores`)),
  `valores_nuevos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`valores_nuevos`)),
  `usuario` varchar(100) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aud_rutas`
--

LOCK TABLES `aud_rutas` WRITE;
/*!40000 ALTER TABLE `aud_rutas` DISABLE KEYS */;
/*!40000 ALTER TABLE `aud_rutas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `id_cliente` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `id_estado` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_cliente`),
  KEY `id_estado` (`id_estado`),
  CONSTRAINT `clientes_ibfk_1` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `costos_operativos`
--

DROP TABLE IF EXISTS `costos_operativos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `costos_operativos` (
  `id_costo` int(11) NOT NULL AUTO_INCREMENT,
  `id_vehiculo` int(11) NOT NULL,
  `id_ruta` int(11) DEFAULT NULL,
  `id_tipo_costo` int(11) NOT NULL,
  `monto` decimal(10,2) NOT NULL,
  `distancia_km` decimal(8,2) DEFAULT 0.00,
  `fecha_costo` date NOT NULL,
  `descripcion` text DEFAULT NULL,
  `evidencia_foto` text DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_costo`),
  KEY `id_vehiculo` (`id_vehiculo`),
  KEY `id_ruta` (`id_ruta`),
  KEY `id_tipo_costo` (`id_tipo_costo`),
  CONSTRAINT `costos_operativos_ibfk_1` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id_vehiculo`),
  CONSTRAINT `costos_operativos_ibfk_2` FOREIGN KEY (`id_ruta`) REFERENCES `rutas` (`id_ruta`),
  CONSTRAINT `costos_operativos_ibfk_3` FOREIGN KEY (`id_tipo_costo`) REFERENCES `tipos_costo` (`id_tipo_costo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `costos_operativos`
--

LOCK TABLES `costos_operativos` WRITE;
/*!40000 ALTER TABLE `costos_operativos` DISABLE KEYS */;
/*!40000 ALTER TABLE `costos_operativos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalle_pedido`
--

DROP TABLE IF EXISTS `detalle_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalle_pedido` (
  `id_detalle` int(11) NOT NULL AUTO_INCREMENT,
  `id_pedido` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  PRIMARY KEY (`id_detalle`),
  KEY `id_pedido` (`id_pedido`),
  KEY `id_producto` (`id_producto`),
  CONSTRAINT `detalle_pedido_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`),
  CONSTRAINT `detalle_pedido_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_pedido`
--

LOCK TABLES `detalle_pedido` WRITE;
/*!40000 ALTER TABLE `detalle_pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalle_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `direcciones_cliente`
--

DROP TABLE IF EXISTS `direcciones_cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `direcciones_cliente` (
  `id_direccion` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) NOT NULL,
  `direccion` text NOT NULL,
  `id_zona` int(11) NOT NULL,
  `es_principal` tinyint(1) DEFAULT 0,
  `id_estado` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_geo` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_direccion`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_zona` (`id_zona`),
  KEY `id_estado` (`id_estado`),
  KEY `fk_direcciones_geo` (`id_geo`),
  CONSTRAINT `direcciones_cliente_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE CASCADE,
  CONSTRAINT `direcciones_cliente_ibfk_2` FOREIGN KEY (`id_zona`) REFERENCES `zonas` (`id_zona`),
  CONSTRAINT `direcciones_cliente_ibfk_3` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`),
  CONSTRAINT `fk_direcciones_geo` FOREIGN KEY (`id_geo`) REFERENCES `geolocalizacion` (`id_geo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direcciones_cliente`
--

LOCK TABLES `direcciones_cliente` WRITE;
/*!40000 ALTER TABLE `direcciones_cliente` DISABLE KEYS */;
/*!40000 ALTER TABLE `direcciones_cliente` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entidades`
--

DROP TABLE IF EXISTS `entidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `entidades` (
  `id_entidad` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_entidad` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `id_estado` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_entidad`),
  UNIQUE KEY `nombre_entidad` (`nombre_entidad`),
  KEY `id_estado` (`id_estado`),
  CONSTRAINT `entidades_ibfk_1` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entidades`
--

LOCK TABLES `entidades` WRITE;
/*!40000 ALTER TABLE `entidades` DISABLE KEYS */;
/*!40000 ALTER TABLE `entidades` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `entregas`
--

DROP TABLE IF EXISTS `entregas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `entregas` (
  `id_entrega` int(11) NOT NULL AUTO_INCREMENT,
  `id_pedido` int(11) NOT NULL,
  `id_ruta` int(11) NOT NULL,
  `id_repartidor` int(11) NOT NULL,
  `id_estado_entrega` int(11) NOT NULL,
  `fecha_estimada_entrega` timestamp NULL DEFAULT NULL,
  `fecha_real_entrega` timestamp NULL DEFAULT NULL,
  `hora_inicio_entrega` timestamp NULL DEFAULT NULL,
  `hora_fin_entrega` timestamp NULL DEFAULT NULL,
  `tiempo_entrega_minutos` int(11) DEFAULT 0,
  `reintentos` int(11) DEFAULT 0,
  `cumplio_sla` tinyint(1) DEFAULT 0,
  `fue_tarde` tinyint(1) DEFAULT 0,
  `costo_entrega` decimal(8,2) DEFAULT 0.00,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_motivo_fallo` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_entrega`),
  KEY `id_pedido` (`id_pedido`),
  KEY `id_ruta` (`id_ruta`),
  KEY `id_repartidor` (`id_repartidor`),
  KEY `fk_entregas_estado` (`id_estado_entrega`),
  KEY `fk_entregas_motivo` (`id_motivo_fallo`),
  CONSTRAINT `entregas_ibfk_1` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`),
  CONSTRAINT `entregas_ibfk_2` FOREIGN KEY (`id_ruta`) REFERENCES `rutas` (`id_ruta`),
  CONSTRAINT `entregas_ibfk_3` FOREIGN KEY (`id_repartidor`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `fk_entregas_estado` FOREIGN KEY (`id_estado_entrega`) REFERENCES `estados_entrega` (`id_estado_entrega`),
  CONSTRAINT `fk_entregas_motivo` FOREIGN KEY (`id_motivo_fallo`) REFERENCES `motivos_fallo` (`id_motivo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entregas`
--

LOCK TABLES `entregas` WRITE;
/*!40000 ALTER TABLE `entregas` DISABLE KEYS */;
/*!40000 ALTER TABLE `entregas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados`
--

DROP TABLE IF EXISTS `estados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados` (
  `id_estado` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_estado`),
  UNIQUE KEY `nombre_estado` (`nombre_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados`
--

LOCK TABLES `estados` WRITE;
/*!40000 ALTER TABLE `estados` DISABLE KEYS */;
INSERT INTO `estados` VALUES
(1,'activo','Elemento activo en el sistema','2025-11-16 02:10:50'),
(2,'inactivo','Elemento inactivo en el sistema','2025-11-16 02:10:50');
/*!40000 ALTER TABLE `estados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_entidad`
--

DROP TABLE IF EXISTS `estados_entidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_entidad` (
  `id_estado_entidad` int(11) NOT NULL AUTO_INCREMENT,
  `id_entidad` int(11) NOT NULL,
  `id_estado` int(11) NOT NULL,
  `orden` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_estado_entidad`),
  UNIQUE KEY `uk_entidad_estado` (`id_entidad`,`id_estado`),
  KEY `id_estado` (`id_estado`),
  CONSTRAINT `estados_entidad_ibfk_1` FOREIGN KEY (`id_entidad`) REFERENCES `entidades` (`id_entidad`),
  CONSTRAINT `estados_entidad_ibfk_2` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_entidad`
--

LOCK TABLES `estados_entidad` WRITE;
/*!40000 ALTER TABLE `estados_entidad` DISABLE KEYS */;
/*!40000 ALTER TABLE `estados_entidad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_entrega`
--

DROP TABLE IF EXISTS `estados_entrega`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_entrega` (
  `id_estado_entrega` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_estado_entrega`),
  UNIQUE KEY `nombre_estado` (`nombre_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_entrega`
--

LOCK TABLES `estados_entrega` WRITE;
/*!40000 ALTER TABLE `estados_entrega` DISABLE KEYS */;
/*!40000 ALTER TABLE `estados_entrega` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_incidencia`
--

DROP TABLE IF EXISTS `estados_incidencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_incidencia` (
  `id_estado_incidencia` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_estado_incidencia`),
  UNIQUE KEY `nombre_estado` (`nombre_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_incidencia`
--

LOCK TABLES `estados_incidencia` WRITE;
/*!40000 ALTER TABLE `estados_incidencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `estados_incidencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_parada`
--

DROP TABLE IF EXISTS `estados_parada`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_parada` (
  `id_estado_parada` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_estado_parada`),
  UNIQUE KEY `nombre_estado` (`nombre_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_parada`
--

LOCK TABLES `estados_parada` WRITE;
/*!40000 ALTER TABLE `estados_parada` DISABLE KEYS */;
/*!40000 ALTER TABLE `estados_parada` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_pedido`
--

DROP TABLE IF EXISTS `estados_pedido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_pedido` (
  `id_estado_pedido` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_estado_pedido`),
  UNIQUE KEY `nombre_estado` (`nombre_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_pedido`
--

LOCK TABLES `estados_pedido` WRITE;
/*!40000 ALTER TABLE `estados_pedido` DISABLE KEYS */;
/*!40000 ALTER TABLE `estados_pedido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_ruta`
--

DROP TABLE IF EXISTS `estados_ruta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_ruta` (
  `id_estado_ruta` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_estado_ruta`),
  UNIQUE KEY `nombre_estado` (`nombre_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_ruta`
--

LOCK TABLES `estados_ruta` WRITE;
/*!40000 ALTER TABLE `estados_ruta` DISABLE KEYS */;
/*!40000 ALTER TABLE `estados_ruta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estados_vehiculo`
--

DROP TABLE IF EXISTS `estados_vehiculo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_vehiculo` (
  `id_estado_vehiculo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `id_estado` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_estado_vehiculo`),
  UNIQUE KEY `nombre_estado` (`nombre_estado`),
  KEY `id_estado` (`id_estado`),
  CONSTRAINT `estados_vehiculo_ibfk_1` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_vehiculo`
--

LOCK TABLES `estados_vehiculo` WRITE;
/*!40000 ALTER TABLE `estados_vehiculo` DISABLE KEYS */;
/*!40000 ALTER TABLE `estados_vehiculo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `evidencias`
--

DROP TABLE IF EXISTS `evidencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `evidencias` (
  `id_evidencia` int(11) NOT NULL AUTO_INCREMENT,
  `id_entrega` int(11) NOT NULL,
  `tipo` enum('foto','firma') NOT NULL,
  `url` text NOT NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_evidencia`),
  KEY `id_entrega` (`id_entrega`),
  CONSTRAINT `evidencias_ibfk_1` FOREIGN KEY (`id_entrega`) REFERENCES `entregas` (`id_entrega`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evidencias`
--

LOCK TABLES `evidencias` WRITE;
/*!40000 ALTER TABLE `evidencias` DISABLE KEYS */;
/*!40000 ALTER TABLE `evidencias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `geolocalizacion`
--

DROP TABLE IF EXISTS `geolocalizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `geolocalizacion` (
  `id_geo` int(11) NOT NULL AUTO_INCREMENT,
  `latitud` decimal(10,8) NOT NULL,
  `longitud` decimal(11,8) NOT NULL,
  PRIMARY KEY (`id_geo`),
  UNIQUE KEY `latitud` (`latitud`,`longitud`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `geolocalizacion`
--

LOCK TABLES `geolocalizacion` WRITE;
/*!40000 ALTER TABLE `geolocalizacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `geolocalizacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `incidencias`
--

DROP TABLE IF EXISTS `incidencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `incidencias` (
  `id_incidencia` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo_incidencia` int(11) NOT NULL,
  `id_zona` int(11) NOT NULL,
  `descripcion` text NOT NULL,
  `fecha_inicio` timestamp NOT NULL,
  `fecha_fin` timestamp NULL DEFAULT NULL,
  `id_estado_incidencia` int(11) NOT NULL,
  `id_nivel_impacto` int(11) NOT NULL,
  `radio_afectacion_km` decimal(5,2) DEFAULT 0.00,
  `id_usuario_reporta` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_geo` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_incidencia`),
  KEY `id_tipo_incidencia` (`id_tipo_incidencia`),
  KEY `id_zona` (`id_zona`),
  KEY `id_nivel_impacto` (`id_nivel_impacto`),
  KEY `id_usuario_reporta` (`id_usuario_reporta`),
  KEY `fk_incidencias_estado` (`id_estado_incidencia`),
  KEY `fk_incidencias_geo` (`id_geo`),
  CONSTRAINT `fk_incidencias_estado` FOREIGN KEY (`id_estado_incidencia`) REFERENCES `estados_incidencia` (`id_estado_incidencia`),
  CONSTRAINT `fk_incidencias_geo` FOREIGN KEY (`id_geo`) REFERENCES `geolocalizacion` (`id_geo`),
  CONSTRAINT `incidencias_ibfk_1` FOREIGN KEY (`id_tipo_incidencia`) REFERENCES `tipos_incidencia` (`id_tipo_incidencia`),
  CONSTRAINT `incidencias_ibfk_2` FOREIGN KEY (`id_zona`) REFERENCES `zonas` (`id_zona`),
  CONSTRAINT `incidencias_ibfk_4` FOREIGN KEY (`id_nivel_impacto`) REFERENCES `niveles_impacto` (`id_nivel_impacto`),
  CONSTRAINT `incidencias_ibfk_5` FOREIGN KEY (`id_usuario_reporta`) REFERENCES `usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incidencias`
--

LOCK TABLES `incidencias` WRITE;
/*!40000 ALTER TABLE `incidencias` DISABLE KEYS */;
/*!40000 ALTER TABLE `incidencias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `motivos_fallo`
--

DROP TABLE IF EXISTS `motivos_fallo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `motivos_fallo` (
  `id_motivo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  PRIMARY KEY (`id_motivo`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `motivos_fallo`
--

LOCK TABLES `motivos_fallo` WRITE;
/*!40000 ALTER TABLE `motivos_fallo` DISABLE KEYS */;
INSERT INTO `motivos_fallo` VALUES
(5,'Acceso restringido'),
(1,'Cliente ausente'),
(6,'Clima adverso'),
(2,'Direccion incorrecta'),
(9,'Error del repartidor'),
(8,'Incidencia de transito'),
(10,'Otro'),
(3,'Paquete rechazado'),
(7,'Vehiculo descompuesto'),
(4,'Zona insegura');
/*!40000 ALTER TABLE `motivos_fallo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `niveles_impacto`
--

DROP TABLE IF EXISTS `niveles_impacto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `niveles_impacto` (
  `id_nivel_impacto` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_nivel` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `id_estado` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_nivel_impacto`),
  UNIQUE KEY `nombre_nivel` (`nombre_nivel`),
  KEY `id_estado` (`id_estado`),
  CONSTRAINT `niveles_impacto_ibfk_1` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `niveles_impacto`
--

LOCK TABLES `niveles_impacto` WRITE;
/*!40000 ALTER TABLE `niveles_impacto` DISABLE KEYS */;
/*!40000 ALTER TABLE `niveles_impacto` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otp`
--

DROP TABLE IF EXISTS `otp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `otp` (
  `id_otp` int(11) NOT NULL AUTO_INCREMENT,
  `id_entrega` int(11) NOT NULL,
  `codigo` varchar(10) NOT NULL,
  `verificado` tinyint(1) DEFAULT 0,
  `fecha_generado` timestamp NULL DEFAULT current_timestamp(),
  `fecha_verificado` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_otp`),
  KEY `id_entrega` (`id_entrega`),
  CONSTRAINT `otp_ibfk_1` FOREIGN KEY (`id_entrega`) REFERENCES `entregas` (`id_entrega`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp`
--

LOCK TABLES `otp` WRITE;
/*!40000 ALTER TABLE `otp` DISABLE KEYS */;
/*!40000 ALTER TABLE `otp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paradas_ruta`
--

DROP TABLE IF EXISTS `paradas_ruta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `paradas_ruta` (
  `id_parada` int(11) NOT NULL AUTO_INCREMENT,
  `id_ruta` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `orden_secuencia` int(11) NOT NULL,
  `id_estado_parada` int(11) NOT NULL,
  `distancia_desde_inicio_km` decimal(8,2) DEFAULT 0.00,
  `tiempo_estimado_desde_inicio_min` int(11) DEFAULT 0,
  `fecha_estimada_entrega` timestamp NULL DEFAULT NULL,
  `fecha_real_entrega` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id_parada`),
  KEY `id_ruta` (`id_ruta`),
  KEY `id_pedido` (`id_pedido`),
  KEY `fk_paradas_estado` (`id_estado_parada`),
  CONSTRAINT `fk_paradas_estado` FOREIGN KEY (`id_estado_parada`) REFERENCES `estados_parada` (`id_estado_parada`),
  CONSTRAINT `paradas_ruta_ibfk_1` FOREIGN KEY (`id_ruta`) REFERENCES `rutas` (`id_ruta`),
  CONSTRAINT `paradas_ruta_ibfk_2` FOREIGN KEY (`id_pedido`) REFERENCES `pedidos` (`id_pedido`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paradas_ruta`
--

LOCK TABLES `paradas_ruta` WRITE;
/*!40000 ALTER TABLE `paradas_ruta` DISABLE KEYS */;
/*!40000 ALTER TABLE `paradas_ruta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `id_pedido` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) NOT NULL,
  `id_direccion_entrega` int(11) NOT NULL,
  `id_estado_pedido` int(11) NOT NULL,
  `fecha_pedido` timestamp NULL DEFAULT current_timestamp(),
  `fecha_estimada_entrega` timestamp NULL DEFAULT NULL,
  `fecha_real_entrega` timestamp NULL DEFAULT NULL,
  `motivo_cancelacion` text DEFAULT NULL,
  `penalizacion_cancelacion` decimal(10,2) DEFAULT 0.00,
  `total_pedido` decimal(12,2) NOT NULL,
  `peso_total` decimal(8,2) NOT NULL,
  `volumen_total` decimal(8,4) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_pedido`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_direccion_entrega` (`id_direccion_entrega`),
  KEY `fk_pedidos_estado` (`id_estado_pedido`),
  CONSTRAINT `fk_pedidos_estado` FOREIGN KEY (`id_estado_pedido`) REFERENCES `estados_pedido` (`id_estado_pedido`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  CONSTRAINT `pedidos_ibfk_2` FOREIGN KEY (`id_direccion_entrega`) REFERENCES `direcciones_cliente` (`id_direccion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `penalizaciones`
--

DROP TABLE IF EXISTS `penalizaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `penalizaciones` (
  `id_penalizacion` int(11) NOT NULL AUTO_INCREMENT,
  `id_entrega` int(11) NOT NULL,
  `id_tipo_penalizacion` int(11) NOT NULL,
  `monto` decimal(10,2) NOT NULL DEFAULT 0.00,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_penalizacion`),
  KEY `id_entrega` (`id_entrega`),
  KEY `id_tipo_penalizacion` (`id_tipo_penalizacion`),
  CONSTRAINT `penalizaciones_ibfk_1` FOREIGN KEY (`id_entrega`) REFERENCES `entregas` (`id_entrega`),
  CONSTRAINT `penalizaciones_ibfk_2` FOREIGN KEY (`id_tipo_penalizacion`) REFERENCES `tipos_penalizacion` (`id_tipo_penalizacion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `penalizaciones`
--

LOCK TABLES `penalizaciones` WRITE;
/*!40000 ALTER TABLE `penalizaciones` DISABLE KEYS */;
/*!40000 ALTER TABLE `penalizaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productos`
--

DROP TABLE IF EXISTS `productos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `peso_kg` decimal(8,2) NOT NULL,
  `volumen_m3` decimal(8,4) NOT NULL,
  `precio_unitario` decimal(10,2) NOT NULL,
  `id_estado` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_producto`),
  KEY `id_estado` (`id_estado`),
  CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id_rol` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_rol` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `id_estado` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `nombre_rol` (`nombre_rol`),
  KEY `id_estado` (`id_estado`),
  CONSTRAINT `roles_ibfk_1` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES
(9,'Admin','Acceso total al sistema',1,'2025-11-16 02:11:00'),
(10,'Planificador','Gestiona rutas, pedidos y asignaciones',1,'2025-11-16 02:11:00'),
(11,'Repartidor','Solo ve y confirma sus entregas',1,'2025-11-16 02:11:00'),
(12,'Auditor','Consulta reportes y auditorías',1,'2025-11-16 02:11:00');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rutas`
--

DROP TABLE IF EXISTS `rutas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `rutas` (
  `id_ruta` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_ruta` varchar(100) NOT NULL,
  `id_zona` int(11) NOT NULL,
  `fecha_ruta` date NOT NULL,
  `id_vehiculo` int(11) NOT NULL,
  `id_repartidor` int(11) NOT NULL,
  `id_estado_ruta` int(11) NOT NULL,
  `distancia_total_km` decimal(8,2) DEFAULT 0.00,
  `tiempo_estimado_minutos` int(11) DEFAULT 0,
  `costo_estimado` decimal(10,2) DEFAULT 0.00,
  `costo_real` decimal(10,2) DEFAULT 0.00,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_ruta`),
  KEY `id_vehiculo` (`id_vehiculo`),
  KEY `id_repartidor` (`id_repartidor`),
  KEY `id_zona` (`id_zona`),
  KEY `fk_rutas_estado` (`id_estado_ruta`),
  CONSTRAINT `fk_rutas_estado` FOREIGN KEY (`id_estado_ruta`) REFERENCES `estados_ruta` (`id_estado_ruta`),
  CONSTRAINT `rutas_ibfk_1` FOREIGN KEY (`id_vehiculo`) REFERENCES `vehiculos` (`id_vehiculo`),
  CONSTRAINT `rutas_ibfk_2` FOREIGN KEY (`id_repartidor`) REFERENCES `usuarios` (`id_usuario`),
  CONSTRAINT `rutas_ibfk_4` FOREIGN KEY (`id_zona`) REFERENCES `zonas` (`id_zona`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rutas`
--

LOCK TABLES `rutas` WRITE;
/*!40000 ALTER TABLE `rutas` DISABLE KEYS */;
/*!40000 ALTER TABLE `rutas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_costo`
--

DROP TABLE IF EXISTS `tipos_costo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_costo` (
  `id_tipo_costo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_tipo` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `id_estado` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_tipo_costo`),
  UNIQUE KEY `nombre_tipo` (`nombre_tipo`),
  KEY `id_estado` (`id_estado`),
  CONSTRAINT `tipos_costo_ibfk_1` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_costo`
--

LOCK TABLES `tipos_costo` WRITE;
/*!40000 ALTER TABLE `tipos_costo` DISABLE KEYS */;
/*!40000 ALTER TABLE `tipos_costo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_incidencia`
--

DROP TABLE IF EXISTS `tipos_incidencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_incidencia` (
  `id_tipo_incidencia` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_tipo` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `id_estado` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_tipo_incidencia`),
  UNIQUE KEY `nombre_tipo` (`nombre_tipo`),
  KEY `id_estado` (`id_estado`),
  CONSTRAINT `tipos_incidencia_ibfk_1` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_incidencia`
--

LOCK TABLES `tipos_incidencia` WRITE;
/*!40000 ALTER TABLE `tipos_incidencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `tipos_incidencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_penalizacion`
--

DROP TABLE IF EXISTS `tipos_penalizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_penalizacion` (
  `id_tipo_penalizacion` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  PRIMARY KEY (`id_tipo_penalizacion`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_penalizacion`
--

LOCK TABLES `tipos_penalizacion` WRITE;
/*!40000 ALTER TABLE `tipos_penalizacion` DISABLE KEYS */;
INSERT INTO `tipos_penalizacion` VALUES
(1,'Cancelacion tardia'),
(9,'Daño del producto'),
(7,'Distancia extra'),
(2,'Entrega fuera de SLA'),
(5,'Incidencia del cliente'),
(4,'Incidencia del repartidor'),
(8,'Incumplimiento de OTP'),
(3,'Reintentos excesivos'),
(10,'Retraso por bloqueo vial'),
(6,'Zona de riesgo');
/*!40000 ALTER TABLE `tipos_penalizacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipos_vehiculo`
--

DROP TABLE IF EXISTS `tipos_vehiculo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipos_vehiculo` (
  `id_tipo_vehiculo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `capacidad_maxima_kg` decimal(8,2) NOT NULL,
  `capacidad_volumen_m3` decimal(8,2) NOT NULL,
  `costo_por_km_base` decimal(8,2) NOT NULL,
  `id_estado` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_tipo_vehiculo`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_vehiculo`
--

LOCK TABLES `tipos_vehiculo` WRITE;
/*!40000 ALTER TABLE `tipos_vehiculo` DISABLE KEYS */;
/*!40000 ALTER TABLE `tipos_vehiculo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `id_rol` int(11) NOT NULL,
  `id_estado` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`),
  KEY `id_rol` (`id_rol`),
  KEY `id_estado` (`id_estado`),
  CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`),
  CONSTRAINT `usuarios_ibfk_2` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES
(5,'Administrador General','admin@demo.com','240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',9,1,'2025-11-16 02:20:43','2025-11-16 02:20:43'),
(6,'Planificador Central','planificador@demo.com','22ab6a65b4e819b25a52b7bd9b34c1e91c8ddc4d5861a2a2c193eae89fccd24d',10,1,'2025-11-16 02:20:43','2025-11-16 02:20:43'),
(7,'Repartidor Demo','repartidor@demo.com','9c410f599d2b705887a40ba8d3b769dda7721929e5a9ef6999c409bc6125fda2',11,1,'2025-11-16 02:20:43','2025-11-16 02:20:43'),
(8,'Auditor Demo','auditor@demo.com','0b26f7caa1c2e5e3f11adfd22f47403ed214a1d4451117a18ea726b451a3aa61',12,1,'2025-11-16 02:20:43','2025-11-16 02:20:43');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehiculos`
--

DROP TABLE IF EXISTS `vehiculos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehiculos` (
  `id_vehiculo` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo_vehiculo` int(11) NOT NULL,
  `patente` varchar(20) NOT NULL,
  `costo_por_km` decimal(8,2) NOT NULL,
  `id_estado_vehiculo` int(11) NOT NULL,
  `id_estado` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_vehiculo`),
  UNIQUE KEY `patente` (`patente`),
  KEY `id_tipo_vehiculo` (`id_tipo_vehiculo`),
  KEY `id_estado_vehiculo` (`id_estado_vehiculo`),
  KEY `id_estado` (`id_estado`),
  CONSTRAINT `vehiculos_ibfk_1` FOREIGN KEY (`id_tipo_vehiculo`) REFERENCES `tipos_vehiculo` (`id_tipo_vehiculo`),
  CONSTRAINT `vehiculos_ibfk_2` FOREIGN KEY (`id_estado_vehiculo`) REFERENCES `estados_vehiculo` (`id_estado_vehiculo`),
  CONSTRAINT `vehiculos_ibfk_3` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehiculos`
--

LOCK TABLES `vehiculos` WRITE;
/*!40000 ALTER TABLE `vehiculos` DISABLE KEYS */;
/*!40000 ALTER TABLE `vehiculos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `zonas`
--

DROP TABLE IF EXISTS `zonas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `zonas` (
  `id_zona` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_zona` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `radio_km` decimal(5,2) DEFAULT NULL,
  `id_estado` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_geo_centro` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_zona`),
  UNIQUE KEY `nombre_zona` (`nombre_zona`),
  KEY `id_estado` (`id_estado`),
  KEY `fk_zonas_geo` (`id_geo_centro`),
  CONSTRAINT `fk_zonas_geo` FOREIGN KEY (`id_geo_centro`) REFERENCES `geolocalizacion` (`id_geo`),
  CONSTRAINT `zonas_ibfk_1` FOREIGN KEY (`id_estado`) REFERENCES `estados` (`id_estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zonas`
--

LOCK TABLES `zonas` WRITE;
/*!40000 ALTER TABLE `zonas` DISABLE KEYS */;
/*!40000 ALTER TABLE `zonas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'ProyectoFinalBDA'
--

--
-- Dumping routines for database 'ProyectoFinalBDA'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-22 23:18:06
