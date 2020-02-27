/*    Jueves 19 de septiembre de 2002   -   v0.00.136.sql 

	Agregamos el stored procedure spGetPersonasByPage. 

*/ 



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[spGetPersonasByPage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[spGetPersonasByPage]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

CREATE PROCEDURE "spGetPersonasByPage"  
    
@nCurrentPage Int , @nPageSize Int, 
@sSqlSelectString nVarChar(3000), @nTotalRecs Int Output

AS
	
/* SET NOCOUNT ON */


-- --------------------------------------------------------------------------------------------------------------------------
-- creamos una tabla temporal identica a la tabla que queremos leer, pero con un item Identity adicional 
-- --------------------------------------------------------------------------------------------------------------------------


Create Table #PersonasTemp 
( 

	RecordId	Int Identity Primary Key, 
	Titulo	nvarchar(10) , 		
	Nombre	nvarchar(50) ,
	Apellido	nvarchar(50), 
	NombreCargo		nvarchar(50),		
	NombreCompania	nvarchar(50), 	
	Telefono nVarChar(25), 
	Fax	nVarChar(25), 
	Celular		nVarChar(25), 
	email	nVarChar(50) 
	
) 


-- --------------------------------------------------------------------------------------------------------------------------
-- agregamos a la tabla temporal los registros de la tabla que queremos leer. Notese como aplicamos el 
-- filtro y ordenamos los registros antes. Usamos un Execute para poder ejecutar la instrucci¢n Sql constru¡da 
-- en forma din mica. 
-- --------------------------------------------------------------------------------------------------------------------------

Execute (
'Insert Into #PersonasTemp (Titulo, Nombre, Apellido, NombreCargo, NombreCompania, Telefono, Fax, Celular, email) '  + 
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
-- n¢tese como los registros ya vienen ordenados pues as¡ los grabamos a la tabla 
-- --------------------------------------------------------------------------------------------------------------------------


Select * From #PersonasTemp 
Where RecordId > @nFirstRec And RecordId < @nLastRec

-- --------------------------------------------------------------------------------------------------------------------------
-- determinamos el numero total de registros seleccionados, para regresarlo como un par metro de este procedimiento 
-- --------------------------------------------------------------------------------------------------------------------------

Select @nTotalRecs = Count(*) From #PersonasTemp 

Drop Table #PersonasTemp
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersion 
Insert Into tVersion (VersionActual, Fecha) Values('v0.00.136', GetDate()) 

