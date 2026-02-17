-- ====
-- 04_indices.sql
-- Creación de índices para mediciones de performance
-- Compatible con MariaDB usando IF NOT EXISTS
-- ====
USE tfi_empresa_domicilio;

-- ====
-- Creación de índices
-- ====

-- 1) Índice para búsquedas rápidas por CUIT
-- Justificación: El CUIT es un campo de búsqueda frecuente y tiene constraint UNIQUE
CREATE INDEX IF NOT EXISTS idx_empresa_cuit 
ON empresa (cuit);

-- 2) Índice para optimizar los JOINs entre empresa y domicilio
-- Justificación: id_empresa es FK y se usa constantemente en consultas relacionales
-- Nota: Si ya existe por ser FK, MariaDB lo ignora sin error
CREATE INDEX IF NOT EXISTS idx_domicilio_id_empresa 
ON domicilio_fiscal (id_empresa);

-- 3) Índice para reportes por localidad
-- Justificación: Consultas de agrupamiento por zona geográfica
CREATE INDEX IF NOT EXISTS idx_domicilio_localidad 
ON domicilio_fiscal (id_localidad);

-- 4) Índice para búsquedas por código postal
-- Justificación: Filtros frecuentes por zona postal en reportes
CREATE INDEX IF NOT EXISTS idx_domicilio_codigo_postal 
ON domicilio_fiscal (codigo_postal);

-- ====
-- Verificación de índices creados
-- ====

SELECT 'Índices en tabla empresa:' AS info;
SHOW INDEX FROM empresa;

SELECT 'Índices en tabla domicilio_fiscal:' AS info;
SHOW INDEX FROM domicilio_fiscal;

-- ====
-- Estadísticas de cardinalidad
-- ====

SELECT 
    table_name,
    index_name,
    column_name,
    cardinality,
    CASE 
        WHEN non_unique = 0 THEN 'UNIQUE'
        ELSE 'NON-UNIQUE'
    END AS tipo_indice
FROM information_schema.statistics
WHERE table_schema = DATABASE()
  AND table_name IN ('empresa', 'domicilio_fiscal')
ORDER BY table_name, index_name, seq_in_index;