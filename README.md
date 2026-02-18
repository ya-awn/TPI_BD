# TFI — Bases de Datos I

**Tema:** Gestión de Empresas y Domicilios Fiscales  \
**Alumno:** Kenyi Meza (Comisión 17)  \
**Motor:** MariaDB (probado en Linux) / compatible con MySQL 8+

## ¿De qué trata?
Este trabajo implementa una base de datos relacional para registrar **empresas** y sus **domicilios fiscales**, apoyándose en catálogos (país/provincia/localidad y tipo de domicilio). La idea es tener una estructura consistente, con integridad referencial y consultas que representen casos reales.

## Qué incluye
- Modelo relacional con restricciones (`PK`, `FK`, `UNIQUE`, `CHECK`)
- Carga inicial de catálogos y carga masiva de datos de prueba
- Consultas con joins/agregaciones y análisis con `EXPLAIN`
- Índices para mejorar rendimiento
- Vistas para simplificar consultas repetidas
- Seguridad (usuarios/permisos)
- Transacciones (COMMIT/ROLLBACK)
- Concurrencia (bloqueos / lock wait timeout con dos sesiones)

## Archivos principales
- `01_esquema.sql` → creación de DB y tablas + restricciones
- `02_catalogos.sql` → carga de catálogos
- `03_carga_masiva.sql` → carga masiva (adaptada para MariaDB)
- `04_indices.sql` → creación de índices
- `05_consultas.sql` → consultas solicitadas
- `05_explain.sql` → `EXPLAIN` para ver planes de ejecución
- `06_vistas.sql` → vistas
- `07_seguridad.sql` → usuarios/roles/permisos
- `08_transacciones.sql` → ejemplos de transacciones
- `09_concurrencia_guiada.sql` → prueba guiada de concurrencia
- `DER.png` → diagrama ER
- `TFI_Analisis_Completo.md` → explicación/justificación del diseño
- `Anexo_IA_Preguntas_y_Respuestas_TFI.docx` → anexo de respuestas
- `LINK_VIDEO.txt` → link a la presentación

## Orden recomendado de ejecución
1. `01_esquema.sql`
2. `02_catalogos.sql`
3. `03_carga_masiva.sql`
4. `04_indices.sql`
5. `06_vistas.sql`
6. `05_consultas.sql` + `05_explain.sql`
7. `07_seguridad.sql`
8. `08_transacciones.sql`
9. `09_concurrencia_guiada.sql` *(se ejecuta con 2 conexiones/sesiones)*

## Nota sobre concurrencia
La parte de concurrencia está pensada para correrla en **dos sesiones** (dos pestañas o dos clientes). La idea es ver cómo se comporta el motor cuando una transacción deja un registro bloqueado y la otra intenta modificarlo.

## Video
Presentación en YouTube: https://www.youtube.com/watch?v=x7CyJGg8EJ0

## Nota sobre el uso de IA (muy leve)
Se usó IA como apoyo puntual para revisar redacción/documentación y validar ideas generales, pero el diseño del modelo y la adaptación de los scripts al motor (MariaDB) se realizó y verificó manualmente.
