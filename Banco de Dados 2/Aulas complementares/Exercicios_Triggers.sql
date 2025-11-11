-------------------------------------------------------------------
-- EXERCÍCIO 1 - Controle de compras

-- Crie uma tabela tbCompras e uma trigger que aumente o saldo da 
-- tabela tbSaldos sempre que uma nova compra for registrada 
-- (ou seja, ao inserir uma nova compra).
-------------------------------------------------------------------

CREATE DATABASE ExTriggers;
USE ExTriggers;

CREATE TABLE tbCompras(
	PRODUTO		VARCHAR(50),
	PRECO		DECIMAL(5,2)
);

CREATE TABLE tbSaldos(
	SALDO_ANTERIOR	DECIMAL(5,2),
	NOVO_SALDO		DECIMAL(5,2)
);

-- Declaração da trigger
CREATE TRIGGER trg_AtualizaSaldo
ON tbCompras
FOR INSERT
AS
BEGIN

	-- Declaração das variáveis
	DECLARE @PRODUTO	VARCHAR(50),
			@PRECO		DECIMAL(5,2);
	
	-- Atribuição de valores
	SELECT @PRECO = PRECO,
			@PRODUTO = PRODUTO
		FROM INSERTED;

	-- Atualização da tbSaldos
	UPDATE tbSaldos
		SET SALDO_ANTERIOR = NOVO_SALDO,
			NOVO_SALDO = NOVO_SALDO + @PRECO;

END
GO

INSERT INTO tbSaldos(SALDO_ANTERIOR, NOVO_SALDO)
	VALUES (0, 0);

INSERT INTO tbCompras(PRODUTO, PRECO)
	VALUES ('Produto 1', 100.00);

SELECT * FROM tbCompras;
SELECT * FROM tbSaldos;

-------------------------------------------------------------------
-- Exercício 2 — Auditoria de Exclusões

-- Crie uma tabela tbAuditoriaVendas e uma trigger que registre 
-- automaticamente o produto e a data sempre que uma venda for excluída 
-- da tabela tbVendas.
-------------------------------------------------------------------

CREATE TABLE tbVendas (
	ID_VENDAS	INT,          -- ID da venda
	PRODUTO		VARCHAR(10),  -- Produto vendido
	QUANTIDADE	INT,          -- Quantidade vendida
	DATA		DATETIME      -- Data da venda
);
GO

CREATE TABLE tbAuditoriaVendas(
	PRODUTO	VARCHAR(50),
	DATA	DATETIME
);
GO

CREATE TRIGGER trg_atualiza_tbAuditoriaVendas
ON tbVendas
AFTER DELETE
AS
BEGIN
	
	DECLARE @PRODUTO	VARCHAR(50),
			@DATA		DATETIME;

	SELECT @PRODUTO = PRODUTO,
		   @DATA = DATA
	FROM DELETED;
  	
	INSERT INTO tbAuditoriaVendas(PRODUTO, DATA)
		VALUES (@PRODUTO, @DATA);

END
GO

DELETE FROM tbVendas
WHERE PRODUTO = 'Produto A';

SELECT * FROM tbVendas;
SELECT * FROM tbAuditoriaVendas;

-------------------------------------------------------------------
-- 3️º Exercício — Validação de Estoque

-- Crie uma trigger que impessa a inserção de uma venda (em tbVendas) 
-- caso o produto não tenha saldo suficiente em tbSaldos.
-- (Dica: use a pseudo-tabela INSERTED e o comando ROLLBACK 
-- TRANSACTION dentro da trigger).
-------------------------------------------------------------------

CREATE TRIGGER trg_impedir_inserção_tbVendas
FOR tbVendas
