CREATE DATABASE gastronomiabsas;

USE DATABASE gastronomiabsas;

CREATE TABLE Categoria(
 ID_Categoria INT PRIMARY KEY AUTO_INCREMENT,
 Categoria VARCHAR (50));
 
 CREATE TABLE Barrio(
 ID_Barrio INT PRIMARY KEY AUTO_INCREMENT,
 Barrio VARCHAR (50));


CREATE TABLE locales (
ID_local INT AUTO_INCREMENT PRIMARY KEY,
Nombre_local VARCHAR (50),
Ventas_por_dia  INT,
Telefono INT,
Direccion VARCHAR (50),
Fecha_apertura DATETIME,
ID_barrio INT,
ID_categoria INT,
FOREIGN KEY (id_barrio) REFERENCES Barrio (id_barrio),
FOREIGN KEY (id_categoria) REFERENCES Categoria (id_categoria)
);


CREATE INDEX idx_locales_barrio ON locales (id_barrio);

CREATE VIEW vista_locales_info_completa AS
 SELECT
 l.nombre_local,
 c.categoria AS nombre_categoria,
 b.barrio AS nombre_barrio,
 l.ventas_por_dia,
 l.telefono
 FROM locales l 
 JOIN categoria c ON l.id_categoria = c.id_categoria
 JOIN barrio b ON l.id_barrio = b.id_barrio;

CREATE VIEW vista_barrio_de_locales AS
SELECT
b.barrio AS nombre_barrio,
l.nombre_local
FROM locales l
JOIN barrio b ON b.id_barrio = l.id_local;

CREATE VIEW vista_categoria_de_locales AS
SELECT
c.categoria,
l.nombre_local
FROM locales l
JOIN categoria c ON c.id_categoria = l.id_local;


CREATE FUNCTION ventas_por_categoria (id_categoria INT)
RETURNS DECIMAL (10,2)
DETERMINISTIC 
  RETURN (
SELECT AVG (ventas_por_dia)
FROM locales
WHERE Locales.id_categoria=id_categoria);

DELIMITER $$  
CREATE FUNCTION cantidad_locales_barrio (nombre_barrio VARCHAR (50))
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE total INT;

SELECT COUNT(*)
INTO total
FROM locales 
WHERE ID_Barrio= (
SELECT ID_Barrio
FROM barrio
WHERE barrio=nombre_barrio
LIMIT 1
);
RETURN total;
END $$
DELIMITER //;


DELIMITER // 

CREATE PROCEDURE agregar_local (
IN p_nombre_local VARCHAR (50),
IN p_ventas_por_dia INT,
IN p_telefono INT,
IN p_direccion VARCHAR (50),
IN p_fecha_apertura DATETIME
)
BEGIN
      INSERT INTO locales (
     nombre_local, ventas_por_dia, telefono, direccion, fecha_apertura
      )
      
      VALUES (p_nombre_local, p_ventas_por_dia, p_telefono, p_direccion, p_fecha_apertura
      );
END //

DELIMITER ;


// DELIMITER 
CREATE PROCEDURE actualizar_direccion_local(
IN p_id_local INT, 
IN p_nueva_direccion VARCHAR (50)
)
BEGIN
UPDATE locales
SET direccion = p_nueva_direccion
WHERE id_local = p.id_local;
END //
DELIMITER ;


CREATE TABLE historial_ventas(
 id INT AUTO_INCREMENT PRIMARY KEY,
 i_local INT,
 ventas_anteriores DECIMAL (10,2),
 ventas_nuevas DECIMAL (10,2),
 fecha_cambio DATETIME
 );

DELIMITER //
CREATE TRIGGER trg_actualizacion_ventas
BEFORE UPDATE ON localeS
FOR EACH ROW
BEGIN
 IF OLD.ventas_por_dia !=NEW.ventas_por_dia THEN
INSERT INTO historial_ventas (id_local, ventas_anteriores, ventas_nuevas, fecha_cambio)
VALUES (OLD.id_local, OLD.ventas_por_dia, NEW.ventas_por_dia, NOW ());
END IF;
END //
DELIMITER ;

CREATE TABLE auditoria_locales (
 id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
 id_local INT,
 nombre_local VARCHAR (100),
 fecha_eliminacion DATETIME
 );

DELIMITER //
CREATE TRIGGER trg_auditoria_borrado_local
BEFORE DELETE ON locales
FOR EACH ROW
BEGIN
  INSERT INTO auditoria_locales (id_local, nombre_local, fecha_eliminacion)
  VALUES (OLD.id_local, OLD.nombre_local, NOW ());
END //
DELIMITER ;


CREATE TABLE resenias (
id_resenia INT PRIMARY KEY AUTO_INCREMENT,
id_local INT,
nombre_cliente VARCHAR (50),
calificacion INT CHECK (calificacion BETWEEN 1 AND 5),
comentario TEXT,
fecha_resenia DATETIME,
FOREIGN KEY (id_local) REFERENCES locales (id_local)
);


