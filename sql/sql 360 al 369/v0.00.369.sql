/*    Mi�rcoles, 26 de Marzo de 2.014   -  v0.00.369.sql 

	Balance general y GyP; hacemos un cambio al stored procedure 
	que lee la informaci�n para cada cuenta, para que obvie los 
	asientos contables de tipo cierre anual, cuando el usuario 
	lo indique ... 
*/



--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.369', GetDate()) 


/****** Object:  StoredProcedure [dbo].[spBalanceGeneral]    Script Date: 03/26/2014 09:38:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[spBalanceGeneral]  
	-- Add the parameters for the stored procedure here
	@cuentaContableID int,
	@mesFiscal smallint, 
	@anoFiscal smallint,
	@desde Date, 
	@hasta Date,
	@moneda int,
	@monedaOriginal int, 
	@nombreUsuario nvarchar(25), 
	@excluirSaldoInicialDebeHaberCero bit, 
	@excluirSinMovimientosPeriodo bit, 
	@excluirAsientoTipoCierreAnual bit, 
	@errorMessage nvarchar(500) out
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @errorMessage = ''; 
	
	declare @ciaContab int; 
	
	declare @saldoInicial money = 0; 
	declare @montoAntesDesde money = 0; 
	declare @debe money = 0; 
	declare @haber money = 0; 
	declare @cantidadMovimientos money = 0; 
	declare @saldoActual money = 0; 
	
	/* lo primero que hacemos es descartar la cuenta si no ha tenido asientos contables antes de la fecha final del 
	   per�odo; una cuenta as� no se ha movido antes y no debe ser mostrada en el balance; por otra parte, si el 
	   balance general es para un a�o fiscal *anterior* al a�o de la consulta, la cuenta podr�a no tener ni siquiera 
	   un registro de saldos y el proceso fallar�a */ 
	   
	declare @contaAsientos int = 0; 
	   
	select @contaAsientos = COUNT(*)  
			   from dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico 
		       where dAsientos.CuentaContableID = @cuentaContableID and 
		             Asientos.Fecha <= @hasta and 
		             Asientos.Moneda = @moneda and 
		             (@monedaOriginal Is Null or Asientos.MonedaOriginal = @monedaOriginal); 
		             
	if (@contaAsientos = 0) 
	begin
		select (0); 
		return; 
	end 
	   
	
	
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
		   de otra forma, ignoramos esta situaci�n; n�tese que el cierre contable siempre crear� un registro de saldos para una cuenta 
		   contable que tenga movimientos ...  */ 
		   
		select CuentaContableID from dAsientos Where CuentaContableID = @cuentaContableID
		
		if (@@ROWCOUNT > 0) 
		begin 
			declare @nombreCuentaContable nvarchar(250); 
			select @nombreCuentaContable = (ltrim(rtrim(CuentaEditada)) + ' - ' + ltrim(rtrim(Descripcion))) 
				   From CuentasContables Where ID = @cuentaContableID; 
			
			if (@@ROWCOUNT = 0) 
				set @errorMessage = 'Error: no hemos podido leer un registro de saldos contables para el a�o fiscal indicado (' + convert(char(4), @anoFiscal) + '); una probable raz�n es que el cierre contable no se haya ejecutado para el mes fiscal y el registro de saldos no haya sido agregado a�n.'
			else
				set @errorMessage = 'Error: no hemos podido leer un registro de saldos contables para el a�o fiscal indicado (' + convert(char(4), @anoFiscal) + ') y la cuenta contable <b><em>' + @nombreCuentaContable + '</em></b>; una probable raz�n es que el cierre contable no se haya ejecutado para el mes fiscal indicado y el registro de saldos no haya sido agregado a�n.'
			
			select (0); 
			return; 
		end 
	end 
		
	if (@saldoInicial is null) set @saldoInicial = 0; 
	set @montoAntesDesde = 0; 
	
	if (datepart("dd", @desde) > 1) 
	begin
		-- debemos determinar el movimiento ocurrido para la cuenta desde el 1er. d�a del mes hasta un d�a antes del inicio del per�odo ... 
		declare @fecha1erDiaMes date
		declare @fecha1diaAntesDesde date 
		
		set @fecha1erDiaMes = CONVERT(date, convert(char(4), year(@desde)) + '/' + 
		                                    convert(char(2), month(@desde)) + '/' + 
		                                    '01'); 
		                                    
		set @fecha1diaAntesDesde = CONVERT(date, convert(char(4), year(@desde)) + '/' + 
		                                         convert(char(2), month(@desde)) + '/' + 
		                                         convert(char(2), day(dateadd(day, -1, @desde)))); 
		                                         
		-- leemos el total en movimientos ocurridos para la cuenta contable entre ambas fechas (determinadas antes) 
		
		-- Obviamos asientos contables de tipo cierre anual, si el usuario as� lo indic� al requerir la consulta 
		
		if (@excluirAsientoTipoCierreAnual = 1) 
		begin 
			/* leemos solo asientos diferentes a cierre anual */ 
			select @montoAntesDesde = SUM(debe - haber) 
			   from dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico 
		       where dAsientos.CuentaContableID = @cuentaContableID and 
		             Asientos.Fecha between @fecha1erDiaMes and @fecha1diaAntesDesde and 
		             Asientos.Moneda = @moneda and 
		             (@monedaOriginal Is Null or Asientos.MonedaOriginal = @monedaOriginal) and 
		             (Asientos.AsientoTipoCierreAnualFlag Is Null Or Asientos.AsientoTipoCierreAnualFlag <> 1) ; 
		end 
		else 
		begin 
			/* leemos todos los asientos */ 
			select @montoAntesDesde = SUM(debe - haber) 
			   from dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico 
		       where dAsientos.CuentaContableID = @cuentaContableID and 
		             Asientos.Fecha between @fecha1erDiaMes and @fecha1diaAntesDesde and 
		             Asientos.Moneda = @moneda and 
		             (@monedaOriginal Is Null or Asientos.MonedaOriginal = @monedaOriginal); 
		end 
		
		
		             
		if (@montoAntesDesde Is Null) set @montoAntesDesde = 0; 
	end 
	
	/* ahora leemos la sumarizaci�n del debe y haber para el per�odo indicado */ 
	
	/* TODO: obviar asientos del tipo Cierre Anual, si as� lo indic� el usaurio al solicitar la consulta ...  */ 
	
	if (@excluirAsientoTipoCierreAnual = 1) 
	begin 
		select @debe = sum(debe), @haber = SUM(haber), @cantidadMovimientos = COUNT(*) 	
			   from dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico 
			   where dAsientos.CuentaContableID = @cuentaContableID and 
					 Asientos.Fecha between @desde and @hasta and 
					 Asientos.Moneda = @moneda and 
					 (@monedaOriginal Is Null or Asientos.MonedaOriginal = @monedaOriginal) and 
					 (Asientos.AsientoTipoCierreAnualFlag Is Null Or Asientos.AsientoTipoCierreAnualFlag <> 1) ;  
	end 
	else 
	begin 
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
	
	if (@excluirSaldoInicialDebeHaberCero = 1 And @saldoInicial = 0 And @montoAntesDesde = 0 And @debe = 0 And @haber = 0) 
	begin 
		select (0); 
		return; 
	end
		
	if (@excluirSinMovimientosPeriodo = 1 And @cantidadMovimientos = 0) 
	begin 
		select (0); 
		return; 
	end
	
	/* calculamos el saldo actual de la cuenta */ 
	
	set @saldoActual = @saldoInicial + @montoAntesDesde + @debe - @haber; 
	
	/* ahora debemos determinar cada detalle y leer sus descripciones para luego grabar el registro a la tabla en el db */ 
	
	declare @cantidadNiveles tinyint 
	declare @nivel1 nvarchar(25) 
	declare @nivel2 nvarchar(25) 
	declare @nivel3 nvarchar(25) 
	declare @nivel4 nvarchar(25) 
	declare @nivel5 nvarchar(25) 
	declare @nivel6 nvarchar(25) 
	
	declare @nivel1Editado nvarchar(30) 
	declare @nivel2Editado nvarchar(30) 
	declare @nivel3Editado nvarchar(30) 
	declare @nivel4Editado nvarchar(30) 
	declare @nivel5Editado nvarchar(30) 
	declare @nivel6Editado nvarchar(30) 
	
	declare @descripcionNivel1 nvarchar(30) 
	declare @descripcionNivel2 nvarchar(30) 
	declare @descripcionNivel3 nvarchar(30) 
	declare @descripcionNivel4 nvarchar(30) 
	declare @descripcionNivel5 nvarchar(30) 
	declare @descripcionNivel6 nvarchar(30) 
	
	declare @cuentaContableEditada nvarchar(30) 
	declare @ordenGrupoContable smallint
	declare @descripcionCuentaContable nvarchar(40) 
	
	select @ciaContab = CuentasContables.Cia, 
	    @descripcionCuentaContable = CuentasContables.Descripcion, 
	    @cuentaContableEditada = CuentasContables.CuentaEditada, @ordenGrupoContable = tGruposContables.OrdenBalanceGeneral, 
		@nivel1 = CuentasContables.Nivel1,
		@nivel1Editado = CuentasContables.Nivel1,
		@nivel2 = CuentasContables.Nivel2,
		@nivel3 = CuentasContables.Nivel3,
		@nivel4 = CuentasContables.Nivel4,
		@nivel5 = CuentasContables.Nivel5,
		@nivel6 = CuentasContables.Nivel6, 
		@cantidadNiveles = CuentasContables.NumNiveles
		
		from CuentasContables Inner Join tGruposContables On CuentasContables.Grupo = tGruposContables.Grupo
		Where ID = @cuentaContableID; 
		
	select @descripcionNivel1 = Descripcion From CuentasContables Where 
			Cuenta = ltrim(rtrim(@nivel1)) And 
			Cia = @ciaContab; 
		
	if (NULLIF(@nivel2, '') IS NOT NULL And @cantidadNiveles > 2) 
	begin
		set @nivel2Editado = @nivel1 + ' ' + @nivel2; 
		select @descripcionNivel2 = Descripcion From CuentasContables Where 
			Cuenta = ltrim(rtrim(@nivel1)) + ltrim(rtrim(@nivel2)) And 
			Cia = @ciaContab; 
	end 
	
	if (NULLIF(@nivel3, '') IS NOT NULL And @cantidadNiveles > 3) 
	begin
		set @nivel3Editado = @nivel1 + ' ' + @nivel2 + ' ' + @nivel3; 
		select @descripcionNivel3 = Descripcion From CuentasContables Where 
			Cuenta = ltrim(rtrim(@nivel1)) + ltrim(rtrim(@nivel2)) + ltrim(rtrim(@nivel3)) And 
			Cia = @ciaContab; 
	end 
	
	if (NULLIF(@nivel4, '') IS NOT NULL And @cantidadNiveles > 4) 
	begin
		set @nivel4Editado = @nivel1 + ' ' + @nivel2 + ' ' + @nivel3 + ' ' + @nivel4; 
		select @descripcionNivel4 = Descripcion From CuentasContables Where 
			Cuenta = ltrim(rtrim(@nivel1)) + ltrim(rtrim(@nivel2)) + ltrim(rtrim(@nivel3)) + ltrim(rtrim(@nivel4)) And 
			Cia = @ciaContab; 
	end 
	
	if (NULLIF(@nivel5, '') IS NOT NULL And @cantidadNiveles > 5) 
	begin
		set @nivel5Editado = @nivel1 + ' ' + @nivel2 + ' ' + @nivel3 + ' ' + @nivel4 + ' ' + @nivel5; 
		select @descripcionNivel5 = Descripcion From CuentasContables Where 
			Cuenta = ltrim(rtrim(@nivel1)) + ltrim(rtrim(@nivel2)) + ltrim(rtrim(@nivel3)) + ltrim(rtrim(@nivel4)) + ltrim(rtrim(@nivel5)) And 
			Cia = @ciaContab; 
	end 
	
	if (NULLIF(@nivel6, '') IS NOT NULL And @cantidadNiveles > 6) 
	begin
		set @nivel6Editado = @nivel1 + ' ' + @nivel2 + ' ' + @nivel3 + ' ' + @nivel4 + ' ' + @nivel5 + ' ' + @nivel6; 
		select @descripcionNivel6 = Descripcion From CuentasContables Where 
			Cuenta = ltrim(rtrim(@nivel1)) + ltrim(rtrim(@nivel2)) + ltrim(rtrim(@nivel3)) + ltrim(rtrim(@nivel4)) + ltrim(rtrim(@nivel5)) + ltrim(rtrim(@nivel6)) And 
			Cia = @ciaContab; 
	end 
	
	
	/* por �ltimo, grabamos un registro a la tabla 'temp...' ... */ 
	
	Insert Into Temp_Contab_Report_BalanceGeneral 
		(CuentaContableID, CuentaContable, NombreCuentaContable, Moneda, OrdenBalanceGeneral, CantidadNiveles, 
		 Nivel1, DescripcionNivel1, Nivel2, DescripcionNivel2, Nivel3, DescripcionNivel3, Nivel4, DescripcionNivel4, 
		 Nivel5, DescripcionNivel5, Nivel6, DescripcionNivel6, 
		 SaldoAnterior, MontoInicioPeriodo, Debe, Haber, SaldoActual, CantMovimientos, Usuario) 
		Values
		(@cuentaContableID, @cuentaContableEditada, @descripcionCuentaContable, @moneda, @ordenGrupoContable, @cantidadNiveles, 
		@nivel1Editado, @descripcionNivel1, @nivel2Editado, @descripcionNivel2, @nivel3Editado, @descripcionNivel3, @nivel4Editado, @descripcionNivel4, 
		@nivel5Editado, @descripcionNivel5, @nivel6Editado, @descripcionNivel6, 
		 @saldoInicial, @montoAntesDesde, @debe, @haber, @saldoActual, @cantidadMovimientos, @nombreUsuario); 
		
	Select (1) 

END
