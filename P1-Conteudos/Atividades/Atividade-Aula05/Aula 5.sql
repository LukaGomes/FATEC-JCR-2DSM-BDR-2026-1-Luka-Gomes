CREATE DATABASE clima_alerta;

CREATE TABLE TipoEvento (
    idTipoEvento INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT
);

CREATE TABLE Localizacao (
    idLocalizacao INT PRIMARY KEY,
    latitude DECIMAL(8,5),
    longitude DECIMAL(8,5),
    cidade VARCHAR(100),
    estado CHAR(2)
);

CREATE TABLE Evento (
    idEvento INT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descricao TEXT,
    dataHora TIMESTAMP,
    status VARCHAR(50),
    idTipoEvento INT REFERENCES TipoEvento(idTipoEvento),
    idLocalizacao INT REFERENCES Localizacao(idLocalizacao)
);

CREATE TABLE Usuario (
    idUsuario INT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    senhaHash VARCHAR(255) NOT NULL
);

CREATE TABLE Relato (
    idRelato INT PRIMARY KEY,
    texto TEXT NOT NULL,
    dataHora TIMESTAMP,
    idEvento INT REFERENCES Evento(idEvento),
    idUsuario INT REFERENCES Usuario(idUsuario)
);

CREATE TABLE Alerta (
    idAlerta INT PRIMARY KEY,
    mensagem TEXT NOT NULL,
    dataHora TIMESTAMP,
    nivel VARCHAR(20),
    idEvento INT REFERENCES Evento(idEvento)
);

CREATE TABLE HistoricoEvento (
    idHistorico INT PRIMARY KEY,
    idEvento INT REFERENCES Evento(idEvento),
    dataHora TIMESTAMP,
    statusAnterior VARCHAR(50),
    statusNovo VARCHAR(50)
);

INSERT INTO TipoEvento VALUES
(1, 'Queimada', 'Incêndio de grandes proporções em áreas urbanas ou rurais.');
(2, 'Enchente', 'Alagamento em áreas urbanas.'),
(3, 'Tempestade', 'Chuvas intensas com ventos fortes.');

INSERT INTO Localizacao VALUES
(5, -23.305, -45.965, 'Jacareí', 'SP');
(6, -23.55052, -46.63331, 'São Paulo', 'SP'),
(7, -22.90685, -43.17290, 'Rio de Janeiro', 'RJ');

INSERT INTO Evento VALUES
(1, 'Queimada em área de preservação',
 'Fogo se alastrando na mata próxima à represa.',
 '2025-08-15 14:35:00', 'Ativo', 1, 5);
(2, 'Enchente no centro da cidade',
 'Ruas alagadas após fortes chuvas.', 
 '2025-09-10 09:00:00', 'Ativo', 2, 6),
(3, 'Tempestade com queda de árvores',
 'Ventos fortes derrubaram árvores em vias públicas.', 
 '2025-11-20 18:45:00', 'Encerrado', 3, 7);

INSERT INTO Usuario VALUES
(2, 'Maria Oliveira', 'maria.oliveira@email.com', '2b6c7f64f76b09d0a7b9e');
(3, 'João Silva', 'joao.silva@email.com', 'a7b8c9d10e11f12g13h14'),
(4, 'Ana Costa', 'ana.costa@email.com', 'z1y2x3w4v5u6t7s8r9q0');

INSERT INTO Relato VALUES
(1, 'Fumaça intensa e chamas visíveis a partir da rodovia.', '2025-08-15 15:10:00', 1, 2);
(2, 'Carros submersos na enchente.', '2025-09-10 09:30:00', 2, 3),
(3, 'Árvore caída bloqueando avenida.', '2025-11-20 19:00:00', 3, 4);

INSERT INTO Alerta VALUES
(1, 'Evacuação imediata da área próxima à represa.', '2025-08-15 15:20:00', 'Crítico', 1);
(2, 'Evite transitar pelo centro devido à enchente.', '2025-09-10 09:15:00', 'Alto', 2),
(3, 'Risco de novos deslizamentos após tempestade.', '2025-11-20 19:10:00', 'Moderado', 3);

SELECT * FROM Evento;
SELECT * FROM TipoEvento;
SELECT * FROM Localizacao;
SELECT * FROM Usuario;
SELECT * FROM Relato;
SELECT * FROM Alerta;

SELECT idEvento, titulo, status FROM Evento;
SELECT idUsuario, nome, email FROM Usuario;


SELECT titulo, dataHora FROM Evento WHERE status = 'Ativo';
SELECT nome, email FROM Usuario WHERE email LIKE '%@email.com';

SELECT titulo, dataHora FROM Evento ORDER BY dataHora DESC;
SELECT nome, email FROM Usuario ORDER BY nome ASC;