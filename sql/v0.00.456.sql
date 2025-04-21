/*    
	  Martes, 10 de Enero de 2.024  -   v0.00.456.sql 
	  
	  Agregamos el View v_contab_cuentasContables_lista para leer las cuentas contables 
	  desde el combo de cuentas (en Microsoft Access) 
*/

-- ********************************************************************************
-- v_contab_cuentasContables_lista
-- ********************************************************************************

-- Drop a view if it exists using OBJECT_ID
IF OBJECT_ID('dbo.v_contab_cuentasContables_lista', 'V') IS NOT NULL
  DROP VIEW dbo.v_contab_cuentasContables_lista;

GO

Create View dbo.v_contab_cuentasContables_lista  As 
  
Select Top 100 Percent ID as id, (Cuenta + ' - ' + Descripcion) as cuentaMasDescripcion, Cia as cia 
From CuentasContables
Where TotDet = 'D' 
Order By (Cuenta + ' - ' + Descripcion)

Go

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.456', GetDate()) 