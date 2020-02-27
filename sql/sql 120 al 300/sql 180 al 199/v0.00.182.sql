/*    Miercoles, 31 de Agosto de 2.005   -   v0.00.182.sql 

	Agregamos la tabla tTempListadoPresupuestoNivelesAgrupacion

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempListadoPresupuestoNivelesAgrupacion]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempListadoPresupuestoNivelesAgrupacion]
GO

CREATE TABLE [dbo].[tTempListadoPresupuestoNivelesAgrupacion] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Mes] [smallint] NOT NULL ,
	[Ano] [smallint] NOT NULL ,
	[Moneda] [int] NOT NULL ,
	[NombreMoneda] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Grupo] [int] NOT NULL ,
	[NombreGrupo] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NivelAgrupacion] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[NombreNivelAgrupacion] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[MontoEstimado] [money] NOT NULL ,
	[MontoEjecutado] [money] NULL ,
	[Diferencia] [money] NULL ,
	[Desviacion] [float] NULL ,
	[NumeroUsuario] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempListadoPresupuestoNivelesAgrupacion] WITH NOCHECK ADD 
	CONSTRAINT [PK_tTempListadoPresupuestoNivelesAgrupacion] PRIMARY KEY  CLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.182', GetDate()) 