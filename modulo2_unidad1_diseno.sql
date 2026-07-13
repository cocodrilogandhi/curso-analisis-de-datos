-- Archivo: modulo2_unidad1_diseno.sql
-- Objetivo: crear las tablas principales de un sistema de gestión de ventas.

-- Tabla que almacena la información básica de los clientes.
CREATE TABLE clientes (
    -- INT se utiliza porque el identificador es un número entero.
    -- PRIMARY KEY garantiza que cada cliente tenga un identificador único.
    id_cliente INT PRIMARY KEY,

    -- VARCHAR(100) permite almacenar nombres de hasta 100 caracteres.
    nombre VARCHAR(100) NOT NULL,

    -- TEXT permite guardar una biografía o notas extensas sobre el cliente.
    perfil_bio TEXT,

    -- DATE almacena únicamente la fecha, sin hora.
    fecha_registro DATE NOT NULL
);

-- Tabla que almacena la información de los productos.
CREATE TABLE productos (
    -- INT se utiliza porque el identificador es un número entero.
    -- PRIMARY KEY garantiza que cada producto tenga un identificador único.
    id_producto INT PRIMARY KEY,

    -- VARCHAR(255) permite almacenar una descripción de hasta 255 caracteres.
    descripcion VARCHAR(255) NOT NULL,

    -- NUMERIC(10,2) permite guardar valores monetarios con hasta
    -- 10 dígitos en total y 2 decimales, evitando los errores de FLOAT.
    precio NUMERIC(10,2) NOT NULL,

    -- SMALLINT representa el estado mediante 1 (activo) o 0 (inactivo).
    -- Se eligió en lugar de BOOLEAN para facilitar la compatibilidad
    -- entre PostgreSQL y SQL Server.
    esta_activo SMALLINT NOT NULL,

    -- La restricción CHECK evita valores distintos de 0 y 1.
    CHECK (esta_activo IN (0, 1))
);
