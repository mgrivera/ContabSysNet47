/*    
	  Jueves, 23 de Noviembre de 2.023  -   v0.00.452.sql 
	  
	  Agregamos una tabla (temp) para registrar los movimientos y su saldo inicial 
	  cuando corremos el proceso que construye los estados de cuenta 
*/



-- Drop a table if it exists using OBJECT_ID
IF OBJECT_ID('dbo.tmp_bancos_cuentasBancarias_edosCuenta', 'U') IS NOT NULL
  DROP TABLE dbo.tmp_bancos_cuentasBancarias_edosCuenta;

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
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.tmp_bancos_cuentasBancarias_edosCuenta
	(
	id int NOT NULL IDENTITY (1, 1),
	cuentaBancaria int NOT NULL,
	numero smallint NOT NULL,
	fecha datetime NOT NULL,
	referencia bigint NOT NULL,
	descripcion nvarchar(250) NOT NULL,
	debe money NOT NULL,
	haber money NOT NULL,
	saldo money NOT NULL,
	usuario nvarchar(125) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.tmp_bancos_cuentasBancarias_edosCuenta ADD CONSTRAINT
	PK_tmp_bancos_cuentasBancarias_edosCuenta PRIMARY KEY CLUSTERED 
	(
	id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.tmp_bancos_cuentasBancarias_edosCuenta ADD CONSTRAINT
	FK_tmp_bancos_cuentasBancarias_edosCuenta_CuentasBancarias FOREIGN KEY
	(
	cuentaBancaria
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.tmp_bancos_cuentasBancarias_edosCuenta SET (LOCK_ESCALATION = TABLE)
GO
COMMIT


-- **********************************************************************
-- v_bancos_cuentasBancarias_edosCuenta
-- **********************************************************************

-- Drop a view if it exists using OBJECT_ID
IF OBJECT_ID('dbo.v_bancos_cuentasBancarias_edosCuenta ', 'V') IS NOT NULL
  DROP VIEW dbo.v_bancos_cuentasBancarias_edosCuenta;

GO

Create View dbo.v_bancos_cuentasBancarias_edosCuenta  As 
  
Select t.id, cb.CuentaInterna as cuentaBancariaId, cb.CuentaBancaria as cuentaBancaria, 
m.Moneda as monedaId, m.Descripcion as monedaDescripcion, m.Simbolo as monedaSimbolo, 
t.numero, t.fecha, t.referencia, t.descripcion, t.debe, t.haber, t.saldo, t.usuario, 
c.Numero as ciaContabId, c.Nombre as ciaContabNombre, c.Abreviatura as ciaContabAbreviatura  
From tmp_bancos_cuentasBancarias_edosCuenta t 
Inner Join CuentasBancarias cb On t.cuentaBancaria = cb.CuentaInterna 
Inner Join Monedas m On cb.Moneda = m.Moneda 
Inner Join Companias c On cb.Cia = c.Numero 

Go

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.452', GetDate()) 