/*    Martes, 19 de Mayo de 2.009  -   v0.00.249.sql 

	Hacemos algunas modificaciones a las tablas 
	Contab_ConsultaComprobantesContables y ..._Partidas 

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
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos
	DROP CONSTRAINT FK_CajaChica_Reposisiones_Gastos_CajaChica_Rubros
GO
ALTER TABLE dbo.CajaChica_Rubros SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos
	DROP CONSTRAINT FK_CajaChica_Reposisiones_Gastos_CajaChica_Reposiciones
GO
ALTER TABLE dbo.CajaChica_Reposiciones SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_CajaChica_Reposiciones_Gastos
	(
	ID int NOT NULL IDENTITY (1, 1),
	Reposicion int NOT NULL,
	CajaChica smallint NOT NULL,
	CiaContab int NOT NULL,
	Fecha smalldatetime NOT NULL,
	Rubro smallint NOT NULL,
	Descripcion nvarchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	Referencia nvarchar(20) NULL,
	Monto money NOT NULL,
	IvaPorc decimal(5, 2) NULL,
	Iva money NULL,
	Total money NOT NULL,
	NumeroDocumento nvarchar(25) NULL,
	NumeroControl nvarchar(20) NULL,
	Proveedor int NULL,
	Nombre nvarchar(50) NULL,
	Rif nvarchar(20) NULL,
	AfectaLibroCompras bit NOT NULL,
	NombreUsuario nvarchar(256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
	)  ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_CajaChica_Reposiciones_Gastos SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_CajaChica_Reposiciones_Gastos ON
GO
IF EXISTS(SELECT * FROM dbo.CajaChica_Reposiciones_Gastos)
	 EXEC('INSERT INTO dbo.Tmp_CajaChica_Reposiciones_Gastos (ID, Reposicion, CajaChica, CiaContab, Fecha, Rubro, Descripcion, Referencia, Monto, NombreUsuario, Total, AfectaLibroCompras)
		SELECT ID, Reposicion, CajaChica, CiaContab, Fecha, Rubro, Descripcion, Referencia, Monto, NombreUsuario, Monto, 0 FROM dbo.CajaChica_Reposiciones_Gastos WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_CajaChica_Reposiciones_Gastos OFF
GO
DROP TABLE dbo.CajaChica_Reposiciones_Gastos
GO
EXECUTE sp_rename N'dbo.Tmp_CajaChica_Reposiciones_Gastos', N'CajaChica_Reposiciones_Gastos', 'OBJECT' 
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos ADD CONSTRAINT
	PK_CajaChica_Reposisiones_Gastos PRIMARY KEY CLUSTERED 
	(
	ID,
	Reposicion,
	CajaChica,
	CiaContab
	) WITH( PAD_INDEX = OFF, FILLFACTOR = 90, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos ADD CONSTRAINT
	FK_CajaChica_Reposisiones_Gastos_CajaChica_Reposiciones FOREIGN KEY
	(
	Reposicion,
	CajaChica,
	CiaContab
	) REFERENCES dbo.CajaChica_Reposiciones
	(
	Reposicion,
	CajaChica,
	CiaContab
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos ADD CONSTRAINT
	FK_CajaChica_Reposisiones_Gastos_CajaChica_Rubros FOREIGN KEY
	(
	Rubro
	) REFERENCES dbo.CajaChica_Rubros
	(
	Rubro
	) ON UPDATE  CASCADE 
	 ON DELETE  CASCADE 
	
GO
COMMIT


--  ------------------------
--  para establecer una relación entre la tabla de gastos de caja chica y los proveedores; 
--  nota: el item Proveedor en la tabla CajaChica_Reposiciones_Gastos permite nulls 
--  ------------------------



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
ALTER TABLE dbo.Proveedores SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos ADD CONSTRAINT
	FK_CajaChica_Reposiciones_Gastos_Proveedores FOREIGN KEY
	(
	Proveedor
	) REFERENCES dbo.Proveedores
	(
	Proveedor
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
ALTER TABLE dbo.CajaChica_Reposiciones_Gastos SET (LOCK_ESCALATION = TABLE)
GO
COMMIT




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb 
Insert Into tVersionWeb (VersionActual, Fecha) Values('v0.00.249', GetDate()) 