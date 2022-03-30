/****** Object:  StoredProcedure [config].[AmbienteConsultar]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE OR ALTER PROCEDURE [config].[AmbienteConsultar]
	@Codigo int
AS

BEGIN
	SET NOCOUNT ON;

	SELECT Codigo, Apelido, NomeResponsavel, EmailResponsavel
	FROM config.Ambiente
	WHERE Codigo = @Codigo
END
GO

/****** Object:  StoredProcedure [config].[AmbienteListar]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [config].[AmbienteListar]
as
	SELECT Codigo, Apelido, NomeResponsavel, EmailResponsavel
	FROM config.Ambiente
GO

/****** Object:  StoredProcedure [email].[ContatoAtualizar]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[ContatoAtualizar]
	@Codigo int = NULL,
	@CodigoAmbiente int = NULL,
	@Nome varchar(100) = NULL,
	@Apelido varchar(50) = NULL,
	@Email varchar(100) = NULL,
	@Ativo bit = NULL	
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE Contato
	SET Nome = @Nome, Apelido = @Apelido, Email = @Email, Ativo = @Ativo, CodigoAmbiente = @CodigoAmbiente
	WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[SnapshotDisparoInserir]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [email].[SnapshotDisparoInserir]
	@Codigo int OUTPUT,
	@Criacao datetime, 
	@CodigoDisparo int,
	@CodigoContato int, 
	@Assunto varchar(100),
	@HTML text
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO email.SnapshotDisparo(Criacao, CodigoDisparo, CodigoContato, Assunto, HTML)
	VALUES (@Criacao, @CodigoDisparo, @CodigoContato, @Assunto, @HTML)

	IF @@ERROR = 0
		SET @Codigo = SCOPE_IDENTITY()
	ELSE
		SET @Codigo = -1
END
GO

/****** Object:  StoredProcedure [email].[VisitaLinkListar]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[VisitaLinkListar]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
	CodigoDisparo, CodigoContato, CodigoLink, Visitas, PrimeiraVisita FROM email.VisitaLink
END
GO

/****** Object:  StoredProcedure [email].[GrupoListarPorContato]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[GrupoListarPorContato]
	@CodigoContato int
AS
BEGIN
	SET NOCOUNT ON;	
	
	SELECT
	G.Codigo, Nome, Ativo, Criacao, g.CodigoAmbiente, g.Sistema FROM email.Grupo g
	INNER JOIN GrupoContato gc ON gc.CodigoGrupo = g.Codigo AND gc.CodigoContato = @CodigoContato
END
GO

/****** Object:  StoredProcedure [email].[GrupoListarPorCampanha]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[GrupoListarPorCampanha]
	@CodigoCampanha int
AS
BEGIN
	SET NOCOUNT ON;	
	SELECT
	G.Codigo, Nome, Ativo, Criacao, g.CodigoAmbiente, g.Sistema FROM email.Grupo G
	INNER JOIN CampanhaGrupo CG ON CG.CodigoGrupo = G.Codigo AND CG.CodigoCampanha = @CodigoCampanha
END
GO

/****** Object:  StoredProcedure [email].[ContatoBuscar]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [email].[ContatoBuscar]
	@nome NVARCHAR(100),
	@email NVARCHAR(100),
	@apelido NVARCHAR(50),
	@ativo BIT = NULL,
	@codigoAmbiente INT
AS
BEGIN

	SET NOCOUNT ON;	
	select @nome = (case when CHARINDEX(' ',@nome,0) = 0 then left(@nome,len(@nome)-1) + '*"' else @nome end)
	
	SELECT Codigo, Nome, Apelido, Email, Ativo, Criacao, CodigoAmbiente
	FROM email.Contato
	WHERE (@nome = '""' OR Contains(Nome, @nome))
		AND (@email = '""' OR Contains(Email, @email))
		AND (@apelido = '""' OR Contains(Apelido, @apelido))
		AND (@ativo IS NULL OR Ativo = @ativo)
		AND CodigoAmbiente = @codigoAmbiente
END

GO

/****** Object:  StoredProcedure [email].[GrupoListarPorAmbiente]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[GrupoListarPorAmbiente]
	@CodigoAmbiente int
AS
BEGIN
	
	SET NOCOUNT ON;	
	
	SELECT
		Codigo, Nome, Ativo, Criacao, CodigoAmbiente, Sistema FROM email.Grupo
	WHERE CodigoAmbiente = @CodigoAmbiente
	ORDER BY Nome
	
END
GO

/****** Object:  StoredProcedure [email].[GrupoListar]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[GrupoListar]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, Nome, Ativo, Criacao, CodigoAmbiente, Sistema FROM email.Grupo
END
GO

/****** Object:  StoredProcedure [email].[GrupoInserir]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[GrupoInserir]
	@Codigo int OUTPUT,
	@CodigoAmbiente int = NULL,
	@Nome varchar(100) = NULL,
	@Ativo bit = NULL,
	@Criacao smalldatetime = NULL,
	@Sistema bit = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO Grupo(Nome, Ativo, Criacao, CodigoAmbiente, Sistema)
	VALUES (@Nome, @Ativo, @Criacao, @CodigoAmbiente, @Sistema)

	IF @@ERROR = 0
		SET @Codigo = SCOPE_IDENTITY()
	ELSE
		SET @Codigo = -1
END
GO

/****** Object:  StoredProcedure [email].[GrupoExcluir]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[GrupoExcluir]
	@Codigo int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM email.Grupo WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[GrupoContatoInserir]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[GrupoContatoInserir]
	@CodigoGrupo int,
	@CodigoContato int	
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO GrupoContato(CodigoGrupo, CodigoContato)
	VALUES (@CodigoGrupo, @CodigoContato)	
END
GO

/****** Object:  StoredProcedure [email].[RemetenteListar]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[RemetenteListar]
	@CodigoAmbiente int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoAmbiente, Email, Nome, Apelido, Criacao, Padrao FROM email.Remetente
	WHERE CodigoAmbiente = @CodigoAmbiente
END
GO

/****** Object:  StoredProcedure [email].[ParametroRastreamentoListar]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[ParametroRastreamentoListar]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, Nome FROM email.ParametroRastreamento
END
GO

/****** Object:  StoredProcedure [email].[ContatoConsultar]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[ContatoConsultar]
	@Codigo int
AS

BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, Nome, Apelido, Email, Ativo, Criacao, CodigoAmbiente FROM email.Contato
	WHERE Codigo = @Codigo
END
GO

/****** Object:  StoredProcedure [email].[ContatoRemocaoListar]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[ContatoRemocaoListar]
	@CodigoContato int,
	@CodigoCampanha int	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Remocao FROM email.ContatoRemocao WHERE CodigoContato = @CodigoContato AND CodigoCampanha = @CodigoCampanha
END
GO

/****** Object:  StoredProcedure [email].[AlertaInserir]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[AlertaInserir]
	@Codigo int OUTPUT,
	@Origem varchar(256) = NULL,
	@CodigoUsuario int = NULL,
	@IP varchar(50) = NULL,
	@Criacao datetime = NULL,
	@Descricao varchar(500) = NULL,
	@Detalhes varchar(500) = NULL,
	@Tipo int = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO Alerta(Origem, CodigoUsuario, IP, Criacao, Descricao, Detalhes, Tipo)
	VALUES (@Origem, @CodigoUsuario, @IP, @Criacao, @Descricao, @Detalhes, @Tipo)

	IF @@ERROR = 0
		SET @Codigo = SCOPE_IDENTITY()
	ELSE
		SET @Codigo = -1
END
GO

/****** Object:  StoredProcedure [email].[CampanhaConsultar]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[CampanhaConsultar]
	@Codigo int
AS

BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoAmbiente, Nome, Ativo, Criacao, CodigoServidor, CodigoRemetente FROM email.Campanha
	WHERE Codigo = @Codigo
END
GO

/****** Object:  StoredProcedure [email].[CampanhaAtualizar]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[CampanhaAtualizar]
	@Codigo int = NULL,
	@CodigoAmbiente int = NULL,
	@CodigoServidor int = NULL,
	@CodigoRemetente int = NULL,
	@Nome varchar(50) = NULL,
	@Ativo bit = NULL,
	@Criacao datetime = NULL	
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE email.Campanha
	SET CodigoAmbiente = @CodigoAmbiente, Nome = @Nome, Ativo = @Ativo, Criacao = @Criacao, CodigoServidor = @CodigoServidor, CodigoRemetente = @CodigoRemetente
	WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[VisitaLinkInserir]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[VisitaLinkInserir]
	@CodigoDisparo int OUTPUT,
	@CodigoContato int = NULL,
	@CodigoLink int = NULL,
	@Visitas int = NULL,
	@PrimeiraVisita smalldatetime = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO VisitaLink(CodigoContato, CodigoLink, Visitas, PrimeiraVisita)
	VALUES (@CodigoContato, @CodigoLink, @Visitas, @PrimeiraVisita)

	IF @@ERROR = 0
		SET @CodigoDisparo = SCOPE_IDENTITY()
	ELSE
		SET @CodigoDisparo = -1
END
GO

/****** Object:  StoredProcedure [email].[CampanhaGrupoInserir]    Script Date: 30/03/2022 11:09:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[CampanhaGrupoInserir]
	@CodigoCampanha int,
	@CodigoGrupo int
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO CampanhaGrupo(CodigoCampanha, CodigoGrupo)
	VALUES (@CodigoCampanha, @CodigoGrupo)	
END
GO

/****** Object:  StoredProcedure [email].[CampanhaInserir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[CampanhaInserir]
	@Codigo int OUTPUT,
	@CodigoAmbiente int = NULL,
	@CodigoServidor int = NULL,
	@CodigoRemetente int = NULL,
	@Nome varchar(50) = NULL,
	@Ativo bit = NULL,
	@Criacao datetime = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO email.Campanha(CodigoAmbiente, Nome, Ativo, Criacao, CodigoServidor, CodigoRemetente)
	VALUES (@CodigoAmbiente, @Nome, @Ativo, @Criacao, @CodigoServidor, @CodigoRemetente)

	IF @@ERROR = 0
		SET @Codigo = SCOPE_IDENTITY()
	ELSE
		SET @Codigo = -1
END
GO

/****** Object:  StoredProcedure [email].[CampanhaListar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[CampanhaListar]
	@CodigoAmbiente int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoAmbiente, Nome, Ativo, Criacao, CodigoServidor, CodigoRemetente FROM email.Campanha
	WHERE CodigoAmbiente = @CodigoAmbiente
END
GO

/****** Object:  StoredProcedure [email].[CampanhaListarPorRemetente]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[CampanhaListarPorRemetente]
	@CodigoRemetente int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoAmbiente, Nome, Ativo, Criacao, CodigoServidor, CodigoRemetente FROM email.Campanha
	WHERE CodigoRemetente = @CodigoRemetente
END
GO

/****** Object:  StoredProcedure [email].[CampanhaListarPorServidor]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[CampanhaListarPorServidor]
	@CodigoServidor int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoAmbiente, Nome, Ativo, Criacao, CodigoServidor, CodigoRemetente FROM email.Campanha
	WHERE CodigoServidor = @CodigoServidor
END
GO

/****** Object:  StoredProcedure [email].[ServidorAtualizar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[ServidorAtualizar]
	@Codigo int = NULL,
	@CodigoAmbiente int = NULL,
	@Apelido varchar(100) = NULL,
	@Endereco varchar(150) = NULL,
	@Porta int = NULL,
	@Usuario varchar(50) = NULL,
	@Senha varchar(250) = NULL,
	@SSL bit = NULL,
	@Padrao bit = NULL
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE email.Servidor
	SET CodigoAmbiente = @CodigoAmbiente, Apelido = @Apelido, Endereco = @Endereco, Porta = @Porta, Usuario = @Usuario, Senha = @Senha, SSL = @SSL, Padrao = @Padrao
	WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[ServidorConsultar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[ServidorConsultar]
	@Codigo int
AS

BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoAmbiente, Apelido, Endereco, Porta, Usuario, Senha, SSL, Padrao FROM email.Servidor
	WHERE Codigo = @Codigo
END
GO

/****** Object:  StoredProcedure [email].[ServidorExcluir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[ServidorExcluir]
	@Codigo int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM email.Servidor WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[ContatoExcluir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[ContatoExcluir]
	@Codigo int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM email.Contato WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[AnexoListar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[AnexoListar]
	@CodigoDisparo int,
	@CodigoContato int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoDisparo, CodigoContato, Arquivo FROM email.Anexo
	WHERE CodigoDisparo = @CodigoDisparo AND CodigoContato = @CodigoContato
END
GO

/****** Object:  StoredProcedure [email].[AnexoExcluir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [email].[AnexoExcluir]
	@Codigo int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM email.Anexo WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[AnexoConsultar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [email].[AnexoConsultar]
	@Codigo int
AS

BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoDisparo, CodigoContato, Arquivo FROM email.Anexo
	WHERE Codigo = @Codigo
END
GO

/****** Object:  StoredProcedure [email].[AnexoAtualizar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [email].[AnexoAtualizar]
	@Codigo int = NULL,
	@CodigoDisparo int = NULL,
	@CodigoContato int = NULL,
	@Arquivo varchar(500) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE email.Anexo
	SET CodigoDisparo = @CodigoDisparo, CodigoContato = @CodigoContato, Arquivo = @Arquivo
	WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[ServidorInserir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[ServidorInserir]
	@Codigo int OUTPUT,
	@CodigoAmbiente int = NULL,
	@Apelido varchar(100) = NULL,
	@Endereco varchar(150) = NULL,
	@Porta int = NULL,
	@Usuario varchar(50) = NULL,
	@Senha varchar(250) = NULL,
	@SSL bit = NULL,
	@Padrao bit = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO email.Servidor(CodigoAmbiente, Apelido, Endereco, Porta, Usuario, Senha, SSL, Padrao)
	VALUES (@CodigoAmbiente, @Apelido, @Endereco, @Porta, @Usuario, @Senha, @SSL, @Padrao)

	IF @@ERROR = 0
		SET @Codigo = SCOPE_IDENTITY()
	ELSE
		SET @Codigo = -1
END
GO

/****** Object:  StoredProcedure [email].[ServidorListar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[ServidorListar]
	@CodigoAmbiente int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoAmbiente, Apelido, Endereco, Porta, Usuario, Senha, SSL, Padrao FROM email.Servidor
	WHERE CodigoAmbiente = @CodigoAmbiente
END
GO

/****** Object:  StoredProcedure [email].[ServidorListarCredenciais]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[ServidorListarCredenciais]
	@CodigoAmbiente int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
		Endereco, Porta, Usuario, Senha, SSL FROM email.Servidor
	WHERE CodigoAmbiente = @CodigoAmbiente
END
GO

/****** Object:  StoredProcedure [email].[RemetenteInserir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[RemetenteInserir]
	@Codigo int OUTPUT,
	@CodigoAmbiente int = NULL,
	@Email varchar(100) = NULL,
	@Nome varchar(100) = NULL,
	@Apelido varchar(50) = NULL,
	@Criacao datetime = NULL,
	@Padrao bit = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO email.Remetente(CodigoAmbiente, Email, Nome, Apelido, Criacao, Padrao)
	VALUES (@CodigoAmbiente, @Email, @Nome, @Apelido, @Criacao, @Padrao)

	IF @@ERROR = 0
		SET @Codigo = SCOPE_IDENTITY()
	ELSE
		SET @Codigo = -1
END
GO

/****** Object:  StoredProcedure [email].[ContatoRemocaoInserir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[ContatoRemocaoInserir]
	@CodigoContato int,
	@CodigoCampanha int,
	@Remocao datetime
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO ContatoRemocao(CodigoContato, CodigoCampanha, Remocao)
	VALUES(@CodigoContato, @CodigoCampanha, @Remocao)
END
GO

/****** Object:  StoredProcedure [email].[ContatoListarPorGrupo]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[ContatoListarPorGrupo]
	@CodigoGrupo int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, Nome, Apelido, Email, Ativo, Criacao, c.CodigoAmbiente
	FROM email.Contato C
	INNER JOIN GrupoContato GC ON GC.CodigoContato = C.Codigo AND GC.CodigoGrupo = @CodigoGrupo
END
GO

/****** Object:  StoredProcedure [email].[ContatoListar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[ContatoListar]
	@CodigoAmbiente int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, Nome, Apelido, Email, Ativo, Criacao, CodigoAmbiente FROM email.Contato
	WHERE CodigoAmbiente = @CodigoAmbiente
END
GO

/****** Object:  StoredProcedure [email].[ContatoInserir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[ContatoInserir]
	@Codigo int OUTPUT,
	@CodigoAmbiente int = NULL,
	@Nome varchar(100) = NULL,
	@Apelido varchar(50) = NULL,
	@Email varchar(100) = NULL,
	@Ativo bit = NULL,
	@Criacao datetime = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO Contato(Nome, Apelido, Email, Ativo, Criacao, CodigoAmbiente)
	VALUES (@Nome, @Apelido, @Email, @Ativo, @Criacao, @CodigoAmbiente)

	IF @@ERROR = 0
		SET @Codigo = SCOPE_IDENTITY()
	ELSE
		SET @Codigo = -1
END
GO

/****** Object:  StoredProcedure [email].[AnexoInserir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [email].[AnexoInserir]
	@Codigo int OUTPUT,
	@CodigoDisparo int = NULL,
	@CodigoContato int = NULL,
	@Arquivo varchar(500) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO email.Anexo(CodigoDisparo, CodigoContato, Arquivo)
	VALUES (@CodigoDisparo, @CodigoContato, @Arquivo)

	IF @@ERROR = 0
		SET @Codigo = SCOPE_IDENTITY()
	ELSE
		SET @Codigo = -1
END
GO

/****** Object:  StoredProcedure [email].[CampanhaExcluir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[CampanhaExcluir]
	@Codigo int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM email.Campanha WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[RemetenteExcluir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[RemetenteExcluir]
	@Codigo int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM email.Remetente WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[RemetenteAtualizar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[RemetenteAtualizar]
	@Codigo int = NULL,
	@CodigoAmbiente int = NULL,
	@Email varchar(100) = NULL,
	@Nome varchar(100) = NULL,
	@Apelido varchar(50) = NULL,
	@Criacao datetime = NULL,
	@Padrao bit = NULL
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE email.Remetente
	SET CodigoAmbiente = @CodigoAmbiente, Email = @Email, Nome = @Nome, Apelido = @Apelido, Criacao = @Criacao, Padrao = @Padrao
	WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[VariavelValorGlobalInserir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [email].[VariavelValorGlobalInserir]
	@Codigo int OUTPUT,
	@CodigoAmbiente int = NULL,
	@Chave varchar(50) = NULL,
	@Valor varchar(1000) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO email.VariavelValorGlobal(CodigoAmbiente, Chave, Valor)
	VALUES (@CodigoAmbiente, @Chave, @Valor)

	IF @@ERROR = 0
		SET @Codigo = SCOPE_IDENTITY()
	ELSE
		SET @Codigo = -1
END
GO

/****** Object:  StoredProcedure [email].[MensagemListarPorAmbiente]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[MensagemListarPorAmbiente]
	@CodigoAmbiente int
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		m.Codigo, CodigoCampanha, Nome, Assunto, NULL AS HTML, m.Ativo, m.Criacao, m.CodigoAmbiente, CodigoTipo, COUNT(distinct d.Codigo) AS Total
	FROM email.Mensagem m
	left JOIN email.Disparo d ON d.CodigoMensagem = m.Codigo
	WHERE m.CodigoAmbiente = @CodigoAmbiente
	GROUP BY m.Codigo, CodigoCampanha, Nome, Assunto, m.Ativo, m.Criacao, m.CodigoAmbiente, CodigoTipo
	
END
GO

/****** Object:  StoredProcedure [email].[DisparoAtualizarStatus]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[DisparoAtualizarStatus]
	@DataAtual DATETIME,
	@Expirados bit = 1,
	@Finalizados bit = 1
AS
BEGIN
   SET NOCOUNT ON;

   IF(@Expirados = 1)
   BEGIN
	   --Finalizando disparos expirados - início
	   BEGIN TRAN disparosExpirados
	   IF EXISTS (SELECT TOP 1 1 FROM Disparo WHERE CodigoStatusDisparo < 3 AND TerminoAgendamento < @DataAtual)
	   BEGIN
		  DECLARE @historico TABLE(Codigo INT);

		  UPDATE Disparo SET CodigoStatusDisparo = 5, TerminoDisparo = @DataAtual 
		  OUTPUT inserted.Codigo INTO @historico
		   WHERE CodigoStatusDisparo < 3 AND TerminoAgendamento < @DataAtual     

		  UPDATE o SET CodigoStatusDisparo = 5, UltimaAlteracao = @DataAtual
			FROM OcorrenciaDisparo o INNER JOIN @historico d ON d.Codigo = o.CodigoDisparo
			 AND CodigoStatusDisparo = 1
	   END

	   COMMIT TRAN disparosExpirados;
	   --Finalizando disparos expirados - fim
   END;

   IF(@Finalizados = 1)
   BEGIN

	   IF EXISTS(SELECT TOP 1 1 FROM Disparo d WHERE Codigo NOT IN (SELECT DISTINCT o.CodigoDisparo FROM OcorrenciaDisparo o WHERE o.CodigoStatusDisparo = 1) AND d.CodigoStatusDisparo = 2)
	   BEGIN
		  UPDATE Disparo SET CodigoStatusDisparo = 3, TerminoDisparo = @DataAtual 
		   WHERE CodigoStatusDisparo = 2 AND Codigo NOT IN (SELECT DISTINCT CodigoDisparo FROM OcorrenciaDisparo WHERE CodigoStatusDisparo != 3)
	     
		  UPDATE Disparo SET CodigoStatusDisparo = 4, TerminoDisparo = @DataAtual 
		   WHERE CodigoStatusDisparo = 2 AND Codigo NOT IN (SELECT DISTINCT CodigoDisparo FROM OcorrenciaDisparo WHERE CodigoStatusDisparo < 3)
			 AND Codigo IN (SELECT DISTINCT CodigoDisparo FROM OcorrenciaDisparo WHERE CodigoStatusDisparo = 4)
	   END
   END;
END
GO

/****** Object:  StoredProcedure [email].[DisparoConsultar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[DisparoConsultar]
	@Codigo int
AS

BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoMensagem, InicioAgendamento, TerminoAgendamento, InicioDisparo, TerminoDisparo, Ativo, Criacao, CodigoRemetente, CodigoStatusDisparo, CodigoAmbiente
	FROM email.Disparo
	WHERE Codigo = @Codigo
END
GO

/****** Object:  StoredProcedure [email].[VariavelValorGlobalListar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [email].[VariavelValorGlobalListar]
	@CodigoAmbiente int
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Codigo, CodigoAmbiente, Chave, Valor
	FROM email.VariavelValorGlobal
	WHERE CodigoAmbiente = @CodigoAmbiente
END
GO

/****** Object:  StoredProcedure [email].[VariavelValorInserir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[VariavelValorInserir]
	@CodigoVariavel int,
	@CodigoContato int,
	@CodigoDisparo int,
	@Valor varchar(max),
	@Atualizacao smalldatetime
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO VariavelValor(CodigoVariavel, CodigoContato, CodigoDisparo, Valor, Atualizacao)
	VALUES(@CodigoVariavel, @CodigoContato, @CodigoDisparo, @Valor, @Atualizacao)
END
GO

/****** Object:  StoredProcedure [email].[OcorrenciaDisparoListarPorDisparo]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [email].[OcorrenciaDisparoListarPorDisparo](
	@CodigoDisparo INT)
AS
BEGIN
   SET NOCOUNT ON;
	
	SELECT CodigoDisparo, CodigoContato, CodigoAmbiente, Enviado, CodigoStatusDisparo, Criacao, UltimaAlteracao, Visitas, PrimeiraVisita, Tentativas
	FROM email.OcorrenciaDisparo
	WHERE CodigoDisparo = @CodigoDisparo   
   
end
GO

/****** Object:  StoredProcedure [email].[OcorrenciaDisparoListar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE	PROCEDURE [email].[OcorrenciaDisparoListar](
	@DataAtual DATETIME, 
	@QuantidadeLinhasSolicitadas INT)
AS
BEGIN
   SET NOCOUNT ON;
   
   EXECUTE [email].[DisparoAtualizarStatus] @DataAtual, 1, 0;

   --Selecionando ocorrências de disparo, ordenando de forma que a quantidade de mensagens seja distribuída de forma justa entre os ambientes 
   WITH ocorrencias AS
   (SELECT Codigo CodigoDisparo, 
          (CASE WHEN disparo.CodigoStatusDisparo = 1 THEN 1 ELSE 0 END) PrimeiroDisparo, 
		  disparo.CodigoAmbiente,
		  ocorrencia.CodigoContato,
		  SUM(1) OVER (PARTITION BY disparo.CodigoAmbiente) MensagensPorAmbiente,
		  SUM(1) OVER (PARTITION BY NULL) TotalDeMensagens,
		  RANK() OVER (PARTITION BY disparo.CodigoAmbiente ORDER BY ISNULL(disparo.TerminoAgendamento, @DataAtual + 10), disparo.Codigo, ocorrencia.CodigoContato) RankMensagem
     FROM Disparo disparo 
    INNER JOIN OcorrenciaDisparo ocorrencia ON ocorrencia.CodigoDisparo = disparo.Codigo
		   AND ocorrencia.CodigoStatusDisparo = 1 AND ocorrencia.Enviado = 0
    WHERE ISNULL(disparo.InicioAgendamento,@DataAtual -.1) <= @DataAtual 
      AND ISNULL(disparo.TerminoAgendamento,@DataAtual + 1) > @DataAtual 
      AND disparo.Ativo = 1 
      AND disparo.CodigoStatusDisparo < 3)
   SELECT TOP (@QuantidadeLinhasSolicitadas) * 
	 INTO #saida
     FROM ocorrencias
    ORDER BY (RANK() OVER (PARTITION BY NULL ORDER BY MensagensPorAmbiente)) * (TotalDeMensagens / MensagensPorAmbiente) * RankMensagem
   
   --Atualizando status do disparo e das ocorrências selecionadas
   UPDATE o SET CodigoStatusDisparo = 2
     FROM #saida s 
    INNER JOIN OcorrenciaDisparo o ON o.CodigoContato = s.CodigoContato 
           AND s.CodigoDisparo = o.CodigoDisparo
      
   UPDATE d SET CodigoStatusDisparo = 2, InicioDisparo = @DataAtual
     FROM Disparo D 
    INNER JOIN (SELECT DISTINCT CodigoDisparo FROM #saida WHERE PrimeiroDisparo = 1) S ON S.CodigoDisparo = D.Codigo

   EXECUTE [email].[DisparoAtualizarStatus] @DataAtual, 0, 1;

   --Retorna o resultado
   SELECT o.* 
     FROM #saida s 
    INNER JOIN OcorrenciaDisparo o ON o.CodigoContato = s.CodigoContato AND o.CodigoDisparo = s.CodigoDisparo;   
   
end
GO

/****** Object:  StoredProcedure [email].[OcorrenciaDisparoInserir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[OcorrenciaDisparoInserir]
	@CodigoDisparo int,
	@CodigoContato int,
	@CodigoAmbiente int,
	@Enviado bit,
	@CodigoStatusDisparo tinyint,
	@Criacao datetime,
	@UltimaAlteracao smalldatetime,
	@Visitas smallint,
	@PrimeiraVisita smalldatetime,
	@Tentativas smallint
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO OcorrenciaDisparo(CodigoDisparo, CodigoContato, CodigoAmbiente, Enviado, CodigoStatusDisparo, Criacao, UltimaAlteracao, Visitas, PrimeiraVisita, Tentativas)
	VALUES (@CodigoDisparo, @CodigoContato, @CodigoAmbiente, @Enviado, @CodigoStatusDisparo, @Criacao, @UltimaAlteracao, @Visitas, @PrimeiraVisita, @Tentativas)	
END
GO

/****** Object:  StoredProcedure [email].[RemetenteConsultar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[RemetenteConsultar]
	@Codigo int
AS

BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoAmbiente, Email, Nome, Apelido, Criacao, Padrao FROM email.Remetente
	WHERE Codigo = @Codigo
END
GO

/****** Object:  StoredProcedure [email].[MensagemListar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[MensagemListar]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoCampanha, Nome, Assunto, HTML, Ativo, Criacao, CodigoAmbiente, CodigoTipo FROM email.Mensagem
END
GO

/****** Object:  StoredProcedure [email].[OcorrenciaDisparoConsultar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[OcorrenciaDisparoConsultar]
	@CodigoDisparo int,
	@CodigoContato int
AS
BEGIN
	SET NOCOUNT ON;	

	SELECT CodigoDisparo, CodigoContato, CodigoAmbiente, Enviado, CodigoStatusDisparo, Criacao, UltimaAlteracao, Visitas, PrimeiraVisita, Tentativas
	FROM email.OcorrenciaDisparo
	WHERE CodigoDisparo = @CodigoDisparo AND CodigoContato = @CodigoContato
END
GO

/****** Object:  StoredProcedure [email].[OcorrenciaDisparoAtualizarVisitas]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[OcorrenciaDisparoAtualizarVisitas]
	@CodigoDisparo int,
	@CodigoContato int,
	@PrimeiraVisita smalldatetime,
	@Visitas int
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE OcorrenciaDisparo
	SET PrimeiraVisita = @PrimeiraVisita,
		Visitas = @Visitas
	WHERE CodigoDisparo = @CodigoDisparo AND CodigoContato = @CodigoContato
END
GO

/****** Object:  StoredProcedure [email].[OcorrenciaDisparoAtualizarEnvio]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [email].[OcorrenciaDisparoAtualizarEnvio]
	@CodigoDisparo int,
	@CodigoContato int,
	@Enviado bit,
	@CodigoStatusDisparo int,	
	@UltimaAlteracao datetime,	
	@Tentativas int
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE OcorrenciaDisparo
	SET Enviado = @Enviado,
		CodigoStatusDisparo = @CodigoStatusDisparo, 
		UltimaAlteracao = @UltimaAlteracao, 
		Tentativas = @Tentativas
	WHERE CodigoDisparo = @CodigoDisparo AND CodigoContato = @CodigoContato
END
GO

/****** Object:  StoredProcedure [email].[DisparoExcluir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[DisparoExcluir]
	@Codigo int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM email.Disparo WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[DisparoInserir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[DisparoInserir]
	@Codigo int OUTPUT,
	@CodigoMensagem int = NULL,
	@InicioAgendamento smalldatetime = NULL,
	@TerminoAgendamento smalldatetime = NULL,
	@InicioDisparo smalldatetime = NULL,
	@TerminoDisparo smalldatetime = NULL,
	@Ativo bit = NULL,
	@Criacao smalldatetime = NULL,
	@CodigoRemetente int = NULL,
	@CodigoStatusDisparo tinyint = NULL,
	@CodigoAmbiente int = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO Disparo(CodigoMensagem, InicioAgendamento, TerminoAgendamento, InicioDisparo, TerminoDisparo, Ativo, Criacao, CodigoRemetente, CodigoStatusDisparo, CodigoAmbiente)
	VALUES (@CodigoMensagem, @InicioAgendamento, @TerminoAgendamento, @InicioDisparo, @TerminoDisparo, @Ativo, @Criacao, @CodigoRemetente, @CodigoStatusDisparo, @CodigoAmbiente)

	IF @@ERROR = 0
		SET @Codigo = SCOPE_IDENTITY()
	ELSE
		SET @Codigo = -1
END
GO

/****** Object:  StoredProcedure [email].[DisparoListar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[DisparoListar]
	@CodigoAmbiente int
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		di.Codigo, CodigoMensagem, InicioAgendamento, TerminoAgendamento, InicioDisparo, TerminoDisparo, Ativo, 
		Criacao, CodigoRemetente, CodigoStatusDisparo, CodigoAmbiente, COUNT(di.Codigo) AS Total
	FROM email.Disparo di
	INNER JOIN email.Destinatario de ON de.CodigoDisparo = di.Codigo
	WHERE CodigoAmbiente = @CodigoAmbiente
	GROUP BY di.Codigo, CodigoMensagem, InicioAgendamento, TerminoAgendamento, InicioDisparo, TerminoDisparo, Ativo, 
		Criacao, CodigoRemetente, CodigoStatusDisparo, CodigoAmbiente	
	ORDER BY CodigoStatusDisparo, TerminoDisparo desc, Codigo 
END
GO

/****** Object:  StoredProcedure [email].[VariavelValorListar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[VariavelValorListar]
	@CodigoDisparo int,
	@CodigoContato int
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		v.Nome, vv.Valor
	FROM email.VariavelValor vv
	INNER JOIN email.Variavel v ON vv.CodigoVariavel = v.Codigo
	WHERE CodigoContato = @CodigoContato AND CodigoDisparo = @CodigoDisparo
END
GO

/****** Object:  StoredProcedure [email].[DisparoListarPorMensagem]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[DisparoListarPorMensagem]
	@CodigoMensagem int
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		di.Codigo, CodigoMensagem, InicioAgendamento, TerminoAgendamento, InicioDisparo, TerminoDisparo, Ativo, 
		Criacao, CodigoRemetente, CodigoStatusDisparo, CodigoAmbiente, COUNT(di.Codigo) AS Total
	FROM email.Disparo di
	INNER JOIN email.Destinatario de ON de.CodigoDisparo = di.Codigo
	WHERE CodigoMensagem = @CodigoMensagem
	GROUP BY di.Codigo, CodigoMensagem, InicioAgendamento, TerminoAgendamento, InicioDisparo, TerminoDisparo, Ativo, 
		Criacao, CodigoRemetente, CodigoStatusDisparo, CodigoAmbiente	
END
GO

/****** Object:  StoredProcedure [email].[VisitaLinkAtualizar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[VisitaLinkAtualizar]
	@CodigoDisparo int = NULL,
	@CodigoContato int = NULL,
	@CodigoLink int = NULL,
	@Visitas int = NULL,
	@PrimeiraVisita smalldatetime = NULL
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE VisitaLink
	SET CodigoContato = @CodigoContato, CodigoLink = @CodigoLink, Visitas = @Visitas, PrimeiraVisita = @PrimeiraVisita
	WHERE CodigoDisparo = @CodigoDisparo

END
GO

/****** Object:  StoredProcedure [email].[VisitaLinkConsultar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[VisitaLinkConsultar]
	@CodigoDisparo int
AS

BEGIN
	SET NOCOUNT ON;
	SELECT
	CodigoDisparo, CodigoContato, CodigoLink, Visitas, PrimeiraVisita FROM email.VisitaLink
	WHERE CodigoDisparo = @CodigoDisparo
END
GO

/****** Object:  StoredProcedure [email].[VisitaLinkExcluir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[VisitaLinkExcluir]
	@CodigoDisparo int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM email.VisitaLink WHERE CodigoDisparo = @CodigoDisparo

END
GO

/****** Object:  StoredProcedure [email].[OcorrenciaDisparoBuscarDetalhes]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[OcorrenciaDisparoBuscarDetalhes]
	@CodigoDisparo int,
	@CodigoContato int	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT R.Nome AS NomeRemetente, R.Email AS EmailRemetente, C.Nome AS NomeDestinatario, C.Email AS EmailDestinatario, M.Assunto, M.HTML,
	M.Codigo as CodigoMensagem, CA.Codigo AS CodigoCampanha, CA.Nome AS NomeCampanha
	FROM email.Disparo D 
	INNER JOIN email.Remetente R ON R.Codigo = D.CodigoRemetente
	INNER JOIN email.OcorrenciaDisparo OD ON OD.CodigoDisparo = D.Codigo
	INNER JOIN email.Contato C ON C.Codigo = OD.CodigoContato
	INNER JOIN email.Mensagem M ON M.Codigo = D.CodigoMensagem
	LEFT JOIN email.Campanha CA ON CA.Codigo = M.CodigoCampanha	
	WHERE D.Codigo = @CodigoDisparo AND C.Codigo = @CodigoContato;

	EXEC [email].[DestinatarioCopiaListar] @CodigoDisparo;	
END
GO

/****** Object:  StoredProcedure [email].[VariavelValorGlobalExcluir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [email].[VariavelValorGlobalExcluir]
	@Codigo int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM email.VariavelValorGlobal
	WHERE Codigo = @Codigo
END
GO

/****** Object:  StoredProcedure [email].[OcorrenciaDisparoGerar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[OcorrenciaDisparoGerar]
   @CodigoDisparo INT,
   @DataAtual DATETIME
AS
BEGIN
	INSERT INTO OcorrenciaDisparo (CodigoDisparo, CodigoContato, CodigoAmbiente, CodigoStatusDisparo, Criacao)
	SELECT DISTINCT disp.Codigo, c.Codigo, disp.CodigoAmbiente, 1, @DataAtual
	  FROM [Destinatario] d 
	  LEFT JOIN GrupoContato gc ON gc.CodigoGrupo = d.CodigoGrupo 
	  LEFT HASH JOIN Grupo g ON g.Codigo = gc.CodigoGrupo 
	 INNER JOIN Contato c ON c.Codigo = ISNULL(d.CodigoContato,gc.CodigoContato)
	 INNER JOIN Disparo disp ON disp.Codigo = d.CodigoDisparo
	 INNER JOIN Mensagem m ON m.Codigo = disp.CodigoMensagem
	  LEFT JOIN ContatoRemocao cr ON cr.CodigoCampanha = m.CodigoCampanha and cr.CodigoContato = c.Codigo
	 WHERE CodigoDisparo = @CodigoDisparo AND c.Ativo = 1 AND (d.CodigoGrupo IS NULL OR g.Ativo = 1)
	   AND cr.Remocao IS NULL
END
GO

/****** Object:  StoredProcedure [email].[VariavelValorGlobalAtualizar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [email].[VariavelValorGlobalAtualizar]
	@Codigo int = NULL,
	@CodigoAmbiente int = NULL,
	@Chave varchar(50) = NULL,
	@Valor varchar(1000) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE email.VariavelValorGlobal
	SET CodigoAmbiente = @CodigoAmbiente, Chave = @Chave, Valor = @Valor
	WHERE Codigo = @Codigo
END
GO

/****** Object:  StoredProcedure [email].[GrupoContatoExcluir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[GrupoContatoExcluir]
	@CodigoGrupo int,
	@CodigoContato int	
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM email.GrupoContato WHERE CodigoContato = @CodigoContato AND CodigoGrupo = @CodigoGrupo
END
GO

/****** Object:  StoredProcedure [email].[GrupoConsultar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[GrupoConsultar]
	@Codigo int
AS

BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoAmbiente, Nome, Ativo, Criacao, Sistema FROM email.Grupo
	WHERE Codigo = @Codigo
END
GO

/****** Object:  StoredProcedure [email].[GrupoAtualizar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[GrupoAtualizar]
	@Codigo int = NULL,
	@CodigoAmbiente int = NULL,
	@Nome varchar(100) = NULL,
	@Ativo bit = NULL,
	@Sistema bit = NULL	
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE Grupo
	SET Nome = @Nome, Ativo = @Ativo, CodigoAmbiente = @CodigoAmbiente, Sistema = @Sistema
	WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[LinkAtualizar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[LinkAtualizar]
	@Codigo int = NULL,
	@CodigoMensagem int = NULL,
	@Endereco varchar(1000) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE Link
	SET CodigoMensagem = @CodigoMensagem, Endereco = @Endereco
	WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[LinkConsultar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[LinkConsultar]
	@Codigo int
AS

BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoMensagem, Endereco FROM email.Link
	WHERE Codigo = @Codigo
END
GO

/****** Object:  StoredProcedure [email].[LinkExcluir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[LinkExcluir]
	@Codigo int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM email.Link WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[LinkInserir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[LinkInserir]
	@Codigo int OUTPUT,
	@CodigoMensagem int = NULL,
	@Endereco varchar(1000) = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO Link(CodigoMensagem, Endereco)
	VALUES (@CodigoMensagem, @Endereco)

	IF @@ERROR = 0
		SET @Codigo = SCOPE_IDENTITY()
	ELSE
		SET @Codigo = -1
END
GO

/****** Object:  StoredProcedure [email].[LinkListar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[LinkListar]
	@CodigoMensagem int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoMensagem, Endereco FROM email.Link
	WHERE CodigoMensagem = @CodigoMensagem
END
GO

/****** Object:  StoredProcedure [email].[LinkParametroRastreamentoConsultar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[LinkParametroRastreamentoConsultar]
	@CodigoLink int
AS

BEGIN
	SET NOCOUNT ON;
	SELECT
	CodigoLink, CodigoParametroRastreamento, Valor, P.Nome FROM email.LinkParametroRastreamento L
	INNER JOIN ParametroRastreamento P ON P.Codigo = L.CodigoParametroRastreamento
	WHERE CodigoLink = @CodigoLink
END
GO

/****** Object:  StoredProcedure [email].[LinkParametroRastreamentoExcluir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [email].[LinkParametroRastreamentoExcluir]
	@CodigoLink int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM email.LinkParametroRastreamento WHERE CodigoLink = @CodigoLink
END
GO

/****** Object:  StoredProcedure [email].[LinkParametroRastreamentoInserir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[LinkParametroRastreamentoInserir]
	@CodigoLink int,
	@CodigoParametroRastreamento int,
	@Valor varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO LinkParametroRastreamento(CodigoLink, CodigoParametroRastreamento, Valor)
	VALUES(@CodigoLink, @CodigoParametroRastreamento, @Valor)	
END
GO

/****** Object:  StoredProcedure [email].[MensagemInserir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[MensagemInserir]
	@Codigo int OUTPUT,
	@CodigoAmbiente int = NULL,
	@CodigoCampanha int = NULL,
	@Nome varchar(50) = NULL,
	@Assunto varchar(100) = NULL,
	@HTML text = NULL,
	@Ativo bit = NULL,
	@Criacao datetime = NULL,
	@CodigoTipo int = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO Mensagem(CodigoCampanha, Nome, Assunto, HTML, Ativo, Criacao, CodigoAmbiente, CodigoTipo)
	VALUES (@CodigoCampanha, @Nome, @Assunto, @HTML, @Ativo, @Criacao, @CodigoAmbiente, @CodigoTipo)

	IF @@ERROR = 0
		SET @Codigo = SCOPE_IDENTITY()
	ELSE
		SET @Codigo = -1
END
GO

/****** Object:  StoredProcedure [email].[DestinatarioCopiaInserir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [email].[DestinatarioCopiaInserir]
	@CodigoDisparo int,	
	@CodigoContato int = null,
	@Inclusao smalldatetime
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO DestinatarioCopia(CodigoDisparo, CodigoContato, Inclusao)
	VALUES(@CodigoDisparo, @CodigoContato, @Inclusao)
END
GO

/****** Object:  StoredProcedure [email].[CampanhaGrupoExcluir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[CampanhaGrupoExcluir]
	@CodigoCampanha int,
	@CodigoGrupo int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM email.CampanhaGrupo WHERE CodigoGrupo = @CodigoGrupo AND CodigoCampanha = @CodigoCampanha
END
GO

/****** Object:  StoredProcedure [email].[VariavelListar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[VariavelListar]
	@CodigoDisparo int
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT
		v.Codigo, v.CodigoMensagem, v.Nome, v.Ativo, Sistema 
	FROM email.Variavel v
	INNER JOIN email.Mensagem m ON v.CodigoMensagem = m.Codigo
	INNER JOIN email.Disparo d ON d.CodigoMensagem = m.Codigo
	AND d.Codigo = @CodigoDisparo
	
END
GO

/****** Object:  StoredProcedure [email].[MensagemExcluir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[MensagemExcluir]
	@Codigo int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM email.Mensagem WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[MensagemConsultar]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[MensagemConsultar]
	@Codigo int
AS

BEGIN
	SET NOCOUNT ON;
	SELECT
	Codigo, CodigoCampanha, Nome, Assunto, HTML, Ativo, Criacao, CodigoAmbiente, CodigoTipo FROM email.Mensagem
	WHERE Codigo = @Codigo
END
GO

/****** Object:  StoredProcedure [email].[VariavelInserir]    Script Date: 30/03/2022 11:09:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[VariavelInserir]
	@Codigo int OUTPUT,
	@CodigoMensagem int = NULL,
	@Nome varchar(50) = NULL,
	@Ativo bit = NULL,
	@Sistema bit = NULL
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO email.Variavel(CodigoMensagem, Nome, Ativo, Sistema)
	VALUES (@CodigoMensagem, @Nome, @Ativo, @Sistema)

	IF @@ERROR = 0
		SET @Codigo = SCOPE_IDENTITY()
	ELSE
		SET @Codigo = -1
END
GO

/****** Object:  StoredProcedure [email].[VariavelExcluir]    Script Date: 30/03/2022 11:09:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[VariavelExcluir]
	@Codigo int
AS
BEGIN
	SET NOCOUNT ON;

	DELETE FROM email.Variavel WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[DisparoAtualizar]    Script Date: 30/03/2022 11:09:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[DisparoAtualizar]
	@Codigo int = NULL,
	@CodigoMensagem int = NULL,
	@CodigoAmbiente int = NULL,
	@InicioAgendamento smalldatetime = NULL,
	@TerminoAgendamento smalldatetime = NULL,
	@InicioDisparo smalldatetime = NULL,
	@TerminoDisparo smalldatetime = NULL,
	@Ativo bit = NULL,	
	@CodigoRemetente int = NULL,
	@CodigoStatusDisparo tinyint = NULL
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE Disparo
	SET CodigoMensagem = @CodigoMensagem, InicioAgendamento = @InicioAgendamento, TerminoAgendamento = @TerminoAgendamento, 
		InicioDisparo = @InicioDisparo, TerminoDisparo = @TerminoDisparo, Ativo = @Ativo, CodigoRemetente = @CodigoRemetente, 
		CodigoStatusDisparo = @CodigoStatusDisparo, CodigoAmbiente = @CodigoAmbiente
	WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[DestinatarioInserir]    Script Date: 30/03/2022 11:09:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[DestinatarioInserir]
	@CodigoDisparo int,
	@CodigoGrupo int = null,
	@CodigoContato int = null,
	@Inclusao smalldatetime
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO Destinatario(CodigoDisparo, CodigoGrupo, CodigoContato, Inclusao)
	VALUES(@CodigoDisparo, @CodigoGrupo, @CodigoContato, @Inclusao)
END
GO

/****** Object:  StoredProcedure [email].[MensagemAtualizar]    Script Date: 30/03/2022 11:09:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [email].[MensagemAtualizar]
	@Codigo int = NULL,
	@CodigoAmbiente int = NULL,
	@CodigoCampanha int = NULL,	
	@Nome varchar(50) = NULL,
	@Assunto varchar(100) = NULL,
	@HTML text = NULL,
	@Ativo bit = NULL,
	@CodigoTipo int = NULL
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE Mensagem
	SET CodigoCampanha = @CodigoCampanha, Nome = @Nome, Assunto = @Assunto, HTML = @HTML, Ativo = @Ativo, CodigoAmbiente = @CodigoAmbiente, CodigoTipo = @CodigoTipo
	WHERE Codigo = @Codigo

END
GO

/****** Object:  StoredProcedure [email].[VariavelListarPorMensagem]    Script Date: 30/03/2022 11:09:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [email].[VariavelListarPorMensagem]
	@CodigoMensagem int
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT Codigo, CodigoMensagem, Nome, Ativo, Sistema 
	FROM email.Variavel
	WHERE CodigoMensagem = @CodigoMensagem AND Ativo = 1
	
END
GO

/****** Object:  StoredProcedure [email].[DestinatarioCopiaListar]    Script Date: 30/03/2022 11:09:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [email].[DestinatarioCopiaListar]
	@CodigoDisparo int	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT C.Nome, C.Email FROM email.DestinatarioCopia DC 
	INNER JOIN email.Contato C ON C.Codigo = DC.CodigoContato AND DC.CodigoDisparo = @CodigoDisparo
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [config].[AmbienteInserir]
	@Codigo int OUTPUT,
	@Apelido varchar(50),
	@NomeResponsavel varchar(100),
	@EmailResponsavel varchar(100)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO config.Ambiente([Apelido],[NomeResponsavel],[EmailResponsavel])
	VALUES(@Apelido, @NomeResponsavel, @EmailResponsavel)

	IF @@ERROR = 0
		SET @Codigo = SCOPE_IDENTITY()
	ELSE
		SET @Codigo = -1
END
GO