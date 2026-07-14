-- ═══════════════════════════════════════════════════════════════
-- BodegaTech — Script de Inventario
-- Descripción: creación, carga y actualización del inventario.
-- Compatible con PostgreSQL y SQL Server.
-- ═══════════════════════════════════════════════════════════════


-- ── SECCIÓN DDL: DEFINICIÓN DE LA ESTRUCTURA ──────────────────

-- Elimina la tabla si ya existe para que el script pueda
-- ejecutarse nuevamente sin producir errores.
DROP TABLE IF EXISTS inventario;


-- Crea la tabla principal del inventario.
CREATE TABLE inventario (
    -- INT es adecuado para un identificador numérico sin decimales.
    -- PRIMARY KEY impide identificadores repetidos o nulos.
    id_producto INT PRIMARY KEY,

    -- VARCHAR(100) admite nombres de hasta 100 caracteres
    -- sin reservar espacio innecesario.
    nombre_producto VARCHAR(100) NOT NULL,

    -- VARCHAR(50) es suficiente para almacenar categorías breves.
    categoria VARCHAR(50) NOT NULL,

    -- DECIMAL(10,2) guarda importes monetarios con precisión:
    -- hasta 8 dígitos enteros y 2 decimales.
    precio_unitario DECIMAL(10,2) NOT NULL,

    -- INT representa cantidades completas de unidades disponibles.
    stock_actual INT NOT NULL,

    -- INT representa el límite de unidades para solicitar reposición.
    stock_minimo INT NOT NULL,

    -- DATE almacena únicamente una fecha, sin hora.
    fecha_ingreso DATE NOT NULL,

    -- SMALLINT representa el estado con 1 (activo) o 0 (inactivo).
    -- Se utiliza por compatibilidad con PostgreSQL y SQL Server.
    activo SMALLINT NOT NULL,

    -- Estas restricciones evitan precios y cantidades negativas
    -- y limitan el estado activo a los valores 0 y 1.
    CHECK (precio_unitario >= 0),
    CHECK (stock_actual >= 0),
    CHECK (stock_minimo >= 0),
    CHECK (activo IN (0, 1))
);


-- ── SECCIÓN DML: CARGA Y MODIFICACIÓN DE DATOS ────────────────

-- Carga de los 10 productos iniciales.
-- Se especifican los nombres de las columnas para evitar errores
-- si en el futuro cambia el orden de la tabla.
INSERT INTO inventario (
    id_producto,
    nombre_producto,
    categoria,
    precio_unitario,
    stock_actual,
    stock_minimo,
    fecha_ingreso,
    activo
)
VALUES
    (1,  'Laptop Pro 15',          'Computación',    1200.00, 15, 3,  '2024-01-10', 1),
    (2,  'Mouse Inalámbrico',      'Accesorios',       28.00, 80, 10, '2024-01-10', 1),
    (3,  'Monitor 4K 27"',         'Computación',      450.00, 12, 2,  '2024-01-15', 1),
    (4,  'Teclado Mecánico',       'Accesorios',       95.00, 40, 5,  '2024-01-15', 1),
    (5,  'Laptop Basic 14',        'Computación',      650.00, 20, 3,  '2024-02-01', 1),
    (6,  'Auriculares BT Pro',     'Audio',            120.00, 35, 5,  '2024-02-01', 1),
    (7,  'Hub USB-C 7 puertos',    'Accesorios',        45.00, 60, 10, '2024-02-10', 1),
    (8,  'Webcam HD 1080p',        'Accesorios',        85.00, 25, 5,  '2024-02-10', 1),
    (9,  'SSD Externo 1TB',        'Almacenamiento',   130.00, 18, 3,  '2024-03-01', 1),
    (10, 'Parlante Bluetooth',     'Audio',             60.00, 45, 8,  '2024-03-01', 1);


-- ── ACTUALIZACIÓN DE LAS VENTAS DEL DÍA ───────────────────────

-- Venta de 3 unidades de Laptop Pro 15.
-- Stock final esperado: 15 - 3 = 12.
UPDATE inventario
SET stock_actual = stock_actual - 3
WHERE id_producto = 1;


-- Venta de 12 unidades de Mouse Inalámbrico.
-- Stock final esperado: 80 - 12 = 68.
UPDATE inventario
SET stock_actual = stock_actual - 12
WHERE id_producto = 2;


-- Venta de 5 unidades de Auriculares BT Pro.
-- Stock final esperado: 35 - 5 = 30.
UPDATE inventario
SET stock_actual = stock_actual - 5
WHERE id_producto = 6;


-- ── ACTUALIZACIÓN DE PRODUCTO DESCONTINUADO ───────────────────

-- La Webcam HD 1080p fue descontinuada por el proveedor.
UPDATE inventario
SET activo = 0
WHERE id_producto = 8;


-- ── CONSULTA DE VALIDACIÓN ─────────────────────────────────────

-- Muestra la tabla completa para confirmar que los datos
-- se cargaron y actualizaron correctamente.
SELECT * FROM inventario;
