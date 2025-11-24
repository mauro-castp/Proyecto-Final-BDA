-- clienteCrearActualizar

DELIMITER $$
CREATE PROCEDURE clienteCrearActualizar(
    IN p_id_cliente INT,
    IN p_nombre VARCHAR(200),
    IN p_telefono VARCHAR(20),
    IN p_email VARCHAR(150),
    IN p_direccion TEXT,
    IN p_id_zona INT
)
BEGIN
    SET p_direccion = TRIM(LOWER(p_direccion));

    IF p_id_cliente IS NULL THEN
        INSERT INTO clientes(nombre, telefono, email, id_estado)
        VALUES(p_nombre, p_telefono, p_email, 1);
        
        SET p_id_cliente = LAST_INSERT_ID();

        INSERT INTO direcciones_cliente(id_cliente, direccion, id_zona, id_estado)
        VALUES(p_id_cliente, p_direccion, p_id_zona, 1);
    ELSE
        UPDATE clientes
        SET nombre = p_nombre,
            telefono = p_telefono,
            email = p_email
        WHERE id_cliente = p_id_cliente;

        UPDATE direcciones_cliente
        SET direccion = p_direccion,
            id_zona = p_id_zona
        WHERE id_cliente = p_id_cliente;
    END IF;

    SELECT p_id_cliente AS id_cliente;
END $$
DELIMITER ;

-- pedidoCrear

DELIMITER $$
CREATE PROCEDURE pedidoCrear(
    IN p_id_cliente INT,
    IN p_id_direccion INT,
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

    INSERT INTO pedidos(id_cliente, id_direccion_entrega, id_estado_pedido,
                        total_pedido, peso_total, volumen_total)
    VALUES(p_id_cliente, p_id_direccion, 1, 0, 0, 0);

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

DELIMITER $$
CREATE PROCEDURE inicioSesion(
    IN p_email VARCHAR(150),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    SELECT 
        id_usuario,
        nombre,
        email,
        id_rol
    FROM usuarios
    WHERE email = p_email
      AND password_hash = p_password_hash
      AND id_estado = 1;
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