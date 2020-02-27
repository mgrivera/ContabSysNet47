/*    Lunes, 23 de Enero de 2.012  -   v0.00.303.sql 

	dAsientos: agrandamos la columna Descripción, desde 50 a 75. 
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
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_Asientos
GO
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_CuentasContables1
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_CentrosCosto
GO
ALTER TABLE dbo.CentrosCosto SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_dAsientos
	(
	NumeroAutomatico int NOT NULL,
	Partida smallint NOT NULL,
	CuentaContableID int NOT NULL,
	Descripcion nvarchar(75) NOT NULL,
	Referencia nvarchar(20) NULL,
	Debe money NOT NULL,
	Haber money NOT NULL,
	CentroCosto int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_dAsientos SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.dAsientos)
	 EXEC('INSERT INTO dbo.Tmp_dAsientos (NumeroAutomatico, Partida, CuentaContableID, Descripcion, Referencia, Debe, Haber, CentroCosto)
		SELECT NumeroAutomatico, Partida, CuentaContableID, Descripcion, Referencia, Debe, Haber, CentroCosto FROM dbo.dAsientos WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.dAsientos
GO
EXECUTE sp_rename N'dbo.Tmp_dAsientos', N'dAsientos', 'OBJECT' 
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	PK_dAsientos PRIMARY KEY CLUSTERED 
	(
	NumeroAutomatico,
	Partida
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_dAsientos ON dbo.dAsientos
	(
	NumeroAutomatico
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	FK_dAsientos_CentrosCosto FOREIGN KEY
	(
	CentroCosto
	) REFERENCES dbo.CentrosCosto
	(
	CentroCosto
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	FK_dAsientos_CuentasContables1 FOREIGN KEY
	(
	CuentaContableID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.dAsientos WITH NOCHECK ADD CONSTRAINT
	FK_dAsientos_Asientos FOREIGN KEY
	(
	NumeroAutomatico
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.303', GetDate()) 