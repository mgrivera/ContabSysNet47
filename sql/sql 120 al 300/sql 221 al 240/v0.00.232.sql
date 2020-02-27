/*    Jueves, 08 de Enero de 2.009  -   v0.00.232.sql 

	Creamos la tabla tTempWebReport_PresupuestoConsultaAnual 

*/ 

/****** Object:  Table [dbo].[tTempWebReport_PresupuestoConsultaAnual]    Script Date: 01/10/2009 11:15:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTempWebReport_PresupuestoConsultaAnual]') AND type in (N'U'))
DROP TABLE [dbo].[tTempWebReport_PresupuestoConsultaAnual]
GO

/****** Object:  Table [dbo].[tTempWebReport_PresupuestoConsultaAnual]    Script Date: 01/10/2009 11:15:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tTempWebReport_PresupuestoConsultaAnual](
	[CiaContab] [int] NOT NULL,
	[Moneda] [int] NOT NULL,
	[AnoFiscal] [smallint] NOT NULL,
	[CodigoPresupuesto] [nvarchar](70) NOT NULL,
	[CodigoPresupuesto_PrimerNivel] [nvarchar](70) NOT NULL,
	[Mes01_Eje] [money] NULL,
	[Mes01_Eje_Porc] [real] NULL,
	[Mes02_Eje] [money] NULL,
	[Mes02_Eje_Porc] [real] NULL,
	[Mes03_Eje] [money] NULL,
	[Mes03_Eje_Porc] [real] NULL,
	[Mes04_Eje] [money] NULL,
	[Mes04_Eje_Porc] [real] NULL,
	[Mes05_Eje] [money] NULL,
	[Mes05_Eje_Porc] [real] NULL,
	[Mes06_Eje] [money] NULL,
	[Mes06_Eje_Porc] [real] NULL,
	[Mes07_Eje] [money] NULL,
	[Mes07_Eje_Porc] [real] NULL,
	[Mes08_Eje] [money] NULL,
	[Mes08_Eje_Porc] [real] NULL,
	[Mes09_Eje] [money] NULL,
	[Mes09_Eje_Porc] [real] NULL,
	[Mes10_Eje] [money] NULL,
	[Mes10_Eje_Porc] [real] NULL,
	[Mes11_Eje] [money] NULL,
	[Mes11_Eje_Porc] [real] NULL,
	[Mes12_Eje] [money] NULL,
	[Mes12_Eje_Porc] [real] NULL,
	[TotalEjecutado] [money] NULL,
	[TotalPresupuestado] [money] NULL,
	[Variacion] [real] NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_tTempWebReport_PresupuestoConsultaAnual] PRIMARY KEY CLUSTERED 
(
	[CiaContab] ASC,
	[Moneda] ASC,
	[AnoFiscal] ASC,
	[CodigoPresupuesto] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.232', GetDate()) 