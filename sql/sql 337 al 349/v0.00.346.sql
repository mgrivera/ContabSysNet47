/*    Sábado, 6 Julio de 2.013 	-   v0.00.346.sql 

	Agregamos la tabla de deducciones y la de salario mínimo 
	(y aprovechamos para actualizar [Bancos_VencimientoFacturas]) 
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
ALTER TABLE dbo.tMaestraRubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Parametros_Nomina_SalarioMinimo
	(
	ID int NOT NULL IDENTITY (1, 1),
	Desde date NOT NULL,
	Monto money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Parametros_Nomina_SalarioMinimo ADD CONSTRAINT
	PK_Parametros_Nomina_SalarioMinimo PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Parametros_Nomina_SalarioMinimo SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tGruposEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.tEmpleados SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.DeduccionesNomina
	(
	ID int NOT NULL IDENTITY (1, 1),
	Rubro int NOT NULL,
	Tipo nvarchar(6) NULL,
	Desde date NOT NULL,
	Cia int NULL,
	GrupoNomina int NULL,
	GrupoEmpleados int NULL,
	Empleado int NULL,
	AporteEmpleado decimal(5,2) NOT NULL,
	AporteEmpresa decimal(5,2) NOT NULL,
	Base nvarchar(10) NOT NULL,
	Tope money NULL,
	TopeBase nvarchar(10) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.DeduccionesNomina ADD CONSTRAINT
	PK_DeduccionesNomina PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.DeduccionesNomina ADD CONSTRAINT
	FK_DeduccionesNomina_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DeduccionesNomina ADD CONSTRAINT
	FK_DeduccionesNomina_tGruposEmpleados FOREIGN KEY
	(
	GrupoNomina
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo
	) ON UPDATE  no action 
	 ON DELETE  no action  
	
GO
ALTER TABLE dbo.DeduccionesNomina ADD CONSTRAINT
	FK_DeduccionesNomina_tGruposEmpleados1 FOREIGN KEY
	(
	GrupoEmpleados
	) REFERENCES dbo.tGruposEmpleados
	(
	Grupo
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DeduccionesNomina ADD CONSTRAINT
	FK_DeduccionesNomina_tEmpleados FOREIGN KEY
	(
	Empleado
	) REFERENCES dbo.tEmpleados
	(
	Empleado
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DeduccionesNomina ADD CONSTRAINT
	FK_DeduccionesNomina_tMaestraRubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.tMaestraRubros
	(
	Rubro
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DeduccionesNomina SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




/****** Object:  Table [dbo].[Bancos_VencimientoFacturas]    Script Date: 07/16/2013 11:01:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Bancos_VencimientoFacturas]') AND type in (N'U'))
DROP TABLE [dbo].[Bancos_VencimientoFacturas]
GO

/****** Object:  Table [dbo].[Bancos_VencimientoFacturas]    Script Date: 07/16/2013 11:01:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Bancos_VencimientoFacturas](
	[CxCCxPFlag] [smallint] NOT NULL,
	[CxCCxPFlag_Descripcion] [char](3) NOT NULL,
	[Moneda] [int] NOT NULL,
	[NombreMoneda] [nvarchar](50) NULL,
	[SimboloMoneda] [nvarchar](6) NULL,
	[CiaContab] [int] NOT NULL,
	[NombreCiaContab] [nvarchar](25) NULL,
	[Compania] [int] NOT NULL,
	[NombreCompania] [nvarchar](50) NOT NULL,
	[NombreCompaniaAbreviatura] [nvarchar](10) NOT NULL,
	[NumeroFactura] [nvarchar](25) NOT NULL,
	[NumeroCuota] [smallint] NOT NULL,
	[FechaEmision] [datetime] NOT NULL,
	[FechaRecepcion] [datetime] NOT NULL,
	[FechaVencimiento] [datetime] NOT NULL,
	[DiasVencimiento] [smallint] NOT NULL,
	[MontoCuota] [money] NOT NULL,
	[Iva] [money] NULL,
	[MontoCuotaDespuesIva] [money] NOT NULL,
	[RetencionSobreISLR] [money] NULL,
	[FRecepcionRetencionISLR] [date] NULL,
	[RetencionSobreISLRAplica] [bit] NULL,
	[RetencionSobreIva] [money] NULL,
	[FRecepcionRetencionIva] [date] NULL,
	[RetencionSobreIvaAplica] [bit] NULL,
	[TotalAntesAnticipo] [money] NOT NULL,
	[Anticipo] [money] NULL,
	[Total] [money] NOT NULL,
	[MontoPagado] [money] NULL,
	[SaldoPendiente] [money] NOT NULL,
	[DiasPorVencerOVencidos] [int] NULL,
	[SaldoPendiente_0] [money] NULL,
	[SaldoPendiente_1] [money] NULL,
	[SaldoPendiente_2] [money] NULL,
	[SaldoPendiente_3] [money] NULL,
	[SaldoPendiente_4] [money] NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Bancos_VencimientoFacturas] PRIMARY KEY CLUSTERED 
(
	[CxCCxPFlag] ASC,
	[Compania] ASC,
	[NumeroFactura] ASC,
	[NumeroCuota] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.346', GetDate()) 