------------------------------------------------------------------------
-- Exercício 1 — Controle de Inserções com Rollback

/* Crie uma tabela chamada tbFuncionarios com os campos:

	ID (inteiro, chave primária)
	NOME (varchar(80))
	SALARIO (decimal(10,2))

Depois:

	1. Inicie uma transaction.
	2. Insira três funcionários (ex: Ana, Bruno e Carla).
	3. Antes de dar o COMMIT, execute um SELECT * FROM tbFuncionarios; e observe o resultado.
	4. Depois use ROLLBACK e execute novamente o SELECT.

🔹 Objetivo: observar a diferença entre dados dentro e fora de uma transação antes do commit.*/
------------------------------------------------------------------------

CREATE TABLE tbFuncionarios (
	ID		INT PRIMARY KEY,
	NOME	VARCHAR(80),
	SALARIO	DECIMAL(10,2)
);
GO

DROP TABLE tbFuncionarios;

DECLARE @TR1	VARCHAR(20);

-- 1
BEGIN TRANSACTION @TR1;
	-- 2
	INSERT INTO tbFuncionarios(ID, NOME, SALARIO) VALUES (1, 'Ana', 1000), (2, 'Bruno', 2000), (3, 'Carla', 3000);

	-- 3
	SELECT * FROM tbFuncionarios;

-- 4
DECLARE @TR1	VARCHAR(20);
ROLLBACK TRANSACTION @TR1;

SELECT * FROM tbFuncionarios;

------------------------------------------------------------------------
-- Exercício 2 — Controle de Atualizações com Commit e Rollback

/* Usando a tabela tbFuncionarios do exercício anterior:

	1. Inicie uma transaction.
	2. Aumente o salário de todos os funcionários em 10%.
	3. Antes de dar o COMMIT, execute o SELECT * e veja a diferença.
	4. Execute o ROLLBACK e verifique que os salários voltaram ao valor original.
	5. Depois, repita o processo e confirme com COMMIT.

🔹 Objetivo: entender como rollback e commit afetam alterações permanentes. */
------------------------------------------------------------------------

-- 1
BEGIN TRANSACTION;
	-- 2
	UPDATE tbFuncionarios
		SET SALARIO = SALARIO * 1.1;
	-- 3
	SELECT * FROM tbFuncionarios;
-- 4
ROLLBACK;
SELECT * FROM tbFuncionarios;

-- 4
BEGIN TRANSACTION;

	UPDATE tbFuncionarios
		SET SALARIO = SALARIO * 1.1;

	SELECT * FROM tbFuncionarios;
COMMIT TRANSACTION;

SELECT * FROM tbFuncionarios;

-- Exercício 3 — Transações aninhadas e @@TRANCOUNT

/* Crie uma tabela simples chamada tbControle:

		CREATE TABLE tbControle (
			ID INT PRIMARY KEY,
			DESCRICAO VARCHAR(50)
		);

Em seguida:

	1. Inicie a transação principal (TR1) e insira um registro.
	2. Dentro dela, inicie uma segunda transação (TR2), insira outro registro e use PRINT para mostrar o valor de @@TRANCOUNT.
	3. Faça um COMMIT TRANSACTION TR2 e observe novamente o contador.
	4. Dê o ROLLBACK da transação principal (TR1).
	5. Por fim, veja o conteúdo da tabela com SELECT * FROM tbControle.

🔹 Objetivo: entender o comportamento das transações aninhadas e o contador @@TRANCOUNT.
*/

CREATE TABLE tbControle (
	ID INT PRIMARY KEY,
	DESCRICAO VARCHAR(50)
);
GO

DELETE tbControle WHERE ID = 1;

-- 1
DECLARE @TR1	VARCHAR(20);

BEGIN TRANSACTION @TR1;
	INSERT INTO tbControle(ID, DESCRICAO) VALUES (1, 'Transaction 1');

	-- 2  
	DECLARE @TR2	VARCHAR(20);

	BEGIN TRANSACTION @TR2;
		INSERT INTO tbControle(ID, DESCRICAO) VALUES (2, 'Transaction 2');
		PRINT 'Valor de @@TRANCOUNT = ' + CAST(@@TRANCOUNT AS NVARCHAR(10));  -- (Valor de @@TRANCOUNT = 2)

	-- 3
	COMMIT TRANSACTION @TR2;
		PRINT 'Valor de @@TRANCOUNT = ' + CAST(@@TRANCOUNT AS NVARCHAR(10));  -- (Valor de @@TRANCOUNT = 1)

-- 4
ROLLBACK TRANSACTION @TR1;

-- 5
SELECT * FROM tbControle;
