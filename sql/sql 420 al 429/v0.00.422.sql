/*    
	  Martes, 19 de Diciembre de 2.019  -   v0.00.422.sql 
	  
	  Aumentamos el tamaño de la columna usuario en la tabla de registro de activos fijos 
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
ALTER TABLE dbo.InventarioActivosFijos
	DROP CONSTRAINT FK_InventarioActivosFijos_Monedas
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.InventarioActivosFijos
	DROP CONSTRAINT FK_InventarioActivosFijos_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.InventarioActivosFijos
	DROP CONSTRAINT FK_InventarioActivosFijos_tEmpleados
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.InventarioActivosFijos
	DROP CONSTRAINT FK_InventarioActivosFijos_tDepartamentos
GO
ALTER TABLE dbo.tDepartamentos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.InventarioActivosFijos
	DROP CONSTRAINT FK_InventarioActivosFijos_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.InventarioActivosFijos
	DROP CONSTRAINT FK_InventarioActivosFijos_TiposDeProducto
GO
ALTER TABLE dbo.TiposDeProducto SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_InventarioActivosFijos
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Moneda int NOT NULL,
	Producto nvarchar(15) NOT NULL,
	Tipo int NOT NULL,
	Departamento int NOT NULL,
	Descripcion nvarchar(255) NOT NULL,
	CompradoA nvarchar(255) NULL,
	Proveedor int NULL,
	Serial nvarchar(255) NULL,
	Modelo nvarchar(255) NULL,
	Placa nvarchar(255) NULL,
	Factura nvarchar(255) NULL,
	FechaCompra date NOT NULL,
	CostoTotal money NOT NULL,
	ValorResidual money NOT NULL,
	MontoADepreciar money NOT NULL,
	NumeroDeAnos decimal(5, 2) NOT NULL,
	FechaDesincorporacion date NULL,
	DesincorporadoFlag bit NULL,
	AutorizadoPor int NULL,
	MotivoDesincorporacion ntext NULL,
	DepreciarDesdeMes smallint NOT NULL,
	DepreciarDesdeAno smallint NOT NULL,
	DepreciarHastaMes smallint NOT NULL,
	DepreciarHastaAno smallint NOT NULL,
	CantidadMesesADepreciar smallint NOT NULL,
	MontoDepreciacionMensual money NOT NULL,
	Ingreso datetime2(7) NOT NULL,
	UltAct datetime2(7) NOT NULL,
	Usuario nvarchar(125) NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_InventarioActivosFijos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_InventarioActivosFijos ON
GO
IF EXISTS(SELECT * FROM dbo.InventarioActivosFijos)
	 EXEC('INSERT INTO dbo.Tmp_InventarioActivosFijos (ClaveUnica, Moneda, Producto, Tipo, Departamento, Descripcion, CompradoA, Proveedor, Serial, Modelo, Placa, Factura, FechaCompra, CostoTotal, ValorResidual, MontoADepreciar, NumeroDeAnos, FechaDesincorporacion, DesincorporadoFlag, AutorizadoPor, MotivoDesincorporacion, DepreciarDesdeMes, DepreciarDesdeAno, DepreciarHastaMes, DepreciarHastaAno, CantidadMesesADepreciar, MontoDepreciacionMensual, Ingreso, UltAct, Usuario, Cia)
		SELECT ClaveUnica, Moneda, Producto, Tipo, Departamento, Descripcion, CompradoA, Proveedor, Serial, Modelo, Placa, Factura, FechaCompra, CostoTotal, ValorResidual, MontoADepreciar, NumeroDeAnos, FechaDesincorporacion, DesincorporadoFlag, AutorizadoPor, MotivoDesincorporacion, DepreciarDesdeMes, DepreciarDesdeAno, DepreciarHastaMes, DepreciarHastaAno, CantidadMesesADepreciar, MontoDepreciacionMensual, Ingreso, UltAct, Usuario, Cia FROM dbo.InventarioActivosFijos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_InventarioActivosFijos OFF
GO
ALTER TABLE dbo.tTempActivosFijos_ConsultaDepreciacion
	DROP CONSTRAINT FK_tTempActivosFijos_ConsultaDepreciacion_InventarioActivosFijos
GO
ALTER TABLE dbo.InventarioActivosFijos_AntesReconversionMonetaria
	DROP CONSTRAINT FK_InventarioActivosFijos_AntesReconversionMonetaria_InventarioActivosFijos
GO
ALTER TABLE dbo.AtributosAsignados
	DROP CONSTRAINT FK_AtributosAsignados_InventarioActivosFijos
GO
DROP TABLE dbo.InventarioActivosFijos
GO
EXECUTE sp_rename N'dbo.Tmp_InventarioActivosFijos', N'InventarioActivosFijos', 'OBJECT' 
GO
ALTER TABLE dbo.InventarioActivosFijos ADD CONSTRAINT
	PK_InventarioActivosFijos PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.InventarioActivosFijos ADD CONSTRAINT
	FK_InventarioActivosFijos_TiposDeProducto FOREIGN KEY
	(
	Tipo
	) REFERENCES dbo.TiposDeProducto
	(
	Tipo
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.InventarioActivosFijos ADD CONSTRAINT
	FK_InventarioActivosFijos_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.InventarioActivosFijos ADD CONSTRAINT
	FK_InventarioActivosFijos_tDepartamentos FOREIGN KEY
	(
	Departamento
	) REFERENCES dbo.tDepartamentos
	(
	Departamento
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.InventarioActivosFijos ADD CONSTRAINT
	FK_InventarioActivosFijos_tEmpleados FOREIGN KEY
	(
	AutorizadoPor
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.InventarioActivosFijos ADD CONSTRAINT
	FK_InventarioActivosFijos_Proveedores FOREIGN KEY
	(
	Proveedor
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.InventarioActivosFijos ADD CONSTRAINT
	FK_InventarioActivosFijos_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.AtributosAsignados ADD CONSTRAINT
	FK_AtributosAsignados_InventarioActivosFijos FOREIGN KEY
	(
	ActivoFijoID
	) REFERENCES dbo.InventarioActivosFijos
	(
	ClaveUnica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.AtributosAsignados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.InventarioActivosFijos_AntesReconversionMonetaria ADD CONSTRAINT
	FK_InventarioActivosFijos_AntesReconversionMonetaria_InventarioActivosFijos FOREIGN KEY
	(
	ActivoFijo_ID
	) REFERENCES dbo.InventarioActivosFijos
	(
	ClaveUnica
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.InventarioActivosFijos_AntesReconversionMonetaria SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tTempActivosFijos_ConsultaDepreciacion ADD CONSTRAINT
	FK_tTempActivosFijos_ConsultaDepreciacion_InventarioActivosFijos FOREIGN KEY
	(
	ActivoFijoID
	) REFERENCES dbo.InventarioActivosFijos
	(
	ClaveUnica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tTempActivosFijos_ConsultaDepreciacion SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.422', GetDate()) 


