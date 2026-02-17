TFI - Bases de Datos I
Gestión de Empresas y Domicilios Fiscales
Alumno: Kenyi Meza
Comisión: 17
Motor: MariaDB / MySQL 8+
Materia: Bases de Datos I

📌 Descripción
Este trabajo final integrador implementa una base de datos relacional para administrar empresas y sus domicilios fiscales, contemplando:

Catálogos geográficos (país, provincia, localidad)
Tipos de domicilio
Restricciones (PK, FK, UNIQUE, CHECK)
Carga masiva de datos
Consultas complejas y optimización con índices
Vistas
Seguridad (usuarios/roles)
Transacciones
Concurrencia (bloqueos y comportamiento del motor)
🧩 Modelo (DER)
El diagrama entidad-relación fue generado a partir del esquema SQL y documentado en formato gráfico.

Archivo: DER.png
📂 Estructura del repositorio
01_esquema.sql → creación de base de datos + tablas + restricciones
02_catalogos.sql → carga de catálogos (país/provincia/localidad/tipo)
03_carga_masiva.sql → carga masiva (adaptada para MariaDB)
04_indices.sql → índices de optimización (con IF NOT EXISTS en MariaDB)
05_consultas.sql → consultas requeridas (joins, filtros, agregaciones)
05_explain.sql → análisis de plan de ejecución (EXPLAIN)
06_vistas.sql → vistas para simplificar consultas frecuentes
07_seguridad.sql → usuarios, permisos y roles
08_transacciones.sql → ejemplos de COMMIT / ROLLBACK
09_concurrencia_guiada.sql → pruebas guiadas de concurrencia/bloqueos
TFI_Analisis_Completo.md → análisis y justificación técnica
Anexo_IA_Preguntas_y_Respuestas_TFI.docx → anexo de respuestas (uso de IA como apoyo)
LINK_VIDEO.txt → link al video de presentación
▶️ Orden recomendado de ejecución
Idealmente ejecutar en este orden para evitar errores de FK y asegurar consistencia:

01_esquema.sql
02_catalogos.sql
03_carga_masiva.sql
04_indices.sql
06_vistas.sql
05_consultas.sql y 05_explain.sql
07_seguridad.sql
08_transacciones.sql
09_concurrencia_guiada.sql (requiere 2 sesiones/conexiones)
🔁 Concurrencia (importante)
Las pruebas de concurrencia se ejecutan en dos sesiones distintas (dos pestañas/conexiones), para simular accesos simultáneos y observar:

bloqueos (locks)
espera por bloqueo
lock wait timeout (si corresponde)
🛠️ Notas de compatibilidad (MariaDB vs MySQL)
Durante el desarrollo se contemplaron diferencias reales entre motores.
Por ejemplo:

Carga masiva: se evitó depender de CTEs recursivos en INSERT si el motor/versión no lo soporta igual.
Índices: se utilizó CREATE INDEX IF NOT EXISTS, que puede aparecer como “warning” en algunos editores, pero es válido en MariaDB.
🎥 Video de presentación
El link al video está en:

LINK_VIDEO.txt
🤖 Uso de IA (de forma asistida)
Se utilizó IA como apoyo para:

validar estructura del DER y cardinalidades
mejorar redacción/documentación técnica
proponer mejoras de scripts sin reemplazar el criterio del diseño
El trabajo final, decisiones y scripts fueron revisados y adaptados manualmente para el motor utilizado.

✅ Requisitos cubiertos (resumen)
 Modelo relacional con restricciones
 Carga de datos + carga masiva
 Consultas complejas
 Índices + análisis con EXPLAIN
 Vistas
 Seguridad (roles/permisos)
 Transacciones
 Concurrencia
📬 Observaciones
Si se corre en un entorno distinto (otra versión de MySQL/MariaDB), puede requerir ajustes menores por diferencias de sintaxis o configuración del servidor.