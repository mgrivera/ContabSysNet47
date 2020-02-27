/*    Lunes, 17 de Julio de 2.006   -   v0.00.197.sql 

	Modificamos levemente la tabla y view: tTempListadoNomina y qListadoNomina, para agregar 
	la versión de "análisis" del listado de nómina 

*/ 


IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tTempListadoNomina]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[tTempListadoNomina]

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qListadoNomina]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qListadoNomina]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tTempListadoNomina](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[GrupoNomina] [int] NULL,
	[FechaNomina] [smalldatetime] NULL,
	[FechaNomina2] [smalldatetime] NULL,
	[Departamento] [int] NULL,
	[NombreDepartamento] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Empleado] [int] NULL,
	[NombreEmpleado] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Cedula] [nvarchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FechaIngreso] [datetime] NULL,
	[Rubro] [int] NULL,
	[TipoRubro] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NombreRubro] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Asignacion] [money] NULL,
	[Deduccion] [money] NULL,
	[Total] [money] NULL,
	[VacFraccionFlag] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FechaEjecucion] [datetime] NULL,
	[NumeroUsuario] [int] NULL,
 CONSTRAINT [PK_tTempListadoNomina] PRIMARY KEY NONCLUSTERED 
(
	[ClaveUnica] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoNomina', @level2type=N'COLUMN',@level2name=N'FechaNomina2'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoNomina', @level2type=N'COLUMN',@level2name=N'FechaNomina2'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoNomina', @level2type=N'COLUMN',@level2name=N'FechaNomina2'



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qListadoNomina]
AS
SELECT     dbo.tTempListadoNomina.ClaveUnica, dbo.tTempListadoNomina.GrupoNomina, dbo.tTempListadoNomina.FechaNomina, 
                      dbo.tTempListadoNomina.FechaNomina2, dbo.tTempListadoNomina.Departamento, dbo.tTempListadoNomina.NombreDepartamento, 
                      dbo.tTempListadoNomina.Empleado, dbo.tTempListadoNomina.NombreEmpleado, dbo.tTempListadoNomina.Rubro, 
                      dbo.tMaestraRubros.NombreCortoRubro, dbo.tMaestraRubros.Descripcion AS NombreRubroMaestra, dbo.tTempListadoNomina.TipoRubro, 
                      dbo.tTempListadoNomina.NombreRubro, dbo.tTempListadoNomina.Asignacion, dbo.tTempListadoNomina.Deduccion, dbo.tTempListadoNomina.Total, 
                      dbo.tTempListadoNomina.FechaEjecucion, dbo.tTempListadoNomina.NumeroUsuario, dbo.tTempListadoNomina.Cedula, 
                      dbo.tTempListadoNomina.FechaIngreso, dbo.tTempListadoNomina.VacFraccionFlag
FROM         dbo.tTempListadoNomina INNER JOIN
                      dbo.tMaestraRubros ON dbo.tTempListadoNomina.Rubro = dbo.tMaestraRubros.Rubro

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qListadoNomina'
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
         Configuration = "(H (1[53] 4) )"
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
         Begin Table = "tTempListadoNomina"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 292
               Right = 253
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tMaestraRubros"
            Begin Extent = 
               Top = 6
               Left = 291
               Bottom = 121
               Right = 487
            End
            DisplayFlags = 280
            TopColumn = 0
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
         Column = 3630
         Alias = 3435
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
' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qListadoNomina'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qListadoNomina'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qListadoNomina'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qListadoNomina'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_OrderByOn', @value=False , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qListadoNomina'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qListadoNomina'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qListadoNomina'


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.197', GetDate()) 