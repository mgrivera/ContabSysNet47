/*    Lunes 19 de Noviembre de 2002   -   v0.00.143.sql 

	Agregamos la tabla temporal y el view para el listado Recibos de Pago. 

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoRecibosPago]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoRecibosPago]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoRecibosDePago]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoRecibosDePago]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempListadoRecibosPago]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempListadoRecibosPago]
GO

CREATE TABLE [dbo].[tTempListadoRecibosPago] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[FechaNomina] [smalldatetime] NOT NULL ,
	[Empleado] [int] NOT NULL ,
	[NombreEmpleado] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SueldoPromedio] [money] NULL ,
	[SueldoBasico] [money] NULL ,
	[Cedula] [nvarchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Departamento] [int] NULL ,
	[NombreDepartamento] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Banco] [int] NULL ,
	[NombreBanco] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaBancaria] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Rubro] [int] NOT NULL ,
	[NombreRubro] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Tipo] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Monto] [money] NOT NULL ,
	[Asignacion] [money] NOT NULL ,
	[Deduccion] [money] NOT NULL ,
	[NumeroUsuario] [int] NOT NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempListadoRecibosPago] WITH NOCHECK ADD 
	CONSTRAINT [PK_tTempListadoRecibosDePago] PRIMARY KEY  CLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qListadoRecibosPago
AS
SELECT     ClaveUnica, FechaNomina, Empleado, NombreEmpleado, SueldoPromedio, SueldoBasico, Cedula, Departamento, NombreDepartamento, Banco, 
                      NombreBanco, CuentaBancaria, Rubro, NombreRubro, Tipo, Monto, Asignacion, Deduccion, NumeroUsuario, Cia
FROM         dbo.tTempListadoRecibosPago

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.143', GetDate()) 

