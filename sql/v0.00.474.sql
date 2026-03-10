/*    
	  Jueves, 10 de Marzo de 2.026  -   v0.00.474.sql 
	  
	  Aumentamos el tamaño de la descripción de la cuenta contable en la tabla 'temp' 
	  usada para obtener el balance de comprobación 

*/


ALTER TABLE [dbo].[Contab_BalanceComprobacion] DROP CONSTRAINT [FK_Contab_BalanceComprobacion_Monedas]
GO

ALTER TABLE [dbo].[Contab_BalanceComprobacion] DROP CONSTRAINT [FK_Contab_BalanceComprobacion_CuentasContables]
GO

/****** Object:  Table [dbo].[Contab_BalanceComprobacion]    Script Date: 3/10/2026 12:30:58 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Contab_BalanceComprobacion]') AND type in (N'U'))
DROP TABLE [dbo].[Contab_BalanceComprobacion]
GO

/****** Object:  Table [dbo].[Contab_BalanceComprobacion]    Script Date: 3/10/2026 12:30:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Contab_BalanceComprobacion](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Moneda] [int] NOT NULL,
	[CuentaContable_NivelPrevio] [nvarchar](25) NULL,
	[CuentaContable_NivelPrevio_Descripcion] [nvarchar](60) NULL,
	[nivel1] [nvarchar](100) NULL,
	[nivel2] [nvarchar](100) NULL,
	[nivel3] [nvarchar](100) NULL,
	[nivel4] [nvarchar](100) NULL,
	[nivel5] [nvarchar](100) NULL,
	[nivel6] [nvarchar](100) NULL,
	[nivel7] [nvarchar](100) NULL,
	[nivel8] [nvarchar](100) NULL,
	[nivel9] [nvarchar](100) NULL,
	[CuentaContableID] [int] NOT NULL,
	[SaldoAnterior] [money] NULL,
	[Debe] [money] NULL,
	[Haber] [money] NULL,
	[SaldoActual] [money] NULL,
	[CantidadMovimientos] [int] NULL,
	[NombreUsuario] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Contab_BalanceComprobacion] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Contab_BalanceComprobacion]  WITH CHECK ADD  CONSTRAINT [FK_Contab_BalanceComprobacion_CuentasContables] FOREIGN KEY([CuentaContableID])
REFERENCES [dbo].[CuentasContables] ([ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Contab_BalanceComprobacion] CHECK CONSTRAINT [FK_Contab_BalanceComprobacion_CuentasContables]
GO

ALTER TABLE [dbo].[Contab_BalanceComprobacion]  WITH CHECK ADD  CONSTRAINT [FK_Contab_BalanceComprobacion_Monedas] FOREIGN KEY([Moneda])
REFERENCES [dbo].[Monedas] ([Moneda])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Contab_BalanceComprobacion] CHECK CONSTRAINT [FK_Contab_BalanceComprobacion_Monedas]
GO


Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.474', GetDate()) 