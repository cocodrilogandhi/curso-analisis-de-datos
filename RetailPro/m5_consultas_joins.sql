/*
============================================================
PRE-ENTREGA: Consultas con JOINs para el proyecto
Título: Cruzando tablas para enriquecer el análisis

Proyecto: RetailPro
Autor: Juan Manuel Márquez
Comisión: #101725
Archivo: m5_consultas_joins.sql
Motor: PostgreSQL

IMPORTANTE:
Este script sigue el modelo RetailPro requerido por la consigna de M5.
Supone la existencia de:
- clientes: id_cliente, nombre, email, segmento, fecha_registro
- productos: id_producto, nombre_producto, categoria, precio
- territorios: id_territorio, region
- ventas: id_venta, fecha_venta, id_cliente, id_producto,
          id_territorio, cantidad, precio_unitario, total_venta, canal
============================================================
*/

-- =========================================================
-- CONSULTA 1 — VISTA BASE DEL PROYECTO (INNER JOIN)
-- Combina ventas, clientes, productos y territorios.
-- Esta consulta será la fuente principal para Power BI.
-- =========================================================

SELECT
    v.fecha_venta AS fecha,
    c.nombre AS nombre_cliente,
    c.segmento,
    t.region,
    p.nombre_producto,
    p.categoria,
    v.cantidad,
    v.precio_unitario,
    v.total_venta,
    v.canal
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN territorios AS t
    ON v.id_territorio = t.id_territorio
ORDER BY v.fecha_venta, v.id_venta;

-- =========================================================
-- CONSULTA 2 — CLIENTES SIN VENTAS (LEFT JOIN)
-- Identifica clientes registrados que todavía no realizaron
-- ninguna compra.
-- =========================================================

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.nombre;

-- =========================================================
-- CONSULTA 3 — PRODUCTOS SIN VENTAS (LEFT JOIN)
-- Identifica productos del catálogo que no tienen ninguna
-- venta registrada.
-- =========================================================

SELECT
    p.nombre_producto,
    p.categoria,
    p.precio
FROM productos AS p
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY p.nombre_producto;

-- =========================================================
-- CONSULTA 4 — CONSOLIDADO POR CANAL (UNION ALL)
-- Combina las ventas Online y Presencial en un único conjunto
-- y luego calcula el total facturado por canal.
-- =========================================================

WITH ventas_por_canal AS (
    SELECT
        'Online' AS canal,
        cantidad * precio_unitario AS importe_venta
    FROM ventas
    WHERE canal = 'Online'

    UNION ALL

    SELECT
        'Presencial' AS canal,
        cantidad * precio_unitario AS importe_venta
    FROM ventas
    WHERE canal = 'Presencial'
)
SELECT
    canal,
    SUM(importe_venta) AS total_facturado
FROM ventas_por_canal
GROUP BY canal
ORDER BY canal;

/*
============================================================
FIN DEL SCRIPT
============================================================
*/
