/*    Lunes, 05 de Diciembre de 2.011  -   v0.00.298b.sql 

	Hacemos cambios en la estructura de las tablas 
	del Control de Caja Chica 
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
ALTER TABLE dbo.CajaChica_CajasChicas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Reposiciones ADD CONSTRAINT
	FK_CajaChica_Reposiciones_CajaChica_CajasChicas FOREIGN KEY
	(
	CajaChica
	) REFERENCES dbo.CajaChica_CajasChicas
	(
	CajaChica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CajaChica_Reposiciones SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Estados ADD CONSTRAINT
	FK_CajaChica_Reposiciones_Estados_CajaChica_Reposiciones FOREIGN KEY
	(
	Reposicion
	) REFERENCES dbo.CajaChica_Reposiciones
	(
	Reposicion
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Estados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos ADD CONSTRAINT
	FK_CajaChica_Reposiciones_Gastos_CajaChica_Reposiciones FOREIGN KEY
	(
	Reposicion
	) REFERENCES dbo.CajaChica_Reposiciones
	(
	Reposicion
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Usuarios ADD CONSTRAINT
	FK_CajaChica_Usuarios_CajaChica_CajasChicas FOREIGN KEY
	(
	CajaChica
	) REFERENCES dbo.CajaChica_CajasChicas
	(
	CajaChica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CajaChica_Usuarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.298b', GetDate()) 