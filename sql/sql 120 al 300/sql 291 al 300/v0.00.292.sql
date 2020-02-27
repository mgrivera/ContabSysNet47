/*    Lunes, 21 de Novimiembre de 2.011  -   v0.00.292.sql 

	Modificamos levemente la tabla tDefaultsImprimirCheque para 
	implementar esta funcionalidad a ContabSysNetLS 
*/

Delete From tDefaultsImprimirCheque

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
ALTER TABLE dbo.tDefaultsImprimirCheque ADD
	NombreDocumentoWord nvarchar(500) NULL,
	Cia int NOT NULL
GO
ALTER TABLE dbo.tDefaultsImprimirCheque SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
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
ALTER TABLE dbo.tDefaultsImprimirCheque SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.292', GetDate()) 