/*    Lunes, 21 de Febrero de 2.005   -   v0.00.167.sql 

	Agregamos la tabla 'temporal' tTempArcEmpleadosMailMerge. 

*/ 



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempArcEmpleadosMailMerge]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempArcEmpleadosMailMerge]
GO

CREATE TABLE [dbo].[tTempArcEmpleadosMailMerge] (
	[Empleado] [int] NOT NULL ,
	[Ano] [smallint] NULL ,
	[FechaInicial] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[FechaFinal] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NombreEmpleado] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Cedula] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NombreCompania] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NumeroRif] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Direccion] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Ciudad] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EntidadFederal] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ZonaPostal] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Telefono] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SSO] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemuneracionesEne] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PorRetencionEne] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpuestoEne] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemAcumEne] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpAcumEne] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemuneracionesFeb] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PorRetencionFeb] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpuestoFeb] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemAcumFeb] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpAcumFeb] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemuneracionesMar] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PorRetencionMar] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpuestoMar] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemAcumMar] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpAcumMar] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemuneracionesAbr] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PorRetencionAbr] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpuestoAbr] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemAcumAbr] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpAcumAbr] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemuneracionesMay] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PorRetencionMay] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpuestoMay] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemAcumMay] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpAcumMay] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemuneracionesJun] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PorRetencionJun] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpuestoJun] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemAcumJun] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpAcumJun] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemuneracionesJul] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PorRetencionJul] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpuestoJul] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemAcumJul] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpAcumJul] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemuneracionesAgo] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PorRetencionAgo] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpuestoAgo] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemAcumAgo] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpAcumAgo] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemuneracionesSep] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PorRetencionSep] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpuestoSep] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemAcumSep] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpAcumSep] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemuneracionesOct] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PorRetencionOct] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpuestoOct] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemAcumOct] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpAcumOct] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemuneracionesNov] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PorRetencionNov] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpuestoNov] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemAcumNov] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpAcumNov] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemuneracionesDic] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[PorRetencionDic] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpuestoDic] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RemAcumDic] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ImpAcumDic] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Cia] [int] NOT NULL ,
	[NumeroUsuario] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempArcEmpleadosMailMerge] WITH NOCHECK ADD 
	CONSTRAINT [PK_tTempArcEmpleadosMailMerge] PRIMARY KEY  CLUSTERED 
	(
		[Empleado],
		[Cia]
	)  ON [PRIMARY] 
GO




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.167', GetDate()) 

