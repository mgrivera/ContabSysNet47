/*    Miércoles 28 de Agosto de 2002   -   v0.00.135.sql 

	Agregamos algunos items a la tabla InventarioActivosFijos. 

*/ 


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_InventarioActivosFijos
	(
	ClaveUnica int NOT NULL,
	Producto nvarchar(15) NOT NULL,
	Tipo int NULL,
	Departamento int NULL,
	Descripcion nvarchar(255) NULL,
	CompradoA nvarchar(255) NULL,
	Proveedor int NULL,
	Serial nvarchar(255) NULL,
	Modelo nvarchar(255) NULL,
	Placa nvarchar(255) NULL,
	Factura nvarchar(255) NULL,
	FechaCompra datetime NULL,
	CostoTotal money NULL,
	ValorResidual money NULL,
	MontoADepreciar money NULL,
	NumeroDeAnos decimal(5, 2) NULL,
	FechaDesincorporacion datetime NULL,
	DesincorporadoFlag bit NULL,
	AutorizadoPor int NULL,
	MotivoDesincorporacion ntext NULL,
	DepreciarDesdeMes smallint NULL,
	DepreciarDesdeAno smallint NULL,
	DepreciarHastaMes smallint NULL,
	DepreciarHastaAno smallint NULL,
	CantidadMesesADepreciar smallint NULL,
	MontoDepreciacionMensual money NULL,
	Ingreso datetime NULL,
	UltAct datetime NULL,
	Usuario nvarchar(25) NULL,
	Cia int NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.InventarioActivosFijos)
	 EXEC('INSERT INTO dbo.Tmp_InventarioActivosFijos (ClaveUnica, Producto, Tipo, Departamento, Descripcion, CompradoA, Serial, Modelo, Placa, Factura, FechaCompra, CostoTotal, ValorResidual, MontoADepreciar, NumeroDeAnos, FechaDesincorporacion, DesincorporadoFlag, AutorizadoPor, MotivoDesincorporacion, Ingreso, UltAct, Usuario, Cia)
		SELECT ClaveUnica, Producto, Tipo, Departamento, Descripcion, CompradoA, Serial, Modelo, Placa, Factura, FechaCompra, CostoTotal, ValorResidual, MontoADepreciar, NumeroDeAnos, FechaDesincorporacion, DesincorporadoFlag, AutorizadoPor, MotivoDesincorporacion, Ingreso, UltAct, Usuario, Cia FROM dbo.InventarioActivosFijos TABLOCKX')
GO
DROP TABLE dbo.InventarioActivosFijos
GO
EXECUTE sp_rename N'dbo.Tmp_InventarioActivosFijos', N'InventarioActivosFijos', 'OBJECT'
GO
ALTER TABLE dbo.InventarioActivosFijos ADD CONSTRAINT
	PK_InventarioActivosFijos PRIMARY KEY NONCLUSTERED 
	(
	ClaveUnica
	) ON [PRIMARY]

GO
COMMIT


--  ----------------------------------------------------------------------
--  damos valor a los nuevos items (en base al valor de items existentes) 
--  ----------------------------------------------------------------------

Update InventarioActivosFijos Set 
	DepreciarDesdeMes = DatePart(m, FechaCompra), 
	DepreciarDesdeAno = DatePart(yyyy, FechaCompra), 
	DepreciarHastaMes = DatePart(m, DateAdd(m, NumeroDeAnos * 12 - 1, FechaCompra)), 
	DepreciarHastaAno = DatePart(yyyy, DateAdd(m, NumeroDeAnos * 12 -1, FechaCompra)), 
	CantidadMesesADepreciar = DateDiff(m, FechaCompra, DateAdd(yy, NumeroDeAnos, FechaCompra)), 
	MontoDepreciacionMensual = MontoADepreciar / DateDiff(mm, FechaCompra, DateAdd(yy, NumeroDeAnos, FechaCompra)) 
	From InventarioActivosFijos 

--  ----------------------------------------------------------------------
--  ahora hacemos not null a los nuevos items 
--  ----------------------------------------------------------------------

Update InventarioActivosFijos Set Ingreso = '1/1/1960' where Ingreso Is Null 
Update InventarioActivosFijos Set UltAct = '1/1/1960' where UltAct Is Null 
Update InventarioActivosFijos Set Usuario = 'sin usuario' where Usuario Is Null Or Usuario = ''

Alter Table InventarioActivosFijos Alter Column DepreciarDesdeMes smallint not null  
Alter Table InventarioActivosFijos Alter Column DepreciarDesdeAno smallint not null  
Alter Table InventarioActivosFijos Alter Column DepreciarHastaMes smallint not null  
Alter Table InventarioActivosFijos Alter Column DepreciarHastaAno smallint not null  
Alter Table InventarioActivosFijos Alter Column CantidadMesesADepreciar smallint not null  
Alter Table InventarioActivosFijos Alter Column MontoDepreciacionMensual money not null 


Alter Table InventarioActivosFijos Alter Column Tipo int not null  
Alter Table InventarioActivosFijos Alter Column Departamento int not null  
Alter Table InventarioActivosFijos Alter Column Descripcion nvarchar(255) not null  
Alter Table InventarioActivosFijos Alter Column FechaCompra smalldatetime not null  
Alter Table InventarioActivosFijos Alter Column CostoTotal money not null  
Alter Table InventarioActivosFijos Alter Column MontoADepreciar money not null 

Alter Table InventarioActivosFijos Alter Column NumeroDeAnos decimal(5,2) not null  
Alter Table InventarioActivosFijos Alter Column Ingreso smalldatetime not null  
Alter Table InventarioActivosFijos Alter Column UltAct smalldatetime not null  
Alter Table InventarioActivosFijos Alter Column Usuario nvarchar(25) not null  
Alter Table InventarioActivosFijos Alter Column Cia smallint not null  


--  ----------------------------------------------------------------------
--  views de la tabla actualizada 
--  ----------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaInventarioActivosFijosConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaInventarioActivosFijosConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaInventarioActivosFijos]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaInventarioActivosFijos]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaInventarioActivosFijos
AS
SELECT     ClaveUnica, Producto, Tipo, Departamento, Descripcion, CompradoA, Proveedor, Serial, Modelo, Placa, Factura, FechaCompra, CostoTotal, 
                      ValorResidual, MontoADepreciar, NumeroDeAnos, DepreciarDesdeMes, DepreciarDesdeAno, DepreciarHastaMes, DepreciarHastaAno, 
                      CantidadMesesADepreciar, MontoDepreciacionMensual, FechaDesincorporacion, DesincorporadoFlag, AutorizadoPor, MotivoDesincorporacion, 
                      Ingreso, UltAct, Usuario, Cia
FROM         dbo.InventarioActivosFijos

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaInventarioActivosFijosConsulta
AS
SELECT     dbo.InventarioActivosFijos.ClaveUnica, dbo.InventarioActivosFijos.Producto, dbo.InventarioActivosFijos.Tipo, 
                      dbo.TiposDeProducto.Descripcion AS NombreTipoDeProducto, dbo.InventarioActivosFijos.Departamento, 
                      dbo.tDepartamentos.Descripcion AS NombreDepartamento, dbo.InventarioActivosFijos.Descripcion, dbo.InventarioActivosFijos.CompradoA, 
                      dbo.InventarioActivosFijos.Proveedor, dbo.Proveedores.Nombre AS NombreProveedor, dbo.InventarioActivosFijos.Serial, 
                      dbo.InventarioActivosFijos.Modelo, dbo.InventarioActivosFijos.Placa, dbo.InventarioActivosFijos.Factura, dbo.InventarioActivosFijos.FechaCompra, 
                      dbo.InventarioActivosFijos.CostoTotal, dbo.InventarioActivosFijos.ValorResidual, dbo.InventarioActivosFijos.MontoADepreciar, 
                      dbo.InventarioActivosFijos.NumeroDeAnos, dbo.InventarioActivosFijos.DepreciarDesdeMes, dbo.InventarioActivosFijos.DepreciarDesdeAno, 
                      dbo.InventarioActivosFijos.DepreciarHastaMes, dbo.InventarioActivosFijos.DepreciarHastaAno, dbo.InventarioActivosFijos.CantidadMesesADepreciar, 
                      dbo.InventarioActivosFijos.MontoDepreciacionMensual, dbo.InventarioActivosFijos.FechaDesincorporacion, 
                      dbo.InventarioActivosFijos.DesincorporadoFlag, dbo.InventarioActivosFijos.AutorizadoPor, dbo.tEmpleados.Nombre AS NombreAutorizadoPor, 
                      dbo.InventarioActivosFijos.MotivoDesincorporacion, dbo.InventarioActivosFijos.Ingreso, dbo.InventarioActivosFijos.UltAct, 
                      dbo.InventarioActivosFijos.Usuario, dbo.InventarioActivosFijos.Cia
FROM         dbo.InventarioActivosFijos LEFT OUTER JOIN
                      dbo.Proveedores ON dbo.InventarioActivosFijos.Proveedor = dbo.Proveedores.Proveedor LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.InventarioActivosFijos.AutorizadoPor = dbo.tEmpleados.Empleado LEFT OUTER JOIN
                      dbo.TiposDeProducto ON dbo.InventarioActivosFijos.Tipo = dbo.TiposDeProducto.Tipo LEFT OUTER JOIN
                      dbo.tDepartamentos ON dbo.InventarioActivosFijos.Departamento = dbo.tDepartamentos.Departamento

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

--  ------------------------------------------------------
--  intentamos tomar el proveedor de la tabla Proveedores 
--  ------------------------------------------------------


Update InventarioActivosFijos Set InventarioActivosFijos.Proveedor = Proveedores.Proveedor From 
InventarioActivosFijos Inner Join Proveedores On InventarioActivosFijos.CompradoA = Proveedores.Nombre


--  ----------------------------------------------
-- ... para generar el listado de activos fijos
--  ----------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoInventarioActivosFijos]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoInventarioActivosFijos]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempListadoDepreciacionActivosFijosPorMes]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempListadoDepreciacionActivosFijosPorMes]
GO

CREATE TABLE [dbo].[tTempListadoDepreciacionActivosFijosPorMes] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Producto] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Tipo] [int] NULL ,
	[NombreTipo] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Departamento] [int] NULL ,
	[NombreDepartamento] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Descripcion] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FechaCompra] [datetime] NULL ,
	[CostoTotal] [money] NULL ,
	[MontoADepreciar] [money] NULL ,
	[FechaDesincorporacion] [datetime] NULL ,
	[DepreciarDesdeMes] [smallint] NULL ,
	[DepreciarDesdeAno] [smallint] NULL ,
	[DepreciarHastaMes] [smallint] NULL ,
	[DepreciarHastaAno] [smallint] NULL ,
	[DepreciarHastaString] [char] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[VidaUtilMeses] [smallint] NULL ,
	[MesesTranscurridosAcumulados] [smallint] NULL ,
	[MesesTranscurridosAno] [smallint] NULL ,
	[MesesVidaRestantes] [smallint] NULL ,
	[DepreciacionMensual] [money] NULL ,
	[DepreciacionAcumulada] [money] NULL ,
	[DepreciacionAno] [money] NULL ,
	[ValorResidual] [money] NULL ,
	[NumeroUsuario] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempListadoDepreciacionActivosFijosPorMes] WITH NOCHECK ADD 
	CONSTRAINT [PK__tTempListadoDepr__0CC5D56F] PRIMARY KEY  CLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoInventarioActivosFijos
AS
SELECT     dbo.InventarioActivosFijos.ClaveUnica, dbo.InventarioActivosFijos.Producto, dbo.InventarioActivosFijos.Tipo, 
                      dbo.TiposDeProducto.Descripcion AS NombreTipoProducto, dbo.InventarioActivosFijos.Departamento, 
                      dbo.tDepartamentos.Descripcion AS NombreDepartamento, dbo.InventarioActivosFijos.Descripcion, dbo.InventarioActivosFijos.CompradoA, 
                      dbo.InventarioActivosFijos.Proveedor, dbo.Proveedores.Nombre AS NombreProveedor, dbo.InventarioActivosFijos.Serial, 
                      dbo.InventarioActivosFijos.Modelo, dbo.InventarioActivosFijos.Placa, dbo.InventarioActivosFijos.Factura, dbo.InventarioActivosFijos.FechaCompra, 
                      dbo.InventarioActivosFijos.CostoTotal, dbo.InventarioActivosFijos.ValorResidual, dbo.InventarioActivosFijos.MontoADepreciar, 
                      dbo.InventarioActivosFijos.NumeroDeAnos, dbo.InventarioActivosFijos.FechaDesincorporacion, dbo.InventarioActivosFijos.DesincorporadoFlag, 
                      dbo.InventarioActivosFijos.AutorizadoPor, dbo.InventarioActivosFijos.MotivoDesincorporacion, dbo.InventarioActivosFijos.Ingreso, 
                      dbo.InventarioActivosFijos.UltAct, dbo.InventarioActivosFijos.Usuario, dbo.InventarioActivosFijos.Cia, 
                      dbo.InventarioActivosFijos.MontoDepreciacionMensual
FROM         dbo.InventarioActivosFijos LEFT OUTER JOIN
                      dbo.tDepartamentos ON dbo.InventarioActivosFijos.Departamento = dbo.tDepartamentos.Departamento LEFT OUTER JOIN
                      dbo.Proveedores ON dbo.InventarioActivosFijos.Proveedor = dbo.Proveedores.Proveedor LEFT OUTER JOIN
                      dbo.TiposDeProducto ON dbo.InventarioActivosFijos.Tipo = dbo.TiposDeProducto.Tipo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  ------------------------
--  qListadoSubReportPersonas
--  ------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoSubReportPersonas]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoSubReportPersonas]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoSubReportPersonas
AS
SELECT     dbo.Personas.Titulo + N' ' + dbo.Personas.Nombre + N' ' + dbo.Personas.Apellido AS NombrePersona, dbo.Personas.Compania, 
                      dbo.tCargos.Descripcion AS NombreCargo, dbo.Personas.Telefono, dbo.Personas.Fax, dbo.Personas.Celular, dbo.Personas.email
FROM         dbo.Personas INNER JOIN
                      dbo.tCargos ON dbo.Personas.Cargo = dbo.tCargos.Cargo

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.135', GetDate()) 

