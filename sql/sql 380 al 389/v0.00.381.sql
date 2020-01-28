/*    
	  Jueves, 21 de Abril de 2.016	-   v0.00.381.sql 

	  Agregamos algunos índices a las tablas Facturas y Pagos 
	  (Nota importante: crear estos indices por separado en forma manual, seleccionar 
	   y ejecutar, pues pueden existir; simplemente, intentar crear estos indices en forma 
	   manuel y luego actualizar la versión)
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
CREATE NONCLUSTERED INDEX IX_Pagos ON dbo.Pagos
	(
	Moneda,
	Proveedor,
	Fecha,
	MiSuFlag,
	Cia
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Pagos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE NONCLUSTERED INDEX IX_Facturas ON dbo.Facturas
	(
	Moneda,
	Proveedor,
	FechaEmision,
	CxCCxPFlag,
	Cia
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX IX_Facturas_1 ON dbo.Facturas
	(
	Moneda,
	Proveedor,
	FechaRecepcion,
	CxCCxPFlag,
	Cia
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Facturas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.381', GetDate()) 
