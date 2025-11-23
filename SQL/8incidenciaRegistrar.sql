DELIMITER //
CREATE PROCEDURE incidenciaRegistrar(
    IN p_id_zona INT,
    IN p_id_tipo_incidencia INT,
    IN p_desde DATETIME,
    IN p_hasta DATETIME
)
BEGIN
    INSERT INTO incidencias(
        id_zona,
        id_tipo_incidencia,
        fecha_inicio,
        fecha_fin,
        id_estado_incidencia
    )
    VALUES(
        p_id_zona,
        p_id_tipo_incidencia,
        p_desde,
        p_hasta,
        1
    );

    SELECT LAST_INSERT_ID() AS id_incidencia;
END //
DELIMITER ;
