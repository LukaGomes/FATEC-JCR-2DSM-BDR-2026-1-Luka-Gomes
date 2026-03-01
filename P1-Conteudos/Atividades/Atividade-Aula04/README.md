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

INSERT INTO Localizacao VALUES
(5, -23.305, -45.965, 'Jacareí', 'SP');

INSERT INTO Evento VALUES
(1, 'Queimada em área de preservação',
 'Fogo se alastrando na mata próxima à represa.',
 '2025-08-15 14:35:00', 'Ativo', 1, 5);

INSERT INTO Usuario VALUES
(2, 'Maria Oliveira', 'maria.oliveira@email.com',
 '2b6c7f64f76b09d0a7b9e...');

INSERT INTO Relato VALUES
(1, 'Fumaça intensa e chamas visíveis a partir da rodovia.',
 '2025-08-15 15:10:00', 1, 2);

INSERT INTO Alerta VALUES
(1, 'Evacuação imediata da área próxima à represa.',
 '2025-08-15 15:20:00', 'Crítico', 1);

SELECT * FROM Evento;
SELECT * FROM TipoEvento;
SELECT * FROM Localizacao;
SELECT * FROM Usuario;
SELECT * FROM Relato;
SELECT * FROM Alerta;