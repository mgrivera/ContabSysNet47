/*    Viernes, 9 de Agosto de 2.008   -   v0.00.218.sql 

	Agregamos una relación entre CuotasFacturas y Proveedores 

	NOTA: ejecutar es query ANTES para verficar que no existan registros en CuotasFactura sin 
		  un registro en Proveedores 


	Select * From CuotasFactura 
	Where Proveedor Not In (Select Proveedor From Proveedores) 

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
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuotasFactura ADD CONSTRAINT
	FK_CuotasFactura_Proveedores FOREIGN KEY
	(
	Proveedor
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.218', GetDate()) 