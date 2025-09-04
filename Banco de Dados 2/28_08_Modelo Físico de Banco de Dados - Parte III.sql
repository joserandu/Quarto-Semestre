CREATE DATABASE db_orquestras;
USE db_orquestras;
-- a) Crie o banco de dados, tabelas e relacionamentos necessários
CREATE Table orchestras (
orchestra_id int PRIMARY KEY IDENTITY(0,1),
name VARCHAR(32),
rating DECIMAL,
city_origin VARCHAR(32),
country_origin VARCHAR(32),
year INT
);
CREATE Table concerts (
id INT PRIMARY KEY IDENTITY(0,1),
city VARCHAR(64),
country VARCHAR(32),
year INT,
rating DECIMAL,
fk_orchestra_id INT REFERENCES orchestras(orchestra_id)
);
CREATE Table members (
id INT PRIMARY KEY IDENTITY(0,1),
name VARCHAR(32),
position VARCHAR(32),
wage INT,
experience INT,
fk_orchestra_id int REFERENCES orchestras(orchestra_id)
);
SELECT * FROM orchestras;
SELECT * FROM concerts;
SELECT * FROM members;
-- b) Insira 2 tuplas em cada tabela
-- Inserir dados na tabela orchestras
INSERT INTO orchestras (name, rating, city_origin, country_origin, year) VALUES
('Symphony Orchestra', 4.5, 'New York', 'USA', 1850),
('Royal Philharmonic', 4.8, 'London', 'UK', 1940);
-- Inserir dados na tabela concerts
INSERT INTO concerts (city, country, year, rating, fk_orchestra_id) VALUES
('New York', 'USA', 2024, 4.7, 0),
('London', 'UK', 2024, 4.6, 1);
-- Inserir dados na tabela members
INSERT INTO members (name, position, wage, experience, fk_orchestra_id) VALUES
('John Doe', 'Conductor', 5000, 10, 0),
('Jane Smith', 'Violinist', 3000, 5, 1);
SELECT * FROM orchestras;
SELECT * FROM concerts;
SELECT * FROM members;
-- c) Retorne os nomes de todas as orquestras que tenham a mesma cidade de origem
de qualquer cidade em que alguma orquestra tenha se apresentado em 2024.
SELECT DISTINCT o.name
FROM orchestras AS o
JOIN concerts AS c ON o.city_origin = c.city
WHERE c.year = 2024;
-- d) Selecione os nomes e as posições (ou seja, o instrumento tocado) de todos os
membros da orquestra que tenham mais de 10 anos de experiência e não pertençam a
orquestras com classificação inferior a 8,0.
SELECT DISTINCT m.name, m.position
FROM members AS m, orchestras AS o
WHERE m.experience > 10
AND o.rating >= 8;
-- e) Mostre o nome e a posição dos membros da orquestra que ganham mais do que o
salário médio de todos os violinistas.
SELECT m.name, m.position
FROM members AS m
WHERE m.wage > (
SELECT AVG(m2.wage)
FROM members AS m2
WHERE m2.position = 'Violinist'
);
-- f) Mostre os nomes das orquestras que foram criadas depois da "Orquestra
Paulistana" e que têm uma classificação maior que 7,5.
INSERT INTO orchestras (name, rating, city_origin, country_origin, year) VALUES
('Orquestra Paulistana', 5.5, 'São Paulo', 'Brazil', 1950);
SELECT o.name
FROM orchestras AS o
WHERE o.year > (
SELECT o2.year
FROM orchestras AS o2
WHERE o2.name = 'Orquestra Paulistana'
)
AND o.rating > 7.5;
