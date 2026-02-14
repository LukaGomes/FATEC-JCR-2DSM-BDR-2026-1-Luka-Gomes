Create database queimadas_db;

Create table focos_calor(
id serial primary key,
estado varchar(50),
bioma varchar(50),
data_ocorrencia date
);

insert into focos_calor(estado,bioma,data_ocorrencia)values
('Amazonas','Amazônia','2025-02-01'),
('Mato Grosso','Cerrado','2025-02-03'),
('Pará','Amazônia','2025-02-05');

select*from focos_calor;