/*    Viernes, 31 de Enero de 2.013  -   v0.00.330.sql 

	Hacemos cambios leves a la tabla 'temp' para la consulta 
	de activos fijos (depreciación) 
*/


delete from tTempActivosFijos_ConsultaDepreciacion 

BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tTempActivosFijos_ConsultaDepreciacion
	DROP CONSTRAINT FK_tTempActivosFijos_ConsultaDepreciacion_InventarioActivosFijos
GO
ALTER TABLE dbo.InventarioActivosFijos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_tTempActivosFijos_ConsultaDepreciacion
	(
	ID int NOT NULL IDENTITY (1, 1),
	ActivoFijoID int NOT NULL,
	CantidadMesesADepreciar smallint NOT NULL,
	MontoADepreciar money NOT NULL,
	DepreciarHastaMes smallint NOT NULL,
	DepreciarHastaAno smallint NOT NULL,
	DepreciacionMensual money NOT NULL,
	DepAcum_CantMeses smallint NOT NULL,
	DepAcum_CantMeses_AnoActual smallint NOT NULL,
	DepAcum_Total money NOT NULL,
	DepAcum_AnoActual money NOT NULL,
	NombreUsuario nvarchar(256) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_tTempActivosFijos_ConsultaDepreciacion SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_tTempActivosFijos_ConsultaDepreciacion ON
GO
IF EXISTS(SELECT * FROM dbo.tTempActivosFijos_ConsultaDepreciacion)
	 EXEC('INSERT INTO dbo.Tmp_tTempActivosFijos_ConsultaDepreciacion (ID, ActivoFijoID, DepreciarHastaMes, DepreciarHastaAno, DepreciacionMensual, DepAcum_CantMeses, DepAcum_CantMeses_AnoActual, DepAcum_Total, DepAcum_AnoActual, NombreUsuario)
		SELECT ID, ActivoFijoID, DepreciarHastaMes, DepreciarHastaAno, DepreciacionMensual, DepAcum_CantMeses, DepAcum_CantMeses_AnoActual, DepAcum_Total, DepAcum_AnoActual, NombreUsuario FROM dbo.tTempActivosFijos_ConsultaDepreciacion WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_tTempActivosFijos_ConsultaDepreciacion OFF
GO
DROP TABLE dbo.tTempActivosFijos_ConsultaDepreciacion
GO
EXECUTE sp_rename N'dbo.Tmp_tTempActivosFijos_ConsultaDepreciacion', N'tTempActivosFijos_ConsultaDepreciacion', 'OBJECT' 
GO
ALTER TABLE dbo.tTempActivosFijos_ConsultaDepreciacion ADD CONSTRAINT
	PK_tTempActivosFijos_ConsultaDepreciacion PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tTempActivosFijos_ConsultaDepreciacion ADD CONSTRAINT
	FK_tTempActivosFijos_ConsultaDepreciacion_InventarioActivosFijos FOREIGN KEY
	(
	ActivoFijoID
	) REFERENCES dbo.InventarioActivosFijos
	(
	ClaveUnica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT










/****** Object:  View [dbo].[vtTempActivosFijos_ConsultaDepreciacion]    Script Date: 02/01/2013 13:09:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vtTempActivosFijos_ConsultaDepreciacion]'))
DROP VIEW [dbo].[vtTempActivosFijos_ConsultaDepreciacion]
GO


/****** Object:  View [dbo].[vtTempActivosFijos_ConsultaDepreciacion]    Script Date: 02/01/2013 13:09:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vtTempActivosFijos_ConsultaDepreciacion]
AS

SELECT     dbo.Companias.Nombre AS NombreCiaContab, dbo.Companias.Abreviatura AS AbreviaturaCiaContab, dbo.tDepartamentos.Descripcion AS NombreDepartamento, 
                      dbo.TiposDeProducto.Descripcion AS NombreTipoProducto, dbo.InventarioActivosFijos.Producto, dbo.InventarioActivosFijos.Descripcion AS DescripcionProducto, 
                      dbo.InventarioActivosFijos.FechaCompra, dbo.InventarioActivosFijos.FechaDesincorporacion, CAST(dbo.InventarioActivosFijos.DepreciarDesdeMes AS nVarChar) 
                      + N'/' + SUBSTRING(CAST(dbo.InventarioActivosFijos.DepreciarDesdeAno AS nVarChar), 3, 2) AS DepreciarDesde, dbo.InventarioActivosFijos.DepreciarDesdeMes, 
                      dbo.InventarioActivosFijos.DepreciarDesdeAno, CAST(dbo.tTempActivosFijos_ConsultaDepreciacion.DepreciarHastaMes AS nVarChar) 
                      + N'/' + SUBSTRING(CAST(dbo.tTempActivosFijos_ConsultaDepreciacion.DepreciarHastaAno AS nVarChar), 3, 2) AS DepreciarHasta, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.DepreciarHastaMes, dbo.tTempActivosFijos_ConsultaDepreciacion.DepreciarHastaAno, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.CantidadMesesADepreciar, dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_CantMeses, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_CantMeses_AnoActual, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.CantidadMesesADepreciar - dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_CantMeses AS RestaPorDepreciar_Meses,
                       InventarioActivosFijos.CostoTotal, 
				 dbo.tTempActivosFijos_ConsultaDepreciacion.MontoADepreciar, dbo.tTempActivosFijos_ConsultaDepreciacion.DepreciacionMensual, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_AnoActual, dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_Total, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.MontoADepreciar - dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_Total AS RestaPorDepreciar, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.NombreUsuario
FROM         dbo.Companias INNER JOIN
                      dbo.InventarioActivosFijos ON dbo.Companias.Numero = dbo.InventarioActivosFijos.Cia INNER JOIN
                      dbo.tDepartamentos ON dbo.InventarioActivosFijos.Departamento = dbo.tDepartamentos.Departamento INNER JOIN
                      dbo.TiposDeProducto ON dbo.InventarioActivosFijos.Tipo = dbo.TiposDeProducto.Tipo INNER JOIN
                      dbo.tTempActivosFijos_ConsultaDepreciacion ON dbo.InventarioActivosFijos.ClaveUnica = dbo.tTempActivosFijos_ConsultaDepreciacion.ActivoFijoID
                      

GO








IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tTempWebReport_ConsultaComprobantesContables_Partidas_tTempWebReport_ConsultaComprobantesContables]') AND parent_object_id = OBJECT_ID(N'[dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas]'))
ALTER TABLE [dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas] DROP CONSTRAINT [FK_tTempWebReport_ConsultaComprobantesContables_Partidas_tTempWebReport_ConsultaComprobantesContables]
GO


/****** Object:  Table [dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas]    Script Date: 02/02/2013 11:12:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas]') AND type in (N'U'))
DROP TABLE [dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas]
GO

/****** Object:  Table [dbo].[tTempWebReport_ConsultaComprobantesContables]    Script Date: 02/02/2013 11:12:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTempWebReport_ConsultaComprobantesContables]') AND type in (N'U'))
DROP TABLE [dbo].[tTempWebReport_ConsultaComprobantesContables]
GO


/****** Object:  Table [dbo].[tTempWebReport_ConsultaComprobantesContables]    Script Date: 02/02/2013 11:12:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tTempWebReport_ConsultaComprobantesContables](
	[NumeroAutomatico] [int] NOT NULL,
	[Numero] [smallint] NOT NULL,
	[Tipo] [nvarchar](6) NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Descripcion] [nvarchar](250) NULL,
	[NumPartidas] [smallint] NOT NULL,
	[TotalDebe] [money] NOT NULL,
	[TotalHaber] [money] NOT NULL,
	[Moneda] [int] NOT NULL,
	[MonedaOriginal] [int] NOT NULL,
	[FactorDeCambio] [money] NOT NULL,
	[ProvieneDe] [nvarchar](25) NULL,
	[Usuario]    [nvarchar](25) NOt NULL,
	[CiaContab] [int] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Contab_ConsultaComprobantesContables] PRIMARY KEY CLUSTERED 
(
	[NumeroAutomatico] ASC,
	[CiaContab] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO


/****** Object:  Table [dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas]    Script Date: 02/02/2013 11:12:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas](
	[NumeroAutomatico] [int] NOT NULL,
	[CuentaContable] [nvarchar](25) NOT NULL,
	[Partida] [smallint] NOT NULL,
	[Descripcion] [nvarchar](75) NULL,
	[Referencia] [nvarchar](20) NULL,
	[Debe] [money] NOT NULL,
	[Haber] [money] NOT NULL,
	[CiaContab] [int] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Contab_ConsultaComprobantesContables_Partidas] PRIMARY KEY CLUSTERED 
(
	[NumeroAutomatico] ASC,
	[Partida] ASC,
	[CiaContab] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas]  WITH CHECK ADD  CONSTRAINT [FK_tTempWebReport_ConsultaComprobantesContables_Partidas_tTempWebReport_ConsultaComprobantesContables] FOREIGN KEY([NumeroAutomatico], [CiaContab], [NombreUsuario])
REFERENCES [dbo].[tTempWebReport_ConsultaComprobantesContables] ([NumeroAutomatico], [CiaContab], [NombreUsuario])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[tTempWebReport_ConsultaComprobantesContables_Partidas] CHECK CONSTRAINT [FK_tTempWebReport_ConsultaComprobantesContables_Partidas_tTempWebReport_ConsultaComprobantesContables]
GO







--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.330', GetDate()) 