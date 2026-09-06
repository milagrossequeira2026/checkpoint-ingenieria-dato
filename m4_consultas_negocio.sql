-- =========================================================
-- M4 — PRE-ENTREGA: CONSULTAS SQL DE NEGOCIO
-- Proyecto: Extrayendo métricas clave con SQL
-- Base de datos: Ventas_Tech_DB
-- Archivo: m4_consultas_negocio.sql
-- =========================================================


-- =========================================================
-- CONSULTA 1 — RESUMEN EJECUTIVO MENSUAL
-- =========================================================
-- Calcula por mes:
--   • Total facturado
--   • Cantidad de pedidos
--   • Ticket promedio
--
-- El total facturado se obtiene multiplicando:
-- cantidad * precio_unitario
-- =========================================================

SELECT
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY EXTRACT(MONTH FROM fecha_venta)
ORDER BY mes;


-- =========================================================
-- CONSULTA 2 — RANKING DE PRODUCTOS
-- =========================================================
-- Muestra los 5 productos con mayor facturación.
-- También muestra las unidades vendidas.
-- =========================================================

SELECT
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY id_producto
ORDER BY total_generado DESC
LIMIT 5;


-- =========================================================
-- CONSULTA 3 — CLIENTES RECURRENTES
-- =========================================================
-- Muestra los clientes que realizaron más de un pedido.
-- También muestra la cantidad de pedidos y el total gastado.
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
-- CONSULTA 4 — FACTURACIÓN MENSUAL VS. PROMEDIO
-- =========================================================
-- Calcula la facturación total de cada mes y la compara
-- con el promedio de facturación mensual.
-- =========================================================

WITH facturacion_mensual AS (
    SELECT
        EXTRACT(MONTH FROM fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY EXTRACT(MONTH FROM fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado > (
            SELECT AVG(total_facturado)
            FROM facturacion_mensual
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM facturacion_mensual
ORDER BY mes;


-- =========================================================
-- HALLAZGOS
-- =========================================================
-- 1. Se registraron 10 pedidos durante el período analizado,
--    todos correspondientes al mes de marzo de 2024.
--
-- 2. El producto 1 fue el que generó la mayor facturación,
--    con un total de $3.600.
--
-- 3. Los cinco clientes registrados realizaron más de un pedido,
--    por lo que todos son considerados clientes recurrentes.
