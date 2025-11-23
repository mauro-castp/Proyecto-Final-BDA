DELIMITER //
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
END //
DELIMITER ;
