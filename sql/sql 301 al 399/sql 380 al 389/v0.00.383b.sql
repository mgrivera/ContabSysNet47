/*    
	  Viernes, 14 de Octubre de 2.016	-   v0.00.383b.sql 

	  Hacemos un cambio muy leve al stored procedure spGetSaldoAnteriorDebeYHaber; eliminamos la funcionalidad 
	  que permitía que el periodo para la consulta comenzara con un día posterior al 1ro. 
	  Además, permitimos que el usuario indique si desea eliminar asientos del tipo cierre anual del 
	  resumen de asientos para la cuenta contable. 
*/



/****** Object:  StoredProcedure [dbo].[spGetSaldoAnteriorDebeYHaber]    Script Date: 14/10/2016 05:44:35 p.m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [dbo].[spGetSaldoAnteriorDebeYHaber] 
	-- Add the parameters for the stored procedure here
	@cuentaContableID int,
	@moneda int,
	@monedaOriginal int, 
	@mesFiscal smallint, 
	@anoFiscal smallint,
	@desde Date, 
	@hasta Date,
	@resumenTodosSusDetalles bit, 
	@excluirAsientoTipoCierreAnual bit, 
	@nombreCuentaContable nvarchar(40) out, 
	@nombreGrupoContable nvarchar(50) out, 
	@saldoInicial money out,
	@montoAntesDesde money out,
	@debe money out,
	@haber money out,
	@saldoActual money out,
	@cantidadMovimientos smallint out,
	@ordenBalanceGeneral smallint out, 
	@errorMessage nvarchar(500) out
AS
BEGIN
	/* 
		Esta función recibe una cuenta y determina: saldo anterior, debe, haber, saldo actual y cantidad de movimientos, para un 
		período, moneda y moneda original indicados; la moneda original puede ser 0, si no se quiere que intervenga. 
		
		si el parametro Like es true, buscamos la cuenta (ejemplo 1) y ejecutamos el proceso pero para *todas* las cuentas que comienzan 
		con 1 (ie: Like 1%). 
		
		Nótese que la función recibe el mes y año fiscal; la idea es que, muchas veces, esta función se ejecuta en forma repetitiva 
		muchas veces; en vez de determinar el mes y año fiscal cada vez, se puede determinar antes y pasarlo en forma sucesiva a esta función
	*/ 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	
	SET NOCOUNT ON;
	set @errorMessage = ''; 
	
	-- lo primero que hacemos es leer la cuenta contable 
	
	declare @ciaContab int; 
	declare @cuenta nvarchar(25); 
	
	select @ciaContab = CuentasContables.Cia, 
		   @cuenta = CuentasContables.Cuenta, 
		   @nombreCuentaContable = CuentasContables.Descripcion, 
		   @nombreGrupoContable = tGruposContables.Descripcion, 
		   @ordenBalanceGeneral = tGruposContables.OrdenBalanceGeneral
		   from CuentasContables Inner Join tGruposContables On CuentasContables.Grupo = tGruposContables.Grupo
		   Where ID = @cuentaContableID; 
	
	if (@@rowcount = 0)
	begin 
		set @errorMessage = 'Error inesperado: no hemos podido leer la cuenta contable en la tabla de cuentas contables (???!!!).'
		return 
	end 
	
	-- ahora intentamos leer y determinar el saldo inicial del período indicado, en base al mes y año fiscal indicados en parámetros ... 
	
	if (@resumenTodosSusDetalles = 1)
		-- usamos Like pues queremos *todas* las 'sub cuentas'; por ejemplo: recibimos 5 y debemos leer 5* ... 
		select @saldoInicial = Sum(case @mesFiscal when 1 then Inicial when 2 then Mes01 when 3 then Mes02 when 4 then Mes03 
								when 5 then Mes04 when 6 then Mes05 when 7 then Mes06 when 8 then Mes07 
								when 9 then Mes08 when 10 then Mes09 when 11 then Mes10 when 12 then Mes11 end)
			from SaldosContables Inner Join CuentasContables On SaldosContables.CuentaContableID = CuentasContables.ID 
			where 
			CuentasContables.Cuenta Like @cuenta + '%' And 
			CuentasContables.Cia = @ciaContab And
			CuentasContables.TotDet = 'D' And 
			SaldosContables.Ano = @anoFiscal and 
			SaldosContables.Moneda = @moneda and 
			(@monedaOriginal Is Null or SaldosContables.MonedaOriginal = @monedaOriginal); 
	else 
		select @saldoInicial = (case @mesFiscal when 1 then Inicial when 2 then Mes01 when 3 then Mes02 when 4 then Mes03 
								when 5 then Mes04 when 6 then Mes05 when 7 then Mes06 when 8 then Mes07 
								when 9 then Mes08 when 10 then Mes09 when 11 then Mes10 when 12 then Mes11 end)
				from SaldosContables where 
				CuentaContableID = @cuentaContableID and 
				Ano = @anoFiscal and 
				Moneda = @moneda and 
				(@monedaOriginal Is Null or MonedaOriginal = @monedaOriginal); 
		
		
	if (@@rowcount = 0)
	begin 
		/* la cuenta contable no tiene un registro de saldos ... mostramos un error *solo* si la cuenta tiene movimientos; 
		   de otra forma, ignoramos esta situación; nótese que el cierre contable siempre creará un registro de saldos para una cuenta 
		   contable que tenga movimientos ...  */ 
		   
		select CuentaContableID from dAsientos Where CuentaContableID = @cuentaContableID
		
		if (@@ROWCOUNT > 0) 
		begin 
			set @errorMessage = 'Error: no hemos podido leer un registro de saldos contables para el año fiscal indicado (' + convert(char(4), @anoFiscal) + ') y la cuenta contable <b><em>' + @nombreCuentaContable + '</em></b>; una probable razón es que el cierre contable no se haya ejecutado para el mes fiscal indicado y el registro de saldos no haya sido agregado aún.'
			return 
		end 
	end 
		
	if (@saldoInicial is null) set @saldoInicial = 0; 
	set @montoAntesDesde = 0; 
	
	/* ahora leemos la sumarización del debe y haber para el período indicado */ 
	/* nótese que el usuario puede indicar que desea excluir asientos de tipo cierre anual  */ 
	
	if (@excluirAsientoTipoCierreAnual = 1) 
	begin 
		if (@resumenTodosSusDetalles = 1)
			select @debe = sum(debe), @haber = SUM(haber), @cantidadMovimientos = COUNT(*) 	
				   from dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico Inner Join 
						CuentasContables On dAsientos.CuentaContableID = CuentasContables.ID
				   where CuentasContables.Cuenta Like @cuenta + '%'  and 
						 CuentasContables.Cia = @ciaContab And
						 Asientos.Fecha between @desde and @hasta and 
						 Asientos.Moneda = @moneda and 
						 (@monedaOriginal Is Null or Asientos.MonedaOriginal = @monedaOriginal) and 
					 (Asientos.AsientoTipoCierreAnualFlag Is Null Or Asientos.AsientoTipoCierreAnualFlag <> 1);
		else 
			select @debe = sum(debe), @haber = SUM(haber), @cantidadMovimientos = COUNT(*) 	
				   from dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico 
				   where dAsientos.CuentaContableID = @cuentaContableID and 
						 Asientos.Fecha between @desde and @hasta and 
						 Asientos.Moneda = @moneda and 
						 (@monedaOriginal Is Null or Asientos.MonedaOriginal = @monedaOriginal) and 
					 (Asientos.AsientoTipoCierreAnualFlag Is Null Or Asientos.AsientoTipoCierreAnualFlag <> 1); 
	end 
	else 
	begin
		if (@resumenTodosSusDetalles = 1)
				select @debe = sum(debe), @haber = SUM(haber), @cantidadMovimientos = COUNT(*) 	
					   from dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico Inner Join 
							CuentasContables On dAsientos.CuentaContableID = CuentasContables.ID
					   where CuentasContables.Cuenta Like @cuenta + '%'  and 
							 CuentasContables.Cia = @ciaContab And
							 Asientos.Fecha between @desde and @hasta and 
							 Asientos.Moneda = @moneda and 
							 (@monedaOriginal Is Null or Asientos.MonedaOriginal = @monedaOriginal); 
			else 
				select @debe = sum(debe), @haber = SUM(haber), @cantidadMovimientos = COUNT(*) 	
					   from dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico 
					   where dAsientos.CuentaContableID = @cuentaContableID and 
							 Asientos.Fecha between @desde and @hasta and 
							 Asientos.Moneda = @moneda and 
							 (@monedaOriginal Is Null or Asientos.MonedaOriginal = @monedaOriginal); 
	end
					 
					
	
	if (@debe Is Null) set @debe = 0; 
	if (@haber Is Null) set @haber = 0; 
	if (@cantidadMovimientos Is Null) set @cantidadMovimientos = 0; 
	
	/* calculamos el saldo actual de la cuenta */ 
	
	set @saldoActual = @saldoInicial + @montoAntesDesde + @debe - @haber; 
	
	Select (0) 

END



GO


--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.383b', GetDate()) 
