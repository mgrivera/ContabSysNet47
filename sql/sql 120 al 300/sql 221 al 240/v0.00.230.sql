/*    Domingo, 14 de diciembre de 2.008  -   v0.00.230.sql 

	Agregamos el item Abreviatura a la tabla Bancos 

*/ 


drop view qFormaCompanias 
drop view qFormaBancos 



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
CREATE TABLE dbo.Tmp_Bancos
	(
	Banco int NOT NULL IDENTITY (1, 1),
	Nombre nvarchar(50) NOT NULL,
	NombreCorto nvarchar(10) NULL,
	Abreviatura nvarchar(5) NULL,
	DefinicionParaElArchivo int NULL,
	NombreArchivoDeTexto nvarchar(150) NULL
	)  ON [PRIMARY]
GO
SET IDENTITY_INSERT dbo.Tmp_Bancos ON
GO
IF EXISTS(SELECT * FROM dbo.Bancos)
	 EXEC('INSERT INTO dbo.Tmp_Bancos (Banco, Nombre, NombreCorto, DefinicionParaElArchivo, NombreArchivoDeTexto)
		SELECT Banco, Nombre, NombreCorto, DefinicionParaElArchivo, NombreArchivoDeTexto FROM dbo.Bancos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Bancos OFF
GO
ALTER TABLE dbo.Agencias
	DROP CONSTRAINT FK_Agencias_Bancos
GO
ALTER TABLE dbo.BancosInfoTarjetas
	DROP CONSTRAINT FK_BancosInfoTarjetas_Bancos
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Bancos
GO
DROP TABLE dbo.Bancos
GO
EXECUTE sp_rename N'dbo.Tmp_Bancos', N'Bancos', 'OBJECT' 
GO
ALTER TABLE dbo.Bancos ADD CONSTRAINT
	PK_Bancos PRIMARY KEY NONCLUSTERED 
	(
	Banco
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancarias WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancarias_Bancos FOREIGN KEY
	(
	Banco
	) REFERENCES dbo.Bancos
	(
	Banco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.BancosInfoTarjetas WITH NOCHECK ADD CONSTRAINT
	FK_BancosInfoTarjetas_Bancos FOREIGN KEY
	(
	Banco
	) REFERENCES dbo.Bancos
	(
	Banco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Agencias WITH NOCHECK ADD CONSTRAINT
	FK_Agencias_Bancos FOREIGN KEY
	(
	Banco
	) REFERENCES dbo.Bancos
	(
	Banco
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
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
CREATE TABLE dbo.Tmp_Companias
	(
	Numero int NOT NULL,
	Nombre nvarchar(50) NOT NULL,
	NombreCorto nvarchar(25) NOT NULL,
	Abreviatura nvarchar(5) NULL,
	Rif nvarchar(12) NULL,
	Direccion nvarchar(150) NULL,
	Ciudad nvarchar(25) NULL,
	EntidadFederal nvarchar(50) NULL,
	ZonaPostal nvarchar(15) NULL,
	Telefono1 nvarchar(14) NULL,
	Telefono2 nvarchar(14) NULL,
	Fax nvarchar(14) NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.Companias)
	 EXEC('INSERT INTO dbo.Tmp_Companias (Numero, Nombre, NombreCorto, Rif, Direccion, Ciudad, EntidadFederal, ZonaPostal, Telefono1, Telefono2, Fax)
		SELECT Numero, Nombre, NombreCorto, Rif, Direccion, Ciudad, EntidadFederal, ZonaPostal, Telefono1, Telefono2, Fax FROM dbo.Companias WITH (HOLDLOCK TABLOCKX)')
GO
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_Companias
GO
ALTER TABLE dbo.CajaChica_CajasChicas
	DROP CONSTRAINT FK_CajaChica_CajasChicas_Companias
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables
	DROP CONSTRAINT FK_CajaChica_RubrosCuentasContables_Companias
GO
ALTER TABLE dbo.Disponibilidad_MontosRestringidos
	DROP CONSTRAINT FK_Disponibilidad_MontosRestringidos_Companias
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_Companias
GO
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Companias
GO
ALTER TABLE dbo.OrdenesPago
	DROP CONSTRAINT FK_OrdenesPago_Companias
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_Companias
GO
ALTER TABLE dbo.Asientos
	DROP CONSTRAINT FK_Asientos_Companias
GO
ALTER TABLE dbo.Facturas
	DROP CONSTRAINT FK_Facturas_Companias
GO
ALTER TABLE dbo.NivelesAgrupacionContableMontosEstimados
	DROP CONSTRAINT FK_NivelesAgrupacionContableMontosEstimados_Companias
GO
ALTER TABLE dbo.CuotasFactura
	DROP CONSTRAINT FK_CuotasFactura_Companias
GO
ALTER TABLE dbo.SaldosCompanias
	DROP CONSTRAINT FK_SaldosCompanias_Companias
GO
ALTER TABLE dbo.Saldos
	DROP CONSTRAINT FK_Saldos_Companias
GO
ALTER TABLE dbo.Pagos
	DROP CONSTRAINT FK_Pagos_Companias
GO
ALTER TABLE dbo.Presupuesto_Codigos
	DROP CONSTRAINT FK_Presupuesto_Codigos_Companias
GO
ALTER TABLE dbo.UltimoMesCerrado
	DROP CONSTRAINT FK_UltimoMesCerrado_Companias
GO
ALTER TABLE dbo.Salidas
	DROP CONSTRAINT FK_Salidas_Companias
GO
ALTER TABLE dbo.Presupuesto_UltimoMesCerrado
	DROP CONSTRAINT FK_Presupuesto_UltimoMesCerrado_Companias
GO
ALTER TABLE dbo.Entradas
	DROP CONSTRAINT FK_Entradas_Companias
GO
ALTER TABLE dbo.CuentasContables
	DROP CONSTRAINT FK_CuentasContables_Companias
GO
DROP TABLE dbo.Companias
GO
EXECUTE sp_rename N'dbo.Tmp_Companias', N'Companias', 'OBJECT' 
GO
ALTER TABLE dbo.Companias ADD CONSTRAINT
	PK_Companias PRIMARY KEY NONCLUSTERED 
	(
	Numero
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasContables WITH NOCHECK ADD CONSTRAINT
	FK_CuentasContables_Companias FOREIGN KEY
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
ALTER TABLE dbo.Entradas WITH NOCHECK ADD CONSTRAINT
	FK_Entradas_Companias FOREIGN KEY
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
ALTER TABLE dbo.Presupuesto_UltimoMesCerrado ADD CONSTRAINT
	FK_Presupuesto_UltimoMesCerrado_Companias FOREIGN KEY
	(
	CiaContab
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Salidas WITH NOCHECK ADD CONSTRAINT
	FK_Salidas_Companias FOREIGN KEY
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
ALTER TABLE dbo.UltimoMesCerrado WITH NOCHECK ADD CONSTRAINT
	FK_UltimoMesCerrado_Companias FOREIGN KEY
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
ALTER TABLE dbo.Presupuesto_Codigos ADD CONSTRAINT
	FK_Presupuesto_Codigos_Companias FOREIGN KEY
	(
	CiaContab
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Pagos WITH NOCHECK ADD CONSTRAINT
	FK_Pagos_Companias FOREIGN KEY
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
ALTER TABLE dbo.Saldos WITH NOCHECK ADD CONSTRAINT
	FK_Saldos_Companias FOREIGN KEY
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
ALTER TABLE dbo.SaldosCompanias WITH NOCHECK ADD CONSTRAINT
	FK_SaldosCompanias_Companias FOREIGN KEY
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
ALTER TABLE dbo.CuotasFactura WITH NOCHECK ADD CONSTRAINT
	FK_CuotasFactura_Companias FOREIGN KEY
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
ALTER TABLE dbo.NivelesAgrupacionContableMontosEstimados ADD CONSTRAINT
	FK_NivelesAgrupacionContableMontosEstimados_Companias FOREIGN KEY
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
ALTER TABLE dbo.Facturas WITH NOCHECK ADD CONSTRAINT
	FK_Facturas_Companias FOREIGN KEY
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
BEGIN TRANSACTION
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
ALTER TABLE dbo.OrdenesPago ADD CONSTRAINT
	FK_OrdenesPago_Companias FOREIGN KEY
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
ALTER TABLE dbo.CuentasBancarias WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancarias_Companias FOREIGN KEY
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
ALTER TABLE dbo.MovimientosBancarios WITH NOCHECK ADD CONSTRAINT
	FK_MovimientosBancarios_Companias FOREIGN KEY
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
ALTER TABLE dbo.Disponibilidad_MontosRestringidos ADD CONSTRAINT
	FK_Disponibilidad_MontosRestringidos_Companias FOREIGN KEY
	(
	CiaContab
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_RubrosCuentasContables ADD CONSTRAINT
	FK_CajaChica_RubrosCuentasContables_Companias FOREIGN KEY
	(
	CiaContab
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_CajasChicas ADD CONSTRAINT
	FK_CajaChica_CajasChicas_Companias FOREIGN KEY
	(
	CiaContab
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_Companias FOREIGN KEY
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

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.230', GetDate()) 