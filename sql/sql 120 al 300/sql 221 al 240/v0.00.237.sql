/*    Jueves, 5 de Febrero de 2.009  -   v0.00.237.sql 

	Modificamos levemente la tabla AsientosNegativosId para agregar una 
	clave principal (PK) 

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
ALTER TABLE dbo.AsientosNegativosId ADD CONSTRAINT
	PK_AsientosNegativosId PRIMARY KEY CLUSTERED 
	(
	Mes,
	Ano,
	Cia
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.AsientosNegativosId
	DROP COLUMN ClaveUnica
GO
ALTER TABLE dbo.AsientosNegativosId SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


--  ------------------------------------------------
--  hacemos lo mismo con AsientosClaveUnicaId
--  ------------------------------------------------


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
CREATE TABLE dbo.Tmp_AsientosClaveUnicaId
	(
	Numero int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_AsientosClaveUnicaId SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.AsientosClaveUnicaId)
	 EXEC('INSERT INTO dbo.Tmp_AsientosClaveUnicaId (Numero)
		SELECT Numero FROM dbo.AsientosClaveUnicaId WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.AsientosClaveUnicaId
GO
EXECUTE sp_rename N'dbo.Tmp_AsientosClaveUnicaId', N'AsientosClaveUnicaId', 'OBJECT' 
GO
ALTER TABLE dbo.AsientosClaveUnicaId ADD CONSTRAINT
	PK_AsientosClaveUnicaId PRIMARY KEY CLUSTERED 
	(
	Numero
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT


















--  ------------------------------------------------------
--  hacemos lo mismo con AsientosId y AsientosIdPorGrupo
--  ------------------------------------------------------


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
ALTER TABLE dbo.AsientosId
	DROP CONSTRAINT PK_AsientosId
GO
ALTER TABLE dbo.AsientosId ADD CONSTRAINT
	PK_AsientosId_1 PRIMARY KEY CLUSTERED 
	(
	Mes,
	Ano,
	Cia
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.AsientosId
	DROP COLUMN ClaveUnica
GO
ALTER TABLE dbo.AsientosId SET (LOCK_ESCALATION = TABLE)
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
CREATE TABLE dbo.Tmp_AsientosIdPorGrupo
	(
	Grupo int NOT NULL,
	Mes smallint NOT NULL,
	Ano smallint NOT NULL,
	Numero int NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_AsientosIdPorGrupo SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.AsientosIdPorGrupo)
	 EXEC('INSERT INTO dbo.Tmp_AsientosIdPorGrupo (Grupo, Mes, Ano, Numero, Cia)
		SELECT Grupo, Mes, Ano, Numero, Cia FROM dbo.AsientosIdPorGrupo WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.AsientosIdPorGrupo
GO
EXECUTE sp_rename N'dbo.Tmp_AsientosIdPorGrupo', N'AsientosIdPorGrupo', 'OBJECT' 
GO
ALTER TABLE dbo.AsientosIdPorGrupo ADD CONSTRAINT
	PK_AsientosIdPorGrupo PRIMARY KEY CLUSTERED 
	(
	Grupo,
	Mes,
	Ano,
	Cia
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.237', GetDate()) 