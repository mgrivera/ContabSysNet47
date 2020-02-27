/*    Jueves, 1 de Septiembre de 2.011  -   v0.00.280.sql 

	Modificamos levemente la tabla tDefaultsImprimirCheque 
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
ALTER TABLE dbo.tDefaultsImprimirCheque ADD
	NombreArchivoDatosMailMerge nvarchar(500) NULL
GO
ALTER TABLE dbo.tDefaultsImprimirCheque SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.280', GetDate()) 