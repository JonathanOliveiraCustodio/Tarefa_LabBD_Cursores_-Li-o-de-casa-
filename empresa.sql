USE master
CREATE DATABASE CursorEmpresa
GO
USE CursorEmpresa
GO
CREATE TABLE envio (
CPF					VARCHAR(20),
NR_LINHA_ARQUIV		INT,
CD_FILIAL			INT,
DT_ENVIO			DATETIME,
NR_DDD				INT,
NR_TELEFONE			VARCHAR(10),
NR_RAMAL			VARCHAR(10),
DT_PROCESSAMENT		DATETIME,
NM_ENDERECO			VARCHAR(200),
NR_ENDERECO			INT,
NM_COMPLEMENTO		VARCHAR(50),
NM_BAIRRO			VARCHAR(100),
NR_CEP				VARCHAR(10),
NM_CIDADE			VARCHAR(100),
NM_UF				VARCHAR(2)
)
GO
CREATE TABLE endereco(
CPF VARCHAR(20),
CEP VARCHAR(10),
PORTA int,
ENDEREÇO VARCHAR(200),
COMPLEMENTO VARCHAR(100),
BAIRRO VARCHAR(100),
CIDADE VARCHAR(100),
UF VARCHAR(2)
)
GO
CREATE PROCEDURE sp_insereenvio
as
declare @cpf as int
declare @cont1 as int
declare @cont2 as int
declare @conttotal as int
set @cpf = 11111
set @cont1 = 1
set @cont2 = 1
set @conttotal = 1
while @cont1 <= @cont2 and @cont2 < = 100
begin
insert into envio (CPF, NR_LINHA_ARQUIV, DT_ENVIO)
values (cast(@cpf as varchar(20)), @cont1,GETDATE())
insert into endereco (CPF,PORTA,ENDEREÇO)
values (@cpf,@conttotal,CAST(@cont2 as varchar(3))+'Rua '+CAST(@conttotal as varchar(5)))
set @cont1 = @cont1 + 1
set @conttotal = @conttotal + 1
if @cont1 > = @cont2
begin
set @cont1 = 1
set @cont2 = @cont2 + 1
set @cpf = @cpf + 1
end
end

exec sp_insereenvio

select * from envio order by CPF,NR_LINHA_ARQUIV asc
select * from endereco order by CPF asc

CREATE PROCEDURE MigrarEnderecos
AS
BEGIN
    DECLARE @CPF VARCHAR(20)
    DECLARE @NR_LINHA_ARQUIV INT
    DECLARE @CEP VARCHAR(10)
    DECLARE @PORTA INT
    DECLARE @ENDERECO VARCHAR(200)
    DECLARE @COMPLEMENTO VARCHAR(100)
    DECLARE @BAIRRO VARCHAR(100)
    DECLARE @CIDADE VARCHAR(100)
    DECLARE @UF VARCHAR(2)

    DECLARE cursor_enderecos CURSOR FOR
    SELECT CPF, PORTA, ENDEREÇO, COMPLEMENTO, BAIRRO, CEP, CIDADE, UF
    FROM endereco

    OPEN cursor_enderecos
    FETCH NEXT FROM cursor_enderecos INTO @CPF, @PORTA, @ENDERECO, @COMPLEMENTO, @BAIRRO, @CEP, @CIDADE, @UF

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Inserir os dados na tabela envio
        INSERT INTO envio (CPF, NR_LINHA_ARQUIV, CD_FILIAL, DT_ENVIO, NM_ENDERECO, NR_ENDERECO, NM_COMPLEMENTO, NM_BAIRRO, NR_CEP, NM_CIDADE, NM_UF)
        VALUES (@CPF, @NR_LINHA_ARQUIV, NULL, NULL, @ENDERECO, @PORTA, @COMPLEMENTO, @BAIRRO, @CEP, @CIDADE, @UF)

        FETCH NEXT FROM cursor_enderecos INTO @CPF, @PORTA, @ENDERECO, @COMPLEMENTO, @BAIRRO, @CEP, @CIDADE, @UF
    END

    CLOSE cursor_enderecos
    DEALLOCATE cursor_enderecos
END



EXEC MigrarEnderecos

select * from envio order by CPF,NR_LINHA_ARQUIV asc