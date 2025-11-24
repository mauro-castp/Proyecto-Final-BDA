-- =================================================================================
-- Tabla Temporal 1: tmpOtp
-- Propósito: Almacena el conteo de OTPs generados por ruta en el mes actual.
-- =================================================================================
DROP TEMPORARY TABLE IF EXISTS tmpOtp;
CREATE TEMPORARY TABLE tmpOtp AS
SELECT 
    r.id_ruta,
    r.nombre_ruta,
    COUNT(o.id_otp) AS Total_OTP
FROM 
    otp o
JOIN 
    entregas e ON o.id_entrega = e.id_entrega
JOIN 
    rutas r ON e.id_ruta = r.id_ruta
WHERE 
    MONTH(o.fecha_generado) = MONTH(CURDATE()) AND YEAR(o.fecha_generado) = YEAR(CURDATE())
GROUP BY 
    r.id_ruta, r.nombre_ruta;

-- =================================================================================
-- Tabla Temporal 2: tmpCostosKM
-- Propósito: Materializa el análisis de costos por kilómetro para cada vehículo.
-- =================================================================================
DROP TEMPORARY TABLE IF EXISTS tmpCostosKM;
CREATE TEMPORARY TABLE tmpCostosKM AS
SELECT 
    v.id_vehiculo,
    v.placa,
    SUM(co.monto) AS Costo_Total,
    SUM(co.distancia_km) AS Distancia_Total_KM,
    -- Se maneja la división por cero para evitar errores
    CASE 
        WHEN SUM(co.distancia_km) > 0 
        THEN SUM(co.monto) / SUM(co.distancia_km) 
        ELSE 0 
    END AS Costo_Por_KM
FROM 
    costos_operativos co
JOIN 
    vehiculos v ON co.id_vehiculo = v.id_vehiculo
GROUP BY 
    v.id_vehiculo, v.placa;

-- =================================================================================
-- Tabla Temporal 3: tmpProductividad
-- Propósito: Guarda las métricas de productividad de cada repartidor en el mes actual.
-- =================================================================================
DROP TEMPORARY TABLE IF EXISTS tmpProductividad;
CREATE TEMPORARY TABLE tmpProductividad AS
SELECT 
    u.id_usuario,
    u.nombre AS Nombre_Repartidor,
    COUNT(e.id_entrega) AS Total_Entregas_Mes,
    SUM(CASE WHEN ee.nombre_estado = 'entregada' THEN 1 ELSE 0 END) AS Entregas_Completadas,
    SUM(CASE WHEN ee.nombre_estado = 'fallida' THEN 1 ELSE 0 END) AS Entregas_Fallidas,
    -- Cálculo de la tasa de éxito, manejando división por cero
    CASE 
        WHEN COUNT(e.id_entrega) > 0 
        THEN (SUM(CASE WHEN ee.nombre_estado = 'entregada' THEN 1 ELSE 0 END) * 100.0 / COUNT(e.id_entrega))
        ELSE 0 
    END AS Tasa_Exito_Porcentaje
FROM 
    usuarios u
JOIN 
    entregas e ON u.id_usuario = e.id_repartidor
JOIN 
    estados_entrega ee ON e.id_estado_entrega = ee.id_estado_entrega
WHERE 
    u.id_rol = (SELECT id_rol FROM roles WHERE nombre_rol = 'Repartidor')
    AND MONTH(e.fecha_creacion) = MONTH(CURDATE()) AND YEAR(e.fecha_creacion) = YEAR(CURDATE())
GROUP BY 
    u.id_usuario, u.nombre;

-- =================================================================================
-- Tabla Temporal 4: tmpKPIglobal
-- Propósito: Centraliza los Indicadores Clave de Rendimiento (KPIs) más importantes
-- del sistema para el mes actual en una sola fila, ideal para un dashboard ejecutivo.
-- =================================================================================
DROP TEMPORARY TABLE IF EXISTS tmpKPIglobal;
CREATE TEMPORARY TABLE tmpKPIglobal AS
SELECT
    -- KPI 1: Total de pedidos en el mes
    (SELECT COUNT(*) 
     FROM pedidos 
     WHERE MONTH(fecha_creacion) = MONTH(CURDATE()) AND YEAR(fecha_creacion) = YEAR(CURDATE())) AS Total_Pedidos_Mes,

    -- KPI 2: Total de entregas completadas en el mes
    (SELECT COUNT(*) 
     FROM entregas e
     JOIN estados_entrega ee ON e.id_estado_entrega = ee.id_estado_entrega
     WHERE ee.nombre_estado = 'entregada' 
       AND MONTH(e.fecha_creacion) = MONTH(CURDATE()) AND YEAR(e.fecha_creacion) = YEAR(CURDATE())) AS Total_Entregas_Completadas_Mes,

    -- KPI 3: Tasa de éxito global de entrega en el mes (con protección contra división por cero)
    (SELECT 
        CASE 
            WHEN COUNT(e.id_entrega) > 0 
            THEN (SUM(CASE WHEN ee.nombre_estado = 'entregada' THEN 1 ELSE 0 END) * 100.0 / COUNT(e.id_entrega))
            ELSE 0 
        END
     FROM entregas e
     JOIN estados_entrega ee ON e.id_estado_entrega = ee.id_estado_entrega
     WHERE MONTH(e.fecha_creacion) = MONTH(CURDATE()) AND YEAR(e.fecha_creacion) = YEAR(CURDATE())) AS Tasa_Exito_Global_Porcentaje,

    -- KPI 4: Tiempo promedio de entrega (solo sobre entregas completadas)
    (SELECT AVG(e.tiempo_entrega_minutos) 
     FROM entregas e
     JOIN estados_entrega ee ON e.id_estado_entrega = ee.id_estado_entrega
     WHERE ee.nombre_estado = 'entregada' AND e.tiempo_entrega_minutos > 0) AS Tiempo_Promedio_Entrega_Minutos,

    -- KPI 5: Costo operativo total del mes
    (SELECT SUM(monto) 
     FROM costos_operativos 
     WHERE MONTH(fecha_costo) = MONTH(CURDATE()) AND YEAR(fecha_costo) = YEAR(CURDATE())) AS Costo_Operativo_Total_Mes,

    -- KPI 6: Número de incidencias actualmente activas
    (SELECT COUNT(*) 
     FROM incidencias i
     JOIN estados_incidencia ei ON i.id_estado_incidencia = ei.id_estado_incidencia
     WHERE ei.nombre_estado IN ('reportada', 'en investigacion')) AS Total_Incidencias_Activas;

-- =================================================================================
-- Tabla Temporal 5: tmpEntregasZona
-- Propósito: Almacena el conteo de entregas por cada zona.
-- =================================================================================
DROP TEMPORARY TABLE IF EXISTS tmpEntregasZona;
CREATE TEMPORARY TABLE tmpEntregasZona AS
SELECT 
    z.id_zona,
    z.nombre_zona,
    COUNT(e.id_entrega) AS Total_Entregas
FROM 
    entregas e
JOIN 
    pedidos p ON e.id_pedido = p.id_pedido
JOIN 
    direcciones_cliente dc ON p.id_direccion_entrega = dc.id_direccion
JOIN 
    zonas z ON dc.id_zona = z.id_zona
GROUP BY 
    z.id_zona, z.nombre_zona
ORDER BY 
    Total_Entregas DESC;
