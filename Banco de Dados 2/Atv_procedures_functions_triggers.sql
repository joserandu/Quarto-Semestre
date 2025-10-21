-- a) Inicialmente, crie o banco de dados, tabelas, relacionamentos;

CREATE DATABASE EMR_Saude;
USE EMR_Saude;

CREATE TABLE Pacientes (
    paciente_id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    logradouro VARCHAR(100),
    cidade VARCHAR(100),
    estado VARCHAR(100),
    telefone VARCHAR(15)
);

CREATE TABLE Diagnosticos (
    diagnostico_id INT PRIMARY KEY,
    paciente_id INT NOT NULL,
    condicao_medica VARCHAR(100) NOT NULL,
    data DATE NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(paciente_id)
);

CREATE TABLE Medicamentos (
    medicamento_id INT PRIMARY KEY,
    paciente_id INT NOT NULL,
    nome_medicamento VARCHAR(100) NOT NULL,
    dosagem VARCHAR(50),
    instrucoes_administracao TEXT,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(paciente_id)
);

CREATE TABLE Resultados_Laboratorio (
    resultado_id INT PRIMARY KEY,
    paciente_id INT NOT NULL,
    teste VARCHAR(100) NOT NULL,
    valor VARCHAR(50) NOT NULL,
    data DATE NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(paciente_id)
);

CREATE TABLE Planos_Tratamento (
    plano_tratamento_id INT PRIMARY KEY,
    paciente_id INT NOT NULL,
    diagnostico_id INT NOT NULL,
    tratamento_recomendado TEXT NOT NULL,
    data_inicio DATE NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES Pacientes(paciente_id),
    FOREIGN KEY (diagnostico_id) REFERENCES Diagnosticos(diagnostico_id)
);

-- b) Insira 3 registros em cada tabela;

INSERT INTO Pacientes (paciente_id, nome, data_nascimento, logradouro, cidade, estado, telefone) VALUES
(101, 'Ana Silva', '1985-06-15', 'Rua das Flores, 123', 'São Paulo', 'SP', '5511987654321'),
(102, 'Bruno Costa', '1992-11-20', 'Av. Central, 456', 'Rio de Janeiro', 'RJ', '5521991234567'),
(103, 'Carla Oliveira', '1970-03-01', 'Travessa da Paz, 789', 'Belo Horizonte', 'MG', '5531988776655');

SELECT * FROM Pacientes;

INSERT INTO Diagnosticos (diagnostico_id, paciente_id, condicao_medica, data) VALUES
(1, 101, 'Hipertensão Essencial', '2023-10-10'),
(2, 102, 'Asma Brônquica', '2023-10-15'),
(3, 103, 'Diabetes Mellitus Tipo 2', '2023-09-01');

SELECT * FROM Diagnosticos;

INSERT INTO Medicamentos (medicamento_id, paciente_id, nome_medicamento, dosagem, instrucoes_administracao) VALUES
(501, 101, 'Losartana', '50mg', 'Tomar 1 comprimido pela manhã.'),
(502, 102, 'Salbutamol', '100mcg/jato', 'Utilizar conforme a necessidade para alívio.'),
(503, 103, 'Metformina', '850mg', 'Tomar 2 comprimidos ao dia com as refeições.');

SELECT * FROM Medicamentos;

INSERT INTO Resultados_Laboratorio (resultado_id, paciente_id, teste, valor, data) VALUES
(701, 101, 'Glicemia em Jejum', '95 mg/dL', '2023-10-05'),
(702, 102, 'Espirometria', 'VEF1/CVF = 65%', '2023-10-12'),
(703, 103, 'Hemoglobina Glicada', '7.2%', '2023-09-28');

SELECT * FROM Resultados_Laboratorio;

INSERT INTO Planos_Tratamento (plano_tratamento_id, paciente_id, diagnostico_id, tratamento_recomendado, data_inicio) VALUES
(1001, 101, 1, 'Monitoramento de pressão arterial e ajustes na dieta.', '2023-10-11'),
(1002, 102, 2, 'Educação sobre gatilhos e uso correto do inalador.', '2023-10-16'),
(1003, 103, 3, 'Acompanhamento nutricional e aumento de atividade física.', '2023-09-05');

SELECT * FROM Planos_Tratamento;

-- c) Crie uma procedure que insira um novo diagnóstico para um paciente, atualizando a tabela Diagnósticos;

CREATE PROCEDURE Inserir_Novo_Diagnostico (
    @paciente_id INT,
    @condicao_medica VARCHAR(100),
    @data DATE
)
AS
BEGIN
    -- Verifica se o paciente_id existe antes de inserir (boa prática)
    IF NOT EXISTS (SELECT 1 FROM Pacientes WHERE paciente_id = @paciente_id)
    BEGIN
        RAISERROR('Erro: O ID do paciente não existe.', 16, 1)
        RETURN
    END

    INSERT INTO Diagnosticos (paciente_id, condicao_medica, data)
    VALUES (@paciente_id, @condicao_medica, @data);
END
GO

-- Exemplo de como executar a procedure:
-- EXEC Inserir_Novo_Diagnostico @paciente_id = 101, @condicao_medica = 'Gripe sazonal', @data = '2024-10-20';

-- d) Crie uma função que retorne o número total de diagnósticos associados a um determinado paciente da clínica – o paciente deve ser informado via parâmetro.

CREATE FUNCTION Contar_Diagnosticos_Paciente (@paciente_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @total_diagnosticos INT;

    SELECT @total_diagnosticos = COUNT(*)
    FROM Diagnosticos
    WHERE paciente_id = @paciente_id;

    RETURN @total_diagnosticos;
END
GO

-- Exemplo de como usar a função:
-- SELECT dbo.Contar_Diagnosticos_Paciente(101) AS TotalDiagnosticos;

-- e) Crie uma função que receberá o nome da condição médica (diagnóstico) como parâmetro e retornará uma tabela contendo os dados dos pacientes que possuem o diagnóstico informado.

CREATE FUNCTION Pacientes_Por_Condicao (@condicao_medica VARCHAR(100))
RETURNS TABLE
AS
RETURN
(
    SELECT
        P.paciente_id AS id,
        P.nome AS nome_paciente,
        P.data_nascimento AS data_nasc,
        P.telefone AS telefone_paciente
    FROM
        Pacientes P
    JOIN
        Diagnosticos D ON P.paciente_id = D.paciente_id
    WHERE
        D.condicao_medica = @condicao_medica
);
GO

-- Exemplo de como usar a função:
-- SELECT * FROM dbo.Pacientes_Por_Condicao('Hipertensão Essencial');

-- f) Desenvolva um trigger disparado após um INSERT em Diagnósticos, exibindo uma mensagem e mais os detalhes/dados do diagnóstico inserido.

CREATE TRIGGER log_novo_diagnostico
ON Diagnosticos
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON; -- Boa prática em triggers

    SELECT 
        'NOVO DIAGNÓSTICO INSERIDO! Detalhes:' AS Mensagem,
        I.diagnostico_id AS ID,
        I.paciente_id AS Paciente_ID,
        I.condicao_medica AS Condicao,
        I.data AS Data_Diagnostico
    FROM 
        INSERTED I;

    -- Alternativamente, você pode usar PRINT (mais simples, mas menos formatado):
    -- DECLARE @ID INT, @Paciente INT, @Condicao VARCHAR(100);
    -- SELECT @ID = diagnostico_id, @Paciente = paciente_id, @Condicao = condicao_medica FROM INSERTED;
    -- PRINT 'Novo Diagnóstico inserido: ID ' + CAST(@ID AS VARCHAR) + ' para Paciente ' + CAST(@Paciente AS VARCHAR) + ' (' + @Condicao + ')';
END
GO

-- g) Crie um trigger que ao ser inserido um registro em resultado de laboratório, mostre uma mensagem com a soma dos valores devidos pelo paciente inserido – somando todos os registros que existirem para aquele paciente.

CREATE TRIGGER mostrar_soma_devida
ON Resultados_Laboratorio
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @paciente_id_inserido INT;
    DECLARE @soma_devida DECIMAL(10, 2);

    -- Obtém o ID do paciente recém-inserido
    SELECT @paciente_id_inserido = paciente_id FROM INSERTED;

    -- Simulação de um valor de cobrança de R$ 100,00 por registro de laboratório
    SELECT @soma_devida = COUNT(*) * 100.00
    FROM Resultados_Laboratorio
    WHERE paciente_id = @paciente_id_inserido;
    
    -- Exibe a mensagem com a soma simulada
    PRINT 'ALERTA: Novo Resultado de Laboratório para Paciente ID ' 
          + CAST(@paciente_id_inserido AS VARCHAR) 
          + '. O valor total SIMULADO a ser cobrado deste paciente é de R$ ' 
          + CAST(@soma_devida AS VARCHAR);
END
GO

-- h) Crie uma visão que mostra o nome do paciente, a condição médica diagnosticada e o plano de tratamento. Obs.: este tipo de mineração de dados é bem útil para uma clínica gerenciar o histórico de diagnósticos e tratamentos de clientes

CREATE VIEW View_Historico_Cuidados
AS
SELECT
    P.nome AS Nome_Paciente,
    P.data_nascimento AS Data_Nascimento,
    D.condicao_medica AS Condicao_Medica,
    PT.tratamento_recomendado AS Plano_de_Tratamento,
    PT.data_inicio AS Data_Inicio_Tratamento
FROM
    Pacientes P
JOIN
    Diagnosticos D ON P.paciente_id = D.paciente_id
JOIN
    Planos_Tratamento PT ON D.diagnostico_id = PT.diagnostico_id;
GO

-- Exemplo de uso:
-- SELECT * FROM View_Historico_Cuidados;

-- i) Faça uma view que retorne o nome do Paciente, a condição médica diagnosticada e ainda acrescentando os dados da tabela resultado: teste, valor e data.

CREATE VIEW View_Diagnostico_e_Exames
AS
SELECT
    P.nome AS Nome_Paciente,
    D.condicao_medica AS Condicao_Medica,
    RL.teste AS Teste_Laboratorio,
    RL.valor AS Resultado_Valor,
    RL.data AS Data_Exame
FROM
    Pacientes P
JOIN
    Diagnosticos D ON P.paciente_id = D.paciente_id
JOIN
    Resultados_Laboratorio RL ON P.paciente_id = RL.paciente_id
-- Opcional: filtro para garantir que o exame seja relevante ao diagnóstico, 
-- verificando se o exame foi feito na mesma data ou depois do diagnóstico
WHERE
    RL.data >= D.data
ORDER BY
    P.nome, RL.data DESC;
GO

-- Exemplo de uso:
SELECT * FROM View_Diagnostico_e_Exames;
