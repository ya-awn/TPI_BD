-- ============================================
-- 05_explain.sql
-- Planes de ejecución para análisis de performance
-- ============================================
USE tfi_empresa_domicilio;

-- 1) Búsqueda por CUIT (igualdad)
EXPLAIN
SELECT 
    e.*
FROM empresa e
WHERE e.cuit = '00000300001';

-- 2) Consulta de rango por fecha de alta
EXPLAIN
SELECT 
    e.id_empresa,
    e.razon_social,
    e.fecha_alta
FROM empresa e
WHERE e.fecha_alta BETWEEN '2020-06-01' AND '2020-12-31';

-- 3) JOIN empresa–domicilio–localidad–provincia
EXPLAIN
SELECT 
    e.id_empresa,
    e.razon_social,
    d.calle,
    d.numero,
    l.nombre AS localidad,
    pr.nombre AS provincia
FROM empresa e
JOIN domicilio_fiscal d ON e.id_empresa = d.id_empresa
JOIN localidad l ON d.id_localidad = l.id_localidad
JOIN provincia pr ON l.id_provincia = pr.id_provincia
LIMIT 100;
