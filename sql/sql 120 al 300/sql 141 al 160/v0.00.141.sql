/*    Lunes 21 de octubre de 2002   -   v0.00.141.sql 

	Agregamos los objetos necesarios para cargar los estados de cuenta del banco. 

*/ 



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaEstadosCuentaBancariaOriginalConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaEstadosCuentaBancariaOriginalConsulta]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qListadoEstadosCuentaBancariaOriginal]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qListadoEstadosCuentaBancariaOriginal]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EstadosCuentaBancariaOriginal]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EstadosCuentaBancariaOriginal]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[EstadosCuentaBancariaOriginalId]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[EstadosCuentaBancariaOriginalId]
GO

CREATE TABLE [dbo].[EstadosCuentaBancariaOriginal] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[NumeroId] [int] NOT NULL ,
	[CuentaBancaria] [int] NOT NULL ,
	[Desde] [datetime] NOT NULL ,
	[Hasta] [datetime] NOT NULL ,
	[Fecha] [datetime] NOT NULL ,
	[Referencia] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Concepto] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Cargo] [money] NOT NULL ,
	[Abono] [money] NOT NULL ,
	[Cia] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[EstadosCuentaBancariaOriginalId] (
	[Numero] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[EstadosCuentaBancariaOriginal] WITH NOCHECK ADD 
	CONSTRAINT [PK_EstadosCuentaBancariaOriginal] PRIMARY KEY  CLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [IX_EstadosCuentaBancariaOriginal] ON [dbo].[EstadosCuentaBancariaOriginal]([NumeroId]) ON [PRIMARY]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.qFormaEstadosCuentaBancariaOriginalConsulta
AS
SELECT     dbo.EstadosCuentaBancariaOriginal.NumeroId, dbo.EstadosCuentaBancariaOriginal.CuentaBancaria, 
                      dbo.CuentasBancarias.CuentaBancaria AS NombreCuentaBancaria, dbo.Bancos.Nombre AS NombreBanco, dbo.CuentasBancarias.Banco, 
                      dbo.EstadosCuentaBancariaOriginal.Desde, dbo.EstadosCuentaBancariaOriginal.Hasta, dbo.EstadosCuentaBancariaOriginal.Fecha, 
                      dbo.EstadosCuentaBancariaOriginal.Referencia, dbo.EstadosCuentaBancariaOriginal.Concepto, dbo.EstadosCuentaBancariaOriginal.Cargo, 
                      dbo.EstadosCuentaBancariaOriginal.Abono, dbo.EstadosCuentaBancariaOriginal.Cia
FROM         dbo.EstadosCuentaBancariaOriginal INNER JOIN
                      dbo.CuentasBancarias ON dbo.EstadosCuentaBancariaOriginal.CuentaBancaria = dbo.CuentasBancarias.CuentaInterna INNER JOIN
                      dbo.Bancos ON dbo.CuentasBancarias.Banco = dbo.Bancos.Banco

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE VIEW dbo.[qListadoEstadosCuentaBancariaOriginal]
AS
SELECT     dbo.EstadosCuentaBancariaOriginal.NumeroId, dbo.EstadosCuentaBancariaOriginal.CuentaBancaria, 
                      dbo.CuentasBancarias.CuentaBancaria AS NombreCuentaBancaria, dbo.Bancos.Nombre AS NombreBanco, dbo.CuentasBancarias.Banco, 
                      dbo.EstadosCuentaBancariaOriginal.Desde, dbo.EstadosCuentaBancariaOriginal.Hasta, dbo.EstadosCuentaBancariaOriginal.Fecha, 
                      dbo.EstadosCuentaBancariaOriginal.Referencia, dbo.EstadosCuentaBancariaOriginal.Concepto, dbo.EstadosCuentaBancariaOriginal.Cargo, 
                      dbo.EstadosCuentaBancariaOriginal.Abono, dbo.EstadosCuentaBancariaOriginal.Cia
FROM         dbo.EstadosCuentaBancariaOriginal INNER JOIN
                      dbo.CuentasBancarias ON dbo.EstadosCuentaBancariaOriginal.CuentaBancaria = dbo.CuentasBancarias.CuentaInterna INNER JOIN
                      dbo.Bancos ON dbo.CuentasBancarias.Banco = dbo.Bancos.Banco
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.141', GetDate()) 

