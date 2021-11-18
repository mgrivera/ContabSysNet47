/*    
	  Lunes, 8 de Noviembre de 2.021  -   v0.00.433.sql 
	  
	  Modificamos el stored procedure spBalanceGeneral para adaptarla a la reconversión 
	  en Oct/2021 
*/



/****** Object:  StoredProcedure [dbo].[spBalanceGeneral]    Script Date: 11/8/21 12:09:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('dbo.spBalanceGeneral', 'P') IS NOT NULL  
    DROP PROCEDURE [dbo].[spBalanceGeneral];  
GO  

Create PROCEDURE [dbo].[spBalanceGeneral]  
	-- Add the parameters for the stored procedure here
	@cuentaContableID int,
	@mesFiscal smallint, 
	@anoFiscal smallint,
	@desde Date, 
	@hasta Date,
	@moneda int,
	@monedaNacional int,
	@monedaOriginal int = Null, 
	@nombreUsuario nvarchar(25), 
	@excluirSaldoInicialDebeHaberCero bit, 
	@excluirSaldoFinalCero bit, 
	@excluirSinMovimientosPeriodo bit, 
	@excluirAsientoTipoCierreAnual bit, 

	@reconvertirCifrasAntes_01Oct2021 bit, 

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
	declare @cantidadMovimientos smallint = 0; 
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
		from SaldosContables 
		where (CuentaContableID = @cuentaContableID) and (Ano = @anoFiscal) and (Moneda = @moneda) and (@monedaOriginal Is Null or MonedaOriginal = @monedaOriginal); 
		
		
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
				set @errorMessage = 'Error: no hemos podido leer un registro de saldos contables para el año fiscal indicado (' + 
									 convert(char(4), @anoFiscal) + '); una probable razón es que el cierre contable no se haya ' + 
									 'ejecutado para el mes fiscal y el registro de saldos no haya sido agregado aún.'
			else
				set @errorMessage = 'Error: no hemos podido leer un registro de saldos contables para el año fiscal indicado (' + 
									convert(char(4), @anoFiscal) + ') y la cuenta contable <b><em>' + @nombreCuentaContable + 
									'</em></b>; una probable razón es que el cierre contable no se haya ejecutado para el ' + 
									'mes fiscal indicado y el registro de saldos no haya sido agregado aún.'
			
			select (0); 
			return; 
		end 
	end 
		
	if (@saldoInicial is null) set @saldoInicial = 0; 

	/* ----------------------- Reconversión Oct/2021 -------------------------------------------------------------------------- */
	/* el usuario puede indicar que desea reconvertir el balance. Reconvertimos saldos anteriores a 1Nov21 y de moneda nacional */ 
	if (@reconvertirCifrasAntes_01Oct2021 = 1 and @moneda = @monedaNacional And @desde < '2021-11-1') 
	begin 
		set @saldoInicial = Round(@saldoInicial / 1000000, 2)
	end

	/* esta variable nunca fue usada. Imaginamos que el usuario no va a pedir nunca la consulta a partir de un día diferente al 1ro (????)  */ 
	set @montoAntesDesde = 0;
	
	/* ------------------------------------------------------------------------------------------------------------------------ */
	/* ahora leemos la sumarización del debe y haber para el período indicado */ 
	/* leemos los asientos que corresponden a la cuenta, moneda y período */

	declare @tempDebe money = 0; 
	declare @tempHaber money = 0; 
	declare @tempCantMovimientos smallint = 0; 
	
	/* seguidamente, reconvertimos los montos si el usuario lo indicó al ejecutar la consulta */ 
	if ((@reconvertirCifrasAntes_01Oct2021 = 0) Or (@moneda <> @monedaNacional) Or (@desde >= '2021-10-1')) 
		begin 
			/* si alguna de las condiciones arriba indicadas es false, no reconvertimos */ 
			EXEC dbo.spBalanceGeneral_leerMovimientos @cuentaContableID = @cuentaContableID,
													@desde = @desde,
													@hasta = @hasta,
													@moneda = @moneda,
													@monedaOriginal = @monedaOriginal,
													@excluirAsientoTipoCierreAnual = @excluirAsientoTipoCierreAnual,
													@debe = @tempDebe out,
													@haber = @tempHaber out,
													@cantidadMovimientos = @tempCantMovimientos out,
													@errorMessage = @errorMessage out;  
							
			if (@errorMessage <> '') 
				begin 
					select (0); 
					return; 
				end

			set @debe = @tempDebe; 
			set @haber = @tempHaber; 
			set @cantidadMovimientos = @tempCantMovimientos; 
			
		end 
	else 
		begin 
			if (@hasta < '2021-10-1') 
				begin 
					/* reconvertimos todos los asientos, pues todos son anteriores a Oct/21 */ 
					EXEC dbo.spBalanceGeneral_leerMovimientos @cuentaContableID = @cuentaContableID,
															@desde = @desde,
															@hasta = @hasta,
															@moneda = @moneda,
															@monedaOriginal = @monedaOriginal,
															@excluirAsientoTipoCierreAnual = @excluirAsientoTipoCierreAnual,
															@debe = @tempDebe out,
															@haber = @tempHaber out,
															@cantidadMovimientos = @tempCantMovimientos out,
															@errorMessage = @errorMessage out;  
							
					if (@errorMessage <> '') 
						begin 
							select (0); 
							return; 
						end

					set @debe = Round(@tempDebe / 1000000, 2); 
					set @haber = Round(@tempHaber / 1000000, 2); 
					set @cantidadMovimientos = @tempCantMovimientos; 
				end 
			else 
				begin 
					/* --------------------------------------------------------- */
					/* leemos los asientos *anteriores* a Oct/2021 - reconvertimos */ 
					EXEC dbo.spBalanceGeneral_leerMovimientos @cuentaContableID = @cuentaContableID,
															@desde = @desde,
															@hasta = '2021-9-30',
															@moneda = @moneda,
															@monedaOriginal = @monedaOriginal,
															@excluirAsientoTipoCierreAnual = @excluirAsientoTipoCierreAnual,
															@debe = @tempDebe out,
															@haber = @tempHaber out,
															@cantidadMovimientos = @tempCantMovimientos out,
															@errorMessage = @errorMessage out;  
							
					if (@errorMessage <> '') 
						begin 
							select (0); 
							return; 
						end

					/* estos son asientos *anteriores* a la reconversión: reconvertimos */
					set @debe = Round(@tempDebe / 1000000, 2); 
					set @haber = Round(@tempHaber / 1000000, 2); 
					set @cantidadMovimientos = @tempCantMovimientos; 

					/* ------------------------------------------------------------- */
					/* leemos los asientos *posteriores* a Oct/2021 - no reconvertimos */ 
					set @tempDebe = 0; 
					set @tempHaber = 0; 
					set @tempCantMovimientos = 0; 

					EXEC dbo.spBalanceGeneral_leerMovimientos @cuentaContableID = @cuentaContableID,
															@desde = '2021-10-1',
															@hasta = @hasta,
															@moneda = @moneda,
															@monedaOriginal = @monedaOriginal,
															@excluirAsientoTipoCierreAnual = @excluirAsientoTipoCierreAnual,
															@debe = @tempDebe out,
															@haber = @tempHaber out,
															@cantidadMovimientos = @tempCantMovimientos out,
															@errorMessage = @errorMessage out;  
							
					if (@errorMessage <> '') 
						begin 
							select (0); 
							return; 
						end

					/* estos son asientos *posteriores* a la reconversión: no reconvertimos - agregamos los leídos arriba */ 
					set @debe = @debe + @tempDebe; 
					set @haber = @haber + @tempHaber; 
					set @cantidadMovimientos = @cantidadMovimientos + @tempCantMovimientos; 
				end 
		end 

	/* excluimos cuentas con saldo cero y sin movimientos */
	if (@excluirSaldoInicialDebeHaberCero = 1 And @saldoInicial = 0 And @debe = 0 And @haber = 0) 
	begin 
		select (0); 
		return; 
	end
		
	/* excluimos cuentas sin movimientos */
	if (@excluirSinMovimientosPeriodo = 1 And @cantidadMovimientos = 0) 
	begin 
		select (0); 
		return; 
	end
	
	/* calculamos el saldo actual de la cuenta */ 
	set @saldoActual = @saldoInicial + @debe - @haber; 
	
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

--  ------------------------
--  actualizamos la version 
--  ------------------------

Delete From tVersionWeb
Insert Into tVersionWeb(VersionActual, Fecha) Values('v0.00.433', GetDate()) 