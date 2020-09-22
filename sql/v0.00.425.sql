/*    
	  Martes, 5 de Septiembre de 2.020  -   v0.00.425.sql 
	  
	  Agregamos dos columnas a la tabla ParametrosBancos: 
	  AplicarITF, CuentaContableITF
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
ALTER TABLE dbo.ParametrosBancos
	DROP CONSTRAINT FK_ParametrosBancos_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
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
	AplicarITF bit NULL,
	CuentaContableITF int NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ParametrosBancos SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.ParametrosBancos)
	 EXEC('INSERT INTO dbo.Tmp_ParametrosBancos (RetencionSobreIvaFlag, RetencionSobreIvaPorc, FooterFacturaImpresa_L1, FooterFacturaImpresa_L2, FooterFacturaImpresa_L3, Cia)
		SELECT RetencionSobreIvaFlag, RetencionSobreIvaPorc, FooterFacturaImpresa_L1, FooterFacturaImpresa_L2, FooterFacturaImpresa_L3, Cia FROM dbo.ParametrosBancos WITH (HOLDLOCK TABLOCKX)')
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
ALTER TABLE dbo.ParametrosBancos ADD CONSTRAINT
	FK_ParametrosBancos_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.425', GetDate()) 