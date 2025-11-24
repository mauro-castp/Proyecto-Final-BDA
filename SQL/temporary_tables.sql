-- =================================================================================
-- Tabla Temporal 1: tmpOtp
-- =================================================================================
DROP TEMPORARY TABLE IF EXISTS tmpOtp;
CREATE TEMPORARY TABLE tmpOtp (
        id_ruta INT,
        total_otps INT,
        otps_usados INT,
        otps_no_usados INT
    );

-- =================================================================================
-- Tabla Temporal 2: tmpCostosKM
-- =================================================================================
DROP TEMPORARY TABLE IF EXISTS tmpCostosKM;
CREATE TEMPORARY TABLE tmpCostosKM (
        id_zona INT,
        id_vehiculo INT,
        km_total DECIMAL(10,2),
        costo_total DECIMAL(10,2),
        costo_por_km DECIMAL(10,2)
    );

-- =================================================================================
-- Tabla Temporal 3: tmpProductividad
-- =================================================================================
DROP TEMPORARY TABLE IF EXISTS tmpProductividad;
CREATE TEMPORARY TABLE tmpProductividad (
        id_repartidor INT,
        nombre VARCHAR(200),
        entregas_realizadas INT
    );

-- =================================================================================
-- Tabla Temporal 4: tmpKPIglobal
-- =================================================================================
DROP TEMPORARY TABLE IF EXISTS tmpKPIglobal;
CREATE TEMPORARY TABLE tmpKPIglobal (
        kpi VARCHAR(100),
        valor DECIMAL(15,2)
    );

-- =================================================================================
-- Tabla Temporal 5: tmpEntregasZona
-- =================================================================================
DROP TEMPORARY TABLE IF EXISTS tmpEntregasZona;
CREATE TEMPORARY TABLE tmpEntregasZona (
        id_zona INT,
        nombre_zona VARCHAR(100),
        entregas_completadas INT,
        entregas_fallidas INT,
        tasa_exito DECIMAL(5,2),
        tiempo_promedio_min INT
    );