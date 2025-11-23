DELIMITER //
CREATE PROCEDURE costosKMRango(
    IN p_desde DATE,
    IN p_hasta DATE
)
BEGIN
    CREATE TEMPORARY TABLE tmpCostosKM (
        id_zona INT,
        id_vehiculo INT,
        km_total DECIMAL(10,2),
        costo_total DECIMAL(10,2),
        costo_por_km DECIMAL(10,2)
    );

    INSERT INTO tmpCostosKM(id_zona, id_vehiculo, km_total, costo_total, costo_por_km)
    SELECT 
        c.id_zona,
        c.id_vehiculo,
        SUM(c.km_recorridos) AS km_total,
        SUM(c.costo_total) AS costo_total,
        SUM(c.costo_total) / NULLIF(SUM(c.km_recorridos),0) AS costo_por_km
    FROM costos_operativos c
    WHERE DATE(c.fecha_registro) BETWEEN p_desde AND p_hasta
    GROUP BY c.id_zona, c.id_vehiculo;

    SELECT * FROM tmpCostosKM;
END //
DELIMITER ;
