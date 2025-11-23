DELIMITER //
CREATE PROCEDURE kpiGlobalMes(
    IN p_anio INT,
    IN p_mes INT
)
BEGIN
    CREATE TEMPORARY TABLE tmpKPIglobal (
        kpi VARCHAR(100),
        valor DECIMAL(15,2)
    );

    INSERT INTO tmpKPIglobal(kpi, valor)
    SELECT 'total_pedidos', COUNT(*) 
    FROM pedidos
    WHERE YEAR(fecha_creacion) = p_anio AND MONTH(fecha_creacion) = p_mes;

    INSERT INTO tmpKPIglobal(kpi, valor)
    SELECT 'entregas_completadas', COUNT(*)
    FROM entregas
    WHERE id_estado_entrega = 3
      AND YEAR(fecha_entrega_real) = p_anio AND MONTH(fecha_entrega_real) = p_mes;

    INSERT INTO tmpKPIglobal(kpi, valor)
    SELECT 'entregas_fallidas', COUNT(*)
    FROM entregas
    WHERE id_estado_entrega = 4
      AND YEAR(fecha_entrega_real) = p_anio AND MONTH(fecha_entrega_real) = p_mes;

    INSERT INTO tmpKPIglobal(kpi, valor)
    SELECT 'otp_usados', COUNT(*)
    FROM otp
    WHERE verificado = 1
      AND YEAR(fecha_generado) = p_anio AND MONTH(fecha_generado) = p_mes;

    INSERT INTO tmpKPIglobal(kpi, valor)
    SELECT 'reintentos', SUM(reintentos)
    FROM entregas
    WHERE YEAR(fecha_estimada_entrega) = p_anio AND MONTH(fecha_estimada_entrega) = p_mes;

    INSERT INTO tmpKPIglobal(kpi, valor)
    SELECT 'penalizaciones_total', SUM(monto)
    FROM penalizaciones
    WHERE YEAR(fecha) = p_anio AND MONTH(fecha) = p_mes;

    INSERT INTO tmpKPIglobal(kpi, valor)
    SELECT 'costo_total', SUM(costo_total)
    FROM costos_operativos
    WHERE YEAR(fecha_registro) = p_anio AND MONTH(fecha_registro) = p_mes;

    SELECT * FROM tmpKPIglobal;
END //
DELIMITER ;
