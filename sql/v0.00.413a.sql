

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
	@excluirSaldoFinalCero bit, 
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
	
	/* lo primero que hacemos es descartar una cuenta *que no se ha movido* en el año o años anteriores
	al año de la consulta. 
	Para determinarlo, buscamos, al menos, un registro de saldos para la cuenta y su moneda, etc., cuyo 
	año sea anterior o igual al año fiscal de la consulta */ 
	   
	declare @contaAsientos int = 0; 
	   
	select @contaAsientos = COUNT(*) from SaldosContables where CuentaContableID = @cuentaContableID and 
		   Ano <= @anoFiscal and Moneda = @moneda and (@monedaOriginal Is Null or MonedaOriginal = @monedaOriginal); 			 
		             
	if (@contaAsientos = 0) 
	begin
		select (0); 
		return; 
	end 
	   
	/* Usamos un Sum pues la cuenta tendrá *más de un registro* en la tabla de saldos (SaldosContables), si la contabilidad es
	    multimoneda; por ejemplo, una cuenta puede (y debe) tener un registro 'Bs.-Bs', pero también un registro 'Bs.-US$' en 
		esta tabla; ambos registros contendrán cifras en Bs. y deberán sumarse para obtener el saldo de la cuenta ...  */

	select @saldoInicial = Sum(case @mesFiscal when 1 then Inicial when 2 then Mes01 when 3 then Mes02 when 4 then Mes03 
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
			declare @nombreCuentaContable nvarchar(250); 
			select @nombreCuentaContable = (ltrim(rtrim(CuentaEditada)) + ' - ' + ltrim(rtrim(Descripcion))) 
				   From CuentasContables Where ID = @cuentaContableID; 
			
			if (@@ROWCOUNT = 0) 
				set @errorMessage = 'Error: no hemos podido leer un registro de saldos contables para el año fiscal indicado (' + convert(char(4), @anoFiscal) + '); una probable razón es que el cierre contable no se haya ejecutado para el mes fiscal y el registro de saldos no haya sido agregado aún.'
			else
				set @errorMessage = 'Error: no hemos podido leer un registro de saldos contables para el año fiscal indicado (' + convert(char(4), @anoFiscal) + ') y la cuenta contable <b><em>' + @nombreCuentaContable + '</em></b>; una probable razón es que el cierre contable no se haya ejecutado para el mes fiscal indicado y el registro de saldos no haya sido agregado aún.'
			
			select (0); 
			return; 
		end 
	end 
		
	if (@saldoInicial is null) set @saldoInicial = 0; 
	set @montoAntesDesde = 0; 
	
	
	/* ahora leemos la sumarización del debe y haber para el período indicado */ 
	
	/* obviar asientos del tipo Cierre Anual, si así lo indicó el usaurio al solicitar la consulta ...  */ 
	/* Nota: Los asientos de tipo cierre anual a obviar son _solo_ los automáticos generados por el programa (mes fiscal 12)  */ 
	
	if (@excluirAsientoTipoCierreAnual = 1) 
	begin 
		select @debe = sum(debe), @haber = SUM(haber), @cantidadMovimientos = COUNT(*) 	
			   from dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico 
			   where dAsientos.CuentaContableID = @cuentaContableID and 
					 Asientos.Fecha between @desde and @hasta and 
					 Asientos.Moneda = @moneda and 
					 (@monedaOriginal Is Null or Asientos.MonedaOriginal = @monedaOriginal) and 
					 (not (Asientos.AsientoTipoCierreAnualFlag Is Not Null And 
						   Asientos.AsientoTipoCierreAnualFlag = 1 And 
						   Asientos.MesFiscal <> 13));
					 
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
	
	/* obviamos cuentas que terminan en cero si así lo indica el usuario */ 
	if (@excluirSaldoFinalCero = 1 And @saldoActual = 0) 
	begin 
		select (0); 
		return; 
	end
	
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
	
	
	/* por último, grabamos un registro a la tabla 'temp...' ... */ 
	
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

