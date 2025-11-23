DELIMITER //
CREATE PROCEDURE auditoriaEntrega(
    IN p_desde DATETIME,
    IN p_hasta DATETIME
)
BEGIN
    SELECT 
        id_log,
        id_entrega,
        accion,
        valores_anteriores,
        valores_nuevos,
        usuario,
        fecha
    FROM aud_entregas
    WHERE fecha BETWEEN p_desde AND p_hasta
    ORDER BY fecha DESC;
END //
DELIMITER ;
