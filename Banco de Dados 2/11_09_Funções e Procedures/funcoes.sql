
GO 
Create FUNCTION F_AreaTriangulo (@base smallint, @altura smallint)
RETURNS int  -- tipo de retorno
    AS
    BEGIN
        RETURN ((@base * @altura)/2)
    END

SELECT dbo.F_AreaTriangulo(5,30)
SELECT dbo.F_AreaTriangulo(3,17)

-- Área do círculo
GO
Create FUNCTION F_AreaCirculo (@raio int)
RETURNS Bigint
AS
BEGIN
 DECLARE @area Bigint
 SET @area = PI() * POWER(@raio,2)
 RETURN @area
END
-- Para executar a função:
SELECT dbo. F_AreaCirculo (10)


-- Função in-line com apenas um comando

-- Criação antiga do bd
CREATE TABLE [Funcionario](
    [Cod_Func] [int] NOT NULL,
    [Nome_Func] [varchar](100) NULL,
    [Sexo_Func] [char](1) NULL,
    [Sal_Func] [float] NULL,
    [Data_Func] [datetime] NULL,
    [Num_Regiao] [int] NULL
)

CREATE TABLE [Regiao](
[Num_Regiao] [int] NOT NULL,
[Regiao] [varchar](50) NULL
)

insert into funcionario values(1,'Manda Chuva','M',5000, '1998-01-01 00:00:00.000',1)
insert into funcionario values(2,'Chuchu','M',3000, '1999-01-01 00:00:00.000',1)
insert into funcionario values(3,'Bacana','M',2000, '2000-01-01 00:00:00.000',2)
insert into funcionario values(4,'Espeto','M',2500, '2001-01-01 00:00:00.000',2)
insert into funcionario values(5,'Batatinha','F',4000, '2002-01-01 00:00:00.000',3)

insert into Regiao values (1,'Norte')
insert into Regiao values (2,'Sul')
insert into Regiao values (3,'Leste')
insert into Regiao values (4,'Oeste')

GO
Create FUNCTION F_DataCadastro (@data smallDatetime)
RETURNS TABLE
AS
RETURN (SELECT * FROM dbo.Funcionario WHERE Data_Func = @data)


SELECT * FROM F_DataCadastro('01/01/98')

--Fazendo JOIN com o resultado da função F_DataCadastro:
Select F.*, Regiao.Regiao
from F_DataCadastro('01/01/98') as F, Regiao
where F.Num_Regiao = Regiao.Num_Regiao


CREATE TABLE [dbo].[Usuario](
    [User_Name] [varchar](50) NULL,
    [Num_Regiao] [int] NULL
)

insert into usuario values ('george',1)
insert into usuario values ('dbo',10)
insert into usuario values ('ana',2)

Create FUNCTION F_Func2 ( )
RETURNS @Func Table ( Nome_Func varchar(100) not null,
 Sal_Func decimal(10,2) not null )
AS
BEGIN
 DECLARE @numreg tinyint
 SELECT @numreg = Num_Regiao FROM Usuario WHERE User_name = User
 IF @numreg IS NOT NULL AND @numreg <> 10
 INSERT @Func
 SELECT Nome_Func, Sal_Func FROM Funcionario WHERE
Num_regiao = @numreg
 ELSE IF @numreg = 10
 INSERT @Func
 SELECT Nome_Func, Sal_Func FROM Funcionario
RETURN
END
GO

--Código que executa a função ***
SELECT * FROM dbo.F_Func2( )
