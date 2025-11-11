-------------------------------------------------------------------
-- Exercício 1 — View de Produtos e Estoque

-- Crie uma view que mostre o nome do produto, o saldo atual e a 
-- última data de movimentação.
-------------------------------------------------------------------


CREATE VIEW VW_MOSTRA_PRODUTO_SALDO_DATA_ULTIMA_MOVIMENTACAO AS
	SELECT 
		C.PRODUTO,
		S.SALDO_ANTERIOR,
		S.NOVO_SALDO
	FROM tbCompras C
	JOIN  tbSaldos S
	ON 
		C.PRODUTO = S.NOVO_SALDO; -- Não é possível juntar, porque a tabela de saldos não mostra nenhum produto.
				
SELECT * FROM VW_MOSTRA_PRODUTO_SALDO_DATA_ULTIMA_MOVIMENTACAO;

DROP VIEW VW_MOSTRA_PRODUTO_SALDO_DATA_ULTIMA_MOVIMENTACAO;

-------------------------------------------------------------------
-- EXERCÍCIO 2 — View de Total de Vendas por Produto

-- Crie uma view que mostre o total de vendas por produto.
-------------------------------------------------------------------

CREATE TABLE tbVendas (
	ID_VENDA INT IDENTITY PRIMARY KEY,
	PRODUTO VARCHAR(50),
	QUANTIDADE INT,
	PRECO_UNIT DECIMAL(10,2)
);

-- Inserindo dados de exemplo
INSERT INTO tbVendas (PRODUTO, QUANTIDADE, PRECO_UNIT) VALUES
('Produto A', 3, 50),
('Produto A', 2, 50),
('Produto B', 1, 70),
('Produto B', 4, 70);

SELECT * FROM tbVendas;

CREATE VIEW TOTAL_DE_VENDAS_POR_PRODUTO AS
SELECT 
	V.PRODUTO,
	SUM(V.QUANTIDADE) AS QUANTIDADE_TOTAL,
	SUM(V.QUANTIDADE * V.PRECO_UNIT) AS LUCRO_TOTAL
FROM tbVendas V
GROUP BY PRODUTO;
GO

SELECT * FROM TOTAL_DE_VENDAS_POR_PRODUTO;

DROP VIEW TOTAL_DE_VENDAS_POR_PRODUTO;

SELECT * FROM tbCompras;

-------------------------------------------------------------------
-- EXERCÍCIO 3 — View de Vendas Recentes

-- Crie uma view que mostre apenas as vendas realizadas nos últimos 7 dias.
-------------------------------------------------------------------

CREATE TABLE tbHistoricoVendas (
	ID INT IDENTITY PRIMARY KEY,
	PRODUTO VARCHAR(50),
	QUANTIDADE INT,
	DATA_VENDA DATETIME
);

-- Inserindo dados de exemplo
INSERT INTO tbHistoricoVendas (PRODUTO, QUANTIDADE, DATA_VENDA) VALUES
('Produto A', 2, DATEADD(DAY, -2, GETDATE())),   -- há 2 dias
('Produto B', 1, DATEADD(DAY, -10, GETDATE())),  -- há 10 dias
('Produto C', 3, GETDATE());

SELECT * FROM tbHistoricoVendas;

CREATE VIEW VW_VENDAS_NOS_ULTIMOS_SETE_DIAS AS
SELECT
	H.PRODUTO,
	H.DATA_VENDA
FROM
	tbHistoricoVendas H
WHERE 
	H.DATA_VENDA >= DATEADD(DAY, -7, GETDATE());

DROP VIEW VW_VENDAS_NOS_ULTIMOS_SETE_DIAS;

SELECT * FROM VW_VENDAS_NOS_ULTIMOS_SETE_DIAS;
