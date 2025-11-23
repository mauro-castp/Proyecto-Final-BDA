DELIMITER //
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
END //
DELIMITER ;
