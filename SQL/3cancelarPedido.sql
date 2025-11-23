DELIMITER //
CREATE PROCEDURE pedidoCancelar(
    IN p_id_pedido INT,
    IN p_motivo TEXT
)
BEGIN
    DECLARE v_estado INT;
    DECLARE v_total DECIMAL(10,2);

    SELECT id_estado_pedido, total_pedido
    INTO v_estado, v_total
    FROM pedidos
    WHERE id_pedido = p_id_pedido;

    IF v_estado = 1 THEN
        UPDATE pedidos
        SET id_estado_pedido = 5
        WHERE id_pedido = p_id_pedido;

    ELSEIF v_estado = 2 THEN
        INSERT INTO penalizaciones(id_entrega, id_tipo_penalizacion, monto)
        VALUES(NULL, 1, v_total * 0.10);

        UPDATE pedidos
        SET id_estado_pedido = 5
        WHERE id_pedido = p_id_pedido;
    ELSE
        SELECT 'no_cancelable' AS status;
        LEAVE BEGIN;
    END IF;

    SELECT 'ok' AS status;
END //
DELIMITER ;
