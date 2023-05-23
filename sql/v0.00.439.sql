/*    
	  Viernes, 5 de Mayo de 2.023  -   v0.00.439.sql 
	  
	  Agregamos la tabla: bancos - registros de cierre 
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
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.bancos_cierre_periodosCierre
	(
	id int NOT NULL IDENTITY (1, 1),
	desde date NOT NULL,
	hasta date NOT NULL,
	fechaCreacion datetime NOT NULL,
	fechaEjecucion datetime NOT NULL,
	fechaUltEjecucion datetime NOT NULL,
	usuario nvarchar(50) NOT NULL,
	cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.bancos_cierre_periodosCierre ADD CONSTRAINT
	PK_bancos_cierre_periodosCierre PRIMARY KEY CLUSTERED 
	(
	id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.bancos_cierre_periodosCierre ADD CONSTRAINT
	FK_bancos_cierre_periodosCierre_Companias FOREIGN KEY
	(
	cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.bancos_cierre_periodosCierre SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.bancos_cierre_periodosCierre
	DROP CONSTRAINT FK_bancos_cierre_periodosCierre_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_bancos_cierre_periodosCierre
	(
	id int NOT NULL IDENTITY (1, 1),
	desde date NOT NULL,
	hasta date NOT NULL,
	fechaCreacion smalldatetime NOT NULL,
	fechaEjecucion smalldatetime NOT NULL,
	fechaUltEjecucion smalldatetime NOT NULL,
	usuario nvarchar(50) NOT NULL,
	cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_bancos_cierre_periodosCierre SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_bancos_cierre_periodosCierre ON
GO
IF EXISTS(SELECT * FROM dbo.bancos_cierre_periodosCierre)
	 EXEC('INSERT INTO dbo.Tmp_bancos_cierre_periodosCierre (id, desde, hasta, fechaCreacion, fechaEjecucion, fechaUltEjecucion, usuario, cia)
		SELECT id, desde, hasta, CONVERT(smalldatetime, fechaCreacion), CONVERT(smalldatetime, fechaEjecucion), CONVERT(smalldatetime, fechaUltEjecucion), usuario, cia FROM dbo.bancos_cierre_periodosCierre WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_bancos_cierre_periodosCierre OFF
GO
DROP TABLE dbo.bancos_cierre_periodosCierre
GO
EXECUTE sp_rename N'dbo.Tmp_bancos_cierre_periodosCierre', N'bancos_cierre_periodosCierre', 'OBJECT' 
GO
ALTER TABLE dbo.bancos_cierre_periodosCierre ADD CONSTRAINT
	PK_bancos_cierre_periodosCierre PRIMARY KEY CLUSTERED 
	(
	id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.bancos_cierre_periodosCierre ADD CONSTRAINT
	FK_bancos_cierre_periodosCierre_Companias FOREIGN KEY
	(
	cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
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
ALTER TABLE dbo.bancos_cierre_periodosCierre
	DROP CONSTRAINT FK_bancos_cierre_periodosCierre_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_bancos_cierre_periodosCierre
	(
	id int NOT NULL IDENTITY (1, 1),
	desde date NOT NULL,
	hasta date NOT NULL,
	fechaCreacion smalldatetime NOT NULL,
	fechaEjecucion smalldatetime NULL,
	fechaUltEjecucion smalldatetime NULL,
	usuario nvarchar(50) NOT NULL,
	cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_bancos_cierre_periodosCierre SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_bancos_cierre_periodosCierre ON
GO
IF EXISTS(SELECT * FROM dbo.bancos_cierre_periodosCierre)
	 EXEC('INSERT INTO dbo.Tmp_bancos_cierre_periodosCierre (id, desde, hasta, fechaCreacion, fechaEjecucion, fechaUltEjecucion, usuario, cia)
		SELECT id, desde, hasta, fechaCreacion, fechaEjecucion, fechaUltEjecucion, usuario, cia FROM dbo.bancos_cierre_periodosCierre WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_bancos_cierre_periodosCierre OFF
GO
DROP TABLE dbo.bancos_cierre_periodosCierre
GO
EXECUTE sp_rename N'dbo.Tmp_bancos_cierre_periodosCierre', N'bancos_cierre_periodosCierre', 'OBJECT' 
GO
ALTER TABLE dbo.bancos_cierre_periodosCierre ADD CONSTRAINT
	PK_bancos_cierre_periodosCierre PRIMARY KEY CLUSTERED 
	(
	id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.bancos_cierre_periodosCierre ADD CONSTRAINT
	FK_bancos_cierre_periodosCierre_Companias FOREIGN KEY
	(
	cia
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
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.439', GetDate()) 