-- ============================================
-- 05_consultas.sql
-- Consultas complejas y útiles
-- ============================================
USE tfi_empresa_domicilio;

-- 1) Empresas con domicilio fiscal principal
SELECT 
    e.id_empresa,
    e.razon_social,
    e.cuit,
    d.calle,
    d.numero,
    l.nombre AS localidad,
    pr.nombre AS provincia,
    pa.nombre AS pais
FROM empresa e
JOIN domicilio_fiscal d
    ON e.id_empresa = d.id_empresa
   AND d.es_principal = 1
JOIN localidad l ON d.id_localidad = l.id_localidad
JOIN provincia pr ON l.id_provincia = pr.id_provincia
JOIN pais pa ON pr.id_pais = pa.id_pais
LIMIT 100;

-- 2) Cantidad de empresas por provincia (solo provincias con más de 100 empresas)
SELECT 
    pr.nombre AS provincia,
    COUNT(DISTINCT e.id_empresa) AS cant_empresas
FROM empresa e
JOIN domicilio_fiscal d ON e.id_empresa = d.id_empresa
JOIN localidad l ON d.id_localidad = l.id_localidad
JOIN provincia pr ON l.id_provincia = pr.id_provincia
GROUP BY pr.nombre
HAVING COUNT(DISTINCT e.id_empresa) > 100
ORDER BY cant_empresas DESC;

-- 3) Empresas en provincias con más de 2000 empresas
SELECT 
    e.id_empresa,
    e.razon_social,
    pr.nombre AS provincia
FROM empresa e
JOIN domicilio_fiscal d ON e.id_empresa = d.id_empresa
JOIN localidad l ON d.id_localidad = l.id_localidad
JOIN provincia pr ON l.id_provincia = pr.id_provincia
WHERE pr.id_provincia IN (
    SELECT pr2.id_provincia
    FROM empresa e2
    JOIN domicilio_fiscal d2 ON e2.id_empresa = d2.id_empresa
    JOIN localidad l2 ON d2.id_localidad = l2.id_localidad
    JOIN provincia pr2 ON l2.id_provincia = pr2.id_provincia
    GROUP BY pr2.id_provincia
    HAVING COUNT(DISTINCT e2.id_empresa) > 2000
)
LIMIT 200;

-- 4) Empresas activas dadas de alta en el último año por provincia
SELECT 
    pr.nombre AS provincia,
    COUNT(DISTINCT e.id_empresa) AS cant_empresas_recientes
FROM empresa e
JOIN domicilio_fiscal d ON e.id_empresa = d.id_empresa
JOIN localidad l ON d.id_localidad = l.id_localidad
JOIN provincia pr ON l.id_provincia = pr.id_provincia
WHERE e.estado = 'ACTIVA'
  AND e.fecha_alta BETWEEN DATE_SUB(CURDATE(), INTERVAL 365 DAY) AND CURDATE()
GROUP BY pr.nombre
ORDER BY cant_empresas_recientes DESC;

-- Vista útil de empresas con domicilio principal
DROP VIEW IF EXISTS vw_empresas_con_domicilio_principal;

CREATE VIEW vw_empresas_con_domicilio_principal AS
SELECT 
    e.id_empresa,
    e.razon_social,
    e.cuit,
    e.email,
    e.telefono,
    e.fecha_alta,
    e.estado,
    d.calle,
    d.numero,
    d.piso,
    d.depto,
    d.codigo_postal,
    l.nombre AS localidad,
    pr.nombre AS provincia,
    pa.nombre AS pais
FROM empresa e
JOIN domicilio_fiscal d
    ON e.id_empresa = d.id_empresa
   AND d.es_principal = 1
JOIN localidad l ON d.id_localidad = l.id_localidad
JOIN provincia pr ON l.id_provincia = pr.id_provincia
JOIN pais pa ON pr.id_pais = pa.id_pais;
