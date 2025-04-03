-- 1. Encuentra el cliente que ha realizado la mayor cantidad de alquileres en los últimos 6 meses.

SELECT c.id_cliente, CONCAT(c.nombre, ' ', c.apellidos) AS cliente,
COUNT(a.id_alquiler) AS total_alquileres
FROM alquiler a
JOIN cliente c ON a.id_cliente = c.id_cliente
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY c.id_cliente
ORDER BY total_alquileres DESC LIMIT 1;

-- 2. Lista las cinco películas más alquiladas durante el último año.

SELECT p.id_pelicula, p.titulo,
COUNT(*) AS total_alquileres
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario 
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY p.id_pelicula
ORDER BY total_alquileres DESC LIMIT 5;

-- 3. Obtén el total de ingresos y la cantidad de alquileres realizados por cada categoría de película.

SELECT cat.nombre AS categoria,
COUNT(a.id_alquiler) AS total_alquileres,
SUM(p.total) AS ingresos_totales
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
JOIN pago p ON a.id_alquiler = p.id_alquiler
GROUP BY cat.id_categoria
ORDER BY ingresos_totales DESC;

-- 4. Calcula el número total de clientes que han realizado alquileres por cada idioma disponible en un mes específico.

SELECT i.nombre AS idioma,
COUNT(DISTINCT a.id_cliente) AS total_clientes
FROM alquiler a
JOIN inventario inv ON a.id_inventario = inv.id_inventario
JOIN pelicula p ON inv.id_pelicula = p.id_pelicula
JOIN idioma i ON p.id_idioma = i.id_idioma
WHERE MONTH(a.fecha_alquiler) = 3 AND YEAR(a.fecha_alquiler) = 2025  -- Cambiar por el mes deseado
GROUP BY i.id_idioma;

-- 5. Encuentra a los clientes que han alquilado todas las películas de una misma categoría.

SELECT c.id_cliente,
CONCAT(c.nombre, ' ', c.apellidos) AS cliente,
cat.nombre AS categoria
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
GROUP BY c.id_cliente, cat.id_categoria
HAVING 
    COUNT(DISTINCT i.id_pelicula) = (
        SELECT COUNT(*) 
        FROM campus.pelicula_categoria 
        WHERE id_categoria = cat.id_categoria
    );

-- 6. Lista las tres ciudades con más clientes activos en el último trimestre.

SELECT ci.nombre AS ciudad,
COUNT(DISTINCT c.id_cliente) AS clientes_activos
FROM cliente c
JOIN direccion d ON c.id_direccion = d.id_direccion
JOIN ciudad ci ON d.id_ciudad = ci.id_ciudad
JOIN alquiler a ON c.id_cliente = a.id_cliente
WHERE 
    a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY ci.id_ciudad
ORDER BY clientes_activos DESC
LIMIT 3;

-- 7. Muestra las cinco categorías con menos alquileres registrados en el último año.

SELECT cat.nombre AS categoria,
COUNT(a.id_alquiler) AS total_alquileres
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY cat.id_categoria
ORDER BY total_alquileres ASC
LIMIT 5;

-- 8. Calcula el promedio de días que un cliente tarda en devolver las películas alquiladas.

SELECT AVG(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) AS promedio_dias_devolucion
FROM alquiler a
WHERE a.fecha_devolucion IS NOT NULL;

-- 9. Encuentra los cinco empleados que gestionaron más alquileres en la categoría de Acción.

SELECT e.id_empleado,
CONCAT(e.nombre, ' ', e.apellidos) AS empleado,
COUNT(a.id_alquiler) AS total_alquileres
FROM alquiler a
JOIN empleado e ON a.id_empleado = e.id_empleado
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula_categoria pc ON i.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
WHERE cat.nombre = 'Acción'
GROUP BY e.id_empleado
ORDER BY total_alquileres DESC
LIMIT 5;