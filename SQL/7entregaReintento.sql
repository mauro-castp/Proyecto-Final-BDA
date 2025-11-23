DELIMITER //
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
END //
DELIMITER ;
