/*    
	  Jueves, 30 de Enero de 2.025  -   v0.00.464.sql 
	  
	  Agregamos la columna SubTitulo a la tabla ProcesosUsuarios 
	  También agregamos las tablas (Tmp_...) y views necesarias 
	  para producir el reporte de Egresos desde Movimientos bancarios. 

	  =======================================================
	  NOTA: If no compila en bases de datos viejas !!!! 
	  =======================================================
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
ALTER TABLE dbo.ProcesosUsuarios ADD
	SubTituloReport nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
GO
ALTER TABLE dbo.ProcesosUsuarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


-- ===================================================================
-- Agregamos la tabla Tmp_MovBancos_EgreIngr_Report 
-- ===================================================================

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tmp_MovBancos_EgreIngReport]') AND type in (N'U'))
ALTER TABLE [dbo].[Tmp_MovBancos_EgreIngReport] DROP CONSTRAINT [FK_Tmp_MovBancos_EgreIngReport_ProcesosUsuarios]
GO

/****** Object:  Table [dbo].[Tmp_MovBancos_EgreIngReport]    Script Date: 2/1/2025 12:02:38 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Tmp_MovBancos_EgreIngReport]') AND type in (N'U'))
DROP TABLE [dbo].[Tmp_MovBancos_EgreIngReport]
GO

/****** Object:  Table [dbo].[Tmp_MovBancos_EgreIngReport]    Script Date: 2/1/2025 12:02:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Tmp_MovBancos_EgreIngReport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ProcesoId] [int] NOT NULL,
	[MovimientoBancarioId] [int] NOT NULL,
	[MontoEscrito] [nvarchar](500) NOT NULL,
 CONSTRAINT [PK_Tmp_MovBancos_EgreIngReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Tmp_MovBancos_EgreIngReport]  WITH CHECK ADD  CONSTRAINT [FK_Tmp_MovBancos_EgreIngReport_ProcesosUsuarios] FOREIGN KEY([ProcesoId])
REFERENCES [dbo].[ProcesosUsuarios] ([Id])
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[Tmp_MovBancos_EgreIngReport] CHECK CONSTRAINT [FK_Tmp_MovBancos_EgreIngReport_ProcesosUsuarios]
GO



-- ===================================================================
-- Agregamos el view V_Tmp_MovBancos_EgreIngr_Report 
-- ===================================================================

-- Drop a view if it exists using OBJECT_ID
IF OBJECT_ID('dbo.V_Tmp_MovBancos_EgreIngr_Report', 'V') IS NOT NULL
  DROP VIEW dbo.V_Tmp_MovBancos_EgreIngr_Report;

GO

Create View dbo.V_Tmp_MovBancos_EgreIngr_Report  As 
  
Select tmp.ProcesoId, m.Simbolo as MonedaSimbolo, Abs(mb.Monto) as Monto, mb.Beneficiario, m.Descripcion as NombreMoneda, 
		tmp.MontoEscrito, mb.Fecha, cia.Nombre as CiaNombre, cia.Rif as CiaRif, cia.Ciudad, 
		mb.Transaccion, banco.Nombre as BancoNombre, cb.CuentaBancaria, 
		pr.Contacto1 as ProveedorNombreContacto1, pr.Rif as ProveedorRif, 
		asnt.Numero as ComprobanteNumero, mb.ClaveUnica as MovimientoBancarioId 

From Tmp_MovBancos_EgreIngReport tmp
		Inner Join MovimientosBancarios mb On tmp.MovimientoBancarioId = mb.ClaveUnica 
		Inner Join Chequeras ch On mb.ClaveUnicaChequera = ch.NumeroChequera 
		Inner Join CuentasBancarias cb On ch.NumeroCuenta = cb.CuentaInterna 
		Inner Join Agencias ag On cb.Agencia = ag.Agencia 
		Inner Join Bancos banco On ag.Banco = banco.Banco 
		Inner Join Monedas m On cb.Moneda = m.Moneda 
		Left Outer Join Proveedores pr On mb.ProvClte = pr.Proveedor 
		Inner Join Companias cia On cb.Cia = cia.Numero 
		Left Outer Join Asientos asnt On asnt.ProvieneDe_ID = mb.ClaveUnica and asnt.Moneda = cb.Moneda 

Where asnt.ProvieneDe = 'Bancos'



-- ===================================================================
-- Agregamos el view V_Tmp_MovBancos_EgreIngr_Asientos_Report 
-- ===================================================================

-- Drop a view if it exists using OBJECT_ID
IF OBJECT_ID('dbo.V_Tmp_MovBancos_EgreIngr_Asientos_Report', 'V') IS NOT NULL
  DROP VIEW dbo.V_Tmp_MovBancos_EgreIngr_Asientos_Report;

GO

Create View dbo.V_Tmp_MovBancos_EgreIngr_Asientos_Report  As 
  
Select a.ProvieneDe, a.ProvieneDe_ID, d.Partida, cc.CuentaEditada, d.Descripcion, 
			m.Simbolo as MonedaSimbolo, d.Debe, d.Haber 
From dAsientos d 
Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico 
Inner Join CuentasContables cc On d.CuentaContableID = cc.Id 
Inner Join Monedas m On a.Moneda = m.Moneda 

Where ProvieneDe = 'Bancos' 

Go


Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.464', GetDate()) 