DROP TABLE IF EXISTS carro, pessoa; 
CREATE TABLE IF NOT EXISTS pessoa ( 
id_pessoa INTEGER PRIMARY KEY, 
nome VARCHAR(100) NOT NULL, 
nascimento DATE 
);

INSERT INTO pessoa (nome, idade, nascimento)
SELECT
    'Pessoa ' || g,
    (RANDOM() * 80)::INT,
    DATE '1950-01-01' + (RANDOM() * 25000)::INT
FROM generate_series(1, 100000) g;

EXPLAIN ANALYZE 
SELECT * 
FROM pessoa 
WHERE nome = 'Ana Silva';

EXPLAIN ANALYZE 
SELECT * 
FROM pessoa 
WHERE nome = 'João Santos';

CREATE INDEX idx_pessoa_nome 
ON pessoa (nome);

DROP INDEX IF EXISTS idx_pessoa_nome;

EXPLAIN ANALYZE 
SELECT * 
FROM pessoa 
WHERE nascimento >= DATE '1970-01-01';

CREATE INDEX idx_pessoa_nascimento
ON pessoa (nascimento);

DROP INDEX IF EXISTS idx_pessoa_nascimento;

EXPLAIN ANALYZE 
SELECT * 
FROM pessoa 
WHERE nascimento >= DATE '2000-01-01' 
AND nome = 'Ana Silva';

CREATE INDEX idx_pessoa_nascimento_nome 
ON pessoa (nascimento, nome);

EXPLAIN ANALYZE 
SELECT * 
FROM pessoa 
WHERE nome = 'Ana Silva';

DROP INDEX IF EXISTS idx_pessoa_nascimento_nome;

CREATE INDEX idx_pessoa_nascimento 
ON pessoa (nascimento); 
CREATE INDEX idx_pessoa_nome 
ON pessoa (nome);

EXPLAIN ANALYZE 
SELECT * 
FROM pessoa 
WHERE nascimento >= DATE '2000-01-01' 
AND nome = 'Ana Silva';


CREATE TABLE IF NOT EXISTS carro ( 
id_carro INTEGER PRIMARY KEY, 
placa CHAR(7) NOT NULL, 
ano INTEGER, 
id_pessoa INTEGER NOT NULL, 
FOREIGN KEY (id_pessoa) 
REFERENCES pessoa(id_pessoa) 
ON DELETE CASCADE 
);

CREATE INDEX idx_carro_ano ON carro(ano);

EXPLAIN ANALYZE 
SELECT * 
FROM carro 
WHERE ano BETWEEN 2015 AND 2020;

CREATE INDEX idx_pessoa_nome ON pessoa(nome);

CREATE INDEX idx_carro_id_pessoa ON carro(id_pessoa);

EXPLAIN ANALYZE 
SELECT p.nome, c.placa
FROM pessoa p 
JOIN carro c ON p.id_pessoa = c.id_pessoa 
WHERE p.nome = 'Ana Silva';

CREATE INDEX idx_pessoa_nascimento ON pessoa(nascimento);

CREATE INDEX idx_carro_idpessoa_ano ON carro(id_pessoa, ano);

EXPLAIN ANALYZE 
SELECT p.nome, c.placa, c.ano 
FROM pessoa p 
JOIN carro c ON p.id_pessoa = c.id_pessoa 
WHERE p.nascimento >= DATE '1980-01-01' 
AND c.ano >= 2018;

EXPLAIN ANALYZE 
SELECT * 
FROM pessoa 
WHERE nascimento BETWEEN DATE '1980-01-01' AND DATE '1990-12-31';

CREATE EXTENSION IF NOT EXISTS btree_gist;

CREATE INDEX idx_pessoa_nascimento_gist 
ON pessoa 
USING GIST (nascimento);

SELECT indexname, indexdef 
FROM pg_indexes 
WHERE tablename = 'pessoa';