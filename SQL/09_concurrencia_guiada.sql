-- ============================================
-- 09_concurrencia_guiada.sql
-- Guion para pruebas manuales de concurrencia
-- (No genera errores por sí mismo)
-- ============================================
USE tfi_empresa_domicilio;

-- ============================================
-- INSTRUCCIONES:
-- Abrir dos sesiones de MySQL: Sesión A y Sesión B.
-- Copiar y ejecutar los bloques indicados en cada sesión.
-- ============================================

-- ============================================
-- 1) Preparación de datos para pruebas
-- ============================================

-- Crear dos empresas para pruebas de locks
INSERT INTO empresa (razon_social, cuit, email, telefono, fecha_alta, estado)
VALUES ('Empresa Lock A', '40000000001', 'a@lock.com', '011-0001', '2024-01-01', 'ACTIVA')
ON DUPLICATE KEY UPDATE razon_social = VALUES(razon_social);

INSERT INTO empresa (razon_social, cuit, email, telefono, fecha_alta, estado)
VALUES ('Empresa Lock B', '40000000002', 'b@lock.com', '011-0002', '2024-01-01', 'ACTIVA')
ON DUPLICATE KEY UPDATE razon_social = VALUES(razon_social);

-- Crear domicilios para estas empresas si no existen
INSERT INTO domicilio_fiscal (
    id_empresa, id_localidad, id_tipo_domicilio,
    calle, numero, piso, depto, codigo_postal,
    es_principal, fecha_desde, fecha_hasta
)
SELECT e.id_empresa, 1, 1,
       'Calle Lock', 100, NULL, NULL, '1000',
       1, '2024-01-01', NULL
FROM empresa e
LEFT JOIN domicilio_fiscal d ON d.id_empresa = e.id_empresa
WHERE e.cuit IN ('40000000001', '40000000002')
  AND d.id_domicilio IS NULL;

-- ============================================
-- 2) Escenario de posible deadlock
-- ============================================

/*
SESIÓN A:
START TRANSACTION;
SELECT * FROM domicilio_fiscal d
JOIN empresa e ON e.id_empresa = d.id_empresa
WHERE e.cuit = '40000000001'
FOR UPDATE;
-- (no hacer COMMIT todavía)

SESIÓN B:
START TRANSACTION;
SELECT * FROM domicilio_fiscal d
JOIN empresa e ON e.id_empresa = d.id_empresa
WHERE e.cuit = '40000000002'
FOR UPDATE;
-- (no hacer COMMIT todavía)

Luego:
SESIÓN A intenta actualizar domicilio de empresa B
SESIÓN B intenta actualizar domicilio de empresa A
Uno de los dos obtendrá error 1213 (deadlock)
*/

-- ============================================
-- 3) Prueba de niveles de aislamiento
-- ============================================

/*
Ajustar nivel de aislamiento en cada sesión:
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
o
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SESIÓN A:
START TRANSACTION;
SELECT COUNT(*) AS cant_domicilios
FROM domicilio_fiscal
WHERE codigo_postal = '1000';

SESIÓN B (mientras A no hace COMMIT):
INSERT INTO domicilio_fiscal (
    id_empresa, id_localidad, id_tipo_domicilio,
    calle, numero, piso, depto, codigo_postal,
    es_principal, fecha_desde, fecha_hasta
) VALUES (
    (SELECT id_empresa FROM empresa WHERE cuit = '40000000001'),
    1, 1, 'Calle Nueva', 999, NULL, NULL, '1000', 0, CURDATE(), NULL
);
COMMIT;

SESIÓN A (segundo SELECT antes de cerrar):
SELECT COUNT(*) AS cant_domicilios_despues
FROM domicilio_fiscal
WHERE codigo_postal = '1000';

Comparar resultados en READ COMMITTED vs REPEATABLE READ.
*/
