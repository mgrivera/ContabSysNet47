/*    Jueves, 13 de Enero de 2.011  -   v0.00.274.sql 

	Agregamos la columna SoloAsientosConNumeroNegativoFlag
	a la tabla Usuarios 
*/



/****** Object:  Table [dbo].[tTempPrintChequesContinuos]    Script Date: 01/13/2011 18:18:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTempPrintChequesContinuos]') AND type in (N'U'))
DROP TABLE [dbo].[tTempPrintChequesContinuos]
GO

/****** Object:  Table [dbo].[tTempPrintChequesContinuos]    Script Date: 01/13/2011 18:18:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tTempPrintChequesContinuos](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[Beneficiario] [nvarchar](60) NULL,
	[NombreBeneficiario] [nvarchar](100) NULL,
	[ConceptoCheque] [nvarchar](300) NULL,
	[sFechaEscrita] [nvarchar](50) NULL,
	[Fecha] [datetime] NULL,
	[FechaCortaEditada] [nvarchar](15) NULL,
	[Ano] [smallint] NULL,
	[NombreCompania] [nvarchar](50) NULL,
	[NumeroComprobante] [int] NULL,
	[NumeroCheque] [nvarchar](20) NULL,
	[CuentaBancaria] [nvarchar](50) NULL,
	[SimboloMoneda] [nvarchar](10) NULL,
	[NombreCiudad] [nvarchar](50) NULL,
	[EndosableFlag] [bit] NULL,
	[ClaveUnicaComprobante] [int] NULL,
	[NombreBanco] [nvarchar](50) NULL,
	[sMonto] [nvarchar](50) NULL,
	[ElaboradoPor] [nvarchar](25) NULL,
	[RevisadoPor] [nvarchar](25) NULL,
	[AprovadoPor] [nvarchar](25) NULL,
	[ContabilizadoPor] [nvarchar](25) NULL,
	[CuentaContable1] [nvarchar](30) NULL,
	[NombreCtaCont1] [nvarchar](40) NULL,
	[DescripcionPartida1] [nvarchar](50) NULL,
	[sDebeOHaber1] [nvarchar](25) NULL,
	[CuentaContable2] [nvarchar](30) NULL,
	[NombreCtaCont2] [nvarchar](40) NULL,
	[DescripcionPartida2] [nvarchar](50) NULL,
	[sDebeOHaber2] [nvarchar](25) NULL,
	[CuentaContable3] [nvarchar](30) NULL,
	[NombreCtaCont3] [nvarchar](40) NULL,
	[DescripcionPartida3] [nvarchar](50) NULL,
	[sDebeOHaber3] [nvarchar](25) NULL,
	[CuentaContable4] [nvarchar](30) NULL,
	[NombreCtaCont4] [nvarchar](40) NULL,
	[DescripcionPartida4] [nvarchar](50) NULL,
	[sDebeOHaber4] [nvarchar](25) NULL,
	[CuentaContable5] [nvarchar](30) NULL,
	[NombreCtaCont5] [nvarchar](40) NULL,
	[DescripcionPartida5] [nvarchar](50) NULL,
	[sDebeOHaber5] [nvarchar](25) NULL,
	[CuentaContable6] [nvarchar](30) NULL,
	[NombreCtaCont6] [nvarchar](40) NULL,
	[DescripcionPartida6] [nvarchar](50) NULL,
	[sDebeOHaber6] [nvarchar](25) NULL,
	[CuentaContable7] [nvarchar](30) NULL,
	[NombreCtaCont7] [nvarchar](40) NULL,
	[DescripcionPartida7] [nvarchar](50) NULL,
	[sDebeOHaber7] [nvarchar](25) NULL,
	[CuentaContable8] [nvarchar](30) NULL,
	[NombreCtaCont8] [nvarchar](40) NULL,
	[DescripcionPartida8] [nvarchar](50) NULL,
	[sDebeOHaber8] [nvarchar](25) NULL,
	[CuentaContable9] [nvarchar](30) NULL,
	[NombreCtaCont9] [nvarchar](40) NULL,
	[DescripcionPartida9] [nvarchar](50) NULL,
	[sDebeOHaber9] [nvarchar](25) NULL,
	[CuentaContable10] [nvarchar](30) NULL,
	[NombreCtaCont10] [nvarchar](40) NULL,
	[DescripcionPartida10] [nvarchar](50) NULL,
	[sDebeOHaber10] [nvarchar](25) NULL,
	[CuentaContable11] [nvarchar](30) NULL,
	[NombreCtaCont11] [nvarchar](40) NULL,
	[DescripcionPartida11] [nvarchar](50) NULL,
	[sDebeOHaber11] [nvarchar](25) NULL,
	[CuentaContable12] [nvarchar](30) NULL,
	[NombreCtaCont12] [nvarchar](40) NULL,
	[DescripcionPartida12] [nvarchar](50) NULL,
	[sDebeOHaber12] [nvarchar](25) NULL,
	[CuentaContable13] [nvarchar](30) NULL,
	[NombreCtaCont13] [nvarchar](40) NULL,
	[DescripcionPartida13] [nvarchar](50) NULL,
	[sDebeOHaber13] [nvarchar](25) NULL,
	[CuentaContable14] [nvarchar](30) NULL,
	[NombreCtaCont14] [nvarchar](40) NULL,
	[DescripcionPartida14] [nvarchar](50) NULL,
	[sDebeOHaber14] [nvarchar](25) NULL,
	[CuentaContable15] [nvarchar](30) NULL,
	[NombreCtaCont15] [nvarchar](40) NULL,
	[DescripcionPartida15] [nvarchar](50) NULL,
	[sDebeOHaber15] [nvarchar](25) NULL,
	[NumeroUsuario] [int] NOT NULL,
 CONSTRAINT [PK_tTempPrintChequesContinuos] PRIMARY KEY NONCLUSTERED 
(
	[ClaveUnica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO





--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.274', GetDate()) 