/*    Domingo, 30 de Diciembre de 2.012  -   v0.00.326.sql 

	Agregamos una tabla 'Temp...' y su view respectivo para la nuevo 
	consulta de empleados en ContabSysNet
*/



/****** Object:  Table [dbo].[Temp_Nomina_Report_ConsultaEmpleados]    Script Date: 12/30/2012 12:00:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Temp_Nomina_Report_ConsultaEmpleados]') AND type in (N'U'))
DROP TABLE [dbo].[Temp_Nomina_Report_ConsultaEmpleados]
GO

/****** Object:  Table [dbo].[Temp_Nomina_Report_ConsultaEmpleados]    Script Date: 12/30/2012 12:00:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Temp_Nomina_Report_ConsultaEmpleados](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Empleado] [int] NOT NULL,
	[Nombre] [nvarchar](250) NOT NULL,
	[Cedula] [nvarchar](12) NOT NULL,
	[Status] [nvarchar](1) NOT NULL,
	[SituacionActual] [nvarchar](2) NOT NULL,
	[FechaNacimiento] [date] NOT NULL,
	[Departamento] [int] NOT NULL,
	[Cargo] [int] NOT NULL,
	[FechaIngreso] [date] NOT NULL,
	[SueldoBasico] [money] NULL,
	[FechaRetiro] [date] NULL,
	[Cia] [int] NOT NULL,
	[Usuario] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_Temp_Nomina_Report_ConsultaEmpleados] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO




/****** Object:  View [dbo].[vwTemp_Nomina_Report_ConsultaEmpleados]    Script Date: 12/30/2012 12:00:41 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vwTemp_Nomina_Report_ConsultaEmpleados]'))
DROP VIEW [dbo].[vwTemp_Nomina_Report_ConsultaEmpleados]
GO


/****** Object:  View [dbo].[vwTemp_Nomina_Report_ConsultaEmpleados]    Script Date: 12/30/2012 12:00:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTemp_Nomina_Report_ConsultaEmpleados]
AS
SELECT     dbo.Temp_Nomina_Report_ConsultaEmpleados.Empleado, dbo.Temp_Nomina_Report_ConsultaEmpleados.Nombre, 
                      dbo.Temp_Nomina_Report_ConsultaEmpleados.Cedula, CASE Status WHEN 'A' THEN 'Activo' WHEN 'S' THEN 'Suspendido' ELSE 'Indefinido' END AS NombreStatus, 
                      CASE SituacionActual WHEN 'NO' THEN 'Normal' WHEN 'VA' THEN 'Vacacionesl' WHEN 'RE' THEN 'Vacacionesl' WHEN 'LI' THEN 'Liquidado' ELSE 'Indefinido' END AS
                       NombreSituacionActual, dbo.Temp_Nomina_Report_ConsultaEmpleados.FechaNacimiento, dbo.tDepartamentos.Descripcion AS NombreDepartamento, 
                      dbo.tCargos.Descripcion AS NombreCargo, dbo.Temp_Nomina_Report_ConsultaEmpleados.FechaIngreso, 
                      dbo.Temp_Nomina_Report_ConsultaEmpleados.SueldoBasico, dbo.Temp_Nomina_Report_ConsultaEmpleados.FechaRetiro, dbo.Companias.Nombre AS NombreCia, 
                      dbo.Companias.Abreviatura AS AbreviaturaCia, dbo.Temp_Nomina_Report_ConsultaEmpleados.Usuario
FROM         dbo.Temp_Nomina_Report_ConsultaEmpleados LEFT OUTER JOIN
                      dbo.Companias ON dbo.Temp_Nomina_Report_ConsultaEmpleados.Cia = dbo.Companias.Numero LEFT OUTER JOIN
                      dbo.tCargos ON dbo.Temp_Nomina_Report_ConsultaEmpleados.Cargo = dbo.tCargos.Cargo LEFT OUTER JOIN
                      dbo.tDepartamentos ON dbo.Temp_Nomina_Report_ConsultaEmpleados.Departamento = dbo.tDepartamentos.Departamento

GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.326', GetDate()) 