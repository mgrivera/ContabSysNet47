/*    Miércoles, 26 de Marzo de 2.014   -  v0.00.370.sql 

	Agregamos una columna para una 2da. plantilla Word en 
	tDefaultsImprimirCheque

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
ALTER TABLE dbo.tDefaultsImprimirCheque
	DROP CONSTRAINT FK_tDefaultsImprimirCheque_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tDefaultsImprimirCheque
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	ElaboradoPor nvarchar(25) NULL,
	RevisadoPor nvarchar(25) NULL,
	AprovadoPor nvarchar(25) NULL,
	ContabilizadoPor nvarchar(25) NULL,
	NombreDocumentoWord nvarchar(500) NULL,
	NombreDocumentoWord2 nvarchar(500) NULL,
	Cia int NOT NULL,
	Usuario nvarchar(25) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tDefaultsImprimirCheque SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tDefaultsImprimirCheque ON
GO
IF EXISTS(SELECT * FROM dbo.tDefaultsImprimirCheque)
	 EXEC('INSERT INTO dbo.Tmp_tDefaultsImprimirCheque (ClaveUnica, ElaboradoPor, RevisadoPor, AprovadoPor, ContabilizadoPor, NombreDocumentoWord, Cia, Usuario)
		SELECT ClaveUnica, ElaboradoPor, RevisadoPor, AprovadoPor, ContabilizadoPor, NombreDocumentoWord, Cia, Usuario FROM dbo.tDefaultsImprimirCheque WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tDefaultsImprimirCheque OFF
GO
DROP TABLE dbo.tDefaultsImprimirCheque
GO
EXECUTE sp_rename N'dbo.Tmp_tDefaultsImprimirCheque', N'tDefaultsImprimirCheque', 'OBJECT' 
GO
ALTER TABLE dbo.tDefaultsImprimirCheque ADD CONSTRAINT
	PK_tDefaultsImprimirCheque PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tDefaultsImprimirCheque ADD CONSTRAINT
	FK_tDefaultsImprimirCheque_Companias FOREIGN KEY
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
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.370', GetDate()) 