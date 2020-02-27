/*    Jueves, 29 de Diciembre de 2.011  -   v0.00.299.sql 

	Hacemos cambios menores al control de caja chica 
	.- la fecha en reposiciones es ahora Date 
	.- agregamos un tipo de asiento 'default' en ParametrosContab
	   para los asientos de caja chica.  
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
ALTER TABLE dbo.ParametrosContab
	DROP CONSTRAINT FK_ParametrosContab_Companias
GO
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Reposiciones
	DROP CONSTRAINT FK_CajaChica_Reposiciones_CajaChica_CajasChicas
GO
ALTER TABLE dbo.CajaChica_CajasChicas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.TiposDeAsiento SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_ParametrosContab
	(
	Activo1 int NULL,
	Activo2 int NULL,
	Activo3 int NULL,
	Activo4 int NULL,
	Activo5 int NULL,
	Activo6 int NULL,
	Pasivo1 int NULL,
	Pasivo2 int NULL,
	Pasivo3 int NULL,
	Pasivo4 int NULL,
	Pasivo5 int NULL,
	Pasivo6 int NULL,
	Capital1 int NULL,
	Capital2 int NULL,
	Capital3 int NULL,
	Capital4 int NULL,
	Capital5 int NULL,
	Capital6 int NULL,
	Ingresos1 int NULL,
	Ingresos2 int NULL,
	Ingresos3 int NULL,
	Ingresos4 int NULL,
	Ingresos5 int NULL,
	Ingresos6 int NULL,
	Egresos1 int NULL,
	Egresos2 int NULL,
	Egresos3 int NULL,
	Egresos4 int NULL,
	Egresos5 int NULL,
	Egresos6 int NULL,
	CuentaGyP int NULL,
	MultiMoneda bit NULL,
	Moneda1 int NULL,
	Moneda2 int NULL,
	Moneda3 int NULL,
	Moneda4 int NULL,
	Moneda5 int NULL,
	CambiarFactorAlAgregarFlag bit NULL,
	CambiarFactorAlModFlag bit NULL,
	NumeracionAsientosSeparadaFlag bit NULL,
	OrganizarPartidasDelAsiento bit NULL,
	CargarAsientosConNumeroNegativoFlag bit NULL,
	DirectorioAsientosOtrasAplicaciones nvarchar(250) NULL,
	CuentaPuenteCajaChica int NULL,
	CajaChica_TipoAsiento nvarchar(6) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_ParametrosContab SET (LOCK_ESCALATION = TABLE)
GO
IF EXISTS(SELECT * FROM dbo.ParametrosContab)
	 EXEC('INSERT INTO dbo.Tmp_ParametrosContab (Activo1, Activo2, Activo3, Activo4, Activo5, Activo6, Pasivo1, Pasivo2, Pasivo3, Pasivo4, Pasivo5, Pasivo6, Capital1, Capital2, Capital3, Capital4, Capital5, Capital6, Ingresos1, Ingresos2, Ingresos3, Ingresos4, Ingresos5, Ingresos6, Egresos1, Egresos2, Egresos3, Egresos4, Egresos5, Egresos6, CuentaGyP, MultiMoneda, Moneda1, Moneda2, Moneda3, Moneda4, Moneda5, CambiarFactorAlAgregarFlag, CambiarFactorAlModFlag, NumeracionAsientosSeparadaFlag, OrganizarPartidasDelAsiento, CargarAsientosConNumeroNegativoFlag, DirectorioAsientosOtrasAplicaciones, CuentaPuenteCajaChica, Cia)
		SELECT Activo1, Activo2, Activo3, Activo4, Activo5, Activo6, Pasivo1, Pasivo2, Pasivo3, Pasivo4, Pasivo5, Pasivo6, Capital1, Capital2, Capital3, Capital4, Capital5, Capital6, Ingresos1, Ingresos2, Ingresos3, Ingresos4, Ingresos5, Ingresos6, Egresos1, Egresos2, Egresos3, Egresos4, Egresos5, Egresos6, CuentaGyP, MultiMoneda, Moneda1, Moneda2, Moneda3, Moneda4, Moneda5, CambiarFactorAlAgregarFlag, CambiarFactorAlModFlag, NumeracionAsientosSeparadaFlag, OrganizarPartidasDelAsiento, CargarAsientosConNumeroNegativoFlag, DirectorioAsientosOtrasAplicaciones, CuentaPuenteCajaChica, Cia FROM dbo.ParametrosContab WITH (HOLDLOCK TABLOCKX)')
GO
DROP TABLE dbo.ParametrosContab
GO
EXECUTE sp_rename N'dbo.Tmp_ParametrosContab', N'ParametrosContab', 'OBJECT' 
GO
ALTER TABLE dbo.ParametrosContab ADD CONSTRAINT
	PK_ParametrosContab PRIMARY KEY NONCLUSTERED 
	(
	Cia
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.ParametrosContab ADD CONSTRAINT
	FK_ParametrosContab_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.ParametrosContab ADD CONSTRAINT
	FK_ParametrosContab_TiposDeAsiento FOREIGN KEY
	(
	CajaChica_TipoAsiento
	) REFERENCES dbo.TiposDeAsiento
	(
	Tipo
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CajaChica_Reposiciones
	(
	Reposicion int NOT NULL IDENTITY (1, 1),
	Fecha date NOT NULL,
	CajaChica smallint NOT NULL,
	Observaciones nvarchar(250) NULL,
	EstadoActual char(2) NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CajaChica_Reposiciones SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_CajaChica_Reposiciones ON
GO
IF EXISTS(SELECT * FROM dbo.CajaChica_Reposiciones)
	 EXEC('INSERT INTO dbo.Tmp_CajaChica_Reposiciones (Reposicion, Fecha, CajaChica, Observaciones, EstadoActual)
		SELECT Reposicion, CONVERT(date, Fecha), CajaChica, Observaciones, EstadoActual FROM dbo.CajaChica_Reposiciones WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_CajaChica_Reposiciones OFF
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Estados
	DROP CONSTRAINT FK_CajaChica_Reposiciones_Estados_CajaChica_Reposiciones
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos
	DROP CONSTRAINT FK_CajaChica_Reposiciones_Gastos_CajaChica_Reposiciones
GO
DROP TABLE dbo.CajaChica_Reposiciones
GO
EXECUTE sp_rename N'dbo.Tmp_CajaChica_Reposiciones', N'CajaChica_Reposiciones', 'OBJECT' 
GO
ALTER TABLE dbo.CajaChica_Reposiciones ADD CONSTRAINT
	PK_CajaChica_Reposiciones_1 PRIMARY KEY CLUSTERED 
	(
	Reposicion
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CajaChica_Reposiciones ADD CONSTRAINT
	FK_CajaChica_Reposiciones_CajaChica_CajasChicas FOREIGN KEY
	(
	CajaChica
	) REFERENCES dbo.CajaChica_CajasChicas
	(
	CajaChica
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos ADD CONSTRAINT
	FK_CajaChica_Reposiciones_Gastos_CajaChica_Reposiciones FOREIGN KEY
	(
	Reposicion
	) REFERENCES dbo.CajaChica_Reposiciones
	(
	Reposicion
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Estados ADD CONSTRAINT
	FK_CajaChica_Reposiciones_Estados_CajaChica_Reposiciones FOREIGN KEY
	(
	Reposicion
	) REFERENCES dbo.CajaChica_Reposiciones
	(
	Reposicion
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Estados SET (LOCK_ESCALATION = TABLE)
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
ALTER TABLE dbo.Companias SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CuentasContables SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ParametrosContab
	DROP CONSTRAINT FK_ParametrosContab_TiposDeAsiento
GO
ALTER TABLE dbo.TiposDeAsiento SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.CajaChica_Parametros
	(
	ID int NOT NULL IDENTITY (1, 1),
	TipoAsiento nvarchar(6) NOT NULL,
	CuentaContablePuenteID int NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.CajaChica_Parametros ADD CONSTRAINT
	PK_CajaChica_Parametros PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CajaChica_Parametros ADD CONSTRAINT
	FK_CajaChica_Parametros_TiposDeAsiento FOREIGN KEY
	(
	TipoAsiento
	) REFERENCES dbo.TiposDeAsiento
	(
	Tipo
	) ON UPDATE  CASCADE 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CajaChica_Parametros ADD CONSTRAINT
	FK_CajaChica_Parametros_CuentasContables FOREIGN KEY
	(
	CuentaContablePuenteID
	) REFERENCES dbo.CuentasContables
	(
	ID
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CajaChica_Parametros ADD CONSTRAINT
	FK_CajaChica_Parametros_Companias FOREIGN KEY
	(
	Cia
	) REFERENCES dbo.Companias
	(
	Numero
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CajaChica_Parametros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.ParametrosContab
	DROP COLUMN CuentaPuenteCajaChica, CajaChica_TipoAsiento
GO
ALTER TABLE dbo.ParametrosContab SET (LOCK_ESCALATION = TABLE)
GO
COMMIT



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.299', GetDate()) 