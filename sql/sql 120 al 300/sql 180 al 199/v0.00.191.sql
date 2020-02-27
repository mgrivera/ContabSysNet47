/*    Jueves, 30 de Marzo de 2.006   -   v0.00.191.sql 

	Creamos los objetos necesarios para el nuevo listado de nómina: 
	montos de aportes patronales 

*/ 



/****** Object:  Table [dbo].[ParametrosProcesoAportesPatronalesNomina]    Script Date: 03/30/2006 14:51:33 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[ParametrosProcesoAportesPatronalesNomina]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[ParametrosProcesoAportesPatronalesNomina]

/****** Object:  Table [dbo].[ParametrosProcesoAportesPatronalesNomina]    Script Date: 03/30/2006 14:51:57 ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ParametrosProcesoAportesPatronalesNomina](
	[ClavePrimaria] [int] IDENTITY(1,1) NOT NULL,
	[SSOAporteEmpleado] [decimal](9, 2) NULL,
	[SSOAportePatronal] [decimal](9, 2) NULL,
	[SPFAporteEmpleado] [decimal](9, 2) NULL,
	[SPFAportePatronal] [decimal](9, 2) NULL,
	[LPHAporteEmpleado] [decimal](9, 2) NULL,
	[LPHAportePatronal] [decimal](9, 2) NULL,
 CONSTRAINT [PK_ParametrosProcesoAportesPatronalesNomina] PRIMARY KEY CLUSTERED 
(
	[ClavePrimaria] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'ClavePrimaria'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'ClavePrimaria'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'ClavePrimaria'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'SSOAporteEmpleado'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'SSOAporteEmpleado'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'SSOAporteEmpleado'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'SSOAportePatronal'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'SSOAportePatronal'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'SSOAportePatronal'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'SPFAporteEmpleado'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'SPFAporteEmpleado'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'SPFAporteEmpleado'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'SPFAportePatronal'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'SPFAportePatronal'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'SPFAportePatronal'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'LPHAporteEmpleado'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'LPHAporteEmpleado'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'LPHAporteEmpleado'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'LPHAportePatronal'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'LPHAportePatronal'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina', @level2type=N'COLUMN',@level2name=N'LPHAportePatronal'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ParametrosProcesoAportesPatronalesNomina'


/****** Object:  Table [dbo].[tTempListadoMontosAportePatronalNomina]    Script Date: 03/30/2006 14:54:39 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tTempListadoMontosAportePatronalNomina]') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE [dbo].[tTempListadoMontosAportePatronalNomina]

/****** Object:  Table [dbo].[tTempListadoMontosAportePatronalNomina]    Script Date: 03/30/2006 14:54:48 ******/

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTempListadoMontosAportePatronalNomina](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[Empleado] [int] NOT NULL,
	[Nombre] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Cedula] [nvarchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FIngreso] [smalldatetime] NULL,
	[NombreCargo] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NombreDepartamento] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SueldoBasico] [money] NULL,
	[MontoAportePatronalSSO] [money] NULL,
	[MontoAporteEmpleadoSSO] [money] NULL,
	[MontoAportePatronalSPF] [money] NULL,
	[MontoAporteEmpleadoSPF] [money] NULL,
	[MontoAportePatronalLPH] [money] NULL,
	[MontoAporteEmpleadoLPH] [money] NULL,
	[NumeroUsuario] [int] NOT NULL
) ON [PRIMARY]

GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'ClaveUnica'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'ClaveUnica'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'ClaveUnica'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=False , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Empleado'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Empleado'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Empleado'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Empleado'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Empleado'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Empleado'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=False , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Nombre'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Nombre'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Nombre'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Nombre'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Nombre'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Nombre'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=False , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Cedula'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Cedula'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Cedula'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Cedula'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Cedula'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'Cedula'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=False , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'FIngreso'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'FIngreso'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'FIngreso'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'FIngreso'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'FIngreso'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'FIngreso'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=False , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NombreCargo'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NombreCargo'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NombreCargo'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NombreCargo'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NombreCargo'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NombreCargo'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=False , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NombreDepartamento'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NombreDepartamento'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NombreDepartamento'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NombreDepartamento'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NombreDepartamento'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NombreDepartamento'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'SueldoBasico'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'"Bs "#,##0.00;"Bs -"#,##0.00' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'SueldoBasico'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'SueldoBasico'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=False , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalSSO'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalSSO'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalSSO'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalSSO'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'"Bs "#,##0.00;"Bs -"#,##0.00' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalSSO'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalSSO'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=False , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoSSO'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoSSO'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoSSO'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoSSO'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'"Bs "#,##0.00;"Bs -"#,##0.00' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoSSO'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoSSO'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=False , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalSPF'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalSPF'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=2790 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalSPF'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalSPF'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'"Bs "#,##0.00;"Bs -"#,##0.00' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalSPF'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalSPF'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=False , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoSPF'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoSPF'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=3090 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoSPF'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoSPF'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'"Bs "#,##0.00;"Bs -"#,##0.00' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoSPF'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoSPF'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=False , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalLPH'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalLPH'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=2700 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalLPH'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalLPH'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'"Bs "#,##0.00;"Bs -"#,##0.00' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalLPH'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAportePatronalLPH'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=False , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoLPH'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoLPH'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=2580 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoLPH'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoLPH'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'"Bs "#,##0.00;"Bs -"#,##0.00' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoLPH'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'MontoAporteEmpleadoLPH'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnHidden', @value=False , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NumeroUsuario'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnOrder', @value=0 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NumeroUsuario'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_ColumnWidth', @value=-1 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NumeroUsuario'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DisplayControl', @value=N'109' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NumeroUsuario'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Format', @value=N'' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NumeroUsuario'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_IMEMode', @value=N'0' , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina', @level2type=N'COLUMN',@level2name=N'NumeroUsuario'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_DefaultView', @value=0x02 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Filter', @value=NULL , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_OrderBy', @value=NULL , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_OrderByOn', @value=False , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_Orientation', @value=0x00 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina'
GO
EXEC dbo.sp_addextendedproperty @name=N'MS_TableMaxRecords', @value=10000 , @level0type=N'USER',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tTempListadoMontosAportePatronalNomina'



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.191', GetDate()) 