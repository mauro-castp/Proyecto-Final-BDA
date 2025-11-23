DELIMITER //
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
END //
DELIMITER ;
