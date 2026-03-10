/*    
	  Domingo, 25 de Enero de 2.026  -   v0.00.471.sql 
	  
	  Agregamos la tabla Logging_Facturas 

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
CREATE TABLE dbo.Logging_Facturas
	(
	Id int NOT NULL IDENTITY (1, 1),
	ItemId int NOT NULL,
	Numero nvarchar(25) NULL,
	Control nvarchar(25) NULL,
	FechaEmision date NULL,
	FechaRecepcion date NULL,
	NcNdFlag char(2) NULL,
	NumeroFacturaAfectada nvarchar(25) NULL,
	Compania nvarchar(150) NULL,
	CxCCxP smallint NULL,
	Descripcion nvarchar(MAX) NULL,
	MonedaId int NULL,
	MontoNoImponible money NULL,
	MontoImponible money NULL,
	IvaPorc decimal(5, 2) NULL,
	Iva money NULL,
	Total money NULL,
	RetencionSobreIva money NULL,
	RetencionSobreIslr money NULL,
	Usuario nvarchar(125) NULL,
	FechaRegistro datetime NULL,
	Cia int NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Logging_Facturas ADD CONSTRAINT
	PK_Logging_Facturas PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.Logging_Facturas SET (LOCK_ESCALATION = TABLE)
GO
COMMIT

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.471', GetDate()) 