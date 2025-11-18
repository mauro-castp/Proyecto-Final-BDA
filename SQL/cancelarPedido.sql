DELIMITER //
CREATE PROCEDURE pedidoCancelar(
    IN p_id_pedido INT,
    IN p_motivo TEXT
)
BEGIN
    DECLARE v_estado INT;
    DECLARE v_total DECIMAL(10,2);
    DECLARE v_penal DECIMAL(10,2) DEFAULT 0;

    SELECT id_estado_pedido, total_pedido INTO v_estado, v_total
    FROM pedidos WHERE id_pedido = p_id_pedido;

    IF v_estado = 1 THEN
        SET v_penal = 0;
    ELSEIF v_estado = 2 THEN
        SET v_penal = v_total * 0.10;
    ELSE
        SELECT 'no_cancelable' AS status;
        LEAVE BEGIN;
    END IF;

    UPDATE pedidos
    SET id_estado_pedido = 5,
        motivo_cancelacion = p_motivo,
        penalizacion_cancelacion = v_penal
    WHERE id_pedido = p_id_pedido;

    SELECT 'ok' AS status, v_penal AS penalizacion;
END //
DELIMITER ;
