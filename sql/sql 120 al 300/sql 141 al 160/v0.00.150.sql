/*    Lunes, 14 de Abril del 2003   -   v0.00.150.sql 

	Agregamos un constraint para que el item FactorDeCambio en las tablas 
	Asientos y dAsientos no pueda contener nulls. Además, creamos la tabla 
	OpcionesPermitidasPorGrupoWeb. 

	También hacemos un cambio menor al stored procedure: spGetCompaniasByPage. 

*/ 

--  ------------------------
--  Asientos
--  ------------------------


--  ----------------------------------------------------------------------
--  por si acaso, actualizamos algun factor de cambio que este en nulls
--  de no hacerlo, lo que sigue fallará 
--  ----------------------------------------------------------------------

Update Asientos Set FactorDeCambio = 1 Where FactorDeCambio Is Null
Update dAsientos Set FactorDeCambio = 1 Where FactorDeCambio Is Null

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
CREATE TABLE dbo.Tmp_Asientos
	(
	NumeroAutomatico int NOT NULL,
	Numero smallint NOT NULL,
	Mes tinyint NOT NULL,
	Ano smallint NOT NULL,
	Tipo nvarchar(6) NOT NULL,
	Fecha datetime NOT NULL,
	Descripcion nvarchar(250) NULL,
	NumPartidas smallint NOT NULL,
	TotalDebe money NOT NULL,
	TotalHaber money NOT NULL,
	Moneda int NOT NULL,
	MonedaOriginal int NOT NULL,
	ConvertirFlag bit NULL,
	FactorDeCambio money NOT NULL,
	ProvieneDe nvarchar(25) NULL,
	Ingreso datetime NOT NULL,
	UltAct datetime NOT NULL,
	CopiableFlag bit NULL,
	MesFiscal smallint NOT NULL,
	AnoFiscal smallint NOT NULL,
	Usuario nvarchar(25) NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.Asientos)
	 EXEC('INSERT INTO dbo.Tmp_Asientos (NumeroAutomatico, Numero, Mes, Ano, Tipo, Fecha, Descripcion, NumPartidas, TotalDebe, TotalHaber, Moneda, MonedaOriginal, ConvertirFlag, FactorDeCambio, ProvieneDe, Ingreso, UltAct, CopiableFlag, MesFiscal, AnoFiscal, Usuario, Cia)
		SELECT NumeroAutomatico, Numero, Mes, Ano, Tipo, Fecha, Descripcion, NumPartidas, TotalDebe, TotalHaber, Moneda, MonedaOriginal, ConvertirFlag, FactorDeCambio, ProvieneDe, Ingreso, UltAct, CopiableFlag, MesFiscal, AnoFiscal, Usuario, Cia FROM dbo.Asientos TABLOCKX')
GO
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_Asientos
GO
DROP TABLE dbo.Asientos
GO
EXECUTE sp_rename N'dbo.Tmp_Asientos', N'Asientos', 'OBJECT'
GO
ALTER TABLE dbo.Asientos ADD CONSTRAINT
	PK_Asientos PRIMARY KEY NONCLUSTERED 
	(
	NumeroAutomatico
	) ON [PRIMARY]

GO
ALTER TABLE dbo.Asientos ADD CONSTRAINT
	IX_Asientos UNIQUE NONCLUSTERED 
	(
	Numero,
	Mes,
	Ano,
	Moneda,
	Cia
	) ON [PRIMARY]

GO
COMMIT
BEGIN TRANSACTION
ALTER TABLE dbo.dAsientos WITH NOCHECK ADD CONSTRAINT
	FK_dAsientos_Asientos FOREIGN KEY
	(
	NumeroAutomatico
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	)
GO
COMMIT



--  ------------------------
--  dAsientos
--  ------------------------



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
ALTER TABLE dbo.dAsientos
	DROP CONSTRAINT FK_dAsientos_Asientos
GO
COMMIT
BEGIN TRANSACTION
CREATE TABLE dbo.Tmp_dAsientos
	(
	NumeroAutomatico int NOT NULL,
	Numero smallint NOT NULL,
	Mes tinyint NOT NULL,
	Ano smallint NOT NULL,
	Fecha datetime NOT NULL,
	Moneda int NOT NULL,
	MonedaOriginal int NOT NULL,
	ConvertirFlag bit NULL,
	FactorDeCambio money NOT NULL,
	Partida smallint NOT NULL,
	Cuenta nvarchar(25) NOT NULL,
	Descripcion nvarchar(50) NULL,
	Referencia nvarchar(20) NULL,
	Debe money NOT NULL,
	Haber money NOT NULL,
	MesFiscal smallint NOT NULL,
	AnoFiscal smallint NOT NULL,
	Cia int NOT NULL
	)  ON [PRIMARY]
GO
IF EXISTS(SELECT * FROM dbo.dAsientos)
	 EXEC('INSERT INTO dbo.Tmp_dAsientos (NumeroAutomatico, Numero, Mes, Ano, Fecha, Moneda, MonedaOriginal, ConvertirFlag, FactorDeCambio, Partida, Cuenta, Descripcion, Referencia, Debe, Haber, MesFiscal, AnoFiscal, Cia)
		SELECT NumeroAutomatico, Numero, Mes, Ano, Fecha, Moneda, MonedaOriginal, ConvertirFlag, FactorDeCambio, Partida, Cuenta, Descripcion, Referencia, Debe, Haber, MesFiscal, AnoFiscal, Cia FROM dbo.dAsientos TABLOCKX')
GO
DROP TABLE dbo.dAsientos
GO
EXECUTE sp_rename N'dbo.Tmp_dAsientos', N'dAsientos', 'OBJECT'
GO
ALTER TABLE dbo.dAsientos ADD CONSTRAINT
	PK_dAsientos PRIMARY KEY NONCLUSTERED 
	(
	NumeroAutomatico,
	Partida
	) ON [PRIMARY]

GO
CREATE NONCLUSTERED INDEX IX_dAsientos ON dbo.dAsientos
	(
	NumeroAutomatico
	) ON [PRIMARY]
GO
ALTER TABLE dbo.dAsientos WITH NOCHECK ADD CONSTRAINT
	FK_dAsientos_Asientos FOREIGN KEY
	(
	NumeroAutomatico
	) REFERENCES dbo.Asientos
	(
	NumeroAutomatico
	)
GO
COMMIT



--  ------------------------
--  OpcionesPermitidasPorGrupoWeb
--  ------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[OpcionesPermitidasPorGrupoWeb]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[OpcionesPermitidasPorGrupoWeb]
GO

CREATE TABLE [dbo].[OpcionesPermitidasPorGrupoWeb] (
	[ClaveUnica] [int] IDENTITY (1, 1) NOT NULL ,
	[Grupo] [int] NOT NULL ,
	[OpcionId] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[OpcionesPermitidasPorGrupoWeb] WITH NOCHECK ADD 
	CONSTRAINT [PK_OpcionesPermitidasPorGrupoWeb] PRIMARY KEY  CLUSTERED 
	(
		[ClaveUnica]
	)  ON [PRIMARY] 
GO


--  ------------------------
--  spGetCompaniasByPage
--  ------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spGetCompaniasByPage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spGetCompaniasByPage]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO



CREATE PROCEDURE spGetCompaniasByPage  
    
@nCurrentPage Int , @nPageSize Int, 
@sSqlSelectString nVarChar(3000), @nTotalRecs Int Output

AS
	
/* SET NOCOUNT ON */


-- --------------------------------------------------------------------------------------------------------------------------
-- creamos una tabla temporal identica a la tabla que queremos leer, pero con un item Identity adicional 
-- --------------------------------------------------------------------------------------------------------------------------


Create Table #CompaniasTemp 
( 

	RecordId		Int Identity Primary Key, 
	Proveedor		int, 		
	Nombre			nvarchar(50) ,
	NombreTipo		nvarchar(50), 
	Direccion		nvarchar(255), 
	NombreCiudad	nvarchar(50),		
	Telefono1		nvarchar(14), 	
	Telefono2 		nVarChar(14), 
	Fax			nVarChar(14) 
			
) 


-- --------------------------------------------------------------------------------------------------------------------------
-- agregamos a la tabla temporal los registros de la tabla que queremos leer. Notese como aplicamos el 
-- filtro y ordenamos los registros antes. Usamos un Execute para poder ejecutar la instrucci>n Sql constru-da 
-- en forma din mica. 
-- --------------------------------------------------------------------------------------------------------------------------

Execute (
'Insert Into #CompaniasTemp (Proveedor, Nombre, NombreTipo, Direccion, NombreCiudad, Telefono1, Telefono2, Fax) '  + 
 @sSqlSelectString 
)

-- --------------------------------------------------------------------------------------------------------------------------
-- declaramos dos variables para guardar el primer y ultimo registro de la pagina que quiere ver el 
-- usuario 
-- --------------------------------------------------------------------------------------------------------------------------


Declare @nFirstRec Int, @nLastRec Int

Select @nFirstRec = (@nCurrentPage - 1) * @nPageSize
Select @nLastRec = @nCurrentPage * @nPageSize + 1 

-- --------------------------------------------------------------------------------------------------------------------------
-- leemos de la tabla temporal los registros que corresponden a la p gina 
-- n>tese como los registros ya vienen ordenados pues as- los grabamos a la tabla 
-- --------------------------------------------------------------------------------------------------------------------------


Select * From #CompaniasTemp 
Where RecordId > @nFirstRec And RecordId < @nLastRec

-- --------------------------------------------------------------------------------------------------------------------------
-- determinamos el numero total de registros seleccionados, para regresarlo como un par metro de este procedimiento 
-- --------------------------------------------------------------------------------------------------------------------------

Select @nTotalRecs = Count(*) From #CompaniasTemp 

Drop Table #CompaniasTemp


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.150', GetDate()) 

