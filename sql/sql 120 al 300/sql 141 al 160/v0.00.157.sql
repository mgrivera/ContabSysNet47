/*    Martes, 4 de Mayo de 2.004   -   v0.00.157.sql 

	Hacemos algunos cambios a la tabla tTempPrintChequesContinuos. 

*/ 

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tTempPrintChequesContinuos]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tTempPrintChequesContinuos]
GO

CREATE TABLE [dbo].[tTempPrintChequesContinuos] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Beneficiario] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NombreBeneficiario] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ConceptoCheque] [nvarchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sFechaEscrita] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Fecha] [datetime] NULL ,
	[FechaCortaEditada] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Ano] [smallint] NULL ,
	[NombreCompania] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NumeroComprobante] [int] NULL ,
	[NumeroCheque] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaBancaria] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[SimboloMoneda] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NombreCiudad] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[EndosableFlag] [bit] NULL ,
	[ClaveUnicaComprobante] [int] NULL ,
	[NombreBanco] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sMonto] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ElaboradoPor] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[RevisadoPor] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[AprovadoPor] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[ContabilizadoPor] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable1] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida1] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber1] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable2] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida2] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber2] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable3] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida3] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber3] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable4] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida4] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber4] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable5] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida5] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber5] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable6] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida6] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber6] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable7] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida7] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber7] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable8] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida8] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber8] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable9] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida9] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber9] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable10] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida10] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber10] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable11] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida11] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber11] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable12] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida12] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber12] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable13] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida13] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber13] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable14] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida14] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber14] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[CuentaContable15] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[DescripcionPartida15] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[sDebeOHaber15] [nvarchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[NumeroUsuario] [int] NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tTempPrintChequesContinuos] ADD 
	CONSTRAINT [PK_tTempPrintChequesContinuos] PRIMARY KEY  NONCLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.157', GetDate()) 

