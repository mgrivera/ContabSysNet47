/*    Martes, 23 de Junio de 2.009  -   v0.00.250.sql 

	Agregamos algunos items a la tabla ParametrosBancos para registrar el footer 
	de la factura impresa a clientes 

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
CREATE TABLE dbo.Tmp_ParametrosBancos
	(
	RetencionSobreIvaFlag bit NULL,
	RetencionSobreIvaPorc decimal(5, 2) NULL,
	FooterFacturaImpresa_L1 nvarchar(100) NULL,
	FooterFacturaImpresa_L2 nvarchar(100) NULL,
	FooterFacturaImpresa_L3 nvarchar(100) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ParametrosBancos SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.ParametrosBancos)
	 EXEC('INSERT INTO dbo.Tmp_ParametrosBancos (RetencionSobreIvaFlag, RetencionSobreIvaPorc, Cia)
		SELECT RetencionSobreIvaFlag, RetencionSobreIvaPorc, Cia FROM dbo.ParametrosBancos WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.ParametrosBancos
GO
EXECUTE sp_rename N'dbo.Tmp_ParametrosBancos', N'ParametrosBancos', 'OBJECT' 
GO
ALTER TABLE dbo.ParametrosBancos ADD CONSTRAINT
	PK_ParametrosBancos PRIMARY KEY CLUSTERED 
	(
	Cia
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qFormaParametrosBancos]'))
DROP VIEW [dbo].[qFormaParametrosBancos]
GO

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.250', GetDate()) 