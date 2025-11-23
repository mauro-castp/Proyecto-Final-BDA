-- 1. Trigger: detallePedidoValidacionBI - Valida cantidad > 0 y producto válido
DELIMITER $$
CREATE TRIGGER detallePedidoValidacionBI
    BEFORE INSERT ON detalle_pedido
    FOR EACH ROW
BEGIN
    DECLARE producto_activo INT;
    DECLARE producto_existe INT;
    
    -- Verificar que la cantidad sea mayor a 0
    IF NEW.cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La cantidad debe ser mayor a 0';
    END IF;
    
    -- Verificar que el producto existe
    SELECT COUNT(*) INTO producto_existe 
    FROM productos 
    WHERE id_producto = NEW.id_producto;
    
    IF producto_existe = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: El producto especificado no existe';
    END IF;
    
    -- Verificar que el producto esté activo
    SELECT COUNT(*) INTO producto_activo 
    FROM productos 
    WHERE id_producto = NEW.id_producto 
    AND id_estado = 1; -- estado activo
    
    IF producto_activo = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: El producto no está activo';
    END IF;
END$$
DELIMITER ;

-- 2. Trigger: entregaEstadoBU - Valida transiciones válidas de estado de entrega
DELIMITER $$
CREATE TRIGGER entregaEstadoBU
    BEFORE UPDATE ON entregas
    FOR EACH ROW
BEGIN
    DECLARE estado_actual_nombre VARCHAR(50);
    DECLARE estado_nuevo_nombre VARCHAR(50);
    
    -- Solo validar si cambió el estado
    IF OLD.id_estado_entrega != NEW.id_estado_entrega THEN
        -- Obtener nombres de estados
        SELECT nombre_estado INTO estado_actual_nombre 
        FROM estados_entrega 
        WHERE id_estado_entrega = OLD.id_estado_entrega;
        
        SELECT nombre_estado INTO estado_nuevo_nombre 
        FROM estados_entrega 
        WHERE id_estado_entrega = NEW.id_estado_entrega;
        
        -- Validar transiciones permitidas
        IF estado_actual_nombre = 'Entregado' THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error: Una entrega ya entregada no puede cambiar de estado';
        END IF;
        
        IF estado_actual_nombre = 'Cancelado' AND estado_nuevo_nombre != 'Cancelado' THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error: Una entrega cancelada no puede reactivarse';
        END IF;
        
        -- Validar que no se salte estados importantes
        IF estado_actual_nombre = 'Pendiente' AND estado_nuevo_nombre = 'Entregado' THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Error: No se puede saltar de Pendiente directamente a Entregado';
        END IF;
        
        -- Si se marca como entregado, validar datos requeridos
        IF estado_nuevo_nombre = 'Entregado' THEN
            IF NEW.fecha_real_entrega IS NULL THEN
                SET NEW.fecha_real_entrega = CURRENT_TIMESTAMP;
            END IF;
            
            IF NEW.hora_fin_entrega IS NULL THEN
                SET NEW.hora_fin_entrega = CURRENT_TIMESTAMP;
            END IF;
            
            -- Calcular tiempo de entrega si hay hora de inicio
            IF NEW.hora_inicio_entrega IS NOT NULL AND NEW.hora_fin_entrega IS NOT NULL THEN
                SET NEW.tiempo_entrega_minutos = TIMESTAMPDIFF(MINUTE, NEW.hora_inicio_entrega, NEW.hora_fin_entrega);
            END IF;
        END IF;
    END IF;
END$$
DELIMITER ;

-- 3. Trigger: vehiculoCapacidadBI - Evita sobrecargas en vehículos
DELIMITER $$
CREATE TRIGGER vehiculoCapacidadBI
    BEFORE INSERT ON rutas
    FOR EACH ROW
BEGIN
    DECLARE capacidad_maxima_kg DECIMAL(8,2);
    DECLARE capacidad_maxima_vol DECIMAL(8,2);
    DECLARE peso_total_ruta DECIMAL(8,2);
    DECLARE volumen_total_ruta DECIMAL(8,4);
    
    -- Obtener capacidades del vehículo
    SELECT tv.capacidad_maxima_kg, tv.capacidad_volumen_m3 
    INTO capacidad_maxima_kg, capacidad_maxima_vol
    FROM vehiculos v
    JOIN tipos_vehiculo tv ON v.id_tipo_vehiculo = tv.id_tipo_vehiculo
    WHERE v.id_vehiculo = NEW.id_vehiculo;
    
    -- Calcular peso y volumen total de los pedidos en la ruta
    SELECT 
        COALESCE(SUM(p.peso_total), 0),
        COALESCE(SUM(p.volumen_total), 0)
    INTO peso_total_ruta, volumen_total_ruta
    FROM paradas_ruta pr
    JOIN pedidos p ON pr.id_pedido = p.id_pedido
    WHERE pr.id_ruta = NEW.id_ruta;
    
    -- Validar capacidad de peso
    IF peso_total_ruta > capacidad_maxima_kg THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = CONCAT('Error: El vehículo excede su capacidad máxima de peso. Máximo: ', capacidad_maxima_kg, ' kg, Actual: ', peso_total_ruta, ' kg');
    END IF;
    
    -- Validar capacidad de volumen
    IF volumen_total_ruta > capacidad_maxima_vol THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = CONCAT('Error: El vehículo excede su capacidad máxima de volumen. Máximo: ', capacidad_maxima_vol, ' m³, Actual: ', volumen_total_ruta, ' m³');
    END IF;
END$$
DELIMITER ;

-- 4. Trigger: incidenciaBloqueoBI - Evita solapamientos incongruentes de incidencias
DELIMITER $$
CREATE TRIGGER incidenciaBloqueoBI
    BEFORE INSERT ON incidencias
    FOR EACH ROW
BEGIN
    DECLARE solapamientos INT;
    DECLARE zona_nombre VARCHAR(100);
    
    -- Obtener nombre de la zona
    SELECT nombre_zona INTO zona_nombre 
    FROM zonas 
    WHERE id_zona = NEW.id_zona;
    
    -- Verificar solapamientos en la misma zona
    SELECT COUNT(*) INTO solapamientos
    FROM incidencias i
    JOIN zonas z ON i.id_zona = z.id_zona
    WHERE i.id_zona = NEW.id_zona
    AND i.id_estado_incidencia IN (SELECT id_estado_incidencia FROM estados_incidencia WHERE nombre_estado = 'Activa')
    AND (
        (NEW.fecha_inicio BETWEEN i.fecha_inicio AND COALESCE(i.fecha_fin, NEW.fecha_inicio))
        OR (NEW.fecha_fin BETWEEN i.fecha_inicio AND COALESCE(i.fecha_fin, NEW.fecha_fin))
        OR (i.fecha_inicio BETWEEN NEW.fecha_inicio AND COALESCE(NEW.fecha_fin, i.fecha_inicio))
    )
    AND i.id_incidencia != COALESCE(NEW.id_incidencia, 0);
    
    IF solapamientos > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = CONCAT('Error: Existe una incidencia activa solapada en la zona "', zona_nombre, '" durante el período especificado');
    END IF;
    
    -- Validar que fecha_fin sea mayor que fecha_inicio si está especificada
    IF NEW.fecha_fin IS NOT NULL AND NEW.fecha_fin <= NEW.fecha_inicio THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La fecha de fin debe ser posterior a la fecha de inicio';
    END IF;
END$$
DELIMITER ;

-- 5. Trigger: normalizaDireccionClienteBI - Limpieza de direcciones
DELIMITER $$
CREATE TRIGGER normalizaDireccionClienteBI
    BEFORE INSERT ON direcciones_cliente
    FOR EACH ROW
BEGIN
    -- Convertir a mayúsculas
    SET NEW.direccion = UPPER(NEW.direccion);
    
    -- Eliminar espacios múltiples
    WHILE NEW.direccion LIKE '%  %' DO
        SET NEW.direccion = REPLACE(NEW.direccion, '  ', ' ');
    END WHILE;
    
    -- Trim espacios al inicio y final
    SET NEW.direccion = TRIM(NEW.direccion);
    
    -- Normalizar abreviaturas comunes
    SET NEW.direccion = REPLACE(NEW.direccion, ' AV. ', ' AVENIDA ');
    SET NEW.direccion = REPLACE(NEW.direccion, ' C/ ', ' CALLE ');
    SET NEW.direccion = REPLACE(NEW.direccion, ' P.º ', ' PASEO ');
    SET NEW.direccion = REPLACE(NEW.direccion, ' PL. ', ' PLAZA ');
    SET NEW.direccion = REPLACE(NEW.direccion, ' CTRA. ', ' CARRETERA ');
    SET NEW.direccion = REPLACE(NEW.direccion, ' Nº ', ' NÚMERO ');
    SET NEW.direccion = REPLACE(NEW.direccion, ' DCHA. ', ' DERECHA ');
    SET NEW.direccion = REPLACE(NEW.direccion, ' IZDA. ', ' IZQUIERDA ');
    
    -- Capitalizar cada palabra (primera letra mayúscula, resto minúsculas)
    SET NEW.direccion = CONCAT(
        UPPER(SUBSTRING(NEW.direccion, 1, 1)),
        LOWER(SUBSTRING(NEW.direccion, 2))
    );
END$$
DELIMITER ;

-- 6. Trigger: slaRetrasoMarcaAIEntrega - Marca entregas como "late" después de insertar
DELIMITER $$
CREATE TRIGGER slaRetrasoMarcaAIEntrega
    AFTER INSERT ON entregas
    FOR EACH ROW
BEGIN
    DECLARE minutos_retraso INT;
    DECLARE fecha_estimada_pedido TIMESTAMP;
    
    -- Obtener fecha estimada del pedido
    SELECT fecha_estimada_entrega INTO fecha_estimada_pedido
    FROM pedidos 
    WHERE id_pedido = NEW.id_pedido;
    
    -- Si hay fecha estimada y la entrega se realizó después, marcar como tarde
    IF fecha_estimada_pedido IS NOT NULL AND NEW.fecha_real_entrega IS NOT NULL THEN
        SET minutos_retraso = TIMESTAMPDIFF(MINUTE, fecha_estimada_pedido, NEW.fecha_real_entrega);
        
        IF minutos_retraso > 15 THEN -- Considerar retraso después de 15 minutos
            UPDATE entregas 
            SET fue_tarde = 1,
                cumplio_sla = 0
            WHERE id_entrega = NEW.id_entrega;
        ELSE
            UPDATE entregas 
            SET fue_tarde = 0,
                cumplio_sla = 1
            WHERE id_entrega = NEW.id_entrega;
        END IF;
    END IF;
    
    -- Si no hay fecha real de entrega pero ya pasó la fecha estimada, marcar como potencial retraso
    IF fecha_estimada_pedido IS NOT NULL AND NEW.fecha_real_entrega IS NULL THEN
        IF fecha_estimada_pedido < CURRENT_TIMESTAMP THEN
            UPDATE entregas 
            SET fue_tarde = 1,
                cumplio_sla = 0
            WHERE id_entrega = NEW.id_entrega;
        END IF;
    END IF;
END$$
DELIMITER ;


-- Trigger para auditoría de pedidos (pedidoAIUD)
DELIMITER $$
CREATE TRIGGER pedidoAIUD
    AFTER INSERT OR UPDATE OR DELETE ON pedidos
    FOR EACH ROW
BEGIN
    DECLARE accion VARCHAR(10);
    DECLARE valores_ant JSON;
    DECLARE valores_nuev JSON;
    
    -- Determinar la acción
    IF INSERTING THEN
        SET accion = 'INSERT';
        SET valores_ant = NULL;
        SET valores_nuev = JSON_OBJECT(
            'id_pedido', NEW.id_pedido,
            'id_cliente', NEW.id_cliente,
            'id_direccion_entrega', NEW.id_direccion_entrega,
            'id_estado_pedido', NEW.id_estado_pedido,
            'fecha_pedido', NEW.fecha_pedido,
            'fecha_estimada_entrega', NEW.fecha_estimada_entrega,
            'fecha_real_entrega', NEW.fecha_real_entrega,
            'motivo_cancelacion', NEW.motivo_cancelacion,
            'penalizacion_cancelacion', NEW.penalizacion_cancelacion,
            'total_pedido', NEW.total_pedido,
            'peso_total', NEW.peso_total,
            'volumen_total', NEW.volumen_total
        );
    ELSEIF UPDATING THEN
        SET accion = 'UPDATE';
        SET valores_ant = JSON_OBJECT(
            'id_pedido', OLD.id_pedido,
            'id_cliente', OLD.id_cliente,
            'id_direccion_entrega', OLD.id_direccion_entrega,
            'id_estado_pedido', OLD.id_estado_pedido,
            'fecha_pedido', OLD.fecha_pedido,
            'fecha_estimada_entrega', OLD.fecha_estimada_entrega,
            'fecha_real_entrega', OLD.fecha_real_entrega,
            'motivo_cancelacion', OLD.motivo_cancelacion,
            'penalizacion_cancelacion', OLD.penalizacion_cancelacion,
            'total_pedido', OLD.total_pedido,
            'peso_total', OLD.peso_total,
            'volumen_total', OLD.volumen_total
        );
        SET valores_nuev = JSON_OBJECT(
            'id_pedido', NEW.id_pedido,
            'id_cliente', NEW.id_cliente,
            'id_direccion_entrega', NEW.id_direccion_entrega,
            'id_estado_pedido', NEW.id_estado_pedido,
            'fecha_pedido', NEW.fecha_pedido,
            'fecha_estimada_entrega', NEW.fecha_estimada_entrega,
            'fecha_real_entrega', NEW.fecha_real_entrega,
            'motivo_cancelacion', NEW.motivo_cancelacion,
            'penalizacion_cancelacion', NEW.penalizacion_cancelacion,
            'total_pedido', NEW.total_pedido,
            'peso_total', NEW.peso_total,
            'volumen_total', NEW.volumen_total
        );
    ELSE -- DELETING
        SET accion = 'DELETE';
        SET valores_ant = JSON_OBJECT(
            'id_pedido', OLD.id_pedido,
            'id_cliente', OLD.id_cliente,
            'id_direccion_entrega', OLD.id_direccion_entrega,
            'id_estado_pedido', OLD.id_estado_pedido,
            'fecha_pedido', OLD.fecha_pedido,
            'fecha_estimada_entrega', OLD.fecha_estimada_entrega,
            'fecha_real_entrega', OLD.fecha_real_entrega,
            'motivo_cancelacion', OLD.motivo_cancelacion,
            'penalizacion_cancelacion', OLD.penalizacion_cancelacion,
            'total_pedido', OLD.total_pedido,
            'peso_total', OLD.peso_total,
            'volumen_total', OLD.volumen_total
        );
        SET valores_nuev = NULL;
    END IF;
    
    -- Insertar en la tabla de auditoría
    INSERT INTO aud_pedidos (id_pedido, accion, valores_anteriores, valores_nuevos, usuario)
    VALUES (
        COALESCE(NEW.id_pedido, OLD.id_pedido),
        accion,
        valores_ant,
        valores_nuev,
        CURRENT_USER()
    );
END$$
DELIMITER ;

-- Trigger para auditoría de rutas (rutaAIUD)
DELIMITER $$
CREATE TRIGGER rutaAIUD
    AFTER INSERT OR UPDATE OR DELETE ON rutas
    FOR EACH ROW
BEGIN
    DECLARE accion VARCHAR(10);
    DECLARE valores_ant JSON;
    DECLARE valores_nuev JSON;
    
    -- Determinar la acción
    IF INSERTING THEN
        SET accion = 'INSERT';
        SET valores_ant = NULL;
        SET valores_nuev = JSON_OBJECT(
            'id_ruta', NEW.id_ruta,
            'nombre_ruta', NEW.nombre_ruta,
            'id_zona', NEW.id_zona,
            'fecha_ruta', NEW.fecha_ruta,
            'id_vehiculo', NEW.id_vehiculo,
            'id_repartidor', NEW.id_repartidor,
            'id_estado_ruta', NEW.id_estado_ruta,
            'distancia_total_km', NEW.distancia_total_km,
            'tiempo_estimado_minutos', NEW.tiempo_estimado_minutos,
            'costo_estimado', NEW.costo_estimado,
            'costo_real', NEW.costo_real
        );
    ELSEIF UPDATING THEN
        SET accion = 'UPDATE';
        SET valores_ant = JSON_OBJECT(
            'id_ruta', OLD.id_ruta,
            'nombre_ruta', OLD.nombre_ruta,
            'id_zona', OLD.id_zona,
            'fecha_ruta', OLD.fecha_ruta,
            'id_vehiculo', OLD.id_vehiculo,
            'id_repartidor', OLD.id_repartidor,
            'id_estado_ruta', OLD.id_estado_ruta,
            'distancia_total_km', OLD.distancia_total_km,
            'tiempo_estimado_minutos', OLD.tiempo_estimado_minutos,
            'costo_estimado', OLD.costo_estimado,
            'costo_real', OLD.costo_real
        );
        SET valores_nuev = JSON_OBJECT(
            'id_ruta', NEW.id_ruta,
            'nombre_ruta', NEW.nombre_ruta,
            'id_zona', NEW.id_zona,
            'fecha_ruta', NEW.fecha_ruta,
            'id_vehiculo', NEW.id_vehiculo,
            'id_repartidor', NEW.id_repartidor,
            'id_estado_ruta', NEW.id_estado_ruta,
            'distancia_total_km', NEW.distancia_total_km,
            'tiempo_estimado_minutos', NEW.tiempo_estimado_minutos,
            'costo_estimado', NEW.costo_estimado,
            'costo_real', NEW.costo_real
        );
    ELSE -- DELETING
        SET accion = 'DELETE';
        SET valores_ant = JSON_OBJECT(
            'id_ruta', OLD.id_ruta,
            'nombre_ruta', OLD.nombre_ruta,
            'id_zona', OLD.id_zona,
            'fecha_ruta', OLD.fecha_ruta,
            'id_vehiculo', OLD.id_vehiculo,
            'id_repartidor', OLD.id_repartidor,
            'id_estado_ruta', OLD.id_estado_ruta,
            'distancia_total_km', OLD.distancia_total_km,
            'tiempo_estimado_minutos', OLD.tiempo_estimado_minutos,
            'costo_estimado', OLD.costo_estimado,
            'costo_real', OLD.costo_real
        );
        SET valores_nuev = NULL;
    END IF;
    
    -- Insertar en la tabla de auditoría
    INSERT INTO aud_rutas (id_ruta, accion, valores_anteriores, valores_nuevos, usuario)
    VALUES (
        COALESCE(NEW.id_ruta, OLD.id_ruta),
        accion,
        valores_ant,
        valores_nuev,
        CURRENT_USER()
    );
END$$
DELIMITER ;

-- Trigger para auditoría de entregas (entregaAIUD)
DELIMITER $$
CREATE TRIGGER entregaAIUD
    AFTER INSERT OR UPDATE OR DELETE ON entregas
    FOR EACH ROW
BEGIN
    DECLARE accion VARCHAR(10);
    DECLARE valores_ant JSON;
    DECLARE valores_nuev JSON;
    
    -- Determinar la acción
    IF INSERTING THEN
        SET accion = 'INSERT';
        SET valores_ant = NULL;
        SET valores_nuev = JSON_OBJECT(
            'id_entrega', NEW.id_entrega,
            'id_pedido', NEW.id_pedido,
            'id_ruta', NEW.id_ruta,
            'id_repartidor', NEW.id_repartidor,
            'id_estado_entrega', NEW.id_estado_entrega,
            'fecha_estimada_entrega', NEW.fecha_estimada_entrega,
            'fecha_real_entrega', NEW.fecha_real_entrega,
            'hora_inicio_entrega', NEW.hora_inicio_entrega,
            'hora_fin_entrega', NEW.hora_fin_entrega,
            'tiempo_entrega_minutos', NEW.tiempo_entrega_minutos,
            'reintentos', NEW.reintentos,
            'cumplio_sla', NEW.cumplio_sla,
            'fue_tarde', NEW.fue_tarde,
            'costo_entrega', NEW.costo_entrega,
            'id_motivo_fallo', NEW.id_motivo_fallo
        );
    ELSEIF UPDATING THEN
        SET accion = 'UPDATE';
        SET valores_ant = JSON_OBJECT(
            'id_entrega', OLD.id_entrega,
            'id_pedido', OLD.id_pedido,
            'id_ruta', OLD.id_ruta,
            'id_repartidor', OLD.id_repartidor,
            'id_estado_entrega', OLD.id_estado_entrega,
            'fecha_estimada_entrega', OLD.fecha_estimada_entrega,
            'fecha_real_entrega', OLD.fecha_real_entrega,
            'hora_inicio_entrega', OLD.hora_inicio_entrega,
            'hora_fin_entrega', OLD.hora_fin_entrega,
            'tiempo_entrega_minutos', OLD.tiempo_entrega_minutos,
            'reintentos', OLD.reintentos,
            'cumplio_sla', OLD.cumplio_sla,
            'fue_tarde', OLD.fue_tarde,
            'costo_entrega', OLD.costo_entrega,
            'id_motivo_fallo', OLD.id_motivo_fallo
        );
        SET valores_nuev = JSON_OBJECT(
            'id_entrega', NEW.id_entrega,
            'id_pedido', NEW.id_pedido,
            'id_ruta', NEW.id_ruta,
            'id_repartidor', NEW.id_repartidor,
            'id_estado_entrega', NEW.id_estado_entrega,
            'fecha_estimada_entrega', NEW.fecha_estimada_entrega,
            'fecha_real_entrega', NEW.fecha_real_entrega,
            'hora_inicio_entrega', NEW.hora_inicio_entrega,
            'hora_fin_entrega', NEW.hora_fin_entrega,
            'tiempo_entrega_minutos', NEW.tiempo_entrega_minutos,
            'reintentos', NEW.reintentos,
            'cumplio_sla', NEW.cumplio_sla,
            'fue_tarde', NEW.fue_tarde,
            'costo_entrega', NEW.costo_entrega,
            'id_motivo_fallo', NEW.id_motivo_fallo
        );
    ELSE -- DELETING
        SET accion = 'DELETE';
        SET valores_ant = JSON_OBJECT(
            'id_entrega', OLD.id_entrega,
            'id_pedido', OLD.id_pedido,
            'id_ruta', OLD.id_ruta,
            'id_repartidor', OLD.id_repartidor,
            'id_estado_entrega', OLD.id_estado_entrega,
            'fecha_estimada_entrega', OLD.fecha_estimada_entrega,
            'fecha_real_entrega', OLD.fecha_real_entrega,
            'hora_inicio_entrega', OLD.hora_inicio_entrega,
            'hora_fin_entrega', OLD.hora_fin_entrega,
            'tiempo_entrega_minutos', OLD.tiempo_entrega_minutos,
            'reintentos', OLD.reintentos,
            'cumplio_sla', OLD.cumplio_sla,
            'fue_tarde', OLD.fue_tarde,
            'costo_entrega', OLD.costo_entrega,
            'id_motivo_fallo', OLD.id_motivo_fallo
        );
        SET valores_nuev = NULL;
    END IF;
    
    -- Insertar en la tabla de auditoría
    INSERT INTO aud_entregas (id_entrega, accion, valores_anteriores, valores_nuevos, usuario)
    VALUES (
        COALESCE(NEW.id_entrega, OLD.id_entrega),
        accion,
        valores_ant,
        valores_nuev,
        CURRENT_USER()
    );
END$$
DELIMITER ;

-- Trigger para auditoría de incidencias (incidenciaAIUD)
DELIMITER $$
CREATE TRIGGER incidenciaAIUD
    AFTER INSERT OR UPDATE OR DELETE ON incidencias
    FOR EACH ROW
BEGIN
    DECLARE accion VARCHAR(10);
    DECLARE valores_ant JSON;
    DECLARE valores_nuev JSON;
    
    -- Determinar la acción
    IF INSERTING THEN
        SET accion = 'INSERT';
        SET valores_ant = NULL;
        SET valores_nuev = JSON_OBJECT(
            'id_incidencia', NEW.id_incidencia,
            'id_tipo_incidencia', NEW.id_tipo_incidencia,
            'id_zona', NEW.id_zona,
            'descripcion', NEW.descripcion,
            'fecha_inicio', NEW.fecha_inicio,
            'fecha_fin', NEW.fecha_fin,
            'id_estado_incidencia', NEW.id_estado_incidencia,
            'id_nivel_impacto', NEW.id_nivel_impacto,
            'radio_afectacion_km', NEW.radio_afectacion_km,
            'id_usuario_reporta', NEW.id_usuario_reporta,
            'id_geo', NEW.id_geo
        );
    ELSEIF UPDATING THEN
        SET accion = 'UPDATE';
        SET valores_ant = JSON_OBJECT(
            'id_incidencia', OLD.id_incidencia,
            'id_tipo_incidencia', OLD.id_tipo_incidencia,
            'id_zona', OLD.id_zona,
            'descripcion', OLD.descripcion,
            'fecha_inicio', OLD.fecha_inicio,
            'fecha_fin', OLD.fecha_fin,
            'id_estado_incidencia', OLD.id_estado_incidencia,
            'id_nivel_impacto', OLD.id_nivel_impacto,
            'radio_afectacion_km', OLD.radio_afectacion_km,
            'id_usuario_reporta', OLD.id_usuario_reporta,
            'id_geo', OLD.id_geo
        );
        SET valores_nuev = JSON_OBJECT(
            'id_incidencia', NEW.id_incidencia,
            'id_tipo_incidencia', NEW.id_tipo_incidencia,
            'id_zona', NEW.id_zona,
            'descripcion', NEW.descripcion,
            'fecha_inicio', NEW.fecha_inicio,
            'fecha_fin', NEW.fecha_fin,
            'id_estado_incidencia', NEW.id_estado_incidencia,
            'id_nivel_impacto', NEW.id_nivel_impacto,
            'radio_afectacion_km', NEW.radio_afectacion_km,
            'id_usuario_reporta', NEW.id_usuario_reporta,
            'id_geo', NEW.id_geo
        );
    ELSE -- DELETING
        SET accion = 'DELETE';
        SET valores_ant = JSON_OBJECT(
            'id_incidencia', OLD.id_incidencia,
            'id_tipo_incidencia', OLD.id_tipo_incidencia,
            'id_zona', OLD.id_zona,
            'descripcion', OLD.descripcion,
            'fecha_inicio', OLD.fecha_inicio,
            'fecha_fin', OLD.fecha_fin,
            'id_estado_incidencia', OLD.id_estado_incidencia,
            'id_nivel_impacto', OLD.id_nivel_impacto,
            'radio_afectacion_km', OLD.radio_afectacion_km,
            'id_usuario_reporta', OLD.id_usuario_reporta,
            'id_geo', OLD.id_geo
        );
        SET valores_nuev = NULL;
    END IF;
    
    -- Insertar en la tabla de auditoría
    INSERT INTO aud_incidencias (id_incidencia, accion, valores_anteriores, valores_nuevos, usuario)
    VALUES (
        COALESCE(NEW.id_incidencia, OLD.id_incidencia),
        accion,
        valores_ant,
        valores_nuev,
        CURRENT_USER()
    );
END$$
DELIMITER ;