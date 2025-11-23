DELIMITER //
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
END //
DELIMITER ;
