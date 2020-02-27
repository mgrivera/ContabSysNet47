/*    Viernes, 14 de Febrero de 2.014 	-   v0.00.368b.sql 

	Cambios para implementar mejoras en retenciones de impuesto ... 
	Agregamos registros, para cada factura, a la tabla: Facturas_Impuestos 
*/


	/* con el código que sigue, intentamos agregar, para cada factura registrada, registros a la tabla: 
	   Facturas_Impuestos. A esta tabla agregamos registros para: impuesto iva, retencion iva y 
	   retención islr. */ 
   	   
	
	DECLARE @DefinicionImpuestoIva int;
	DECLARE @DefinicionRetencionIva int;
	DECLARE @DefinicionRetencionISLR int;

	Declare @ClaveUnica int, @MontoFacturaConIva money, @IvaPorc decimal(6,3), @Iva money; 
	Declare @RetencionSobreIvaPorc decimal(6,3), @RetencionSobreIva money, @FRecepcionRetencionIva date; 
	Declare @CodigoConceptoRetencion nvarchar(6), @MontoSujetoARetencion money, @ImpuestoRetenidoPorc decimal(6,3); 
	Declare @ImpuestoRetenidoISLRAntesSustraendo money, @ImpuestoRetenidoISLRSustraendo money, @ImpuestoRetenido money; 
	Declare @FRecepcionRetencionISLR date, @TipoAlicuota char(1); 

	Select @DefinicionImpuestoIva = ID From ImpuestosRetencionesDefinicion Where Predefinido = 1
	Select @DefinicionRetencionIva = ID From ImpuestosRetencionesDefinicion Where Predefinido = 2
	Select @DefinicionRetencionISLR = ID From ImpuestosRetencionesDefinicion Where Predefinido = 3

	

	DECLARE db_cursor CURSOR FOR  
		SELECT 
	ClaveUnica, MontoFacturaConIva, IvaPorc, Iva, 
	RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIva,  
	CodigoConceptoRetencion, MontoSujetoARetencion, ImpuestoRetenidoPorc, 
	ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, 
	FRecepcionRetencionISLR, TipoAlicuota
		FROM Facturas 
				
	OPEN db_cursor 
	  
	FETCH NEXT FROM db_cursor INTO 
			@ClaveUnica, @MontoFacturaConIva, @IvaPorc, @Iva, 
			@RetencionSobreIvaPorc, @RetencionSobreIva, @FRecepcionRetencionIva,  
			@CodigoConceptoRetencion, @MontoSujetoARetencion, @ImpuestoRetenidoPorc, 
			@ImpuestoRetenidoISLRAntesSustraendo, @ImpuestoRetenidoISLRSustraendo, @ImpuestoRetenido, 
			@FRecepcionRetencionISLR, @TipoAlicuota


	WHILE @@FETCH_STATUS = 0   
	BEGIN   
 
		if (@Iva Is Not Null And @Iva <> 0) 
		begin 

			Insert Into Facturas_Impuestos 
			(FacturaID, ImpRetID, TipoAlicuota, MontoBase, Porcentaje, MontoAntesSustraendo, Sustraendo, Monto, FechaRecepcionPlanilla) 
			Values 
			(@ClaveUnica, @DefinicionImpuestoIva, @TipoAlicuota, @MontoFacturaConIva, @IvaPorc, @Iva, 0, @Iva, Null) 

		end 	

		if (@RetencionSobreIva Is Not Null And @RetencionSobreIva <> 0) 
		begin 

			Insert Into Facturas_Impuestos 
			(FacturaID, ImpRetID, MontoBase, Porcentaje, MontoAntesSustraendo, Sustraendo, Monto, FechaRecepcionPlanilla) 
			Values 
			(@ClaveUnica, @DefinicionRetencionIva, @Iva, @RetencionSobreIvaPorc, @RetencionSobreIva, 0, @RetencionSobreIva, 
			 @FRecepcionRetencionIva) 

		end 


		if (@ImpuestoRetenido Is Not Null And @ImpuestoRetenido <> 0) 
		begin 

			Insert Into Facturas_Impuestos 
			(FacturaID, ImpRetID, Codigo, MontoBase, Porcentaje, MontoAntesSustraendo, Sustraendo, Monto, FechaRecepcionPlanilla) 
			Values 
			(@ClaveUnica, @DefinicionRetencionISLR, @CodigoConceptoRetencion, 
			 @MontoSujetoARetencion, @ImpuestoRetenidoPorc, @ImpuestoRetenidoISLRAntesSustraendo, @ImpuestoRetenidoISLRSustraendo, 
			 @ImpuestoRetenido, 
			 @FRecepcionRetencionISLR) 

		end 	

		FETCH NEXT FROM db_cursor INTO 
			@ClaveUnica, @MontoFacturaConIva, @IvaPorc, @Iva, 
			@RetencionSobreIvaPorc, @RetencionSobreIva, @FRecepcionRetencionIva,  
			@CodigoConceptoRetencion, @MontoSujetoARetencion, @ImpuestoRetenidoPorc, 
			@ImpuestoRetenidoISLRAntesSustraendo, @ImpuestoRetenidoISLRSustraendo, @ImpuestoRetenido, 
			@FRecepcionRetencionISLR, @TipoAlicuota
	
	END   

	CLOSE db_cursor   
	DEALLOCATE db_cursor


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.368b', GetDate()) 
