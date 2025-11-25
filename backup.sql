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

--
-- Table structure for table `aud_clientes`
--

DROP TABLE IF EXISTS `aud_clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `aud_clientes` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) DEFAULT NULL,
  `nombre` varchar(200) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `usuario` varchar(100) DEFAULT NULL,
  `accion` enum('INSERT','UPDATE','DELETE') NOT NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_log`),
  KEY `idx_id_cliente` (`id_cliente`),
  KEY `idx_nombre` (`nombre`),
  KEY `idx_fecha` (`fecha`),
  KEY `idx_accion` (`accion`),
  KEY `idx_usuario` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aud_clientes`
--

LOCK TABLES `aud_clientes` WRITE;
/*!40000 ALTER TABLE `aud_clientes` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `aud_clientes` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `aud_entregas`
--

DROP TABLE IF EXISTS `aud_entregas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `aud_entregas` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `id_entrega` int(11) DEFAULT NULL,
  `valores_anteriores` longtext DEFAULT NULL CHECK (json_valid(`valores_anteriores`)),
  `valores_nuevos` longtext DEFAULT NULL CHECK (json_valid(`valores_nuevos`)),
  `usuario` varchar(100) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aud_entregas`
--

LOCK TABLES `aud_entregas` WRITE;
/*!40000 ALTER TABLE `aud_entregas` DISABLE KEYS */;
set autocommit=0;
/*!40000 ALTER TABLE `aud_entregas` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `aud_incidencias`
--

DROP TABLE IF EXISTS `aud_incidencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `aud_incidencias` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `id_incidencia` int(11) DEFAULT NULL,
  `id_tipo_incidencia` int(11) DEFAULT NULL,
  `id_zona` int(11) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_inicio` timestamp NULL DEFAULT NULL,
  `fecha_fin` timestamp NULL DEFAULT NULL,
  `id_estado_incidencia` int(11) DEFAULT NULL,
  `id_nivel_impacto` int(11) DEFAULT NULL,
  `usuario_reporta` varchar(100) DEFAULT NULL,
  `geolocalizacion` varchar(255) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_log`),
  KEY `idx_id_incidencia` (`id_incidencia`),
  KEY `idx_fecha` (`fecha`),
  KEY `idx_estado` (`id_estado_incidencia`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aud_incidencias`
--

LOCK TABLES `aud_incidencias` WRITE;
/*!40000 ALTER TABLE `aud_incidencias` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `aud_incidencias` VALUES
(3,3,3,3,'Accidente vehicular en avenida principal | Estado cambiado: reportada → en investigacion','2025-11-24 05:19:29','2025-11-25 00:11:00',2,4,'Repartidor Demo','40.71480000, -74.00800000','2025-11-25 00:11:05'),
(4,3,3,3,'Accidente vehicular en avenida principal | Estado cambiado: en investigacion → reportada','2025-11-24 05:19:29','2025-11-25 00:11:00',1,4,'Repartidor Demo','40.71480000, -74.00800000','2025-11-25 00:12:45'),
(5,7,7,7,'Cliente no se encuentra en domicilio | ELIMINADA','2025-11-24 05:19:29',NULL,2,1,'Repartidor Demo','40.71880000, -74.01200000','2025-11-25 00:12:58'),
(6,11,4,7,'Robo a un banco','2025-11-25 00:24:00',NULL,1,3,'Administrador General',NULL,'2025-11-25 00:25:09'),
(7,11,4,7,'Robo a un banco | ELIMINADA','2025-11-25 00:24:00',NULL,1,3,'Administrador General',NULL,'2025-11-25 00:34:49'),
(8,3,3,3,'Accidente vehicular en avenida principal | Estado cambiado: reportada → en investigacion','2025-11-24 05:19:29','2025-11-25 00:11:00',2,4,'Repartidor Demo','40.71480000, -74.00800000','2025-11-25 00:37:24'),
(9,3,3,3,'Accidente vehicular en avenida principal | Estado cambiado: en investigacion → reportada','2025-11-24 05:19:29',NULL,1,4,'Repartidor Demo','40.71480000, -74.00800000','2025-11-25 00:40:52');
/*!40000 ALTER TABLE `aud_incidencias` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `aud_pedidos`
--

DROP TABLE IF EXISTS `aud_pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `aud_pedidos` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `id_pedido` int(11) DEFAULT NULL,
  `valores_anteriores` longtext DEFAULT NULL CHECK (json_valid(`valores_anteriores`)),
  `valores_nuevos` longtext DEFAULT NULL CHECK (json_valid(`valores_nuevos`)),
  `usuario` varchar(100) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aud_pedidos`
--

LOCK TABLES `aud_pedidos` WRITE;
/*!40000 ALTER TABLE `aud_pedidos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `aud_pedidos` VALUES
(1,11,NULL,'{\"id_cliente\": 3, \"id_direccion_entrega\": 3, \"id_estado_pedido\": 1, \"fecha_pedido\": \"2025-11-24 01:02:33\", \"fecha_estimada_entrega\": null, \"motivo_cancelacion\": null, \"penalizacion_cancelacion\": 0.00, \"total_pedido\": 0.00, \"peso_total\": 0.00, \"volumen_total\": 0.0000}','proyecto_user@localhost','2025-11-24 07:02:33'),
(2,11,'{\"id_cliente\": 3, \"id_direccion_entrega\": 3, \"id_estado_pedido\": 1, \"fecha_pedido\": \"2025-11-24 01:02:33\", \"fecha_estimada_entrega\": null, \"motivo_cancelacion\": null, \"penalizacion_cancelacion\": 0.00, \"total_pedido\": 0.00, \"peso_total\": 0.00, \"volumen_total\": 0.0000}','{\"id_cliente\": 3, \"id_direccion_entrega\": 3, \"id_estado_pedido\": 1, \"fecha_pedido\": \"2025-11-24 01:02:33\", \"fecha_estimada_entrega\": null, \"motivo_cancelacion\": null, \"penalizacion_cancelacion\": 0.00, \"total_pedido\": 250.00, \"peso_total\": 8.50, \"volumen_total\": 0.0450}','proyecto_user@localhost','2025-11-24 07:02:33'),
(3,12,NULL,'{\"id_cliente\": 4, \"id_direccion_entrega\": 4, \"id_estado_pedido\": 1, \"fecha_pedido\": \"2025-11-24 01:59:11\", \"fecha_estimada_entrega\": null, \"motivo_cancelacion\": null, \"penalizacion_cancelacion\": 0.00, \"total_pedido\": 0.00, \"peso_total\": 0.00, \"volumen_total\": 0.0000}','proyecto_user@localhost','2025-11-24 07:59:11'),
(4,12,'{\"id_cliente\": 4, \"id_direccion_entrega\": 4, \"id_estado_pedido\": 1, \"fecha_pedido\": \"2025-11-24 01:59:11\", \"fecha_estimada_entrega\": null, \"motivo_cancelacion\": null, \"penalizacion_cancelacion\": 0.00, \"total_pedido\": 0.00, \"peso_total\": 0.00, \"volumen_total\": 0.0000}','{\"id_cliente\": 4, \"id_direccion_entrega\": 4, \"id_estado_pedido\": 1, \"fecha_pedido\": \"2025-11-24 01:59:11\", \"fecha_estimada_entrega\": null, \"motivo_cancelacion\": null, \"penalizacion_cancelacion\": 0.00, \"total_pedido\": 900.00, \"peso_total\": 1.50, \"volumen_total\": 0.0090}','proyecto_user@localhost','2025-11-24 07:59:11');
/*!40000 ALTER TABLE `aud_pedidos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Table structure for table `aud_rutas`
--

DROP TABLE IF EXISTS `aud_rutas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `aud_rutas` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `id_ruta` int(11) NOT NULL,
  `nombre_ruta` varchar(100) NOT NULL,
  `id_zona` int(11) NOT NULL,
  `costo` decimal(10,2) DEFAULT 0.00,
  `usuario` varchar(100) NOT NULL,
  `accion` varchar(50) NOT NULL,
  `fecha` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aud_rutas`
--

LOCK TABLES `aud_rutas` WRITE;
/*!40000 ALTER TABLE `aud_rutas` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `aud_rutas` VALUES
(3,10,'Ruta Industrial',10,270.20,'proyecto_user@localhost','UPDATE','2025-11-25 03:48:58'),
(4,10,'Ruta Industrial',10,270.20,'proyecto_user@localhost','UPDATE','2025-11-25 03:55:05'),
(5,10,'Ruta Industrial',10,270.20,'root@localhost','UPDATE','2025-11-25 03:56:46'),
(6,10,'Ruta Industrial',10,270.20,'proyecto_user@localhost','UPDATE','2025-11-25 03:57:21'),
(7,10,'Ruta Industrial',10,270.20,'proyecto_user@localhost','UPDATE','2025-11-25 03:58:03'),
(10,13,'Ruta Norte - nocturna',1,0.00,'proyecto_user@localhost','INSERT','2025-11-25 04:25:35'),
(12,13,'Ruta Norte - nocturna',1,0.00,'proyecto_user@localhost','DELETE','2025-11-25 04:31:54'),
(13,14,'Ruta Norte - Nocturna',1,0.00,'proyecto_user@localhost','INSERT','2025-11-25 04:32:22'),
(14,14,'Ruta Norte - Nocturna',1,0.00,'proyecto_user@localhost','UPDATE','2025-11-25 04:32:35'),
(15,14,'Ruta Norte - Nocturna',1,0.00,'proyecto_user@localhost','DELETE','2025-11-25 04:32:54'),
(17,16,'Ruta Norte - mañana',1,0.00,'proyecto_user@localhost','INSERT','2025-11-25 04:35:48'),
(18,16,'Ruta Norte - mañana',1,0.00,'proyecto_user@localhost','UPDATE','2025-11-25 04:35:53'),
(19,16,'Ruta Norte - mañana',1,0.00,'proyecto_user@localhost','DELETE','2025-11-25 04:36:01');
/*!40000 ALTER TABLE `aud_rutas` ENABLE KEYS */;
UNLOCK TABLES;
commit;

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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `clientes` VALUES
(1,'Juan Pérez','+1234567890','juan.perez@email.com',1,'2025-11-24 06:19:28','2025-11-24 06:19:28'),
(2,'María García','+1234567891','maria.garcia@email.com',1,'2025-11-24 06:19:28','2025-11-24 06:19:28'),
(3,'Carlos López','+1234567892','carlos.lopez@email.com',1,'2025-11-24 06:19:28','2025-11-24 06:19:28'),
(4,'Ana Martínez','+1234567893','ana.martinez@email.com',1,'2025-11-24 06:19:28','2025-11-24 22:37:37'),
(5,'Pedro Rodríguez','+1234567894','pedro.rodriguez@email.com',1,'2025-11-24 06:19:28','2025-11-24 06:19:28'),
(6,'Laura Hernández','+1234567895','laura.hernandez@email.com',1,'2025-11-24 06:19:28','2025-11-24 06:19:28'),
(7,'Miguel Sánchez','+1234567896','miguel.sanchez@email.com',1,'2025-11-24 06:19:28','2025-11-24 06:19:28'),
(8,'Isabel Díaz','+1234567897','isabel.diaz@email.com',1,'2025-11-24 06:19:28','2025-11-24 06:19:28'),
(9,'Francisco Ruiz','+1234567898','francisco.ruiz@email.com',1,'2025-11-24 06:19:28','2025-11-24 06:19:28'),
(10,'Elena Torres','+1234567899','elena.torres@email.com',1,'2025-11-24 06:19:28','2025-11-24 06:19:28');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER after_clientes_insert
    AFTER INSERT ON clientes
    FOR EACH ROW
BEGIN
    DECLARE v_usuario VARCHAR(100);
    
    
    SELECT @usuario_sistema INTO v_usuario;
    
    
    IF v_usuario IS NULL THEN
        SET v_usuario = USER();
    END IF;
    
    INSERT INTO aud_clientes (
        id_cliente,
        nombre,
        telefono,
        email,
        usuario,  
        accion
    ) VALUES (
        NEW.id_cliente,
        NEW.nombre,
        NEW.telefono,
        NEW.email,
        v_usuario,  
        'INSERT'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER after_clientes_update
    AFTER UPDATE ON clientes
    FOR EACH ROW
BEGIN
    DECLARE v_usuario VARCHAR(100);
    
    
    SELECT @usuario_sistema INTO v_usuario;
    
    
    IF v_usuario IS NULL THEN
        SET v_usuario = USER();
    END IF;
    
    
    IF OLD.nombre != NEW.nombre OR OLD.telefono != NEW.telefono OR OLD.email != NEW.email THEN
        INSERT INTO aud_clientes (
            id_cliente,
            nombre,
            telefono,
            email,
            usuario,  
            accion
        ) VALUES (
            NEW.id_cliente,
            NEW.nombre,
            NEW.telefono,
            NEW.email,
            v_usuario,  
            'UPDATE'
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER before_clientes_delete
    BEFORE DELETE ON clientes
    FOR EACH ROW
BEGIN
    DECLARE v_usuario VARCHAR(100);
    
    
    SELECT @usuario_sistema INTO v_usuario;
    
    
    IF v_usuario IS NULL THEN
        SET v_usuario = USER();
    END IF;
    
    
    INSERT INTO aud_clientes (
        id_cliente,
        nombre,
        telefono,
        email,
        usuario,  
        accion
    ) VALUES (
        OLD.id_cliente,
        OLD.nombre,
        OLD.telefono,
        OLD.email,
        v_usuario,  
        'DELETE'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `costos_operativos`
--

LOCK TABLES `costos_operativos` WRITE;
/*!40000 ALTER TABLE `costos_operativos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `costos_operativos` VALUES
(1,1,1,1,15.50,25.50,'2025-11-24','Combustible para ruta norte','2025-11-24 06:19:28'),
(2,2,2,2,45.00,18.75,'2025-11-24','Cambio de aceite','2025-11-24 06:19:28'),
(3,3,3,3,12.00,32.00,'2025-11-24','Peajes ruta este','2025-11-24 06:19:28'),
(4,4,4,4,8.50,28.25,'2025-11-24','Estacionamiento centro','2025-11-24 06:19:28'),
(5,5,5,5,12.00,15.80,'2025-11-24','Lavado completo','2025-11-24 06:19:28'),
(6,6,6,6,25.00,45.30,'2025-11-24','Pago de seguro mensual','2025-11-24 06:19:28'),
(7,7,7,7,15.00,12.50,'2025-11-24','Renovación de licencia','2025-11-24 06:19:28'),
(8,8,8,8,35.00,22.75,'2025-11-24','Reparación de frenos','2025-11-24 06:19:28'),
(9,9,9,9,20.00,19.40,'2025-11-24','Multa por estacionamiento','2025-11-24 06:19:28'),
(10,10,10,10,10.00,38.60,'2025-11-24','Gastos varios','2025-11-24 06:19:28');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalle_pedido`
--

LOCK TABLES `detalle_pedido` WRITE;
/*!40000 ALTER TABLE `detalle_pedido` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `detalle_pedido` VALUES
(1,1,1,1,1200.00),
(2,2,2,1,800.00),
(3,3,1,1,1200.00),
(4,3,7,1,50.00),
(5,4,3,1,300.00),
(6,4,4,1,150.00),
(7,5,5,1,200.00),
(8,5,6,1,80.00),
(9,6,4,1,150.00),
(10,7,8,1,250.00),
(11,11,8,1,250.00),
(12,12,4,6,900.00);
/*!40000 ALTER TABLE `detalle_pedido` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER detallePedidoValidacionBI
BEFORE INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    IF NEW.cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: La cantidad del producto debe ser mayor que cero.';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM productos WHERE id_producto = NEW.id_producto) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: El ID de producto especificado no es válido.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER detallePedidoValidacionBU
BEFORE UPDATE ON detalle_pedido
FOR EACH ROW
BEGIN
    IF NEW.cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: La cantidad del producto debe ser mayor que cero.';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM productos WHERE id_producto = NEW.id_producto) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: El ID de producto especificado no es válido.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `direcciones_cliente`
--

LOCK TABLES `direcciones_cliente` WRITE;
/*!40000 ALTER TABLE `direcciones_cliente` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `direcciones_cliente` VALUES
(1,1,'Calle Principal 123, Apt 4B',1,1,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',1),
(2,2,'Avenida Central 456, Casa 2',2,1,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',2),
(3,3,'Calle Secundaria 789, Piso 3',3,1,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',3),
(4,4,'Boulevard Norte 321, Local 5',3,1,3,'2025-11-24 06:19:29','2025-11-24 21:26:09',4),
(5,5,'Calle Sur 654, Edificio A',5,1,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',5),
(6,6,'Avenida Este 987, Casa 10',6,1,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',6),
(7,7,'Calle Oeste 147, Apt 7C',7,1,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',7),
(8,8,'Paseo del Parque 258, Piso 2',8,1,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',8),
(9,9,'Camino Real 369, Local 8',9,1,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',9),
(10,10,'Ruta Comercial 741, Casa 12',10,1,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',10);
/*!40000 ALTER TABLE `direcciones_cliente` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER normalizaDireccionClienteBI
BEFORE INSERT ON direcciones_cliente
FOR EACH ROW
BEGIN
    SET NEW.direccion = TRIM(NEW.direccion);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER normalizaDireccionClienteBU
BEFORE UPDATE ON direcciones_cliente
FOR EACH ROW
BEGIN
    SET NEW.direccion = TRIM(NEW.direccion);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `empresas`
--

DROP TABLE IF EXISTS `empresas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `empresas` (
  `id_empresa` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(200) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `id_estado_empresa` int(11) NOT NULL,
  `fecha_creacion` timestamp NULL DEFAULT current_timestamp(),
  `fecha_actualizacion` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_empresa`),
  KEY `id_estado_empresa` (`id_estado_empresa`),
  CONSTRAINT `empresas_ibfk_1` FOREIGN KEY (`id_estado_empresa`) REFERENCES `estados_empresa` (`id_estado_empresa`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empresas`
--

LOCK TABLES `empresas` WRITE;
/*!40000 ALTER TABLE `empresas` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `empresas` VALUES
(1,'Tech Solutions SA','+1234567801','ventas@techsolutions.com','Av. Tecnológica 123, Parque Industrial',1,'2025-11-24 18:47:41','2025-11-24 18:47:41'),
(2,'ElectroHome Corp','+1234567802','pedidos@electrohome.com','Calle Comercial 456, Centro',1,'2025-11-24 18:47:41','2025-11-24 18:47:41'),
(3,'Gadget Store','+1234567803','info@gadgetstore.com','Plaza Shopping 789, Local 15',1,'2025-11-24 18:47:41','2025-11-24 18:47:41'),
(4,'Digital World','+1234567804','contacto@digitalworld.com','Boulevard Digital 321, Piso 8',1,'2025-11-24 18:47:41','2025-11-24 18:47:41'),
(5,'Smart Devices Inc','+1234567805','ventas@smartdevices.com','Zona Franca 654, Bodega 12',1,'2025-11-24 18:47:41','2025-11-24 18:47:41');
/*!40000 ALTER TABLE `empresas` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entregas`
--

LOCK TABLES `entregas` WRITE;
/*!40000 ALTER TABLE `entregas` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `entregas` VALUES
(1,1,1,3,1,'2025-11-26 06:19:29',NULL,NULL,NULL,0,0,0,0,5.00,'2025-11-24 06:19:29','2025-11-24 06:19:29',NULL),
(2,2,2,3,2,'2025-11-25 06:19:29','2025-11-24 06:19:29',NULL,NULL,0,0,0,0,4.50,'2025-11-24 06:19:29','2025-11-24 06:19:29',NULL),
(3,3,3,3,3,'2025-11-27 06:19:29','2025-11-24 05:49:29',NULL,NULL,30,0,1,0,6.25,'2025-11-24 06:19:29','2025-11-24 06:19:29',NULL),
(4,4,4,3,4,'2025-11-25 06:19:29','2025-11-24 05:34:29',NULL,NULL,45,0,1,0,5.75,'2025-11-24 06:19:29','2025-11-24 06:19:29',NULL),
(5,5,5,3,5,'2025-11-26 06:19:29','2025-11-24 05:19:29','2025-11-24 06:19:29','2025-11-24 06:19:29',60,0,1,0,7.20,'2025-11-24 06:19:29','2025-11-24 06:19:29',NULL),
(6,6,6,3,5,'2025-11-23 06:19:29','2025-11-24 04:19:29','2025-11-24 05:19:29','2025-11-24 05:19:29',60,0,1,0,8.50,'2025-11-24 06:19:29','2025-11-24 06:19:29',NULL),
(7,7,7,3,5,'2025-11-22 06:19:29','2025-11-24 03:19:29','2025-11-24 04:19:29','2025-11-24 04:19:29',60,0,1,0,9.30,'2025-11-24 06:19:29','2025-11-24 06:19:29',NULL),
(8,8,8,3,6,'2025-11-28 06:19:29','2025-11-24 06:04:29','2025-11-24 06:19:29',NULL,15,1,0,0,3.80,'2025-11-24 06:19:29','2025-11-24 06:19:29',NULL),
(9,9,9,3,1,'2025-11-26 06:19:29',NULL,NULL,NULL,0,0,0,0,4.20,'2025-11-24 06:19:29','2025-11-24 06:19:29',NULL),
(10,10,10,3,2,'2025-11-27 06:19:29','2025-11-24 06:19:29',NULL,NULL,0,0,0,0,5.60,'2025-11-24 06:19:29','2025-11-24 06:19:29',NULL);
/*!40000 ALTER TABLE `entregas` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER entregas_ai
AFTER INSERT ON entregas
FOR EACH ROW
BEGIN
    INSERT INTO aud_entregas (
        id_entrega, valores_anteriores, valores_nuevos, usuario, fecha
    ) VALUES (
        NEW.id_entrega, NULL,
        JSON_OBJECT(
            'id_pedido', NEW.id_pedido, 'id_ruta', NEW.id_ruta, 'id_repartidor', NEW.id_repartidor,
            'id_estado_entrega', NEW.id_estado_entrega, 'fecha_estimada_entrega', NEW.fecha_estimada_entrega,
            'hora_inicio_entrega', NEW.hora_inicio_entrega, 'fecha_fin_entrega', NEW.fecha_real_entrega,
            'tiempo_entrega_minutos', NEW.tiempo_entrega_minutos, 'reintentos', NEW.reintentos,
            'cumplio_sla', NEW.cumplio_sla, 'fue_tarde', NEW.fue_tarde, 'costo_entrega', NEW.costo_entrega,
            'id_motivo_fallo', NEW.id_motivo_fallo
        ),
        CURRENT_USER(), NOW()
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER slaRetrasoMarcaAIEntrega
AFTER INSERT ON entregas
FOR EACH ROW
BEGIN
    IF NEW.fecha_estimada_entrega < NOW() THEN
        UPDATE entregas SET fue_tarde = 1 WHERE id_entrega = NEW.id_entrega;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER entregaEstadoBU
BEFORE UPDATE ON entregas
FOR EACH ROW
BEGIN
    DECLARE old_estado VARCHAR(50);
    DECLARE new_estado VARCHAR(50);
    SELECT nombre_estado INTO old_estado FROM estados_entrega WHERE id_estado_entrega = OLD.id_estado_entrega;
    SELECT nombre_estado INTO new_estado FROM estados_entrega WHERE id_estado_entrega = NEW.id_estado_entrega;

    IF old_estado IN ('entregada', 'fallida') AND new_estado <> old_estado THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: No se puede cambiar el estado de una entrega que ya fue completada o fallida.';
    END IF;
    IF old_estado = 'pendiente' AND new_estado NOT IN ('asignada', 'reprogramada') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: Desde "pendiente" solo se puede pasar a "asignada" o "reprogramada".';
    END IF;
    IF old_estado = 'asignada' AND new_estado NOT IN ('en camino', 'reprogramada') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: Desde "asignada" solo se puede pasar a "en camino" o "reprogramada".';
    END IF;
    IF old_estado = 'en camino' AND new_estado NOT IN ('en destino', 'fallida', 'reprogramada') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: Desde "en camino" solo se puede pasar a "en destino", "fallida" o "reprogramada".';
    END IF;
    IF old_estado = 'en destino' AND new_estado NOT IN ('entregada', 'fallida', 'reprogramada') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: Desde "en destino" solo se puede pasar a "entregada", "fallida" o "reprogramada".';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER entregas_au
AFTER UPDATE ON entregas
FOR EACH ROW
BEGIN
    INSERT INTO aud_entregas (
        id_entrega, valores_anteriores, valores_nuevos, usuario, fecha
    ) VALUES (
        NEW.id_entrega,
        JSON_OBJECT(
            'id_pedido', OLD.id_pedido, 'id_ruta', OLD.id_ruta, 'id_repartidor', OLD.id_repartidor,
            'id_estado_entrega', OLD.id_estado_entrega, 'fecha_estimada_entrega', OLD.fecha_estimada_entrega,
            'hora_inicio_entrega', OLD.hora_inicio_entrega, 'fecha_fin_entrega', OLD.fecha_real_entrega,
            'tiempo_entrega_minutos', OLD.tiempo_entrega_minutos, 'reintentos', OLD.reintentos,
            'cumplio_sla', OLD.cumplio_sla, 'fue_tarde', OLD.fue_tarde, 'costo_entrega', OLD.costo_entrega,
            'id_motivo_fallo', OLD.id_motivo_fallo
        ),
        JSON_OBJECT(
            'id_pedido', NEW.id_pedido, 'id_ruta', NEW.id_ruta, 'id_repartidor', NEW.id_repartidor,
            'id_estado_entrega', NEW.id_estado_entrega, 'fecha_estimada_entrega', NEW.fecha_estimada_entrega,
            'hora_inicio_entrega', NEW.hora_inicio_entrega, 'fecha_fin_entrega', NEW.fecha_real_entrega,
            'tiempo_entrega_minutos', NEW.tiempo_entrega_minutos, 'reintentos', NEW.reintentos,
            'cumplio_sla', NEW.cumplio_sla, 'fue_tarde', NEW.fue_tarde, 'costo_entrega', NEW.costo_entrega,
            'id_motivo_fallo', NEW.id_motivo_fallo
        ),
        CURRENT_USER(), NOW()
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER entregas_ad
AFTER DELETE ON entregas
FOR EACH ROW
BEGIN
    INSERT INTO aud_entregas (
        id_entrega, valores_anteriores, valores_nuevos, usuario, fecha
    ) VALUES (
        OLD.id_entrega,
        JSON_OBJECT(
            'id_pedido', OLD.id_pedido, 'id_ruta', OLD.id_ruta, 'id_repartidor', OLD.id_repartidor,
            'id_estado_entrega', OLD.id_estado_entrega, 'fecha_estimada_entrega', OLD.fecha_estimada_entrega,
            'hora_inicio_entrega', OLD.hora_inicio_entrega, 'fecha_fin_entrega', OLD.fecha_real_entrega,
            'tiempo_entrega_minutos', OLD.tiempo_entrega_minutos, 'reintentos', OLD.reintentos,
            'cumplio_sla', OLD.cumplio_sla, 'fue_tarde', OLD.fue_tarde, 'costo_entrega', OLD.costo_entrega,
            'id_motivo_fallo', OLD.id_motivo_fallo
        ),
        NULL, CURRENT_USER(), NOW()
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
-- Table structure for table `estados_empresa`
--

DROP TABLE IF EXISTS `estados_empresa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados_empresa` (
  `id_estado_empresa` int(11) NOT NULL AUTO_INCREMENT,
  `nombre_estado` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`id_estado_empresa`),
  UNIQUE KEY `nombre_estado` (`nombre_estado`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estados_empresa`
--

LOCK TABLES `estados_empresa` WRITE;
/*!40000 ALTER TABLE `estados_empresa` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `estados_empresa` VALUES
(1,'activa','Empresa activa'),
(2,'inactiva','Empresa inactiva'),
(3,'suspendida','Empresa suspendida');
/*!40000 ALTER TABLE `estados_empresa` ENABLE KEYS */;
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
(1,'Por aprobar','Ruta por aprobar'),
(2,'Aprobada','Ruta aprobada para uso'),
(3,'En uso','Ruta en uso'),
(4,'Sin servicio','Ruta fuera de servicio');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `evidencias`
--

LOCK TABLES `evidencias` WRITE;
/*!40000 ALTER TABLE `evidencias` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `evidencias` VALUES
(1,5,NULL,NULL,'foto_entrega','/evidencias/entrega_5_1.jpg','Foto del paquete entregado','2025-11-24 06:19:29'),
(2,6,NULL,NULL,'firma_cliente','/evidencias/firma_6_1.png','Firma del cliente recibido','2025-11-24 06:19:29'),
(3,NULL,1,NULL,'foto_costo','/evidencias/costo_1_1.jpg','Ticket de combustible','2025-11-24 06:19:29'),
(4,NULL,2,NULL,'foto_costo','/evidencias/costo_2_1.jpg','Factura de mantenimiento','2025-11-24 06:19:29'),
(5,7,NULL,NULL,'foto_entrega','/evidencias/entrega_7_1.jpg','Foto del lugar de entrega','2025-11-24 06:19:29'),
(6,NULL,3,NULL,'foto_costo','/evidencias/costo_3_1.jpg','Ticket de peaje','2025-11-24 06:19:29'),
(7,8,NULL,NULL,'firma_cliente','/evidencias/firma_8_1.png','Firma de rechazo','2025-11-24 06:19:29'),
(8,NULL,4,NULL,'foto_costo','/evidencias/costo_4_1.jpg','Ticket de estacionamiento','2025-11-24 06:19:29'),
(9,5,NULL,NULL,'otro','/evidencias/entrega_5_2.pdf','Documentación adicional','2025-11-24 06:19:29'),
(10,NULL,5,NULL,'foto_costo','/evidencias/costo_5_1.jpg','Factura de lavado','2025-11-24 06:19:29');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `geolocalizacion`
--

LOCK TABLES `geolocalizacion` WRITE;
/*!40000 ALTER TABLE `geolocalizacion` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `geolocalizacion` VALUES
(1,40.71280000,-74.00600000),
(2,40.71380000,-74.00700000),
(3,40.71480000,-74.00800000),
(4,40.71580000,-74.00900000),
(5,40.71680000,-74.01000000),
(6,40.71780000,-74.01100000),
(7,40.71880000,-74.01200000),
(8,40.71980000,-74.01300000),
(9,40.72080000,-74.01400000),
(10,40.72180000,-74.01500000);
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `incidencias`
--

LOCK TABLES `incidencias` WRITE;
/*!40000 ALTER TABLE `incidencias` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `incidencias` VALUES
(1,1,1,'Congestión vehicular por accidente menor','2025-11-24 04:19:29','2025-11-24 05:19:29',3,2,1.50,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',1),
(2,2,2,'Lluvia intensa afectando visibilidad','2025-11-24 03:19:29',NULL,2,3,3.00,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',2),
(3,3,3,'Accidente vehicular en avenida principal','2025-11-24 05:19:29',NULL,1,4,2.00,3,'2025-11-24 06:19:29','2025-11-25 00:40:52',3),
(4,4,4,'Manifestación bloqueando calles principales','2025-11-24 02:19:29','2025-11-24 04:19:29',3,4,1.00,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',4),
(5,5,5,'Trabajos de mantenimiento en vía rápida','2025-11-24 01:19:29','2025-11-24 05:19:29',3,2,0.50,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',5),
(6,6,6,'Vehículo con falla mecánica','2025-11-24 04:19:29','2025-11-24 05:49:29',3,3,0.00,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',6),
(8,8,8,'Dirección incorrecta en sistema','2025-11-24 03:19:29','2025-11-24 05:19:29',3,2,0.00,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',8),
(9,9,9,'Paquete dañado durante transporte','2025-11-24 04:19:29',NULL,1,3,0.00,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',9),
(10,10,10,'Problema de comunicación con centro','2025-11-24 05:19:29','2025-11-24 05:49:29',3,2,0.00,3,'2025-11-24 06:19:29','2025-11-24 06:19:29',10);
/*!40000 ALTER TABLE `incidencias` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER incidenciaBloqueoBI
BEFORE INSERT ON incidencias
FOR EACH ROW
BEGIN
    DECLARE incidencias_activas INT;
    SELECT COUNT(*) INTO incidencias_activas
    FROM incidencias
    WHERE id_zona = NEW.id_zona AND id_estado_incidencia IN (SELECT id_estado_incidencia FROM estados_incidencia WHERE nombre_estado IN ('reportada', 'en investigacion'));
    IF incidencias_activas > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: Ya existe una incidencia activa en esta zona. Resuelva o cierre la incidencia anterior antes de crear una nueva.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER after_incidencias_insert
    AFTER INSERT ON incidencias
    FOR EACH ROW
BEGIN
    DECLARE v_usuario_reporta_nombre VARCHAR(100);
    DECLARE v_geolocalizacion_text VARCHAR(255);
    
    
    SELECT nombre INTO v_usuario_reporta_nombre
    FROM usuarios 
    WHERE id_usuario = NEW.id_usuario_reporta;
    
    
    IF NEW.id_geo IS NOT NULL THEN
        SELECT CONCAT(latitud, ', ', longitud) INTO v_geolocalizacion_text
        FROM geolocalizacion 
        WHERE id_geo = NEW.id_geo;
    ELSE
        SET v_geolocalizacion_text = NULL;
    END IF;
    
    
    INSERT INTO aud_incidencias (
        id_incidencia,
        id_tipo_incidencia,
        id_zona,
        descripcion,
        fecha_inicio,
        fecha_fin,
        id_estado_incidencia,
        id_nivel_impacto,
        usuario_reporta,
        geolocalizacion
    ) VALUES (
        NEW.id_incidencia,
        NEW.id_tipo_incidencia,
        NEW.id_zona,
        NEW.descripcion,
        NEW.fecha_inicio,
        NEW.fecha_fin,
        NEW.id_estado_incidencia,
        NEW.id_nivel_impacto,
        v_usuario_reporta_nombre,
        v_geolocalizacion_text
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER incidenciaBloqueoBU
BEFORE UPDATE ON incidencias
FOR EACH ROW
BEGIN
    DECLARE incidencias_activas INT;
    SELECT COUNT(*) INTO incidencias_activas
    FROM incidencias
    WHERE id_zona = NEW.id_zona AND id_estado_incidencia IN (SELECT id_estado_incidencia FROM estados_incidencia WHERE nombre_estado IN ('reportada', 'en investigacion')) AND id_incidencia <> OLD.id_incidencia;
    IF incidencias_activas > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: Ya existe una incidencia activa en esta zona. Resuelva o cierre la incidencia anterior.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER after_incidencias_update
    AFTER UPDATE ON incidencias
    FOR EACH ROW
BEGIN
    DECLARE v_usuario_reporta_nombre VARCHAR(100);
    DECLARE v_geolocalizacion_text VARCHAR(255);
    
    
    IF OLD.id_estado_incidencia != NEW.id_estado_incidencia 
       OR OLD.fecha_fin != NEW.fecha_fin 
       OR OLD.id_nivel_impacto != NEW.id_nivel_impacto THEN
        
        
        SELECT nombre INTO v_usuario_reporta_nombre
        FROM usuarios 
        WHERE id_usuario = NEW.id_usuario_reporta;
        
        
        IF NEW.id_geo IS NOT NULL THEN
            SELECT CONCAT(latitud, ', ', longitud) INTO v_geolocalizacion_text
            FROM geolocalizacion 
            WHERE id_geo = NEW.id_geo;
        ELSE
            SET v_geolocalizacion_text = NULL;
        END IF;
        
        
        INSERT INTO aud_incidencias (
            id_incidencia,
            id_tipo_incidencia,
            id_zona,
            descripcion,
            fecha_inicio,
            fecha_fin,
            id_estado_incidencia,
            id_nivel_impacto,
            usuario_reporta,
            geolocalizacion
        ) VALUES (
            NEW.id_incidencia,
            NEW.id_tipo_incidencia,
            NEW.id_zona,
            CONCAT(
                NEW.descripcion, 
                ' | Estado cambiado: ', 
                (SELECT nombre_estado FROM estados_incidencia WHERE id_estado_incidencia = OLD.id_estado_incidencia),
                ' → ',
                (SELECT nombre_estado FROM estados_incidencia WHERE id_estado_incidencia = NEW.id_estado_incidencia)
            ),
            NEW.fecha_inicio,
            NEW.fecha_fin,
            NEW.id_estado_incidencia,
            NEW.id_nivel_impacto,
            v_usuario_reporta_nombre,
            v_geolocalizacion_text
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER before_incidencias_delete
    BEFORE DELETE ON incidencias
    FOR EACH ROW
BEGIN
    DECLARE v_usuario_reporta_nombre VARCHAR(100);
    DECLARE v_geolocalizacion_text VARCHAR(255);
    
    
    SELECT nombre INTO v_usuario_reporta_nombre
    FROM usuarios 
    WHERE id_usuario = OLD.id_usuario_reporta;
    
    
    IF OLD.id_geo IS NOT NULL THEN
        SELECT CONCAT(latitud, ', ', longitud) INTO v_geolocalizacion_text
        FROM geolocalizacion 
        WHERE id_geo = OLD.id_geo;
    ELSE
        SET v_geolocalizacion_text = NULL;
    END IF;
    
    
    INSERT INTO aud_incidencias (
        id_incidencia,
        id_tipo_incidencia,
        id_zona,
        descripcion,
        fecha_inicio,
        fecha_fin,
        id_estado_incidencia,
        id_nivel_impacto,
        usuario_reporta,
        geolocalizacion
    ) VALUES (
        OLD.id_incidencia,
        OLD.id_tipo_incidencia,
        OLD.id_zona,
        CONCAT(OLD.descripcion, ' | ELIMINADA'),
        OLD.fecha_inicio,
        OLD.fecha_fin,
        OLD.id_estado_incidencia,
        OLD.id_nivel_impacto,
        v_usuario_reporta_nombre,
        v_geolocalizacion_text
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `niveles_impacto`
--

LOCK TABLES `niveles_impacto` WRITE;
/*!40000 ALTER TABLE `niveles_impacto` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `niveles_impacto` VALUES
(1,'Bajo','Impacto mínimo en las operaciones'),
(2,'Medio','Impacto moderado en las operaciones'),
(3,'Alto','Impacto significativo en las operaciones'),
(4,'Crítico','Impacto crítico que detiene operaciones'),
(5,'Localizado','Impacto en área específica'),
(6,'Extendido','Impacto en múltiples áreas'),
(7,'Temporal','Impacto de corta duración'),
(8,'Prolongado','Impacto de larga duración'),
(9,'Recurrente','Impacto que se repite frecuentemente'),
(10,'Inesperado','Impacto no previsto');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp`
--

LOCK TABLES `otp` WRITE;
/*!40000 ALTER TABLE `otp` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `otp` VALUES
(1,1,'123456',0,'2025-11-24 06:19:30',NULL),
(2,2,'234567',0,'2025-11-24 06:19:30',NULL),
(3,3,'345678',1,'2025-11-24 06:19:30','2025-11-24 05:49:30'),
(4,4,'456789',1,'2025-11-24 06:19:30','2025-11-24 05:34:30'),
(5,5,'567890',1,'2025-11-24 06:19:30','2025-11-24 05:19:30'),
(6,6,'678901',1,'2025-11-24 06:19:30','2025-11-24 04:19:30'),
(7,7,'789012',1,'2025-11-24 06:19:30','2025-11-24 03:19:30'),
(8,8,'890123',0,'2025-11-24 06:19:30',NULL),
(9,9,'901234',0,'2025-11-24 06:19:30',NULL),
(10,10,'012345',0,'2025-11-24 06:19:30',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paradas_ruta`
--

LOCK TABLES `paradas_ruta` WRITE;
/*!40000 ALTER TABLE `paradas_ruta` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `paradas_ruta` VALUES
(1,1,1,1,1,0.00,0,'2025-11-26 06:19:30',NULL),
(2,2,2,1,2,0.00,0,'2025-11-25 06:19:30',NULL),
(3,3,3,1,3,0.00,0,'2025-11-27 06:19:30',NULL),
(4,4,4,1,4,0.00,0,'2025-11-25 06:19:30',NULL),
(5,5,5,1,1,0.00,0,'2025-11-26 06:19:30',NULL),
(6,6,6,1,2,0.00,0,'2025-11-23 06:19:30',NULL),
(7,7,7,1,3,0.00,0,'2025-11-22 06:19:30',NULL),
(8,8,8,1,4,0.00,0,'2025-11-28 06:19:30',NULL),
(9,9,9,1,1,0.00,0,'2025-11-26 06:19:30',NULL),
(10,10,10,1,2,0.00,0,'2025-11-27 06:19:30',NULL);
/*!40000 ALTER TABLE `paradas_ruta` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER vehiculoCapacidadBI
BEFORE INSERT ON paradas_ruta
FOR EACH ROW
BEGIN
    DECLARE capacidad_peso_vehiculo DECIMAL(10,2);
    DECLARE capacidad_volumen_vehiculo DECIMAL(10,2);
    DECLARE peso_actual_ruta DECIMAL(10,2) DEFAULT 0;
    DECLARE volumen_actual_ruta DECIMAL(10,2) DEFAULT 0;
    DECLARE peso_nuevo_pedido DECIMAL(10,2) DEFAULT 0;
    DECLARE volumen_nuevo_pedido DECIMAL(10,2) DEFAULT 0;

    SELECT tv.capacidad_maxima_kg, tv.capacidad_volumen_m3 INTO capacidad_peso_vehiculo, capacidad_volumen_vehiculo
    FROM rutas r JOIN vehiculos v ON r.id_vehiculo = v.id_vehiculo JOIN tipos_vehiculo tv ON v.id_tipo_vehiculo = tv.id_tipo_vehiculo
    WHERE r.id_ruta = NEW.id_ruta;

    SELECT SUM(dp.cantidad * prd.peso_kg), SUM(dp.cantidad * prd.volumen_m3) INTO peso_actual_ruta, volumen_actual_ruta
    FROM paradas_ruta pr JOIN pedidos p ON pr.id_pedido = p.id_pedido JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido JOIN productos prd ON dp.id_producto = prd.id_producto
    WHERE pr.id_ruta = NEW.id_ruta;

    SELECT SUM(dp.cantidad * prd.peso_kg), SUM(dp.cantidad * prd.volumen_m3) INTO peso_nuevo_pedido, volumen_nuevo_pedido
    FROM pedidos p JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido JOIN productos prd ON dp.id_producto = prd.id_producto
    WHERE p.id_pedido = NEW.id_pedido;

    IF (peso_actual_ruta + peso_nuevo_pedido) > capacidad_peso_vehiculo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: El pedido excede la capacidad de peso del vehículo para esta ruta.';
    END IF;
    IF (volumen_actual_ruta + volumen_nuevo_pedido) > capacidad_volumen_vehiculo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: El pedido excede la capacidad de volumen del vehículo para esta ruta.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER vehiculoCapacidadBU
BEFORE UPDATE ON paradas_ruta
FOR EACH ROW
BEGIN
    DECLARE capacidad_peso_vehiculo DECIMAL(10,2);
    DECLARE capacidad_volumen_vehiculo DECIMAL(10,2);
    DECLARE peso_actual_ruta DECIMAL(10,2) DEFAULT 0;
    DECLARE volumen_actual_ruta DECIMAL(10,2) DEFAULT 0;
    DECLARE peso_nuevo_pedido DECIMAL(10,2) DEFAULT 0;
    DECLARE volumen_nuevo_pedido DECIMAL(10,2) DEFAULT 0;

    SELECT tv.capacidad_maxima_kg, tv.capacidad_volumen_m3 INTO capacidad_peso_vehiculo, capacidad_volumen_vehiculo
    FROM rutas r JOIN vehiculos v ON r.id_vehiculo = v.id_vehiculo JOIN tipos_vehiculo tv ON v.id_tipo_vehiculo = tv.id_tipo_vehiculo
    WHERE r.id_ruta = NEW.id_ruta;

    SELECT SUM(dp.cantidad * prd.peso_kg), SUM(dp.cantidad * prd.volumen_m3) INTO peso_actual_ruta, volumen_actual_ruta
    FROM paradas_ruta pr JOIN pedidos p ON pr.id_pedido = p.id_pedido JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido JOIN productos prd ON dp.id_producto = prd.id_producto
    WHERE pr.id_ruta = NEW.id_ruta AND pr.id_pedido <> NEW.id_pedido;

    SELECT SUM(dp.cantidad * prd.peso_kg), SUM(dp.cantidad * prd.volumen_m3) INTO peso_nuevo_pedido, volumen_nuevo_pedido
    FROM pedidos p JOIN detalle_pedido dp ON p.id_pedido = dp.id_pedido JOIN productos prd ON dp.id_producto = prd.id_producto
    WHERE p.id_pedido = NEW.id_pedido;

    IF (peso_actual_ruta + peso_nuevo_pedido) > capacidad_peso_vehiculo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: El pedido excede la capacidad de peso del vehículo para esta ruta.';
    END IF;
    IF (volumen_actual_ruta + volumen_nuevo_pedido) > capacidad_volumen_vehiculo THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: El pedido excede la capacidad de volumen del vehículo para esta ruta.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `id_pedido` int(11) NOT NULL AUTO_INCREMENT,
  `id_cliente` int(11) NOT NULL,
  `id_empresa` int(11) DEFAULT NULL,
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
  KEY `id_empresa` (`id_empresa`),
  CONSTRAINT `fk_pedidos_estado` FOREIGN KEY (`id_estado_pedido`) REFERENCES `estados_pedido` (`id_estado_pedido`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `clientes` (`id_cliente`),
  CONSTRAINT `pedidos_ibfk_2` FOREIGN KEY (`id_direccion_entrega`) REFERENCES `direcciones_cliente` (`id_direccion`),
  CONSTRAINT `pedidos_ibfk_empresa` FOREIGN KEY (`id_empresa`) REFERENCES `empresas` (`id_empresa`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `pedidos` VALUES
(1,1,NULL,1,1,'2025-11-24 06:19:30','2025-11-26 06:19:30',NULL,0.00,1200.00,2.50,0.0150,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(2,2,NULL,2,2,'2025-11-24 06:19:30','2025-11-25 06:19:30',NULL,0.00,800.00,0.20,0.0008,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(3,3,NULL,3,3,'2025-11-24 06:19:30','2025-11-27 06:19:30',NULL,0.00,1100.00,2.70,0.0165,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(4,4,NULL,4,4,'2025-11-24 06:19:30','2025-11-25 06:19:30',NULL,0.00,450.00,0.75,0.0045,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(5,5,NULL,5,5,'2025-11-24 06:19:30','2025-11-26 06:19:30',NULL,0.00,280.00,1.25,0.0051,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(6,6,NULL,6,6,'2025-11-24 06:19:30','2025-11-23 06:19:30',NULL,0.00,150.00,0.25,0.0015,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(7,7,NULL,7,6,'2025-11-24 06:19:30','2025-11-22 06:19:30',NULL,0.00,250.00,8.50,0.0450,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(8,8,NULL,8,1,'2025-11-24 06:19:30','2025-11-28 06:19:30',NULL,0.00,90.00,0.48,0.0021,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(9,9,NULL,9,2,'2025-11-24 06:19:30','2025-11-26 06:19:30',NULL,0.00,60.00,0.30,0.0012,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(10,10,NULL,10,3,'2025-11-24 06:19:30','2025-11-27 06:19:30',NULL,0.00,40.00,0.18,0.0009,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(11,3,NULL,3,1,'2025-11-24 07:02:33',NULL,NULL,0.00,250.00,8.50,0.0450,'2025-11-24 07:02:33','2025-11-24 07:02:33'),
(12,4,NULL,4,1,'2025-11-24 07:59:11',NULL,NULL,0.00,900.00,1.50,0.0090,'2025-11-24 07:59:11','2025-11-24 07:59:11');
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER pedidos_ai
AFTER INSERT ON pedidos
FOR EACH ROW
BEGIN
    INSERT INTO aud_pedidos (
        id_pedido, valores_anteriores, valores_nuevos, usuario, fecha
    ) VALUES (
        NEW.id_pedido, NULL,
        JSON_OBJECT(
            'id_cliente', NEW.id_cliente, 'id_direccion_entrega', NEW.id_direccion_entrega,
            'id_estado_pedido', NEW.id_estado_pedido, 'fecha_pedido', NEW.fecha_pedido,
            'fecha_estimada_entrega', NEW.fecha_estimada_entrega, 'motivo_cancelacion', NEW.motivo_cancelacion,
            'penalizacion_cancelacion', NEW.penalizacion_cancelacion, 'total_pedido', NEW.total_pedido,
            'peso_total', NEW.peso_total, 'volumen_total', NEW.volumen_total
        ),
        CURRENT_USER(), NOW()
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER pedidos_au
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN
    INSERT INTO aud_pedidos (
        id_pedido, valores_anteriores, valores_nuevos, usuario, fecha
    ) VALUES (
        NEW.id_pedido,
        JSON_OBJECT(
            'id_cliente', OLD.id_cliente, 'id_direccion_entrega', OLD.id_direccion_entrega,
            'id_estado_pedido', OLD.id_estado_pedido, 'fecha_pedido', OLD.fecha_pedido,
            'fecha_estimada_entrega', OLD.fecha_estimada_entrega, 'motivo_cancelacion', OLD.motivo_cancelacion,
            'penalizacion_cancelacion', OLD.penalizacion_cancelacion, 'total_pedido', OLD.total_pedido,
            'peso_total', OLD.peso_total, 'volumen_total', OLD.volumen_total
        ),
        JSON_OBJECT(
            'id_cliente', NEW.id_cliente, 'id_direccion_entrega', NEW.id_direccion_entrega,
            'id_estado_pedido', NEW.id_estado_pedido, 'fecha_pedido', NEW.fecha_pedido,
            'fecha_estimada_entrega', NEW.fecha_estimada_entrega, 'motivo_cancelacion', NEW.motivo_cancelacion,
            'penalizacion_cancelacion', NEW.penalizacion_cancelacion, 'total_pedido', NEW.total_pedido,
            'peso_total', NEW.peso_total, 'volumen_total', NEW.volumen_total
        ),
        CURRENT_USER(), NOW()
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER pedidos_ad
AFTER DELETE ON pedidos
FOR EACH ROW
BEGIN
    INSERT INTO aud_pedidos (
        id_pedido, valores_anteriores, valores_nuevos, usuario, fecha
    ) VALUES (
        OLD.id_pedido,
        JSON_OBJECT(
            'id_cliente', OLD.id_cliente, 'id_direccion_entrega', OLD.id_direccion_entrega,
            'id_estado_pedido', OLD.id_estado_pedido, 'fecha_pedido', OLD.fecha_pedido,
            'fecha_estimada_entrega', OLD.fecha_estimada_entrega, 'motivo_cancelacion', OLD.motivo_cancelacion,
            'penalizacion_cancelacion', OLD.penalizacion_cancelacion, 'total_pedido', OLD.total_pedido,
            'peso_total', OLD.peso_total, 'volumen_total', OLD.volumen_total
        ),
        NULL, CURRENT_USER(), NOW()
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `penalizaciones`
--

LOCK TABLES `penalizaciones` WRITE;
/*!40000 ALTER TABLE `penalizaciones` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `penalizaciones` VALUES
(1,8,1,25.00,'2025-11-24 06:19:30'),
(2,8,2,15.00,'2025-11-24 06:19:30'),
(3,8,3,10.00,'2025-11-24 06:19:30'),
(4,8,4,20.00,'2025-11-24 06:19:30'),
(5,8,5,30.00,'2025-11-24 06:19:30'),
(6,8,6,12.50,'2025-11-24 06:19:30'),
(7,8,7,8.00,'2025-11-24 06:19:30'),
(8,8,8,18.00,'2025-11-24 06:19:30'),
(9,8,9,22.00,'2025-11-24 06:19:30'),
(10,8,10,14.00,'2025-11-24 06:19:30');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productos`
--

LOCK TABLES `productos` WRITE;
/*!40000 ALTER TABLE `productos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `productos` VALUES
(1,'Laptop Gaming','Laptop para gaming de alta gama',2.50,0.0150,1200.00,1,'2025-11-24 06:19:30'),
(2,'Smartphone Pro','Teléfono inteligente última generación',0.20,0.0008,800.00,1,'2025-11-24 06:19:30'),
(3,'Tablet 10 pulgadas','Tablet con pantalla de 10 pulgadas',0.50,0.0030,300.00,1,'2025-11-24 06:19:30'),
(4,'Auriculares Inalámbricos','Auriculares Bluetooth con cancelación de ruido',0.25,0.0015,150.00,1,'2025-11-24 06:19:30'),
(5,'Monitor 24\"','Monitor LED 24 pulgadas Full HD',3.20,0.0250,200.00,1,'2025-11-24 06:19:30'),
(6,'Teclado Mecánico','Teclado mecánico RGB',1.10,0.0045,80.00,1,'2025-11-24 06:19:30'),
(7,'Mouse Gaming','Mouse para gaming con DPI ajustable',0.15,0.0006,50.00,1,'2025-11-24 06:19:30'),
(8,'Impresora Multifunción','Impresora láser multifunción',8.50,0.0450,250.00,1,'2025-11-24 06:19:30'),
(9,'Disco Duro Externo 1TB','Disco duro externo portátil',0.30,0.0012,60.00,1,'2025-11-24 06:19:30'),
(10,'Cámara Web HD','Cámara web 1080p para streaming',0.18,0.0009,40.00,1,'2025-11-24 06:19:30');
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `roles` VALUES
(1,'Administrador','Acceso total al sistema',1,'2025-11-24 08:50:19'),
(2,'Planificador','Gestiona rutas, pedidos y asignaciones',1,'2025-11-24 08:50:19'),
(3,'Repartidor','Solo ve y confirma sus entregas',1,'2025-11-24 08:50:19'),
(4,'Auditor','Consulta reportes y auditorías',1,'2025-11-24 08:50:19');
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rutas`
--

LOCK TABLES `rutas` WRITE;
/*!40000 ALTER TABLE `rutas` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `rutas` VALUES
(1,'Ruta Norte Mañana',1,'2025-11-24',1,3,1,25.50,180,38.25,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(2,'Ruta Sur Tarde',2,'2025-11-24',2,3,2,18.75,120,46.88,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(3,'Ruta Este Express',3,'2025-11-24',3,3,1,32.00,210,112.00,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(4,'Ruta Oeste Regular',4,'2025-11-24',4,3,3,28.25,165,127.13,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(5,'Ruta Centro Urgente',5,'2025-11-24',5,3,2,15.80,90,94.80,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(6,'Ruta Suburbana',6,'2025-11-24',6,3,1,45.30,240,362.40,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(7,'Ruta Financiera',7,'2025-11-24',7,3,3,12.50,75,6.25,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(8,'Ruta Universitaria',8,'2025-11-24',8,3,2,22.75,135,6.83,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(9,'Ruta Hospitalaria',9,'2025-11-24',9,3,1,19.40,110,38.80,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(10,'Ruta Industrial',10,'2025-11-24',1,3,2,38.60,195,270.20,'2025-11-24 06:19:30','2025-11-25 03:58:03');
/*!40000 ALTER TABLE `rutas` ENABLE KEYS */;
UNLOCK TABLES;
commit;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER tr_rutas_after_insert
AFTER INSERT ON rutas
FOR EACH ROW
BEGIN
    INSERT INTO aud_rutas (
        id_ruta, nombre_ruta, id_zona, costo, usuario, accion
    ) VALUES (
        NEW.id_ruta, 
        NEW.nombre_ruta, 
        NEW.id_zona, 
        NEW.costo,
        USER(),
        'INSERT'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER tr_rutas_after_update
AFTER UPDATE ON rutas
FOR EACH ROW
BEGIN
    INSERT INTO aud_rutas (
        id_ruta, nombre_ruta, id_zona, costo, usuario, accion
    ) VALUES (
        NEW.id_ruta, 
        NEW.nombre_ruta, 
        NEW.id_zona, 
        NEW.costo,
        USER(),
        'UPDATE'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_uca1400_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`proyecto_user`@`localhost`*/ /*!50003 TRIGGER tr_rutas_after_delete
AFTER DELETE ON rutas
FOR EACH ROW
BEGIN
    INSERT INTO aud_rutas (
        id_ruta, nombre_ruta, id_zona, costo, usuario, accion
    ) VALUES (
        OLD.id_ruta, 
        OLD.nombre_ruta, 
        OLD.id_zona, 
        OLD.costo,
        USER(),
        'DELETE'
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_costo`
--

LOCK TABLES `tipos_costo` WRITE;
/*!40000 ALTER TABLE `tipos_costo` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tipos_costo` VALUES
(1,'Combustible','Gastos de combustible'),
(2,'Mantenimiento','Costos de mantenimiento del vehículo'),
(3,'Peaje','Gastos de peajes y vialidad'),
(4,'Estacionamiento','Costos de estacionamiento'),
(5,'Lavado','Lavado y limpieza del vehículo'),
(6,'Seguro','Seguros del vehículo'),
(7,'Impuestos','Impuestos y licencias'),
(8,'Reparaciones','Reparaciones y refacciones'),
(9,'Sanciones','Multas y sanciones de tránsito'),
(10,'Otros','Otros costos operativos');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_incidencia`
--

LOCK TABLES `tipos_incidencia` WRITE;
/*!40000 ALTER TABLE `tipos_incidencia` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tipos_incidencia` VALUES
(1,'Tráfico','Congestión vehicular'),
(2,'Clima','Condiciones climáticas adversas'),
(3,'Accidente','Accidente de tránsito'),
(4,'Protesta','Manifestación o protesta'),
(5,'Obra Vial','Trabajos en la vía pública'),
(6,'Vehicular','Problema con el vehículo'),
(7,'Cliente','Problema con el cliente'),
(8,'Dirección','Problema con la dirección'),
(9,'Paquete','Problema con el paquete'),
(10,'Otro','Otro tipo de incidencia');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipos_vehiculo`
--

LOCK TABLES `tipos_vehiculo` WRITE;
/*!40000 ALTER TABLE `tipos_vehiculo` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `tipos_vehiculo` VALUES
(1,'Moto',50.00,0.50,0.15),
(2,'Auto Compacto',200.00,2.00,0.25),
(3,'Camioneta',500.00,4.00,0.35),
(4,'Furgoneta Pequeña',800.00,6.00,0.45),
(5,'Furgoneta Mediana',1200.00,10.00,0.60),
(6,'Camión Ligero',2000.00,15.00,0.80),
(7,'Bicicleta',10.00,0.20,0.05),
(8,'Patineta Eléctrica',5.00,0.10,0.03),
(9,'Cuatrimoto',80.00,0.80,0.20),
(10,'Van de Reparto',1500.00,12.00,0.70);
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `usuarios` VALUES
(1,'Administrador General','admin@demo.com','admin123',1,1,'2025-11-24 08:51:01','2025-11-24 08:51:01'),
(2,'Planificador Central','planificador@demo.com','plan123',2,1,'2025-11-24 08:51:01','2025-11-24 08:51:01'),
(3,'Repartidor','repartidor@demo.com','rep123',3,1,'2025-11-24 08:51:01','2025-11-25 03:57:06'),
(4,'Auditor Demo','auditor@demo.com','aud123',4,1,'2025-11-24 08:51:01','2025-11-24 08:51:01');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Temporary table structure for view `vcostosporkm`
--

DROP TABLE IF EXISTS `vcostosporkm`;
/*!50001 DROP VIEW IF EXISTS `vcostosporkm`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vcostosporkm` AS SELECT
 1 AS `id_vehiculo`,
  1 AS `placa`,
  1 AS `Costo_Total`,
  1 AS `Distancia_Total_KM`,
  1 AS `Costo_Por_KM` */;
SET character_set_client = @saved_cs_client;

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehiculos`
--

LOCK TABLES `vehiculos` WRITE;
/*!40000 ALTER TABLE `vehiculos` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `vehiculos` VALUES
(1,1,'MOT-001',0.15,1,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(2,2,'AUT-002',0.25,1,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(3,3,'CAM-003',0.35,1,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(4,4,'FUR-004',0.45,1,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(5,5,'FUR-005',0.60,1,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(6,6,'CAM-006',0.80,1,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(7,7,'BIC-007',0.05,1,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(8,8,'PAT-008',0.03,1,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(9,9,'CUA-009',0.20,1,'2025-11-24 06:19:30','2025-11-24 06:19:30'),
(10,10,'VAN-010',0.70,1,'2025-11-24 06:19:30','2025-11-24 06:19:30');
/*!40000 ALTER TABLE `vehiculos` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Temporary table structure for view `ventregashoy`
--

DROP TABLE IF EXISTS `ventregashoy`;
/*!50001 DROP VIEW IF EXISTS `ventregashoy`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `ventregashoy` AS SELECT
 1 AS `id_entrega`,
  1 AS `id_pedido`,
  1 AS `Nombre_Cliente`,
  1 AS `Direccion_Entrega`,
  1 AS `Repartidor`,
  1 AS `Estado_Entrega`,
  1 AS `fecha_estimada_entrega` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `ventregasporzona`
--

DROP TABLE IF EXISTS `ventregasporzona`;
/*!50001 DROP VIEW IF EXISTS `ventregasporzona`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `ventregasporzona` AS SELECT
 1 AS `id_zona`,
  1 AS `nombre_zona`,
  1 AS `Total_Entregas` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vincidenciasactivas`
--

DROP TABLE IF EXISTS `vincidenciasactivas`;
/*!50001 DROP VIEW IF EXISTS `vincidenciasactivas`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vincidenciasactivas` AS SELECT
 1 AS `id_incidencia`,
  1 AS `Tipo_Incidencia`,
  1 AS `descripcion`,
  1 AS `Zona_Afectada`,
  1 AS `Impacto`,
  1 AS `Estado_Actual`,
  1 AS `fecha_inicio` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `votpporrutames`
--

DROP TABLE IF EXISTS `votpporrutames`;
/*!50001 DROP VIEW IF EXISTS `votpporrutames`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `votpporrutames` AS SELECT
 1 AS `id_ruta`,
  1 AS `nombre_ruta`,
  1 AS `Total_OTP` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vpedidosporestado`
--

DROP TABLE IF EXISTS `vpedidosporestado`;
/*!50001 DROP VIEW IF EXISTS `vpedidosporestado`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vpedidosporestado` AS SELECT
 1 AS `id_estado_pedido`,
  1 AS `nombre_estado`,
  1 AS `Total_Pedidos` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vproductividadrepartidor`
--

DROP TABLE IF EXISTS `vproductividadrepartidor`;
/*!50001 DROP VIEW IF EXISTS `vproductividadrepartidor`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vproductividadrepartidor` AS SELECT
 1 AS `id_usuario`,
  1 AS `Nombre_Repartidor`,
  1 AS `Total_Entregas_Mes`,
  1 AS `Entregas_Completadas`,
  1 AS `Entregas_Fallidas`,
  1 AS `Tasa_Exito_Porcentaje` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vtiempopromedioentrega`
--

DROP TABLE IF EXISTS `vtiempopromedioentrega`;
/*!50001 DROP VIEW IF EXISTS `vtiempopromedioentrega`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `vtiempopromedioentrega` AS SELECT
 1 AS `Tiempo_Promedio_Minutos` */;
SET character_set_client = @saved_cs_client;

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 ;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `zonas`
--

LOCK TABLES `zonas` WRITE;
/*!40000 ALTER TABLE `zonas` DISABLE KEYS */;
set autocommit=0;
INSERT INTO `zonas` VALUES
(1,'Zona Norte','Área residencial norte',5.00,1,'2025-11-24 06:19:30','2025-11-24 06:19:30',1),
(2,'Zona Sur','Área comercial sur',4.50,1,'2025-11-24 06:19:30','2025-11-24 06:19:30',2),
(3,'Zona Este','Zona industrial este',6.00,1,'2025-11-24 06:19:30','2025-11-24 06:19:30',3),
(4,'Zona Oeste','Área mixta oeste',5.50,1,'2025-11-24 06:19:30','2025-11-24 06:19:30',4),
(5,'Centro Ciudad','Zona centro densamente poblada',3.00,1,'2025-11-24 06:19:30','2025-11-24 06:19:30',5),
(6,'Zona Suburbana','Área suburbana residencial',7.00,1,'2025-11-24 06:19:30','2025-11-24 06:19:30',6),
(7,'Distrito Financiero','Área de oficinas y negocios',2.50,1,'2025-11-24 06:19:30','2025-11-24 06:19:30',7),
(8,'Zona Universitaria','Cerca de campus universitario',4.00,1,'2025-11-24 06:19:30','2025-11-24 06:19:30',8),
(9,'Zona Hospital','Área médica y hospitalaria',3.50,1,'2025-11-24 06:19:30','2025-11-24 06:19:30',9),
(10,'Zona Parque Industrial','Área industrial y logística',8.00,1,'2025-11-24 06:19:30','2025-11-24 06:19:30',10);
/*!40000 ALTER TABLE `zonas` ENABLE KEYS */;
UNLOCK TABLES;
commit;

--
-- Final view structure for view `vcostosporkm`
--

/*!50001 DROP VIEW IF EXISTS `vcostosporkm`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`proyecto_user`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vcostosporkm` AS select `v`.`id_vehiculo` AS `id_vehiculo`,`v`.`placa` AS `placa`,sum(`co`.`monto`) AS `Costo_Total`,sum(`co`.`distancia_km`) AS `Distancia_Total_KM`,case when sum(`co`.`distancia_km`) > 0 then sum(`co`.`monto`) / sum(`co`.`distancia_km`) else 0 end AS `Costo_Por_KM` from (`costos_operativos` `co` join `vehiculos` `v` on(`co`.`id_vehiculo` = `v`.`id_vehiculo`)) group by `v`.`id_vehiculo`,`v`.`placa` having `Distancia_Total_KM` > 0 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ventregashoy`
--

/*!50001 DROP VIEW IF EXISTS `ventregashoy`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`proyecto_user`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ventregashoy` AS select `e`.`id_entrega` AS `id_entrega`,`p`.`id_pedido` AS `id_pedido`,`c`.`nombre` AS `Nombre_Cliente`,`dc`.`direccion` AS `Direccion_Entrega`,`u`.`nombre` AS `Repartidor`,`ee`.`nombre_estado` AS `Estado_Entrega`,`e`.`fecha_estimada_entrega` AS `fecha_estimada_entrega` from (((((`entregas` `e` join `pedidos` `p` on(`e`.`id_pedido` = `p`.`id_pedido`)) join `clientes` `c` on(`p`.`id_cliente` = `c`.`id_cliente`)) join `direcciones_cliente` `dc` on(`p`.`id_direccion_entrega` = `dc`.`id_direccion`)) join `usuarios` `u` on(`e`.`id_repartidor` = `u`.`id_usuario`)) join `estados_entrega` `ee` on(`e`.`id_estado_entrega` = `ee`.`id_estado_entrega`)) where cast(`e`.`fecha_estimada_entrega` as date) = curdate() */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `ventregasporzona`
--

/*!50001 DROP VIEW IF EXISTS `ventregasporzona`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`proyecto_user`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `ventregasporzona` AS select `z`.`id_zona` AS `id_zona`,`z`.`nombre_zona` AS `nombre_zona`,count(`e`.`id_entrega`) AS `Total_Entregas` from (((`entregas` `e` join `pedidos` `p` on(`e`.`id_pedido` = `p`.`id_pedido`)) join `direcciones_cliente` `dc` on(`p`.`id_direccion_entrega` = `dc`.`id_direccion`)) join `zonas` `z` on(`dc`.`id_zona` = `z`.`id_zona`)) group by `z`.`id_zona`,`z`.`nombre_zona` order by count(`e`.`id_entrega`) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vincidenciasactivas`
--

/*!50001 DROP VIEW IF EXISTS `vincidenciasactivas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`proyecto_user`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vincidenciasactivas` AS select `i`.`id_incidencia` AS `id_incidencia`,`ti`.`nombre_tipo` AS `Tipo_Incidencia`,`i`.`descripcion` AS `descripcion`,`z`.`nombre_zona` AS `Zona_Afectada`,`ni`.`nombre_nivel` AS `Impacto`,`ei`.`nombre_estado` AS `Estado_Actual`,`i`.`fecha_inicio` AS `fecha_inicio` from ((((`incidencias` `i` join `tipos_incidencia` `ti` on(`i`.`id_tipo_incidencia` = `ti`.`id_tipo_incidencia`)) join `zonas` `z` on(`i`.`id_zona` = `z`.`id_zona`)) join `niveles_impacto` `ni` on(`i`.`id_nivel_impacto` = `ni`.`id_nivel_impacto`)) join `estados_incidencia` `ei` on(`i`.`id_estado_incidencia` = `ei`.`id_estado_incidencia`)) where `ei`.`nombre_estado` in ('reportada','en investigacion') order by `i`.`fecha_inicio` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `votpporrutames`
--

/*!50001 DROP VIEW IF EXISTS `votpporrutames`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`proyecto_user`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `votpporrutames` AS select `r`.`id_ruta` AS `id_ruta`,`r`.`nombre_ruta` AS `nombre_ruta`,count(`o`.`id_otp`) AS `Total_OTP` from ((`otp` `o` join `entregas` `e` on(`o`.`id_entrega` = `e`.`id_entrega`)) join `rutas` `r` on(`e`.`id_ruta` = `r`.`id_ruta`)) where month(`o`.`fecha_generado`) = month(curdate()) and year(`o`.`fecha_generado`) = year(curdate()) group by `r`.`id_ruta`,`r`.`nombre_ruta` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vpedidosporestado`
--

/*!50001 DROP VIEW IF EXISTS `vpedidosporestado`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`proyecto_user`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vpedidosporestado` AS select `ep`.`id_estado_pedido` AS `id_estado_pedido`,`ep`.`nombre_estado` AS `nombre_estado`,count(`p`.`id_pedido`) AS `Total_Pedidos` from (`pedidos` `p` join `estados_pedido` `ep` on(`p`.`id_estado_pedido` = `ep`.`id_estado_pedido`)) group by `ep`.`id_estado_pedido`,`ep`.`nombre_estado` order by count(`p`.`id_pedido`) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vproductividadrepartidor`
--

/*!50001 DROP VIEW IF EXISTS `vproductividadrepartidor`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`proyecto_user`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vproductividadrepartidor` AS select `u`.`id_usuario` AS `id_usuario`,`u`.`nombre` AS `Nombre_Repartidor`,count(`e`.`id_entrega`) AS `Total_Entregas_Mes`,sum(case when `ee`.`nombre_estado` = 'entregada' then 1 else 0 end) AS `Entregas_Completadas`,sum(case when `ee`.`nombre_estado` = 'fallida' then 1 else 0 end) AS `Entregas_Fallidas`,case when count(`e`.`id_entrega`) > 0 then sum(case when `ee`.`nombre_estado` = 'entregada' then 1 else 0 end) * 100.0 / count(`e`.`id_entrega`) else 0 end AS `Tasa_Exito_Porcentaje` from ((`usuarios` `u` join `entregas` `e` on(`u`.`id_usuario` = `e`.`id_repartidor`)) join `estados_entrega` `ee` on(`e`.`id_estado_entrega` = `ee`.`id_estado_entrega`)) where `u`.`id_rol` = (select `roles`.`id_rol` from `roles` where `roles`.`nombre_rol` = 'Repartidor') and month(`e`.`fecha_creacion`) = month(curdate()) and year(`e`.`fecha_creacion`) = year(curdate()) group by `u`.`id_usuario`,`u`.`nombre` order by case when count(`e`.`id_entrega`) > 0 then sum(case when `ee`.`nombre_estado` = 'entregada' then 1 else 0 end) * 100.0 / count(`e`.`id_entrega`) else 0 end desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vtiempopromedioentrega`
--

/*!50001 DROP VIEW IF EXISTS `vtiempopromedioentrega`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_uca1400_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`proyecto_user`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vtiempopromedioentrega` AS select avg(`e`.`tiempo_entrega_minutos`) AS `Tiempo_Promedio_Minutos` from (`entregas` `e` join `estados_entrega` `ee` on(`e`.`id_estado_entrega` = `ee`.`id_estado_entrega`)) where `ee`.`nombre_estado` = 'entregada' and `e`.`tiempo_entrega_minutos` > 0 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2025-11-24 22:42:42
