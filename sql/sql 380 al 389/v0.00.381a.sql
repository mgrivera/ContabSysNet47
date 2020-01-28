/*    
	  Miércoles, 27 de Abril de 2.016	-   v0.00.381a.sql 

	  Cambiamos, levemente, algunas columnas en la tabla UltimoMesCerradoContab 
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
ALTER TABLE dbo.UltimoMesCerradoContab
	DROP CONSTRAINT FK_UltimoMesCerradoContab_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_UltimoMesCerradoContab
	(
	Mes tinyint NOT NULL,
	Ano smallint NOT NULL,
	UltAct datetime2(7) NOT NULL,
	ManAuto nvarchar(1) NOT NULL,
	Cia int NOT NULL,
	Usuario nvarchar(125) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_UltimoMesCerradoContab SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.UltimoMesCerradoContab)
	 EXEC('INSERT INTO dbo.Tmp_UltimoMesCerradoContab (Mes, Ano, UltAct, ManAuto, Cia, Usuario)
		SELECT Mes, Ano, CONVERT(datetime2(7), UltAct), ManAuto, Cia, Usuario FROM dbo.UltimoMesCerradoContab WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.UltimoMesCerradoContab
GO
EXECUTE sp_rename N'dbo.Tmp_UltimoMesCerradoContab', N'UltimoMesCerradoContab', 'OBJECT' 
GO
ALTER TABLE dbo.UltimoMesCerradoContab ADD CONSTRAINT
	PK_UltimoMesCerradoContab PRIMARY KEY NONCLUSTERED 
	(
	Cia
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.UltimoMesCerradoContab ADD CONSTRAINT
	FK_UltimoMesCerradoContab_Companias FOREIGN KEY
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
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.381a', GetDate()) 
