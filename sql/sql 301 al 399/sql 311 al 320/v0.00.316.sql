/*    Martes, 31 de Julio de 2.012  -   v0.00.316.sql 

	Simplificamos en buena medida la tabla Saldos (de cuentas bancarias) 
	y sus relaciones con otras tablas ... 


*/


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Saldos
	DROP CONSTRAINT FK_Saldos_CuentasBancarias
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Saldos
	DROP CONSTRAINT FK_Saldos_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Saldos
	(
	ID int NOT NULL IDENTITY (1, 1),
	CuentaBancaria int NOT NULL,
	Ano smallint NOT NULL,
	Inicial money NULL,
	Mes01 money NULL,
	Mes02 money NULL,
	Mes03 money NULL,
	Mes04 money NULL,
	Mes05 money NULL,
	Mes06 money NULL,
	Mes07 money NULL,
	Mes08 money NULL,
	Mes09 money NULL,
	Mes10 money NULL,
	Mes11 money NULL,
	Mes12 money NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Saldos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Saldos OFF
GO
IF EXISTS(SELECT * FROM dbo.Saldos)
	 EXEC('INSERT INTO dbo.Tmp_Saldos (CuentaBancaria, Ano, Inicial, Mes01, Mes02, Mes03, Mes04, Mes05, Mes06, Mes07, Mes08, Mes09, Mes10, Mes11, Mes12)
		SELECT CuentaBancaria, Ano, Inicial, Mes01, Mes02, Mes03, Mes04, Mes05, Mes06, Mes07, Mes08, Mes09, Mes10, Mes11, Mes12 FROM dbo.Saldos WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.Saldos
GO
EXECUTE sp_rename N'dbo.Tmp_Saldos', N'Saldos', 'OBJECT' 
GO
ALTER TABLE dbo.Saldos ADD CONSTRAINT
	PK_Saldos PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE UNIQUE NONCLUSTERED INDEX IX_Saldos ON dbo.Saldos
	(
	CuentaBancaria,
	Ano
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Saldos WITH NOCHECK ADD CONSTRAINT
	FK_Saldos_CuentasBancarias FOREIGN KEY
	(
	CuentaBancaria
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT





BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos
	DROP CONSTRAINT FK_Disponibilidad_MontosRestringidos_CuentasBancarias
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos
	DROP CONSTRAINT FK_Disponibilidad_MontosRestringidos_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos
	DROP CONSTRAINT FK_Disponibilidad_MontosRestringidos_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Disponibilidad_MontosRestringidos
	(
	ID int NOT NULL IDENTITY (1, 1),
	CuentaBancaria int NOT NULL,
	Fecha date NOT NULL,
	Monto money NOT NULL,
	Comentarios ntext NOT NULL,
	SuspendidoFlag bit NOT NULL,
	DesactivarEl date NULL,
	Registro_Fecha datetime2(7) NOT NULL,
	Registro_Usuario nvarchar(25) NOT NULL,
	UltAct_Fecha datetime2(7) NOT NULL,
	UltAct_Usuario nvarchar(25) NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Disponibilidad_MontosRestringidos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Disponibilidad_MontosRestringidos ON
GO
IF EXISTS(SELECT * FROM dbo.Disponibilidad_MontosRestringidos)
	 EXEC('INSERT INTO dbo.Tmp_Disponibilidad_MontosRestringidos (ID, CuentaBancaria, Fecha, Monto, Comentarios, SuspendidoFlag, DesactivarEl, Registro_Fecha, Registro_Usuario, UltAct_Fecha, UltAct_Usuario)
		SELECT ID, CuentaBancaria, CONVERT(date, Fecha), Monto, Comentarios, SuspendidoFlag, CONVERT(date, DesactivarEl), CONVERT(datetime2(7), Registro_Fecha), Registro_Usuario, CONVERT(datetime2(7), UltAct_Fecha), UltAct_Usuario FROM dbo.Disponibilidad_MontosRestringidos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Disponibilidad_MontosRestringidos OFF
GO
DROP TABLE dbo.Disponibilidad_MontosRestringidos
GO
EXECUTE sp_rename N'dbo.Tmp_Disponibilidad_MontosRestringidos', N'Disponibilidad_MontosRestringidos', 'OBJECT' 
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos ADD CONSTRAINT
	PK_Disponibilidad_MontosRestringidos_1 PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos ADD CONSTRAINT
	FK_Disponibilidad_MontosRestringidos_CuentasBancarias FOREIGN KEY
	(
	CuentaBancaria
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT


/****** Object:  Table [dbo].[Temp_Bancos_Disponibilidad]    Script Date: 08/02/2012 10:33:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Bancos_Disponibilidad]') AND type in (N'U'))
DROP TABLE [dbo].[Temp_Bancos_Disponibilidad]
GO


/****** Object:  Table [dbo].[Temp_Bancos_Disponibilidad]    Script Date: 08/02/2012 10:33:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Temp_Bancos_Disponibilidad](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NombreCia] [nvarchar](6) NOT NULL,
	[NombreBanco] [nvarchar](6) NOT NULL,
	[CuentaBancaria] [nvarchar](50) NOT NULL,
	[SimboloMoneda] [nvarchar](6) NOT NULL,
	[Orden] [int] NOT NULL,
	[Ano] [smallint] NOT NULL,
	[Mes] [tinyint] NOT NULL,
	[Fecha] [date] NOT NULL,
	[Tipo] [nchar](6) NOT NULL,
	[Numero] [bigint] NOT NULL,
	[Beneficiario] [nvarchar](50) NOT NULL,
	[Concepto] [nvarchar](250) NOT NULL,
	[Monto] [money] NOT NULL,
	[Usuario] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_Temp_Bancos_Disponibilidad] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Saldos ADD
	TieneMovimientosEnElMes bit NULL
GO
ALTER TABLE dbo.Saldos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

/****** Object:  Table [dbo].[Temp_Contab_Report_AnalisisContable]    Script Date: 08/02/2012 16:13:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Contab_Report_AnalisisContable]') AND type in (N'U'))
DROP TABLE [dbo].[Temp_Contab_Report_AnalisisContable]
GO

/****** Object:  Table [dbo].[Temp_Contab_Report_AnalisisContable]    Script Date: 08/02/2012 16:13:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Temp_Contab_Report_AnalisisContable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NombreCia] [nvarchar](6) NOT NULL,
	[SimboloMoneda] [nvarchar](6) NOT NULL,
	[SimboloMonedaOriginal] [nvarchar](6) NULL,
	[CuentaContable] [nvarchar](25) NOT NULL,
	[NombreCuenta] [nvarchar](50) NOT NULL,
	[OrderBy] [int] NOT NULL,
	[Fecha] [date] NOT NULL,
	[Comprobante] [smallint] NULL,
	[Descripcion] [nvarchar](75) NOT NULL,
	[SaldoInicial] [money] NULL,
	[Haber] [money] NULL,
	[Debe] [money] NULL,
	[SaldoFinal] [money] NULL,
	[Monto] [money] NULL,
	[Tag1] [nvarchar](30) NULL,
	[Tag2] [nvarchar](30) NULL,
	[Tag3] [nvarchar](30) NULL,
	[Tag4] [nvarchar](30) NULL,
	[Tag5] [nvarchar](30) NULL,
	[Tag6] [nvarchar](30) NULL,
	[Usuario] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_Temp_Contab_Report_AnalisisContable] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.316', GetDate()) 