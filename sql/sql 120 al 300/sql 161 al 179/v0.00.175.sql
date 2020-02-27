/*    Viernes, 17 de Junio de 2.005   -   v0.00.175.sql 

	Agregamos la tabla 'temporal' tTempAgregarNivelesAUnaCuentaContable 

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempAgregarNivelesAUnaCuentaContable]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempAgregarNivelesAUnaCuentaContable]
GO

CREATE TABLE [dbo].[tTempAgregarNivelesAUnaCuentaContable] (
	[ClaveUnica] [numeric](18, 0) IDENTITY (1, 1) NOT NULL ,
	[NivelCuentaContable] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Descripcion] [nvarchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[RecibirAsientosFlag] [bit] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempAgregarNivelesAUnaCuentaContable] WITH NOCHECK ADD 
	CONSTRAINT [PK_tTempAgregarNivelesAUnaCuentaContable] PRIMARY KEY  CLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tTempAgregarNivelesAUnaCuentaContable] ADD 
	CONSTRAINT [DF_tTempAgregarNivelesAUnaCuentaContable_RecibirAsientosFlag] DEFAULT (0) FOR [RecibirAsientosFlag]
GO




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.175', GetDate()) 

