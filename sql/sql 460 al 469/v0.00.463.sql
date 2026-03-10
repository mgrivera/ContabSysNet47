/*    
	  Martes, 10 de Diciembre de 2.024  -   v0.00.463.sql 
	  
	  Hacemos modificaciones (menores) a la tabla Prefactura
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
ALTER TABLE dbo.PreFactura
	DROP CONSTRAINT FK_PreFactura_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.PreFactura
	DROP CONSTRAINT FK_PreFactura_TiposProveedor
GO
ALTER TABLE dbo.TiposProveedor SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.PreFactura
	DROP CONSTRAINT FK_PreFactura_FormasDePago
GO
ALTER TABLE dbo.FormasDePago SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.PreFactura
	DROP CONSTRAINT FK_PreFactura_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.PreFactura
	DROP CONSTRAINT FK_PreFactura_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_PreFactura
	(
	Id int NOT NULL IDENTITY (1, 1),
	Seleccionada bit NOT NULL,
	CompaniaId int NOT NULL,
	MonedaId int NOT NULL,
	Tasa decimal(10, 6) NOT NULL,
	ConvertirPorTasa bit NULL,
	FechaEmision date NOT NULL,
	FechaRecepcion date NOT NULL,
	CxCCxPFlag smallint NOT NULL,
	FormaPagoId int NOT NULL,
	TipoServicioId int NOT NULL,
	Concepto ntext NOT NULL,
	MontoNoImponible money NULL,
	MontoImponible money NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_PreFactura SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_PreFactura ON
GO
IF EXISTS(SELECT * FROM dbo.PreFactura)
	 EXEC('INSERT INTO dbo.Tmp_PreFactura (Id, Seleccionada, CompaniaId, MonedaId, Tasa, FechaEmision, FechaRecepcion, CxCCxPFlag, FormaPagoId, TipoServicioId, Concepto, MontoNoImponible, MontoImponible, Cia)
		SELECT Id, Seleccionada, CompaniaId, MonedaId, Tasa, FechaEmision, FechaRecepcion, CxCCxPFlag, FormaPagoId, TipoServicioId, Concepto, MontoNoImponible, MontoImponible, Cia FROM dbo.PreFactura WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_PreFactura OFF
GO
DROP TABLE dbo.PreFactura
GO
EXECUTE sp_rename N'dbo.Tmp_PreFactura', N'PreFactura', 'OBJECT' 
GO
ALTER TABLE dbo.PreFactura ADD CONSTRAINT
	PK_PreFactura PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.PreFactura ADD CONSTRAINT
	FK_PreFactura_Proveedores FOREIGN KEY
	(
	CompaniaId
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.PreFactura ADD CONSTRAINT
	FK_PreFactura_Monedas FOREIGN KEY
	(
	MonedaId
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.PreFactura ADD CONSTRAINT
	FK_PreFactura_FormasDePago FOREIGN KEY
	(
	FormaPagoId
	) REFERENCES dbo.FormasDePago
	(
	FormaDePago
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.PreFactura ADD CONSTRAINT
	FK_PreFactura_TiposProveedor FOREIGN KEY
	(
	TipoServicioId
	) REFERENCES dbo.TiposProveedor
	(
	Tipo
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.PreFactura ADD CONSTRAINT
	FK_PreFactura_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT




/* La columna ConvertirPorTasa debe ser Not Null */ 
Update Prefactura Set ConvertirPorTasa = 0 
Alter Table Prefactura Alter Column ConvertirPorTasa bit Not Null


Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.463', GetDate()) 