--Crie uma transação que aplique um aumento de salário para um determinado funcionário.

CREATE DATABASE atv_aula23out2025;
USE atv_aula23out2025;

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


BEGIN TRANSACTION;
UPDATE FUNCIONARIO set salario = salario + 100 WHERE ID_func = 3;
IF @@ROWCOUNT = 0
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Fucionario não encontrado';
END
ELSE
    BEGIN
        COMMIT TRANSACTION;
        PRINT 'Salário atualizado com sucesso';
    END

select * from FUNCIONARIO;

-- Exiba todos os dados do funcionário, o salário anterior e o atual.

DECLARE @ID_Funcionario INT = 2;
DECLARE @Aumento DECIMAL(10, 2) = 100.00;
DECLARE @SalarioAnterior DECIMAL(10, 2);

SELECT @SalarioAnterior = salario 
FROM FUNCIONARIO 
WHERE ID_func = @ID_Funcionario;

BEGIN TRANSACTION;

UPDATE FUNCIONARIO 
SET salario = salario + @Aumento 
WHERE ID_func = @ID_Funcionario;

IF @@ROWCOUNT = 0
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Funcionário não encontrado. Nenhuma alteração foi feita.';
END
ELSE
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Salário atualizado com sucesso.';
    
    SELECT 
        ID_func,
        nome_func,
        ID_Depto,
        @SalarioAnterior AS 'Salário Anterior', 
        salario AS 'Salário Atual'            
    FROM FUNCIONARIO
    WHERE ID_func = @ID_Funcionario;
END
