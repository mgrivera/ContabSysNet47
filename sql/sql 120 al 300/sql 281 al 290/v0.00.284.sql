/*    Jueves, 22 de Septiembre de 2.011  -   v0.00.284.sql 

*/


/****** Object:  View [dbo].[qFormaAsientosSubForm]    Script Date: 09/22/2011 11:40:33 ******/
DROP VIEW [dbo].[qFormaAsientosSubForm]
GO
/****** Object:  View [dbo].[qFormaAsientosSubFormConsulta]    Script Date: 09/22/2011 11:40:33 ******/
DROP VIEW [dbo].[qFormaAsientosSubFormConsulta]
GO
/****** Object:  View [dbo].[qListadoAsientos]    Script Date: 09/22/2011 11:40:33 ******/
DROP VIEW [dbo].[qListadoAsientos]
GO
/****** Object:  View [dbo].[qListadoMayorGeneral]    Script Date: 09/22/2011 11:40:33 ******/
DROP VIEW [dbo].[qListadoMayorGeneral]
GO
/****** Object:  View [dbo].[qFormaAsientos]    Script Date: 09/22/2011 11:40:33 ******/
DROP VIEW [dbo].[qFormaAsientos]
GO
/****** Object:  View [dbo].[qFormaAsientosConsulta]    Script Date: 09/22/2011 11:40:33 ******/
DROP VIEW [dbo].[qFormaAsientosConsulta]
GO
/****** Object:  Table [dbo].[dAsientosTemp]    Script Date: 09/22/2011 11:40:33 ******/
DROP TABLE [dbo].[dAsientosTemp]
GO
/****** Object:  Table [dbo].[dAsientosTemp]    Script Date: 09/22/2011 11:40:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dAsientosTemp](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[NumeroAutomatico] [int] NOT NULL,
	[Partida] [smallint] NOT NULL,
	[Cuenta] [nvarchar](25) NOT NULL,
	[Descripcion] [nvarchar](50) NULL,
	[Referencia] [nvarchar](20) NULL,
	[Debe] [money] NOT NULL,
	[Haber] [money] NOT NULL,
	[CentroCosto] [int] NULL,
	[Cia] [int] NOT NULL,
	[NumeroUsuario] [int] NULL,
 CONSTRAINT [PK_dAsientosTemp] PRIMARY KEY CLUSTERED 
(
	[ClaveUnica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dAsientosTemp] ON [dbo].[dAsientosTemp] 
(
	[NumeroUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  View [dbo].[qFormaAsientosConsulta]    Script Date: 09/22/2011 11:40:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qFormaAsientosConsulta]
AS
SELECT     dbo.Asientos.NumeroAutomatico, dbo.Asientos.Numero, dbo.Asientos.Mes, dbo.Asientos.MesFiscal, dbo.Asientos.AnoFiscal, dbo.Asientos.Ano, 
                      dbo.Asientos.Tipo, dbo.Asientos.Fecha, dbo.Asientos.Descripcion, dbo.Asientos.Ingreso, dbo.Asientos.UltAct, dbo.Asientos.Moneda, 
                      dbo.Asientos.MonedaOriginal, dbo.Monedas.Simbolo AS SimboloMonedaOriginal, dbo.Asientos.ConvertirFlag, dbo.Asientos.FactorDeCambio, 
                      dbo.Asientos.CopiableFlag, dbo.Asientos.Usuario, dbo.Asientos.Cia, dbo.Asientos.ProvieneDe, dbo.Asientos.AsientoTipoCierreAnualFlag
FROM         dbo.Asientos LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Asientos.MonedaOriginal = dbo.Monedas.Moneda
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[20] 4[57] 2[16] 3) )"
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
         Begin Table = "Asientos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 254
               Right = 251
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Monedas"
            Begin Extent = 
               Top = 6
               Left = 289
               Bottom = 121
               Right = 441
            End
            DisplayFlags = 280
            TopColumn = 0
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
         Column = 3555
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qFormaAsientosConsulta'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qFormaAsientosConsulta'
GO
/****** Object:  View [dbo].[qFormaAsientos]    Script Date: 09/22/2011 11:40:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qFormaAsientos]
AS
SELECT     dbo.Asientos.NumeroAutomatico, dbo.Asientos.Numero, dbo.Asientos.Mes, dbo.Asientos.MesFiscal, dbo.Asientos.AnoFiscal, dbo.Asientos.Ano, 
                      dbo.Asientos.Tipo, dbo.Asientos.Fecha, dbo.Asientos.Descripcion, dbo.Asientos.Ingreso, dbo.Asientos.UltAct, dbo.Asientos.Moneda, 
                      dbo.Asientos.MonedaOriginal, dbo.Monedas.Simbolo AS SimboloMonedaOriginal, dbo.Asientos.ConvertirFlag, dbo.Asientos.FactorDeCambio, 
                      dbo.Asientos.CopiableFlag, dbo.Asientos.Usuario, dbo.Asientos.Cia, dbo.Asientos.ProvieneDe, dbo.Asientos.AsientoTipoCierreAnualFlag
FROM         dbo.Asientos LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Asientos.MonedaOriginal = dbo.Monedas.Moneda
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[49] 2[5] 3) )"
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
         Begin Table = "Asientos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 182
               Right = 251
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Monedas"
            Begin Extent = 
               Top = 6
               Left = 289
               Bottom = 121
               Right = 441
            End
            DisplayFlags = 280
            TopColumn = 0
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
         Column = 2895
         Alias = 1845
         Table = 2985
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qFormaAsientos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qFormaAsientos'
GO
/****** Object:  View [dbo].[qListadoMayorGeneral]    Script Date: 09/22/2011 11:40:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.qListadoMayorGeneral    Script Date: 31/12/00 10:25:55 a.m. *****
***** Object:  View dbo.qListadoMayorGeneral    Script Date: 28/11/00 07:01:23 p.m. *****
***** Object:  View dbo.qListadoMayorGeneral    Script Date: 08/nov/00 9:01:18 ******/
CREATE VIEW [dbo].[qListadoMayorGeneral]
AS
SELECT     dbo.Asientos.Moneda, dbo.Monedas.Descripcion AS NombreMoneda, dbo.Asientos.MonedaOriginal, 
                      MonedasOriginal.Descripcion AS NombreMonedaOriginal, dbo.Asientos.Numero, dbo.Asientos.Mes, dbo.Asientos.Ano, dbo.Asientos.MesFiscal, 
                      dbo.Asientos.AnoFiscal, dbo.Asientos.Fecha, CONVERT(Char(4), dbo.Asientos.Ano) + { fn REPLACE(STR(dbo.Asientos.Mes, 2), ' ', '0') } AS AnoMes, 
                      dbo.dAsientos.Partida, dbo.dAsientos.Cuenta, dbo.dAsientos.Descripcion, dbo.dAsientos.Referencia, dbo.dAsientos.Debe, dbo.dAsientos.Haber, 
                      dbo.Asientos.FactorDeCambio, dbo.dAsientos.CentroCosto, dbo.dAsientos.Cia, dbo.Asientos.AsientoTipoCierreAnualFlag
FROM         dbo.dAsientos INNER JOIN
                      dbo.Asientos ON dbo.dAsientos.NumeroAutomatico = dbo.Asientos.NumeroAutomatico LEFT OUTER JOIN
                      dbo.Monedas AS MonedasOriginal ON dbo.Asientos.MonedaOriginal = MonedasOriginal.Moneda LEFT OUTER JOIN
                      dbo.Monedas ON dbo.Asientos.Moneda = dbo.Monedas.Moneda
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[17] 4[56] 2[9] 3) )"
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
         Begin Table = "dAsientos"
            Begin Extent = 
               Top = 48
               Left = 39
               Bottom = 334
               Right = 211
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Asientos"
            Begin Extent = 
               Top = 28
               Left = 328
               Bottom = 345
               Right = 541
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "MonedasOriginal"
            Begin Extent = 
               Top = 198
               Left = 689
               Bottom = 313
               Right = 841
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Monedas"
            Begin Extent = 
               Top = 25
               Left = 696
               Bottom = 140
               Right = 848
            End
            DisplayFlags = 280
            TopColumn = 0
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
         Column = 4185
         Alias = 4035
         Table = 3855
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qListadoMayorGeneral'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qListadoMayorGeneral'
GO
/****** Object:  View [dbo].[qListadoAsientos]    Script Date: 09/22/2011 11:40:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[qListadoAsientos]
AS
SELECT     dbo.dAsientos.Partida, dbo.dAsientos.Cuenta, dbo.dAsientos.Descripcion AS DescripcionPartida, dbo.dAsientos.Referencia, dbo.dAsientos.Debe, 
                      dbo.dAsientos.Haber, dbo.dAsientos.NumeroAutomatico, dbo.Asientos.Numero, dbo.Asientos.Mes, dbo.Asientos.Ano, dbo.Asientos.Fecha, 
                      dbo.Asientos.Moneda, dbo.Asientos.MonedaOriginal, dbo.Asientos.ConvertirFlag, dbo.Asientos.FactorDeCambio, dbo.Asientos.MesFiscal, 
                      dbo.Asientos.AnoFiscal, dbo.dAsientos.Cia, dbo.Asientos.Tipo, dbo.Asientos.Descripcion, dbo.Asientos.Ingreso, dbo.Asientos.UltAct, 
                      dbo.Asientos.CopiableFlag, dbo.Asientos.ProvieneDe, dbo.dAsientos.CentroCosto, dbo.Asientos.Usuario
FROM         dbo.dAsientos INNER JOIN
                      dbo.Asientos ON dbo.dAsientos.NumeroAutomatico = dbo.Asientos.NumeroAutomatico
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[5] 4[56] 2[21] 3) )"
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
         Begin Table = "dAsientos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 210
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Asientos"
            Begin Extent = 
               Top = 6
               Left = 248
               Bottom = 121
               Right = 461
            End
            DisplayFlags = 280
            TopColumn = 0
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
         Column = 4155
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qListadoAsientos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qListadoAsientos'
GO
/****** Object:  View [dbo].[qFormaAsientosSubFormConsulta]    Script Date: 09/22/2011 11:40:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.qFormaAsientosSubFormConsulta    Script Date: 31/12/00 10:25:56 a.m. *****
***** Object:  View dbo.qFormaAsientosSubFormConsulta    Script Date: 28/11/00 07:01:21 p.m. *****
***** Object:  View dbo.qFormaAsientosSubFormConsulta    Script Date: 08/nov/00 9:01:17 ******/
CREATE VIEW [dbo].[qFormaAsientosSubFormConsulta]
AS
SELECT     dbo.dAsientos.NumeroAutomatico, dbo.dAsientos.Partida, dbo.dAsientos.Cuenta, dbo.dAsientos.Descripcion, dbo.dAsientos.Referencia, 
                      dbo.dAsientos.Debe, dbo.dAsientos.Haber, dbo.CuentasContables.Descripcion AS NombreCuentaContable, dbo.CuentasContables.CuentaEditada, 
                      dbo.CentrosCosto.DescripcionCorta AS NombreCortoCentroCosto, dbo.dAsientos.CentroCosto, dbo.dAsientos.Cia
FROM         dbo.dAsientos LEFT OUTER JOIN
                      dbo.CentrosCosto ON dbo.dAsientos.CentroCosto = dbo.CentrosCosto.CentroCosto LEFT OUTER JOIN
                      dbo.CuentasContables ON dbo.dAsientos.Cuenta = dbo.CuentasContables.Cuenta AND dbo.dAsientos.Cia = dbo.CuentasContables.Cia
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[48] 2[4] 3) )"
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
         Begin Table = "dAsientos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 188
               Right = 210
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "CentrosCosto"
            Begin Extent = 
               Top = 6
               Left = 248
               Bottom = 106
               Right = 410
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CuentasContables"
            Begin Extent = 
               Top = 33
               Left = 518
               Bottom = 148
               Right = 705
            End
            DisplayFlags = 280
            TopColumn = 0
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
         Column = 3600
         Alias = 900
         Table = 2985
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qFormaAsientosSubFormConsulta'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qFormaAsientosSubFormConsulta'
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion
Insert Into tVersion(VersionActual, Fecha) Values('v0.00.284', GetDate()) 