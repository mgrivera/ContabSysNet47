/*    Lunes, 25 de Noviembre de 2.013 	-   v0.00.362d.sql 

	Cambios básicos al registro de información para la contabilización de 
	depósitos de ventas con tarjetas de crédito ... 
	
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
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas
	DROP CONSTRAINT FK_MovimientosBancariosPagosTarjetas_Tarjetas
GO
ALTER TABLE dbo.Tarjetas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_MovimientosBancariosPagosTarjetas
	(
	ID int NOT NULL IDENTITY (1, 1),
	MovimientoBancarioID int NOT NULL,
	Transaccion bigint NOT NULL,
	CuentaInterna int NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Tarjeta nvarchar(4) NOT NULL,
	MontoBase money NULL,
	PorcComision decimal(5, 2) NULL,
	Comision money NULL,
	PorcComision2 decimal(5, 2) NULL,
	Comision2 money NULL,
	FactorReversionImpuestos float(53) NULL,
	MontoBaseParaImpuestos money NULL,
	PorcImpuestos decimal(5, 2) NULL,
	Impuestos money NULL,
	Monto money NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_MovimientosBancariosPagosTarjetas SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_MovimientosBancariosPagosTarjetas OFF
GO
IF EXISTS(SELECT * FROM dbo.MovimientosBancariosPagosTarjetas)
	 EXEC('INSERT INTO dbo.Tmp_MovimientosBancariosPagosTarjetas (MovimientoBancarioID, Transaccion, CuentaInterna, Tipo, Tarjeta, MontoBase, PorcComision, Comision, PorcComision2, Comision2, FactorReversionImpuestos, MontoBaseParaImpuestos, PorcImpuestos, Impuestos, Monto)
		SELECT 0, Transaccion, CuentaInterna, Tipo, Tarjeta, MontoBase, PorcComision, Comision, PorcComision2, Comision2, FactorReversionImpuestos, MontoBaseParaImpuestos, PorcImpuestos, Impuestos, Monto FROM dbo.MovimientosBancariosPagosTarjetas WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.MovimientosBancariosPagosTarjetas
GO
EXECUTE sp_rename N'dbo.Tmp_MovimientosBancariosPagosTarjetas', N'MovimientosBancariosPagosTarjetas', 'OBJECT' 
GO
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas ADD CONSTRAINT
	PK_MovimientosBancariosPagosTarjetas PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas WITH NOCHECK ADD CONSTRAINT
	FK_MovimientosBancariosPagosTarjetas_Tarjetas FOREIGN KEY
	(
	Tarjeta
	) REFERENCES dbo.Tarjetas
	(
	Tarjeta
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO






UPdate t 
Set t.MovimientoBancarioID = m.ClaveUnica 
From  
MovimientosBancarios m Inner Join Chequeras c On m.ClaveUnicaChequera = c.NumeroChequera 
Inner Join 
MovimientosBancariosPagosTarjetas t On t.Transaccion = m.Transaccion And t.Tipo = m.Tipo And t.CuentaInterna = c.NumeroCuenta 


Delete From MovimientosBancariosPagosTarjetas Where MovimientoBancarioID = 0 



ALTER TABLE dbo.MovimientosBancariosPagosTarjetas ADD CONSTRAINT
	FK_MovimientosBancariosPagosTarjetas_MovimientosBancarios FOREIGN KEY
	(
	MovimientoBancarioID
	) REFERENCES dbo.MovimientosBancarios
	(
	ClaveUnica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT




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
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas
	DROP COLUMN Transaccion, CuentaInterna, Tipo
GO
ALTER TABLE dbo.MovimientosBancariosPagosTarjetas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.362d', GetDate()) 
