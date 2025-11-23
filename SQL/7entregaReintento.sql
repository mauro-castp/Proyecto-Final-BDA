DELIMITER //
CREATE PROCEDURE entregaReintento(
    IN p_id_entrega INT,
    IN p_motivo_fallo INT
)
BEGIN
    DECLARE v_reintentos INT;
    DECLARE v_limite INT DEFAULT 3;

    SELECT reintentos
    INTO v_reintentos
    FROM entregas
    WHERE id_entrega = p_id_entrega;

    IF v_reintentos >= v_limite THEN
        SELECT 'limite_reintentos' AS status;
        LEAVE BEGIN;
    END IF;

    UPDATE entregas
    SET reintentos = reintentos + 1,
        id_motivo_fallo = p_motivo_fallo,
        id_estado_entrega = 4
    WHERE id_entrega = p_id_entrega;

    IF v_reintentos + 1 >= v_limite THEN
        INSERT INTO penalizaciones(id_entrega, id_tipo_penalizacion, monto)
        VALUES(p_id_entrega, 3, 25.00);
    END IF;

    SELECT 'ok' AS status;
END //
DELIMITER ;
