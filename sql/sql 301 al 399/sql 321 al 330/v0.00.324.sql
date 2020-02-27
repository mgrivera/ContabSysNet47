/*    Martes, 20 de Noviembre de 2.012  -   v0.00.324.sql 

	Modificamos en forma muy leve la tabla de Grupos Contables ... 
*/


Update tGruposContables Set Descripcion = 'Indefinido' Where Descripcion Is Null Or Descripcion = '' 
Update tGruposContables Set OrdenBalanceGeneral = 0 Where OrdenBalanceGeneral Is Null 



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
CREATE TABLE dbo.Tmp_tGruposContables
	(
	Grupo int NOT NULL,
	Descripcion nvarchar(50) NOT NULL,
	OrdenBalanceGeneral smallint NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tGruposContables SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tGruposContables)
	 EXEC('INSERT INTO dbo.Tmp_tGruposContables (Grupo, Descripcion, OrdenBalanceGeneral)
		SELECT Grupo, Descripcion, OrdenBalanceGeneral FROM dbo.tGruposContables WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.CuentasContables
	DROP CONSTRAINT FK_CuentasContables_tGruposContables1
GO
ALTER TABLE dbo.CuentasContables
	DROP CONSTRAINT FK_CuentasContables_tGruposContables
GO
DROP TABLE dbo.tGruposContables
GO
EXECUTE sp_rename N'dbo.Tmp_tGruposContables', N'tGruposContables', 'OBJECT' 
GO
ALTER TABLE dbo.tGruposContables ADD CONSTRAINT
	PK_tGruposContables PRIMARY KEY NONCLUSTERED 
	(
	Grupo
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasContables ADD CONSTRAINT
	FK_CuentasContables_tGruposContables1 FOREIGN KEY
	(
	GrupoNivelAgrupacion
	) REFERENCES dbo.tGruposContables
	(
	Grupo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasContables ADD CONSTRAINT
	FK_CuentasContables_tGruposContables FOREIGN KEY
	(
	Grupo
	) REFERENCES dbo.tGruposContables
	(
	Grupo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.324', GetDate()) 