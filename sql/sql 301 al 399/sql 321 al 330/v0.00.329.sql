/*    Viernes, 25 de Enero de 2.013  -   v0.00.329.sql 

	Agregamos la tabla de Atributos_Asignados y modificamos la tabla Atributos 
	Además, agregamos la tabla 'temporal' y view para la nueva consulta de 
	Activos Fijos 
*/


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
ALTER TABLE dbo.InventarioActivosFijos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Atributos ADD
	Origen nvarchar(10) NULL
GO
ALTER TABLE dbo.Atributos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


Update Atributos Set Origen = 'Persona' 


ALTER TABLE dbo.Atributos Alter Column
	Origen nvarchar(10) Not NULL


BEGIN TRANSACTION
GO
CREATE TABLE dbo.AtributosAsignados
	(
	ID int NOT NULL IDENTITY (1, 1),
	AtributoID int NOT NULL,
	EntitdadAsociadaID int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.AtributosAsignados ADD CONSTRAINT
	PK_AtributosAsignados PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.AtributosAsignados ADD CONSTRAINT
	FK_AtributosAsignados_Atributos FOREIGN KEY
	(
	AtributoID
	) REFERENCES dbo.Atributos
	(
	Atributo
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.AtributosAsignados ADD CONSTRAINT
	FK_AtributosAsignados_InventarioActivosFijos FOREIGN KEY
	(
	EntitdadAsociadaID
	) REFERENCES dbo.InventarioActivosFijos
	(
	ClaveUnica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.AtributosAsignados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


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
ALTER TABLE dbo.AtributosAsignados
	DROP CONSTRAINT FK_AtributosAsignados_InventarioActivosFijos
GO
ALTER TABLE dbo.InventarioActivosFijos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.AtributosAsignados
	DROP CONSTRAINT FK_AtributosAsignados_Atributos
GO
ALTER TABLE dbo.Atributos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_AtributosAsignados
	(
	ID int NOT NULL IDENTITY (1, 1),
	AtributoID int NOT NULL,
	ActivoFijoID int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_AtributosAsignados SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_AtributosAsignados ON
GO
IF EXISTS(SELECT * FROM dbo.AtributosAsignados)
	 EXEC('INSERT INTO dbo.Tmp_AtributosAsignados (ID, AtributoID, ActivoFijoID)
		SELECT ID, AtributoID, EntitdadAsociadaID FROM dbo.AtributosAsignados WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_AtributosAsignados OFF
GO
DROP TABLE dbo.AtributosAsignados
GO
EXECUTE sp_rename N'dbo.Tmp_AtributosAsignados', N'AtributosAsignados', 'OBJECT' 
GO
ALTER TABLE dbo.AtributosAsignados ADD CONSTRAINT
	PK_AtributosAsignados PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.AtributosAsignados ADD CONSTRAINT
	FK_AtributosAsignados_Atributos FOREIGN KEY
	(
	AtributoID
	) REFERENCES dbo.Atributos
	(
	Atributo
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.AtributosAsignados ADD CONSTRAINT
	FK_AtributosAsignados_InventarioActivosFijos FOREIGN KEY
	(
	ActivoFijoID
	) REFERENCES dbo.InventarioActivosFijos
	(
	ClaveUnica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT


/* agregamos una tabla 'backup' para la reconversión monetaria */ 

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
ALTER TABLE dbo.InventarioActivosFijos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.InventarioActivosFijos_AntesReconversionMonetaria
	(
	ID int NOT NULL IDENTITY (1, 1),
	ActivoFijo_ID int NOT NULL,
	CostoTotal money NOT NULL,
	ValorResidual money NOT NULL,
	MontoADepreciar money NOT NULL,
	MontoDepreciacionMensual money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.InventarioActivosFijos_AntesReconversionMonetaria ADD CONSTRAINT
	PK_InventarioActivosFijos_AntesReconversionMonetaria PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.InventarioActivosFijos_AntesReconversionMonetaria ADD CONSTRAINT
	FK_InventarioActivosFijos_AntesReconversionMonetaria_InventarioActivosFijos FOREIGN KEY
	(
	ActivoFijo_ID
	) REFERENCES dbo.InventarioActivosFijos
	(
	ClaveUnica
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.InventarioActivosFijos_AntesReconversionMonetaria SET (LOCK_ESCALATION = TABLE)
GO
COMMIT















/****** Object:  ForeignKey [FK_tTempActivosFijos_ConsultaDepreciacion_InventarioActivosFijos]    Script Date: 01/31/2013 09:06:22 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tTempActivosFijos_ConsultaDepreciacion_InventarioActivosFijos]') AND parent_object_id = OBJECT_ID(N'[dbo].[tTempActivosFijos_ConsultaDepreciacion]'))
ALTER TABLE [dbo].[tTempActivosFijos_ConsultaDepreciacion] DROP CONSTRAINT [FK_tTempActivosFijos_ConsultaDepreciacion_InventarioActivosFijos]
GO
/****** Object:  View [dbo].[vtTempActivosFijos_ConsultaDepreciacion]    Script Date: 01/31/2013 09:06:22 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vtTempActivosFijos_ConsultaDepreciacion]'))
DROP VIEW [dbo].[vtTempActivosFijos_ConsultaDepreciacion]
GO
/****** Object:  Table [dbo].[tTempActivosFijos_ConsultaDepreciacion]    Script Date: 01/31/2013 09:06:22 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tTempActivosFijos_ConsultaDepreciacion_InventarioActivosFijos]') AND parent_object_id = OBJECT_ID(N'[dbo].[tTempActivosFijos_ConsultaDepreciacion]'))
ALTER TABLE [dbo].[tTempActivosFijos_ConsultaDepreciacion] DROP CONSTRAINT [FK_tTempActivosFijos_ConsultaDepreciacion_InventarioActivosFijos]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTempActivosFijos_ConsultaDepreciacion]') AND type in (N'U'))
DROP TABLE [dbo].[tTempActivosFijos_ConsultaDepreciacion]
GO
/****** Object:  Table [dbo].[tTempActivosFijos_ConsultaDepreciacion]    Script Date: 01/31/2013 09:06:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTempActivosFijos_ConsultaDepreciacion]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tTempActivosFijos_ConsultaDepreciacion](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ActivoFijoID] [int] NOT NULL,
	[DepreciarHastaMes] [smallint] NOT NULL,
	[DepreciarHastaAno] [smallint] NOT NULL,
	[DepreciacionMensual] [money] NOT NULL,
	[DepAcum_CantMeses] [smallint] NOT NULL,
	[DepAcum_CantMeses_AnoActual] [smallint] NOT NULL,
	[DepAcum_Total] [money] NOT NULL,
	[DepAcum_AnoActual] [money] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_tTempActivosFijos_ConsultaDepreciacion] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  View [dbo].[vtTempActivosFijos_ConsultaDepreciacion]    Script Date: 01/31/2013 09:06:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vtTempActivosFijos_ConsultaDepreciacion]'))
EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dbo].[vtTempActivosFijos_ConsultaDepreciacion]
AS
SELECT     dbo.Companias.Nombre AS NombreCiaContab, dbo.Companias.Abreviatura AS AbreviaturaCiaContab, dbo.tDepartamentos.Descripcion AS NombreDepartamento, 
                      dbo.TiposDeProducto.Descripcion AS NombreTipoProducto, dbo.InventarioActivosFijos.Producto, dbo.InventarioActivosFijos.Descripcion AS DescripcionProducto, 
                      dbo.InventarioActivosFijos.FechaCompra, dbo.InventarioActivosFijos.FechaDesincorporacion, CAST(dbo.InventarioActivosFijos.DepreciarDesdeMes AS nVarChar) 
                      + N''/'' + SUBSTRING(CAST(dbo.InventarioActivosFijos.DepreciarDesdeAno AS nVarChar), 3, 2) AS DepreciarDesde, dbo.InventarioActivosFijos.DepreciarDesdeMes, 
                      dbo.InventarioActivosFijos.DepreciarDesdeAno, CAST(dbo.tTempActivosFijos_ConsultaDepreciacion.DepreciarHastaMes AS nVarChar) 
                      + N''/'' + SUBSTRING(CAST(dbo.tTempActivosFijos_ConsultaDepreciacion.DepreciarHastaAno AS nVarChar), 3, 2) AS DepreciarHasta, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.DepreciarHastaMes, dbo.tTempActivosFijos_ConsultaDepreciacion.DepreciarHastaAno, 
                      dbo.InventarioActivosFijos.CantidadMesesADepreciar, dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_CantMeses, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_CantMeses_AnoActual, 
                      dbo.InventarioActivosFijos.CantidadMesesADepreciar - dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_CantMeses AS RestaPorDepreciar_Meses, 
                      dbo.InventarioActivosFijos.MontoADepreciar, dbo.tTempActivosFijos_ConsultaDepreciacion.DepreciacionMensual, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_AnoActual, dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_Total, 
                      dbo.InventarioActivosFijos.MontoADepreciar - dbo.tTempActivosFijos_ConsultaDepreciacion.DepAcum_Total AS RestaPorDepreciar, 
                      dbo.tTempActivosFijos_ConsultaDepreciacion.NombreUsuario
FROM         dbo.Companias INNER JOIN
                      dbo.InventarioActivosFijos ON dbo.Companias.Numero = dbo.InventarioActivosFijos.Cia INNER JOIN
                      dbo.tDepartamentos ON dbo.InventarioActivosFijos.Departamento = dbo.tDepartamentos.Departamento INNER JOIN
                      dbo.TiposDeProducto ON dbo.InventarioActivosFijos.Tipo = dbo.TiposDeProducto.Tipo INNER JOIN
                      dbo.tTempActivosFijos_ConsultaDepreciacion ON dbo.InventarioActivosFijos.ClaveUnica = dbo.tTempActivosFijos_ConsultaDepreciacion.ActivoFijoID
'
GO
/****** Object:  ForeignKey [FK_tTempActivosFijos_ConsultaDepreciacion_InventarioActivosFijos]    Script Date: 01/31/2013 09:06:22 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tTempActivosFijos_ConsultaDepreciacion_InventarioActivosFijos]') AND parent_object_id = OBJECT_ID(N'[dbo].[tTempActivosFijos_ConsultaDepreciacion]'))
ALTER TABLE [dbo].[tTempActivosFijos_ConsultaDepreciacion]  WITH CHECK ADD  CONSTRAINT [FK_tTempActivosFijos_ConsultaDepreciacion_InventarioActivosFijos] FOREIGN KEY([ActivoFijoID])
REFERENCES [dbo].[InventarioActivosFijos] ([ClaveUnica])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tTempActivosFijos_ConsultaDepreciacion_InventarioActivosFijos]') AND parent_object_id = OBJECT_ID(N'[dbo].[tTempActivosFijos_ConsultaDepreciacion]'))
ALTER TABLE [dbo].[tTempActivosFijos_ConsultaDepreciacion] CHECK CONSTRAINT [FK_tTempActivosFijos_ConsultaDepreciacion_InventarioActivosFijos]
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.329', GetDate()) 