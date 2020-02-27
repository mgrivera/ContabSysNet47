/*    Miercoles, 07 de Agosto de 2002   -   v0.00.127.sql 

	Agregamos el item Estado a la tabla CuentasBancarias. 

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
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Monedas
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Agencias
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.CuentasBancarias
	DROP CONSTRAINT FK_CuentasBancarias_Companias
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_CuentasBancarias
	(
	CuentaInterna int NOT NULL,
	Agencia int NOT NULL,
	CuentaBancaria nvarchar(50) NOT NULL,
	Tipo nvarchar(2) NOT NULL,
	Moneda int NOT NULL,
	LineaCredito money NULL,
	Banco int NULL,
	Estado char(2) NULL,
	CuentaContable nvarchar(25) NULL,
	CuentaContableGastosIDB nvarchar(25) NULL,
	FormatoImpresionCheque smallint NULL,
	GenerarTransaccionesAOtraCuentaFlag bit NULL,
	CuentaBancariaAsociada int NULL,
	NombrePlantillaWord nvarchar(100) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.CuentasBancarias)
	 EXEC('INSERT INTO dbo.Tmp_CuentasBancarias (CuentaInterna, Agencia, CuentaBancaria, Tipo, Moneda, LineaCredito, Banco, CuentaContable, CuentaContableGastosIDB, FormatoImpresionCheque, GenerarTransaccionesAOtraCuentaFlag, CuentaBancariaAsociada, NombrePlantillaWord, Cia)
		SELECT CuentaInterna, Agencia, CuentaBancaria, Tipo, Moneda, LineaCredito, Banco, CuentaContable, CuentaContableGastosIDB, FormatoImpresionCheque, GenerarTransaccionesAOtraCuentaFlag, CuentaBancariaAsociada, NombrePlantillaWord, Cia FROM dbo.CuentasBancarias TABLOCKX')
GO
ALTER TABLE dbo.Saldos
	DROP CONSTRAINT FK_Saldos_CuentasBancarias
GO
ALTER TABLE dbo.MovimientosBancarios
	DROP CONSTRAINT FK_MovimientosBancarios_CuentasBancarias
GO
ALTER TABLE dbo.Chequeras
	DROP CONSTRAINT FK_Chequeras_CuentasBancarias
GO
DROP TABLE dbo.CuentasBancarias
GO
EXECUTE sp_rename N'dbo.Tmp_CuentasBancarias', N'CuentasBancarias', 'OBJECT'
GO
ALTER TABLE dbo.CuentasBancarias ADD CONSTRAINT
	PK_CuentasBancarias PRIMARY KEY NONCLUSTERED 
	(
	CuentaInterna
	) ON [PRIMARY]

GO
ALTER TABLE dbo.CuentasBancarias WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancarias_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	)
GO
ALTER TABLE dbo.CuentasBancarias WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancarias_Agencias FOREIGN KEY
	(
	Agencia
	) REFERENCES dbo.Agencias
	(
	Agencia
	)
GO
ALTER TABLE dbo.CuentasBancarias WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancarias_Monedas FOREIGN KEY
	(
	Moneda
	) REFERENCES dbo.Monedas
	(
	Moneda
	)
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Chequeras WITH NOCHECK ADD CONSTRAINT
	FK_Chequeras_CuentasBancarias FOREIGN KEY
	(
	NumeroCuenta
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	)
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.MovimientosBancarios WITH NOCHECK ADD CONSTRAINT
	FK_MovimientosBancarios_CuentasBancarias FOREIGN KEY
	(
	CuentaInterna
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	)
GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.Saldos WITH NOCHECK ADD CONSTRAINT
	FK_Saldos_CuentasBancarias FOREIGN KEY
	(
	CuentaBancaria
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	)
GO
COMMIT


--  ----------------------------------------------------
--  ponemos el nuevo valor del item en AC (activa) 
--  ----------------------------------------------------

Update CuentasBancarias Set Estado = 'AC' 

--  ----------------------------------------------------
--  hacemos el nuevo item not null 
--  ----------------------------------------------------

Alter Table CuentasBancarias Alter Column Estado Char(2) Not Null 



--  ----------------------------------------------------
--  actualizamos los views que corresponden a la tabla 
--  ----------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaCuentasBancarias]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaCuentasBancarias]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qFormaCuentasBancariasConsulta]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qFormaCuentasBancariasConsulta]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaCuentasBancarias    Script Date: 28/11/00 07:01:23 p.m. *****
***** Object:  View dbo.qFormaCuentasBancarias    Script Date: 08/nov/00 9:01:18 *****
***** Object:  View dbo.qFormaCuentasBancarias    Script Date: 30/sep/00 1:10:01 ******/
CREATE VIEW dbo.qFormaCuentasBancarias
AS
SELECT     dbo.CuentasBancarias.CuentaInterna, dbo.CuentasBancarias.Agencia, dbo.CuentasBancarias.CuentaBancaria, dbo.CuentasBancarias.Tipo, 
                      dbo.CuentasBancarias.Moneda, dbo.CuentasBancarias.LineaCredito, dbo.CuentasBancarias.Estado, dbo.CuentasBancarias.Banco, 
                      dbo.Bancos.Nombre AS NombreBanco, dbo.CuentasBancarias.CuentaContable, dbo.CuentasBancarias.CuentaContableGastosIDB, 
                      dbo.CuentasBancarias.FormatoImpresionCheque, dbo.CuentasBancarias.GenerarTransaccionesAOtraCuentaFlag, 
                      dbo.CuentasBancarias.CuentaBancariaAsociada, dbo.CuentasBancarias.NombrePlantillaWord, dbo.CuentasBancarias.Cia
FROM         dbo.CuentasBancarias LEFT OUTER JOIN
                      dbo.Bancos ON dbo.CuentasBancarias.Banco = dbo.Bancos.Banco

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qFormaCuentasBancariasConsulta    Script Date: 28/11/00 07:01:24 p.m. *****
***** Object:  View dbo.qFormaCuentasBancariasConsulta    Script Date: 08/nov/00 9:01:18 *****
***** Object:  View dbo.qFormaCuentasBancariasConsulta    Script Date: 30/sep/00 1:10:01 ******/
CREATE VIEW dbo.qFormaCuentasBancariasConsulta
AS
SELECT     dbo.CuentasBancarias.CuentaInterna, dbo.CuentasBancarias.Agencia, dbo.Agencias.Nombre AS NombreAgencia, 
                      dbo.CuentasBancarias.CuentaBancaria, dbo.CuentasBancarias.Tipo, dbo.CuentasBancarias.Moneda, dbo.Monedas.Simbolo AS SimboloMoneda, 
                      dbo.CuentasBancarias.LineaCredito, dbo.CuentasBancarias.Estado, dbo.CuentasBancarias.Banco, dbo.Bancos.Nombre AS NombreBanco, 
                      dbo.CuentasBancarias.CuentaContable, dbo.CuentasBancarias.CuentaContableGastosIDB, dbo.CuentasBancarias.FormatoImpresionCheque, 
                      dbo.CuentasBancarias.GenerarTransaccionesAOtraCuentaFlag, dbo.CuentasBancarias.CuentaBancariaAsociada, 
                      dbo.CuentasBancarias.NombrePlantillaWord, dbo.CuentasBancarias.Cia
FROM         dbo.CuentasBancarias INNER JOIN
                      dbo.Bancos ON dbo.CuentasBancarias.Banco = dbo.Bancos.Banco INNER JOIN
                      dbo.Agencias ON dbo.CuentasBancarias.Agencia = dbo.Agencias.Agencia INNER JOIN
                      dbo.Monedas ON dbo.CuentasBancarias.Moneda = dbo.Monedas.Moneda

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[qReportDisponibilidad]') and OBJECTPROPERTY(id, N'IsView') = 1)
drop view [dbo].[qReportDisponibilidad]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

/****** Object:  View dbo.qReportDisponibilidad    Script Date: 28/11/00 07:01:24 p.m. *****
***** Object:  View dbo.qReportDisponibilidad    Script Date: 08/nov/00 9:01:18 ******/
CREATE VIEW dbo.qReportDisponibilidad
AS
SELECT     dbo.Monedas.Moneda, dbo.Monedas.Descripcion AS NombreMoneda, dbo.Bancos.Banco, dbo.Bancos.Nombre AS NombreBanco, 
                      dbo.CuentasBancarias.CuentaBancaria, dbo.CuentasBancarias.CuentaInterna, dbo.CuentasBancarias.LineaCredito, dbo.CuentasBancarias.Cia, 
                      dbo.CuentasBancarias.Estado
FROM         dbo.CuentasBancarias LEFT OUTER JOIN
                      dbo.Bancos ON dbo.CuentasBancarias.Banco = dbo.Bancos.Banco LEFT OUTER JOIN
                      dbo.Monedas ON dbo.CuentasBancarias.Moneda = dbo.Monedas.Moneda

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.127', GetDate()) 
