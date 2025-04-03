CREATE DATABASE IF NOT EXISTS Examen_sql;
USE Examen_sql;

CREATE TABLE actor (
	id_actor INT AUTO_INCREMENT,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    ulltima_actualizacion TIMESTAMP,
    PRIMARY KEY(id_actor)
);

CREATE TABLE pais ( 
	id_pais INT AUTO_INCREMENT,
    nombre VARCHAR(50),
    ultima_actualizacion TIMESTAMP,
	PRIMARY KEY(id_pais)
);

CREATE TABLE ciudad (
    id_ciudad INT AUTO_INCREMENT,
	nombre VARCHAR(50),
    id_pais INT,
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY(id_ciudad),
    FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);

CREATE TABLE direccion (
	id_direccion INT PRIMARY KEY AUTO_INCREMENT,
    direccion VARCHAR(50),
    direccion2 VARCHAR(50),
    distrito VARCHAR(20),
    id_ciudad INT,
    codigo_postal VARCHAR(10),
    telefono VARCHAR(20),
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_ciudad) REFERENCES ciudad(id_ciudad)
);

CREATE TABLE categoria (
	id_categoria INT AUTO_INCREMENT,
    nombre VARCHAR(255),
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY (id_categoria)
);

CREATE TABLE idioma (
	id_idioma INT AUTO_INCREMENT,
    nombre VARCHAR(20),
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY(id_idioma)
);

CREATE TABLE pelicula (
	id_pelicula INT AUTO_INCREMENT,
    titulo VARCHAR(255),
    descripcion TEXT,
    anyo_lanzamiento YEAR,
    id_idioma INT,
    id_idioma_original INT,
    duracion_alquiler INT,
    rental_rate DECIMAL(4,2),
    duracion INT,
    replacement_cost DECIMAL(5,2),
    clasificacion ENUM('G','PG','PG-13','R','NC-17'),
    caracteristicas_especiales SET('Trailers', 'Commentaries', 'Deleted Scenes', 'Behind the Scenes'),
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY(id_pelicula),
    FOREIGN KEY (id_idioma) REFERENCES idioma(id_idioma)
);

CREATE TABLE empleado (
	id_empleado INT AUTO_INCREMENT,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    id_direccion INT,
    imagen BLOB,
    email VARCHAR(50),
    id_almacen INT,
    activo INT(1),
    username VARCHAR(16),
    password VARCHAR(40),
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY (id_empleado),
    FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion)
);

CREATE TABLE almacen (
	id_almacen INT AUTO_INCREMENT,
    id_empleado INT,
    id_direccion INT,
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY(id_almacen),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
 	FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion)
);

CREATE TABLE inventario (
	id_inventario INT AUTO_INCREMENT,
    id_pelicula INT,
    id_almacen INT,
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY(id_inventario),
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula),
    FOREIGN KEY (id_almacen) REFERENCES almacen(id_almacen)
);

CREATE TABLE pelicula_categoria (
	id_pelicula INT,
    id_categoria INT,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_pelicula) REFERENCES pelicula(id_pelicula),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE pelicula_actor (
	id_actor INT,
    id_categoria INT,
    ultima_actualizacion TIMESTAMP,
    FOREIGN KEY (id_actor) REFERENCES actor(id_actor),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
);

CREATE TABLE cliente (
	id_cliente INT AUTO_INCREMENT,
    id_almacen INT,
    nombre VARCHAR(45),
    apellidos VARCHAR(45),
    email VARCHAR(50),
    id_direccion INT,
    activo INT(1),
    fecha_creacion DATETIME,
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY (id_cliente),
    FOREIGN KEY (id_almacen) REFERENCES almacen(id_almacen),
    FOREIGN KEY (id_direccion) REFERENCES direccion(id_direccion)
);


CREATE TABLE alquiler (
	id_alquiler INT AUTO_INCREMENT,
    fecha_alquiler DATETIME,
    id_inventario INT,
    id_cliente INT,
    fecha_devolucion DATETIME,
    id_empleado INT,
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY (id_alquiler),
    FOREIGN KEY (id_inventario) REFERENCES inventario(id_inventario),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

CREATE TABLE pago (
	id_pago INT AUTO_INCREMENT,
    id_cliente INT,
    id_empleado INT,
    id_alquiler INT,
    total DECIMAL(5,2),
    fecha_pago DATETIME,
    ultima_actualizacion TIMESTAMP,
    PRIMARY KEY (id_pago),
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado),
    FOREIGN KEY (id_alquiler) REFERENCES alquiler(id_alquiler)
);

CREATE TABLE film_text (
	film_id INT AUTO_INCREMENT,
    title VARCHAR(255),
    descripcion TEXT,
    PRIMARY KEY (film_id)
);