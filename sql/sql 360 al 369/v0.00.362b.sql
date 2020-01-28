/*    Jueves, 21 de Noviembre de 2.013 	-   v0.00.362b.sql 

	Cambios básicos al registro de información para la contabilización de 
	depósitos de ventas con tarjetas de crédito ... 

	NOTA IMPORTANTE: revisar collation en las siguientes tables: CuentasBancariasCuentasContables y CuentasContables 

*/

Update cb Set cb.CuentaContableComision = cc.ID 
From CuentasBancariasCuentasContables cb Inner Join CuentasContables cc 
On cb.CiaContab = cc.Cia And cb.CuentaContableComision = cc.Cuenta 
Where cb.CuentaContableComision Is Not Null And rtrim(ltrim(cb.CuentaContableComision)) <> ''

Update cb Set cb.CuentaContableComision2 = cc.ID 
From CuentasBancariasCuentasContables cb Inner Join CuentasContables cc 
On cb.CiaContab = cc.Cia And cb.CuentaContableComision2 = cc.Cuenta 
Where cb.CuentaContableComision2 Is Not Null And rtrim(ltrim(cb.CuentaContableComision2)) <> ''

Update cb Set cb.CuentaContableImpuestos = cc.ID 
From CuentasBancariasCuentasContables cb Inner Join CuentasContables cc 
On cb.CiaContab = cc.Cia And cb.CuentaContableImpuestos = cc.Cuenta 
Where cb.CuentaContableImpuestos Is Not Null And rtrim(ltrim(cb.CuentaContableImpuestos)) <> ''

Update cb Set cb.CuentaContableCxC = cc.ID 
From CuentasBancariasCuentasContables cb Inner Join CuentasContables cc 
On cb.CiaContab = cc.Cia And cb.CuentaContableCxC = cc.Cuenta 
Where cb.CuentaContableCxC Is Not Null And rtrim(ltrim(cb.CuentaContableCxC)) <> ''














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
ALTER TABLE dbo.CuentasBancariasCuentasContables
	DROP CONSTRAINT FK_CuentasBancariasCuentasContables_CuentasBancarias
GO
ALTER TABLE dbo.CuentasBancarias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables
	DROP CONSTRAINT FK_CuentasBancariasCuentasContables_Tarjetas
GO
ALTER TABLE dbo.Tarjetas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CuentasBancariasCuentasContables
	(
	ID int NOT NULL IDENTITY (1, 1),
	CuentaInterna int NOT NULL,
	Tarjeta nvarchar(4) NOT NULL,
	CuentaContableComision int NULL,
	CuentaContableComision2 int NULL,
	CuentaContableImpuestos int NULL,
	CuentaContableCxC int NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CuentasBancariasCuentasContables SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_CuentasBancariasCuentasContables OFF
GO
IF EXISTS(SELECT * FROM dbo.CuentasBancariasCuentasContables)
	 EXEC('INSERT INTO dbo.Tmp_CuentasBancariasCuentasContables (CuentaInterna, Tarjeta, CuentaContableComision, CuentaContableComision2, CuentaContableImpuestos, CuentaContableCxC)
		SELECT CuentaInterna, Tarjeta, CONVERT(int, CuentaContableComision), CONVERT(int, CuentaContableComision2), CONVERT(int, CuentaContableImpuestos), CONVERT(int, CuentaContableCxC) FROM dbo.CuentasBancariasCuentasContables WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.CuentasBancariasCuentasContables
GO
EXECUTE sp_rename N'dbo.Tmp_CuentasBancariasCuentasContables', N'CuentasBancariasCuentasContables', 'OBJECT' 
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables ADD CONSTRAINT
	PK_CuentasBancariasCuentasContables PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CuentasBancariasCuentasContables WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancariasCuentasContables_Tarjetas FOREIGN KEY
	(
	Tarjeta
	) REFERENCES dbo.Tarjetas
	(
	Tarjeta
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables WITH NOCHECK ADD CONSTRAINT
	FK_CuentasBancariasCuentasContables_CuentasBancarias FOREIGN KEY
	(
	CuentaInterna
	) REFERENCES dbo.CuentasBancarias
	(
	CuentaInterna
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables ADD CONSTRAINT
	FK_CuentasBancariasCuentasContables_CuentasContables FOREIGN KEY
	(
	CuentaContableComision
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables ADD CONSTRAINT
	FK_CuentasBancariasCuentasContables_CuentasContables1 FOREIGN KEY
	(
	CuentaContableComision2
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables ADD CONSTRAINT
	FK_CuentasBancariasCuentasContables_CuentasContables2 FOREIGN KEY
	(
	CuentaContableImpuestos
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CuentasBancariasCuentasContables ADD CONSTRAINT
	FK_CuentasBancariasCuentasContables_CuentasContables3 FOREIGN KEY
	(
	CuentaContableCxC
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.362b', GetDate()) 
