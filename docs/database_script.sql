-- Crear base de datos
CREATE DATABASE app_clientes;

-- Usar la base de datos
USE app_clientes;

-- Crear tabla clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    dpi VARCHAR(20) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    created_at DATETIME,
    updated_at DATETIME,
    deleted_at DATETIME
);

-- Insertar datos de prueba
INSERT INTO clientes (dpi, nombre, email, telefono, created_at, updated_at)
VALUES 
('4580751200369', 'Marvin Jenaro', 'mjerez@hotmail.com', '58784512', NOW(), NOW()),
('1234567890123', 'Denis Sincal', 'dsincal@hotmail.com', '44445555', NOW(), NOW()),
('7895420000014', 'Javier Gomez', 'jgomez@hotmail.com', '85212369', NOW(), NOW()),
('7895661321310', 'Guiller Castañeda', 'gcastaneda@hotmail.com', '78965432', NOW(), NOW()),
('8522001364479', 'Pablo Escobar', 'pescobar@hotmail.com', '89651520', NOW(), NOW()),
('3387567601001', 'Laura Castañeda', 'lcastaneda@hotmail.com', '74196301', NOW(), NOW())
;