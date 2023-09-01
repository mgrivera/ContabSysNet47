/*    
	  Lunes, 8 de Noviembre de 2.021  -   v0.00.433a.sql 
	  
	  Modificamos el stored procedure spBalanceGeneral para adaptarla a la reconversión 
	  en Oct/2021 
*/

IF OBJECT_ID('dbo.spBalanceGeneral_leerMovimientos', 'P') IS NOT NULL  
    DROP PROCEDURE [dbo].[spBalanceGeneral_leerMovimientos];  
GO  

Create PROCEDURE [dbo].[spBalanceGeneral_leerMovimientos]  
	-- Add the parameters for the stored procedure here
	@cuentaContableID int,
	@desde Date, 
	@hasta Date,
	@moneda int,
	@monedaOriginal int = Null, 
	@excluirAsientoTipoCierreAnual bit, 
	@reconvertirCifrasAntes_01Oct2021 bit, 
	@debe money out, 
	@haber money out, 
	@cantidadMovimientos smallint out, 
	@errorMessage nvarchar(500) out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @errorMessage = ''; 
	
	set @debe = 0; 
	set @haber = 0; 
	set @cantidadMovimientos = 0; 
	
	/* nótese que recibimos como parámetro si debemos o no leer asientos de tipo cierre anual */
	if (@excluirAsientoTipoCierreAnual = 1) 
		begin 
			if (@reconvertirCifrasAntes_01Oct2021 = 0) 
				begin 
					-- cuando el usuario NO reconvierte, leemos el asiento de reconversión 
					select @debe = sum(debe), @haber = SUM(haber), @cantidadMovimientos = COUNT(*) 	
					   from dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico 
					   where (dAsientos.CuentaContableID = @cuentaContableID) and (Asientos.Fecha between @desde and @hasta) and (Asientos.Moneda = @moneda) and 
							 (@monedaOriginal Is Null or Asientos.MonedaOriginal = @monedaOriginal) and 
							 (not (Asientos.AsientoTipoCierreAnualFlag Is Not Null And 
								   Asientos.AsientoTipoCierreAnualFlag = 1 And 
								   Asientos.MesFiscal <> 13));
				end 
			else 
				begin 
					-- cuando el usuario reconvierte, NO leemos el asiento de reconversión 
					select @debe = sum(debe), @haber = SUM(haber), @cantidadMovimientos = COUNT(*) 	
					   from dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico 
					   where (dAsientos.CuentaContableID = @cuentaContableID) and (Asientos.Fecha between @desde and @hasta) and (Asientos.Moneda = @moneda) and 
							 (@monedaOriginal Is Null or Asientos.MonedaOriginal = @monedaOriginal) and 
							 (not (Asientos.AsientoTipoCierreAnualFlag Is Not Null And 
								   Asientos.AsientoTipoCierreAnualFlag = 1 And 
								   Asientos.MesFiscal <> 13)) And 
								  (dAsientos.Referencia Is Null Or dAsientos.Referencia <> 'Reconversión 2021');
				end 		 
		end 
	else 
		begin 
			if (@reconvertirCifrasAntes_01Oct2021 = 0) 
				begin 
					-- cuando el usuario NO reconvierte, leemos el asiento de reconversión 
					select @debe = sum(debe), 
				   @haber = SUM(haber), 
				   @cantidadMovimientos = COUNT(*) 	
				   from dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico 
				   where dAsientos.CuentaContableID = @cuentaContableID and (Asientos.Fecha between @desde and @hasta) and (Asientos.Moneda = @moneda) and 
						 (@monedaOriginal Is Null or Asientos.MonedaOriginal = @monedaOriginal);
				end 
			else 
				begin 
					-- cuando el usuario reconvierte, NO leemos el asiento de reconversión 
					select @debe = sum(debe), 
				   @haber = SUM(haber), 
				   @cantidadMovimientos = COUNT(*) 	
				   from dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico 
				   where dAsientos.CuentaContableID = @cuentaContableID and (Asientos.Fecha between @desde and @hasta) and (Asientos.Moneda = @moneda) and 
						 (@monedaOriginal Is Null or Asientos.MonedaOriginal = @monedaOriginal) And 
						 (dAsientos.Referencia Is Null Or dAsientos.Referencia <> 'Reconversión 2021');
				end 
		end 
	         
	if (@debe Is Null) set @debe = 0; 
	if (@haber Is Null) set @haber = 0; 
	if (@cantidadMovimientos Is Null) set @cantidadMovimientos = 0; 
	
	Select (1) 
END

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.433a', GetDate()) 
GO 