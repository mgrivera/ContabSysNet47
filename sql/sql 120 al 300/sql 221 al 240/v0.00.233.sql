/*    Martes, 13 de Enero de 2.009  -   v0.00.233.sql 

	Actualizamos la tabla tTempWebReport_PresupuestoConsultaMensual 

*/ 

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tTempWebReport_PresupuestoConsultaMensual_Presupuesto_Codigos]') AND parent_object_id = OBJECT_ID(N'[dbo].[tTempWebReport_PresupuestoConsultaMensual]'))
ALTER TABLE [dbo].[tTempWebReport_PresupuestoConsultaMensual] DROP CONSTRAINT [FK_tTempWebReport_PresupuestoConsultaMensual_Presupuesto_Codigos]
GO

/****** Object:  Table [dbo].[tTempWebReport_PresupuestoConsultaMensual]    Script Date: 01/13/2009 10:58:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTempWebReport_PresupuestoConsultaMensual]') AND type in (N'U'))
DROP TABLE [dbo].[tTempWebReport_PresupuestoConsultaMensual]
GO

/****** Object:  Table [dbo].[tTempWebReport_PresupuestoConsultaMensual]    Script Date: 01/13/2009 10:58:07 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tTempWebReport_PresupuestoConsultaMensual](
	[CiaContab] [int] NOT NULL,
	[Moneda] [int] NOT NULL,
	[AnoFiscal] [smallint] NOT NULL,
	[MesFiscal] [smallint] NOT NULL,
	[MesCalendario] [smallint] NOT NULL,
	[NombreMes] [nvarchar](20) NOT NULL,
	[CodigoPresupuesto] [nvarchar](70) NOT NULL,
	[MontoEstimado] [money] NOT NULL,
	[MontoEjecutado] [money] NOT NULL,
	[Variacion] [real] NOT NULL,
	[MontoEstimadoAcum] [money] NOT NULL,
	[MontoEjecutadoAcum] [money] NOT NULL,
	[VariacionAcum] [real] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_tTempWebReport_PresupuestoConsultaMensual] PRIMARY KEY CLUSTERED 
(
	[CiaContab] ASC,
	[Moneda] ASC,
	[AnoFiscal] ASC,
	[MesCalendario] ASC,
	[CodigoPresupuesto] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tTempWebReport_PresupuestoConsultaMensual]  WITH CHECK ADD  CONSTRAINT [FK_tTempWebReport_PresupuestoConsultaMensual_Presupuesto_Codigos] FOREIGN KEY([CodigoPresupuesto], [CiaContab])
REFERENCES [dbo].[Presupuesto_Codigos] ([Codigo], [CiaContab])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[tTempWebReport_PresupuestoConsultaMensual] CHECK CONSTRAINT [FK_tTempWebReport_PresupuestoConsultaMensual_Presupuesto_Codigos]
GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.233', GetDate()) 