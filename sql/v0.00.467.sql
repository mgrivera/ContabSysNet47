/*    
	  Lunes, 28 de Abril de 2.025  -   v0.00.467.sql 
	  
	  Agregamos la tabla FacturasProductos

*/

-- **********************************************************
-- FacturasProductos
-- **********************************************************


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
ALTER TABLE dbo.ProductosFacturas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Facturas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.FacturasProductos
	(
	Id int NOT NULL IDENTITY (1, 1),
	FacturaId int NOT NULL,
	ProductoId nvarchar(20) NOT NULL,
	Precio_NoImponible decimal(12, 2) NULL,
	Precio_Imponible decimal(12, 2) NULL,
	Cantidad smallint NOT NULL,
	Total decimal(12, 2) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.FacturasProductos ADD CONSTRAINT
	PK_FacturasProductos PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.FacturasProductos ADD CONSTRAINT
	FK_FacturasProductos_Facturas FOREIGN KEY
	(
	FacturaId
	) REFERENCES dbo.Facturas
	(
	ClaveUnica
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.FacturasProductos ADD CONSTRAINT
	FK_FacturasProductos_ProductosFacturas FOREIGN KEY
	(
	ProductoId
	) REFERENCES dbo.ProductosFacturas
	(
	Codigo
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.FacturasProductos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.467', GetDate()) 