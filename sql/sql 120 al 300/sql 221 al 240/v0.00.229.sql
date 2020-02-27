/*    Miércoles, 3 de diciembre de 2.008  -   v0.00.229.sql 

	Hacemos algunos cambios para mejorar la consulta de disponibilidad bancaria 

*/ 

DROP TABLE [dbo].[tTempWebReport_DisponibilidadBancos]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tTempWebReport_DisponibilidadBancos](
	[CuentaInterna] [int] NOT NULL,
	[NombreCiaContab] [nvarchar](25) NOT NULL,
	[NombreBanco] [nvarchar](50) NOT NULL,
	[CuentaBancaria] [nvarchar](50) NOT NULL,
	[NombreMoneda] [nvarchar](50) NOT NULL,
	[SimboloMoneda] [nvarchar](6) NOT NULL,
	[FechaSaldoAnterior] [smalldatetime] NOT NULL,
	[SaldoAnterior] [money] NOT NULL,
	[Debitos] [money] NOT NULL,
	[Creditos] [money] NOT NULL,
	[SaldoActual] [money] NOT NULL,
	[MontoRestringido] [money] NOT NULL,
	[SaldoActual2] [money] NOT NULL,
	[MontoChequesNoEntregados] [money] NOT NULL,
	[SaldoActual3] [money] NOT NULL,
	[FechaSaldoActual] [smalldatetime] NOT NULL,
	[CiaContab] [int] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_tTempWebReport_DisponibilidadBancos] PRIMARY KEY CLUSTERED 
(
	[CuentaInterna] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad](
	[CiaContab] [int] NOT NULL,
	[CuentaBancaria] [int] NOT NULL,
	[Fecha] [datetime] NOT NULL,
	[Transaccion] [nvarchar](20) NOT NULL,
	[ProvClte] [int] NULL,
	[Beneficiario] [nvarchar](50) NULL,
	[Concepto] [nvarchar](250) NULL,
	[Monto] [money] NOT NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad] PRIMARY KEY CLUSTERED 
(
	[CiaContab] ASC,
	[CuentaBancaria] ASC,
	[Transaccion] ASC,
	[NombreUsuario] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.229', GetDate()) 