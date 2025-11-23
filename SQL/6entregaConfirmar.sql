DELIMITER //
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
END //
DELIMITER ;
