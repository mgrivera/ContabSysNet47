/*    Martes 24 de septiembre de 2002   -   v0.00.138.sql 

	Agregamos el stored procedure que permite 'paginar' las compañías, para mostrarlas 
	en un web page. 

*/ 


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spGetCompaniasByPage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spGetCompaniasByPage]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


CREATE PROCEDURE "spGetCompaniasByPage"  
    
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
	Nombre		nvarchar(50) ,
	NombreTipo		nvarchar(50), 
	NombreCiudad	nvarchar(50),		
	Telefono1		nvarchar(14), 	
	Telefono2 		nVarChar(14), 
	Fax			nVarChar(14) 
			
) 


-- --------------------------------------------------------------------------------------------------------------------------
-- agregamos a la tabla temporal los registros de la tabla que queremos leer. Notese como aplicamos el 
-- filtro y ordenamos los registros antes. Usamos un Execute para poder ejecutar la instrucci›n Sql constru­da 
-- en forma din mica. 
-- --------------------------------------------------------------------------------------------------------------------------

Execute (
'Insert Into #CompaniasTemp (Proveedor, Nombre, NombreTipo, NombreCiudad, Telefono1, Telefono2, Fax) '  + 
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
-- n›tese como los registros ya vienen ordenados pues as­ los grabamos a la tabla 
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
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.138', GetDate()) 

