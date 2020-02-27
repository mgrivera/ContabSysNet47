/*    Martes, 20 de Mayo de 2.008   -   v0.00.215.sql 

	Agregamos relaciones de integridad referencial, que no existían antes, a algunas tablas de 
	contabilidad 

	NOTA IMPORTANTE: revisar a ver si hay registros en dAsientos SIN la cuenta contable en CuentasContables 

	usar este query para revisar 

	Select dAsientos.Numero, Mes, Ano, Fecha, Moneda, MonedaOriginal, Cuenta, Descripcion, 
				dAsientos.Cia, Companias.NombreCorto 
				From dAsientos 
				Inner Join Companias On dAsientos.Cia = Companias.Numero
				Where 
				Cuenta + '-' + Convert(nvarchar, Cia) 
				Not In (Select Cuenta + '-' + Convert(nvarchar, Cia) From CuentasContables) 

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
COMMIT
BEGIN TRANSACTION
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	FK_dAsientos_CuentasContables FOREIGN KEY
	(
	Cuenta,
	Cia
	) REFERENCES dbo.CuentasContables
	(
	Cuenta,
	Cia
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	FK_dAsientos_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Asientos ADD CONSTRAINT
	FK_Asientos_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Asientos ADD CONSTRAINT
	FK_Asientos_Monedas1 FOREIGN KEY
	(
	MonedaOriginal
	) REFERENCES dbo.Monedas
	(
	Moneda
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.Asientos ADD CONSTRAINT
	FK_Asientos_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.215', GetDate()) 