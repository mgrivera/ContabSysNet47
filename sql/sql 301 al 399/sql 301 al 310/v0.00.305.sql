/*    Lunes, 5 de Marzo de 2.012  -   v0.00.305.sql 

	Agregamos relaciones a la tabla de ActivosFijos 
	
	NOTA IMPORTANTE: este script *ya fue aplicado en Geh*; sin embargo, 
	no debe fallar si se vuelve a aplicar. Solo la linea que elimina la tabla 
	InventarioActivosFijosId. 
	
	Geh: no existe TiposDeProductoId (buscar esta tabla más abajo y revisar; ver más abajo) 
	
*/




/* estos selects deben traer 0 records; de otra forma, 
   habrá problemas cuando se intente agregar las 
   relaciones más abajo */ 

Select * From InventarioActivosFijos
Where Departamento Not In 
(Select Departamento From tDepartamentos)

Select * From InventarioActivosFijos
Where Proveedor Is Not Null And Proveedor Not In 
(Select Proveedor From Proveedores)

/* ponemos en nulls los proveedores que se mantienen pero se 
   han eliminado de la tabla de Proveedores */ 

/* si el select anterior trae registros, tenemos que limpiar el Proveedor */ 

Update InventarioActivosFijos Set Proveedor = null
Where Proveedor Is Not Null And Proveedor Not In 
(Select Proveedor From Proveedores)

Select * From InventarioActivosFijos
Where AutorizadoPor Is Not Null and AutorizadoPor Not In 
(Select Empleado From tEmpleados)

Select * From InventarioActivosFijos
Where Cia Not In 
(Select Numero From Companias)

Select * From InventarioActivosFijos
Where Tipo Not In 
(Select Tipo From TiposDeProducto)


/* esta columna va a ser not null ahora */ 
Update InventarioActivosFijos Set ValorResidual = 0 Where ValorResidual Is Null  

/* ===================================================================== */ 

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
ALTER TABLE dbo.TiposDeProducto SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tDepartamentos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

/* vamos por aquí */ 

BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_InventarioActivosFijos
	(
	ClaveUnica int NOT NULL,
	Producto nvarchar(15) ,
	Tipo int NOT NULL,
	Departamento int NOT NULL,
	Descripcion nvarchar(255),
	CompradoA nvarchar(255) ,
	Proveedor int NULL,
	Serial nvarchar(255) ,
	Modelo nvarchar(255),
	Placa nvarchar(255),
	Factura nvarchar(255) ,
	FechaCompra date NOT NULL,
	CostoTotal money NOT NULL,
	ValorResidual money NOT NULL,
	MontoADepreciar money NOT NULL,
	NumeroDeAnos decimal(5, 2) NOT NULL,
	FechaDesincorporacion date NULL,
	DesincorporadoFlag bit NULL,
	AutorizadoPor int NULL,
	MotivoDesincorporacion ntext,
	DepreciarDesdeMes smallint NOT NULL,
	DepreciarDesdeAno smallint NOT NULL,
	DepreciarHastaMes smallint NOT NULL,
	DepreciarHastaAno smallint NOT NULL,
	CantidadMesesADepreciar smallint NOT NULL,
	MontoDepreciacionMensual money NOT NULL,
	Ingreso datetime2(7) NOT NULL,
	UltAct datetime2(7) NOT NULL,
	Usuario nvarchar(25),
	Cia int NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_InventarioActivosFijos SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.InventarioActivosFijos)
	 EXEC('INSERT INTO dbo.Tmp_InventarioActivosFijos (ClaveUnica, Producto, Tipo, Departamento, Descripcion, CompradoA, Proveedor, Serial, Modelo, Placa, Factura, FechaCompra, CostoTotal, ValorResidual, MontoADepreciar, NumeroDeAnos, FechaDesincorporacion, DesincorporadoFlag, AutorizadoPor, MotivoDesincorporacion, DepreciarDesdeMes, DepreciarDesdeAno, DepreciarHastaMes, DepreciarHastaAno, CantidadMesesADepreciar, MontoDepreciacionMensual, Ingreso, UltAct, Usuario, Cia)
		SELECT ClaveUnica, Producto, Tipo, Departamento, Descripcion, CompradoA, Proveedor, Serial, Modelo, Placa, Factura, FechaCompra, CostoTotal, ValorResidual, MontoADepreciar, NumeroDeAnos, FechaDesincorporacion, DesincorporadoFlag, AutorizadoPor, MotivoDesincorporacion, DepreciarDesdeMes, DepreciarDesdeAno, DepreciarHastaMes, DepreciarHastaAno, CantidadMesesADepreciar, MontoDepreciacionMensual, Ingreso, UltAct, Usuario, CONVERT(int, Cia) FROM dbo.InventarioActivosFijos WITH (HOLDLOCK TABLOCKX)')
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
	 ON DELETE  NO ACTION 
	
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
DROP TABLE dbo.InventarioActivosFijosId
GO
COMMIT
BEGIN TRANSACTION
GO

/* no existe en Geh (???) */ 
DROP TABLE dbo.TiposDeProductoId
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
CREATE TABLE dbo.Tmp_TiposDeProducto
	(
	Tipo int NOT NULL IDENTITY (1, 1),
	Descripcion nvarchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_TiposDeProducto SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_TiposDeProducto ON
GO
IF EXISTS(SELECT * FROM dbo.TiposDeProducto)
	 EXEC('INSERT INTO dbo.Tmp_TiposDeProducto (Tipo, Descripcion)
		SELECT Tipo, Descripcion FROM dbo.TiposDeProducto WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_TiposDeProducto OFF
GO
ALTER TABLE dbo.InventarioActivosFijos
	DROP CONSTRAINT FK_InventarioActivosFijos_TiposDeProducto
GO
DROP TABLE dbo.TiposDeProducto
GO
EXECUTE sp_rename N'dbo.Tmp_TiposDeProducto', N'TiposDeProducto', 'OBJECT' 
GO
ALTER TABLE dbo.TiposDeProducto ADD CONSTRAINT
	PK_TiposDeProducto PRIMARY KEY NONCLUSTERED 
	(
	Tipo
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
/* vamos por aquí */ 
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_InventarioActivosFijos
	(
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	Producto nvarchar(15) ,
	Tipo int NOT NULL,
	Departamento int NOT NULL,
	Descripcion nvarchar(255),
	CompradoA nvarchar(255),
	Proveedor int NULL,
	Serial nvarchar(255) ,
	Modelo nvarchar(255) ,
	Placa nvarchar(255),
	Factura nvarchar(255),
	FechaCompra date NOT NULL,
	CostoTotal money NOT NULL,
	ValorResidual money NOT NULL,
	MontoADepreciar money NOT NULL,
	NumeroDeAnos decimal(5, 2) NOT NULL,
	FechaDesincorporacion date NULL,
	DesincorporadoFlag bit NULL,
	AutorizadoPor int NULL,
	MotivoDesincorporacion ntext ,
	DepreciarDesdeMes smallint NOT NULL,
	DepreciarDesdeAno smallint NOT NULL,
	DepreciarHastaMes smallint NOT NULL,
	DepreciarHastaAno smallint NOT NULL,
	CantidadMesesADepreciar smallint NOT NULL,
	MontoDepreciacionMensual money NOT NULL,
	Ingreso datetime2(7) NOT NULL,
	UltAct datetime2(7) NOT NULL,
	Usuario nvarchar(25)  ,
	Cia int NOT NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE dbo.Tmp_InventarioActivosFijos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_InventarioActivosFijos ON
GO
IF EXISTS(SELECT * FROM dbo.InventarioActivosFijos)
	 EXEC('INSERT INTO dbo.Tmp_InventarioActivosFijos (ClaveUnica, Producto, Tipo, Departamento, Descripcion, CompradoA, Proveedor, Serial, Modelo, Placa, Factura, FechaCompra, CostoTotal, ValorResidual, MontoADepreciar, NumeroDeAnos, FechaDesincorporacion, DesincorporadoFlag, AutorizadoPor, MotivoDesincorporacion, DepreciarDesdeMes, DepreciarDesdeAno, DepreciarHastaMes, DepreciarHastaAno, CantidadMesesADepreciar, MontoDepreciacionMensual, Ingreso, UltAct, Usuario, Cia)
		SELECT ClaveUnica, Producto, Tipo, Departamento, Descripcion, CompradoA, Proveedor, Serial, Modelo, Placa, Factura, FechaCompra, CostoTotal, ValorResidual, MontoADepreciar, NumeroDeAnos, FechaDesincorporacion, DesincorporadoFlag, AutorizadoPor, MotivoDesincorporacion, DepreciarDesdeMes, DepreciarDesdeAno, DepreciarHastaMes, DepreciarHastaAno, CantidadMesesADepreciar, MontoDepreciacionMensual, Ingreso, UltAct, Usuario, Cia FROM dbo.InventarioActivosFijos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_InventarioActivosFijos OFF
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
	 ON DELETE  NO ACTION 
	
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
COMMIT





--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.305', GetDate()) 