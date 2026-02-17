-- ============================================
-- 02_catalogos.sql
-- Catálogos y datos maestros adicionales
-- ============================================
USE tfi_empresa_domicilio;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE domicilio_fiscal;
TRUNCATE TABLE empresa;
TRUNCATE TABLE localidad;
TRUNCATE TABLE provincia;
TRUNCATE TABLE pais;
TRUNCATE TABLE tipo_domicilio;
SET FOREIGN_KEY_CHECKS = 1;

-- Países
INSERT INTO pais (nombre, codigo_iso) VALUES
('Argentina', 'AR'),
('Brasil', 'BR');

-- Provincias (solo Argentina para simplificar)
INSERT INTO provincia (id_pais, nombre, codigo) VALUES
(1, 'Buenos Aires', 'BA'),
(1, 'Córdoba', 'CB'),
(1, 'Santa Fe', 'SF');

-- Localidades
INSERT INTO localidad (id_provincia, nombre, codigo_postal) VALUES
(1, 'CABA', '1000'),
(1, 'La Plata', '1900'),
(2, 'Córdoba Capital', '5000'),
(2, 'Villa Carlos Paz', '5152'),
(3, 'Rosario', '2000'),
(3, 'Santa Fe Capital', '3000');

-- Tipos de domicilio
INSERT INTO tipo_domicilio (nombre) VALUES
('FISCAL'),
('COMERCIAL'),
('LEGAL');
