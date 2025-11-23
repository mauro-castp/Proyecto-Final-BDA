-- =================================================================================
-- Vista 1: vEntregasHoy
-- Propósito: Muestra todas las entregas planificadas para el día de hoy.
-- Incluye información del cliente, dirección, repartidor y estado actual.
-- =================================================================================
CREATE OR REPLACE VIEW vEntregasHoy AS
SELECT 
    e.id_entrega,
    p.id_pedido,
    c.nombre AS Nombre_Cliente,
    dc.direccion AS Direccion_Entrega,
    u.nombre AS Repartidor,
    ee.nombre_estado AS Estado_Entrega,
    e.fecha_estimada_entrega
FROM 
    entregas e
JOIN 
    pedidos p ON e.id_pedido = p.id_pedido
JOIN 
    clientes c ON p.id_cliente = c.id_cliente
JOIN 
    direcciones_cliente dc ON p.id_direccion_entrega = dc.id_direccion
JOIN 
    usuarios u ON e.id_repartidor = u.id_usuario
JOIN 
    estados_entrega ee ON e.id_estado_entrega = ee.id_estado_entrega
WHERE 
    DATE(e.fecha_estimada_entrega) = CURDATE();


-- =================================================================================
-- Vista 2: vOtpPorRutaMes
-- Propósito: Cuenta la cantidad de códigos OTP generados para cada ruta durante el mes actual.
-- Útil para medir la actividad de verificación por ruta.
-- =================================================================================
CREATE OR REPLACE VIEW vOtpPorRutaMes AS
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
-- Vista 3: vCostosPorKM
-- Propósito: Calcula el costo operativo por kilómetro para cada vehículo.
-- Suma todos los costos y distancias asociados a un vehículo y calcula el ratio.
-- =================================================================================
CREATE OR REPLACE VIEW vCostosPorKM AS
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
    v.id_vehiculo, v.placa
HAVING 
    Distancia_Total_KM > 0; -- Opcional: mostrar solo vehículos con distancia registrada


-- =================================================================================
-- Vista 4: vEntregasPorZona
-- Propósito: Muestra el total de entregas realizadas en cada zona.
-- Ayuda a identificar las zonas con mayor volumen de trabajo.
-- =================================================================================
CREATE OR REPLACE VIEW vEntregasPorZona AS
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


-- =================================================================================
-- Vista 5: vIncidenciasActivas
-- Propósito: Lista todas las incidencias que están actualmente abiertas (reportadas o en investigación).
-- Permite un seguimiento rápido de problemas no resueltos.
-- =================================================================================
CREATE OR REPLACE VIEW vIncidenciasActivas AS
SELECT 
    i.id_incidencia,
    ti.nombre_tipo AS Tipo_Incidencia,
    i.descripcion,
    z.nombre_zona AS Zona_Afectada,
    ni.nombre_nivel AS Impacto,
    ei.nombre_estado AS Estado_Actual,
    i.fecha_inicio
FROM 
    incidencias i
JOIN 
    tipos_incidencia ti ON i.id_tipo_incidencia = ti.id_tipo_incidencia
JOIN 
    zonas z ON i.id_zona = z.id_zona
JOIN 
    niveles_impacto ni ON i.id_nivel_impacto = ni.id_nivel_impacto
JOIN 
    estados_incidencia ei ON i.id_estado_incidencia = ei.id_estado_incidencia
WHERE 
    ei.nombre_estado IN ('reportada', 'en investigacion')
ORDER BY 
    i.fecha_inicio DESC;


-- =================================================================================
-- Vista 6: vTiempoPromedioEntrega
-- Propósito: Calcula el tiempo promedio en minutos que toma realizar una entrega.
-- Se calcula solo sobre entregas que han sido completadas exitosamente.
-- =================================================================================
CREATE OR REPLACE VIEW vTiempoPromedioEntrega AS
SELECT 
    AVG(e.tiempo_entrega_minutos) AS Tiempo_Promedio_Minutos
FROM 
    entregas e
JOIN 
    estados_entrega ee ON e.id_estado_entrega = ee.id_estado_entrega
WHERE 
    ee.nombre_estado = 'entregada' AND e.tiempo_entrega_minutos > 0;


-- =================================================================================
-- Vista 7: vProductividadRepartidor
-- Propósito: Muestra la productividad de cada repartidor en el mes actual.
-- Incluye entregas completadas, fallidas y la tasa de éxito.
-- =================================================================================
CREATE OR REPLACE VIEW vProductividadRepartidor AS
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
    u.id_usuario, u.nombre
ORDER BY 
    Tasa_Exito_Porcentaje DESC;


-- =================================================================================
-- Vista 8: vPedidosPorEstado
-- Propósito: Proporciona un recuento simple de cuántos pedidos existen en cada estado.
-- Ideal para un dashboard de estado general del sistema.
-- =================================================================================
CREATE OR REPLACE VIEW vPedidosPorEstado AS
SELECT 
    ep.id_estado_pedido,
    ep.nombre_estado,
    COUNT(p.id_pedido) AS Total_Pedidos
FROM 
    pedidos p
JOIN 
    estados_pedido ep ON p.id_estado_pedido = ep.id_estado_pedido
GROUP BY 
    ep.id_estado_pedido, ep.nombre_estado
ORDER BY 
    Total_Pedidos DESC;
