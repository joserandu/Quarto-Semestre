-- Aula 37
-- Assunto: TRIGGERS (Gatilhos)
-- --------------------------------------------
-- Uma trigger é um bloco de código SQL que é executado automaticamente
-- em resposta a um evento (INSERT, UPDATE ou DELETE) em uma tabela.
-- Elas são muito usadas para manter integridade de dados e automatizar processos.

-------------------------------------------------------------------
-- 1️ Criação da tabela de saldos
-------------------------------------------------------------------
CREATE TABLE tbSaldos(
	PRODUTO			VARCHAR(10),   -- Nome do produto
	SALDO_INICIAL	NUMERIC(10),   -- Saldo inicial (quantidade inicial em estoque)
	SALDO_FINAL		NUMERIC(10),   -- Saldo final (atualizado conforme as vendas)
	DATA_ULT_MOV	DATETIME       -- Data da última movimentação
);
GO

-- Inserindo um produto inicial com saldo
INSERT INTO tbSaldos(PRODUTO, SALDO_INICIAL, SALDO_FINAL, DATA_ULT_MOV)
	VALUES('Produto A', 0, 100, GETDATE());
GO

-------------------------------------------------------------------
-- 2️ Criação da tabela de vendas
-------------------------------------------------------------------
CREATE TABLE tbVendas (
	ID_VENDAS	INT,          -- ID da venda
	PRODUTO		VARCHAR(10),  -- Produto vendido
	QUANTIDADE	INT,          -- Quantidade vendida
	DATA		DATETIME      -- Data da venda
);
GO

-------------------------------------------------------------------
-- 3️ Criação de uma SEQUENCE
-- A SEQUENCE gera valores numéricos automáticos (como um auto_increment).
-------------------------------------------------------------------
CREATE SEQUENCE seq_tbVendas
	AS NUMERIC
	START WITH 1
	INCREMENT BY 1;
GO

-------------------------------------------------------------------
-- 4️ Criação da tabela de histórico de vendas
-- Ela guardará um registro de cada venda efetuada.
-------------------------------------------------------------------
CREATE TABLE tbHistoricoVendas (
	PRODUTO		VARCHAR(10),
	QUANTIDADE	INT,
	DATA_VENDA	DATETIME
);
GO

-------------------------------------------------------------------
-- 5️ Criação da TRIGGER
-- A trigger será executada automaticamente após cada INSERT em tbVendas.
-------------------------------------------------------------------
CREATE TRIGGER trg_AjustaSaldo
ON tbVendas
FOR INSERT      -- Tipo da trigger: executa após uma inserção na tabela tbVendas
AS
BEGIN
	-- Declaração de variáveis locais para capturar os valores da linha inserida
	DECLARE @QUANTIDADE		INT,
			@DATA			DATETIME,
			@PRODUTO		VARCHAR(10);

	-- A pseudo-tabela INSERTED guarda os dados recém inseridos.
	-- Aqui, pegamos os valores da nova venda.
	SELECT @DATA = DATA, 
		   @QUANTIDADE = QUANTIDADE, 
		   @PRODUTO = PRODUTO
	FROM INSERTED;

	-- Atualiza o saldo do produto subtraindo a quantidade vendida
	UPDATE tbSaldos
		SET SALDO_FINAL = SALDO_FINAL - @QUANTIDADE,
			DATA_ULT_MOV = @DATA
		WHERE PRODUTO = @PRODUTO;  -- Garante que só o produto correspondente será atualizado.

	-- Registra a venda no histórico
	INSERT INTO tbHistoricoVendas(PRODUTO, QUANTIDADE, DATA_VENDA)
		VALUES (@PRODUTO, @QUANTIDADE, @DATA);
END 
GO

-------------------------------------------------------------------
-- 6️ Inserindo uma venda (a trigger será disparada automaticamente)
-------------------------------------------------------------------
INSERT INTO tbVendas(ID_VENDAS, PRODUTO, QUANTIDADE, DATA)
	VALUES (NEXT VALUE FOR seq_tbVendas, 'Produto A', 2, GETDATE());

-------------------------------------------------------------------
-- 7️ Consultando as tabelas para ver os resultados
-------------------------------------------------------------------
SELECT * FROM tbVendas;           -- Deve mostrar a venda feita
SELECT * FROM tbSaldos;           -- Deve mostrar o saldo final atualizado
SELECT * FROM tbHistoricoVendas;  -- Deve mostrar o registro da venda feita

-------------------------------------------------------------------
-- 8️ Comando de limpeza (exclusão de objetos)
-- Use apenas se quiser refazer o exercício do zero.
-------------------------------------------------------------------
DROP TABLE tbVendas;
DROP TABLE tbSaldos;
DROP TABLE tbHistoricoVendas;
DROP SEQUENCE seq_tbVendas;
