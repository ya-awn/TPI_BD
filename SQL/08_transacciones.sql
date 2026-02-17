-- ============================================
-- 08_transacciones.sql
-- Procedimiento almacenado con manejo de transacciones
-- ============================================
USE tfi_empresa_domicilio;

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_actualizar_domicilio_principal $$
CREATE PROCEDURE sp_actualizar_domicilio_principal (
    IN p_id_empresa INT,
    IN p_id_localidad INT,
    IN p_id_tipo_domicilio INT,
    IN p_calle VARCHAR(150),
    IN p_numero INT,
    IN p_piso VARCHAR(10),
    IN p_depto VARCHAR(10),
    IN p_codigo_postal VARCHAR(10),
    IN p_fecha_desde DATE
)
BEGIN
    DECLARE exit handler FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Desmarcar otros domicilios principales vigentes de la empresa
    UPDATE domicilio_fiscal
    SET es_principal = 0
    WHERE id_empresa = p_id_empresa
      AND es_principal = 1
      AND (fecha_hasta IS NULL OR fecha_hasta >= p_fecha_desde);

    -- Insertar nuevo domicilio principal
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
    ) VALUES (
        p_id_empresa,
        p_id_localidad,
        p_id_tipo_domicilio,
        p_calle,
        p_numero,
        p_piso,
        p_depto,
        p_codigo_postal,
        1,
        p_fecha_desde,
        NULL
    );

    COMMIT;
END $$

DELIMITER ;

/*
-- Ejemplo de uso:
CALL sp_actualizar_domicilio_principal(
    1,          -- p_id_empresa
    1,          -- p_id_localidad
    1,          -- p_id_tipo_domicilio
    'Av. Principal',
    123,
    NULL,
    NULL,
    '1000',
    '2024-01-01'
);
*/
