/*    
	  Martes, 14 de Julio de 2.020  -   v0.00.424.sql 
	  
	  tGruposDeTiposDeAsiento: modificamos la columna Grupo para que sea Identity 
	  antes era pk pero no Identity; además, eliminamos la tabla que usabamos para 
	  asignar el valor en el pk: tGruposTiposAsientoId. 
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
CREATE TABLE dbo.Tmp_tGruposDeTiposDeAsiento
	(
	Grupo int NOT NULL IDENTITY (1, 1),
	Descripcion nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	NumeroInicial int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tGruposDeTiposDeAsiento SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tGruposDeTiposDeAsiento ON
GO
IF EXISTS(SELECT * FROM dbo.tGruposDeTiposDeAsiento)
	 EXEC('INSERT INTO dbo.Tmp_tGruposDeTiposDeAsiento (Grupo, Descripcion, NumeroInicial)
		SELECT Grupo, Descripcion, NumeroInicial FROM dbo.tGruposDeTiposDeAsiento WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tGruposDeTiposDeAsiento OFF
GO
ALTER TABLE dbo.TiposDeAsiento
	DROP CONSTRAINT FK_TiposDeAsiento_tGruposDeTiposDeAsiento
GO
DROP TABLE dbo.tGruposDeTiposDeAsiento
GO
EXECUTE sp_rename N'dbo.Tmp_tGruposDeTiposDeAsiento', N'tGruposDeTiposDeAsiento', 'OBJECT' 
GO
ALTER TABLE dbo.tGruposDeTiposDeAsiento ADD CONSTRAINT
	PK_tGruposDeTiposDeAsiento PRIMARY KEY NONCLUSTERED 
	(
	Grupo
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.TiposDeAsiento ADD CONSTRAINT
	FK_TiposDeAsiento_tGruposDeTiposDeAsiento FOREIGN KEY
	(
	Grupo
	) REFERENCES dbo.tGruposDeTiposDeAsiento
	(
	Grupo
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.TiposDeAsiento SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

Drop Table tGruposDeTiposDeAsientoId

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.424', GetDate()) 


