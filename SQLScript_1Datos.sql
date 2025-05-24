
 INSERT INTO categoria(id_categoria, Categoria)
 VALUES (1, "Cafeteria"),
(2, "Restaurante"),
 (3, "Pizzeria");
 
 INSERT INTO Barrio (id_barrio, Barrio)
 VALUES (1, "Mataderos"),(2, "Villa Luro"),(3, "Liniers"),(4, "Caballito");

INSERT INTO locales(nombre_local, ventas_por_dia, telefono, direccion, fecha_apertura, ID_categoria, ID_barrio)
 VALUES 
 ("Cedron","200","46584559","Av. Juan Bautista Alberdi 6101","1985-05-20", 3, 1),
 ("Bonafide","150","46852553","Bonifacio 7585","1999-02-20", 1, 3),
 ("Havanna","175","45569889","Av. Juan B. Justo 5856","2000-08-19", 1, 4),
 ("Aturias","140","44427568","Av.Emilio castro 6052","1995-05-13", 2, 2),
 ("Ochavita","100","22345685","Av.Juan B. Alberdi 1556 ","1999-06-21", 2, 1);


--Consultar las vistas
SELECT*FROM vista_barrio_de_locales;

SELECT*FROM vista_locales_info_completa;

SELECT*FROM vista_categoria_de_locales;

--Consultar funciones
SELECT  id_categoria,
ventas_por_categoria (id_categoria)
 AS promedio_ventas_categoria 
 FROM locales
 GROUP BY id_categoria;

SELECT cantidad_locales_barrio('Mataderos');

--Ejecutar Stored Procedure
CALL agregar_local('Don Bianco', 500, 1125589945, 'Av.Larrazabal 1445','1992-05-04');
               
CALL actualizar_direccion (11, 'Av. Juan Bautista Alberdi 6105');


---Ejecutar triggers
DELETE FROM locales WHERE id_local= 13;

SELECT * FROM auditoria_locales;


UPDATE locales
SET Ventas_por_dia = 250
WHERE ID_local = 15;

SELECT * FROM historial_ventas;
