/*    
	  Jueves, 01 de Junio de 2.023  -   v0.00.442.sql 
	  
	  Hacemos algunos cambios a la tabla: Registros Manuales 
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
ALTER TABLE dbo.bancos_cierre_periodosCierre SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.bancos_cierre_registros
	DROP CONSTRAINT FK_bancos_cierre_registrosManuales_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.bancos_cierre_registros
	DROP CONSTRAINT FK_bancos_cierre_registrosManuales_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.bancos_cierre_registros
	DROP CONSTRAINT FK_bancos_cierre_registrosManuales_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_bancos_cierre_registros
	(
	id int NOT NULL IDENTITY (1, 1),
	registroCierreId int NOT NULL,
	moneda int NOT NULL,
	compania int NOT NULL,
	tipo1 nvarchar(10) NOT NULL,
	tipo2 nvarchar(10) NOT NULL,
	manAuto char(1) NOT NULL,
	fecha smalldatetime NOT NULL,
	referencia nvarchar(50) NULL,
	orden smallint NOT NULL,
	descripcion nvarchar(250) NOT NULL,
	monto money NOT NULL,
	fechaCreacion smalldatetime NOT NULL,
	fechaUltModificacion smalldatetime NULL,
	usuario nvarchar(50) NOT NULL,
	cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_bancos_cierre_registros SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_bancos_cierre_registros ON
GO
IF EXISTS(SELECT * FROM dbo.bancos_cierre_registros)
	 EXEC('INSERT INTO dbo.Tmp_bancos_cierre_registros (id, moneda, compania, tipo1, tipo2, manAuto, fecha, orden, descripcion, monto, fechaCreacion, fechaUltModificacion, usuario, cia)
		SELECT id, moneda, compania, tipo1, tipo2, manAuto, fecha, orden, descripcion, monto, fechaCreacion, fechaUltModificacion, usuario, cia FROM dbo.bancos_cierre_registros WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_bancos_cierre_registros OFF
GO
DROP TABLE dbo.bancos_cierre_registros
GO
EXECUTE sp_rename N'dbo.Tmp_bancos_cierre_registros', N'bancos_cierre_registros', 'OBJECT' 
GO
ALTER TABLE dbo.bancos_cierre_registros ADD CONSTRAINT
	PK_bancos_cierre_registrosManuales PRIMARY KEY CLUSTERED 
	(
	id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.bancos_cierre_registros ADD CONSTRAINT
	FK_bancos_cierre_registrosManuales_Companias FOREIGN KEY
	(
	cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.bancos_cierre_registros ADD CONSTRAINT
	FK_bancos_cierre_registrosManuales_Monedas FOREIGN KEY
	(
	moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.bancos_cierre_registros ADD CONSTRAINT
	FK_bancos_cierre_registrosManuales_Proveedores FOREIGN KEY
	(
	compania
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.bancos_cierre_registros ADD CONSTRAINT
	FK_bancos_cierre_registros_bancos_cierre_periodosCierre FOREIGN KEY
	(
	registroCierreId
	) REFERENCES dbo.bancos_cierre_periodosCierre
	(
	id
	) ON UPDATE  NO ACTION 
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
EXECUTE sp_rename N'dbo.bancos_cierre_registros.registroCierreId', N'Tmp_periodoCierreId', 'COLUMN' 
GO
EXECUTE sp_rename N'dbo.bancos_cierre_registros.Tmp_periodoCierreId', N'periodoCierreId', 'COLUMN' 
GO
ALTER TABLE dbo.bancos_cierre_registros SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.bancos_cierre_registros
	DROP CONSTRAINT FK_bancos_cierre_registros_bancos_cierre_periodosCierre
GO
ALTER TABLE dbo.bancos_cierre_periodosCierre SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.bancos_cierre_registros
	DROP CONSTRAINT FK_bancos_cierre_registrosManuales_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.bancos_cierre_registros
	DROP CONSTRAINT FK_bancos_cierre_registrosManuales_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.bancos_cierre_registros
	DROP CONSTRAINT FK_bancos_cierre_registrosManuales_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.bancos_cierre_ultimoPeriodoCerrado
	(
	id int NOT NULL IDENTITY (1, 1),
	desde date NOT NULL,
	hasta date NOT NULL,
	cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.bancos_cierre_ultimoPeriodoCerrado ADD CONSTRAINT
	PK_bancos_cierre_ultimoPeriodoCerrado PRIMARY KEY CLUSTERED 
	(
	id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.bancos_cierre_ultimoPeriodoCerrado ADD CONSTRAINT
	FK_bancos_cierre_ultimoPeriodoCerrado_Companias FOREIGN KEY
	(
	cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.bancos_cierre_ultimoPeriodoCerrado SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_bancos_cierre_registros
	(
	id int NOT NULL IDENTITY (1, 1),
	periodoCierreId int NOT NULL,
	moneda int NOT NULL,
	compania int NOT NULL,
	tipo1 nvarchar(10) NOT NULL,
	tipo2 nvarchar(10) NULL,
	manAuto char(1) NOT NULL,
	fecha smalldatetime NOT NULL,
	referencia nvarchar(50) NULL,
	orden smallint NOT NULL,
	descripcion nvarchar(250) NOT NULL,
	monto money NOT NULL,
	fechaCreacion smalldatetime NOT NULL,
	fechaUltModificacion smalldatetime NULL,
	usuario nvarchar(50) NOT NULL,
	cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_bancos_cierre_registros SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_bancos_cierre_registros ON
GO
IF EXISTS(SELECT * FROM dbo.bancos_cierre_registros)
	 EXEC('INSERT INTO dbo.Tmp_bancos_cierre_registros (id, periodoCierreId, moneda, compania, tipo1, tipo2, manAuto, fecha, referencia, orden, descripcion, monto, fechaCreacion, fechaUltModificacion, usuario, cia)
		SELECT id, periodoCierreId, moneda, compania, tipo1, tipo2, manAuto, fecha, referencia, orden, descripcion, monto, fechaCreacion, fechaUltModificacion, usuario, cia FROM dbo.bancos_cierre_registros WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_bancos_cierre_registros OFF
GO
DROP TABLE dbo.bancos_cierre_registros
GO
EXECUTE sp_rename N'dbo.Tmp_bancos_cierre_registros', N'bancos_cierre_registros', 'OBJECT' 
GO
ALTER TABLE dbo.bancos_cierre_registros ADD CONSTRAINT
	PK_bancos_cierre_registrosManuales PRIMARY KEY CLUSTERED 
	(
	id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.bancos_cierre_registros ADD CONSTRAINT
	FK_bancos_cierre_registrosManuales_Companias FOREIGN KEY
	(
	cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.bancos_cierre_registros ADD CONSTRAINT
	FK_bancos_cierre_registrosManuales_Monedas FOREIGN KEY
	(
	moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.bancos_cierre_registros ADD CONSTRAINT
	FK_bancos_cierre_registrosManuales_Proveedores FOREIGN KEY
	(
	compania
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.bancos_cierre_registros ADD CONSTRAINT
	FK_bancos_cierre_registros_bancos_cierre_periodosCierre FOREIGN KEY
	(
	periodoCierreId
	) REFERENCES dbo.bancos_cierre_periodosCierre
	(
	id
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.442', GetDate()) 