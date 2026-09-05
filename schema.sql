-- Video Game Store Database
-- PostgreSQL - Arrays, JSON, Window Functions


CREATE TABLE games (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(150),
    precio DECIMAL(10,2),
    año_lanzamiento INT,
    generos TEXT[],              -- ARRAY de géneros            
    plataformas TEXT[],          -- ARRAY de plataformas        
    reviews JSONB DEFAULT '[]'::jsonb,  -- JSON array de reviews   
    metadata JSONB DEFAULT '{}'::jsonb   -- JSON con info extra   
);




-- Insert de informacion para la base de datos 
INSERT INTO games (titulo, precio, año_lanzamiento, generos, plataformas, reviews, metadata) VALUES
(
    'Elden Ring',
    59.99,
    2022,
    ARRAY['action', 'rpg', 'adventure'],
    ARRAY['PS5', 'Xbox Series X', 'PC'],
    '[
        {"user": "Carlos", "rating": 9, "comentario": "Juego increíble"},
        {"user": "Ana", "rating": 8.5, "comentario": "Muy difícil pero adictivo"},
        {"user": "Luis", "rating": 9.5, "comentario": "Obra maestra"}
    ]'::jsonb,
    '{"desarrollador": "FromSoftware", "ventas": 20000, "multijugador": true}'::jsonb
),
(
    'Hogwarts Legacy',
    69.99,
    2023,
    ARRAY['action', 'rpg', 'magic'],
    ARRAY['PS5', 'Xbox Series X', 'PC', 'Nintendo Switch'],
    '[
        {"user": "Maria", "rating": 8, "comentario": "Gran mundo para explorar"},
        {"user": "Juan", "rating": 7.5, "comentario": "Bueno pero repetitivo"}
    ]'::jsonb,
    '{"desarrollador": "Avalanche Software", "ventas": 15000, "multijugador": false}'::jsonb
),
(
    'Palworld',
    29.99,
    2024,
    ARRAY['action', 'survival', 'crafting'],
    ARRAY['PC', 'Xbox Series X'],
    '[
        {"user": "Pedro", "rating": 8.5, "comentario": "Divertido en coop"},
        {"user": "Sofia", "rating": 7, "comentario": "Buen juego, algo buggy"},
        {"user": "Miguel", "rating": 8, "comentario": "Vale cada peso"}
    ]'::jsonb,
    '{"desarrollador": "Pocketpair", "ventas": 12000, "multijugador": true}'::jsonb
),
(
    'Baldurs Gate 3',
    59.99,
    2023,
    ARRAY['rpg', 'adventure', 'strategy'],
    ARRAY['PS5', 'PC', 'Xbox Series X'],
    '[
        {"user": "Alex", "rating": 10, "comentario": "Mejor RPG que he jugado"},
        {"user": "Diana", "rating": 9.5, "comentario": "Historias increíbles"},
        {"user": "Oscar", "rating": 9, "comentario": "Muy largo pero excelente"}
    ]'::jsonb,
    '{"desarrollador": "Larian Studios", "ventas": 25000, "multijugador": false}'::jsonb
);