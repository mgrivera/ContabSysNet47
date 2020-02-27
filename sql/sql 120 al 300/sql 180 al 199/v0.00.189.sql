/*    Viernes, 10 de Marzo de 2.006   -   v0.00.189.sql 

	Agregamos el item RubroDescuentoDiasAnticipoVacaciones a la tabla 
	ParametrosNomina 

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
CREATE TABLE dbo.Tmp_ParametrosNomina
	(
	LimiteProrrateoVacaciones real NULL,
	AgregarAsientosContables bit NULL,
	OrganizarPartidasDelAsiento bit NULL,
	TipoAsientoDefault nvarchar(6) NULL,
	CuentaContableNomina nvarchar(25) NULL,
	MonedaParaElAsiento int NULL,
	SumarizarPartidaAsientoContable tinyint NULL,
	RubroDescuentoDiasAnticipoVacaciones int NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.ParametrosNomina)
	 EXEC('INSERT INTO dbo.Tmp_ParametrosNomina (LimiteProrrateoVacaciones, AgregarAsientosContables, OrganizarPartidasDelAsiento, TipoAsientoDefault, CuentaContableNomina, MonedaParaElAsiento, SumarizarPartidaAsientoContable, Cia)
		SELECT LimiteProrrateoVacaciones, AgregarAsientosContables, OrganizarPartidasDelAsiento, TipoAsientoDefault, CuentaContableNomina, MonedaParaElAsiento, SumarizarPartidaAsientoContable, Cia FROM dbo.ParametrosNomina WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.ParametrosNomina
GO
EXECUTE sp_rename N'dbo.Tmp_ParametrosNomina', N'ParametrosNomina', 'OBJECT' 
GO
ALTER TABLE dbo.ParametrosNomina ADD CONSTRAINT
	PK_tParametrosNomina PRIMARY KEY NONCLUSTERED 
	(
	Cia
	) ON [PRIMARY]

GO
COMMIT

/****** Object:  View [dbo].[qFormaParametrosNomina]    Script Date: 03/10/2006 16:07:01 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaParametrosNomina]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qFormaParametrosNomina]


/****** Object:  View [dbo].[qFormaParametrosNomina]    Script Date: 03/10/2006 16:07:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qFormaParametrosNomina]
AS
SELECT     LimiteProrrateoVacaciones, AgregarAsientosContables, OrganizarPartidasDelAsiento, TipoAsientoDefault, CuentaContableNomina, 
                      MonedaParaElAsiento, SumarizarPartidaAsientoContable, RubroDescuentoDiasAnticipoVacaciones, Cia
FROM         dbo.ParametrosNomina

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[14] 4[48] 2[21] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "ParametrosNomina"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 310
            End
            DisplayFlags = 280
            TopColumn = 5
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3810
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'qFormaParametrosNomina'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'qFormaParametrosNomina'



/****** Object:  View [dbo].[qReportCartaImpuestosRetenidos]    Script Date: 03/13/2006 17:29:06 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qReportCartaImpuestosRetenidos]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qReportCartaImpuestosRetenidos]

/****** Object:  Table [dbo].[tTempCartaImpuestosRetenidos]    Script Date: 03/13/2006 17:28:06 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tTempCartaImpuestosRetenidos]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[tTempCartaImpuestosRetenidos]


/****** Object:  Table [dbo].[tTempCartaImpuestosRetenidos]    Script Date: 03/13/2006 17:28:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTempCartaImpuestosRetenidos](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[Proveedor] [int] NULL,
	[NombreProveedor] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Rif] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Nit] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DireccionProveedor] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ciudad] [nvarchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NombreCiudad] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Moneda] [int] NULL,
	[SimboloMoneda] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumeroFactura] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FechaRecepcion] [datetime] NULL,
	[MontoFactura] [money] NULL,
	[MontoSujetoARetencion] [money] NULL,
	[ImpuestoRetenidoPorc] [real] NULL,
	[ImpuestoRetenido] [money] NULL,
	[NumeroUsuario] [int] NULL,
 CONSTRAINT [PK_tTempCartaImpuestosRetenidos] PRIMARY KEY NONCLUSTERED 
(
	[ClaveUnica] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'tTempCartaImpuestosRetenidos', @level2type=N'COLUMN', @level2name=N'Nit'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'tTempCartaImpuestosRetenidos', @level2type=N'COLUMN', @level2name=N'Nit'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'tTempCartaImpuestosRetenidos', @level2type=N'COLUMN', @level2name=N'Nit'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'tTempCartaImpuestosRetenidos', @level2type=N'COLUMN', @level2name=N'DireccionProveedor'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'tTempCartaImpuestosRetenidos', @level2type=N'COLUMN', @level2name=N'DireccionProveedor'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'TABLE', @level1name=N'tTempCartaImpuestosRetenidos', @level2type=N'COLUMN', @level2name=N'DireccionProveedor'



/****** Object:  View [dbo].[qReportCartaImpuestosRetenidos]    Script Date: 03/13/2006 17:29:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.qReportCartaImpuestosRetenidos    Script Date: 28/11/00 07:01:20 p.m. *****
***** Object:  View dbo.qReportCartaImpuestosRetenidos    Script Date: 08/nov/00 9:01:17 *****
***** Object:  View dbo.qReportCartaImpuestosRetenidos    Script Date: 30/sep/00 1:10:02 ******/
CREATE VIEW [dbo].[qReportCartaImpuestosRetenidos]
AS
SELECT     ClaveUnica, Proveedor, NombreProveedor, Rif, Nit, DireccionProveedor, Ciudad, NombreCiudad, Moneda, SimboloMoneda, NumeroFactura, 
                      FechaRecepcion, MontoFactura, MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenido, NumeroUsuario
FROM         dbo.tTempCartaImpuestosRetenidos

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1 [56] 4 [18] 2))"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[40] 4) )"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 9
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tTempCartaImpuestosRetenidos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 163
               Right = 333
            End
            DisplayFlags = 280
            TopColumn = 6
         End
      End
   End
   Begin SQLPane = 
      PaneHidden = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 5055
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'qReportCartaImpuestosRetenidos'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'qReportCartaImpuestosRetenidos'

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 ,@level0type=N'USER', @level0name=N'dbo', @level1type=N'VIEW', @level1name=N'qReportCartaImpuestosRetenidos'


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.189', GetDate()) 