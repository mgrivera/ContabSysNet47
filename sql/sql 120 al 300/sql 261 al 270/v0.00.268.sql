/*    Lunes, 30 de Agosoto de 2.010   -   v0.00.268.sql 

	Agregamos un PK a las tablas CompaniasID, ProveedoresID y 
	TiposProveedorID para que EF las pueda usar ... 

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
CREATE TABLE dbo.Tmp_TiposProveedorId
	(
	Numero int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_TiposProveedorId SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.TiposProveedorId)
	 EXEC('INSERT INTO dbo.Tmp_TiposProveedorId (Numero)
		SELECT Numero FROM dbo.TiposProveedorId WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.TiposProveedorId
GO
EXECUTE sp_rename N'dbo.Tmp_TiposProveedorId', N'TiposProveedorId', 'OBJECT' 
GO
ALTER TABLE dbo.TiposProveedorId ADD CONSTRAINT
	PK_TiposProveedorId PRIMARY KEY CLUSTERED 
	(
	Numero
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_ProveedoresId
	(
	Numero int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ProveedoresId SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.ProveedoresId)
	 EXEC('INSERT INTO dbo.Tmp_ProveedoresId (Numero)
		SELECT Numero FROM dbo.ProveedoresId WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.ProveedoresId
GO
EXECUTE sp_rename N'dbo.Tmp_ProveedoresId', N'ProveedoresId', 'OBJECT' 
GO
ALTER TABLE dbo.ProveedoresId ADD CONSTRAINT
	PK_ProveedoresId PRIMARY KEY CLUSTERED 
	(
	Numero
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CompaniasId
	(
	Numero int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CompaniasId SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.CompaniasId)
	 EXEC('INSERT INTO dbo.Tmp_CompaniasId (Numero)
		SELECT Numero FROM dbo.CompaniasId WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.CompaniasId
GO
EXECUTE sp_rename N'dbo.Tmp_CompaniasId', N'CompaniasId', 'OBJECT' 
GO
ALTER TABLE dbo.CompaniasId ADD CONSTRAINT
	PK_CompaniasId PRIMARY KEY CLUSTERED 
	(
	Numero
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.268', GetDate()) 