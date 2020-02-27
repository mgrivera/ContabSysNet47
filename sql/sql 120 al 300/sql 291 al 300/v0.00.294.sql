/*    Jueves, 01 de Diciembre de 2.011  -   v0.00.294.sql 

	Hacemos algunos cambios a la tabla DefinicionCuentasContables 
	NOTA: se ejecutó muy bien en Lacoste luego de revisar/corregir con las instrucciones que siguen 
*/

/* Nota Importante: revisar y cambiar el collation, de ser necesario, en CuentaContable
   para que sea *igual* a ID en CuentasContables ANTES DE EJECUTAR EL SCRIPT */ 


/* ========================================================================================== */ 
/* NOTA IMPORTANTE: 

este script fallará si alguno de los queries que siguen regresa algun registro 
Probar cada query por separado (de manera individual) 

*/ 

Select * From DefinicionCuentasContables 
Where CiaContab Is Not Null And 
CiaContab Not In (Select Numero From Companias) 

/* corregir el anterior con éste */ 
Update DefinicionCuentasContables Set CiaContab = null 
Where CiaContab Is Not Null And 
CiaContab Not In (Select Numero From Companias) 

Select * From DefinicionCuentasContables 
Where Moneda Is Not Null And 
Moneda Not In (Select Moneda From Monedas) 

/* corregir el anterior con éste */ 
Update DefinicionCuentasContables Set Moneda = null 
Where Moneda Is Not Null And 
Moneda Not In (Select Moneda From Monedas) 

Select * From DefinicionCuentasContables 
Where Compania Is Not Null And 
Compania Not In (Select Proveedor From Proveedores) 

/* corregir el anterior con éste */ 
Update DefinicionCuentasContables Set Compania = Null 
Where Compania Is Not Null And 
Compania Not In (Select Proveedor From Proveedores) 

Select * From DefinicionCuentasContables 
Where Rubro Is Not Null And 
Rubro Not In (Select Tipo From TiposProveedor) 

/* ========================================================================================== */ 



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
ALTER TABLE dbo.TiposProveedor SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Monedas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	FK_DefinicionCuentasContables_Companias FOREIGN KEY
	(
	CiaContab
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	FK_DefinicionCuentasContables_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	FK_DefinicionCuentasContables_Proveedores FOREIGN KEY
	(
	Compania
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.DefinicionCuentasContables ADD CONSTRAINT
	FK_DefinicionCuentasContables_TiposProveedor FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.TiposProveedor
	(
	Tipo
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.DefinicionCuentasContables
	DROP COLUMN GrupoCondominio, CodigoInmueble
GO
ALTER TABLE dbo.DefinicionCuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.294', GetDate()) 