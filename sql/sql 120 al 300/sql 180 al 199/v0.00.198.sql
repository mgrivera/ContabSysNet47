/*    Lunes, 17 de Julio de 2.006   -   v0.00.198.sql 

	Agregamos el item Categoría a la tabla tPrestamos 

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
CREATE TABLE dbo.Tmp_tPrestamos
	(
	Numero int NOT NULL,
	Categoria char(3) NULL,
	Tipo int NOT NULL,
	Empleado int NOT NULL,
	Rubro int NOT NULL,
	Periodicidad nvarchar(2) NOT NULL,
	NumeroDeCuotas smallint NOT NULL,
	FechaPrimeraCuota smalldatetime NOT NULL,
	Situacion nvarchar(2) NOT NULL,
	FechaSolicitado datetime NOT NULL,
	FechaOtorgado datetime NULL,
	FechaCancelado datetime NULL,
	FechaAnulado datetime NULL,
	MontoSolicitado money NOT NULL,
	PorcIntereses money NULL,
	TotalAPagar money NOT NULL,
	MontoCancelado money NULL,
	Saldo money NULL,
	ImprimirRecibo bit NULL,
	FechaNominaActual smalldatetime NULL,
	MontoCuotasOrdinarias money NULL,
	MontoCuotasEspeciales money NULL,
	NumeroCuotasEspeciales smallint NULL,
	RubroIntereses int NULL,
	MontoCuota money NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.tPrestamos)
	 EXEC('INSERT INTO dbo.Tmp_tPrestamos (Numero, Tipo, Empleado, Rubro, Periodicidad, NumeroDeCuotas, FechaPrimeraCuota, Situacion, FechaSolicitado, FechaOtorgado, FechaCancelado, FechaAnulado, MontoSolicitado, PorcIntereses, TotalAPagar, MontoCancelado, Saldo, ImprimirRecibo, FechaNominaActual, MontoCuotasOrdinarias, MontoCuotasEspeciales, NumeroCuotasEspeciales, RubroIntereses, MontoCuota, Cia)
		SELECT Numero, Tipo, Empleado, Rubro, Periodicidad, NumeroDeCuotas, FechaPrimeraCuota, Situacion, FechaSolicitado, FechaOtorgado, FechaCancelado, FechaAnulado, MontoSolicitado, PorcIntereses, TotalAPagar, MontoCancelado, Saldo, ImprimirRecibo, FechaNominaActual, MontoCuotasOrdinarias, MontoCuotasEspeciales, NumeroCuotasEspeciales, RubroIntereses, MontoCuota, Cia FROM dbo.tPrestamos WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.tPrestamos
GO
EXECUTE sp_rename N'dbo.Tmp_tPrestamos', N'tPrestamos', 'OBJECT' 
GO
ALTER TABLE dbo.tPrestamos ADD CONSTRAINT
	PK_tPrestamos PRIMARY KEY NONCLUSTERED 
	(
	Numero
	) ON [PRIMARY]

GO
COMMIT

Update tPrestamos Set Categoria = 'PRT' 

Alter Table tPrestamos Alter Column Categoria char(3) Not NULL



IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaPrestamosConsulta]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qFormaPrestamosConsulta]

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qListadoSubReportRecibosDePago]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qListadoSubReportRecibosDePago]

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[qFormaPrestamos]') AND OBJECTPROPERTY(id, N'IsView') = 1)
DROP VIEW [dbo].[qFormaPrestamos]



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[qFormaPrestamos]
AS
SELECT     Numero, Categoria, Tipo, Empleado, Rubro, FechaPrimeraCuota, Periodicidad, NumeroDeCuotas, Situacion, FechaSolicitado, FechaOtorgado, 
                      FechaCancelado, FechaAnulado, MontoSolicitado, PorcIntereses, TotalAPagar, Saldo, MontoCancelado, ImprimirRecibo, FechaNominaActual, 
                      MontoCuotasOrdinarias, MontoCuotasEspeciales, NumeroCuotasEspeciales, RubroIntereses, MontoCuota, Cia
FROM         dbo.tPrestamos

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
      ActivePaneConfig = 8
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tPrestamos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 3000
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
' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qFormaPrestamos'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qFormaPrestamos'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qFormaPrestamos'


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.qFormaPrestamosConsulta    Script Date: 15-May-01 12:13:56 PM *****
***** Object:  View dbo.qFormaPrestamosConsulta    Script Date: 28/11/00 07:01:17 p.m. *****

*/
CREATE VIEW [dbo].[qFormaPrestamosConsulta]
AS
SELECT     dbo.tPrestamos.Numero, CASE dbo.tPrestamos.Categoria WHEN 'PRT' THEN 'Préstamo' WHEN 'FNC' THEN 'Financiamiento' END AS NombreCategoria,
                       dbo.tPrestamos.Tipo, dbo.tTiposDePrestamo.Descripcion AS NombreTipo, dbo.tPrestamos.Empleado, dbo.tEmpleados.Nombre AS NombreEmpleado, 
                      dbo.tPrestamos.Rubro, dbo.tMaestraRubros.NombreCortoRubro AS NombreRubro, dbo.tPrestamos.RubroIntereses, 
                      tMaestraRubros_1.NombreCortoRubro AS NombreRubroIntereses, dbo.tPrestamos.FechaPrimeraCuota, dbo.tPrestamos.Periodicidad, 
                      dbo.tPrestamos.NumeroDeCuotas, dbo.tPrestamos.MontoCuota, dbo.tPrestamos.Situacion, dbo.tPrestamos.FechaSolicitado, 
                      dbo.tPrestamos.FechaOtorgado, dbo.tPrestamos.FechaCancelado, dbo.tPrestamos.FechaAnulado, dbo.tPrestamos.MontoSolicitado, 
                      dbo.tPrestamos.MontoCuotasOrdinarias, dbo.tPrestamos.MontoCuotasEspeciales, dbo.tPrestamos.NumeroCuotasEspeciales, 
                      dbo.tPrestamos.PorcIntereses, dbo.tPrestamos.TotalAPagar, dbo.tPrestamos.MontoCancelado, dbo.tPrestamos.Saldo, dbo.tPrestamos.Cia
FROM         dbo.tPrestamos LEFT OUTER JOIN
                      dbo.tTiposDePrestamo ON dbo.tPrestamos.Tipo = dbo.tTiposDePrestamo.Tipo LEFT OUTER JOIN
                      dbo.tEmpleados ON dbo.tPrestamos.Empleado = dbo.tEmpleados.Empleado LEFT OUTER JOIN
                      dbo.tMaestraRubros ON dbo.tPrestamos.Rubro = dbo.tMaestraRubros.Rubro LEFT OUTER JOIN
                      dbo.tMaestraRubros tMaestraRubros_1 ON dbo.tPrestamos.RubroIntereses = tMaestraRubros_1.Rubro

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
         Configuration = "(H (1[18] 4[4] 2) )"
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
      ActivePaneConfig = 8
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tPrestamos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 121
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tTiposDePrestamo"
            Begin Extent = 
               Top = 6
               Left = 277
               Bottom = 91
               Right = 429
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tEmpleados"
            Begin Extent = 
               Top = 96
               Left = 277
               Bottom = 211
               Right = 458
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tMaestraRubros"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 241
               Right = 234
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tMaestraRubros_1"
            Begin Extent = 
               Top = 216
               Left = 272
               Bottom = 331
               Right = 468
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
        ' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qFormaPrestamosConsulta'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N' Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qFormaPrestamosConsulta'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qFormaPrestamosConsulta'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qFormaPrestamosConsulta'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View dbo.qListadoSubReportRecibosDePago    Script Date: 15-May-01 12:13:57 PM *****
***** Object:  View dbo.qListadoSubReportRecibosDePago    Script Date: 28/11/00 07:01:19 p.m. *****



*/
CREATE VIEW [dbo].[qListadoSubReportRecibosDePago]
AS
SELECT     CASE Categoria WHEN 'PRT' THEN 'Préstamos' WHEN 'FNC' THEN 'Financiamientos' END AS NombreCategoria, dbo.tPrestamos.Empleado, 
                      dbo.tPrestamos.Numero, dbo.tPrestamos.TotalAPagar, dbo.tCuotasPrestamos.Monto AS CuotaPagada, 
                      dbo.tPrestamos.MontoCancelado AS TotalPagado, dbo.tPrestamos.Saldo
FROM         dbo.tPrestamos INNER JOIN
                      dbo.tCuotasPrestamos ON dbo.tPrestamos.Numero = dbo.tCuotasPrestamos.Prestamo AND 
                      dbo.tPrestamos.FechaNominaActual = dbo.tCuotasPrestamos.FechaCuota AND dbo.tPrestamos.Cia = dbo.tCuotasPrestamos.Cia
WHERE     (dbo.tPrestamos.ImprimirRecibo = 1)

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
         Configuration = "(H (1[23] 4[19] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1[44] 4) )"
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
      ActivePaneConfig = 8
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tPrestamos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 243
               Right = 239
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tCuotasPrestamos"
            Begin Extent = 
               Top = 22
               Left = 463
               Bottom = 252
               Right = 653
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
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
' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qListadoSubReportRecibosDePago'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qListadoSubReportRecibosDePago'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'qListadoSubReportRecibosDePago'




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.198', GetDate()) 