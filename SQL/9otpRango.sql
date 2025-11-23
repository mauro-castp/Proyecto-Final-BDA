DELIMITER //
CREATE PROCEDURE otpRango(
    IN p_desde DATE,
    IN p_hasta DATE
)
BEGIN
    CREATE TEMPORARY TABLE tmpOtp (
        id_ruta INT,
        total_otps INT,
        otps_usados INT,
        otps_no_usados INT
    );

    INSERT INTO tmpOtp(id_ruta, total_otps, otps_usados, otps_no_usados)
    SELECT
        e.id_ruta,
        COUNT(o.id_otp) AS total_otps,
        SUM(CASE WHEN o.verificado = 1 THEN 1 ELSE 0 END) AS otps_usados,
        SUM(CASE WHEN o.verificado = 0 THEN 1 ELSE 0 END) AS otps_no_usados
    FROM entregas e
    JOIN otp o ON o.id_entrega = e.id_entrega
    WHERE DATE(o.fecha_generado) BETWEEN p_desde AND p_hasta
    GROUP BY e.id_ruta;

    SELECT * FROM tmpOtp;
END //
DELIMITER ;
