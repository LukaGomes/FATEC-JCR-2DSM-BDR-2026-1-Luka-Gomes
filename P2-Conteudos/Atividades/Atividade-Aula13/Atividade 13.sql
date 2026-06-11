CREATE TABLE IF NOT EXISTS autor (
    id_autor   SERIAL PRIMARY KEY,
    nome       VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS livro (
    id_livro        SERIAL PRIMARY KEY,
    titulo          VARCHAR(150) NOT NULL,
    num_paginas     INT          NOT NULL,
    ano_publicacao  INT          NOT NULL,
    id_autor        INT          NOT NULL REFERENCES autor(id_autor)
);

-- DADOS DE EXEMPLO

INSERT INTO autor (nome) VALUES
    ('Machado de Assis'),
    ('Clarice Lispector'),
    ('Graciliano Ramos'),
    ('Carlos Drummond de Andrade');

INSERT INTO livro (titulo, num_paginas, ano_publicacao, id_autor) VALUES
    ('Dom Casmurro',                  256, 1899, 1),
    ('Memórias Póstumas de Brás Cubas', 312, 1881, 1),
    ('Quincas Borba',                 288, 1891, 1),
    ('A Hora da Estrela',             96,  1977, 2),
    ('Perto do Coração Selvagem',     192, 1943, 2),
    ('Vidas Secas',                   176, 1938, 3),
    ('No Meio do Caminho',            48,  1928, 4);

-- EXERCÍCIO 1

CREATE OR REPLACE VIEW vw_livros_paginas AS
SELECT
    titulo,
    num_paginas
FROM livro;

--Teste
SELECT * FROM vw_livros_paginas;

-- EXERCÍCIO 2

CREATE OR REPLACE VIEW vw_autores_mais_de_um_livro AS
SELECT
    a.nome        AS autor,
    COUNT(l.id_livro) AS total_livros
FROM autor a
JOIN livro l ON l.id_autor = a.id_autor
GROUP BY a.id_autor, a.nome
HAVING COUNT(l.id_livro) > 1;

-- Teste:
SELECT * FROM vw_autores_mais_de_um_livro;

-- EXERCÍCIO 3

CREATE OR REPLACE VIEW vw_livros_acima_media_paginas AS
SELECT
    titulo,
    num_paginas
FROM livro
WHERE num_paginas > (SELECT AVG(num_paginas) FROM livro);

-- Teste:
SELECT * FROM vw_livros_acima_media_paginas;

-- EXERCÍCIO 4

CREATE OR REPLACE VIEW vw_autor_titulo_ano AS
SELECT
    a.nome        AS autor,
    l.titulo,
    l.ano_publicacao
FROM livro l
JOIN autor a ON a.id_autor = l.id_autor;

-- Teste:
SELECT * FROM vw_autor_titulo_ano;

-- EXERCÍCIO 5

CREATE OR REPLACE VIEW vw_autor_stats AS
SELECT
    a.nome            AS autor,
    COUNT(l.id_livro) AS total_livros,
    MAX(l.num_paginas) AS maior_num_paginas
FROM autor a
JOIN livro l ON l.id_autor = a.id_autor
GROUP BY a.id_autor, a.nome;

-- Teste:
SELECT * FROM vw_autor_stats;