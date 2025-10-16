--a partir do banco de dados bd_vendas
select * from tb_cliente
select * from tb_venda
select * from tb_NotaFiscal

--crie uma view retornado os dados do cliente, e as notas fiscais de compras feitas por eles,
--agrupando por cliente
use bd_vendas

GO
create VIEW viewClintes AS
Select
c.nome as Nome,
COUNT(n.pk_notafiscal) as Quantidade_Nota_Fiscal
FROM tb_NotaFiscal as n
JOIN tb_venda as v on n.fk_venda = v.pk_venda
JOIN tb_cliente as c on c.pk_cliente = v.fk_cliente
GROUP by c.nome
GO

SELECT * FROM viewClintes


-- outro exemplo
go
CREATE VIEW vw_ClientesComResumoVendas AS
SELECT
c.pk_cliente AS ID_Cliente,
c.nome AS Nome_Cliente,
c.cpf AS CPF_Cliente,
COUNT(DISTINCT v.pk_venda) AS Total_Vendas,
COUNT(nf.pk_notafiscal) AS Total_NotasFiscais
FROM
tb_cliente c
INNER JOIN
tb_venda v ON c.pk_cliente = v.fk_cliente
INNER JOIN
tb_NotaFiscal nf ON v.pk_venda = nf.fk_venda
GROUP BY
c.pk_cliente, c.nome, c.cpf
go

select * from vw_ClientesComResumoVendas


--mais um exemplo
go
CREATE VIEW vw_TotalNotasFiscaisPorCliente AS
SELECT
c.pk_cliente AS ID_Cliente,
c.nome AS Nome_Cliente,
c.cpf AS CPF_Cliente,
COUNT(nf.pk_notafiscal) AS Total_NotasFiscais
FROM
tb_cliente c
INNER JOIN
tb_venda v ON c.pk_cliente = v.fk_cliente
INNER JOIN
tb_NotaFiscal nf ON v.pk_venda = nf.fk_venda
GROUP BY
c.pk_cliente, c.nome, c.cpf
go

select * from vw_TotalNotasFiscaisPorCliente

--mais um exemplo
go
CREATE VIEW vwClienteNotaFiscal AS
SELECT tc.nome, tc.cpf, tn.pk_notafiscal FROM tb_cliente tc
JOIN tb_venda tv ON tc.pk_cliente = tv.fk_cliente
JOIN tb_NotaFiscal tn ON tv.pk_venda = tn.fk_venda
GROUP BY tc.nome, tc.cpf, tn.pk_notafiscal
GO

select * from vwClienteNotaFiscal
order by nome

select * from tb_cliente
