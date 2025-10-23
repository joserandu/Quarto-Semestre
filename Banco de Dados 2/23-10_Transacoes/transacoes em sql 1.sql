CREATE DATABASE aula12dez2024;
use aula12dez2024;

create table tbl_editora( 
    id_editora int, 
    nome_editora varchar(50), 
    primary key(id_editora)
)

insert into tbl_editora values (1,'ABC'), (2,'CEU AZUL'),(3,'FONTE')

CREATE TABLE TBL_AUTOR( id_autor int,
    nome_autor varchar(50),
    id_editora int, primary key(id_autor),
    foreign key(id_editora) references tbl_editora(id_editora)
)

insert into tbl_autor values (11,'Bill Gates',1),
(22,'Steve Jobs',1),(33,'ELMASRI, Ramez',2)

CREATE TABLE tbl_livro ( id_livro int,
    nome_livro varchar(100),
    valor_livro decimal(10,2),
    quantidade int,
    id_editora int,
    id_autor int,
    primary key(id_livro),
    foreign key(id_editora)
    references tbl_editora(id_editora),
    foreign key(id_autor) references tbl_autor(id_autor)
)

insert into tbl_livro values (111,'Como Ser Milionario',120.00,10,1,11),
(222,'New Era',85.00,20,2,22),
(333,'Banco de Dados', 98.00,30,3,33),
(444,'Modelagem de Dados', 65.00,25,3,33)

create table tbl_venda (id_livro int,
    quantidade int,
    data_venda datetime,
    primary key (id_livro)
)


select * from TBL_AUTOR
select * from tbl_editora
select * from tbl_livro
select * from tbl_venda

-- veja um exemplo de uma Transação que envolve a Venda de um Livro:
BEGIN TRANSACTION;
-- Verifica se o livro está em estoque
SELECT * FROM tbl_livro l WHERE id_livro = 111 AND quantidade > 0;

-- Atualiza a quantidade em estoque
UPDATE tbl_livro SET quantidade = quantidade - 1 WHERE id_livro = 111;

-- Insere um registro na tabela de vendas
INSERT INTO tbl_venda (id_livro, quantidade, data_venda)
VALUES (222, 1, GETDATE());   -- Quando colocamos um id que não existe, como esse, ele não dá erro, só não executa.

COMMIT TRANSACTION;
