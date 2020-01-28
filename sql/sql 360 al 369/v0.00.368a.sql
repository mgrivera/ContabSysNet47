/*    Viernes, 14 de Febrero de 2.014 	-   v0.00.368a.sql 

	Cambios para implementar mejoras en retenciones de impuesto ... 
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
ALTER TABLE dbo.Facturas_Impuestos
	DROP CONSTRAINT FK_Facturas_Impuestos_Facturas
GO
ALTER TABLE dbo.Facturas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Facturas_Impuestos
	DROP CONSTRAINT FK_Facturas_Impuestos_ImpuestosRetencionesDefinicion
GO
ALTER TABLE dbo.ImpuestosRetencionesDefinicion SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Facturas_Impuestos
	(
	ID int NOT NULL IDENTITY (1, 1),
	FacturaID int NOT NULL,
	ImpRetID int NOT NULL,
	Codigo nvarchar(6) NULL,
	MontoBase money NULL,
	Porcentaje decimal(5, 3) NULL,
	TipoAlicuota nvarchar(1) NULL,
	MontoAntesSustraendo money NULL,
	Sustraendo money NULL,
	Monto money NOT NULL,
	FechaRecepcionPlanilla date NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Facturas_Impuestos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Facturas_Impuestos ON
GO
IF EXISTS(SELECT * FROM dbo.Facturas_Impuestos)
	 EXEC('INSERT INTO dbo.Tmp_Facturas_Impuestos (ID, FacturaID, ImpRetID, MontoBase, Porcentaje, Monto)
		SELECT ID, FacturaID, ImpRetID, MontoBase, Porcentaje, Monto FROM dbo.Facturas_Impuestos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Facturas_Impuestos OFF
GO
DROP TABLE dbo.Facturas_Impuestos
GO
EXECUTE sp_rename N'dbo.Tmp_Facturas_Impuestos', N'Facturas_Impuestos', 'OBJECT' 
GO
ALTER TABLE dbo.Facturas_Impuestos ADD CONSTRAINT
	PK_Facturas_Impuestos PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Facturas_Impuestos ADD CONSTRAINT
	FK_Facturas_Impuestos_ImpuestosRetencionesDefinicion FOREIGN KEY
	(
	ImpRetID
	) REFERENCES dbo.ImpuestosRetencionesDefinicion
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Facturas_Impuestos ADD CONSTRAINT
	FK_Facturas_Impuestos_Facturas FOREIGN KEY
	(
	FacturaID
	) REFERENCES dbo.Facturas
	(
	ClaveUnica
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
CREATE TABLE dbo.Tmp_ImpuestosRetencionesDefinicion
	(
	ID int NOT NULL IDENTITY (1, 1),
	Predefinido smallint NULL,
	ImpuestoRetencion smallint NOT NULL,
	Descripcion nvarchar(50) NOT NULL,
	Base smallint NULL,
	Porcentaje decimal(5, 3) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ImpuestosRetencionesDefinicion SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_ImpuestosRetencionesDefinicion ON
GO
IF EXISTS(SELECT * FROM dbo.ImpuestosRetencionesDefinicion)
	 EXEC('INSERT INTO dbo.Tmp_ImpuestosRetencionesDefinicion (ID, ImpuestoRetencion, Descripcion, Base, Porcentaje)
		SELECT ID, ImpuestoRetencion, Descripcion, Base, Porcentaje FROM dbo.ImpuestosRetencionesDefinicion WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_ImpuestosRetencionesDefinicion OFF
GO
ALTER TABLE dbo.Facturas_Impuestos
	DROP CONSTRAINT FK_Facturas_Impuestos_ImpuestosRetencionesDefinicion
GO
DROP TABLE dbo.ImpuestosRetencionesDefinicion
GO
EXECUTE sp_rename N'dbo.Tmp_ImpuestosRetencionesDefinicion', N'ImpuestosRetencionesDefinicion', 'OBJECT' 
GO
ALTER TABLE dbo.ImpuestosRetencionesDefinicion ADD CONSTRAINT
	PK_ImpuestosRetencionesDefinicion PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Facturas_Impuestos ADD CONSTRAINT
	FK_Facturas_Impuestos_ImpuestosRetencionesDefinicion FOREIGN KEY
	(
	ImpRetID
	) REFERENCES dbo.ImpuestosRetencionesDefinicion
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Facturas_Impuestos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


/* agregamos registros a la tabla ImpuestosRetencionesDefinicion, para agregar las definiciones del: 
   iva, ret iva y ret islr */ 
   
Insert Into ImpuestosRetencionesDefinicion (Predefinido, ImpuestoRetencion, Descripcion) Values (1, 1, 'Impuesto Iva') 
Insert Into ImpuestosRetencionesDefinicion (Predefinido, ImpuestoRetencion, Descripcion) Values (2, 2, 'Retención Iva') 
Insert Into ImpuestosRetencionesDefinicion (Predefinido, ImpuestoRetencion, Descripcion) Values (3, 2, 'Retención Islr') 





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
ALTER TABLE dbo.Facturas_Impuestos
	DROP CONSTRAINT FK_Facturas_Impuestos_ImpuestosRetencionesDefinicion
GO
ALTER TABLE dbo.ImpuestosRetencionesDefinicion SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Facturas_Impuestos
	DROP CONSTRAINT FK_Facturas_Impuestos_Facturas
GO
ALTER TABLE dbo.Facturas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Facturas_Impuestos
	(
	ID int NOT NULL IDENTITY (1, 1),
	FacturaID int NOT NULL,
	ImpRetID int NOT NULL,
	Codigo nvarchar(6) NULL,
	MontoBase money NULL,
	Porcentaje decimal(6, 3) NULL,
	TipoAlicuota nvarchar(1) NULL,
	MontoAntesSustraendo money NULL,
	Sustraendo money NULL,
	Monto money NOT NULL,
	FechaRecepcionPlanilla date NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Facturas_Impuestos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Facturas_Impuestos ON
GO
IF EXISTS(SELECT * FROM dbo.Facturas_Impuestos)
	 EXEC('INSERT INTO dbo.Tmp_Facturas_Impuestos (ID, FacturaID, ImpRetID, Codigo, MontoBase, Porcentaje, TipoAlicuota, MontoAntesSustraendo, Sustraendo, Monto, FechaRecepcionPlanilla)
		SELECT ID, FacturaID, ImpRetID, Codigo, MontoBase, Porcentaje, TipoAlicuota, MontoAntesSustraendo, Sustraendo, Monto, FechaRecepcionPlanilla FROM dbo.Facturas_Impuestos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Facturas_Impuestos OFF
GO
DROP TABLE dbo.Facturas_Impuestos
GO
EXECUTE sp_rename N'dbo.Tmp_Facturas_Impuestos', N'Facturas_Impuestos', 'OBJECT' 
GO
ALTER TABLE dbo.Facturas_Impuestos ADD CONSTRAINT
	PK_Facturas_Impuestos PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Facturas_Impuestos ADD CONSTRAINT
	FK_Facturas_Impuestos_Facturas FOREIGN KEY
	(
	FacturaID
	) REFERENCES dbo.Facturas
	(
	ClaveUnica
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Facturas_Impuestos ADD CONSTRAINT
	FK_Facturas_Impuestos_ImpuestosRetencionesDefinicion FOREIGN KEY
	(
	ImpRetID
	) REFERENCES dbo.ImpuestosRetencionesDefinicion
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.368a', GetDate()) 
