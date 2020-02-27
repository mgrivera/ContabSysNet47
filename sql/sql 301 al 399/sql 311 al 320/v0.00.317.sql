/*    Viernes, 17 de Agosto de 2.012  -   v0.00.317.sql 

	Agregamos el item Referencia a la tabla Temp...MayorGeneral 
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
CREATE TABLE dbo.Tmp_Temp_Contab_Report_MayorGeneral
	(
	ID int NOT NULL IDENTITY (1, 1),
	NombreCia nvarchar(6) NOT NULL,
	SimboloMoneda nvarchar(6) NOT NULL,
	CuentaContable nvarchar(25) NOT NULL,
	NombreCuenta nvarchar(50) NOT NULL,
	OrderBy int NOT NULL,
	Fecha date NOT NULL,
	Comprobante smallint NULL,
	Descripcion nvarchar(75) NOT NULL,
	Referencia nvarchar(20) NULL,
	SaldoInicial money NULL,
	Haber money NULL,
	Debe money NULL,
	SaldoFinal money NULL,
	Usuario nvarchar(25) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Temp_Contab_Report_MayorGeneral SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Temp_Contab_Report_MayorGeneral ON
GO
IF EXISTS(SELECT * FROM dbo.Temp_Contab_Report_MayorGeneral)
	 EXEC('INSERT INTO dbo.Tmp_Temp_Contab_Report_MayorGeneral (ID, NombreCia, SimboloMoneda, CuentaContable, NombreCuenta, OrderBy, Fecha, Comprobante, Descripcion, SaldoInicial, Haber, Debe, SaldoFinal, Usuario)
		SELECT ID, NombreCia, SimboloMoneda, CuentaContable, NombreCuenta, OrderBy, Fecha, Comprobante, Descripcion, SaldoInicial, Haber, Debe, SaldoFinal, Usuario FROM dbo.Temp_Contab_Report_MayorGeneral WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Temp_Contab_Report_MayorGeneral OFF
GO
DROP TABLE dbo.Temp_Contab_Report_MayorGeneral
GO
EXECUTE sp_rename N'dbo.Tmp_Temp_Contab_Report_MayorGeneral', N'Temp_Contab_Report_MayorGeneral', 'OBJECT' 
GO
ALTER TABLE dbo.Temp_Contab_Report_MayorGeneral ADD CONSTRAINT
	PK_Temp_Contab_Report_MayorGeneral PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tDefaultsImprimirCheque_Companias]') AND parent_object_id = OBJECT_ID(N'[dbo].[tDefaultsImprimirCheque]'))
ALTER TABLE [dbo].[tDefaultsImprimirCheque] DROP CONSTRAINT [FK_tDefaultsImprimirCheque_Companias]
GO

/****** Object:  Table [dbo].[tDefaultsImprimirCheque]    Script Date: 08/17/2012 11:26:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tDefaultsImprimirCheque]') AND type in (N'U'))
DROP TABLE [dbo].[tDefaultsImprimirCheque]
GO

/****** Object:  Table [dbo].[tDefaultsImprimirCheque]    Script Date: 08/17/2012 11:26:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tDefaultsImprimirCheque](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[ElaboradoPor] [nvarchar](25) NULL,
	[RevisadoPor] [nvarchar](25) NULL,
	[AprovadoPor] [nvarchar](25) NULL,
	[ContabilizadoPor] [nvarchar](25) NULL,
	[NombreDocumentoWord] [nvarchar](500) NULL,
	[Cia] [int] NOT NULL,
	[Usuario] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_tDefaultsImprimirCheque] PRIMARY KEY NONCLUSTERED 
(
	[ClaveUnica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tDefaultsImprimirCheque]  WITH CHECK ADD  CONSTRAINT [FK_tDefaultsImprimirCheque_Companias] FOREIGN KEY([Cia])
REFERENCES [dbo].[Companias] ([Numero])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[tDefaultsImprimirCheque] CHECK CONSTRAINT [FK_tDefaultsImprimirCheque_Companias]
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
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Companias ADD
	MonedaDefecto int NULL
GO
ALTER TABLE dbo.Companias ADD CONSTRAINT
	FK_Companias_Monedas FOREIGN KEY
	(
	MonedaDefecto
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION  
	
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.317', GetDate()) 