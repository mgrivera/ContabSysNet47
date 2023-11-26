/*    
	  Viernes, 14 de Julio de 2.023  -   v0.00.445.sql 
	  
	  Agregamos los objetos necesarios para la nueva consulta: facturas y sus pagos 
*/



-- **********************************************************************
-- tmp_facturasYSusPagos_filter
-- **********************************************************************

-- Drop a table if it exists using OBJECT_ID
IF OBJECT_ID('dbo.tmp_facturasYSusPagos_filter', 'U') IS NOT NULL
  DROP TABLE dbo.tmp_facturasYSusPagos_filter;


/****** Object:  Table [dbo].[tmp_facturasYSusPagos_filter]    Script Date: 7/14/23 9:54:33 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tmp_facturasYSusPagos_filter](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[desde] [date] NOT NULL,
	[hasta] [date] NOT NULL,
	[moneda] [nvarchar](50) NULL,
	[compania] [nvarchar](50) NULL,
	[tipo1] [nvarchar](10) NULL,
	[tipo2] [nvarchar](10) NULL,
	[agregarPagosSinFacturasAsociadas] [bit] NULL,
	[fechaCalculoVencimientos] [date] NULL,
	[soloSaldoMayorA] [money] NULL,
	[cia] [int] NOT NULL,
	[usuario] [nvarchar](50) NOT NULL,
	[versionCol] rowversion
 CONSTRAINT [PK_tmp_facturasYSusPagos_filter] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO



-- **********************************************************************
-- tmp_facturasYSusPagos
-- **********************************************************************

-- Drop a table if it exists using OBJECT_ID
IF OBJECT_ID('dbo.tmp_facturasYSusPagos', 'U') IS NOT NULL
  DROP TABLE dbo.tmp_facturasYSusPagos;

/****** Object:  Table [dbo].[tmp_facturasYSusPagos]    Script Date: 7/14/23 9:54:20 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tmp_facturasYSusPagos](
	[id] [int] IDENTITY(1,1) NOT NULL,
	
	[cuotaId] [int] NULL,
	[numeroCuota] [tinyint] NULL,
	
	[moneda] [int] NOT NULL,
	[compania] [int] NOT NULL,
	[referencia] [nvarchar](50) NULL,
	[concepto] [nvarchar](250) NULL,
	[fechaEmision] [date] NOT NULL,
	[fechaRecepcion] [date] NULL,
	[tipo1] [nvarchar](10) NOT NULL,
	[tipo2] [nvarchar](10) NULL,
	[cantPagos] [tinyint] NULL,
	[fechaVencimiento] [date] NULL,
	[cantDiasVencimiento] [smallint] NULL,
	[monto] [money] NOT NULL,
	[montoPagos] [money] NULL,
	[saldo] [money] NOT NULL,
	[cia] [int] NOT NULL,
	[usuario] [nvarchar](50) NOT NULL,
	[versionCol] rowversion
 CONSTRAINT [PK_tmp_facturasYSusPagos] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


-- **********************************************************************
-- v_tmp_facturasYSusPagos
-- **********************************************************************

-- Drop a view if it exists using OBJECT_ID
IF OBJECT_ID('dbo.v_tmp_facturasYSusPagos', 'V') IS NOT NULL
  DROP VIEW dbo.v_tmp_facturasYSusPagos;


GO

  Create View dbo.v_tmp_facturasYSusPagos As 
  Select 
	t.id,
	t.cuotaId,
	t.numeroCuota,
	t.moneda,
	m.Descripcion as monedaDescripcion, 
	m.Simbolo as monedaSimbolo, 
	t.compania,
	p.Nombre as companiaNombre, 
	p.Abreviatura as companiaAbreviatura, 
	t.referencia,
	t.concepto, 
	t.fechaEmision ,
	t.fechaRecepcion ,
	t.tipo1 ,
	t.tipo2 ,
	t.cantPagos,
	t.fechaVencimiento, 
	t.cantDiasVencimiento,
	t.monto ,
	t.montoPagos ,
	t.saldo ,
	t.cia,
	c.Nombre as ciaNombre, 
	c.Abreviatura as ciaAbreviatura, 
	t.usuario 
  From tmp_facturasYSusPagos t Inner Join Monedas m On t.moneda = m.Moneda 
  Inner Join Proveedores p On t.compania = p.Proveedor  
  Inner Join Companias c On t.cia = c.Numero 

  Go

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.445', GetDate()) 