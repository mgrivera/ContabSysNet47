/*    Martes, 17 de Agosto de 2.010    -   v0.00.267.sql 

	Agregamos la tabla necesaria para obtener los recibos de pago 
	desde el mail merge de microsoft word 

*/


/****** Object:  View [dbo].[qListadoRecibosPago]    Script Date: 08/17/2010 16:45:42 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[qListadoRecibosPago]'))
DROP VIEW [dbo].[qListadoRecibosPago]
GO

/****** Object:  View [dbo].[qListadoRecibosPago]    Script Date: 08/17/2010 16:45:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[qListadoRecibosPago]
AS
SELECT     ClaveUnica, FechaNomina, Empleado, NombreEmpleado, SueldoPromedio, SueldoBasico, Cedula, Departamento, NombreDepartamento, Banco, 
                      NombreBanco, CuentaBancaria, Rubro, NombreRubro, Tipo, Monto, Asignacion, Deduccion, NumeroUsuario, Cia
FROM         dbo.tTempListadoRecibosPago


GO



/****** Object:  Table [dbo].[tTempListadoRecibosPago_MicrosoftWord]    Script Date: 08/17/2010 16:46:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tTempListadoRecibosPago_MicrosoftWord]') AND type in (N'U'))
DROP TABLE [dbo].[tTempListadoRecibosPago_MicrosoftWord]
GO


/****** Object:  Table [dbo].[tTempListadoRecibosPago_MicrosoftWord]    Script Date: 08/17/2010 16:46:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tTempListadoRecibosPago_MicrosoftWord](
	[ClaveUnica] [int] IDENTITY(1,1) NOT NULL,
	[NombreCompania] [nvarchar](50) NOT NULL,
	[FechaNomina] [nvarchar](15) NOT NULL,
	[EmpleadoNombre] [nvarchar](250) NOT NULL,
	[EmpleadoCedula] [nvarchar](12) NOT NULL,
	[EmpleadoDepartamento] [nvarchar](30) NOT NULL,
	[EmpleadoCuentaBancaria] [nvarchar](50) NOT NULL,
	[EmpleadoBanco] [nvarchar](50) NOT NULL,
	[EmpleadoSueldoPromedio] [nvarchar](20) NOT NULL,
	[EmpleadoSueldoBasico] [nvarchar](20) NOT NULL,
	[TotalAsignaciones] [nvarchar](20) NOT NULL,
	[TotalDeducciones] [nvarchar](20) NOT NULL,
	[NetoACobrar] [nvarchar](20) NOT NULL,
	[RubroDesc1] [nvarchar](250) NULL,
	[RubroAsignacion1] [nvarchar](20) NULL,
	[RubroDeduccion1] [nvarchar](20) NULL,
	[RubroDesc2] [nvarchar](250) NULL,
	[RubroAsignacion2] [nvarchar](20) NULL,
	[RubroDeduccion2] [nvarchar](20) NULL,
	[RubroDesc3] [nvarchar](250) NULL,
	[RubroAsignacion3] [nvarchar](20) NULL,
	[RubroDeduccion3] [nvarchar](20) NULL,
	[RubroDesc4] [nvarchar](250) NULL,
	[RubroAsignacion4] [nvarchar](20) NULL,
	[RubroDeduccion4] [nvarchar](20) NULL,
	[RubroDesc5] [nvarchar](250) NULL,
	[RubroAsignacion5] [nvarchar](20) NULL,
	[RubroDeduccion5] [nvarchar](20) NULL,
	[RubroDesc6] [nvarchar](250) NULL,
	[RubroAsignacion6] [nvarchar](20) NULL,
	[RubroDeduccion6] [nvarchar](20) NULL,
	[RubroDesc7] [nvarchar](250) NULL,
	[RubroAsignacion7] [nvarchar](20) NULL,
	[RubroDeduccion7] [nvarchar](20) NULL,
	[RubroDesc8] [nvarchar](250) NULL,
	[RubroAsignacion8] [nvarchar](20) NULL,
	[RubroDeduccion8] [nvarchar](20) NULL,
	[RubroDesc9] [nvarchar](250) NULL,
	[RubroAsignacion9] [nvarchar](20) NULL,
	[RubroDeduccion9] [nvarchar](20) NULL,
	[RubroDesc10] [nvarchar](250) NULL,
	[RubroAsignacion10] [nvarchar](20) NULL,
	[RubroDeduccion10] [nvarchar](20) NULL,
	[RubroDesc11] [nvarchar](250) NULL,
	[RubroAsignacion11] [nvarchar](20) NULL,
	[RubroDeduccion11] [nvarchar](20) NULL,
	[RubroDesc12] [nvarchar](250) NULL,
	[RubroAsignacion12] [nvarchar](20) NULL,
	[RubroDeduccion12] [nvarchar](20) NULL,
	[RubroDesc13] [nvarchar](250) NULL,
	[RubroAsignacion13] [nvarchar](20) NULL,
	[RubroDeduccion13] [nvarchar](20) NULL,
	[RubroDesc14] [nvarchar](250) NULL,
	[RubroAsignacion14] [nvarchar](20) NULL,
	[RubroDeduccion14] [nvarchar](20) NULL,
	[RubroDesc15] [nvarchar](250) NULL,
	[RubroAsignacion15] [nvarchar](20) NULL,
	[RubroDeduccion15] [nvarchar](20) NULL,
	[RubroDesc16] [nvarchar](250) NULL,
	[RubroAsignacion16] [nvarchar](20) NULL,
	[RubroDeduccion16] [nvarchar](20) NULL,
 CONSTRAINT [PK_tTempListadoRecibosPago_MicrosoftWord] PRIMARY KEY CLUSTERED 
(
	[ClaveUnica] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.267', GetDate()) 