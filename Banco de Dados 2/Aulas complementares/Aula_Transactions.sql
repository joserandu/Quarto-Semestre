------------------------------------------------------------------------
-- Transitions
-- Aula 30

-- BEGIN TRANSACTION  (Iniciando uma transaction)
-- ROLLBACK TRANSACTION (Desfazer uma transaction que está em andamento)
-- COMMIT (Commitar ou gravar os dados)

	-- Se começarmos uma transação e não fizermos o commit, os dados não
	-- são gravados no bd.
	-- A transaction cria um espaço na memória,
------------------------------------------------------------------------

-- DICA: para não apagar os dados de uma tabela principal, crie uma cópia
-- temporária:

-- SELECT * 
-- INTO tTEMP -- Tabela temporária
-- FROM ALUNOS 

-- Criação da tabela jogadores
CREATE TABLE tb_Jogadores_Corinthians(
	nome			VARCHAR(80),
	data_nascimento	VARCHAR(20),
	sexo			VARCHAR(1),
	data_cadastro	DATETIME,
	login_cadastro	DATETIME
);

DROP TABLE tb_Jogadores_Corinthians

INSERT INTO tb_Jogadores_Corinthians(nome, data_nascimento, sexo, data_cadastro, login_cadastro)
VALUES 
('Memphis Depay', '1993-05-14', 'M', DATEADD(DAY, -365, GETDATE()), GETDATE()),

('Cássio Ramos', '1987-06-06', 'M', DATEADD(DAY, -200, GETDATE()), GETDATE()),
('Fagner Conserva Lemos', '1989-06-11', 'M', DATEADD(DAY, -180, GETDATE()), GETDATE()),
('Maycon Souza', '1997-07-15', 'M', DATEADD(DAY, -150, GETDATE()), GETDATE()),
('Yuri Alberto Monteiro', '2001-03-18', 'M', DATEADD(DAY, -120, GETDATE()), GETDATE()),
('Gustavo Mosquito', '1997-06-20', 'M', DATEADD(DAY, -100, GETDATE()), GETDATE()),
('Giovane Santana', '2003-02-10', 'M', DATEADD(DAY, -90, GETDATE()), GETDATE()),
('Matheus Donelli', '2002-05-17', 'M', DATEADD(DAY, -60, GETDATE()), GETDATE()),
('Fausto Vera', '2000-03-26', 'M', DATEADD(DAY, -45, GETDATE()), GETDATE()),
('Raniele Almeida', '1997-12-31', 'M', DATEADD(DAY, -30, GETDATE()), GETDATE());

SELECT * 
	INTO tTEMP -- Tabela temporária
	FROM tb_Jogadores_Corinthians 

DROP TABLE tTEMP;

SELECT * FROM tTEMP;

-- TRANSACTION
BEGIN TRANSACTION;
	UPDATE tTEMP
		SET sexo = LOWER(sexo)
COMMIT;

-- Usando Rollback
BEGIN TRANSACTION;
	UPDATE tTEMP
		SET SEXO = UPPER(SEXO);
ROLLBACK;  -- Não atualiza

BEGIN TRANSACTION;
	DROP TABLE tTEMP;
ROLLBACK;

SELECT * FROM tTEMP;

-- Geralmente usamos transactions juntamente com procedures
DECLARE @TR1	VARCHAR(20);
	SELECT @TR1 = 'Transação Delete';

BEGIN TRANSACTION @TR1;  -- Podemos nomear as nossas transactions

	DELETE FROM tTEMP
		WHERE NOME LIKE 'G%';

COMMIT TRANSACTION @TR1;

SELECT * FROM tTEMP;

--------------

IF OBJECT_ID('TabelaTeste', 'U') is not null
	DROP TABLE TabelaTeste;
GO

CREATE TABLE TabelaTeste (
	ID int PRIMARY KEY, 
	LETRA CHAR(1)
);
GO

-- Iniciar a variável de controle de transactions @@TRANSCOUNT PARA 1

BEGIN TRANSACTION TR1;
	PRINT 'Transaction : contador depois do BEGIN = ' + CAST(@@TRANCOUNT AS NVARCHAR(10));  -- A variável @@trancount mostra quantas transactions estão abertas. 
	INSERT INTO TabelaTeste VALUES (1, 'A');

BEGIN TRANSACTION TR2;
	PRINT 'Transaction : contador depois do 2º BEGIN = ' + CAST(@@TRANCOUNT AS NVARCHAR(10));
	INSERT INTO TabelaTeste VALUES (2, 'B');

BEGIN TRANSACTION TR3;
	PRINT 'Transaction: contador depois do 3º BEGIN = ' + CAST(@@TRANCOUNT AS NVARCHAR(10));
	INSERT INTO TabelaTeste VALUES (3, 'C')

COMMIT TRANSACTION TR2;
	PRINT 'Transaction: contador depois do COMMIT = ' + CAST(@@TRANCOUNT AS NVARCHAR(10));

COMMIT TRANSACTION TR1;
	PRINT 'Transaction: contador depois do COMMIT = ' + CAST(@@TRANCOUNT AS NVARCHAR(10));

COMMIT TRANSACTION TR3;
	PRINT 'Transaction: contador depois do COMMIT = ' + CAST(@@TRANCOUNT AS NVARCHAR(10));

SELECT * FROM TabelaTeste;

-- NVARCHAR (PARA CARACTERES ESPECIAIS)

DECLARE @a VARCHAR(20) = '✅';
DECLARE @b NVARCHAR(20) = N'✅';

SELECT @a AS TextoVarchar, @b AS TextoNvarchar;
