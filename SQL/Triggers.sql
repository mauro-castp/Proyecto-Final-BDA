-- -----------------------------------------------------
-- Triggers de Auditoría para la tabla `pedidos`
-- -----------------------------------------------------
CREATE TRIGGER pedidos_ai
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
END$$ 
CREATE TRIGGER pedidos_au
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
END$$ 
CREATE TRIGGER pedidos_ad
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
END$$ 

-- -----------------------------------------------------
-- Triggers de Auditoría para la tabla `rutas`
-- -----------------------------------------------------
CREATE TRIGGER rutas_ai
AFTER INSERT ON rutas
FOR EACH ROW
BEGIN
    INSERT INTO aud_rutas (
        id_ruta, valores_anteriores, valores_nuevos, usuario, fecha
    ) VALUES (
        NEW.id_ruta, NULL,
        JSON_OBJECT(
            'nombre_ruta', NEW.nombre_ruta, 'id_zona', NEW.id_zona, 'fecha_ruta', NEW.fecha_ruta,
            'id_vehiculo', NEW.id_vehiculo, 'id_repartidor', NEW.id_repartidor, 'id_estado_ruta', NEW.id_estado_ruta,
            'distancia_total_km', NEW.distancia_total_km, 'tiempo_estimado_minutos', NEW.tiempo_estimado_minutos, 'costo', NEW.costo
        ),
        CURRENT_USER(), NOW()
    );
END$$ 
CREATE TRIGGER rutas_au
AFTER UPDATE ON rutas
FOR EACH ROW
BEGIN
    INSERT INTO aud_rutas (
        id_ruta, valores_anteriores, valores_nuevos, usuario, fecha
    ) VALUES (
        NEW.id_ruta,
        JSON_OBJECT(
            'nombre_ruta', OLD.nombre_ruta, 'id_zona', OLD.id_zona, 'fecha_ruta', OLD.fecha_ruta,
            'id_vehiculo', OLD.id_vehiculo, 'id_repartidor', OLD.id_repartidor, 'id_estado_ruta', OLD.id_estado_ruta,
            'distancia_total_km', OLD.distancia_total_km, 'tiempo_estimado_minutos', OLD.tiempo_estimado_minutos, 'costo', OLD.costo
        ),
        JSON_OBJECT(
            'nombre_ruta', NEW.nombre_ruta, 'id_zona', NEW.id_zona, 'fecha_ruta', NEW.fecha_ruta,
            'id_vehiculo', NEW.id_vehiculo, 'id_repartidor', NEW.id_repartidor, 'id_estado_ruta', NEW.id_estado_ruta,
            'distancia_total_km', NEW.distancia_total_km, 'tiempo_estimado_minutos', NEW.tiempo_estimado_minutos, 'costo', NEW.costo
        ),
        CURRENT_USER(), NOW()
    );
END$$ 
CREATE TRIGGER rutas_ad
AFTER DELETE ON rutas
FOR EACH ROW
BEGIN
    INSERT INTO aud_rutas (
        id_ruta, valores_anteriores, valores_nuevos, usuario, fecha
    ) VALUES (
        OLD.id_ruta,
        JSON_OBJECT(
            'nombre_ruta', OLD.nombre_ruta, 'id_zona', OLD.id_zona, 'fecha_ruta', OLD.fecha_ruta,
            'id_vehiculo', OLD.id_vehiculo, 'id_repartidor', OLD.id_repartidor, 'id_estado_ruta', OLD.id_estado_ruta,
            'distancia_total_km', OLD.distancia_total_km, 'tiempo_estimado_minutos', OLD.tiempo_estimado_minutos, 'costo', OLD.costo
        ),
        NULL, CURRENT_USER(), NOW()
    );
END$$ 

-- -----------------------------------------------------
-- Triggers de Auditoría para la tabla `entregas`
-- -----------------------------------------------------
CREATE TRIGGER entregas_ai
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
            'hora_inicio_entrega', NEW.hora_inicio_entrega, 'fecha_fin_entrega', NEW.fecha_fin_entrega,
            'tiempo_entrega_minutos', NEW.tiempo_entrega_minutos, 'reintentos', NEW.reintentos,
            'cumplio_sla', NEW.cumplio_sla, 'fue_tarde', NEW.fue_tarde, 'costo_entrega', NEW.costo_entrega,
            'id_motivo_fallo', NEW.id_motivo_fallo
        ),
        CURRENT_USER(), NOW()
    );
END$$ 
CREATE TRIGGER entregas_au
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
            'hora_inicio_entrega', OLD.hora_inicio_entrega, 'fecha_fin_entrega', OLD.fecha_fin_entrega,
            'tiempo_entrega_minutos', OLD.tiempo_entrega_minutos, 'reintentos', OLD.reintentos,
            'cumplio_sla', OLD.cumplio_sla, 'fue_tarde', OLD.fue_tarde, 'costo_entrega', OLD.costo_entrega,
            'id_motivo_fallo', OLD.id_motivo_fallo
        ),
        JSON_OBJECT(
            'id_pedido', NEW.id_pedido, 'id_ruta', NEW.id_ruta, 'id_repartidor', NEW.id_repartidor,
            'id_estado_entrega', NEW.id_estado_entrega, 'fecha_estimada_entrega', NEW.fecha_estimada_entrega,
            'hora_inicio_entrega', NEW.hora_inicio_entrega, 'fecha_fin_entrega', NEW.fecha_fin_entrega,
            'tiempo_entrega_minutos', NEW.tiempo_entrega_minutos, 'reintentos', NEW.reintentos,
            'cumplio_sla', NEW.cumplio_sla, 'fue_tarde', NEW.fue_tarde, 'costo_entrega', NEW.costo_entrega,
            'id_motivo_fallo', NEW.id_motivo_fallo
        ),
        CURRENT_USER(), NOW()
    );
END$$ 
CREATE TRIGGER entregas_ad
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
            'hora_inicio_entrega', OLD.hora_inicio_entrega, 'fecha_fin_entrega', OLD.fecha_fin_entrega,
            'tiempo_entrega_minutos', OLD.tiempo_entrega_minutos, 'reintentos', OLD.reintentos,
            'cumplio_sla', OLD.cumplio_sla, 'fue_tarde', OLD.fue_tarde, 'costo_entrega', OLD.costo_entrega,
            'id_motivo_fallo', OLD.id_motivo_fallo
        ),
        NULL, CURRENT_USER(), NOW()
    );
END$$ 

-- -----------------------------------------------------
-- Triggers de Auditoría para la tabla `incidencias`
-- -----------------------------------------------------
CREATE TRIGGER incidencias_ai
AFTER INSERT ON incidencias
FOR EACH ROW
BEGIN
    INSERT INTO aud_incidencias (
        id_incidencia, valores_anteriores, valores_nuevos, usuario, fecha
    ) VALUES (
        NEW.id_incidencia, NULL,
        JSON_OBJECT(
            'id_tipo_incidencia', NEW.id_tipo_incidencia, 'id_zona', NEW.id_zona, 'descripcion', NEW.descripcion,
            'fecha_inicio', NEW.fecha_inicio, 'fecha_fin', NEW.fecha_fin, 'id_estado_incidencia', NEW.id_estado_incidencia,
            'id_nivel_impacto', NEW.id_nivel_impacto, 'radio_afectacion_km', NEW.radio_afectacion_km,
            'id_usuario_reporta', NEW.id_usuario_reporta, 'id_geo', NEW.id_geo
        ),
        CURRENT_USER(), NOW()
    );
END$$ 
CREATE TRIGGER incidencias_au
AFTER UPDATE ON incidencias
FOR EACH ROW
BEGIN
    INSERT INTO aud_incidencias (
        id_incidencia, valores_anteriores, valores_nuevos, usuario, fecha
    ) VALUES (
        NEW.id_incidencia,
        JSON_OBJECT(
            'id_tipo_incidencia', OLD.id_tipo_incidencia, 'id_zona', OLD.id_zona, 'descripcion', OLD.descripcion,
            'fecha_inicio', OLD.fecha_inicio, 'fecha_fin', OLD.fecha_fin, 'id_estado_incidencia', OLD.id_estado_incidencia,
            'id_nivel_impacto', OLD.id_nivel_impacto, 'radio_afectacion_km', OLD.radio_afectacion_km,
            'id_usuario_reporta', OLD.id_usuario_reporta, 'id_geo', OLD.id_geo
        ),
        JSON_OBJECT(
            'id_tipo_incidencia', NEW.id_tipo_incidencia, 'id_zona', NEW.id_zona, 'descripcion', NEW.descripcion,
            'fecha_inicio', NEW.fecha_inicio, 'fecha_fin', NEW.fecha_fin, 'id_estado_incidencia', NEW.id_estado_incidencia,
            'id_nivel_impacto', NEW.id_nivel_impacto, 'radio_afectacion_km', NEW.radio_afectacion_km,
            'id_usuario_reporta', NEW.id_usuario_reporta, 'id_geo', NEW.id_geo
        ),
        CURRENT_USER(), NOW()
    );
END$$ 
CREATE TRIGGER incidencias_ad
AFTER DELETE ON incidencias
FOR EACH ROW
BEGIN
    INSERT INTO aud_incidencias (
        id_incidencia, valores_anteriores, valores_nuevos, usuario, fecha
    ) VALUES (
        OLD.id_incidencia,
        JSON_OBJECT(
            'id_tipo_incidencia', OLD.id_tipo_incidencia, 'id_zona', OLD.id_zona, 'descripcion', OLD.descripcion,
            'fecha_inicio', OLD.fecha_inicio, 'fecha_fin', OLD.fecha_fin, 'id_estado_incidencia', OLD.id_estado_incidencia,
            'id_nivel_impacto', OLD.id_nivel_impacto, 'radio_afectacion_km', OLD.radio_afectacion_km,
            'id_usuario_reporta', OLD.id_usuario_reporta, 'id_geo', OLD.id_geo
        ),
        NULL, CURRENT_USER(), NOW()
    );
END$$ 

-- -----------------------------------------------------
-- Trigger: detallePedidoValidacionBI
-- Tabla: detalle_pedido
-- Propósito: Valida que la cantidad sea > 0 y el producto exista.
-- -----------------------------------------------------
CREATE TRIGGER detallePedidoValidacionBI
BEFORE INSERT ON detalle_pedido
FOR EACH ROW
BEGIN
    IF NEW.cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: La cantidad del producto debe ser mayor que cero.';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM productos WHERE id_producto = NEW.id_producto) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: El ID de producto especificado no es válido.';
    END IF;
END$$ 
CREATE TRIGGER detallePedidoValidacionBU
BEFORE UPDATE ON detalle_pedido
FOR EACH ROW
BEGIN
    IF NEW.cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: La cantidad del producto debe ser mayor que cero.';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM productos WHERE id_producto = NEW.id_producto) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error de validación: El ID de producto especificado no es válido.';
    END IF;
END$$ 

-- -----------------------------------------------------
-- Trigger: entregaEstadoBU
-- Tabla: entregas
-- Propósito: Controla que las transiciones de estado sean lógicas.
-- -----------------------------------------------------
CREATE TRIGGER entregaEstadoBU
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
END$$ 

-- -----------------------------------------------------
-- Trigger: vehiculoCapacidadBI
-- Tabla: paradas_ruta
-- Propósito: Evita sobrecargar un vehículo más allá de su capacidad.
-- -----------------------------------------------------
CREATE TRIGGER vehiculoCapacidadBI
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
END$$ 
CREATE TRIGGER vehiculoCapacidadBU
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
END$$ 

-- -----------------------------------------------------
-- Trigger: incidenciaBloqueoBI
-- Tabla: incidencias
-- Propósito: Evita solapes de incidencias activas en la misma zona.
-- -----------------------------------------------------
CREATE TRIGGER incidenciaBloqueoBI
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
END$$ 
CREATE TRIGGER incidenciaBloqueoBU
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
END$$ 

-- -----------------------------------------------------
-- Trigger: normalizaDireccionClienteBI
-- Tabla: direcciones_cliente
-- Propósito: Limpia los datos de la dirección (elimina espacios).
-- -----------------------------------------------------
CREATE TRIGGER normalizaDireccionClienteBI
BEFORE INSERT ON direcciones_cliente
FOR EACH ROW
BEGIN
    SET NEW.direccion = TRIM(NEW.direccion);
END$$ 
CREATE TRIGGER normalizaDireccionClienteBU
BEFORE UPDATE ON direcciones_cliente
FOR EACH ROW
BEGIN
    SET NEW.direccion = TRIM(NEW.direccion);
END$$ 

-- -----------------------------------------------------
-- Trigger: slaRetrasoMarcaAIEntrega
-- Tabla: entregas
-- Propósito: Marca como "tarde" una entrega si la fecha estimada ya pasó.
-- -----------------------------------------------------
CREATE TRIGGER slaRetrasoMarcaAIEntrega
AFTER INSERT ON entregas
FOR EACH ROW
BEGIN
    IF NEW.fecha_estimada_entrega < NOW() THEN
        UPDATE entregas SET fue_tarde = 1 WHERE id_entrega = NEW.id_entrega;
    END IF;
END$$ 
