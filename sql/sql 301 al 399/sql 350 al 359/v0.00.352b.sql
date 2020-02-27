/*    Martes, 30 de Julio de 2.013 	-   v0.00.352b.sql 

	Cambios a la tabla tNomina 
*/

	/* leemos tNomina y agrupamos por FechaNomina / GrupoNomina / Cia
	    
	   La idea es que cada nómina ejecutada comparte estos valores, entonces podemos agrupara por ellos y obtener la 
	   información común para cada nómina. 
	   
	   Para cada nómina, entonces, agregaremos un registro a la nueva tabla tNominaHeaders, que va a ser un parent para 
	   tNomina. En esta tabla existirá un registro para cada nómina que se ejecute. 
    */ 
	   
	DECLARE @FechaNomina smalldatetime
	DECLARE @GrupoNomina Int
	DECLARE @Cia Int
	
	DECLARE @FechaEjecucion DateTime
	DECLARE @TipoNomina nvarchar(2)
	
	-- para capturar el Identity que se genera al grabara a tNominaHeaders 
	declare @IdentityOutput table ( ID int )
	declare @IdentityValue int


	DECLARE db_cursor CURSOR FOR  
		SELECT FechaNomina, FechaEjecucion, TipoNomina, GrupoNomina, Cia 
		FROM tNomina 
		Group By FechaNomina, FechaEjecucion, TipoNomina, GrupoNomina, Cia 
		Order By FechaNomina

	OPEN db_cursor   
	FETCH NEXT FROM db_cursor INTO @FechaNomina, @FechaEjecucion, @TipoNomina, @GrupoNomina, @Cia 

	WHILE @@FETCH_STATUS = 0   
	BEGIN   
 
			Insert Into tNominaHeaders (FechaNomina, FechaEjecucion, GrupoNomina, Tipo) 
				   output inserted.ID into @IdentityOutput
				   Values (@FechaNomina, @FechaEjecucion, @GrupoNomina, @TipoNomina) 
				   
			select @IdentityValue = (select Max(ID) from @IdentityOutput)
			
			-- actualizamos el HeaderID en tNomina con el valor generado para el Identity en tNominaHeaders 
			Update tNomina Set HeaderID = @IdentityValue 
						   Where FechaNomina = @FechaNomina And 
								 FechaEjecucion = @FechaEjecucion And 
								 TipoNomina = @TipoNomina And 
								 GrupoNomina = @GrupoNomina And
						         Cia = @Cia  
						         
						

		   FETCH NEXT FROM db_cursor INTO @FechaNomina, @FechaEjecucion, @TipoNomina, @GrupoNomina, @Cia 
	END   

	CLOSE db_cursor   
	DEALLOCATE db_cursor
	

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.352b', GetDate()) 