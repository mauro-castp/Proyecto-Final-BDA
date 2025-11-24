/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19-11.8.3-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: proyecto
-- ------------------------------------------------------
-- Server version	11.8.3-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

-- LUM = Logistica Ultima Milla
-- CREATE DATABASE proyecto;
-- CREATE USER proyecto_user@localhost IDENTIFIED BY '666';
-- GRANT ALL PRIVILEGES ON proyecto.* TO proyecto_user@localhost IDENTIFIED BY '666'; 
-- mysql -u proyecto_user -p666 proyecto < DumpGeneral.sql

--
-- Table structure for table `aud_entregas`
--

DROP TABLE IF EXISTS `aud_entregas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `aud_entregas` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `id_entrega` int(11) DEFAULT NULL,
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
  `id_estado_cliente` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_cliente`),
  KEY `id_estado_cliente` (`id_estado_cliente`),
  CONSTRAINT `clientes_ibfk_1` FOREIGN KEY (`id_estado_cliente`) REFERENCES `estados_cliente` (`id_estado_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
set autocommit=0;
/*!40000 ALTER TABLE `costos_operativos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
set autocommit=0;
/*!40000 ALTER TABLE `detalle_pedido` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
  `id_estado_direccion` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_geo` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_direccion`),
  KEY `id_cliente` (`id_cliente`),
  KEY `id_zona` (`id_zona`),
  KEY `id_estado_direccion` (`id_estado_direccion`),
  KEY `fk_direcciones_geo` (`id_geo`),
  CONSTRAINT `direcciones_cliente_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`) ON DELETE CASCADE,
  CONSTRAINT `direcciones_cliente_ibfk_2` FOREIGN KEY (`id_zona`) REFERENCES `zonas` (`id_zona`),
  CONSTRAINT `direcciones_cliente_ibfk_3` FOREIGN KEY (`id_estado_direccion`) REFERENCES `estados_direccion` (`id_estado_direccion`),
  CONSTRAINT `fk_direcciones_geo` FOREIGN KEY (`id_geo`) REFERENCES `geolocalizacion` (`id_geo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direcciones_cliente`
--

LOCK TABLES `direcciones_cliente` WRITE;
/*!40000 ALTER TABLE `direcciones_cliente` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `direcciones_cliente` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
  `hora_inicio_entrega` timestamp NULL DEFAULT NULL,
  `hora_fin_entrega` timestamp NULL DEFAULT NULL,
  `fecha_real_entrega` timestamp NULL DEFAULT NULL,
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
set autocommit=0;
/*!40000 ALTER TABLE `entregas` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `estados_cliente`
--

DROP TABLE IF EXISTS `estados_cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_cliente` (
  `id_estado_cliente` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_estado_cliente`),
  UNIQUE KEY `nombre_estado` (`nombre_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_cliente`
--

LOCK TABLES `estados_cliente` WRITE;
/*!40000 ALTER TABLE `estados_cliente` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `estados_cliente` VALUES
(1,'activo','Cliente activo'),
(2,'inactivo','Cliente inactivo'),
(3,'suspendido','Cliente suspendido');
/*!40000 ALTER TABLE `estados_cliente` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `estados_direccion`
--

DROP TABLE IF EXISTS `estados_direccion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_direccion` (
  `id_estado_direccion` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_estado_direccion`),
  UNIQUE KEY `nombre_estado` (`nombre_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_direccion`
--

LOCK TABLES `estados_direccion` WRITE;
/*!40000 ALTER TABLE `estados_direccion` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `estados_direccion` VALUES
(1,'activa','Dirección activa'),
(2,'inactiva','Dirección inactiva'),
(3,'principal','Dirección principal del cliente');
/*!40000 ALTER TABLE `estados_direccion` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_entrega`
--

LOCK TABLES `estados_entrega` WRITE;
/*!40000 ALTER TABLE `estados_entrega` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `estados_entrega` VALUES
(1,'pendiente','Entrega pendiente'),
(2,'asignada','Entrega asignada a repartidor'),
(3,'en camino','Repartidor en camino'),
(4,'en destino','Repartidor en destino'),
(5,'entregada','Entrega completada'),
(6,'fallida','Entrega fallida'),
(7,'reprogramada','Entrega reprogramada');
/*!40000 ALTER TABLE `estados_entrega` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_incidencia`
--

LOCK TABLES `estados_incidencia` WRITE;
/*!40000 ALTER TABLE `estados_incidencia` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `estados_incidencia` VALUES
(1,'reportada','Incidencia reportada'),
(2,'en investigacion','Incidencia en investigación'),
(3,'resuelta','Incidencia resuelta'),
(4,'cerrada','Incidencia cerrada');
/*!40000 ALTER TABLE `estados_incidencia` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_parada`
--

LOCK TABLES `estados_parada` WRITE;
/*!40000 ALTER TABLE `estados_parada` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `estados_parada` VALUES
(1,'pendiente','Parada pendiente'),
(2,'en progreso','Parada en progreso'),
(3,'completada','Parada completada'),
(4,'omitida','Parada omitida');
/*!40000 ALTER TABLE `estados_parada` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_pedido`
--

LOCK TABLES `estados_pedido` WRITE;
/*!40000 ALTER TABLE `estados_pedido` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `estados_pedido` VALUES
(1,'pendiente','Pedido pendiente de procesar'),
(2,'confirmado','Pedido confirmado'),
(3,'en preparacion','Pedido en preparación'),
(4,'listo para entrega','Pedido listo para entrega'),
(5,'en camino','Pedido en camino'),
(6,'entregado','Pedido entregado'),
(7,'cancelado','Pedido cancelado');
/*!40000 ALTER TABLE `estados_pedido` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `estados_producto`
--

DROP TABLE IF EXISTS `estados_producto`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_producto` (
  `id_estado_producto` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_estado_producto`),
  UNIQUE KEY `nombre_estado` (`nombre_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_producto`
--

LOCK TABLES `estados_producto` WRITE;
/*!40000 ALTER TABLE `estados_producto` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `estados_producto` VALUES
(1,'disponible','Producto disponible para venta'),
(2,'no disponible','Producto no disponible'),
(3,'descontinuado','Producto descontinuado');
/*!40000 ALTER TABLE `estados_producto` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `estados_rol`
--

DROP TABLE IF EXISTS `estados_rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_rol` (
  `id_estado_rol` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_estado_rol`),
  UNIQUE KEY `nombre_estado` (`nombre_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_rol`
--

LOCK TABLES `estados_rol` WRITE;
/*!40000 ALTER TABLE `estados_rol` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `estados_rol` VALUES
(1,'activo','Estado activo para roles'),
(2,'inactivo','Estado inactivo para roles');
/*!40000 ALTER TABLE `estados_rol` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_ruta`
--

LOCK TABLES `estados_ruta` WRITE;
/*!40000 ALTER TABLE `estados_ruta` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `estados_ruta` VALUES
(1,'planificada','Ruta planificada'),
(2,'en progreso','Ruta en progreso'),
(3,'completada','Ruta completada'),
(4,'cancelada','Ruta cancelada');
/*!40000 ALTER TABLE `estados_ruta` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `estados_usuario`
--

DROP TABLE IF EXISTS `estados_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_usuario` (
  `id_estado_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_estado_usuario`),
  UNIQUE KEY `nombre_estado` (`nombre_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_usuario`
--

LOCK TABLES `estados_usuario` WRITE;
/*!40000 ALTER TABLE `estados_usuario` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `estados_usuario` VALUES
(1,'activo','Usuario activo en el sistema'),
(2,'inactivo','Usuario inactivo en el sistema'),
(3,'bloqueado','Usuario bloqueado temporalmente');
/*!40000 ALTER TABLE `estados_usuario` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
  PRIMARY KEY (`id_estado_vehiculo`),
  UNIQUE KEY `nombre_estado` (`nombre_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_vehiculo`
--

LOCK TABLES `estados_vehiculo` WRITE;
/*!40000 ALTER TABLE `estados_vehiculo` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `estados_vehiculo` VALUES
(1,'operativo','Vehículo en operación'),
(2,'mantenimiento','Vehículo en mantenimiento'),
(3,'inactivo','Vehículo inactivo');
/*!40000 ALTER TABLE `estados_vehiculo` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `estados_zona`
--

DROP TABLE IF EXISTS `estados_zona`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_zona` (
  `id_estado_zona` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_estado_zona`),
  UNIQUE KEY `nombre_estado` (`nombre_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_zona`
--

LOCK TABLES `estados_zona` WRITE;
/*!40000 ALTER TABLE `estados_zona` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `estados_zona` VALUES
(1,'activa','Zona activa para entregas'),
(2,'inactiva','Zona inactiva'),
(3,'restringida','Zona con restricciones');
/*!40000 ALTER TABLE `estados_zona` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `evidencias`
--

DROP TABLE IF EXISTS `evidencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `evidencias` (
  `id_evidencia` int(11) NOT NULL AUTO_INCREMENT,
  `id_entrega` int(11) DEFAULT NULL,
  `id_costo_operativo` int(11) DEFAULT NULL,
  `id_incidencia` int(11) DEFAULT NULL,
  `tipo` enum('foto_entrega','firma_cliente','foto_costo','documento_incidencia','otro') NOT NULL,
  `url` text NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_evidencia`),
  KEY `id_entrega` (`id_entrega`),
  KEY `id_costo_operativo` (`id_costo_operativo`),
  KEY `id_incidencia` (`id_incidencia`),
  CONSTRAINT `evidencias_ibfk_1` FOREIGN KEY (`id_entrega`) REFERENCES `entregas` (`id_entrega`),
  CONSTRAINT `evidencias_ibfk_2` FOREIGN KEY (`id_costo_operativo`) REFERENCES `costos_operativos` (`id_costo`),
  CONSTRAINT `evidencias_ibfk_3` FOREIGN KEY (`id_incidencia`) REFERENCES `incidencias` (`id_incidencia`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evidencias`
--

LOCK TABLES `evidencias` WRITE;
/*!40000 ALTER TABLE `evidencias` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `evidencias` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
set autocommit=0;
/*!40000 ALTER TABLE `geolocalizacion` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
set autocommit=0;
/*!40000 ALTER TABLE `incidencias` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `motivos_fallo`
--

DROP TABLE IF EXISTS `motivos_fallo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `motivos_fallo` (
  `id_motivo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `categoria` enum('cliente','repartidor','externo','sistema') NOT NULL,
  PRIMARY KEY (`id_motivo`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `motivos_fallo`
--

LOCK TABLES `motivos_fallo` WRITE;
/*!40000 ALTER TABLE `motivos_fallo` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `motivos_fallo` VALUES
(1,'Cliente ausente','Cliente no se encuentra en el domicilio','cliente'),
(2,'Direccion incorrecta','La dirección proporcionada es incorrecta','cliente'),
(3,'Paquete rechazado','Cliente rechaza recibir el paquete','cliente'),
(4,'Zona insegura','Zona considerada de riesgo para el repartidor','externo'),
(5,'Acceso restringido','No se puede acceder al domicilio (portería, rejas, etc.)','externo'),
(6,'Clima adverso','Condiciones climáticas impiden la entrega','externo'),
(7,'Vehiculo descompuesto','Problemas mecánicos con el vehículo de entrega','repartidor'),
(8,'Incidencia de transito','Problemas de tráfico o viales','externo'),
(9,'Error del repartidor','Error cometido por el repartidor','repartidor'),
(10,'Otro','Otro motivo no especificado','sistema');
/*!40000 ALTER TABLE `motivos_fallo` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
  PRIMARY KEY (`id_nivel_impacto`),
  UNIQUE KEY `nombre_nivel` (`nombre_nivel`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `niveles_impacto`
--

LOCK TABLES `niveles_impacto` WRITE;
/*!40000 ALTER TABLE `niveles_impacto` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `niveles_impacto` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
set autocommit=0;
/*!40000 ALTER TABLE `otp` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
set autocommit=0;
/*!40000 ALTER TABLE `paradas_ruta` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
set autocommit=0;
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
set autocommit=0;
/*!40000 ALTER TABLE `penalizaciones` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
  `id_estado_producto` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_producto`),
  KEY `id_estado_producto` (`id_estado_producto`),
  CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`id_estado_producto`) REFERENCES `estados_producto` (`id_estado_producto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `productos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
  `id_estado_rol` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `nombre_rol` (`nombre_rol`),
  KEY `id_estado_rol` (`id_estado_rol`),
  CONSTRAINT `roles_ibfk_1` FOREIGN KEY (`id_estado_rol`) REFERENCES `estados_rol` (`id_estado_rol`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `roles` VALUES
(9,'Admin','Acceso total al sistema',1,'2025-11-16 08:11:00'),
(10,'Planificador','Gestiona rutas, pedidos y asignaciones',1,'2025-11-16 08:11:00'),
(11,'Repartidor','Solo ve y confirma sus entregas',1,'2025-11-16 08:11:00'),
(12,'Auditor','Consulta reportes y auditorías',1,'2025-11-16 08:11:00');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
  `costo` decimal(10,2) DEFAULT 0.00,
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
set autocommit=0;
/*!40000 ALTER TABLE `rutas` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
  PRIMARY KEY (`id_tipo_costo`),
  UNIQUE KEY `nombre_tipo` (`nombre_tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_costo`
--

LOCK TABLES `tipos_costo` WRITE;
/*!40000 ALTER TABLE `tipos_costo` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `tipos_costo` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
  PRIMARY KEY (`id_tipo_incidencia`),
  UNIQUE KEY `nombre_tipo` (`nombre_tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_incidencia`
--

LOCK TABLES `tipos_incidencia` WRITE;
/*!40000 ALTER TABLE `tipos_incidencia` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `tipos_incidencia` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
set autocommit=0;
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
commit;

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
  PRIMARY KEY (`id_tipo_vehiculo`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_vehiculo`
--

LOCK TABLES `tipos_vehiculo` WRITE;
/*!40000 ALTER TABLE `tipos_vehiculo` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `tipos_vehiculo` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
  `id_estado_usuario` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`),
  KEY `id_rol` (`id_rol`),
  KEY `id_estado_usuario` (`id_estado_usuario`),
  CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`id_rol`) REFERENCES `roles` (`id_rol`),
  CONSTRAINT `usuarios_ibfk_2` FOREIGN KEY (`id_estado_usuario`) REFERENCES `estados_usuario` (`id_estado_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `usuarios` VALUES
(5,'Administrador General','admin@demo.com','admin123',9,1,'2025-11-16 08:20:43','2025-11-16 08:20:43'),
(6,'Planificador Central','planificador@demo.com','plan123',10,1,'2025-11-16 08:20:43','2025-11-16 08:20:43'),
(7,'Repartidor Demo','repartidor@demo.com','rep123',11,1,'2025-11-16 08:20:43','2025-11-16 08:20:43'),
(8,'Auditor Demo','auditor@demo.com','aud123',12,1,'2025-11-16 08:20:43','2025-11-16 08:20:43');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `vehiculos`
--

DROP TABLE IF EXISTS `vehiculos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `vehiculos` (
  `id_vehiculo` int(11) NOT NULL AUTO_INCREMENT,
  `id_tipo_vehiculo` int(11) NOT NULL,
  `placa` varchar(20) NOT NULL,
  `costo_por_km` decimal(8,2) NOT NULL,
  `id_estado_vehiculo` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_vehiculo`),
  UNIQUE KEY `placa` (`placa`),
  KEY `id_tipo_vehiculo` (`id_tipo_vehiculo`),
  KEY `id_estado_vehiculo` (`id_estado_vehiculo`),
  CONSTRAINT `vehiculos_ibfk_1` FOREIGN KEY (`id_tipo_vehiculo`) REFERENCES `tipos_vehiculo` (`id_tipo_vehiculo`),
  CONSTRAINT `vehiculos_ibfk_2` FOREIGN KEY (`id_estado_vehiculo`) REFERENCES `estados_vehiculo` (`id_estado_vehiculo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehiculos`
--

LOCK TABLES `vehiculos` WRITE;
/*!40000 ALTER TABLE `vehiculos` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `vehiculos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
  `id_estado_zona` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `id_geo_centro` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_zona`),
  UNIQUE KEY `nombre_zona` (`nombre_zona`),
  KEY `id_estado_zona` (`id_estado_zona`),
  KEY `fk_zonas_geo` (`id_geo_centro`),
  CONSTRAINT `fk_zonas_geo` FOREIGN KEY (`id_geo_centro`) REFERENCES `geolocalizacion` (`id_geo`),
  CONSTRAINT `zonas_ibfk_1` FOREIGN KEY (`id_estado_zona`) REFERENCES `estados_zona` (`id_estado_zona`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zonas`
--

LOCK TABLES `zonas` WRITE;
/*!40000 ALTER TABLE `zonas` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `zonas` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-11-22 14:50:48