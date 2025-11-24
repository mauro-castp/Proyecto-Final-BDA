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
  `valores_anteriores` longtext CHARACTER SET utf8mb4 DEFAULT NULL CHECK (json_valid(`valores_anteriores`)),
  `valores_nuevos` longtext CHARACTER SET utf8mb4 DEFAULT NULL CHECK (json_valid(`valores_nuevos`)),
  `usuario` varchar(100) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
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
  `valores_anteriores` longtext CHARACTER SET utf8mb4 DEFAULT NULL CHECK (json_valid(`valores_anteriores`)),
  `valores_nuevos` longtext CHARACTER SET utf8mb4 DEFAULT NULL CHECK (json_valid(`valores_nuevos`)),
  `usuario` varchar(100) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
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
  `valores_anteriores` longtext CHARACTER SET utf8mb4 DEFAULT NULL CHECK (json_valid(`valores_anteriores`)),
  `valores_nuevos` longtext CHARACTER SET utf8mb4 DEFAULT NULL CHECK (json_valid(`valores_nuevos`)),
  `usuario` varchar(100) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
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
  `valores_anteriores` longtext CHARACTER SET utf8mb4  DEFAULT NULL CHECK (json_valid(`valores_anteriores`)),
  `valores_nuevos` longtext CHARACTER SET utf8mb4  DEFAULT NULL CHECK (json_valid(`valores_nuevos`)),
  `usuario` varchar(100) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `clientes` (`nombre`, `telefono`, `email`, `id_estado_cliente`) VALUES
('Juan Pérez', '+1234567890', 'juan.perez@email.com', 1),
('María García', '+1234567891', 'maria.garcia@email.com', 1),
('Carlos López', '+1234567892', 'carlos.lopez@email.com', 1),
('Ana Martínez', '+1234567893', 'ana.martinez@email.com', 1),
('Pedro Rodríguez', '+1234567894', 'pedro.rodriguez@email.com', 1),
('Laura Hernández', '+1234567895', 'laura.hernandez@email.com', 1),
('Miguel Sánchez', '+1234567896', 'miguel.sanchez@email.com', 1),
('Isabel Díaz', '+1234567897', 'isabel.diaz@email.com', 1),
('Francisco Ruiz', '+1234567898', 'francisco.ruiz@email.com', 1),
('Elena Torres', '+1234567899', 'elena.torres@email.com', 1);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `costos_operativos`
--

LOCK TABLES `costos_operativos` WRITE;
/*!40000 ALTER TABLE `costos_operativos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `costos_operativos` (`id_vehiculo`, `id_ruta`, `id_tipo_costo`, `monto`, `distancia_km`, `fecha_costo`, `descripcion`) VALUES
(1, 1, 1, 15.50, 25.50, CURDATE(), 'Combustible para ruta norte'),
(2, 2, 2, 45.00, 18.75, CURDATE(), 'Cambio de aceite'),
(3, 3, 3, 12.00, 32.00, CURDATE(), 'Peajes ruta este'),
(4, 4, 4, 8.50, 28.25, CURDATE(), 'Estacionamiento centro'),
(5, 5, 5, 12.00, 15.80, CURDATE(), 'Lavado completo'),
(6, 6, 6, 25.00, 45.30, CURDATE(), 'Pago de seguro mensual'),
(7, 7, 7, 15.00, 12.50, CURDATE(), 'Renovación de licencia'),
(8, 8, 8, 35.00, 22.75, CURDATE(), 'Reparación de frenos'),
(9, 9, 9, 20.00, 19.40, CURDATE(), 'Multa por estacionamiento'),
(10, 10, 10, 10.00, 38.60, CURDATE(), 'Gastos varios');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_pedido`
--

LOCK TABLES `detalle_pedido` WRITE;
/*!40000 ALTER TABLE `detalle_pedido` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `detalle_pedido` (`id_pedido`, `id_producto`, `cantidad`, `subtotal`) VALUES
(1, 1, 1, 1200.00),
(2, 2, 1, 800.00),
(3, 1, 1, 1200.00),
(3, 7, 1, 50.00),
(4, 3, 1, 300.00),
(4, 4, 1, 150.00),
(5, 5, 1, 200.00),
(5, 6, 1, 80.00),
(6, 4, 1, 150.00),
(7, 8, 1, 250.00);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direcciones_cliente`
--

LOCK TABLES `direcciones_cliente` WRITE;
/*!40000 ALTER TABLE `direcciones_cliente` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `direcciones_cliente` (`id_cliente`, `direccion`, `id_zona`, `es_principal`, `id_estado_direccion`, `id_geo`) VALUES
(1, 'Calle Principal 123, Apt 4B', 1, 1, 3, 1),
(2, 'Avenida Central 456, Casa 2', 2, 1, 3, 2),
(3, 'Calle Secundaria 789, Piso 3', 3, 1, 3, 3),
(4, 'Boulevard Norte 321, Local 5', 4, 1, 3, 4),
(5, 'Calle Sur 654, Edificio A', 5, 1, 3, 5),
(6, 'Avenida Este 987, Casa 10', 6, 1, 3, 6),
(7, 'Calle Oeste 147, Apt 7C', 7, 1, 3, 7),
(8, 'Paseo del Parque 258, Piso 2', 8, 1, 3, 8),
(9, 'Camino Real 369, Local 8', 9, 1, 3, 9),
(10, 'Ruta Comercial 741, Casa 12', 10, 1, 3, 10);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entregas`
--

LOCK TABLES `entregas` WRITE;
/*!40000 ALTER TABLE `entregas` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `entregas` (`id_pedido`, `id_ruta`, `id_repartidor`, `id_estado_entrega`, `fecha_estimada_entrega`, `hora_inicio_entrega`, `hora_fin_entrega`, `fecha_real_entrega`, `tiempo_entrega_minutos`, `reintentos`, `cumplio_sla`, `fue_tarde`, `costo_entrega`) VALUES
(1, 1, 3, 1, NOW() + INTERVAL 2 DAY, NULL, NULL, NULL, 0, 0, 0, 0, 5.00),
(2, 2, 3, 2, NOW() + INTERVAL 1 DAY, NOW(), NULL, NULL, 0, 0, 0, 0, 4.50),
(3, 3, 3, 3, NOW() + INTERVAL 3 DAY, NOW() - INTERVAL 30 MINUTE, NULL, NULL, 30, 0, 1, 0, 6.25),
(4, 4, 3, 4, NOW() + INTERVAL 1 DAY, NOW() - INTERVAL 45 MINUTE, NULL, NULL, 45, 0, 1, 0, 5.75),
(5, 5, 3, 5, NOW() + INTERVAL 2 DAY, NOW() - INTERVAL 60 MINUTE, NOW(), NOW(), 60, 0, 1, 0, 7.20),
(6, 6, 3, 5, NOW() - INTERVAL 1 DAY, NOW() - INTERVAL 2 HOUR, NOW() - INTERVAL 1 HOUR, NOW() - INTERVAL 1 HOUR, 60, 0, 1, 0, 8.50),
(7, 7, 3, 5, NOW() - INTERVAL 2 DAY, NOW() - INTERVAL 3 HOUR, NOW() - INTERVAL 2 HOUR, NOW() - INTERVAL 2 HOUR, 60, 0, 1, 0, 9.30),
(8, 8, 3, 6, NOW() + INTERVAL 4 DAY, NOW() - INTERVAL 15 MINUTE, NOW(), NULL, 15, 1, 0, 0, 3.80),
(9, 9, 3, 1, NOW() + INTERVAL 2 DAY, NULL, NULL, NULL, 0, 0, 0, 0, 4.20),
(10, 10, 3, 2, NOW() + INTERVAL 3 DAY, NOW(), NULL, NULL, 0, 0, 0, 0, 5.60);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 ;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 ;
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 ;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 ;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 ;
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 ;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 ;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 ;
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 ;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 ;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 ;
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 ;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evidencias`
--

LOCK TABLES `evidencias` WRITE;
/*!40000 ALTER TABLE `evidencias` DISABLE KEYS */;
set autocommit=0;
-- Inserts para evidencias
INSERT INTO `evidencias` (`id_entrega`, `id_costo_operativo`, `id_incidencia`, `tipo`, `url`, `descripcion`) VALUES
(5, NULL, NULL, 'foto_entrega', '/evidencias/entrega_5_1.jpg', 'Foto del paquete entregado'),
(6, NULL, NULL, 'firma_cliente', '/evidencias/firma_6_1.png', 'Firma del cliente recibido'),
(NULL, 1, NULL, 'foto_costo', '/evidencias/costo_1_1.jpg', 'Ticket de combustible'),
(NULL, 2, NULL, 'foto_costo', '/evidencias/costo_2_1.jpg', 'Factura de mantenimiento'),
(7, NULL, NULL, 'foto_entrega', '/evidencias/entrega_7_1.jpg', 'Foto del lugar de entrega'),
(NULL, 3, NULL, 'foto_costo', '/evidencias/costo_3_1.jpg', 'Ticket de peaje'),
(8, NULL, NULL, 'firma_cliente', '/evidencias/firma_8_1.png', 'Firma de rechazo'),
(NULL, 4, NULL, 'foto_costo', '/evidencias/costo_4_1.jpg', 'Ticket de estacionamiento'),
(5, NULL, NULL, 'otro', '/evidencias/entrega_5_2.pdf', 'Documentación adicional'),
(NULL, 5, NULL, 'foto_costo', '/evidencias/costo_5_1.jpg', 'Factura de lavado');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `geolocalizacion`
--

LOCK TABLES `geolocalizacion` WRITE;
/*!40000 ALTER TABLE `geolocalizacion` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `geolocalizacion` (`latitud`, `longitud`) VALUES
(40.7128000, -74.0060000),
(40.7138000, -74.0070000),
(40.7148000, -74.0080000),
(40.7158000, -74.0090000),
(40.7168000, -74.0100000),
(40.7178000, -74.0110000),
(40.7188000, -74.0120000),
(40.7198000, -74.0130000),
(40.7208000, -74.0140000),
(40.7218000, -74.0150000);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incidencias`
--

LOCK TABLES `incidencias` WRITE;
/*!40000 ALTER TABLE `incidencias` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `incidencias` (`id_tipo_incidencia`, `id_zona`, `descripcion`, `fecha_inicio`, `fecha_fin`, `id_estado_incidencia`, `id_nivel_impacto`, `radio_afectacion_km`, `id_usuario_reporta`, `id_geo`) VALUES
(1, 1, 'Congestión vehicular por accidente menor', NOW() - INTERVAL 2 HOUR, NOW() - INTERVAL 1 HOUR, 3, 2, 1.50, 3, 1),
(2, 2, 'Lluvia intensa afectando visibilidad', NOW() - INTERVAL 3 HOUR, NULL, 2, 3, 3.00, 3, 2),
(3, 3, 'Accidente vehicular en avenida principal', NOW() - INTERVAL 1 HOUR, NULL, 1, 4, 2.00, 3, 3),
(4, 4, 'Manifestación bloqueando calles principales', NOW() - INTERVAL 4 HOUR, NOW() - INTERVAL 2 HOUR, 3, 4, 1.00, 3, 4),
(5, 5, 'Trabajos de mantenimiento en vía rápida', NOW() - INTERVAL 5 HOUR, NOW() - INTERVAL 1 HOUR, 3, 2, 0.50, 3, 5),
(6, 6, 'Vehículo con falla mecánica', NOW() - INTERVAL 2 HOUR, NOW() - INTERVAL 30 MINUTE, 3, 3, 0.00, 3, 6),
(7, 7, 'Cliente no se encuentra en domicilio', NOW() - INTERVAL 1 HOUR, NULL, 2, 1, 0.00, 3, 7),
(8, 8, 'Dirección incorrecta en sistema', NOW() - INTERVAL 3 HOUR, NOW() - INTERVAL 1 HOUR, 3, 2, 0.00, 3, 8),
(9, 9, 'Paquete dañado durante transporte', NOW() - INTERVAL 2 HOUR, NULL, 1, 3, 0.00, 3, 9),
(10, 10, 'Problema de comunicación con centro', NOW() - INTERVAL 1 HOUR, NOW() - INTERVAL 30 MINUTE, 3, 2, 0.00, 3, 10);
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `niveles_impacto`
--

LOCK TABLES `niveles_impacto` WRITE;
/*!40000 ALTER TABLE `niveles_impacto` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `niveles_impacto` (`nombre_nivel`, `descripcion`) VALUES
('Bajo', 'Impacto mínimo en las operaciones'),
('Medio', 'Impacto moderado en las operaciones'),
('Alto', 'Impacto significativo en las operaciones'),
('Crítico', 'Impacto crítico que detiene operaciones'),
('Localizado', 'Impacto en área específica'),
('Extendido', 'Impacto en múltiples áreas'),
('Temporal', 'Impacto de corta duración'),
('Prolongado', 'Impacto de larga duración'),
('Recurrente', 'Impacto que se repite frecuentemente'),
('Inesperado', 'Impacto no previsto');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp`
--

LOCK TABLES `otp` WRITE;
/*!40000 ALTER TABLE `otp` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `otp` (`id_entrega`, `codigo`, `verificado`, `fecha_verificado`) VALUES
(1, '123456', 0, NULL),
(2, '234567', 0, NULL),
(3, '345678', 1, NOW() - INTERVAL 30 MINUTE),
(4, '456789', 1, NOW() - INTERVAL 45 MINUTE),
(5, '567890', 1, NOW() - INTERVAL 60 MINUTE),
(6, '678901', 1, NOW() - INTERVAL 120 MINUTE),
(7, '789012', 1, NOW() - INTERVAL 180 MINUTE),
(8, '890123', 0, NULL),
(9, '901234', 0, NULL),
(10, '012345', 0, NULL);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paradas_ruta`
--

LOCK TABLES `paradas_ruta` WRITE;
/*!40000 ALTER TABLE `paradas_ruta` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `paradas_ruta` (`id_ruta`, `id_pedido`, `orden_secuencia`, `id_estado_parada`, `distancia_desde_inicio_km`, `tiempo_estimado_desde_inicio_min`, `fecha_estimada_entrega`) VALUES
(1, 1, 1, 1, 0.00, 0, NOW() + INTERVAL 2 DAY),
(2, 2, 1, 2, 0.00, 0, NOW() + INTERVAL 1 DAY),
(3, 3, 1, 3, 0.00, 0, NOW() + INTERVAL 3 DAY),
(4, 4, 1, 4, 0.00, 0, NOW() + INTERVAL 1 DAY),
(5, 5, 1, 1, 0.00, 0, NOW() + INTERVAL 2 DAY),
(6, 6, 1, 2, 0.00, 0, NOW() - INTERVAL 1 DAY),
(7, 7, 1, 3, 0.00, 0, NOW() - INTERVAL 2 DAY),
(8, 8, 1, 4, 0.00, 0, NOW() + INTERVAL 4 DAY),
(9, 9, 1, 1, 0.00, 0, NOW() + INTERVAL 2 DAY),
(10, 10, 1, 2, 0.00, 0, NOW() + INTERVAL 3 DAY);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `pedidos` (`id_cliente`, `id_direccion_entrega`, `id_estado_pedido`, `fecha_estimada_entrega`, `total_pedido`, `peso_total`, `volumen_total`) VALUES
(1, 1, 1, NOW() + INTERVAL 2 DAY, 1200.00, 2.50, 0.0150),
(2, 2, 2, NOW() + INTERVAL 1 DAY, 800.00, 0.20, 0.0008),
(3, 3, 3, NOW() + INTERVAL 3 DAY, 1100.00, 2.70, 0.0165),
(4, 4, 4, NOW() + INTERVAL 1 DAY, 450.00, 0.75, 0.0045),
(5, 5, 5, NOW() + INTERVAL 2 DAY, 280.00, 1.25, 0.0051),
(6, 6, 6, NOW() - INTERVAL 1 DAY, 150.00, 0.25, 0.0015),
(7, 7, 6, NOW() - INTERVAL 2 DAY, 250.00, 8.50, 0.0450),
(8, 8, 1, NOW() + INTERVAL 4 DAY, 90.00, 0.48, 0.0021),
(9, 9, 2, NOW() + INTERVAL 2 DAY, 60.00, 0.30, 0.0012),
(10, 10, 3, NOW() + INTERVAL 3 DAY, 40.00, 0.18, 0.0009);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `penalizaciones`
--

LOCK TABLES `penalizaciones` WRITE;
/*!40000 ALTER TABLE `penalizaciones` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `penalizaciones` (`id_entrega`, `id_tipo_penalizacion`, `monto`) VALUES
(8, 1, 25.00),
(8, 2, 15.00),
(8, 3, 10.00),
(8, 4, 20.00),
(8, 5, 30.00),
(8, 6, 12.50),
(8, 7, 8.00),
(8, 8, 18.00),
(8, 9, 22.00),
(8, 10, 14.00);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `productos` (`nombre`, `descripcion`, `peso_kg`, `volumen_m3`, `precio_unitario`, `id_estado_producto`) VALUES
('Laptop Gaming', 'Laptop para gaming de alta gama', 2.50, 0.0150, 1200.00, 1),
('Smartphone Pro', 'Teléfono inteligente última generación', 0.20, 0.0008, 800.00, 1),
('Tablet 10 pulgadas', 'Tablet con pantalla de 10 pulgadas', 0.50, 0.0030, 300.00, 1),
('Auriculares Inalámbricos', 'Auriculares Bluetooth con cancelación de ruido', 0.25, 0.0015, 150.00, 1),
('Monitor 24"', 'Monitor LED 24 pulgadas Full HD', 3.20, 0.0250, 200.00, 1),
('Teclado Mecánico', 'Teclado mecánico RGB', 1.10, 0.0045, 80.00, 1),
('Mouse Gaming', 'Mouse para gaming con DPI ajustable', 0.15, 0.0006, 50.00, 1),
('Impresora Multifunción', 'Impresora láser multifunción', 8.50, 0.0450, 250.00, 1),
('Disco Duro Externo 1TB', 'Disco duro externo portátil', 0.30, 0.0012, 60.00, 1),
('Cámara Web HD', 'Cámara web 1080p para streaming', 0.18, 0.0009, 40.00, 1);
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
set autocommit=0;
INSERT INTO roles (id_rol, nombre_rol, descripcion, id_estado_rol) VALUES
(1, 'Administrador', 'Acceso total al sistema', 1),
(2, 'Planificador', 'Gestiona rutas, pedidos y asignaciones', 1),
(3, 'Repartidor', 'Solo ve y confirma sus entregas', 1),
(4, 'Auditor', 'Consulta reportes y auditorías', 1);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rutas`
--

LOCK TABLES `rutas` WRITE;
/*!40000 ALTER TABLE `rutas` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `rutas` (`nombre_ruta`, `id_zona`, `fecha_ruta`, `id_vehiculo`, `id_repartidor`, `id_estado_ruta`, `distancia_total_km`, `tiempo_estimado_minutos`, `costo`) VALUES
('Ruta Norte Mañana', 1, CURDATE(), 1, 3, 1, 25.50, 180, 38.25),
('Ruta Sur Tarde', 2, CURDATE(), 2, 3, 2, 18.75, 120, 46.88),
('Ruta Este Express', 3, CURDATE(), 3, 3, 1, 32.00, 210, 112.00),
('Ruta Oeste Regular', 4, CURDATE(), 4, 3, 3, 28.25, 165, 127.13),
('Ruta Centro Urgente', 5, CURDATE(), 5, 3, 2, 15.80, 90, 94.80),
('Ruta Suburbana', 6, CURDATE(), 6, 3, 1, 45.30, 240, 362.40),
('Ruta Financiera', 7, CURDATE(), 7, 3, 3, 12.50, 75, 6.25),
('Ruta Universitaria', 8, CURDATE(), 8, 3, 2, 22.75, 135, 6.83),
('Ruta Hospitalaria', 9, CURDATE(), 9, 3, 1, 19.40, 110, 38.80),
('Ruta Industrial', 10, CURDATE(), 10, 3, 3, 38.60, 195, 270.20);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_costo`
--

LOCK TABLES `tipos_costo` WRITE;
/*!40000 ALTER TABLE `tipos_costo` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tipos_costo` (`nombre_tipo`, `descripcion`) VALUES
('Combustible', 'Gastos de combustible'),
('Mantenimiento', 'Costos de mantenimiento del vehículo'),
('Peaje', 'Gastos de peajes y vialidad'),
('Estacionamiento', 'Costos de estacionamiento'),
('Lavado', 'Lavado y limpieza del vehículo'),
('Seguro', 'Seguros del vehículo'),
('Impuestos', 'Impuestos y licencias'),
('Reparaciones', 'Reparaciones y refacciones'),
('Sanciones', 'Multas y sanciones de tránsito'),
('Otros', 'Otros costos operativos');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_incidencia`
--

LOCK TABLES `tipos_incidencia` WRITE;
/*!40000 ALTER TABLE `tipos_incidencia` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tipos_incidencia` (`nombre_tipo`, `descripcion`) VALUES
('Tráfico', 'Congestión vehicular'),
('Clima', 'Condiciones climáticas adversas'),
('Accidente', 'Accidente de tránsito'),
('Protesta', 'Manifestación o protesta'),
('Obra Vial', 'Trabajos en la vía pública'),
('Vehicular', 'Problema con el vehículo'),
('Cliente', 'Problema con el cliente'),
('Dirección', 'Problema con la dirección'),
('Paquete', 'Problema con el paquete'),
('Otro', 'Otro tipo de incidencia');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_vehiculo`
--

LOCK TABLES `tipos_vehiculo` WRITE;
/*!40000 ALTER TABLE `tipos_vehiculo` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tipos_vehiculo` (`nombre`, `capacidad_maxima_kg`, `capacidad_volumen_m3`, `costo_por_km_base`) VALUES
('Moto', 50.00, 0.50, 0.15),
('Auto Compacto', 200.00, 2.00, 0.25),
('Camioneta', 500.00, 4.00, 0.35),
('Furgoneta Pequeña', 800.00, 6.00, 0.45),
('Furgoneta Mediana', 1200.00, 10.00, 0.60),
('Camión Ligero', 2000.00, 15.00, 0.80),
('Bicicleta', 10.00, 0.20, 0.05),
('Patineta Eléctrica', 5.00, 0.10, 0.03),
('Cuatrimoto', 80.00, 0.80, 0.20),
('Van de Reparto', 1500.00, 12.00, 0.70);
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
  `password` varchar(255) NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
set autocommit=0;
INSERT INTO usuarios (id_usuario, nombre, email, password, id_rol, id_estado_usuario) VALUES
(1, 'Administrador General', 'admin@demo.com', 'admin123', 1, 1),
(2, 'Planificador Central', 'planificador@demo.com', 'plan123', 2, 1),
(3, 'Repartidor Demo', 'repartidor@demo.com', 'rep123', 3, 1),
(4, 'Auditor Demo', 'auditor@demo.com', 'aud123', 4, 1);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehiculos`
--

LOCK TABLES `vehiculos` WRITE;
/*!40000 ALTER TABLE `vehiculos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `vehiculos` (`id_tipo_vehiculo`, `placa`, `costo_por_km`, `id_estado_vehiculo`) VALUES
(1, 'MOT-001', 0.15, 1),
(2, 'AUT-002', 0.25, 1),
(3, 'CAM-003', 0.35, 1),
(4, 'FUR-004', 0.45, 1),
(5, 'FUR-005', 0.60, 1),
(6, 'CAM-006', 0.80, 1),
(7, 'BIC-007', 0.05, 1),
(8, 'PAT-008', 0.03, 1),
(9, 'CUA-009', 0.20, 1),
(10, 'VAN-010', 0.70, 1);
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zonas`
--

LOCK TABLES `zonas` WRITE;
/*!40000 ALTER TABLE `zonas` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `zonas` (`nombre_zona`, `descripcion`, `radio_km`, `id_estado_zona`, `id_geo_centro`) VALUES
('Zona Norte', 'Área residencial norte', 5.00, 1, 1),
('Zona Sur', 'Área comercial sur', 4.50, 1, 2),
('Zona Este', 'Zona industrial este', 6.00, 1, 3),
('Zona Oeste', 'Área mixta oeste', 5.50, 1, 4),
('Centro Ciudad', 'Zona centro densamente poblada', 3.00, 1, 5),
('Zona Suburbana', 'Área suburbana residencial', 7.00, 1, 6),
('Distrito Financiero', 'Área de oficinas y negocios', 2.50, 1, 7),
('Zona Universitaria', 'Cerca de campus universitario', 4.00, 1, 8),
('Zona Hospital', 'Área médica y hospitalaria', 3.50, 1, 9),
('Zona Parque Industrial', 'Área industrial y logística', 8.00, 1, 10);
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