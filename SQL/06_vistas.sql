-- ============================================
-- 06_vistas.sql
-- Vistas adicionales para reporting
-- ============================================
USE tfi_empresa_domicilio;

-- Empresas por provincia
DROP VIEW IF EXISTS vw_empresas_por_provincia;

CREATE VIEW vw_empresas_por_provincia AS
SELECT 
    pr.nombre AS provincia,
    COUNT(DISTINCT e.id_empresa) AS cant_empresas
FROM empresa e
JOIN domicilio_fiscal d ON e.id_empresa = d.id_empresa
JOIN localidad l ON d.id_localidad = l.id_localidad
JOIN provincia pr ON l.id_provincia = pr.id_provincia
GROUP BY pr.nombre;

-- Empresas activas recientes
DROP VIEW IF EXISTS vw_empresas_activas_recientes;

CREATE VIEW vw_empresas_activas_recientes AS
SELECT 
    e.id_empresa,
    e.razon_social,
    e.cuit,
    e.fecha_alta,
    pr.nombre AS provincia
FROM empresa e
JOIN domicilio_fiscal d ON e.id_empresa = d.id_empresa
JOIN localidad l ON d.id_localidad = l.id_localidad
JOIN provincia pr ON l.id_provincia = pr.id_provincia
WHERE e.estado = 'ACTIVA'
  AND e.fecha_alta BETWEEN DATE_SUB(CURDATE(), INTERVAL 365 DAY) AND CURDATE();

-- Vista con CUIT enmascarado (para seguridad)
DROP VIEW IF EXISTS vw_empresas_cuit_enmascarado;

CREATE VIEW vw_empresas_cuit_enmascarado AS
SELECT 
    e.id_empresa,
    e.razon_social,
    CONCAT('*******', RIGHT(e.cuit, 4)) AS cuit_enmascarado,
    e.email,
    e.telefono,
    e.fecha_alta,
    e.estado
FROM empresa e;
