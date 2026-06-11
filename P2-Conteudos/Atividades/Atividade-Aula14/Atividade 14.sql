-- Atividade 14
-- EXERCÍCIO 1 – Lógica e Condição
-- Insere livro SOMENTE se o autor existir

CREATE OR REPLACE PROCEDURE sp_inserir_livro_seguro(
    p_titulo         VARCHAR,
    p_num_paginas    INT,
    p_ano_publicacao INT,
    p_id_autor       INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_existe INT;
BEGIN
    -- Verifica se o autor existe
    SELECT COUNT(*) INTO v_existe
    FROM autor
    WHERE id_autor = p_id_autor;

    IF v_existe = 0 THEN
        RAISE EXCEPTION 'Autor com id % não encontrado. Cadastre o autor antes de inserir o livro.', p_id_autor;
    END IF;

    INSERT INTO livro (titulo, num_paginas, ano_publicacao, id_autor)
    VALUES (p_titulo, p_num_paginas, p_ano_publicacao, p_id_autor);

    RAISE NOTICE 'Livro "%" inserido com sucesso!', p_titulo;
END;
$$;

-- Testes Exercício 1:
CALL sp_inserir_livro_seguro('Esaú e Jacó', 280, 1904, 1);
-- Erro (autor id=99 não existe):
CALL sp_inserir_livro_seguro('Livro Fantasma', 100, 2020, 99);


-- EXERCÍCIO 2 – Atualização com regra

CREATE OR REPLACE PROCEDURE sp_atualizar_paginas(
    p_id_livro    INT,
    p_num_paginas INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_num_paginas <= 10 THEN
        RAISE EXCEPTION 'Número de páginas inválido: %. O valor deve ser maior que 10.', p_num_paginas;
    END IF;

    UPDATE livro
    SET num_paginas = p_num_paginas
    WHERE id_livro = p_id_livro;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Livro com id % não encontrado.', p_id_livro;
    END IF;

    RAISE NOTICE 'Páginas do livro id % atualizadas para %.', p_id_livro, p_num_paginas;
END;
$$;

-- Testes Exercício 2:
CALL sp_atualizar_paginas(1, 300);
-- Erro (valor <= 10):
CALL sp_atualizar_paginas(1, 5);


-- EXERCÍCIO 3 – Operação composta

CREATE OR REPLACE PROCEDURE sp_excluir_autor(
    p_id_autor INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_livros INT;
BEGIN
    -- Verifica se o autor possui livros
    SELECT COUNT(*) INTO v_total_livros
    FROM livro
    WHERE id_autor = p_id_autor;

    IF v_total_livros > 0 THEN
        RAISE EXCEPTION 'Não é possível excluir o autor id %. Ele possui % livro(s) cadastrado(s).', p_id_autor, v_total_livros;
    END IF;

    DELETE FROM autor WHERE id_autor = p_id_autor;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Autor com id % não encontrado.', p_id_autor;
    END IF;

    RAISE NOTICE 'Autor id % excluído com sucesso.', p_id_autor;
END;
$$;

-- Testes Exercício 3:
CALL sp_excluir_autor(1);
-- Sucesso (inserir autor sem livros e excluir):
INSERT INTO autor (nome) VALUES ('Autor Teste');
CALL sp_excluir_autor(5);


-- EXERCÍCIO 4 – Procedure com cálculo

CREATE OR REPLACE PROCEDURE sp_media_paginas_autor(
    p_id_autor INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_existe INT;
BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM autor
    WHERE id_autor = p_id_autor;

    IF v_existe = 0 THEN
        RAISE EXCEPTION 'Autor com id % não encontrado.', p_id_autor;
    END IF;

    -- Retorna resultado via SELECT
    SELECT
        a.nome                        AS autor,
        ROUND(AVG(l.num_paginas), 2)  AS media_paginas
    FROM autor a
    JOIN livro l ON l.id_autor = a.id_autor
    WHERE a.id_autor = p_id_autor
    GROUP BY a.nome;
END;
$$;

-- Teste Exercício 4:
CALL sp_media_paginas_autor(1);


-- EXERCÍCIO 5 – DESAFIO

CREATE OR REPLACE PROCEDURE sp_inserir_livro_completo(
    p_titulo         VARCHAR,
    p_num_paginas    INT,
    p_ano_publicacao INT,
    p_id_autor       INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_existe INT;
BEGIN
    -- Validação 1: título não pode ser vazio
    IF TRIM(p_titulo) = '' OR p_titulo IS NULL THEN
        RAISE EXCEPTION 'O título do livro não pode ser vazio.';
    END IF;

    -- Validação 2: páginas deve ser maior que 0
    IF p_num_paginas <= 0 THEN
        RAISE EXCEPTION 'Número de páginas inválido: %. O valor deve ser maior que 0.', p_num_paginas;
    END IF;

    -- Validação 3: autor deve existir
    SELECT COUNT(*) INTO v_existe
    FROM autor
    WHERE id_autor = p_id_autor;

    IF v_existe = 0 THEN
        RAISE EXCEPTION 'Autor com id % não encontrado. Cadastre o autor antes de inserir o livro.', p_id_autor;
    END IF;

    -- Tudo válido: realiza o INSERT
    INSERT INTO livro (titulo, num_paginas, ano_publicacao, id_autor)
    VALUES (p_titulo, p_num_paginas, p_ano_publicacao, p_id_autor);

    RAISE NOTICE 'Livro "%" inserido com sucesso!', p_titulo;
END;
$$;

-- Testes Exercício 5:
CALL sp_inserir_livro_completo('O Alienista', 96, 1882, 1);
-- Erro - título vazio:
CALL sp_inserir_livro_completo('', 96, 1882, 1);
-- Erro - páginas <= 0:
CALL sp_inserir_livro_completo('O Alienista', 0, 1882, 1);
-- Erro - autor inexistente:
CALL sp_inserir_livro_completo('O Alienista', 96, 1882, 99);


-- EXERCÍCIO 6 – DESAFIO

-- Tentativa de inserir com páginas negativas (será bloqueado):
CALL sp_inserir_livro_completo('Livro Inválido', -50, 2024, 1);

-- O bloco abaixo demonstra explicitamente o bloqueio para fins didáticos:

DO $$
BEGIN
    RAISE NOTICE '--- EXERCÍCIO 6: Tentando inserir livro com páginas negativas (-50) ---';
    CALL sp_inserir_livro_completo('Livro Páginas Negativas', -50, 2024, 1);
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'BLOQUEADO PELA PROCEDURE: %', SQLERRM;
END;
$$;