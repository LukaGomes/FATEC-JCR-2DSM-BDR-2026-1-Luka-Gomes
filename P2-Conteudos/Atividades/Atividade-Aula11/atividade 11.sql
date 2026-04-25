    CREATE DATABASE biblioteca; 

    -- Autor 
    CREATE TABLE autor ( 
    id_autor SERIAL PRIMARY KEY, 
    nome VARCHAR(100) NOT NULL 
    ); 

    -- Editora 
    CREATE TABLE editora ( 
    id_editora SERIAL PRIMARY KEY, 
    nome VARCHAR(100) NOT NULL, 
    cidade VARCHAR(100) 
    ); 

    -- Livro 
    CREATE TABLE livro ( 
        id_livro SERIAL PRIMARY KEY, 
        titulo VARCHAR(150) NOT NULL, 
        ano_publicacao INT, 
        id_autor INT REFERENCES autor(id_autor), 
        id_editora INT REFERENCES editora(id_editora) 
    ); 
    
    
    -- Aluno 
    CREATE TABLE aluno ( 
        id_aluno SERIAL PRIMARY KEY, 
        nome VARCHAR(100) NOT NULL, 
        curso VARCHAR(100) 
    ); 
    
    
    -- Empréstimo 
    CREATE TABLE emprestimo ( 
        id_emprestimo SERIAL PRIMARY KEY, 
        data_emprestimo DATE NOT NULL, 
        id_aluno INT REFERENCES aluno(id_aluno) 
    ); 
    
    
    -- Tabela associativa N:M entre empréstimo e livro 
    CREATE TABLE emprestimo_livro ( 
        id_emprestimo INT REFERENCES emprestimo(id_emprestimo), 
        id_livro INT REFERENCES livro(id_livro), 
        PRIMARY KEY (id_emprestimo, id_livro) 
    ); 
    
    
    -- Autores 
    INSERT INTO autor (nome) VALUES 
    ('J. R. R. Tolkien'), 
    ('Machado de Assis'), 
    ('Clarice Lispector'), 
    ('J.K. Rowling'); 

    -- Editoras 
    INSERT INTO editora (nome, cidade) VALUES 
    ('Companhia das Letras', 'São Paulo'), 
    ('Saraiva', 'São Paulo'), 
    ('Atlas', 'Rio de Janeiro'); 

    -- Livros 
    INSERT INTO livro (titulo, ano_publicacao, id_autor, id_editora) VALUES 
    ('O Senhor dos Anéis', 1954, 1, 1), 
    ('Dom Casmurro', 1899, 2, 2), 
    ('A Hora da Estrela', 1977, 3, 3), 
    ('O Hobbit', 1937, 1, 1); 

    -- Alunos 
    INSERT INTO aluno (nome, curso) VALUES 
    ('Ana Souza', 'Sistemas de Informação'), 
    ('Bruno Silva', 'Engenharia de Software'); -- Empréstimos 
    INSERT INTO emprestimo (data_emprestimo, id_aluno) VALUES 
    ('2025-08-20', 1), 
    ('2025-08-21', 2); 

    -- Empréstimo_Livro 
    INSERT INTO emprestimo_livro (id_emprestimo, id_livro) VALUES 
    (1, 1), 
    (1, 2), 
    (2, 3); 

    --EX1 
    SELECT 
        a.nome AS autor,
        (SELECT COUNT(*) 
        FROM livro l 
        WHERE l.id_autor = a.id_autor) AS total_livros,
        (SELECT AVG(l2.ano_publicacao) 
        FROM livro l2 
        WHERE l2.id_autor = a.id_autor) AS media_ano_publicacao
    FROM autor a;

    --EX2 
    WITH paginas_por_autor AS (
        SELECT 
            id_autor,
            SUM(ano_publicacao) AS soma_paginas
        FROM livro
        GROUP BY id_autor
    ),
    media_geral AS (
        SELECT AVG(soma_paginas) AS media_total
        FROM paginas_por_autor
    )
    SELECT 
        a.nome AS autor,
        p.soma_paginas
    FROM paginas_por_autor p
    JOIN autor a ON a.id_autor = p.id_autor
    WHERE p.soma_paginas > (SELECT media_total FROM media_geral);

    --EX3 version A
    SELECT 
        a.nome AS autor,
        (SELECT COUNT(*) 
        FROM livro l 
        WHERE l.id_autor = a.id_autor) AS total_livros
    FROM autor a;

    --version b
    WITH livros_por_autor AS (
        SELECT id_autor, COUNT(*) AS total_livros
        FROM livro
        GROUP BY id_autor
    )
    SELECT 
        a.nome AS autor,
        l.total_livros
    FROM autor a
    JOIN livros_por_autor l ON a.id_autor = l.id_autor;

