/*    
	  Jueves, 7 de Octubre de 2.021  -   v0.00.432.sql 
	  
	  Agregamos la columna Fecha a la tabla Contab_ConsultaCuentasYMovimientos
	  La idea es poder reconvertir los montos en la consulta:  
	  Cuentas y sus Movimientos / Por la reconversión de Oct/2021 
*/

Delete from Contab_ConsultaCuentasYMovimientos_Movimientos

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
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos_Movimientos
	DROP CONSTRAINT FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos
GO
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_Contab_ConsultaCuentasYMovimientos_Movimientos
	(
	ID int NOT NULL IDENTITY (1, 1),
	ParentID int NOT NULL,
	Secuencia smallint NOT NULL,
	AsientoID int NOT NULL,
	CuentaContableID int NOT NULL,
	Partida smallint NULL,
	Fecha date NOT NULL,
	Referencia nvarchar(20) NULL,
	Descripcion nvarchar(300) NOT NULL,
	Monto money NOT NULL,
	CentroCostoAbreviatura nvarchar(3) NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_Contab_ConsultaCuentasYMovimientos_Movimientos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_Contab_ConsultaCuentasYMovimientos_Movimientos ON
GO
IF EXISTS(SELECT * FROM dbo.Contab_ConsultaCuentasYMovimientos_Movimientos)
	 EXEC('INSERT INTO dbo.Tmp_Contab_ConsultaCuentasYMovimientos_Movimientos (ID, ParentID, Secuencia, AsientoID, CuentaContableID, Partida, Referencia, Descripcion, Monto, CentroCostoAbreviatura)
		SELECT ID, ParentID, Secuencia, AsientoID, CuentaContableID, Partida, Referencia, Descripcion, Monto, CentroCostoAbreviatura FROM dbo.Contab_ConsultaCuentasYMovimientos_Movimientos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_Contab_ConsultaCuentasYMovimientos_Movimientos OFF
GO
DROP TABLE dbo.Contab_ConsultaCuentasYMovimientos_Movimientos
GO
EXECUTE sp_rename N'dbo.Tmp_Contab_ConsultaCuentasYMovimientos_Movimientos', N'Contab_ConsultaCuentasYMovimientos_Movimientos', 'OBJECT' 
GO
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos_Movimientos ADD CONSTRAINT
	PK_Contab_ConsultaCuentasYMovimientos_Movimientos_1 PRIMARY KEY CLUSTERED 
	(
	ID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Contab_ConsultaCuentasYMovimientos_Movimientos ADD CONSTRAINT
	FK_Contab_ConsultaCuentasYMovimientos_Movimientos_Contab_ConsultaCuentasYMovimientos FOREIGN KEY
	(
	ParentID
	) REFERENCES dbo.Contab_ConsultaCuentasYMovimientos
	(
	ID
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.432', GetDate()) 