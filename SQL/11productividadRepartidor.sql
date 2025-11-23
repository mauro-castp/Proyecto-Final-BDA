DELIMITER //
CREATE PROCEDURE productividadRepartidor(
    IN p_desde DATE,
    IN p_hasta DATE
)
BEGIN
    CREATE TEMPORARY TABLE tmpProductividad (
        id_repartidor INT,
        nombre VARCHAR(200),
        entregas_realizadas INT
    );

    INSERT INTO tmpProductividad(id_repartidor, nombre, entregas_realizadas)
    SELECT
        u.id_usuario AS id_repartidor,
        u.nombre,
        COUNT(e.id_entrega) AS entregas_realizadas
    FROM entregas e
    JOIN usuarios u ON u.id_usuario = e.id_repartidor
    WHERE e.id_estado_entrega = 3
      AND DATE(e.fecha_entrega_real) BETWEEN p_desde AND p_hasta
    GROUP BY u.id_usuario, u.nombre
    ORDER BY entregas_realizadas DESC;

    SELECT * FROM tmpProductividad;
END //
DELIMITER ;
