CREATE DATABASE aula23out2025;
USE aula23out2025;

CREATE TABLE DEPARTAMENTO (
    ID_Depto INT,
    NomeDepto VARCHAR(50),
    ID_Gerente INT,
    PRIMARY KEY (ID_Depto)
)

INSERT INTO Departamento (ID_Depto, NomeDepto, ID_Gerente) 
VALUES 
    (1, 'Vendas', 3), 
    (2, 'TI', 2), 
    (3, 'Logistica', 1)

CREATE TABLE FUNCIONARIO (
    ID_func int,
    nome_func varchar(50),
    salario decimal(10,2),
    ID_Depto int,
    primary key (ID_func),
    foreign key (ID_Depto) references DEPARTAMENTO (ID_Depto) 
)

INSERT INTO FUNCIONARIO VALUES
    (1,'JOSE DA SILVA', 8000, 3), 
    (2, 'CARLOS DOS SANTOS',9000,2), 
    (3,'REBECCA ANDRADE',10000,1)



--outra transação

BEGIN TRANSACTION
INSERT INTO Departamento (ID_Depto, NomeDepto,
ID_Gerente) VALUES (11, 'RH', 2);
SAVE TRANSACTION ponto1; --mudou o SAVEPOINT para somente SAVE
DELETE FROM Funcionario;
ROLLBACK TRANSACTION ponto1; --mudou o ROLLBACK sem o SAVEPOINT
UPDATE Funcionario SET salario = salario * 1.05
WHERE ID_Depto = 5;
COMMIT

SELECT * FROM funcionario;
SELECT * FROM Departamento;

--Inserir um novo funcionário e confirmar

BEGIN TRANSACTION;
INSERT INTO Funcionario VALUES (4, 'ANA SILVA', 7500, 1);
COMMIT TRANSACTION;


--Inserir um novo funcionário e desfazer
BEGIN TRANSACTION;
INSERT INTO Funcionario VALUES (5, 'BRUNO PEREIRA', 8500, 2); -- Não aparece e não da erro.
ROLLBACK TRANSACTION;

select * from FUNCIONARIO;

--Utilizar SAVEPOINT
BEGIN TRANSACTION;
INSERT INTO Funcionario VALUES (6, 'CAMILA OLIVEIRA', 9500, 3);
SAVE TRANSACTION Ponto1;
INSERT INTO Funcionario VALUES (7, 'DANIEL SANTOS', 10500, 1);  -- Não vai ser adicionado.
ROLLBACK TRANSACTION Ponto1;
COMMIT TRANSACTION;

    --Insere um funcionário (Camila)
    --Cria um ponto de restauração chamado "Ponto1".
    --Insere outro funcionário (Daniel).
    --Desfaz as alterações até o ponto "Ponto1". Isso significa que Daniel não será inserido, mas Camila será.
    --Confirma as alterações restantes (apenas Camila será inserida). 

--Atualizar o salário de um funcionário e verificar condições
BEGIN TRANSACTION;
UPDATE Funcionario SET Salario = 11000 WHERE ID_func = 1;  
IF @@ROWCOUNT = 0
BEGIN
 ROLLBACK TRANSACTION;
 PRINT 'Funcionário não encontrado';
END
ELSE
 BEGIN
  COMMIT TRANSACTION;
  PRINT 'Salário atualizado com sucesso';
 END

select * from FUNCIONARIO

    --Atualiza o salário de José da Silva para 11000.
    --Verifica se alguma linha foi afetada pela atualização.
    --Se nenhuma linha foi afetada (funcionário não encontrado), desfaz a transação.
    --Se alguma linha foi afetada, confirma as alterações.

