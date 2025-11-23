DELIMITER //
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
END //
DELIMITER ;
