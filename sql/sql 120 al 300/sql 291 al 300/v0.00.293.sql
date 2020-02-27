/*    Lunes, 28 de Novimiembre de 2.011  -   v0.00.293.sql 

	Cambiamos el tipo de la columna Transaccion de nvarchar(20) a BigInt
	
	NOTA: con las validaciones que siguen, funcionó perfecto para Lacoste ... 

	NOTA IMPORTANTE: debemos revisar que no existan movimientos bancarios con 
	Transacción DIFERENTE a numérico. De existir estos casos, tomar las accciones 
	que correspondan ANTES de ejecutar este script. 
	
	
		Select * From MovimientosBancarios Where IsNumeric(Transaccion) = 0 
		
		Solo si es posible, se pueden eliminar los movimientos que traiga el Select anterior: 
		
		Delete From MovimientosBancarios Where IsNumeric(Transaccion) = 0 

	NOTA IMPORTANTE: Transaccion será cambiado a int; este tipo soporta hasta 
	2 mil millones; este tipo debe ser adecuado para todos los casos ... 
	sin embargo, asegurarse con Max(Transaccion) como sigue ... 
*/


/* para consultar mb con Transaccion no numérica */ 

Select * From 
MovimientosBancarios 
Where IsNumeric(Transaccion) = 0

/* para consultar mb con '.'; nótese que son tomados como números ... */ 

/* necesario en Lacoste */ 

Update MovimientosBancarios 
Set Transaccion = Replace(Transaccion, '_dt', '') 
Where Transaccion Like '%_dt%' 

Select * From 
MovimientosBancarios 
Where Transaccion Like '%.%' Or Transaccion Like '%,%' 

Update MovimientosBancarios 
Set Transaccion = Replace(Transaccion, '.', '') 
Where Transaccion Like '%.%' 

Update MovimientosBancarios 
Set Transaccion = Replace(Transaccion, ',', '') 
Where Transaccion Like '%,%' 

Select Max(Transaccion) 
From MovimientosBancarios 

/* con la siguiente instrucción revisamos si existen movimientos cuya Transaccion 
   NO CABE en un bigint */ 
   

   
Select * From MovimientosBancarios Where 
Convert(bigint, Transaccion) > 9223372000000000000


Select Max(Convert(bigint, Transaccion))
From MovimientosBancarios 

/* si las 2 instrucciones anteriores fallan, es probable que existan Transacciones con 
   más de 19 dígitos; buscar con el siguiente query y cambiar a números más pequeños */ 
   
Select Len(Transaccion) As LenTransaccion, Transaccion From MovimientosBancarios 
Where Len(Transaccion) > 18
Order By LenTransaccion Desc

/* si son pocos, corregir con este simple Update; usar copy/paste con la transacción que da el query anterior */ 

Update MovimientosBancarios Set Transaccion = SubString('80001615092012870127',1, 18)  
Where Transaccion = '80001615092012870127'



/* ==================== fin de validaciones a los datos ========================= */ 



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
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_CuentasBancarias
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Proveedores
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Asientos
GO
ALTER TABLE dbo.Asientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Chequeras
	(
	NumeroChequera int NOT NULL IDENTITY (1, 1),
	NumeroCuenta int NOT NULL,
	Activa bit NOT NULL,
	Generica bit NOT NULL,
	FechaAsignacion date NOT NULL,
	Desde int NULL,
	Hasta int NULL,
	AsignadaA nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	AgotadaFlag bit NULL,
	CantidadDeChequesUsados smallint NULL,
	UltimoChequeUsado bigint NULL,
	CantidadDeCheques int NULL,
	Usuario nvarchar(25) NOT NULL,
	Ingreso datetime NOT NULL,
	UltAct datetime NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Chequeras SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras ON
GO
IF EXISTS(SELECT * FROM dbo.Chequeras)
	 EXEC('INSERT INTO dbo.Tmp_Chequeras (NumeroChequera, NumeroCuenta, Activa, Generica, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, UltimoChequeUsado, CantidadDeCheques, Usuario, Ingreso, UltAct)
		SELECT NumeroChequera, NumeroCuenta, Activa, Generica, FechaAsignacion, Desde, Hasta, AsignadaA, AgotadaFlag, CantidadDeChequesUsados, CONVERT(bigint, UltimoChequeUsado), CantidadDeCheques, Usuario, Ingreso, UltAct FROM dbo.Chequeras WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Chequeras OFF
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Chequeras
GO
DROP TABLE dbo.Chequeras
GO
EXECUTE sp_rename N'dbo.Tmp_Chequeras', N'Chequeras', 'OBJECT' 
GO
ALTER TABLE dbo.Chequeras ADD CONSTRAINT
	PK_Chequeras PRIMARY KEY NONCLUSTERED 
	(
	NumeroChequera
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_Chequeras ON dbo.Chequeras
	(
	NumeroCuenta
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_CuentasBancarias FOREIGN KEY
	(
	NumeroCuenta
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT


BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_MovimientosBancarios
	(
	Transaccion bigint NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Fecha date NOT NULL,
	ProvClte int NULL,
	Beneficiario nvarchar(50) NOT NULL,
	Concepto nvarchar(250) NOT NULL,
	MontoBase money NULL,
	Comision money NULL,
	Impuestos money NULL,
	Monto money NOT NULL,
	Ingreso datetime NOT NULL,
	UltMod datetime NOT NULL,
	Usuario nvarchar(25) NOT NULL,
	Comprobante int NULL,
	ClaveUnica int NOT NULL IDENTITY (1, 1),
	ClaveUnicaChequera int NOT NULL,
	FechaEntregado date NULL,
	Conciliacion_FechaEjecucion smalldatetime NULL,
	Conciliacion_MovimientoBanco_Fecha smalldatetime NULL,
	Conciliacion_MovimientoBanco_Numero nvarchar(50) NULL,
	Conciliacion_MovimientoBanco_Tipo nvarchar(4) NULL,
	Conciliacion_MovimientoBanco_FechaProceso smalldatetime NULL,
	Conciliacion_MovimientoBanco_Monto money NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_MovimientosBancarios SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_MovimientosBancarios ON
GO
IF EXISTS(SELECT * FROM dbo.MovimientosBancarios)
	 EXEC('INSERT INTO dbo.Tmp_MovimientosBancarios (Transaccion, Tipo, Fecha, ProvClte, Beneficiario, Concepto, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, Usuario, Comprobante, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, Conciliacion_MovimientoBanco_Numero, Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto)
		SELECT CONVERT(bigint, Transaccion), Tipo, Fecha, ProvClte, Beneficiario, Concepto, MontoBase, Comision, Impuestos, Monto, Ingreso, UltMod, Usuario, Comprobante, ClaveUnica, ClaveUnicaChequera, FechaEntregado, Conciliacion_FechaEjecucion, Conciliacion_MovimientoBanco_Fecha, Conciliacion_MovimientoBanco_Numero, Conciliacion_MovimientoBanco_Tipo, Conciliacion_MovimientoBanco_FechaProceso, Conciliacion_MovimientoBanco_Monto FROM dbo.MovimientosBancarios WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_MovimientosBancarios OFF
GO
DROP TABLE dbo.MovimientosBancarios
GO
EXECUTE sp_rename N'dbo.Tmp_MovimientosBancarios', N'MovimientosBancarios', 'OBJECT' 
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	PK_MovimientosBancarios PRIMARY KEY CLUSTERED 
	(
	ClaveUnica
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	FK_MovimientosBancarios_Asientos FOREIGN KEY
	(
	Comprobante
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MovimientosBancarios WITH NOCHECK ADD CONSTRAINT
	FK_MovimientosBancarios_Proveedores FOREIGN KEY
	(
	ProvClte
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.MovimientosBancarios ADD CONSTRAINT
	FK_MovimientosBancarios_Chequeras FOREIGN KEY
	(
	ClaveUnicaChequera
	) REFERENCES dbo.Chequeras
	(
	NumeroChequera
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.293', GetDate()) 