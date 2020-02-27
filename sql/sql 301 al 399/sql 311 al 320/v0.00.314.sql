/*    Martes, 19 de Junio de 2.012  -   v0.00.314.sql 

	Agregamos las tablas 'Temp' para las consultas: 
	Balance de Comprobación; además, agregamos 
	relación entre SaldosContables y Monedas (???!!!) 


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
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.SaldosContables ADD CONSTRAINT
	FK_SaldosContables_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION  
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.SaldosContables ADD CONSTRAINT
	FK_SaldosContables_Monedas1 FOREIGN KEY
	(
	MonedaOriginal
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION  
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.SaldosContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

















/****** Object:  Table [dbo].[Temp_Contab_Report_BalanceComprobacion]    Script Date: 07/12/2012 09:19:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Contab_Report_BalanceComprobacion]') AND type in (N'U'))
DROP TABLE [dbo].[Temp_Contab_Report_BalanceComprobacion]
GO


/****** Object:  Table [dbo].[Temp_Contab_Report_BalanceComprobacion]    Script Date: 07/12/2012 09:19:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Temp_Contab_Report_BalanceComprobacion](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[NombreCia] [nvarchar](50) NOT NULL,
	[AbreviaturaCia] [nvarchar](6) NOT NULL,
	[SimboloMoneda] [nvarchar](6) NOT NULL,
	[CuentaContable_Nivel1] [nvarchar](25) NOT NULL,
	[CuentaContable_Nivel1_NombreCuenta] [nvarchar](50) NOT NULL,
	[CuentaContable_NivelPrevio] [nvarchar](25) NOT NULL,
	[CuentaContable_NivelPrevio_NombreCuenta] [nvarchar](50) NOT NULL,
	[CuentaContable] [nvarchar](25) NOT NULL,
	[NombreCuenta] [nvarchar](50) NOT NULL,
	[SaldoInicial] [money] NOT NULL,
	[Haber] [money] NULL,
	[Debe] [money] NULL,
	[SaldoFinal] [money] NOT NULL,
	[Usuario] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_Temp_Contab_Report_BalanceGeneral] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AnalisisContable_Companias]') AND parent_object_id = OBJECT_ID(N'[dbo].[AnalisisContable]'))
ALTER TABLE [dbo].[AnalisisContable] DROP CONSTRAINT [FK_AnalisisContable_Companias]
GO

/****** Object:  Table [dbo].[AnalisisContable]    Script Date: 07/12/2012 09:18:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AnalisisContable]') AND type in (N'U'))
DROP TABLE [dbo].[AnalisisContable]
GO

/****** Object:  Table [dbo].[AnalisisContable]    Script Date: 07/12/2012 09:18:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AnalisisContable](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Cia] [int] NOT NULL,
	[Descripcion] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_AnalisisContable] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[AnalisisContable]  WITH CHECK ADD  CONSTRAINT [FK_AnalisisContable_Companias] FOREIGN KEY([Cia])
REFERENCES [dbo].[Companias] ([Numero])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[AnalisisContable] CHECK CONSTRAINT [FK_AnalisisContable_Companias]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AnalisisContable_CuentasContables_AnalisisContable]') AND parent_object_id = OBJECT_ID(N'[dbo].[AnalisisContable_CuentasContables]'))
ALTER TABLE [dbo].[AnalisisContable_CuentasContables] DROP CONSTRAINT [FK_AnalisisContable_CuentasContables_AnalisisContable]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_AnalisisContable_CuentasContables_CuentasContables]') AND parent_object_id = OBJECT_ID(N'[dbo].[AnalisisContable_CuentasContables]'))
ALTER TABLE [dbo].[AnalisisContable_CuentasContables] DROP CONSTRAINT [FK_AnalisisContable_CuentasContables_CuentasContables]
GO

/****** Object:  Table [dbo].[AnalisisContable_CuentasContables]    Script Date: 07/12/2012 09:18:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AnalisisContable_CuentasContables]') AND type in (N'U'))
DROP TABLE [dbo].[AnalisisContable_CuentasContables]
GO

/****** Object:  Table [dbo].[AnalisisContable_CuentasContables]    Script Date: 07/12/2012 09:18:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[AnalisisContable_CuentasContables](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AnalisisContable_ID] [int] NOT NULL,
	[CuentaContable_ID] [int] NOT NULL,
	[Tag1] [nvarchar](30) NULL,
	[Tag2] [nvarchar](30) NULL,
	[Tag3] [nvarchar](30) NULL,
	[Tag4] [nvarchar](30) NULL,
	[Tag5] [nvarchar](30) NULL,
	[Tag6] [nvarchar](30) NULL,
 CONSTRAINT [PK_AnalisisContable_CuentasContables] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[AnalisisContable_CuentasContables]  WITH CHECK ADD  CONSTRAINT [FK_AnalisisContable_CuentasContables_AnalisisContable] FOREIGN KEY([AnalisisContable_ID])
REFERENCES [dbo].[AnalisisContable] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[AnalisisContable_CuentasContables] CHECK CONSTRAINT [FK_AnalisisContable_CuentasContables_AnalisisContable]
GO

ALTER TABLE [dbo].[AnalisisContable_CuentasContables]  WITH CHECK ADD  CONSTRAINT [FK_AnalisisContable_CuentasContables_CuentasContables] FOREIGN KEY([CuentaContable_ID])
REFERENCES [dbo].[CuentasContables] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[AnalisisContable_CuentasContables] CHECK CONSTRAINT [FK_AnalisisContable_CuentasContables_CuentasContables]
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.314', GetDate()) 