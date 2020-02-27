/*    Sabado, 17 de Septiembre de 2.011  -   v0.00.281.sql 

	Agregamos relaciones entre las tablas de grupos de asientos y 
	asientos ... 
	
	NOTA IMPORTANTE: este script fallará si el query que sigue muestra registros: 
	
	Select * From Asientos 
	Where Tipo Not In 
	(Select Tipo From TiposDeAsiento) 
	
	El problema se podría corregir con las instrucciones que siguen: 
	
	Update Asientos Set Tipo = 'CH' Where Tipo = 'CHEQUE' 
	Update Asientos Set Tipo = 'DP' Where Tipo = 'DEP'
	Update Asientos Set Tipo = 'CH' Where Tipo Is Null Or LTrim(Tipo) = '' 
	
	Mejor, corregir así: 
	====================
	
	1) agregamos un tipo 'Indefinido' a la tabla TiposDeAsiento
		1.1) chequear antes si existe el tipo: Select * From TiposDeAsiento Where Tipo = 'INDF' 
		     no existe --> Insert Into TiposDeAsiento (Tipo, Descripcion) Values ('INDF', 'Indefinido') 
		     
	2) usamos ese tipo para los asientos cuyo tipo no exista en TiposDeAsiento 
		Update Asientos Set Tipo = 'INDF' 
			Where Tipo Not In (Select Tipo From TiposDeAsiento) 

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
	Grupo int NOT NULL,
	Descripcion nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	NumeroInicial int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tGruposDeTiposDeAsiento SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.tGruposDeTiposDeAsiento)
	 EXEC('INSERT INTO dbo.Tmp_tGruposDeTiposDeAsiento (Grupo, Descripcion, NumeroInicial)
		SELECT Grupo, Descripcion, NumeroInicial FROM dbo.tGruposDeTiposDeAsiento WITH (HOLDLOCK TABLOCKX)')
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
CREATE TABLE dbo.Tmp_TiposDeAsiento
	(
	Grupo int NULL,
	Tipo nvarchar(6) NOT NULL,
	Descripcion nvarchar(50) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_TiposDeAsiento SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.TiposDeAsiento)
	 EXEC('INSERT INTO dbo.Tmp_TiposDeAsiento (Grupo, Tipo, Descripcion)
		SELECT Grupo, Tipo, Descripcion FROM dbo.TiposDeAsiento WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.TiposDeAsiento
GO
EXECUTE sp_rename N'dbo.Tmp_TiposDeAsiento', N'TiposDeAsiento', 'OBJECT' 
GO
ALTER TABLE dbo.TiposDeAsiento ADD CONSTRAINT
	PK_TiposDeAsiento PRIMARY KEY NONCLUSTERED 
	(
	Tipo
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

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
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Asientos ADD CONSTRAINT
	FK_Asientos_TiposDeAsiento FOREIGN KEY
	(
	Tipo
	) REFERENCES dbo.TiposDeAsiento
	(
	Tipo
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion(VersionActual, Fecha) Values('v0.00.281', GetDate()) 