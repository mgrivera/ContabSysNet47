/*    Jueves, 21 de Noviembre de 2.013 	-   v0.00.362c.sql 

	Cambios básicos al registro de información para la contabilización de 
	depósitos de ventas con tarjetas de crédito ... 
	
	Este Select no debe traer registros: 
	Select * From MovimientosBancariosPagosTarjetas Where IsNumeric(Transaccion) <> 1 
	
	El siguiente Select debe funcionar sin errores, para probar que se puede convertir a BigInt la 
	columna Transacción 
	SELECT Transaccion, CONVERT(bigint, Transaccion) as TransaccionBigInt From MovimientosBancariosPagosTarjetas
	Order by Transaccion
	
	Cambiar el contendido de Transaccion, para que el Select anterior se ejecute en forma completa 
	Update MovimientosBancariosPagosTarjetas Set Transaccion = Replace(Transaccion, '.', '') 
	Update MovimientosBancariosPagosTarjetas Set Transaccion = Replace(Transaccion, ',', '') 
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
CREATE TABLE dbo.Tmp_MovimientosBancariosPagosTarjetas
	(
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
IF EXISTS(SELECT * FROM dbo.MovimientosBancariosPagosTarjetas)
	 EXEC('INSERT INTO dbo.Tmp_MovimientosBancariosPagosTarjetas (Transaccion, CuentaInterna, Tipo, Tarjeta, MontoBase, PorcComision, Comision, PorcComision2, Comision2, FactorReversionImpuestos, MontoBaseParaImpuestos, PorcImpuestos, Impuestos, Monto)
		SELECT CONVERT(bigint, Transaccion), CuentaInterna, Tipo, Tarjeta, MontoBase, PorcComision, Comision, PorcComision2, Comision2, FactorReversionImpuestos, MontoBaseParaImpuestos, PorcImpuestos, Impuestos, Monto FROM dbo.MovimientosBancariosPagosTarjetas WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.MovimientosBancariosPagosTarjetas
GO
EXECUTE sp_rename N'dbo.Tmp_MovimientosBancariosPagosTarjetas', N'MovimientosBancariosPagosTarjetas', 'OBJECT' 
GO




Declare @transaccionx bigint, @cuentainternax int, @tipox nvarchar(2), @tarjetax nvarchar(4) 

Declare MyCursor Cursor For 
	Select Transaccion, CuentaInterna, Tipo, Tarjeta 
	From MovimientosBancariosPagosTarjetas 
	Group By Transaccion, CuentaInterna, Tipo, Tarjeta 
	Having Count(*) > 1


Open MyCursor

Fetch Next From MyCursor Into @transaccionx, @cuentainternax, @tipox, @tarjetax

WHILE @@FETCH_STATUS = 0

BEGIN
  
   DELETE From MovimientosBancariosPagosTarjetas 
		  where Transaccion = @transaccionx And 
		        CuentaInterna = @cuentainternax And 
		        Tipo = @tipox And 
		        Tarjeta = @tarjetax 

   Fetch Next From MyCursor Into @transaccionx, @cuentainternax, @tipox, @tarjetax
   
END


ALTER TABLE dbo.MovimientosBancariosPagosTarjetas ADD CONSTRAINT
	PK_MovimientosBancariosPagosTarjetas PRIMARY KEY CLUSTERED 
	(
	Transaccion,
	CuentaInterna,
	Tipo,
	Tarjeta
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
COMMIT






--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.362c', GetDate()) 
