-- Consultas con ARRAY 

-- Mostrar géneros de cada juego
select titulo, generos from games;

-- Juegos que contienen género 'rpg'
SELECT titulo FROM games WHERE 'rpg' = ANY(generos);


-- Contar cuántos géneros tiene cada juego
SELECT titulo, array_length(generos, 1) as cantidad_generos FROM games;

-- Agregar plataforma a un juego existente
UPDATE games 
SET plataformas = array_append(plataformas, 'Nintendo Switch')
WHERE titulo = 'Elden Ring';


--------------------------------------------

-- Consultas con JSON


-- Primer review de cada juego
SELECT 
    titulo,
    reviews->0->>'user' as primer_usuario,
    reviews->0->>'comentario' as comentario
FROM games;

-- Expandir todas las reviews en filas
SELECT 
    titulo,
    jsonb_array_elements(reviews)->>'user' as usuario,
    (jsonb_array_elements(reviews)->>'rating')::FLOAT as rating,
    jsonb_array_elements(reviews)->>'comentario' as comentario
FROM games;


-- Promedio de rating por juego
SELECT 
    titulo,
    AVG((jsonb_array_elements(reviews)->>'rating')::FLOAT) as promedio_rating
FROM games
GROUP BY titulo
ORDER BY promedio_rating DESC;

-- Información del desarrollador y multijugador desde metadata
SELECT 
    titulo,
    metadata->>'desarrollador' as desarrollador,
    (metadata->>'ventas')::INT as ventas,
    CASE 
        WHEN (metadata->>'multijugador')::BOOLEAN THEN 'Sí'
        ELSE 'No'
    END as tiene_multijugador
FROM games;
----------------------------------------------------

-- Consultas con windows functions

-- Ranking de juegos por precio
SELECT
	titulo,
	precio,
	ROW_NUMBER() OVER (ORDER BY precio DESC) as ranking_precio
FROM games 
ORDER BY precio DESC;

 
-- Ranking por promedio de rating 
SELECT 
    titulo,
    año_lanzamiento,
    ROUND(AVG((elem->>'rating')::NUMERIC), 2) as promedio_rating,
    ROW_NUMBER() OVER (ORDER BY AVG((elem->>'rating')::NUMERIC) DESC) as ranking
FROM games,
LATERAL jsonb_array_elements(reviews) as elem
GROUP BY titulo, año_lanzamiento
ORDER BY promedio_rating DESC;

-- Comparar precio de cada juego vs promedio general
SELECT 
    titulo,
    precio,
    ROUND(AVG(precio) OVER ()::NUMERIC, 2) as precio_promedio,
    ROUND((precio - AVG(precio) OVER ())::NUMERIC, 2) as diferencia,
    CASE
        WHEN precio > AVG(precio) OVER () THEN 'Mas caro'
        WHEN precio < AVG(precio) OVER () THEN 'Mas barato'
        ELSE 'Precio promedio'
    END as categoria_precio
FROM games
ORDER BY precio DESC;


-- Comparar precio de cada juego vs precio de Palworld
SELECT 
    titulo,
    precio,
    (SELECT precio FROM games WHERE titulo = 'Palworld') as precio_palworld,
    CASE 
        WHEN precio > (SELECT precio FROM games WHERE titulo = 'Palworld') THEN 'Más caro'
        ELSE 'Igual o más barato'
    END as comparacion,
    ROW_NUMBER() OVER (ORDER BY precio DESC) as ranking
FROM games;
-----------------------------------------------------

-- Dashboard con todas las métricas

SELECT 
    titulo,
    precio,
    array_length(generos, 1) as num_generos,
    array_length(plataformas, 1) as num_plataformas,
    metadata->>'desarrollador' as desarrollador,
    (metadata->>'ventas')::INT as ventas,
    ROUND(AVG((elem->>'rating')::NUMERIC), 2) as promedio_rating,
    jsonb_array_length(reviews) as cantidad_reviews,
    ROW_NUMBER() OVER (ORDER BY AVG((elem->>'rating')::NUMERIC) DESC) as ranking_rating,
    ROW_NUMBER() OVER (ORDER BY (metadata->>'ventas')::INT DESC) as ranking_ventas
FROM games,
LATERAL jsonb_array_elements(reviews) as elem
GROUP BY titulo, precio, generos, plataformas, metadata, reviews
ORDER BY promedio_rating DESC;