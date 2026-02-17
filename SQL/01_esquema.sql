-- ============================================
-- 01_esquema.sql
-- Esquema base para TFI Bases de Datos I - Empresa y Domicilio Fiscal
-- ============================================

DROP DATABASE IF EXISTS tfi_empresa_domicilio;
CREATE DATABASE tfi_empresa_domicilio
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE tfi_empresa_domicilio;

-- ============================================
-- TABLAS MAESTRAS / CATÁLOGOS
-- ============================================

DROP TABLE IF EXISTS domicilio_fiscal;
DROP TABLE IF EXISTS empresa;
DROP TABLE IF EXISTS localidad;
DROP TABLE IF EXISTS provincia;
DROP TABLE IF EXISTS pais;
DROP TABLE IF EXISTS tipo_domicilio;

CREATE TABLE pais (
    id_pais INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    codigo_iso CHAR(2) NOT NULL,
    CONSTRAINT uq_pais_codigo_iso UNIQUE (codigo_iso),
    CONSTRAINT chk_pais_codigo_iso CHECK (codigo_iso REGEXP '^[A-Z]{2}$')
);

CREATE TABLE provincia (
    id_provincia INT AUTO_INCREMENT PRIMARY KEY,
    id_pais INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    codigo VARCHAR(10) NOT NULL,
    CONSTRAINT fk_provincia_pais FOREIGN KEY (id_pais)
        REFERENCES pais(id_pais),
    CONSTRAINT uq_provincia_codigo UNIQUE (codigo)
);

CREATE TABLE localidad (
    id_localidad INT AUTO_INCREMENT PRIMARY KEY,
    id_provincia INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    codigo_postal VARCHAR(10) NOT NULL,
    CONSTRAINT fk_localidad_provincia FOREIGN KEY (id_provincia)
        REFERENCES provincia(id_provincia),
    CONSTRAINT chk_localidad_cp CHECK (CHAR_LENGTH(codigo_postal) BETWEEN 4 AND 10)
);

CREATE TABLE tipo_domicilio (
    id_tipo_domicilio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    CONSTRAINT uq_tipo_domicilio_nombre UNIQUE (nombre)
);

-- ============================================
-- TABLAS PRINCIPALES DEL DOMINIO
-- ============================================

CREATE TABLE empresa (
    id_empresa INT AUTO_INCREMENT PRIMARY KEY,
    razon_social VARCHAR(150) NOT NULL,
    cuit CHAR(11) NOT NULL,
    email VARCHAR(150) NULL,
    telefono VARCHAR(30) NULL,
    fecha_alta DATE NOT NULL,
    estado ENUM('ACTIVA', 'INACTIVA') NOT NULL DEFAULT 'ACTIVA',
    CONSTRAINT uq_empresa_cuit UNIQUE (cuit),
    CONSTRAINT chk_empresa_cuit CHECK (cuit REGEXP '^[0-9]{11}$')
);

CREATE TABLE domicilio_fiscal (
    id_domicilio INT AUTO_INCREMENT PRIMARY KEY,
    id_empresa INT NOT NULL,
    id_localidad INT NOT NULL,
    id_tipo_domicilio INT NOT NULL,
    calle VARCHAR(150) NOT NULL,
    numero INT NOT NULL,
    piso VARCHAR(10) NULL,
    depto VARCHAR(10) NULL,
    codigo_postal VARCHAR(10) NOT NULL,
    es_principal BOOLEAN NOT NULL DEFAULT FALSE,
    fecha_desde DATE NOT NULL,
    fecha_hasta DATE NULL,
    CONSTRAINT fk_domicilio_empresa FOREIGN KEY (id_empresa)
        REFERENCES empresa(id_empresa),
    CONSTRAINT fk_domicilio_localidad FOREIGN KEY (id_localidad)
        REFERENCES localidad(id_localidad),
    CONSTRAINT fk_domicilio_tipo FOREIGN KEY (id_tipo_domicilio)
        REFERENCES tipo_domicilio(id_tipo_domicilio),
    CONSTRAINT chk_domicilio_numero CHECK (numero > 0),
    CONSTRAINT chk_domicilio_cp CHECK (CHAR_LENGTH(codigo_postal) BETWEEN 4 AND 10),
    CONSTRAINT chk_domicilio_fechas CHECK (fecha_hasta IS NULL OR fecha_hasta >= fecha_desde)
);

-- ============================================
-- DATOS DE PRUEBA (SIN ERRORES)
-- ============================================

INSERT INTO pais (nombre, codigo_iso) VALUES ('Argentina', 'AR');
INSERT INTO provincia (id_pais, nombre, codigo) VALUES (1, 'Buenos Aires', 'BA');
INSERT INTO localidad (id_provincia, nombre, codigo_postal) VALUES (1, 'CABA', '1000');
INSERT INTO tipo_domicilio (nombre) VALUES ('FISCAL'), ('COMERCIAL'), ('LEGAL');

INSERT INTO empresa (razon_social, cuit, email, telefono, fecha_alta, estado)
VALUES ('Empresa Uno SA', '30712345678', 'contacto@empresa1.com', '011-1234-5678', '2023-01-10', 'ACTIVA');

INSERT INTO domicilio_fiscal (
    id_empresa, id_localidad, id_tipo_domicilio,
    calle, numero, piso, depto, codigo_postal,
    es_principal, fecha_desde, fecha_hasta
) VALUES (
    1, 1, 1,
    'Av. Siempre Viva', 742, NULL, NULL, '1000',
    TRUE, '2023-01-10', NULL
);


-- ============================================
--          PRUEBAS DE CONSTRAINTS
-- ============================================

-- 1) Violación de UNIQUE en CUIT
INSERT INTO empresa (razon_social, cuit, email, telefono, fecha_alta, estado)
VALUES ('Empresa Duplicada SA', '30712345678', 'otra@empresa.com', '011-9999-9999', '2023-02-01', 'ACTIVA');

-- 2) Violación de FK: domicilio con empresa inexistente
INSERT INTO domicilio_fiscal (id_empresa, id_localidad, id_tipo_domicilio, calle, numero, piso, depto, codigo_postal, es_principal, fecha_desde)
VALUES (9999, 1, 1, 'Calle Falsa', 123, NULL, NULL, '1000', TRUE, '2023-03-01');

-- 3) Violación de CHECK: código postal muy corto
INSERT INTO localidad (id_provincia, nombre, codigo_postal)
VALUES (1, 'Localidad Invalida', '10');

-- 4) Violación de CHECK: número de puerta no positivo
INSERT INTO domicilio_fiscal (id_empresa, id_localidad, id_tipo_domicilio, calle, numero, piso, depto, codigo_postal, es_principal, fecha_desde)
VALUES (1, 1, 1, 'Calle Error', 0, NULL, NULL, '1000', FALSE, '2023-04-01');

