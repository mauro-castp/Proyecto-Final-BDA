-- clienteCrearActualizar

-- Corrección del procedimiento clienteCrearActualizar
DROP PROCEDURE IF EXISTS clienteCrearActualizar;

DELIMITER $$
CREATE PROCEDURE clienteCrearActualizar(
    IN p_id_cliente INT,
    IN p_nombre VARCHAR(200),
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(150),
    IN p_direccion TEXT,
    IN p_id_zona INT,
    IN p_id_estado_cliente INT,
    IN p_usuario_sistema VARCHAR(100)  -- PARÁMETRO NUEVO (8°)
)
BEGIN
    SET p_direccion = TRIM(p_direccion);

    -- Guardar el usuario del sistema en variable de sesión para los triggers
    SET @usuario_sistema = p_usuario_sistema;

    IF p_id_cliente IS NULL THEN
        INSERT INTO clientes(nombre, telefono, email, id_estado_cliente)
        VALUES(p_nombre, p_telefono, p_email, p_id_estado_cliente);
        
        SET p_id_cliente = LAST_INSERT_ID();

        INSERT INTO direcciones_cliente(id_cliente, direccion, id_zona, id_estado_direccion, es_principal)
        VALUES(p_id_cliente, p_direccion, p_id_zona, 1, 1);
    ELSE
        UPDATE clientes
        SET nombre = p_nombre,
            telefono = p_telefono,
            email = p_email,
            id_estado_cliente = p_id_estado_cliente
        WHERE id_cliente = p_id_cliente;

        UPDATE direcciones_cliente
        SET direccion = p_direccion,
            id_zona = p_id_zona
        WHERE id_cliente = p_id_cliente AND es_principal = 1;
    END IF;

    -- Limpiar la variable de sesión
    SET @usuario_sistema = NULL;

    SELECT p_id_cliente AS id_cliente;
END $$
DELIMITER ;

-- clientesActivosListar
DELIMITER $$
CREATE PROCEDURE clientesActivosListar()
BEGIN
    SELECT 
        c.id_cliente,
        c.nombre,
        c.telefono,
        c.email,
        dc.id_direccion,
        dc.direccion,
        z.nombre_zona,
        c.id_estado_cliente,
        ec.nombre_estado AS estado_nombre 
    FROM clientes c
    LEFT JOIN direcciones_cliente dc ON c.id_cliente = dc.id_cliente
    LEFT JOIN zonas z ON dc.id_zona = z.id_zona
    JOIN estados_cliente ec ON c.id_estado_cliente = ec.id_estado_cliente  
    WHERE c.id_estado_cliente = 1
    ORDER BY c.nombre;
END $$
DELIMITER ;

-- clienteDireccionesListar
DELIMITER $$
CREATE PROCEDURE clienteDireccionesListar(
    IN p_id_cliente INT
)
BEGIN
    SELECT 
        id_direccion,
        direccion,
        id_zona,
        es_principal,
        id_estado_direccion
    FROM direcciones_cliente
    WHERE id_cliente = p_id_cliente
      AND id_estado_direccion IN (1, 3)
    ORDER BY es_principal DESC, direccion ASC;
END $$
DELIMITER ;

-- productosActivosListar
DELIMITER $$
CREATE PROCEDURE productosActivosListar()
BEGIN
    SELECT 
        id_producto,
        nombre,
        descripcion,
        precio_unitario,
        peso_kg,
        volumen_m3
    FROM productos
    WHERE id_estado_producto = 1
    ORDER BY nombre;
END $$
DELIMITER ;

-- pedidoCrear

DELIMITER $$
CREATE PROCEDURE pedidoCrear(
    IN p_id_cliente INT,
    IN p_id_direccion INT,
    IN p_id_empresa INT,
    IN p_items JSON
)
BEGIN
    DECLARE v_pedido_id INT;
    DECLARE v_i INT DEFAULT 0;
    DECLARE v_len INT;
    DECLARE v_producto INT;
    DECLARE v_cant INT;
    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_peso DECIMAL(10,2);
    DECLARE v_vol DECIMAL(10,4);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'error' AS status;
    END;

    START TRANSACTION;

    -- Insertar pedido con id_empresa
    INSERT INTO pedidos(
        id_cliente, 
        id_direccion_entrega, 
        id_empresa,
        id_estado_pedido,
        total_pedido, 
        peso_total, 
        volumen_total
    )
    VALUES(
        p_id_cliente, 
        p_id_direccion, 
        p_id_empresa,
        1, 
        0, 
        0, 
        0
    );

    SET v_pedido_id = LAST_INSERT_ID();
    SET v_len = JSON_LENGTH(p_items);

    WHILE v_i < v_len DO
        SET v_producto = JSON_EXTRACT(p_items, CONCAT('$[', v_i, '].producto'));
        SET v_cant     = JSON_EXTRACT(p_items, CONCAT('$[', v_i, '].cantidad'));

        SELECT precio_unitario, peso_kg, volumen_m3
        INTO v_precio, v_peso, v_vol
        FROM productos
        WHERE id_producto = v_producto;

        INSERT INTO detalle_pedido(id_pedido, id_producto, cantidad, subtotal)
        VALUES(v_pedido_id, v_producto, v_cant, v_precio * v_cant);

        UPDATE pedidos
        SET total_pedido  = total_pedido  + (v_precio * v_cant),
            peso_total    = peso_total    + (v_peso   * v_cant),
            volumen_total = volumen_total + (v_vol    * v_cant)
        WHERE id_pedido = v_pedido_id;

        SET v_i = v_i + 1;
    END WHILE;

    COMMIT;
    SELECT v_pedido_id AS id_pedido;
END $$
DELIMITER ;

-- pedidosListar
DELIMITER $$
CREATE PROCEDURE pedidosListar(
    IN p_id_usuario INT,
    IN p_id_rol INT,
    IN p_estado VARCHAR(50),
    IN p_fecha DATE,
    IN p_id_empresa INT,
    IN p_offset INT,
    IN p_limite INT
)
BEGIN
    DECLARE v_offset INT DEFAULT 0;
    DECLARE v_limite INT DEFAULT 10;
    DECLARE v_total INT DEFAULT 0;
    DECLARE v_total_paginas INT DEFAULT 1;

    IF p_offset IS NOT NULL AND p_offset >= 0 THEN
        SET v_offset = p_offset;
    END IF;

    IF p_limite IS NOT NULL AND p_limite > 0 THEN
        SET v_limite = LEAST(p_limite, 50);
    END IF;

    -- Contar total de registros con filtro por empresa
    SELECT COUNT(DISTINCT p.id_pedido)
    INTO v_total
    FROM pedidos p
    LEFT JOIN entregas e ON e.id_pedido = p.id_pedido
    JOIN estados_pedido ep ON p.id_estado_pedido = ep.id_estado_pedido
    LEFT JOIN empresas emp ON p.id_empresa = emp.id_empresa
    WHERE (p_estado IS NULL OR p_estado = '' OR LOWER(ep.nombre_estado) = LOWER(p_estado))
      AND (p_fecha IS NULL OR DATE(p.fecha_pedido) = p_fecha)
      AND (p_id_empresa IS NULL OR p.id_empresa = p_id_empresa)
      AND (p_id_rol <> 3 OR e.id_repartidor = p_id_usuario);

    IF v_total = 0 THEN
        SET v_total_paginas = 1;
    ELSE
        SET v_total_paginas = CEILING(v_total / v_limite);
    END IF;

    -- Obtener pedidos con información de empresa
    SELECT 
        p.id_pedido,
        p.fecha_pedido,
        p.total_pedido,
        p.peso_total,
        p.volumen_total,
        p.id_empresa,
        emp.nombre AS empresa_nombre,
        c.nombre AS cliente_nombre,
        c.email AS cliente_email,
        c.telefono AS cliente_telefono,
        ep.nombre_estado AS estado_nombre,
        COALESCE(SUM(dp.cantidad), 0) AS cantidad_productos
    FROM pedidos p
    JOIN clientes c ON p.id_cliente = c.id_cliente
    JOIN estados_pedido ep ON p.id_estado_pedido = ep.id_estado_pedido
    LEFT JOIN empresas emp ON p.id_empresa = emp.id_empresa
    LEFT JOIN detalle_pedido dp ON dp.id_pedido = p.id_pedido
    LEFT JOIN entregas e ON e.id_pedido = p.id_pedido
    WHERE (p_estado IS NULL OR p_estado = '' OR LOWER(ep.nombre_estado) = LOWER(p_estado))
      AND (p_fecha IS NULL OR DATE(p.fecha_pedido) = p_fecha)
      AND (p_id_empresa IS NULL OR p.id_empresa = p_id_empresa)
      AND (p_id_rol <> 3 OR e.id_repartidor = p_id_usuario)
    GROUP BY 
        p.id_pedido,
        p.fecha_pedido,
        p.total_pedido,
        p.peso_total,
        p.volumen_total,
        p.id_empresa,
        emp.nombre,
        c.nombre,
        c.email,
        c.telefono,
        ep.nombre_estado
    ORDER BY p.fecha_pedido DESC
    LIMIT v_limite OFFSET v_offset;

    -- Retornar información de paginación
    SELECT 
        v_total AS total_registros,
        v_total_paginas AS total_paginas,
        v_limite AS limite,
        v_offset AS offset_actual;
END $$
DELIMITER ;

-- pedidosResumenEstados
DELIMITER $$
CREATE PROCEDURE pedidosResumenEstados()
BEGIN
    SELECT 
        COUNT(*) AS total,
        SUM(CASE WHEN ep.nombre_estado IN ('pendiente', 'confirmado', 'en preparacion') THEN 1 ELSE 0 END) AS pendientes,
        SUM(CASE WHEN ep.nombre_estado IN ('listo para entrega', 'en camino') THEN 1 ELSE 0 END) AS proceso,
        SUM(CASE WHEN ep.nombre_estado = 'entregado' THEN 1 ELSE 0 END) AS completados,
        -- Estadísticas por empresa
        (SELECT COUNT(*) FROM pedidos WHERE id_empresa IS NOT NULL) AS con_empresa,
        (SELECT COUNT(*) FROM pedidos WHERE id_empresa IS NULL) AS sin_empresa
    FROM pedidos p
    JOIN estados_pedido ep ON p.id_estado_pedido = ep.id_estado_pedido;
END $$
DELIMITER ;

-- pedidoObtener
DELIMITER $$
CREATE PROCEDURE pedidoObtener(
    IN p_id_pedido INT
)
BEGIN
    SELECT 
        p.id_pedido,
        p.fecha_pedido,
        p.total_pedido,
        p.peso_total,
        p.volumen_total,
        p.id_estado_pedido,
        p.id_empresa,
        emp.nombre AS empresa_nombre,
        ep.nombre_estado AS estado_nombre,
        c.nombre AS cliente_nombre,
        c.email AS cliente_email,
        c.telefono AS cliente_telefono,
        dc.direccion AS direccion_entrega,
        z.nombre_zona
    FROM pedidos p
    JOIN clientes c ON p.id_cliente = c.id_cliente
    JOIN estados_pedido ep ON p.id_estado_pedido = ep.id_estado_pedido
    JOIN direcciones_cliente dc ON p.id_direccion_entrega = dc.id_direccion
    JOIN zonas z ON dc.id_zona = z.id_zona
    LEFT JOIN empresas emp ON p.id_empresa = emp.id_empresa
    WHERE p.id_pedido = p_id_pedido;
END $$
DELIMITER ;

-- pedidoDetalleObtener
DELIMITER $$
CREATE PROCEDURE pedidoDetalleObtener(
    IN p_id_pedido INT
)
BEGIN
    SELECT 
        dp.id_detalle,
        dp.id_producto,
        dp.cantidad,
        dp.subtotal,
        pr.nombre AS nombre_producto,
        pr.precio_unitario
    FROM detalle_pedido dp
    JOIN productos pr ON dp.id_producto = pr.id_producto
    WHERE dp.id_pedido = p_id_pedido;
END $$
DELIMITER ;

-- pedidoCancelar

DELIMITER $$
CREATE PROCEDURE pedidoCancelar(
    IN p_id_pedido INT,
    IN p_motivo TEXT
)
BEGIN
    DECLARE v_estado INT;
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_status VARCHAR(20) DEFAULT 'ok';

    SELECT id_estado_pedido, total_pedido
    INTO v_estado, v_total
    FROM pedidos
    WHERE id_pedido = p_id_pedido;

    IF v_estado = 1 THEN
        UPDATE pedidos
        SET id_estado_pedido = 5
        WHERE id_pedido = p_id_pedido;

        SET v_status = 'ok';

    ELSEIF v_estado = 2 THEN
        INSERT INTO penalizaciones(id_entrega, id_tipo_penalizacion, monto)
        VALUES (NULL, 1, v_total * 0.10);

        UPDATE pedidos
        SET id_estado_pedido = 5
        WHERE id_pedido = p_id_pedido;

        SET v_status = 'ok';

    ELSE
        -- no cancelable: dejamos el status en 'no_cancelable'
        SET v_status = 'no_cancelable';
    END IF;

    SELECT v_status AS status;
END $$
DELIMITER ;

-- rutaCrear

DELIMITER $$
CREATE PROCEDURE rutaCrear(
    IN p_id_zona INT,
    IN p_fecha DATE,
    IN p_id_vehiculo INT,
    IN p_id_repartidor INT,
    IN p_secuencia JSON
)
BEGIN
    DECLARE v_ruta_id INT;
    DECLARE v_len INT;
    DECLARE v_i INT DEFAULT 0;
    DECLARE v_id_pedido INT;

    INSERT INTO rutas(
        nombre_ruta,
        id_zona,
        fecha_ruta,
        id_vehiculo,
        id_repartidor,
        id_estado_ruta
    )
    VALUES(
        CONCAT('Ruta ', NOW()),
        p_id_zona,
        p_fecha,
        p_id_vehiculo,
        p_id_repartidor,
        1
    );

    SET v_ruta_id = LAST_INSERT_ID();
    SET v_len = JSON_LENGTH(p_secuencia);

    WHILE v_i < v_len DO
        SET v_id_pedido = JSON_EXTRACT(p_secuencia, CONCAT('$[', v_i, ']'));

        INSERT INTO paradas_ruta(
            id_ruta,
            id_pedido,
            orden_secuencia,
            id_estado_parada
        )
        VALUES(
            v_ruta_id,
            v_id_pedido,
            v_i + 1,
            1
        );

        SET v_i = v_i + 1;
    END WHILE;

    SELECT v_ruta_id AS id_ruta;
END $$
DELIMITER ;

-- entregaAsignar

DELIMITER $$
CREATE PROCEDURE entregaAsignar(
    IN p_id_pedido INT,
    IN p_id_ruta INT,
    IN p_id_vehiculo INT,
    IN p_id_repartidor INT
)
BEGIN
    DECLARE v_peso DECIMAL(10,2);
    DECLARE v_vol DECIMAL(10,4);
    DECLARE v_cap_peso DECIMAL(10,2);
    DECLARE v_cap_vol DECIMAL(10,4);
    DECLARE v_status VARCHAR(30) DEFAULT 'ok';

    SELECT peso_total, volumen_total
    INTO v_peso, v_vol
    FROM pedidos
    WHERE id_pedido = p_id_pedido;

    SELECT tv.peso_kg, tv.volumen_m3
    INTO v_cap_peso, v_cap_vol
    FROM vehiculos v
    JOIN tipos_vehiculo tv ON tv.id_tipo_vehiculo = v.id_tipo_vehiculo
    WHERE v.id_vehiculo = p_id_vehiculo;

    -- Validación de capacidad
    IF v_peso > v_cap_peso OR v_vol > v_cap_vol THEN
        SET v_status = 'capacidad_insuficiente';
    ELSE
        INSERT INTO entregas(
            id_pedido,
            id_ruta,
            id_repartidor,
            id_estado_entrega,
            fecha_estimada_entrega,
            reintentos
        )
        VALUES(
            p_id_pedido,
            p_id_ruta,
            p_id_repartidor,
            1,
            NOW(),
            0
        );

        SET v_status = LAST_INSERT_ID();
    END IF;

    SELECT v_status AS status;
END $$
DELIMITER ;

-- entregaConfirmar

DELIMITER $$
CREATE PROCEDURE entregaConfirmar(
    IN p_id_entrega INT,
    IN p_hora_real DATETIME,
    IN p_evidencia_url TEXT
)
BEGIN
    DECLARE v_fecha_estimada DATETIME;
    DECLARE v_estado_actual INT;
    DECLARE v_tipo_penalizacion INT DEFAULT NULL;
    DECLARE v_status VARCHAR(30) DEFAULT 'ok';

    -- Obtener datos de la entrega
    SELECT fecha_estimada_entrega, id_estado_entrega
    INTO v_fecha_estimada, v_estado_actual
    FROM entregas
    WHERE id_entrega = p_id_entrega;

    -- Validar estado válido
    IF v_estado_actual <> 1 AND v_estado_actual <> 2 THEN
        SET v_status = 'estado_invalido';
    ELSE

        -- Registrar evidencia
        INSERT INTO evidencias(id_entrega, tipo, url)
        VALUES(p_id_entrega, 'foto', p_evidencia_url);

        -- Actualizar la entrega como completada
        UPDATE entregas
        SET fecha_entrega_real = p_hora_real,
            id_estado_entrega = 3
        WHERE id_entrega = p_id_entrega;

        -- Penalización por retraso
        IF p_hora_real > v_fecha_estimada THEN
            SET v_tipo_penalizacion = 2;

            INSERT INTO penalizaciones(
                id_entrega,
                id_tipo_penalizacion,
                monto
            )
            VALUES(
                p_id_entrega,
                v_tipo_penalizacion,
                20.00
            );
        END IF;
    END IF;

    SELECT v_status AS status;
END $$
DELIMITER ;

-- entregaReintento

DELIMITER $$
CREATE PROCEDURE entregaReintento(
    IN p_id_entrega INT,
    IN p_motivo_fallo INT
)
BEGIN
    DECLARE v_reintentos INT;
    DECLARE v_limite INT DEFAULT 3;
    DECLARE v_status VARCHAR(30) DEFAULT 'ok';

    -- Obtener reintentos actuales
    SELECT reintentos
    INTO v_reintentos
    FROM entregas
    WHERE id_entrega = p_id_entrega;

    -- Validar límite
    IF v_reintentos >= v_limite THEN
        SET v_status = 'limite_reintentos';
    ELSE
        -- Actualizar entrega
        UPDATE entregas
        SET reintentos = reintentos + 1,
            id_motivo_fallo = p_motivo_fallo,
            id_estado_entrega = 4
        WHERE id_entrega = p_id_entrega;

        -- Si alcanzó el límite con este reintento → penalización
        IF v_reintentos + 1 >= v_limite THEN
            INSERT INTO penalizaciones(id_entrega, id_tipo_penalizacion, monto)
            VALUES(p_id_entrega, 3, 25.00);
        END IF;
    END IF;

    -- Devolver resultado
    SELECT v_status AS status;
END $$
DELIMITER ;

-- incidenciaRegistrar

DELIMITER $$
CREATE PROCEDURE incidenciaRegistrar(
    IN p_id_zona INT,
    IN p_id_tipo_incidencia INT,
    IN p_desde DATETIME,
    IN p_hasta DATETIME
)
BEGIN
    INSERT INTO incidencias(
        id_zona,
        id_tipo_incidencia,
        fecha_inicio,
        fecha_fin,
        id_estado_incidencia
    )
    VALUES(
        p_id_zona,
        p_id_tipo_incidencia,
        p_desde,
        p_hasta,
        1
    );

    SELECT LAST_INSERT_ID() AS id_incidencia;
END $$
DELIMITER ;

-- otpRango

DELIMITER $$
CREATE PROCEDURE otpRango(
    IN p_desde DATE,
    IN p_hasta DATE
)
BEGIN
    CREATE TEMPORARY TABLE tmpOtp (
        id_ruta INT,
        total_otps INT,
        otps_usados INT,
        otps_no_usados INT
    );

    INSERT INTO tmpOtp(id_ruta, total_otps, otps_usados, otps_no_usados)
    SELECT
        e.id_ruta,
        COUNT(o.id_otp) AS total_otps,
        SUM(CASE WHEN o.verificado = 1 THEN 1 ELSE 0 END) AS otps_usados,
        SUM(CASE WHEN o.verificado = 0 THEN 1 ELSE 0 END) AS otps_no_usados
    FROM entregas e
    JOIN otp o ON o.id_entrega = e.id_entrega
    WHERE DATE(o.fecha_generado) BETWEEN p_desde AND p_hasta
    GROUP BY e.id_ruta;

    SELECT * FROM tmpOtp;
    DROP TEMPORARY TABLE tmpOtp;
END $$
DELIMITER ;

-- costosKMRango

DELIMITER $$
CREATE PROCEDURE costosKMRango(
    IN p_desde DATE,
    IN p_hasta DATE
)
BEGIN
    CREATE TEMPORARY TABLE tmpCostosKM (
        id_zona INT,
        id_vehiculo INT,
        km_total DECIMAL(10,2),
        costo_total DECIMAL(10,2),
        costo_por_km DECIMAL(10,2)
    );

    INSERT INTO tmpCostosKM(id_zona, id_vehiculo, km_total, costo_total, costo_por_km)
    SELECT 
        c.id_zona,
        c.id_vehiculo,
        SUM(c.km_recorridos) AS km_total,
        SUM(c.costo_total) AS costo_total,
        SUM(c.costo_total) / NULLIF(SUM(c.km_recorridos),0) AS costo_por_km
    FROM costos_operativos c
    WHERE DATE(c.fecha_registro) BETWEEN p_desde AND p_hasta
    GROUP BY c.id_zona, c.id_vehiculo;

    SELECT * FROM tmpCostosKM;
    DROP TEMPORARY TABLE tmpCostosKM;
END $$
DELIMITER ;

-- productividadRepartidor

DELIMITER $$
CREATE PROCEDURE productividadRepartidor(
    IN p_desde DATE,
    IN p_hasta DATE
)
BEGIN
    CREATE TEMPORARY TABLE tmpProductividad (
        id_repartidor INT,
        nombre VARCHAR(200),
        entregas_realizadas INT
    );

    INSERT INTO tmpProductividad(id_repartidor, nombre, entregas_realizadas)
    SELECT
        u.id_usuario AS id_repartidor,
        u.nombre,
        COUNT(e.id_entrega) AS entregas_realizadas
    FROM entregas e
    JOIN usuarios u ON u.id_usuario = e.id_repartidor
    WHERE e.id_estado_entrega = 3
      AND DATE(e.fecha_entrega_real) BETWEEN p_desde AND p_hasta
    GROUP BY u.id_usuario, u.nombre
    ORDER BY entregas_realizadas DESC;

    SELECT * FROM tmpProductividad;
    DROP TEMPORARY TABLE tmpProductividad;
END $$
DELIMITER ;

-- kpiGlobalMes

DELIMITER $$
CREATE PROCEDURE kpiGlobalMes(
    IN p_anio INT,
    IN p_mes INT
)
BEGIN
    CREATE TEMPORARY TABLE tmpKPIglobal (
        kpi VARCHAR(100),
        valor DECIMAL(15,2)
    );

    INSERT INTO tmpKPIglobal(kpi, valor)
    SELECT 'total_pedidos', COUNT(*) 
    FROM pedidos
    WHERE YEAR(fecha_creacion) = p_anio AND MONTH(fecha_creacion) = p_mes;

    INSERT INTO tmpKPIglobal(kpi, valor)
    SELECT 'entregas_completadas', COUNT(*)
    FROM entregas
    WHERE id_estado_entrega = 3
      AND YEAR(fecha_entrega_real) = p_anio AND MONTH(fecha_entrega_real) = p_mes;

    INSERT INTO tmpKPIglobal(kpi, valor)
    SELECT 'entregas_fallidas', COUNT(*)
    FROM entregas
    WHERE id_estado_entrega = 4
      AND YEAR(fecha_entrega_real) = p_anio AND MONTH(fecha_entrega_real) = p_mes;

    INSERT INTO tmpKPIglobal(kpi, valor)
    SELECT 'otp_usados', COUNT(*)
    FROM otp
    WHERE verificado = 1
      AND YEAR(fecha_generado) = p_anio AND MONTH(fecha_generado) = p_mes;

    INSERT INTO tmpKPIglobal(kpi, valor)
    SELECT 'reintentos', SUM(reintentos)
    FROM entregas
    WHERE YEAR(fecha_estimada_entrega) = p_anio AND MONTH(fecha_estimada_entrega) = p_mes;

    INSERT INTO tmpKPIglobal(kpi, valor)
    SELECT 'penalizaciones_total', SUM(monto)
    FROM penalizaciones
    WHERE YEAR(fecha) = p_anio AND MONTH(fecha) = p_mes;

    INSERT INTO tmpKPIglobal(kpi, valor)
    SELECT 'costo_total', SUM(costo_total)
    FROM costos_operativos
    WHERE YEAR(fecha_registro) = p_anio AND MONTH(fecha_registro) = p_mes;

    SELECT * FROM tmpKPIglobal;
    DROP TEMPORARY TABLE tmpKPIglobal;
END $$
DELIMITER ;

-- usuarioRoles

DELIMITER $$
CREATE PROCEDURE usuarioRoles(
    IN p_id_usuario INT
)
BEGIN
    SELECT r.nombre_rol
    FROM usuarios u
    JOIN roles r ON r.id_rol = u.id_rol
    WHERE u.id_usuario = p_id_usuario;
END $$
DELIMITER ;

-- inicioSesion

DROP PROCEDURE IF EXISTS inicioSesion;

DELIMITER $$
CREATE OR REPLACE PROCEDURE inicioSesion(
    IN p_email VARCHAR(150),
    IN p_password VARCHAR(255)
)
BEGIN
    SELECT 
        u.id_usuario,
        u.nombre,
        u.email,
        u.id_rol,
        r.nombre_rol
    FROM usuarios u
    INNER JOIN roles r ON u.id_rol = r.id_rol
    WHERE u.email = p_email
      AND u.password = p_password
      AND u.id_estado_usuario = 1
      AND r.id_estado_rol = 1; 
END $$
DELIMITER ;

-- auditoriaEntrega

DELIMITER $$
CREATE PROCEDURE auditoriaEntrega(
    IN p_desde DATETIME,
    IN p_hasta DATETIME
)
BEGIN
    SELECT 
        id_log,
        id_entrega,
        accion,
        valores_anteriores,
        valores_nuevos,
        usuario,
        fecha
    FROM aud_entregas
    WHERE fecha BETWEEN p_desde AND p_hasta
    ORDER BY fecha DESC;
END $$
DELIMITER ;

-- entregasZona

DELIMITER $$
CREATE PROCEDURE entregasZona(
    IN p_desde DATE,
    IN p_hasta DATE
)
BEGIN
    CREATE TEMPORARY TABLE tmpEntregasZona (
        id_zona INT,
        nombre_zona VARCHAR(100),
        entregas_completadas INT,
        entregas_fallidas INT,
        tasa_exito DECIMAL(5,2),
        tiempo_promedio_min INT
    );

    INSERT INTO tmpEntregasZona(id_zona, nombre_zona, entregas_completadas, entregas_fallidas, tasa_exito, tiempo_promedio_min)
    SELECT 
        z.id_zona,
        z.nombre_zona,
        SUM(CASE WHEN e.id_estado_entrega = 3 THEN 1 ELSE 0 END) as entregas_completadas,
        SUM(CASE WHEN e.id_estado_entrega = 4 THEN 1 ELSE 0 END) as entregas_fallidas,
        ROUND(
            (SUM(CASE WHEN e.id_estado_entrega = 3 THEN 1 ELSE 0 END) * 100.0) / 
            NULLIF(COUNT(e.id_entrega), 0), 
        2) as tasa_exito,
        AVG(TIMESTAMPDIFF(MINUTE, e.fecha_estimada_entrega, e.fecha_entrega_real)) as tiempo_promedio_min
    FROM zonas z
    LEFT JOIN direcciones_cliente dc ON dc.id_zona = z.id_zona
    LEFT JOIN pedidos p ON p.id_direccion_entrega = dc.id_direccion
    LEFT JOIN entregas e ON e.id_pedido = p.id_pedido
    WHERE DATE(e.fecha_estimada_entrega) BETWEEN p_desde AND p_hasta
    GROUP BY z.id_zona, z.nombre_zona;

    SELECT * FROM tmpEntregasZona;
    DROP TEMPORARY TABLE tmpEntregasZona;
END $$
DELIMITER ;

-- Procedimiento para obtener un cliente específico por ID
DELIMITER $$
CREATE PROCEDURE clienteObtenerPorId(
    IN p_id_cliente INT
)
BEGIN
    SELECT 
        c.id_cliente,
        c.nombre,
        c.telefono,
        c.email,
        dc.direccion,
        dc.id_zona,
        c.id_estado_cliente,
        ec.nombre_estado AS estado_nombre,
        c.fecha_creacion,
        c.fecha_actualizacion,
        z.nombre_zona
    FROM clientes c
    LEFT JOIN direcciones_cliente dc ON c.id_cliente = dc.id_cliente AND dc.es_principal = 1
    LEFT JOIN zonas z ON dc.id_zona = z.id_zona
    JOIN estados_cliente ec ON c.id_estado_cliente = ec.id_estado_cliente 
    WHERE c.id_cliente = p_id_cliente;
END $$
DELIMITER ;

-- Procedimiento para eliminar (soft delete) un cliente
DROP PROCEDURE IF EXISTS clienteEliminar;

DELIMITER $$
CREATE PROCEDURE clienteEliminar(
    IN p_id_cliente INT,
    IN p_usuario_sistema VARCHAR(100)  -- Usuario del sistema
)
BEGIN
    DECLARE cliente_existe INT DEFAULT 0;
    
    -- Verificar si el cliente existe
    SELECT COUNT(*) INTO cliente_existe 
    FROM clientes 
    WHERE id_cliente = p_id_cliente;
    
    IF cliente_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cliente no encontrado';
    ELSE
        -- Guardar el usuario del sistema en una variable de sesión MySQL
        SET @usuario_sistema = p_usuario_sistema;
        
        -- Eliminar direcciones primero (por las FK)
        DELETE FROM direcciones_cliente WHERE id_cliente = p_id_cliente;
        
        -- Eliminar cliente físicamente (el trigger usará la variable de sesión)
        DELETE FROM clientes WHERE id_cliente = p_id_cliente;
        
        -- Limpiar la variable de sesión
        SET @usuario_sistema = NULL;
        
        SELECT 'Cliente eliminado permanentemente' AS mensaje;
    END IF;
END $$
DELIMITER ;

-- Procedimiento para obtener estadísticas del dashboard
DELIMITER $$
CREATE PROCEDURE dashboardEstadisticas()
BEGIN
    SELECT 
        (SELECT COUNT(*) FROM pedidos WHERE id_estado_pedido IN (1,2)) as pedidos_pendientes,
        (SELECT COUNT(*) FROM entregas WHERE id_estado_entrega IN (1,2)) as entregas_pendientes,
        (SELECT COUNT(*) FROM rutas WHERE id_estado_ruta = 1) as rutas_activas,
        (SELECT COUNT(*) FROM incidencias WHERE id_estado_incidencia = 1) as incidencias_activas,
        (SELECT ROUND(
            (SELECT COUNT(*) FROM entregas WHERE id_estado_entrega = 5) * 100.0 / 
            NULLIF((SELECT COUNT(*) FROM entregas), 0), 2
        )) as tasa_exito;
END $$
DELIMITER ;

-- Procedimiento para obtener entregas de un repartidor específico
DELIMITER $$
CREATE PROCEDURE entregasObtenerPorRepartidor(
    IN p_id_repartidor INT
)
BEGIN
    SELECT 
        e.*, 
        p.id_pedido, 
        c.nombre as nombre_cliente, 
        ee.nombre_estado, 
        r.nombre_ruta
    FROM entregas e
    JOIN pedidos p ON e.id_pedido = p.id_pedido
    JOIN clientes c ON p.id_cliente = c.id_cliente
    JOIN estados_entrega ee ON e.id_estado_entrega = ee.id_estado_entrega
    LEFT JOIN rutas r ON e.id_ruta = r.id_ruta
    WHERE e.id_repartidor = p_id_repartidor
    ORDER BY e.fecha_estimada_entrega DESC;
END $$
DELIMITER ;

-- Procedimiento para obtener todas las entregas (admin/planificador)
DELIMITER $$
CREATE PROCEDURE entregasObtenerTodas()
BEGIN
    SELECT 
        e.*, 
        p.id_pedido, 
        c.nombre as nombre_cliente, 
        ee.nombre_estado, 
        r.nombre_ruta, 
        u.nombre as nombre_repartidor
    FROM entregas e
    JOIN pedidos p ON e.id_pedido = p.id_pedido
    JOIN clientes c ON p.id_cliente = c.id_cliente
    JOIN estados_entrega ee ON e.id_estado_entrega = ee.id_estado_entrega
    LEFT JOIN rutas r ON e.id_ruta = r.id_ruta
    LEFT JOIN usuarios u ON e.id_repartidor = u.id_usuario
    ORDER BY e.fecha_estimada_entrega DESC;
END $$
DELIMITER ;

-- Procedimiento para obtener una entrega específica por ID
DELIMITER $$
CREATE PROCEDURE entregaObtenerPorId(
    IN p_id_entrega INT
)
BEGIN
    SELECT 
        e.*, 
        p.id_pedido, 
        c.nombre as nombre_cliente, 
        ee.nombre_estado, 
        r.nombre_ruta, 
        u.nombre as nombre_repartidor,
        dc.direccion
    FROM entregas e
    JOIN pedidos p ON e.id_pedido = p.id_pedido
    JOIN clientes c ON p.id_cliente = c.id_cliente
    JOIN estados_entrega ee ON e.id_estado_entrega = ee.id_estado_entrega
    LEFT JOIN rutas r ON e.id_ruta = r.id_ruta
    LEFT JOIN usuarios u ON e.id_repartidor = u.id_usuario
    JOIN direcciones_cliente dc ON p.id_direccion_entrega = dc.id_direccion
    WHERE e.id_entrega = p_id_entrega;
END $$
DELIMITER ;

-- Procedimiento para obtener todas las incidencias
DELIMITER $$
CREATE PROCEDURE incidenciasObtenerTodas()
BEGIN
    SELECT 
        i.*, 
        z.nombre_zona, 
        ti.nombre_tipo, 
        ei.nombre_estado,
        ni.nombre_nivel, 
        u.nombre as nombre_reporta
    FROM incidencias i
    JOIN zonas z ON i.id_zona = z.id_zona
    JOIN tipos_incidencia ti ON i.id_tipo_incidencia = ti.id_tipo_incidencia
    JOIN estados_incidencia ei ON i.id_estado_incidencia = ei.id_estado_incidencia
    JOIN niveles_impacto ni ON i.id_nivel_impacto = ni.id_nivel_impacto
    LEFT JOIN usuarios u ON i.id_usuario_reporta = u.id_usuario
    ORDER BY i.fecha_inicio DESC;
END $$
DELIMITER ;

-- Procedimiento para obtener todas las rutas
DELIMITER $$
CREATE PROCEDURE rutasObtenerTodas()
BEGIN
    SELECT 
        r.*, 
        z.nombre_zona, 
        u.nombre as nombre_repartidor,
        v.placa, 
        er.nombre_estado
    FROM rutas r
    JOIN zonas z ON r.id_zona = z.id_zona
    LEFT JOIN usuarios u ON r.id_repartidor = u.id_usuario
    LEFT JOIN vehiculos v ON r.id_vehiculo = v.id_vehiculo
    JOIN estados_ruta er ON r.id_estado_ruta = er.id_estado_ruta
    ORDER BY r.fecha_ruta DESC, r.id_ruta DESC;
END $$
DELIMITER ;

-- Procedimiento para obtener una ruta específica por ID con sus paradas
DELIMITER $$
CREATE PROCEDURE rutaObtenerPorId(
    IN p_id_ruta INT
)
BEGIN
    -- Obtener información básica de la ruta
    SELECT 
        r.*, 
        z.nombre_zona, 
        u.nombre as nombre_repartidor,
        v.placa, 
        er.nombre_estado
    FROM rutas r
    JOIN zonas z ON r.id_zona = z.id_zona
    LEFT JOIN usuarios u ON r.id_repartidor = u.id_usuario
    LEFT JOIN vehiculos v ON r.id_vehiculo = v.id_vehiculo
    JOIN estados_ruta er ON r.id_estado_ruta = er.id_estado_ruta
    WHERE r.id_ruta = p_id_ruta;
    
    -- Obtener las paradas de la ruta
    SELECT 
        pr.*, 
        p.id_pedido, 
        c.nombre as nombre_cliente,
        dc.direccion
    FROM paradas_ruta pr
    JOIN pedidos p ON pr.id_pedido = p.id_pedido
    JOIN clientes c ON p.id_cliente = c.id_cliente
    JOIN direcciones_cliente dc ON p.id_direccion_entrega = dc.id_direccion
    WHERE pr.id_ruta = p_id_ruta
    ORDER BY pr.orden_secuencia;
END $$
DELIMITER ;

-- Procedimientos para reemplazar las vistas del dashboard
DELIMITER $$

CREATE PROCEDURE dashboardPedidosPorEstado()
BEGIN
    SELECT * FROM vPedidosPorEstado;
END $$

CREATE PROCEDURE dashboardEntregasHoy()
BEGIN
    SELECT * FROM vEntregasHoy;
END $$

CREATE PROCEDURE dashboardIncidenciasActivas()
BEGIN
    SELECT * FROM vIncidenciasActivas;
END $$

CREATE PROCEDURE dashboardEntregasPorZona()
BEGIN
    SELECT * FROM vEntregasPorZona;
END $$

CREATE PROCEDURE dashboardTiempoPromedioEntrega()
BEGIN
    SELECT * FROM vTiempoPromedioEntrega;
END $$

DELIMITER ;

-- Solo estos 3 procedimientos faltan para completar todas las vistas
DELIMITER $$

CREATE PROCEDURE vistaOtpPorRutaMes()
BEGIN
    SELECT * FROM vOtpPorRutaMes;
END $$

CREATE PROCEDURE vistaCostosPorKM()
BEGIN
    SELECT * FROM vCostosPorKM;
END $$

CREATE PROCEDURE vistaProductividadRepartidores()
BEGIN
    SELECT * FROM vProductividadRepartidor;
END $$

DELIMITER ;

-- Procedimiento para obtener clientes con paginación y filtros
DELIMITER $$
CREATE PROCEDURE clientesListar(
    IN p_estado VARCHAR(50),
    IN p_busqueda VARCHAR(200),
    IN p_offset INT,
    IN p_limite INT
)
BEGIN
    DECLARE v_offset INT DEFAULT 0;
    DECLARE v_limite INT DEFAULT 10;
    DECLARE v_total INT DEFAULT 0;
    DECLARE v_total_paginas INT DEFAULT 1;

    IF p_offset IS NOT NULL AND p_offset >= 0 THEN
        SET v_offset = p_offset;
    END IF;

    IF p_limite IS NOT NULL AND p_limite > 0 THEN
        SET v_limite = LEAST(p_limite, 50);
    END IF;

    -- Contar total de registros
    SELECT COUNT(*)
    INTO v_total
    FROM clientes c
    WHERE (p_estado IS NULL OR p_estado = '' OR 
           (p_estado = 'activo' AND c.id_estado_cliente = 1) OR
           (p_estado = 'inactivo' AND c.id_estado_cliente = 2) OR
           (p_estado = 'bloqueado' AND c.id_estado_cliente = 3))
      AND (p_busqueda IS NULL OR p_busqueda = '' OR 
           c.nombre LIKE CONCAT('%', p_busqueda, '%') OR
           c.email LIKE CONCAT('%', p_busqueda, '%') OR
           c.telefono LIKE CONCAT('%', p_busqueda, '%'));

    -- Calcular total de páginas
    IF v_total = 0 THEN
        SET v_total_paginas = 1;
    ELSE
        SET v_total_paginas = CEILING(v_total / v_limite);
    END IF;

    -- Obtener clientes ORDENADOS POR FECHA DESC (más recientes primero)
    SELECT 
        c.id_cliente,
        c.nombre,
        c.telefono,
        c.email,
        c.id_estado_cliente,
        ec.nombre_estado AS estado_nombre,
        c.fecha_creacion,
        c.fecha_actualizacion,
        dc.direccion,
        z.nombre_zona
    FROM clientes c
    JOIN estados_cliente ec ON c.id_estado_cliente = ec.id_estado_cliente
    LEFT JOIN direcciones_cliente dc ON c.id_cliente = dc.id_cliente AND dc.es_principal = 1
    LEFT JOIN zonas z ON dc.id_zona = z.id_zona
    WHERE (p_estado IS NULL OR p_estado = '' OR 
           (p_estado = 'activo' AND c.id_estado_cliente = 1) OR
           (p_estado = 'inactivo' AND c.id_estado_cliente = 2) OR
           (p_estado = 'bloqueado' AND c.id_estado_cliente = 3))
      AND (p_busqueda IS NULL OR p_busqueda = '' OR 
           c.nombre LIKE CONCAT('%', p_busqueda, '%') OR
           c.email LIKE CONCAT('%', p_busqueda, '%') OR
           c.telefono LIKE CONCAT('%', p_busqueda, '%'))
    -- ORDENAR POR FECHA: más recientes primero
    ORDER BY c.fecha_creacion DESC, c.id_cliente DESC
    LIMIT v_limite OFFSET v_offset;

    -- Retornar información de paginación
    SELECT 
        v_total AS total_registros,
        v_total_paginas AS total_paginas,
        v_limite AS limite,
        v_offset AS offset_actual;
END $$
DELIMITER ;

-- Procedimiento para estadísticas de clientes
DELIMITER $$
CREATE PROCEDURE clientesResumenEstados()
BEGIN
    SELECT 
        COUNT(*) AS total,
        SUM(CASE WHEN id_estado_cliente = 1 THEN 1 ELSE 0 END) AS activos,
        SUM(CASE WHEN id_estado_cliente = 2 THEN 1 ELSE 0 END) AS inactivos,
        SUM(CASE WHEN id_estado_cliente = 3 THEN 1 ELSE 0 END) AS bloqueados
    FROM clientes;
END $$
DELIMITER ;

-- Procedimiento para obtener zonas activas
DELIMITER $$
CREATE PROCEDURE zonasActivasListar()
BEGIN
    SELECT 
        id_zona,
        nombre_zona,
        descripcion
    FROM zonas
    WHERE id_estado_zona = 1
    ORDER BY nombre_zona;
END $$
DELIMITER ;

-- Procedimiento para obtener todas las empresas
DELIMITER $$
CREATE PROCEDURE obtenerEmpresas()
BEGIN
    SELECT 
        e.*,
        es.nombre_estado
    FROM empresas e
    LEFT JOIN estados_empresa es ON e.id_estado_empresa = es.id_estado_empresa
    ORDER BY e.nombre;
END $$
DELIMITER ;

-- Procedimiento para obtener empresa por ID
DELIMITER $$
CREATE PROCEDURE obtenerEmpresaPorId(IN p_id_empresa INT)
BEGIN
    SELECT 
        e.*,
        es.nombre_estado
    FROM empresas e
    LEFT JOIN estados_empresa es ON e.id_estado_empresa = es.id_estado_empresa
    WHERE e.id_empresa = p_id_empresa;
END $$
DELIMITER ;

-- Procedimiento para eliminar empresa (CORREGIDO)
DELIMITER $$
CREATE PROCEDURE eliminarEmpresa(IN p_id_empresa INT)
BEGIN
    DECLARE v_rows_affected INT DEFAULT 0;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Verificar si la empresa existe
    SELECT COUNT(*) INTO v_rows_affected 
    FROM empresas 
    WHERE id_empresa = p_id_empresa;
    
    IF v_rows_affected > 0 THEN
        -- Eliminar la empresa
        DELETE FROM empresas WHERE id_empresa = p_id_empresa;
        SELECT 1 as success;
    ELSE
        SELECT 0 as success;
    END IF;
    
    COMMIT;
END $$
DELIMITER ;

-- Procedimiento para crear empresa (CORREGIDO)
DELIMITER $$
CREATE PROCEDURE crearEmpresa(
    IN p_nombre VARCHAR(200),
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(150),
    IN p_direccion TEXT,
    IN p_id_estado_empresa INT
)
BEGIN
    DECLARE v_id_empresa INT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    INSERT INTO empresas (
        nombre, telefono, email, direccion, id_estado_empresa
    ) VALUES (
        p_nombre, p_telefono, p_email, p_direccion, p_id_estado_empresa
    );
    
    SET v_id_empresa = LAST_INSERT_ID();
    
    SELECT v_id_empresa as id_empresa, 1 as success;
    
    COMMIT;
END $$
DELIMITER ;

-- Procedimiento para actualizar empresa (CORREGIDO)
DELIMITER $$
CREATE PROCEDURE actualizarEmpresa(
    IN p_id_empresa INT,
    IN p_nombre VARCHAR(200),
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(150),
    IN p_direccion TEXT,
    IN p_id_estado_empresa INT
)
BEGIN
    DECLARE v_rows_affected INT DEFAULT 0;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    UPDATE empresas 
    SET 
        nombre = p_nombre,
        telefono = p_telefono,
        email = p_email,
        direccion = p_direccion,
        id_estado_empresa = p_id_estado_empresa,
        fecha_actualizacion = CURRENT_TIMESTAMP
    WHERE id_empresa = p_id_empresa;
    
    SET v_rows_affected = ROW_COUNT();
    
    IF v_rows_affected > 0 THEN
        SELECT 1 as success;
    ELSE
        SELECT 0 as success;
    END IF;
    
    COMMIT;
END $$
DELIMITER ;

-- Procedimiento para obtener estadísticas de empresas
DELIMITER $$
CREATE PROCEDURE obtenerEstadisticasEmpresas()
BEGIN
    SELECT 
        COUNT(*) as total_empresas,
        SUM(CASE WHEN id_estado_empresa = 1 THEN 1 ELSE 0 END) as empresas_activas,
        SUM(CASE WHEN id_estado_empresa = 2 THEN 1 ELSE 0 END) as empresas_inactivas,
        SUM(CASE WHEN id_estado_empresa = 3 THEN 1 ELSE 0 END) as empresas_suspendidas
    FROM empresas;
END $$
DELIMITER ;

-- Procedimiento para obtener pedidos por empresa
DELIMITER $$
CREATE PROCEDURE obtenerPedidosPorEmpresa(IN p_id_empresa INT)
BEGIN
    SELECT 
        p.id_pedido,
        p.fecha_pedido,
        p.total_pedido,
        ep.nombre_estado,
        p.fecha_estimada_entrega,
        c.nombre as nombre_cliente
    FROM pedidos p
    INNER JOIN estados_pedido ep ON p.id_estado_pedido = ep.id_estado_pedido
    INNER JOIN clientes c ON p.id_cliente = c.id_cliente
    WHERE p.id_empresa = p_id_empresa
    ORDER BY p.fecha_pedido DESC;
END $$
DELIMITER ;

-- Procedimiento para obtener empresas para dropdown
DELIMITER $$
CREATE PROCEDURE empresasParaPedidos()
BEGIN
    SELECT 
        id_empresa,
        nombre
    FROM empresas
    WHERE id_estado_empresa = 1
    ORDER BY nombre;
END $$
DELIMITER ;

-- Procedimiento para actualizar pedido
DELIMITER $$
CREATE PROCEDURE pedidoActualizar(
    IN p_id_pedido INT,
    IN p_id_estado_pedido INT,
    IN p_motivo_cancelacion TEXT,
    IN p_penalizacion_cancelacion DECIMAL(10,2)
)
BEGIN
    DECLARE v_rows_affected INT DEFAULT 0;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    UPDATE pedidos 
    SET 
        id_estado_pedido = p_id_estado_pedido,
        motivo_cancelacion = p_motivo_cancelacion,
        penalizacion_cancelacion = p_penalizacion_cancelacion,
        fecha_actualizacion = CURRENT_TIMESTAMP
    WHERE id_pedido = p_id_pedido;
    
    SET v_rows_affected = ROW_COUNT();
    
    IF v_rows_affected > 0 THEN
        SELECT 1 as success;
    ELSE
        SELECT 0 as success;
    END IF;
    
    COMMIT;
END $$
DELIMITER ;

-- Procedimiento para eliminar pedido (solo si está pendiente)
DELIMITER $$
CREATE PROCEDURE pedidoEliminar(
    IN p_id_pedido INT
)
BEGIN
    DECLARE v_estado_actual INT;
    DECLARE v_rows_affected INT DEFAULT 0;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Obtener estado actual del pedido
    SELECT id_estado_pedido INTO v_estado_actual
    FROM pedidos 
    WHERE id_pedido = p_id_pedido;
    
    -- Solo permitir eliminar pedidos en estado pendiente (1)
    IF v_estado_actual = 1 THEN
        -- Eliminar detalles del pedido primero
        DELETE FROM detalle_pedido WHERE id_pedido = p_id_pedido;
        
        -- Eliminar el pedido
        DELETE FROM pedidos WHERE id_pedido = p_id_pedido;
        
        SET v_rows_affected = ROW_COUNT();
    END IF;
    
    IF v_rows_affected > 0 THEN
        SELECT 1 as success;
    ELSE
        SELECT 0 as success;
    END IF;
    
    COMMIT;
DELIMITER $$
CREATE PROCEDURE obtenerNombreUsuario(
    IN p_id_usuario INT
)
BEGIN
    DECLARE v_nombre VARCHAR(100);
    
    SELECT nombre INTO v_nombre
    FROM usuarios 
    WHERE id_usuario = p_id_usuario;
    
    -- Si no encuentra el usuario, usar valor por defecto
    IF v_nombre IS NULL THEN
        SET v_nombre = 'admin';
    END IF;
    
    SELECT v_nombre AS nombre_usuario;
END $$
DELIMITER ;