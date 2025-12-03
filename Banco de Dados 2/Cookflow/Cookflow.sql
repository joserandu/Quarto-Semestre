-- CookFlow - Scripts DDL para SQL Server (T-SQL)
-- Migration 001: Cria a estrutura inicial completa do banco de dados.

USE Cookflow;

-------------------------------------------------------------------------------------------------------------------

-- PROCEDURE ranking_receitas_melhor_avaliadas

CREATE PROCEDURE ranking_receitas_melhor_avaliadas
AS
BEGIN
    SELECT 
        r.id_receita AS receita_id,
        r.titulo AS nome_receita,
        CAST(AVG(a.nota) AS DECIMAL(4,2)) AS media_avaliacao,
        COUNT(a.nota) AS total_avaliacoes
    FROM receitas r
    INNER JOIN avaliacoes a
        ON a.id_receita = r.id_receita
    GROUP BY r.id_receita, r.titulo
    HAVING COUNT(a.nota) > 0
    ORDER BY 
        AVG(a.nota) DESC,
        COUNT(a.nota) DESC;
END;
GO

EXEC ranking_receitas_melhor_avaliadas;

-------------------------------------------------------------------------------------------------------------------

-- FUNCTION: fn_buscar_receitas_por_ingrediente

CREATE FUNCTION fn_buscar_receitas_por_ingrediente
(
    @nome_ingrediente VARCHAR(100)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        r.id_receita,
        r.titulo,
        r.descricao,
        r.tempo_preparo_minutos,
        r.dificuldade,
        i.nome AS ingrediente,
        ri.quantidade,
        ri.unidade_medida
    FROM ingredientes i
    INNER JOIN receitas_ingredientes ri
        ON ri.id_ingrediente = i.id_ingrediente
    INNER JOIN receitas r
        ON r.id_receita = ri.id_receita
    WHERE i.nome LIKE '%' + @nome_ingrediente + '%'
);
GO

SELECT * FROM fn_buscar_receitas_por_ingrediente('Chocolate');

-------------------------------------------------------------------------------------------------------------------

-- TRIGGER trg_formatar_nome_usuario

CREATE TRIGGER trg_formatar_nome_usuario
ON usuarios
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE u
    SET nome = (
        SELECT STRING_AGG(
            UPPER(LEFT(value, 1)) + LOWER(SUBSTRING(value, 2, LEN(value))),
            ' '
        )
        FROM STRING_SPLIT(i.nome, ' ')
    )
    FROM usuarios u
    INNER JOIN inserted i ON u.id_usuario = i.id_usuario;
END;
GO

INSERT INTO usuarios (nome, email, senha_hash)
VALUES ('frANcIScO veriSSimo LuCiAnO', 'francisco@teste.com', '123');

SELECT * FROM usuarios;

-------------------------------------------------------------------------------------------------------------------

-- VIEW vw_usuarios_mais_ativos

CREATE VIEW vw_usuarios_mais_ativos AS
SELECT 
    u.id_usuario,
    u.nome,
    u.email,
    COUNT(r.id_receita) AS total_receitas
FROM usuarios u
LEFT JOIN receitas r 
    ON u.id_usuario = r.id_usuario
GROUP BY 
    u.id_usuario,
    u.nome,
    u.email;
GO

SELECT * FROM vw_usuarios_mais_ativos
ORDER BY total_receitas DESC;

-------------------------------------------------------------------------------------------------------------------

-- TRANSACTION apagar_categoria

INSERT INTO categorias (nome) VALUES ('Doce Azerbaijano');

SELECT * FROM categorias;

INSERT INTO receitas (id_usuario, id_categoria, titulo, descricao, url_imagem, tempo_preparo_minutos, dificuldade, instrucoes) 
VALUES (2, 51, 'Shekerbura', 'A Shekerbura é um doce delicioso e festivo.', '', 180, 'Difícil', 'Em uma tigela pequena, misture o fermento, o açúcar e um pouco do leite morno. Em uma tigela grande (ou na batedeira), misture a farinha e o sal. Adicione os ovos ligeiramente batidos, a manteiga derretida e a mistura de fermento ativada à farinha');

SELECT * FROM receitas;

DECLARE @id_categoria_remover INT = 51; -- ID
DECLARE @id_categoria_outras INT;

BEGIN TRANSACTION;

BEGIN TRY
    SELECT @id_categoria_outras = id_categoria
    FROM categorias
    WHERE nome = 'Outras';

    IF @id_categoria_outras IS NULL
    BEGIN
        INSERT INTO categorias (nome)
        VALUES ('Outras');

        SET @id_categoria_outras = SCOPE_IDENTITY();
    END

    UPDATE receitas
    SET id_categoria = @id_categoria_outras
    WHERE id_categoria = @id_categoria_remover;

    DELETE FROM categorias
    WHERE id_categoria = @id_categoria_remover;

    COMMIT;
    PRINT 'Transação concluída com sucesso!';

END TRY
BEGIN CATCH
    ROLLBACK;

    PRINT 'Erro na transação: ' + ERROR_MESSAGE();
END CATCH;

SELECT * FROM categorias;
SELECT titulo, id_categoria FROM receitas;
SELECT * FROM categorias WHERE id_categoria = 52;

-------------------------------------------------------------------------------------------------------------------
