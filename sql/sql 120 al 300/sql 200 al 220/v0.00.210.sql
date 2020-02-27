/*    Martes, 24 de Septiembre de 2.007   -   v0.00.210.sql 

	Agregamos el item AplicarFactorReversionImpuestos a la tabla BancosInfoTarjetas 

*/ 


BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.BancosInfoTarjetas ADD
	AplicarFactorReversionImpuestos bit NULL
GO
COMMIT

Update BancosInfoTarjetas Set AplicarFactorReversionImpuestos = 1 

ALTER TABLE dbo.BancosInfoTarjetas Alter Column 
	AplicarFactorReversionImpuestos bit Not NULL

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.210', GetDate()) 