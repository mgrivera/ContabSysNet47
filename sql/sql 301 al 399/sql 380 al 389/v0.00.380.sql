/*    
	  Lunes 18 de Abril de 2.016	-   v0.00.380.sql 

	  hacemos cambios leves a la tabla UltimoMesCerrado (bancos)
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
ALTER TABLE dbo.UltimoMesCerrado
	DROP CONSTRAINT FK_UltimoMesCerrado_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_UltimoMesCerrado
	(
	Mes tinyint NOT NULL,
	Ano smallint NOT NULL,
	UltAct datetime2(7) NOT NULL,
	ManAuto nvarchar(1) NOT NULL,
	Cia int NOT NULL,
	Usuario nvarchar(125) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_UltimoMesCerrado SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.UltimoMesCerrado)
	 EXEC('INSERT INTO dbo.Tmp_UltimoMesCerrado (Mes, Ano, UltAct, ManAuto, Cia, Usuario)
		SELECT Mes, Ano, CONVERT(datetime2(7), UltAct), ManAuto, Cia, Usuario FROM dbo.UltimoMesCerrado WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.UltimoMesCerrado
GO
EXECUTE sp_rename N'dbo.Tmp_UltimoMesCerrado', N'UltimoMesCerrado', 'OBJECT' 
GO
ALTER TABLE dbo.UltimoMesCerrado ADD CONSTRAINT
	PK_UltimoMesCerrado PRIMARY KEY NONCLUSTERED 
	(
	Cia
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.UltimoMesCerrado WITH NOCHECK ADD CONSTRAINT
	FK_UltimoMesCerrado_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.380', GetDate()) 
