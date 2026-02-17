-- ============================================
-- 07_seguridad.sql
-- Seguridad, usuarios y privilegios
-- ============================================
USE tfi_empresa_domicilio;

-- Usuario de aplicación con privilegios mínimos
DROP USER IF EXISTS 'app_user'@'localhost';
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'AppUser123!';

-- Otorgar privilegios mínimos sobre vistas
GRANT SELECT ON tfi_empresa_domicilio.vw_empresas_con_domicilio_principal TO 'app_user'@'localhost';
GRANT SELECT ON tfi_empresa_domicilio.vw_empresas_por_provincia TO 'app_user'@'localhost';
GRANT SELECT ON tfi_empresa_domicilio.vw_empresas_activas_recientes TO 'app_user'@'localhost';
GRANT SELECT ON tfi_empresa_domicilio.vw_empresas_cuit_enmascarado TO 'app_user'@'localhost';

-- Privilegios sobre tabla domicilio_fiscal
GRANT SELECT, INSERT, UPDATE ON tfi_empresa_domicilio.domicilio_fiscal TO 'app_user'@'localhost';

FLUSH PRIVILEGES;
