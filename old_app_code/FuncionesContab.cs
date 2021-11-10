using System;
using System.Collections.Generic;
using System.Linq;
using ContabSysNet_Web.ModelosDatos;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;


/// <summary>
/// Summary description for AsientosContables
/// </summary>
public class FuncionesContab
{
    int _CiaContab; 
    int _Moneda;
    dbContabDataContext _dbContab;

    public class _Partida
    {
        public string CuentaContable { get; set; }
        public string Descripcion { get; set; }
        public string Referencia { get; set; }
        public decimal Debe { get; set; }
        public decimal Haber { get; set; }
        public Nullable<int> CentroCosto { get; set; }
    }
    public class _AsientoContable
    {
        public Nullable<int> NumeroAutomatico { get; set; }
        public Nullable<int> Numero { get; set; }
        public DateTime Fecha { get; set; }
        public Nullable<short> MesFiscal { get; set; }
        public Nullable<short> AnoFiscal { get; set; }
        public string Tipo { get; set; }
        public string Descripcion { get; set; }
        public int Moneda { get; set; }
        public Nullable<decimal> FactorCambio { get; set; }
        public string ProvieneDe { get; set; }
        public int CiaContab { get; set; }
        public List<_Partida> Partidas { get; set; }
    }

    public FuncionesContab(int nCiaContab, int nMoneda, dbContabDataContext dbContab)
    {
        //
        // TODO: Add constructor logic here
        //

        _CiaContab = nCiaContab;
        _Moneda = nMoneda;
        _dbContab = dbContab;
    }

    public string sLeerCuentaContableDefinida(int nConcepto, int nCompania, int nRubro)
    {
        // TODO: tenemos que regresar el ID de la cuenta contable, y no la cuenta; sin embargo, 
        // esto lo haremos *más adelante*, o nunca!, pues tal vez vayamos pasando estas funciones a 
        // LS y dejemos este código como está 

        string sc;
       
        // busca una cuenta contable predefinida en la tabla DefinicionCuentasContables



        //  1) buscamos por: concepto, rubro, compañía y ciacontab

        sc = (from d in _dbContab.DefinicionCuentasContables
              where d.Concepto == nConcepto &&
              d.Rubro == nRubro &&
              d.Compania == nCompania &&
              d.CiaContab == _CiaContab
              select d.CuentaContable).FirstOrDefault();

        if (sc != null && sc != "")
            return sc;


        //  2) buscamos por: concepto, compañía y ciacontab

        sc = (from d in _dbContab.DefinicionCuentasContables
              where d.Concepto == nConcepto &&
              d.Rubro == null && 
              d.Compania == nCompania &&
              d.CiaContab == _CiaContab
              select d.CuentaContable).FirstOrDefault();

        if (sc != null && sc != "")
            return sc;


        //  3) buscamos por: concepto, compañía

        sc = (from d in _dbContab.DefinicionCuentasContables
              where d.Concepto == nConcepto &&
              d.Rubro == null && 
              d.Compania == nCompania && 
              d.CiaContab == null
              select d.CuentaContable).FirstOrDefault();

        if (sc != null && sc != "")
            return sc;


        //  4) buscamos por: concepto y ciacontab

        sc = (from d in _dbContab.DefinicionCuentasContables
              where d.Concepto == nConcepto &&
              d.Rubro == null &&
              d.Compania == null && 
              d.CiaContab == _CiaContab
              select d.CuentaContable).FirstOrDefault();

        if (sc != null && sc != "")
            return sc;


        //  5) buscamos por: concepto 

        sc = (from d in _dbContab.DefinicionCuentasContables
              where d.Concepto == nConcepto &&
              d.Rubro == null &&
              d.Compania == null &&
              d.CiaContab == null
              select d.CuentaContable).FirstOrDefault();

        if (sc != null && sc != "")
            return sc;


        return ""; 
    }

    public bool PrepararInfoAsientoParaObtenerReporte()
    {
        return false; 
    }

    public bool ValidarAsientoContable(_AsientoContable AsientoContable, out string sErrMessage)
    {
        sErrMessage = ""; 

        // recibe un asiento contable completo e intenta validarlo; este método es usado, principalmente, 
        // en la carga automática de asientos contables desde otras aplicaciones; la clase recibe un 
        // asiento que puede inclumplir muchas validaciones, lo valida y regresa el error en un 
        // string si existe 

        // ---------------------------------------------------
        // validamos que exista la CiaContab 
        int nRecCount = (from c in _dbContab.Compania_Contabs
                         where c.Numero == AsientoContable.CiaContab
                         select c).Count();

        if (nRecCount == 0)
        {
            sErrMessage = "La compañía indicada para el asiento contable no fue encontrada en Contab.";
            return false;
        }

        // ---------------------------------------------------
        // validamos que exista la moneda 

        nRecCount = (from m in _dbContab.Moneda_Contabs
                         where m.Moneda1 == AsientoContable.Moneda
                     select m).Count();

        if (nRecCount == 0)
        {
            sErrMessage = "La moneda indicada para el asiento contable no fue encontrada en Contab.";
            return false;
        }

        // -----------------------------------------------------------------------------------
        // el método que sigue valida que el tipo de asiento exista y, además, si la numeración 
        // es separada por tipo de asiento, que este mecanismo esté correctamente configurado en la 
        // compañía para el tipo de asiento indicado 

        if (!ValidarObtenerNumeroContab(AsientoContable.Fecha, AsientoContable.CiaContab, AsientoContable.Tipo, out sErrMessage))
            return false; 
        
        // asignamos un factor de cambio al asiento contable
        // leemos el factor de cambio más próximo a la fecha de la reposición 
        decimal? nFactorCambio = (from fc in _dbContab.CambiosMonedas
                                  where fc.Fecha <= AsientoContable.Fecha
                                  orderby fc.Fecha descending
                                  select fc.Cambio).FirstOrDefault();

        if (!nFactorCambio.HasValue)
            nFactorCambio = 0;

        AsientoContable.FactorCambio = nFactorCambio;

        // determina mes y año fiscal 
        Int16 nMesFiscal = 0;
        Int16 nAnoFiscal = 0;

        if (!DeterminarMesFiscal(AsientoContable.Fecha, AsientoContable.CiaContab, out sErrMessage, out nMesFiscal, out nAnoFiscal))
            return false;

        AsientoContable.MesFiscal = nMesFiscal;
        AsientoContable.AnoFiscal = nAnoFiscal; 

        // validar mes cerrado en Contab 
        if (!ValidarUltimoMesCerradoContab(AsientoContable.Fecha, AsientoContable.CiaContab, out sErrMessage))
            return false;

        // ahora validamos que las cuentas contables que vienen con cada asiento existan en Contab para 
        // la compañía específica y sean del tipo detalle. 

        foreach (_Partida MyPartida in AsientoContable.Partidas)
        {
            var sTotalDetalle = (from cc in _dbContab.CuentasContables 
                                where cc.Cia == AsientoContable.CiaContab && 
                                cc.Cuenta == MyPartida.CuentaContable
                                select cc.TotDet).FirstOrDefault(); 

            if (sTotalDetalle == null) 
            {
                sErrMessage = "La cuenta contable " + MyPartida.CuentaContable + 
                    " no existe en la tabla de cuentas contables para la compañía del asiento.";
                return false;
            }

            if (sTotalDetalle != "D") 
            {
                sErrMessage = "Aunque la cuenta contable " + MyPartida.CuentaContable + 
                    " existe en la tabla de cuentas contables para la compañía del asiento, " + 
                    "no es del tipo Detalle<br />" + 
                    "Las cuentas contables que se asocien a los asientos, deben ser del tipo Detalle."; 
                return false;
            }
        }
        
        return true; 
    }

    public bool GrabarAsientoContable(_AsientoContable AsientoContable, out string sErrMessage, 
        string sUserName)
    {
        sErrMessage = "";


        // Grabamos el asiento pasado a esta función a la tabla de asientos y partidas; nótese como 
        // usamos un número negativo como número del asiento; en un proximo paso, el usuario asignará
        // números Contab a los asientos de la lista  

        // intentamos registrar el asiento. Nótese que el asiento preparado para el asiento fue leído en 
        // AsientoContable (arriba usando Linq) 

        // lo primero que hacemos es obtener un ClaveUnica para el asiento y un número negativo 

        int nNumeroNegativoAsientoContable = 0;

        if (!ObtenerNumeroNegativoAsiento(AsientoContable.Fecha, AsientoContable.CiaContab,
            out sErrMessage, out nNumeroNegativoAsientoContable))
            return false;

        int nPKAsientoContable = 0;

        if (!ObtenerClaveUnicaAsiento(out sErrMessage, out nPKAsientoContable))
            return false;

        AsientoContable.Numero = nNumeroNegativoAsientoContable;
        AsientoContable.NumeroAutomatico = nPKAsientoContable; 
        

        ContabSysNet_Web.ModelosDatos.Asiento MyAsientoContable = new ContabSysNet_Web.ModelosDatos.Asiento();

        MyAsientoContable.NumeroAutomatico = nPKAsientoContable;

        MyAsientoContable.Fecha = AsientoContable.Fecha;
        MyAsientoContable.Numero = Convert.ToInt16(nNumeroNegativoAsientoContable);
        MyAsientoContable.Mes = Convert.ToByte(AsientoContable.Fecha.Month);
        MyAsientoContable.Ano = Convert.ToInt16(AsientoContable.Fecha.Year);
        MyAsientoContable.MesFiscal = AsientoContable.MesFiscal.Value;
        MyAsientoContable.AnoFiscal = AsientoContable.AnoFiscal.Value;
        MyAsientoContable.Tipo = AsientoContable.Tipo;

        if (AsientoContable.Descripcion.Length > 250) 
            MyAsientoContable.Descripcion = AsientoContable.Descripcion.ToString().Substring(0, 50);
        else
            MyAsientoContable.Descripcion = AsientoContable.Descripcion;

        //MyAsientoContable.NumPartidas = 0;
        //MyAsientoContable.TotalDebe = 0;
        //MyAsientoContable.TotalHaber = 0;

        MyAsientoContable.Moneda = AsientoContable.Moneda;
        MyAsientoContable.MonedaOriginal = AsientoContable.Moneda;
        MyAsientoContable.FactorDeCambio = AsientoContable.FactorCambio.Value;

        MyAsientoContable.ConvertirFlag = true;
        MyAsientoContable.ProvieneDe = AsientoContable.ProvieneDe; 
        MyAsientoContable.Ingreso = DateTime.Now;
        MyAsientoContable.UltAct = DateTime.Now;
        MyAsientoContable.Usuario = sUserName;
        MyAsientoContable.Cia = AsientoContable.CiaContab;

        _dbContab.Asientos.InsertOnSubmit(MyAsientoContable);

        try
        {
            _dbContab.SubmitChanges();
        }
        catch (Exception ex)
        {
            sErrMessage = "... se ha producido un error al intentar efectuar una operación en la base de datos. <br />" +
                "El mensaje específico de error es: <br /><br />" +
                ex.Message;
            return false;
        }

        // grabar partidas a dAsientos  

        // ahora que registramos el asiento, registramos sus partidas 

        ContabSysNet_Web.ModelosDatos.dAsiento MyPartidaAsiento;
        List<ContabSysNet_Web.ModelosDatos.dAsiento> MyPartidaAsiento_List = new List<ContabSysNet_Web.ModelosDatos.dAsiento>();

        decimal nTotalDebe = 0;
        decimal nTotalHaber = 0;
        short nNumeroPartida = 0; 
        int nCantidadPartidas = AsientoContable.Partidas.Count();

        foreach (var wMyPartidaAsiento in AsientoContable.Partidas)
        {

            nNumeroPartida += 10; 
            MyPartidaAsiento = new ContabSysNet_Web.ModelosDatos.dAsiento();

            MyPartidaAsiento.NumeroAutomatico = nPKAsientoContable;

            //MyPartidaAsiento.Fecha = AsientoContable.Fecha;
            //MyPartidaAsiento.Numero = Convert.ToInt16(nNumeroNegativoAsientoContable);
            //MyPartidaAsiento.Mes = Convert.ToByte(AsientoContable.Fecha.Month);
            //MyPartidaAsiento.Ano = Convert.ToInt16(AsientoContable.Fecha.Year);
            //MyPartidaAsiento.MesFiscal = AsientoContable.MesFiscal.Value;
            //MyPartidaAsiento.AnoFiscal = AsientoContable.AnoFiscal.Value;

            MyPartidaAsiento.Partida = nNumeroPartida;
            //MyPartidaAsiento.Cuenta = wMyPartidaAsiento.CuentaContable;

            if (wMyPartidaAsiento.Referencia.Length > 20)
                MyPartidaAsiento.Referencia = wMyPartidaAsiento.Referencia.ToString().Substring(0, 20);
            else
                MyPartidaAsiento.Referencia = wMyPartidaAsiento.Referencia;

            if (wMyPartidaAsiento.Descripcion.Length > 50)
                MyPartidaAsiento.Descripcion = wMyPartidaAsiento.Descripcion.ToString().Substring(0, 50); 
            else
                MyPartidaAsiento.Descripcion = wMyPartidaAsiento.Descripcion;

            MyPartidaAsiento.Debe = wMyPartidaAsiento.Debe;
            MyPartidaAsiento.Haber = wMyPartidaAsiento.Haber;

            //MyPartidaAsiento.Moneda = AsientoContable.Moneda;
            //MyPartidaAsiento.MonedaOriginal = AsientoContable.Moneda;
            //MyPartidaAsiento.FactorDeCambio = AsientoContable.FactorCambio.Value;
            //MyPartidaAsiento.ConvertirFlag = true;

            //MyPartidaAsiento.Cia = AsientoContable.CiaContab;

            nTotalDebe += wMyPartidaAsiento.Debe;
            nTotalHaber += wMyPartidaAsiento.Haber;

            MyPartidaAsiento_List.Add(MyPartidaAsiento);
        }

        _dbContab.dAsientos.InsertAllOnSubmit(MyPartidaAsiento_List);

        try
        {
            _dbContab.SubmitChanges();
        }
        catch (Exception ex)
        {
            sErrMessage = "... se ha producido un error al intentar efectuar una operación en la base de datos. <br />" +
                "El mensaje específico de error es: <br /><br />" +
                ex.Message;
            return false;
        }


        // actualizar items: NumPartidas, TotalDebe y TotalHaber en Asientos  

        ContabSysNet_Web.ModelosDatos.Asiento AsientoContab = (from a in _dbContab.Asientos
                                 where a.NumeroAutomatico == nPKAsientoContable
                                 select a).FirstOrDefault();

        if (AsientoContab == null)
        {
            sErrMessage = "... se ha producido un error al intentar efectuar una operación en la base de datos. <br />" +
                "No se encontró el asiento contable recién registrado para su modificación.";
            return false;
        }

        //AsientoContab.NumPartidas = Convert.ToInt16(nCantidadPartidas);
        //AsientoContab.TotalDebe = nTotalDebe;
        //AsientoContab.TotalHaber = nTotalHaber;

        try
        {
            _dbContab.SubmitChanges();
        }
        catch (Exception ex)
        {
            sErrMessage = "... se ha producido un error al intentar efectuar una operación en la base de datos. <br />" +
                "El mensaje específico de error es: <br /><br />" +
                ex.Message;
            return false;
        }


        return true; 
    }

    private bool ValidarObtenerNumeroContab(DateTime dFecha, int nCiaContab, string sTipoAsiento,
        out string sMensajeError)
    {
        // esta función valida que un número de asiento contable pueda ser obtenido en forma normal. En 
        // particular, es importante para asientos que correspondan a contabilidades cuyo número se obtiene 
        // en base al tipo del asiento; para estos casos, si el tipo no tiene un grupo asociado en la tabla 
        // tGruposDeTiposDeAsiento, el número Contab para el asiento NO PODRÁ ser obtenido en forma 
        // adecuada. 

        // Esta función debe ser ejecutada para que efectúe la validación mencionada ANTES de intentar 
        // grabar un asiento, aunque éste tenga un número Contab negativo. Pues luego, cuando se intente 
        // obtener su número Contab definitivo, el proceso fallará. 

        sMensajeError = "";

        // antes que nada, nos aseguramos que el tipo de asiento exista 

        int nRecCount = (from ta in _dbContab.TiposDeAsientos
                           where ta.Tipo == sTipoAsiento 
                           select ta).Count();

        if (nRecCount == 0)
        {
            sMensajeError = "El tipo de asiento asociado al asiento contable no fue encontrado en Contab."; 
            return false;
        }

        int nMesCalendario = dFecha.Month;
        int nAnoCalendario = dFecha.Year;

        // determinamos si el número se genera de acuerdo al tipo 

        bool? bNumeracionSeparadaPorTipo = (from par in _dbContab.ParametrosContabs
                                            where par.Cia == nCiaContab
                                            select par.NumeracionAsientosSeparadaFlag).FirstOrDefault();

        if (bNumeracionSeparadaPorTipo == null)
        {
            sMensajeError = " ... aparentemente, no se ha definido si la numeración de los asientos es o no separada de acuerdo a su tipo.<br /><br />" +
                "Por favor abra la tabla <i>Parámetros</i> en <i>Contab</i> y defina un valor para este item.";

            return false;
        }

        if (bNumeracionSeparadaPorTipo.Value)
        {
            // NOTESE que NO VALIDAMOS los casos en los cuales la númeración NO ES por tipo de asiento; 
            // ASUMIMOS que, para estos casos, el número podrá ser obtenido en forma normal. 

            // leemos el grupo de la tabla TiposDeAsiento 
            // leemos el número del asiento de la tabla AsientosIdPorGrupo

            int? nGrupo = (from t in _dbContab.TiposDeAsientos
                           where t.Tipo == sTipoAsiento
                           select t.Grupo).FirstOrDefault();

            if (nGrupo == null)
            {
                sMensajeError = " ... aparentemente, no se ha definido el Grupo que corresponde al tipo de asientos que Ud. ha indicado para el asiento contable.<br />" +
                    "Como la numeración de los asientos contables es separada de acuerdo a su tipo (según está ahora definido en el sistema <i>Contab</i>), cada tipo debe corresponder a un grupo.<br />" +
                    "Por favor abra la tabla <i>Tipos de Asiento</i> en <i>Contab</i> y defina un valor para este item.";

                return false;
            }

            AsientosIdPorGrupo MyAsientosIdPorGrupo = (from aidg in _dbContab.AsientosIdPorGrupos
                                                       where aidg.Mes == nMesCalendario &&
                                                       aidg.Ano == nAnoCalendario &&
                                                       aidg.Grupo == nGrupo.Value &&
                                                       aidg.Cia == nCiaContab
                                                       select aidg).SingleOrDefault();

            if (MyAsientosIdPorGrupo == null)
            {
                // no existe un registro en la tabla para el mes, año y cia. Buscamos el número INICIAL 
                // en la tabla tGruposDeTiposDeAsiento 

                var MyGrupoTipoAsiento = (from g in _dbContab.tGruposDeTiposDeAsientos
                                          where g.Grupo == nGrupo
                                          select g).FirstOrDefault();

                if (MyGrupoTipoAsiento == null || MyGrupoTipoAsiento.NumeroInicial == null)
                {
                    sMensajeError = " ... aparentemente, no se ha definido el Grupo que corresponde al tipo de asientos que Ud. ha indicado para el asiento contable.<br />" +
                        "Como la numeración de los asientos contables es separada de acuerdo a su tipo (según está ahora definido en el sistema <i>Contab</i>), cada tipo debe corresponder a un grupo.<br />" +
                        "Por favor abra la tabla <i>Tipos de Asiento</i> en <i>Contab</i> y defina un valor para este item;<br />" +
                        "o, abra la tabla <i>Grupos de tipos de asiento</i> y defina un grupo y un número de inicio para este grupo.";

                    return false;
                }
            }
        }

        return true;
    }


    // esta función recibe una fecha y una cia contab. 
    // determina y regresa el mes y año fiscal para esa fecha y cia 
    public bool DeterminarMesFiscal(DateTime dFecha, int nCiaContab, out string sMensajeError, out Int16 nMesFiscal, out Int16 nAnoFiscal)
    {
        nMesFiscal = 0;
        nAnoFiscal = 0;
        sMensajeError = "";

        var MesFiscal = (from mf in _dbContab.MesesDelAnoFiscals
                         where mf.Mes == dFecha.Month && mf.Cia == nCiaContab
                         select new { mf.MesFiscal, mf.Ano }).FirstOrDefault();

        if (MesFiscal == null)
        {
            sMensajeError = " hemos encontrado un error al intentar leer la tabla de meses en Contab.<br /> " +
                "No existe un registro en la tabla 'meses y sus fechas' que corresponda al mes calendario " +
                "indicado (" + dFecha.Month.ToString() + ").<br /> Por favor revise esta situación antes de continuar. ";
            return false;
        }

        nMesFiscal = MesFiscal.MesFiscal;
        nAnoFiscal = Convert.ToInt16(dFecha.Year);

        if (MesFiscal.Ano == 1)
            nAnoFiscal += 1;

        return true;
    }


    // esta función recibe un mes fiscal, año fiscal y fecha 
    // determina el último mes cerrado para esa fecha 
    // Nótese que *antes* se debe tener a mano el mes y año *fiscales* para la fecha 

    // NOTA: esta función regresa False si el mes está cerrado 
    public bool ValidarUltimoMesCerradoContab(DateTime dFechaAsiento, int nCiaContab, out string sMensajeError)
    {
        sMensajeError = "";

        // -------------------------------------------------------------------------------------------------
        // primero leemos el Ultimo Mes Cerrado para la cia contab 
        var UltimoMesCerrado = (from umc in _dbContab.UltimoMesCerradoContabs
                                where umc.Cia == nCiaContab
                                select new { umc.Mes, umc.Ano }).FirstOrDefault();

        if (UltimoMesCerrado == null)
        {
            sMensajeError = " ... hemos encontrado un error al intentar leer el 'último mes cerrado'. <br />" +
            "Aparentemente, no hay un valor válido en esta tabla para la compañía seleccionada. <br />" +
                "Por favor revice esta situación antes de continuar.";

            return false;
        }

        // -------------------------------------------------------------------------------------------------
        // ahora determinamos el mes y año fiscal para la fecha 
        short nMesFiscal = 0;
        short nAnoFiscal = 0;
        string mensajeError = ""; 

        var result = this.DeterminarMesFiscal(dFechaAsiento, nCiaContab, out mensajeError, out nMesFiscal, out nAnoFiscal);

        if (!result)
        {
            sMensajeError = " ... hemos encontrado un error al intentar determinar el mes y año fiscal para la fecha indicada (" + 
                            dFechaAsiento.ToString("dd-MMM-yyyy") + "). <br />" +
                            "El mensaje de error obtenido es: <br />" + sMensajeError;

            return false;
        }

        // -------------------------------------------------------------------------------------------------
        // finalmente determinamos si el año y mes (fiscal) para la fecha indicada está cerrado en Contab 
        // Nota: normalmente, tal como se usa esta función en el programa, si el mes está cerrado es un error, 
        // pues se intenta, por ejemplo, editar un asiento que corresponde a un mes cerrado. 

        // en todo caso, esta función solo determina si la fecha pasada corresponde a un mes cerrado en Contab 
        if ((nAnoFiscal < UltimoMesCerrado.Ano) || (nAnoFiscal == UltimoMesCerrado.Ano & nMesFiscal <= UltimoMesCerrado.Mes))
        {
            sMensajeError = " ... la fecha ('" + dFechaAsiento.ToString("dd-MMM-yyyy") + "') del asiento " +
                "que se desea registrar, corresponde a un mes ya cerrado en Contab " +
                "(para la compañía seleccionada).<br /><br />" +
                "Este proceso ha detenido su ejecución antes de registrar el asiento en Contab. ";
            return false;
        }

        return true;
    }

    private bool ObtenerNumeroNegativoAsiento(DateTime dFecha, int nCiaContab, out string sMensajeError,
        out int nNumeroNegativoAsientoContable)
    {
        // esta función regresa un número negativo para el asiento contable. Para ello, lee la tabla 
        // AsientosNegativosId. NOTESE que la tabla se lee por mes y año calendario, en vez de usar los 
        // valores fiscales (ie: mes y año fiscal). 

        sMensajeError = "";
        nNumeroNegativoAsientoContable = 0;

        int nMesCalendario = dFecha.Month;
        int nAnoCalendario = dFecha.Year;

        var NumeroContabNegativo = (from nn in _dbContab.AsientosNegativosIds
                                    where nn.Mes == nMesCalendario &&
                                    nn.Ano == nAnoCalendario &&
                                    nn.Cia == nCiaContab
                                    select nn).FirstOrDefault();

        if (NumeroContabNegativo == null)
        {
            // no existe un registro para el mes/año/cia; agregamos uno 

            nNumeroNegativoAsientoContable = 1;

            AsientosNegativosId MyAsientoNegativo = new AsientosNegativosId();

            MyAsientoNegativo.Mes = Convert.ToInt16(nMesCalendario);
            MyAsientoNegativo.Ano = Convert.ToInt16(nAnoCalendario);
            MyAsientoNegativo.Cia = nCiaContab;
            MyAsientoNegativo.Numero = 2;

            _dbContab.AsientosNegativosIds.InsertOnSubmit(MyAsientoNegativo);

            try
            {
                _dbContab.SubmitChanges();
            }
            catch (Exception ex)
            {
                sMensajeError = " ... hemos obtenido un error al intentar efectuar una operación en la base de datos.<br />" +
                "El mensaje específico de error es: <br /><br />" + ex.Message;

                return false;
            }
        }
        else
        {
            nNumeroNegativoAsientoContable = NumeroContabNegativo.Numero;

            // aumentamos el número en 1 y actualizamos la tabla 

            NumeroContabNegativo.Numero += 1;

            try
            {
                _dbContab.SubmitChanges();
            }
            catch (Exception ex)
            {
                sMensajeError = " ... hemos obtenido un error al intentar efectuar una operación en la base de datos.<br />" +
                "El mensaje específico de error es: <br /><br />" + ex.Message;

                return false;
            }
        }

        nNumeroNegativoAsientoContable *= -1;
        return true;
    }

    private bool ObtenerClaveUnicaAsiento(out string sMensajeError, out int nClaveUnicaAsientoContable)
    {
        // Cada asiento contable tiene una clave primaria (PK) que se llama ClaveUnica. Esta función 
        // determina el número actual que corresponde a esa clave. NOTESE que este valor (Clave Unica) 
        // NO SE separa por Cia Contab; todas las compañías comparten el mismo número (o la misma 
        // numeración) 

        sMensajeError = "";
        nClaveUnicaAsientoContable = 0;

        var ClaveUnicaAsientoContable = (from pk in _dbContab.AsientosClaveUnicaIds
                                         select pk).FirstOrDefault();

        if (ClaveUnicaAsientoContable == null)
        {
            // no existe un registro en la tabla; agregamos uno 

            nClaveUnicaAsientoContable = 1;

            AsientosClaveUnicaId MyPKAsientoContable = new AsientosClaveUnicaId();
            MyPKAsientoContable.Numero = 2;
            _dbContab.AsientosClaveUnicaIds.InsertOnSubmit(MyPKAsientoContable);

            try
            {
                _dbContab.SubmitChanges();
            }
            catch (Exception ex)
            {
                sMensajeError = " ... hemos obtenido un error al intentar efectuar una operación en la base de datos.<br />" +
                "El mensaje específico de error es: <br /><br />" + ex.Message;

                return false;
            }
        }
        else
        {
            nClaveUnicaAsientoContable = ClaveUnicaAsientoContable.Numero;

            // nótese como tenemos que eliminar el registro y agregar uno nuevo, pues LinqToSql no puede 
            // actualizar un PK (???) 

            try
            {
                _dbContab.AsientosClaveUnicaIds.DeleteOnSubmit(ClaveUnicaAsientoContable);
                _dbContab.SubmitChanges();

                AsientosClaveUnicaId MyPKAsientoContable = new AsientosClaveUnicaId();
                MyPKAsientoContable.Numero = nClaveUnicaAsientoContable + 1;
                _dbContab.AsientosClaveUnicaIds.InsertOnSubmit(MyPKAsientoContable);
                _dbContab.SubmitChanges();

            }
            catch (Exception ex)
            {
                sMensajeError = " ... hemos obtenido un error al intentar efectuar una operación en la base de datos.<br />" +
                "El mensaje específico de error es: <br /><br />" + ex.Message;

                return false;
            }
        }

        return true;
    }

    public bool AsignarNumeroContab(_AsientoContable AsientoContable, out string sErrMessage)
    {
        sErrMessage = "";


        // Determinamos un número Contab para el asiento contable pasado a esta función 
        // y lo asignamos al asiento que fue grabado previamente (con un número negativo) 

        if (AsientoContable.Numero > 0)
        {
            sErrMessage = "Aparentemente, ya Ud. asignó un número <i>Contab</i> a este comprobante, pues su número <b>no es</b> negativo.<br />" +
                "Esta función debe ser ejecutada para obtener números <i>Contab</i> para comprobantes cuyo número es negativo.";
            return false;
        }

        int nNumeroNegativoAnterior = AsientoContable.Numero.Value;

        int nNumeroAsientoContab = 0;

        if (!ObtenerNumeroContab(AsientoContable.Fecha, AsientoContable.CiaContab,
            AsientoContable.Tipo, out sErrMessage, out nNumeroAsientoContab))
            return false;

        // ahora actualizamos TRES tablas con el número determinado: asientos, dasientos y tTemp... 

        ContabSysNet_Web.ModelosDatos.Asiento MyAsientoContable = (from a in _dbContab.Asientos
                                     where a.Numero == AsientoContable.Numero &&
                                     a.Mes == AsientoContable.Fecha.Month &&
                                     a.Ano == AsientoContable.Fecha.Year &&
                                     a.Cia == AsientoContable.CiaContab
                                     select a).SingleOrDefault();



        if (MyAsientoContable == null)
        {
            sErrMessage = "Aparentemente, Ud. no ha registrado aún el asiento contable.<br />" +
                "Construya y registre el asiento contable primero y luego regrese a esta función para intentar asignarle un número Contab.";
            return false;
        }

        List<ContabSysNet_Web.ModelosDatos.dAsiento> MyAsientoContable_Partidas = (from a in _dbContab.dAsientos
                                                     where a.NumeroAutomatico == AsientoContable.NumeroAutomatico
                                                     select a).ToList();

        MyAsientoContable.Numero = Convert.ToInt16(nNumeroAsientoContab);
        
        try
        {
            _dbContab.SubmitChanges();
        }
        catch (Exception ex)
        {
            sErrMessage = "... se ha producido un error al intentar efectuar una operación en la base de datos. <br />" +
                "El mensaje específico de error es: <br /><br />" +
                ex.Message;
            return false;
        }

        AsientoContable.Numero = nNumeroAsientoContab; 
        return true;
    }

    private bool ObtenerNumeroContab(DateTime dFecha, int nCiaContab, string sTipoAsiento,
                                    out string sMensajeError, out int nNumeroContab)
    {
        // esta función determina y regresa un número de asiento Contab. Nótese que el número determinado 
        // depende de si se genera por grupos de tipo o no. Esto lo determina un flag en ParametrosContab: 
        // NumeracionAsientosSeparadaFlag. 

        sMensajeError = "";
        nNumeroContab = 0;

        int nMesCalendario = dFecha.Month;
        int nAnoCalendario = dFecha.Year;

        // lo primero que hacemos es determinar si el número se genera de acuerdo al tipo 

        bool? bNumeracionSeparadaPorTipo = (from par in _dbContab.ParametrosContabs
                                            where par.Cia == nCiaContab
                                            select par.NumeracionAsientosSeparadaFlag).FirstOrDefault();

        if (bNumeracionSeparadaPorTipo == null)
        {
            sMensajeError = " ... aparentemente, no se ha definido si la numeración de los asientos es o no separada de acuerdo a su tipo.<br /><br />" +
                "Por favor abra la tabla <i>Parámetros</i> en <i>Contab</i> y defina un valor para este item.";
            return false;
        }

        if (!bNumeracionSeparadaPorTipo.Value)
        {
            // la númeración NO ES separada de acuerdo al tipo del asiento. La determinación del número 
            // es más simple 

            // leemos el número del asiento de la tabla AsientosId

            AsientosId MyAsientosId = (from aid in _dbContab.AsientosIds
                                       where aid.Mes == nMesCalendario &&
                                       aid.Ano == nAnoCalendario &&
                                       aid.Cia == nCiaContab
                                       select aid).SingleOrDefault();

            if (MyAsientosId == null)
            {
                // no existe un registro en la tabla para el mes, año y cia. Lo creamos y asumimos 1 
                // como número 

                nNumeroContab = 1;

                AsientosId MyAsientosId_Nuevo = new AsientosId();

                MyAsientosId_Nuevo.Mes = Convert.ToInt16(nMesCalendario);
                MyAsientosId_Nuevo.Ano = Convert.ToInt16(nAnoCalendario);
                MyAsientosId_Nuevo.Cia = nCiaContab;
                MyAsientosId_Nuevo.Numero = 2;

                _dbContab.AsientosIds.InsertOnSubmit(MyAsientosId_Nuevo);
            }
            else
            {
                nNumeroContab = MyAsientosId.Numero;
                MyAsientosId.Numero += 1;
            }
        }
        else
        {
            // leemos el grupo de la tabla TiposDeAsiento 


            // leemos el número del asiento de la tabla AsientosIdPorGrupo

            int? nGrupo = (from t in _dbContab.TiposDeAsientos
                           where t.Tipo == sTipoAsiento
                           select t.Grupo).FirstOrDefault();

            if (nGrupo == null)
            {
                sMensajeError = " ... aparentemente, no se ha definido el Grupo que corresponde al tipo de asientos que Ud. ha indicado para el asiento contable.<br />" +
                    "Como la numeración de los asientos contables es separada de acuerdo a su tipo (según está ahora definido en el sistema <i>Contab</i>), cada tipo debe corresponder a un grupo.<br />" +
                    "Por favor abra la tabla <i>Tipos de Asiento</i> en <i>Contab</i> y defina un valor para este item.";
                return false;
            }



            AsientosIdPorGrupo MyAsientosIdPorGrupo = (from aidg in _dbContab.AsientosIdPorGrupos
                                                       where aidg.Mes == nMesCalendario &&
                                                       aidg.Ano == nAnoCalendario &&
                                                       aidg.Grupo == nGrupo.Value &&
                                                       aidg.Cia == nCiaContab
                                                       select aidg).SingleOrDefault();

            if (MyAsientosIdPorGrupo == null)
            {
                // no existe un registro en la tabla para el mes, año y cia. Buscamos el número INICIAL 
                // en la tabla tGruposDeTiposDeAsiento 

                var MyGrupoTipoAsiento = (from g in _dbContab.tGruposDeTiposDeAsientos
                                          where g.Grupo == nGrupo
                                          select g).FirstOrDefault();

                if (MyGrupoTipoAsiento == null || MyGrupoTipoAsiento.NumeroInicial == null)
                {
                    sMensajeError = " ... aparentemente, no se ha definido el Grupo que corresponde al tipo de asientos que Ud. ha indicado para el asiento contable.<br />" +
                        "Como la numeración de los asientos contables es separada de acuerdo a su tipo (según está ahora definido en el sistema <i>Contab</i>), cada tipo debe corresponder a un grupo.<br />" +
                        "Por favor abra la tabla <i>Tipos de Asiento</i> en <i>Contab</i> y defina un valor para este item;<br />" +
                        "o, abra la tabla <i>Grupos de tipos de asiento</i> y defina un grupo y un número de inicio para este grupo.";
                    return false;
                }

                nNumeroContab = MyGrupoTipoAsiento.NumeroInicial;

                AsientosIdPorGrupo MyAsientosIdPorGrupo_Nuevo = new AsientosIdPorGrupo();

                MyAsientosIdPorGrupo_Nuevo.Mes = Convert.ToInt16(nMesCalendario);
                MyAsientosIdPorGrupo_Nuevo.Ano = Convert.ToInt16(nAnoCalendario);
                MyAsientosIdPorGrupo_Nuevo.Grupo = nGrupo.Value;
                MyAsientosIdPorGrupo_Nuevo.Cia = nCiaContab;
                MyAsientosIdPorGrupo_Nuevo.Numero = MyGrupoTipoAsiento.NumeroInicial + 1;

                _dbContab.AsientosIdPorGrupos.InsertOnSubmit(MyAsientosIdPorGrupo_Nuevo);
            }
            else
            {
                nNumeroContab = MyAsientosIdPorGrupo.Numero.Value;
                MyAsientosIdPorGrupo.Numero += 1;
            }
        }


        try
        {
            _dbContab.SubmitChanges();
        }
        catch (Exception ex)
        {
            sMensajeError = " ... hemos obtenido un error al intentar efectuar una operación en la base de datos.<br />" +
            "El mensaje específico de error es: <br /><br />" + ex.Message;
            return false;
        }

        return true;
    }

    public bool ValidarUltimoMesCerradoBancos(DateTime fecha, int ciaContab, BancosEntities bancosContext)
    {
        var UltimoMesCerrado = (from umc in bancosContext.UltimoMesCerradoes
                                where umc.Cia == ciaContab
                                select umc).FirstOrDefault();

        if (UltimoMesCerrado == null)
            return false;


        if ((fecha.Year < UltimoMesCerrado.Ano) || (fecha.Year == UltimoMesCerrado.Ano & fecha.Month <= UltimoMesCerrado.Mes))
            return false;


        return true;
    }
}
