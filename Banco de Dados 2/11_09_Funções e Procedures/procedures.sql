--O que é
Stored Procedure, traduzido Procedimento Armazenado, é uma biblioteca de comandos em SQL para utilização junto ao banco de dados. Ela armazena tarefas repetitivas e aceita parâmetros de entrada para que a tarefa seja efetuada de acordo com a necessidade individual.

Uma Stored Procedure pode reduzir o tráfego na rede, melhorar a performance de um banco de dados, criar tarefas agendadas, diminuir riscos, criar rotinas de processsamento, etc. Por todas estas e outras funcionalidades é que as stored procedures são de extrema importância para os DBAs e desenvolvedores.

Quando utilizar procedures
Quando temos várias aplicações escritas em diferentes linguagens, ou rodam em plataformas diferentes, porém executam a mesma função.
Quando damos prioridade à consistência e segurança

CREATE PROCEDURE sp_minha_procedure AS
BEGIN
SELECT 'HELLO WORLD!'
END

EXEC sp_minha_procedure

GO 
CREATE PROCEDURE sp_procedure_com_variavel AS
DECLARE @idade int, @nome varchar(4)
BEGIN
    set @idade = 15
    set @nome = 'IFSP'
    print @idade
    print @nome
END

-- Executando
EXEC sp_procedure_com_variavel

GO
CREATE PROCEDURE sp_procedure_variavel_coluna AS
DECLARE @cpf varchar(11)
BEGIN
    SELECT @cpf = cpf FROM tb_cliente WHERE pk_cliente = 1
    print @cpf
END

-- Execução
EXEC sp_procedure_variavel_coluna

-- Vai retornar o cpf desse caba:
SELECT * FROM tb_cliente WHERE pk_cliente = 1

-- Procidure (SP) com parâmetros
GO
CREATE PROCEDURE sp_procedure_parametro(@pk_cliente int) AS  
BEGIN
SELECT * FROM tb_cliente WHERE pk_cliente = @pk_cliente  -- @pk_cliente é o valor que eu vou passar para a procedure.
END

EXEC sp_procedure_parametro 2


--
GO 
CREATE PROCEDURE sp_procedure_varios_parametros(@pk_cliente int, @nome
varchar(255)) AS
BEGIN
UPDATE tb_cliente SET nome = @nome WHERE pk_cliente = @pk_cliente  -- Vai mudar o nome do cliente
END

EXEC sp_procedure_varios_parametros 1, 'Pedro Paulo Pereira'

EXEC sp_procedure_parametro 1


-- Procedure com IF
GO
CREATE PROCEDURE sp_procedure_if_UM(@pk_cliente int) AS
BEGIN
IF(@pk_cliente>10)
    BEGIN  -- Não esqueça que tem que inicia e fechar o if
    SELECT * FROM tb_cliente WHERE pk_cliente > 10
    END
ELSE
    BEGIN
    SELECT * FROM tb_cliente WHERE pk_cliente < 10
    END
END

exec sp_procedure_if_UM 10  -- Vai retornar todos os que tem menos de 10

-- Exercícios:
-- 1. Faça uma SP que retorne a mйdia da quantidade em estoque de todos os produtos
-- 2. Faça uma SP que retorne todos os vendedores que realizaram vendas cujo nome tenha em sua parte %dr%
-- 3. Faça uma SP que dado a PK de produto mostre quantas vendas foram realizadas para ele
-- 4. Faça uma SP que dado a PK de uma loja mostre a quantidade de vendas realizadas para ela

-- 1.
GO
CREATE PROCEDURE sp_procedure_mediaEstoque AS
    BEGIN 
        SELECT AVG(quantidade_estoque) 'Estoque Medio' FROM tb_produto
    END

EXEC sp_procedure_mediaEstoque

-- 2.
GO
CREATE PROCEDURE sp_procedure_nome_vendedor AS
    BEGIN 
        SELECT v.*
        FROM tb_vendedor
        JOIN tb_venda ve
        ON v.pk_vendedor = ve.fk_vendedor
        INNER JOIN Vendas VD ON V.IdVendedor = VD.IdVendedor
        WHERE v.nome NOT LIKE '%dr%'
        ORDER BY v.pk_vendedor
    END

EXEC sp_procedure_nome_vendedor

-- 3. Faça uma SP que dado a PK de produto mostre quantas vendas foram realizadas para ele

GO
    CREATE PROCEDURE sp_procedure_vendas_produtos(@pk_produto int) AS
BEGIN

    SELECT COUNT(fk_produto) FROM tb_itens 
    WHERE @pk_produto = fk_produto
END

EXEC sp_procedure_vendas_produtos 3

-- 4. Faça uma SP que dado a PK de uma loja mostre a quantidade de vendas realizadas para ela

GO
    CREATE PROCEDURE sp_procedure_loja_vendas(@pk_loja) AS
BEGIN 
    SELECT COUNT(fk_loja) FROM tb_venda 
    WHERE @pk_loja = fk_loja
END

EXEC sp_procedure_loja_vendas 1
