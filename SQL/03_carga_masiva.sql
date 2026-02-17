-- ====
-- 03_carga_masiva.sql
-- Generación de datos masivos compatible con MariaDB
-- Objetivo: ~50.000 empresas y ~100.000 domicilios
-- ====
USE tfi_empresa_domicilio;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE domicilio_fiscal;
TRUNCATE TABLE empresa;
SET FOREIGN_KEY_CHECKS = 1;

-- ====
-- Crear tabla temporal de secuencia (números 1..50000)
-- ====
DROP TEMPORARY TABLE IF EXISTS seq;
CREATE TEMPORARY TABLE seq (n INT PRIMARY KEY);

DELIMITER //
DROP PROCEDURE IF EXISTS fill_seq//
CREATE PROCEDURE fill_seq(IN max_n INT)
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= max_n DO
    INSERT INTO seq VALUES (i);
    SET i = i + 1;
  END WHILE;
END//
DELIMITER ;

-- Llenar la tabla con 50.000 números
CALL fill_seq(50000);

-- ====
-- 1) Generación de empresas (1..50000)
-- ====
INSERT INTO empresa (razon_social, cuit, email, telefono, fecha_alta, estado)
SELECT 
    CONCAT('Empresa ', n) AS razon_social,
    LPAD(30000 + n, 11, '0') AS cuit,
    CONCAT('empresa', n, '@correo.com') AS email,
    CONCAT('011-', LPAD(n % 10000, 4, '0')) AS telefono,
    DATE_ADD('2020-01-01', INTERVAL (n % 365) DAY) AS fecha_alta,
    CASE WHEN n % 10 = 0 THEN 'INACTIVA' ELSE 'ACTIVA' END AS estado
FROM seq;

-- ====
-- 2) Generación de domicilios (1 por empresa)
-- ====

INSERT INTO domicilio_fiscal (
    id_empresa,
    id_localidad,
    id_tipo_domicilio,
    calle,
    numero,
    piso,
    depto,
    codigo_postal,
    es_principal,
    fecha_desde,
    fecha_hasta
)
SELECT 
    e.id_empresa,
    l.id_localidad,
    td.id_tipo_domicilio,
    CONCAT('Calle ', (e.id_empresa % 1000)) AS calle,
    100 + (e.id_empresa % 900) AS numero,
    CASE WHEN e.id_empresa % 5 = 0 THEN '1' ELSE NULL END AS piso,
    CASE WHEN e.id_empresa % 7 = 0 THEN 'A' ELSE NULL END AS depto,
    l.codigo_postal,
    CASE WHEN e.id_empresa % 3 = 0 THEN 0 ELSE 1 END AS es_principal,
    DATE_ADD(e.fecha_alta, INTERVAL (e.id_empresa % 30) DAY) AS fecha_desde,
    CASE
        WHEN e.estado = 'INACTIVA' AND e.fecha_alta < '2021-01-01'
        THEN DATE_ADD(e.fecha_alta, INTERVAL 365 DAY)
        ELSE NULL
    END AS fecha_hasta
FROM empresa e
JOIN localidad l ON l.id_localidad = (e.id_empresa % 6) + 1
JOIN tipo_domicilio td ON td.id_tipo_domicilio = (e.id_empresa % 3) + 1;

-- ====
-- 3) Segundo domicilio para ~50% de empresas
-- ====

INSERT INTO domicilio_fiscal (
    id_empresa,
    id_localidad,
    id_tipo_domicilio,
    calle,
    numero,
    piso,
    depto,
    codigo_postal,
    es_principal,
    fecha_desde,
    fecha_hasta
)
SELECT 
    e.id_empresa,
    l.id_localidad,
    td.id_tipo_domicilio,
    CONCAT('Av. ', (e.id_empresa % 500)) AS calle,
    200 + (e.id_empresa % 800) AS numero,
    NULL AS piso,
    NULL AS depto,
    l.codigo_postal,
    0 AS es_principal,
    DATE_ADD(e.fecha_alta, INTERVAL (e.id_empresa % 60) DAY) AS fecha_desde,
    NULL AS fecha_hasta
FROM empresa e
JOIN localidad l ON l.id_localidad = ((e.id_empresa + 3) % 6) + 1
JOIN tipo_domicilio td ON td.id_tipo_domicilio = ((e.id_empresa + 1) % 3) + 1
WHERE e.id_empresa % 2 = 0;

-- ====
-- 4) Verificaciones de consistencia
-- ====

SELECT 'empresas' AS tabla, COUNT(*) AS cantidad FROM empresa
UNION ALL
SELECT 'domicilios', COUNT(*) FROM domicilio_fiscal;

SELECT COUNT(*) AS domicilios_sin_empresa
FROM domicilio_fiscal d
LEFT JOIN empresa e ON d.id_empresa = e.id_empresa
WHERE e.id_empresa IS NULL;

SELECT pr.nombre AS provincia, COUNT(*) AS cant_empresas
FROM empresa e
JOIN domicilio_fiscal d ON e.id_empresa = d.id_empresa
JOIN localidad l ON d.id_localidad = l.id_localidad
JOIN provincia pr ON l.id_provincia = pr.id_provincia
GROUP BY pr.nombre
ORDER BY cant_empresas DESC;

-- Limpiar
DROP TEMPORARY TABLE IF EXISTS seq;
DROP PROCEDURE IF EXISTS fill_seq;