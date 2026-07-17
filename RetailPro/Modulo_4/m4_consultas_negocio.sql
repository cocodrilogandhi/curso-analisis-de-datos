/*
============================================================
PRE-ENTREGA: Consultas SQL de negocio
Título: Extrayendo métricas clave con SQL

Proyecto: RetailPro
Autor: Juan Manuel Márquez
Comisión: #101725
Archivo: m4_consultas_negocio.sql
Motor: PostgreSQL
============================================================
*/

-- =========================================================
-- CONSULTA 1 — RESUMEN EJECUTIVO MENSUAL
-- Total facturado, cantidad de pedidos y ticket promedio
-- agrupados por mes.
-- =========================================================

SELECT
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    ROUND(
        SUM(cantidad * precio_unitario) / COUNT(*),
        2
    ) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;


-- =========================================================
-- CONSULTA 2 — RANKING DE PRODUCTOS
-- Top 5 de productos por total facturado, mostrando
-- también las unidades vendidas.
-- =========================================================

SELECT
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;


-- =========================================================
-- CONSULTA 3 — CLIENTES RECURRENTES
-- Clientes que realizaron más de un pedido, mostrando
-- cantidad de pedidos y total gastado.
-- =========================================================

SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;


-- =========================================================
-- CONSULTA 4 — MESES POR ENCIMA / POR DEBAJO DEL PROMEDIO
-- Calcula la facturación mensual y la compara con el
-- promedio mensual general.
--
-- Se incluye "Igual al promedio" para no clasificar
-- incorrectamente un mes cuyo total coincida exactamente
-- con el promedio.
-- =========================================================

WITH facturacion_mensual AS (
    SELECT
        EXTRACT(MONTH FROM fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
),
promedio_general AS (
    SELECT
        AVG(total_facturado) AS promedio_mensual_general
    FROM facturacion_mensual
)
SELECT
    fm.mes,
    fm.total_facturado,
    pg.promedio_mensual_general,
    CASE
        WHEN fm.total_facturado > pg.promedio_mensual_general
            THEN 'Por encima'
        WHEN fm.total_facturado < pg.promedio_mensual_general
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS comparacion_promedio
FROM facturacion_mensual AS fm
CROSS JOIN promedio_general AS pg
ORDER BY fm.mes;


-- =========================================================
-- HALLAZGOS AL REVISAR LOS RESULTADOS
-- =========================================================
--
-- 1. En marzo se facturaron USD 6.444,00 en 10 pedidos,
--    con un ticket promedio de USD 644,40.
--
-- 2. El producto con id_producto = 1 generó USD 3.600,00,
--    equivalente aproximadamente al 55,87 % de la
--    facturación total del período.
--
-- 3. Los 5 clientes realizaron más de un pedido. El
--    id_cliente = 1 fue el de mayor gasto, con USD 2.640,00,
--    seguido por el id_cliente = 5, con USD 2.100,00.
--
-- Nota: los datos iniciales cargados en M3 corresponden
-- únicamente a marzo de 2024. Por ese motivo, en la Consulta 4
-- el único mes disponible coincide con el promedio mensual.
