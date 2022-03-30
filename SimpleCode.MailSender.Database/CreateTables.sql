/****** Object:  Table [config].[Ambiente]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [config].[Ambiente](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[Apelido] [varchar](50) NOT NULL,
	[NomeResponsavel] [varchar](100) NULL,
	[EmailResponsavel] [varchar](100) NULL,
	[CodigoCanalHome] [int] NULL,
	[CodigoCanalLinks] [int] NULL,
	[CodigoCanalSignin] [int] NULL,
	[CodigoUsuarioFaleConosco] [int] NULL,
	[CodigoIdiomaPadrao] [int] NULL,
	[PermitirTrocaIdiomas] [bit] NULL,
 CONSTRAINT [PK_Ambiente] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[Mensagem]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[Mensagem](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[CodigoAmbiente] [int] NOT NULL,
	[CodigoCampanha] [int] NULL,
	[CodigoTipo] [int] NOT NULL,
	[Nome] [varchar](50) NOT NULL,
	[Assunto] [varchar](100) NOT NULL,
	[HTML] [text] NOT NULL,
	[Ativo] [bit] NOT NULL,
	[Criacao] [datetime] NOT NULL,
 CONSTRAINT [PK_tbEmails] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [email].[OcorrenciaDisparo]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[OcorrenciaDisparo](
	[CodigoDisparo] [int] NOT NULL,
	[CodigoContato] [int] NOT NULL,
	[CodigoAmbiente] [int] NOT NULL,
	[Enviado] [bit] NOT NULL,
	[CodigoStatusDisparo] [tinyint] NOT NULL,
	[Criacao] [datetime] NOT NULL,
	[UltimaAlteracao] [datetime] NULL,
	[Visitas] [smallint] NULL,
	[PrimeiraVisita] [datetime] NULL,
	[Tentativas] [smallint] NULL,
 CONSTRAINT [PK_OcorrenciaDisparo] PRIMARY KEY CLUSTERED 
(
	[CodigoDisparo] ASC,
	[CodigoContato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[ParametroRastreamento]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[ParametroRastreamento](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](256) NOT NULL,
 CONSTRAINT [PK_ParametroRastreamento] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[Remetente]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[Remetente](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[CodigoAmbiente] [int] NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[Nome] [varchar](100) NOT NULL,
	[Apelido] [varchar](50) NOT NULL,
	[Criacao] [datetime] NOT NULL,
	[Padrao] [bit] NOT NULL,
 CONSTRAINT [PK_Remetente] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[Servidor]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[Servidor](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[CodigoAmbiente] [int] NOT NULL,
	[Apelido] [varchar](100) NOT NULL,
	[Endereco] [varchar](150) NOT NULL,
	[Porta] [int] NULL,
	[Usuario] [varchar](50) NULL,
	[Senha] [varchar](250) NULL,
	[SSL] [bit] NOT NULL,
	[Padrao] [bit] NOT NULL,
 CONSTRAINT [PK_Servidor] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[SnapshotDisparo]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[SnapshotDisparo](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[Criacao] [datetime] NOT NULL,
	[CodigoDisparo] [int] NOT NULL,
	[CodigoContato] [int] NOT NULL,
	[Assunto] [varchar](100) NOT NULL,
	[HTML] [text] NOT NULL,
 CONSTRAINT [PK_Snapshot] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [email].[Variavel]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[Variavel](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[CodigoMensagem] [int] NOT NULL,
	[Nome] [varchar](50) NOT NULL,
	[Ativo] [bit] NOT NULL,
	[Sistema] [bit] NOT NULL,
 CONSTRAINT [PK_Variavel] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[TipoMensagem]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[TipoMensagem](
	[Codigo] [int] NOT NULL,
	[Descricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TipoMensagem] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[VariavelValor]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[VariavelValor](
	[CodigoVariavel] [int] NOT NULL,
	[CodigoContato] [int] NOT NULL,
	[CodigoDisparo] [int] NOT NULL,
	[Valor] [varchar](max) NULL,
	[Atualizacao] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_VariavelValor_1] PRIMARY KEY CLUSTERED 
(
	[CodigoVariavel] ASC,
	[CodigoContato] ASC,
	[CodigoDisparo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [email].[VariavelValorGlobal]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[VariavelValorGlobal](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[CodigoAmbiente] [int] NOT NULL,
	[Chave] [varchar](50) NOT NULL,
	[Valor] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_VariavelValorGlobal] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[VisitaLink]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[VisitaLink](
	[CodigoDisparo] [int] NOT NULL,
	[CodigoContato] [int] NOT NULL,
	[CodigoLink] [int] NOT NULL,
	[Visitas] [int] NOT NULL,
	[PrimeiraVisita] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_VisitaLink] PRIMARY KEY CLUSTERED 
(
	[CodigoDisparo] ASC,
	[CodigoContato] ASC,
	[CodigoLink] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[Link]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[Link](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[CodigoMensagem] [int] NOT NULL,
	[Endereco] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_Link] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[StatusDisparo]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[StatusDisparo](
	[Codigo] [tinyint] IDENTITY(1,1) NOT NULL,
	[Descricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_StatusDisparo] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[GrupoContato]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[GrupoContato](
	[CodigoGrupo] [int] NOT NULL,
	[CodigoContato] [int] NOT NULL,
 CONSTRAINT [PK_GrupoContato] PRIMARY KEY CLUSTERED 
(
	[CodigoGrupo] ASC,
	[CodigoContato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[LinkParametroRastreamento]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[LinkParametroRastreamento](
	[CodigoLink] [int] NOT NULL,
	[CodigoParametroRastreamento] [int] NOT NULL,
	[Valor] [varchar](50) NULL,
 CONSTRAINT [PK_LinkParametroRastreamento] PRIMARY KEY CLUSTERED 
(
	[CodigoLink] ASC,
	[CodigoParametroRastreamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[Disparo]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[Disparo](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[CodigoAmbiente] [int] NOT NULL,
	[CodigoMensagem] [int] NOT NULL,
	[InicioAgendamento] [smalldatetime] NULL,
	[TerminoAgendamento] [smalldatetime] NULL,
	[InicioDisparo] [smalldatetime] NULL,
	[TerminoDisparo] [smalldatetime] NULL,
	[Ativo] [bit] NOT NULL,
	[Criacao] [smalldatetime] NOT NULL,
	[CodigoRemetente] [int] NOT NULL,
	[CodigoStatusDisparo] [tinyint] NOT NULL,
 CONSTRAINT [PK_Disparo] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[DestinatarioCopia]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[DestinatarioCopia](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[CodigoDisparo] [int] NOT NULL,
	[CodigoContato] [int] NOT NULL,
	[Inclusao] [smalldatetime] NULL,
 CONSTRAINT [PK_DestinatarioCopia] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[Destinatario]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[Destinatario](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[CodigoDisparo] [int] NOT NULL,
	[CodigoGrupo] [int] NULL,
	[CodigoContato] [int] NULL,
	[Inclusao] [smalldatetime] NULL,
 CONSTRAINT [PK_Destinatario] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Destinatario_CodigoContatoDisparoGrupo] UNIQUE NONCLUSTERED 
(
	[CodigoContato] ASC,
	[CodigoDisparo] ASC,
	[CodigoGrupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[ContatoRemocao]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[ContatoRemocao](
	[CodigoContato] [int] NOT NULL,
	[CodigoCampanha] [int] NOT NULL,
	[Remocao] [datetime] NULL,
 CONSTRAINT [PK_ContatoRemocao] PRIMARY KEY CLUSTERED 
(
	[CodigoContato] ASC,
	[CodigoCampanha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[Contato]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[Contato](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[CodigoAmbiente] [int] NOT NULL,
	[Nome] [varchar](100) NOT NULL,
	[Apelido] [varchar](50) NULL,
	[Email] [varchar](100) NOT NULL,
	[Ativo] [bit] NOT NULL,
	[Criacao] [datetime] NOT NULL,
 CONSTRAINT [PK_Contato] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[CampanhaGrupo]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[CampanhaGrupo](
	[CodigoCampanha] [int] NOT NULL,
	[CodigoGrupo] [int] NOT NULL,
 CONSTRAINT [PK_CampanhaGrupo] PRIMARY KEY CLUSTERED 
(
	[CodigoCampanha] ASC,
	[CodigoGrupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[Campanha]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[Campanha](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[CodigoAmbiente] [int] NOT NULL,
	[CodigoServidor] [int] NULL,
	[CodigoRemetente] [int] NULL,
	[Nome] [varchar](50) NOT NULL,
	[Ativo] [bit] NOT NULL,
	[Criacao] [datetime] NOT NULL,
 CONSTRAINT [PK_Campanha] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UQ_Campanha_Nome] UNIQUE NONCLUSTERED 
(
	[Nome] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[Anexo]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[Anexo](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[CodigoDisparo] [int] NOT NULL,
	[CodigoContato] [int] NULL,
	[Arquivo] [varchar](500) NOT NULL,
 CONSTRAINT [PK_Anexo] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[Alerta]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[Alerta](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[Origem] [varchar](256) NOT NULL,
	[CodigoUsuario] [int] NULL,
	[IP] [varchar](50) NULL,
	[Criacao] [datetime] NOT NULL,
	[Descricao] [varchar](500) NULL,
	[Detalhes] [varchar](500) NULL,
	[Tipo] [int] NOT NULL,
 CONSTRAINT [PK_Alerta] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [email].[Grupo]    Script Date: 30/03/2022 11:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [email].[Grupo](
	[Codigo] [int] IDENTITY(1,1) NOT NULL,
	[CodigoAmbiente] [int] NOT NULL,
	[Nome] [varchar](100) NOT NULL,
	[Ativo] [bit] NOT NULL,
	[Criacao] [smalldatetime] NOT NULL,
	[Sistema] [bit] NULL,
 CONSTRAINT [PK_Grupo] PRIMARY KEY CLUSTERED 
(
	[Codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [email].[Mensagem] ADD  CONSTRAINT [DF__Mensagem__Ativo__2E1BDC42]  DEFAULT ((0)) FOR [Ativo]
GO

ALTER TABLE [email].[Mensagem] ADD  CONSTRAINT [DF__Mensagem__Criaca__2F10007B]  DEFAULT (getdate()) FOR [Criacao]
GO

ALTER TABLE [email].[OcorrenciaDisparo] ADD  CONSTRAINT [DF__Ocorrenci__Envia__300424B4]  DEFAULT ((0)) FOR [Enviado]
GO

ALTER TABLE [email].[OcorrenciaDisparo] ADD  CONSTRAINT [DF__Ocorrenci__Criac__30F848ED]  DEFAULT (getdate()) FOR [Criacao]
GO

ALTER TABLE [email].[Servidor] ADD  CONSTRAINT [DF_Servidor_Padrao]  DEFAULT ((0)) FOR [Padrao]
GO

ALTER TABLE [email].[Disparo] ADD  CONSTRAINT [DF__Disparo__Ativo__2A4B4B5E]  DEFAULT ((1)) FOR [Ativo]
GO

ALTER TABLE [email].[Disparo] ADD  CONSTRAINT [DF__Disparo__Criacao__2B3F6F97]  DEFAULT (getdate()) FOR [Criacao]
GO

ALTER TABLE [email].[Contato] ADD  CONSTRAINT [DF__Contato__Ativo__286302EC]  DEFAULT ((1)) FOR [Ativo]
GO

ALTER TABLE [email].[Contato] ADD  CONSTRAINT [DF__Contato__Criacao__29572725]  DEFAULT (getdate()) FOR [Criacao]
GO

ALTER TABLE [email].[Campanha] ADD  CONSTRAINT [DF__Campanha__Ativo__267ABA7A]  DEFAULT ((0)) FOR [Ativo]
GO

ALTER TABLE [email].[Campanha] ADD  CONSTRAINT [DF__Campanha__Criaca__276EDEB3]  DEFAULT (getdate()) FOR [Criacao]
GO

ALTER TABLE [email].[Grupo] ADD  CONSTRAINT [DF__Grupo__Ativo__2C3393D0]  DEFAULT ((0)) FOR [Ativo]
GO

ALTER TABLE [email].[Grupo] ADD  CONSTRAINT [DF__Grupo__Criacao__2D27B809]  DEFAULT (getdate()) FOR [Criacao]
GO

ALTER TABLE [config].[Ambiente]  WITH NOCHECK ADD  CONSTRAINT [FK_Ambiente_Idioma] FOREIGN KEY([CodigoIdiomaPadrao])
REFERENCES [config].[Idioma] ([Codigo])
NOT FOR REPLICATION 
GO

ALTER TABLE [config].[Ambiente] NOCHECK CONSTRAINT [FK_Ambiente_Idioma]
GO

ALTER TABLE [email].[Mensagem]  WITH CHECK ADD  CONSTRAINT [FK_Mensagem_Ambiente] FOREIGN KEY([CodigoAmbiente])
REFERENCES [config].[Ambiente] ([Codigo])
GO

ALTER TABLE [email].[Mensagem] CHECK CONSTRAINT [FK_Mensagem_Ambiente]
GO

ALTER TABLE [email].[Mensagem]  WITH NOCHECK ADD  CONSTRAINT [FK_Mensagem_Campanha] FOREIGN KEY([CodigoCampanha])
REFERENCES [email].[Campanha] ([Codigo])
NOT FOR REPLICATION 
GO

ALTER TABLE [email].[Mensagem] NOCHECK CONSTRAINT [FK_Mensagem_Campanha]
GO

ALTER TABLE [email].[Mensagem]  WITH CHECK ADD  CONSTRAINT [FK_Mensagem_TipoMensagem] FOREIGN KEY([CodigoTipo])
REFERENCES [email].[TipoMensagem] ([Codigo])
GO

ALTER TABLE [email].[Mensagem] CHECK CONSTRAINT [FK_Mensagem_TipoMensagem]
GO

ALTER TABLE [email].[OcorrenciaDisparo]  WITH CHECK ADD  CONSTRAINT [FK_OcorrenciaDisparo_Ambiente] FOREIGN KEY([CodigoAmbiente])
REFERENCES [config].[Ambiente] ([Codigo])
GO

ALTER TABLE [email].[OcorrenciaDisparo] CHECK CONSTRAINT [FK_OcorrenciaDisparo_Ambiente]
GO

ALTER TABLE [email].[OcorrenciaDisparo]  WITH CHECK ADD  CONSTRAINT [FK_OcorrenciaDisparo_Contato] FOREIGN KEY([CodigoContato])
REFERENCES [email].[Contato] ([Codigo])
GO

ALTER TABLE [email].[OcorrenciaDisparo] CHECK CONSTRAINT [FK_OcorrenciaDisparo_Contato]
GO

ALTER TABLE [email].[OcorrenciaDisparo]  WITH CHECK ADD  CONSTRAINT [FK_OcorrenciaDisparo_Disparo] FOREIGN KEY([CodigoDisparo])
REFERENCES [email].[Disparo] ([Codigo])
GO

ALTER TABLE [email].[OcorrenciaDisparo] CHECK CONSTRAINT [FK_OcorrenciaDisparo_Disparo]
GO

ALTER TABLE [email].[OcorrenciaDisparo]  WITH CHECK ADD  CONSTRAINT [FK_OcorrenciaDisparo_StatusDisparo] FOREIGN KEY([CodigoStatusDisparo])
REFERENCES [email].[StatusDisparo] ([Codigo])
GO

ALTER TABLE [email].[OcorrenciaDisparo] CHECK CONSTRAINT [FK_OcorrenciaDisparo_StatusDisparo]
GO

ALTER TABLE [email].[Remetente]  WITH CHECK ADD  CONSTRAINT [FK_Remetente_Ambiente] FOREIGN KEY([CodigoAmbiente])
REFERENCES [config].[Ambiente] ([Codigo])
GO

ALTER TABLE [email].[Remetente] CHECK CONSTRAINT [FK_Remetente_Ambiente]
GO

ALTER TABLE [email].[Servidor]  WITH CHECK ADD  CONSTRAINT [FK_Servidor_Ambiente] FOREIGN KEY([CodigoAmbiente])
REFERENCES [config].[Ambiente] ([Codigo])
GO

ALTER TABLE [email].[Servidor] CHECK CONSTRAINT [FK_Servidor_Ambiente]
GO

ALTER TABLE [email].[Variavel]  WITH CHECK ADD  CONSTRAINT [FK_Variavel_Mensagem1] FOREIGN KEY([CodigoMensagem])
REFERENCES [email].[Mensagem] ([Codigo])
GO

ALTER TABLE [email].[Variavel] CHECK CONSTRAINT [FK_Variavel_Mensagem1]
GO

ALTER TABLE [email].[VariavelValor]  WITH CHECK ADD  CONSTRAINT [FK_VariavelValor_Contato] FOREIGN KEY([CodigoContato])
REFERENCES [email].[Contato] ([Codigo])
GO

ALTER TABLE [email].[VariavelValor] CHECK CONSTRAINT [FK_VariavelValor_Contato]
GO

ALTER TABLE [email].[VariavelValor]  WITH CHECK ADD  CONSTRAINT [FK_VariavelValor_Disparo] FOREIGN KEY([CodigoDisparo])
REFERENCES [email].[Disparo] ([Codigo])
GO

ALTER TABLE [email].[VariavelValor] CHECK CONSTRAINT [FK_VariavelValor_Disparo]
GO

ALTER TABLE [email].[VariavelValor]  WITH CHECK ADD  CONSTRAINT [FK_VariavelValor_Variavel] FOREIGN KEY([CodigoVariavel])
REFERENCES [email].[Variavel] ([Codigo])
GO

ALTER TABLE [email].[VariavelValor] CHECK CONSTRAINT [FK_VariavelValor_Variavel]
GO

ALTER TABLE [email].[VisitaLink]  WITH CHECK ADD  CONSTRAINT [FK_VisitaLink_Link] FOREIGN KEY([CodigoLink])
REFERENCES [email].[Link] ([Codigo])
GO

ALTER TABLE [email].[VisitaLink] CHECK CONSTRAINT [FK_VisitaLink_Link]
GO

ALTER TABLE [email].[VisitaLink]  WITH CHECK ADD  CONSTRAINT [FK_VisitaLink_OcorrenciaDisparo] FOREIGN KEY([CodigoDisparo], [CodigoContato])
REFERENCES [email].[OcorrenciaDisparo] ([CodigoDisparo], [CodigoContato])
GO

ALTER TABLE [email].[VisitaLink] CHECK CONSTRAINT [FK_VisitaLink_OcorrenciaDisparo]
GO

ALTER TABLE [email].[Link]  WITH CHECK ADD  CONSTRAINT [FK_Link_Mensagem] FOREIGN KEY([CodigoMensagem])
REFERENCES [email].[Mensagem] ([Codigo])
GO

ALTER TABLE [email].[Link] CHECK CONSTRAINT [FK_Link_Mensagem]
GO

ALTER TABLE [email].[GrupoContato]  WITH CHECK ADD  CONSTRAINT [FK_GrupoContato_Contato] FOREIGN KEY([CodigoContato])
REFERENCES [email].[Contato] ([Codigo])
GO

ALTER TABLE [email].[GrupoContato] CHECK CONSTRAINT [FK_GrupoContato_Contato]
GO

ALTER TABLE [email].[GrupoContato]  WITH CHECK ADD  CONSTRAINT [FK_GrupoContato_Grupo] FOREIGN KEY([CodigoGrupo])
REFERENCES [email].[Grupo] ([Codigo])
GO

ALTER TABLE [email].[GrupoContato] CHECK CONSTRAINT [FK_GrupoContato_Grupo]
GO

ALTER TABLE [email].[LinkParametroRastreamento]  WITH CHECK ADD  CONSTRAINT [FK_LinkParametroRastreamento_Link] FOREIGN KEY([CodigoLink])
REFERENCES [email].[Link] ([Codigo])
GO

ALTER TABLE [email].[LinkParametroRastreamento] CHECK CONSTRAINT [FK_LinkParametroRastreamento_Link]
GO

ALTER TABLE [email].[LinkParametroRastreamento]  WITH CHECK ADD  CONSTRAINT [FK_LinkParametroRastreamento_ParametroRastreamento] FOREIGN KEY([CodigoParametroRastreamento])
REFERENCES [email].[ParametroRastreamento] ([Codigo])
GO

ALTER TABLE [email].[LinkParametroRastreamento] CHECK CONSTRAINT [FK_LinkParametroRastreamento_ParametroRastreamento]
GO

ALTER TABLE [email].[Disparo]  WITH CHECK ADD  CONSTRAINT [FK_Disparo_Ambiente] FOREIGN KEY([CodigoAmbiente])
REFERENCES [config].[Ambiente] ([Codigo])
GO

ALTER TABLE [email].[Disparo] CHECK CONSTRAINT [FK_Disparo_Ambiente]
GO

ALTER TABLE [email].[Disparo]  WITH CHECK ADD  CONSTRAINT [FK_Disparo_Mensagem] FOREIGN KEY([CodigoMensagem])
REFERENCES [email].[Mensagem] ([Codigo])
GO

ALTER TABLE [email].[Disparo] CHECK CONSTRAINT [FK_Disparo_Mensagem]
GO

ALTER TABLE [email].[Disparo]  WITH CHECK ADD  CONSTRAINT [FK_Disparo_Remetente] FOREIGN KEY([CodigoRemetente])
REFERENCES [email].[Remetente] ([Codigo])
GO

ALTER TABLE [email].[Disparo] CHECK CONSTRAINT [FK_Disparo_Remetente]
GO

ALTER TABLE [email].[Disparo]  WITH CHECK ADD  CONSTRAINT [FK_Disparo_StatusDisparo] FOREIGN KEY([CodigoStatusDisparo])
REFERENCES [email].[StatusDisparo] ([Codigo])
GO

ALTER TABLE [email].[Disparo] CHECK CONSTRAINT [FK_Disparo_StatusDisparo]
GO

ALTER TABLE [email].[DestinatarioCopia]  WITH CHECK ADD  CONSTRAINT [FK_DestinatarioCopia_Contato] FOREIGN KEY([CodigoContato])
REFERENCES [email].[Contato] ([Codigo])
GO

ALTER TABLE [email].[DestinatarioCopia] CHECK CONSTRAINT [FK_DestinatarioCopia_Contato]
GO

ALTER TABLE [email].[DestinatarioCopia]  WITH CHECK ADD  CONSTRAINT [FK_DestinatarioCopia_Disparo] FOREIGN KEY([CodigoDisparo])
REFERENCES [email].[Disparo] ([Codigo])
GO

ALTER TABLE [email].[DestinatarioCopia] CHECK CONSTRAINT [FK_DestinatarioCopia_Disparo]
GO

ALTER TABLE [email].[Destinatario]  WITH CHECK ADD  CONSTRAINT [FK_Destinatario_Contato] FOREIGN KEY([CodigoContato])
REFERENCES [email].[Contato] ([Codigo])
GO

ALTER TABLE [email].[Destinatario] CHECK CONSTRAINT [FK_Destinatario_Contato]
GO

ALTER TABLE [email].[Destinatario]  WITH CHECK ADD  CONSTRAINT [FK_Destinatario_Disparo] FOREIGN KEY([CodigoDisparo])
REFERENCES [email].[Disparo] ([Codigo])
GO

ALTER TABLE [email].[Destinatario] CHECK CONSTRAINT [FK_Destinatario_Disparo]
GO

ALTER TABLE [email].[Destinatario]  WITH CHECK ADD  CONSTRAINT [FK_Destinatarios_Grupos] FOREIGN KEY([CodigoGrupo])
REFERENCES [email].[Grupo] ([Codigo])
GO

ALTER TABLE [email].[Destinatario] CHECK CONSTRAINT [FK_Destinatarios_Grupos]
GO

ALTER TABLE [email].[ContatoRemocao]  WITH CHECK ADD  CONSTRAINT [FK_ContatoRemocao_Contato] FOREIGN KEY([CodigoContato])
REFERENCES [email].[Contato] ([Codigo])
GO

ALTER TABLE [email].[ContatoRemocao] CHECK CONSTRAINT [FK_ContatoRemocao_Contato]
GO

ALTER TABLE [email].[Contato]  WITH CHECK ADD  CONSTRAINT [FK_Contato_Ambiente] FOREIGN KEY([CodigoAmbiente])
REFERENCES [config].[Ambiente] ([Codigo])
GO

ALTER TABLE [email].[Contato] CHECK CONSTRAINT [FK_Contato_Ambiente]
GO

ALTER TABLE [email].[CampanhaGrupo]  WITH CHECK ADD  CONSTRAINT [FK_CampanhaGrupo_Campanha] FOREIGN KEY([CodigoCampanha])
REFERENCES [email].[Campanha] ([Codigo])
GO

ALTER TABLE [email].[CampanhaGrupo] CHECK CONSTRAINT [FK_CampanhaGrupo_Campanha]
GO

ALTER TABLE [email].[CampanhaGrupo]  WITH CHECK ADD  CONSTRAINT [FK_CampanhaGrupo_Grupo] FOREIGN KEY([CodigoGrupo])
REFERENCES [email].[Grupo] ([Codigo])
GO

ALTER TABLE [email].[CampanhaGrupo] CHECK CONSTRAINT [FK_CampanhaGrupo_Grupo]
GO

ALTER TABLE [email].[Campanha]  WITH CHECK ADD  CONSTRAINT [FK_Campanha_Ambiente] FOREIGN KEY([CodigoAmbiente])
REFERENCES [config].[Ambiente] ([Codigo])
GO

ALTER TABLE [email].[Campanha] CHECK CONSTRAINT [FK_Campanha_Ambiente]
GO

ALTER TABLE [email].[Campanha]  WITH CHECK ADD  CONSTRAINT [FK_Campanha_Remetente] FOREIGN KEY([CodigoRemetente])
REFERENCES [email].[Remetente] ([Codigo])
GO

ALTER TABLE [email].[Campanha] CHECK CONSTRAINT [FK_Campanha_Remetente]
GO

ALTER TABLE [email].[Campanha]  WITH CHECK ADD  CONSTRAINT [FK_Campanha_Servidor] FOREIGN KEY([CodigoServidor])
REFERENCES [email].[Servidor] ([Codigo])
GO

ALTER TABLE [email].[Campanha] CHECK CONSTRAINT [FK_Campanha_Servidor]
GO

ALTER TABLE [email].[Anexo]  WITH NOCHECK ADD  CONSTRAINT [FK_Anexo_Contato] FOREIGN KEY([CodigoContato])
REFERENCES [email].[Contato] ([Codigo])
NOT FOR REPLICATION 
GO

ALTER TABLE [email].[Anexo] NOCHECK CONSTRAINT [FK_Anexo_Contato]
GO

ALTER TABLE [email].[Anexo]  WITH CHECK ADD  CONSTRAINT [FK_Anexo_Disparo] FOREIGN KEY([CodigoDisparo])
REFERENCES [email].[Disparo] ([Codigo])
GO

ALTER TABLE [email].[Anexo] CHECK CONSTRAINT [FK_Anexo_Disparo]
GO

ALTER TABLE [email].[Grupo]  WITH CHECK ADD  CONSTRAINT [FK_Grupo_Ambiente] FOREIGN KEY([CodigoAmbiente])
REFERENCES [config].[Ambiente] ([Codigo])
GO

ALTER TABLE [email].[Grupo] CHECK CONSTRAINT [FK_Grupo_Ambiente]
GO