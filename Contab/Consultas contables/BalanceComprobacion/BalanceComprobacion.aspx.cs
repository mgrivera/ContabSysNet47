using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.HtmlControls; 
using System.Web.Security;
using System.Threading;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using System.Web.UI.WebControls;
using ContabSysNet_Web.Clases;
using ContabSysNet_Web.ModelosDatos_EF.code_first.contab;

namespace ContabSysNet_Web.Contab.Consultas_contables.BalanceComprobacion
{
    public partial class BalanceComprobacion : System.Web.UI.Page
    {
        private class CuentaContable_Object
        {
            public int CuentaContableID { get; set; }
            public string CuentaContable { get; set; }
            public string NombreCuentaContable { get; set; }

            public int GrupoContable { get; set; }
            public string NombreGrupoContable { get; set; }
            public Int16 GrupoContable_OrdenBalance { get; set; }
            public int CiaContab { get; set; }
            public string NombreCiaContab { get; set; }
            public string CuentaContableEditada { get; set; }
            public int Moneda { get; set; }
            public string NombreMoneda { get; set; }
            public string SimboloMoneda { get; set; }
            public string CuentaContable_NivelPrevio { get; set; }

            public string Nivel1 { get; set; }
            public string Nivel2 { get; set; }
            public string Nivel3 { get; set; }
            public string Nivel4 { get; set; }
            public string Nivel5 { get; set; }
            public string Nivel6 { get; set; }

            public byte NumNiveles { get; set; }
        }

        private class BalanceComprobacion_Item
        {
            public int CuentaContableID { get; set; }
            public int Moneda { get; set; }
            public string NivelPrevioCuentaContable { get; set; }
            public string NivelPrevioCuentaContable_Nombre { get; set; }
            public string nivel1 { get; set; }
            public string nivel2 { get; set; }
            public string nivel3 { get; set; }
            public string nivel4 { get; set; }
            public string nivel5 { get; set; }
            public string nivel6 { get; set; }
            public decimal SaldoAnterior { get; set; }
            public decimal Debe { get; set; }
            public decimal Haber { get; set; }
            public decimal SaldoActual { get; set; }
            public int CantidadMovimientos { get; set; }
            public int Cia { get; set; } 
        }

        private class Cuenta_Nombre
        {
            public string cuenta { get; set; }
            public string descripcion { get; set; }
        }

        // para pasar como 'parámetro' la fecha now al procedimiento RefreshAndBindInfo; como lo ejecutamos como 
        // una tarea separada, no podemos pasar parámetros al ejecutarlo (??!!) 

        public System.DateTime _FechaInicioProceso;

        private class CantidadRecords_Object
        {
            public int RecordCount = 0;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            ErrMessage_Span.InnerHtml = "";
            ErrMessage_Span.Style["display"] = "none";

            Master.Page.Title = "Balance de Comprobación";

            if (!Page.IsPostBack)
            {

                // Gets a reference to a Label control that is not in a ContentPlaceHolder control
                HtmlContainerControl MyHtmlSpan;

                MyHtmlSpan = (HtmlContainerControl)Master.FindControl("AppName_Span");
                if (!(MyHtmlSpan == null))
                {
                    MyHtmlSpan.InnerHtml = "Contab";
                }

                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    MyHtmlH2.InnerHtml = "Balance de Comprobación";
                }

                // --------------------------------------------------------------------------------------------
                // para asignar la página que corresponde al help de la página 

                HtmlAnchor MyHtmlHyperLink;
                MyHtmlHyperLink = (HtmlAnchor)Master.FindControl("Help_HyperLink");

                MyHtmlHyperLink.HRef = "javascript:PopupWin('../../../Doc/Contab/Balance comprobacion/Balance de comprobacion.htm', 1000, 680)";

                Session["FiltroForma"] = null;
            }

            else
            {
                // -------------------------------------------------------------------------
                // la página puede ser 'refrescada' por el popup; en ese caso, ejeucutamos  
                // una función que efectúa alguna funcionalidad y rebind la información 
                if (ExecuteThread_HiddenField.Value == "1")
                {
                    // cuando este html item es 1, ejecutamos el thread que construye la selección y la graba 
                    // a una tabla en la base de datos  
                    ExecuteThread_HiddenField.Value = "0";

                    // nótese como ejecutamos el sub que sigue en un thread diferente 

                    // ------------------------------------------------------------------------------
                    // inicializamos antes las variables que indican que debemos mostrar el progreso 
                    Session["Progress_Completed"] = 0;
                    Session["Progress_Percentage"] = 0;
                    Session["Progress_SelectedRecs"] = 0;

                    // para que el thread regrese algún mensaje de error ... 
                    Session["Thread_ErrorMessage"] = ""; 
                    // ------------------------------------------------------------------------------

                    Thread MyThread = new Thread(RefreshAndBindInfo);
                    MyThread.Priority = ThreadPriority.Lowest;
                    MyThread.Start();

                    // ejecutamos javascript para que lea la variable session y muestre el progreso 
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append("<script language='javascript'>");
                    sb.Append("showprogress();");
                    sb.Append("</script>");

                    ClientScript.RegisterStartupScript(this.GetType(), "onLoad", sb.ToString());
                }
                else
                {
                    if (RebindPage_HiddenField.Value == "1")
                    {
                        // cuando este html item es 1 terminó el thread que construye la selección. Entonces 
                        // se hace un refresh de la página y ejecutamos aquí el procedimiento que hace el 
                        // databind a los controles para que muestren los datos al usuario 
                        RebindPage_HiddenField.Value = "0";
                        SelectedRecs_HiddenField.Value = Session["Progress_SelectedRecs"].ToString();

                        if (!string.IsNullOrEmpty(Session["Thread_ErrorMessage"].ToString()))
                        {
                            ErrMessage_Span.InnerHtml = Session["Thread_ErrorMessage"].ToString();
                            ErrMessage_Span.Style["display"] = "block";

                            return;
                        }

                        PageDataBind();

                        System.Text.StringBuilder sb = new System.Text.StringBuilder();
                        sb.Append("<script language='javascript'>");
                        sb.Append("showprogress_displayselectedrecs();");
                        sb.Append("</script>");

                        ClientScript.RegisterStartupScript(this.GetType(), "onLoad", sb.ToString());
                    }
                }
                // -------------------------------------------------------------------------
            }
        }

        private void RefreshAndBindInfo()
        {
            if (this.User != null && this.User.Identity != null && !User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            if (Session["FiltroForma"] == null) {
                Session["Thread_ErrorMessage"] = "Aparentemente, Ud. no ha indicado un filtro aún.<br /> " + 
                    "Por favor indique y aplique un filtro antes de intentar mostrar el resultado de " + 
                    "la consulta.";
                return;
            }

            Session["Progress_Percentage"] = 0;
            string errorMessage = "";

            // nota importante: esta consulta (y otras?) deben, al menos por ahora, ser pedidas para una CiaContab 
            // en particular, pues los años fiscales para las Cias Contab pueden variar entre ellas ... 
            if (Session["CiaContabSeleccionada"] == null)
            {
                // el usuario debe seleccionar una cia contab en particular, pues los saldos contables se leen 
                // de acuerdo al año fiscal de la misma ... 

                Session["Thread_ErrorMessage"] = "Aparentemente, no se ha seleccionado una Cia Contab.<br /> " +
                    "Por favor seleccione una Cia Contab al establecer el filtro a usar para esta consulta.";

                Session["Progress_SelectedRecs"] = 0;
                Session["Progress_Completed"] = 1;
                Session["Progress_Percentage"] = 0;

                return;
            }

            var ciaContabSeleccionada = Convert.ToInt32(Session["CiaContabSeleccionada"].ToString());

            var dFechaInicialPeriodoIndicado = (System.DateTime)Session["FechaInicialPeriodo"];
            var dFechaFinalPeriodoIndicado = (System.DateTime)Session["FechaFinalPeriodo"];

            bool bReconvertirCifrasAntes_01Oct2021 = (bool)Session["ReconvertirCifrasAntes_01Oct2021"];
            bool bExcluirAsientosReconversion_01Oct2021 = (bool)Session["ExcluirAsientosReconversion_01Oct2021"];

            bool bExcluirAsientosTipoCierreAnual = (bool)Session["ExcluirAsientosTipoCierreAnual"];

            // ----------------------------------------------------------------------------------------------------------------------
            // leemos la tabla de monedas para 'saber' cual es la moneda Bs. Nota: la idea es aplicar las opciones de reconversión 
            // *solo* a esta moneda 
            var monedaNacional_return = Reconversion.Get_MonedaNacional();

            if (monedaNacional_return.error)
            {
                ErrMessage_Span.InnerHtml = monedaNacional_return.message;
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            Monedas monedaNacional = monedaNacional_return.moneda;
            Session["monedaNacional"] = monedaNacional.Moneda; 
            // ----------------------------------------------------------------------------------------------------------------------

            // --------------------------------------------------------------------------------------------
            // eliminamos el contenido de la tabla temporal
            dbContab_Contab_Entities dbContext = new dbContab_Contab_Entities();
            try 
            {
                int cantRegistrosEliminados = dbContext.ExecuteStoreCommand("Delete From Contab_BalanceComprobacion Where NombreUsuario = {0}", Membership.GetUser().UserName);
            }
            catch (Exception ex) {
                dbContext.Dispose();

                Session["Thread_ErrorMessage"] = "Ha ocurrido un error al intentar ejecutar una operación de " + 
                    "acceso a la base de datos. <br /> El mensaje específico de error es: " + ex.Message + 
                    "<br /><br />";
                return;
            }

            // -----------------------------------------------------------------------------------------------
            // para evitar que el reporte se genere en forma incompleta, intentamos buscar cuentas que tengan 
            // asientos, más no registros en SaldosContables. De haberlas, lo notificamos al usuario y le 
            // indicamos que ejecute un cierre contable para corregir esta situación 

            string filtroFormParaAsientos = Session["FiltroForma"].ToString();
            filtroFormParaAsientos = filtroFormParaAsientos.Replace("SaldosContables", "Asientos");

            string filtroFormaParaSaldosContables = Session["FiltroForma"].ToString();

            string sSqlQueryString = "Select dAsientos.CuentaContableID From dAsientos " +
                "Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico " +
                "Inner Join CuentasContables On dAsientos.CuentaContableID = CuentasContables.ID " +
                "Where Asientos.Fecha Between '" + dFechaInicialPeriodoIndicado.ToString("yyyy-MM-dd") + "' And '" +
                dFechaFinalPeriodoIndicado.ToString("yyyy-MM-dd") + "' And " +
                filtroFormParaAsientos +
                " And dAsientos.CuentaContableID Not In " +
                "(Select CuentaContableID From SaldosContables Inner Join CuentasContables On SaldosContables.CuentaContableID = CuentasContables.ID " +
                "Where " + filtroFormaParaSaldosContables + ")";

            int nCuentasSinSaldo = dbContext.ExecuteStoreQuery<int>(sSqlQueryString).Count();

            if (nCuentasSinSaldo > 0)
            {
                // hay cuentas contables en asientos que no tienen un registro en SaldosContables; lo notificamos al 
                // usuario para que corrija esta situación con un cierre contable 
                Session["Thread_ErrorMessage"] = "Existen cuentas contables usadas en asientos contables que no tienen " +
                    "un registro en la tabla de saldos. <br /> " +
                    "Por favor ejecute un cierre contable para el mes (o los meses) de esta consulta, " +
                    "para corregir esta situación (y agregar un registro de saldos a las cuentas contables que no lo tienen).";

                Session["Progress_SelectedRecs"] = 0;
                Session["Progress_Completed"] = 1;
                Session["Progress_Percentage"] = 0;

                return;
            }

            // hacemos una validación similar a la anterior, pero esta vez buscando cuentas contables que hayan cambiado de detalle a total
            // recuérdese que solo cuentas de tipo detalle pueden recibir asientos; notificamos ésto al usuario, para que corrija esta 
            // situación antes de continuar ... 
            sSqlQueryString = "Select CuentasContables.CuentaEditada + ' ' + CuentasContables.Descripcion From dAsientos " +
                                    "Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico " +
                                    "Inner Join CuentasContables On dAsientos.CuentaContableID = CuentasContables.ID " +
                                    "Where Asientos.Fecha Between '" + dFechaInicialPeriodoIndicado.ToString("yyyy-MM-dd") + "' And '" +
                                    dFechaFinalPeriodoIndicado.ToString("yyyy-MM-dd") + "' And " +
                                    filtroFormParaAsientos +
                                    " And CuentasContables.TotDet <> 'D'";

            List<string> query0 = dbContext.ExecuteStoreQuery<string>(sSqlQueryString).ToList();

            errorMessage = "";

            foreach (string cuentaTipoTotal in query0)
            {
                if (string.IsNullOrEmpty(errorMessage))
                    errorMessage = cuentaTipoTotal;
                else
                    errorMessage += ", " + cuentaTipoTotal;  
            }

            if (errorMessage != "")
            {
                Session["Thread_ErrorMessage"] = "Aparentemente, existen cuentas contables que han recibido asientos contables en el período indicado y que " +
                    "no son de tipo 'detalle'; <br />deben serlo, pues solo cuentas de tipo 'detalle' pueden recibir asientos. <br /> " +
                    "Es probable que una cuenta de tipo 'detalle' y que recibió asientos en el período indicado, fue cambiada a tipo 'total' y mantuvo sus asientos.<br /> " +
                    "A continuación mostramos las cuentas que están en este estado y que ha detectado este proceso: " + errorMessage;

                Session["Progress_SelectedRecs"] = 0;
                Session["Progress_Completed"] = 1;
                Session["Progress_Percentage"] = 0;

                return;
            }; 

            // para leer los saldos, debemos determinar el año fiscal de la Cia Contab; un año calendario puede ser 
            // 2013 y el año fiscal 2012. Los saldos contables se registran para el año fiscal. Por esta razón, 
            // debemos obtenerlo *antes* de hacer el select que sigue
            GetMesFiscalContable MyGetMesFiscalContable = new GetMesFiscalContable(dFechaInicialPeriodoIndicado, ciaContabSeleccionada);

            string sErrorMessage = "";

            // antes usabamos Linq to Sql en vez de EF ... 
            ContabSysNet_Web.ModelosDatos.dbContabDataContext ContabDB = new ContabSysNet_Web.ModelosDatos.dbContabDataContext();   
            MyGetMesFiscalContable.dbContabDataContext = ContabDB;

            if (!MyGetMesFiscalContable.DeterminarMesFiscal(ref sErrorMessage)) 
            {
                ContabDB.Dispose();

                ErrMessage_Span.InnerHtml = sErrorMessage;
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            int anoFiscalCiaSeleccionada = MyGetMesFiscalContable.AnoFiscal;

            // ------------------------------------------------------------------------------------------------------------------------------
            // como vamos a usar esta conexión mientras se ejecute el ciclo que viene, la abrimos aquí y la cerramos al final ... 
            SqlConnection sqlConnection = new SqlConnection();
            sqlConnection.ConnectionString = ConfigurationManager.ConnectionStrings["dbContabConnectionString"].ConnectionString;
            sqlConnection.Open();

            // -----------------------------------------------------------------------------------------------------
            // usamos esta clase para leer los movimientos (debe, haber) para cada cuenta contable y moneda 
            DeterminarMovimientoCuentaContable determinarMovimientoCuentaContable = new DeterminarMovimientoCuentaContable(sqlConnection, 
                                                                                                                           bExcluirAsientosTipoCierreAnual,  
                                                                                                                           bReconvertirCifrasAntes_01Oct2021,
                                                                                                                           bExcluirAsientosReconversion_01Oct2021, 
                                                                                                                           dFechaInicialPeriodoIndicado, 
                                                                                                                           dFechaFinalPeriodoIndicado, monedaNacional.Moneda); 

            // -----------------------------------------------------------------------------------------------------
            // primero determinamos la cantidad de registros, para mostrar progreso al usuario

            // NOTA IMPORTANTE: usamos el año para leer en la tabla SaldosContables SOLO cuentas/monedas/cias que
            // corresopondan al año indicado. Recuérdese que una cuenta/moneda/cia puede tener MUCHOS registros
            // en SaldosContables, uno para cada año. SIN EMBARGO, deberíamos usar el año fiscal y no el año de
            // la fecha inicial del período (año calendario). Lo hacemos así, sabiendo que muy pocas veces ésto
            // tendrá un efecto importante en el proceso. Creo que bastaría con hacer un cierre contable anual en
            // los casos en que el efecto exista

            // ----------------------------------------------------------------------
            // ahora ejecutamos el query para que regrese los rows uno a uno

            // leemos las cuentas contables y todos sus datos de compañías, grupos, monedas, etc. Nótese que leemos
            // SOLO las que tienen un registro en SaldosContables y para el año de la fecha de inicio. La idea es
            // solo traernos cuentas que tengan un registro en SaldosContables, no leer su saldo, lo cual hacemos
            // más adelante, para cada una, en el loop que sigue

            // nótese como cambiamos el Select que sigue, para eliminar la tabla SaldosContables de la 
            // sección Inner Join. La razón es que, a veces, puede ocurrir que una cuenta tiene asientos 
            // más no tiene un registro en SaldosContables. Imaginamos que ésto puede ocurrir cuando una 
            // cuenta se usa por 1ra. vez y no se ha corrido el cierre contable aún para el mes del reporte. 

            // ordenamos por CiaContab para que la lista que resulta de aquí también lo esté

            sSqlQueryString = "Select Distinct CuentasContables.ID As CuentaContableID, CuentasContables.Cuenta As CuentaContable, " +
                "CuentasContables.Descripcion As NombreCuentaContable, " +
                "tGruposContables.Grupo As GrupoContable, " +
                "tGruposContables.Descripcion As NombreGrupoContable, " +
                "IsNull(tGruposContables.OrdenBalanceGeneral, 0) As GrupoContable_OrdenBalance, " +
                "CuentasContables.Cia As CiaContab, Companias.NombreCorto As NombreCiaContab, " +
                "CuentaEditada As CuentaContableEditada, Monedas.Moneda, Monedas.Descripcion As " +
                "NombreMoneda, " + "Monedas.Simbolo As SimboloMoneda, " +
                "Case NumNiveles When 2 Then Nivel1 When 3 Then Nivel1 + Nivel2 When 4 Then Nivel1 + " +
                "Nivel2 + Nivel3 " + "When 5 Then Nivel1 + Nivel2 + Nivel3 + Nivel4 When 6 Then Nivel1 + " +
                "Nivel2 + Nivel3 + Nivel4 + Nivel5 " +
                "When 7 Then Nivel1 + Nivel2 + Nivel3 + Nivel4 + Nivel5 + Nivel6 End AS " +
                "CuentaContable_NivelPrevio, " + 
                "Nivel1, Nivel2, Nivel3, Nivel4, Nivel5, Nivel6, NumNiveles " +
                "From CuentasContables " +
                "Inner Join Companias On CuentasContables.Cia = Companias.Numero " +
                "Inner Join SaldosContables On CuentasContables.ID = SaldosContables.CuentaContableID " +
                "Inner Join Monedas On SaldosContables.Moneda = Monedas.Moneda " +
                "Inner Join tGruposContables On CuentasContables.Grupo = tGruposContables.Grupo " +
                "Where CuentasContables.TotDet = 'D' And SaldosContables.Ano = " +
                anoFiscalCiaSeleccionada.ToString() +
                " And " + Session["FiltroForma"].ToString() + " Order by CuentasContables.Cia";

            List<CuentaContable_Object> query = dbContext.ExecuteStoreQuery<CuentaContable_Object>(sSqlQueryString).ToList();

            if (query.Count() == 0)
            {
                Session["Thread_ErrorMessage"] = "No existen registros que cumplan el criterio de selección " + 
                    "(filtro) que Ud. ha indicado. <br /> Para regresar registros, " + 
                    "Ud. puede intentar un filtro diferente al que ha indicado.";

                Session["Progress_SelectedRecs"] = 0;
                Session["Progress_Completed"] = 1;
                Session["Progress_Percentage"] = 0;

                return;
            }

            // ---------------------------------------------------------------------------------------------
            // variables usadas para mostrar el meter en la página ... 
            int nCantidadRegistros = query.Count();

            int nRegistroActual = 0;
            int nProgreesPercentaje = 0;

            string nombreUsuario = Membership.GetUser().UserName;

            Session["Progress_SelectedRecs"] = 0;
            // ---------------------------------------------------------------------------------------------

            List<BalanceComprobacion_Item> MyBalanceComprobacion_Lista = new List<BalanceComprobacion_Item>();
            BalanceComprobacion_Item MyBalanceComprobacion_Record;

            foreach (CuentaContable_Object MyComprobanteContable_Query in query)
            {
                MyBalanceComprobacion_Record = new BalanceComprobacion_Item();

                MyBalanceComprobacion_Record.CuentaContableID = MyComprobanteContable_Query.CuentaContableID;
                MyBalanceComprobacion_Record.Moneda = MyComprobanteContable_Query.Moneda;
                MyBalanceComprobacion_Record.NivelPrevioCuentaContable = MyComprobanteContable_Query.CuentaContable_NivelPrevio;
                MyBalanceComprobacion_Record.Cia = MyComprobanteContable_Query.CiaContab;

                // nótese como agregamos todos los niveles 'previos' de la cuenta, para poder totalizar por éstos en el reporte ... 
                switch (MyComprobanteContable_Query.NumNiveles)
                { 
                    case 2:
                        MyBalanceComprobacion_Record.nivel1 = MyComprobanteContable_Query.Nivel1; 
                        break; 
                    case 3: 
                        MyBalanceComprobacion_Record.nivel1 = MyComprobanteContable_Query.Nivel1;
                        MyBalanceComprobacion_Record.nivel2 = MyBalanceComprobacion_Record.nivel1 + MyComprobanteContable_Query.Nivel2;  
                        break; 
                    case 4: 
                        MyBalanceComprobacion_Record.nivel1 = MyComprobanteContable_Query.Nivel1;
                        MyBalanceComprobacion_Record.nivel2 = MyBalanceComprobacion_Record.nivel1 + MyComprobanteContable_Query.Nivel2;
                        MyBalanceComprobacion_Record.nivel3 = MyBalanceComprobacion_Record.nivel2 + MyComprobanteContable_Query.Nivel3; 
                        break; 
                    case 5: 
                        MyBalanceComprobacion_Record.nivel1 = MyComprobanteContable_Query.Nivel1;
                        MyBalanceComprobacion_Record.nivel2 = MyBalanceComprobacion_Record.nivel1 + MyComprobanteContable_Query.Nivel2;
                        MyBalanceComprobacion_Record.nivel3 = MyBalanceComprobacion_Record.nivel2 + MyComprobanteContable_Query.Nivel3;
                        MyBalanceComprobacion_Record.nivel4 = MyBalanceComprobacion_Record.nivel3 + MyComprobanteContable_Query.Nivel4;
                        break;
                    case 6:
                        MyBalanceComprobacion_Record.nivel1 = MyComprobanteContable_Query.Nivel1;
                        MyBalanceComprobacion_Record.nivel2 = MyBalanceComprobacion_Record.nivel1 + MyComprobanteContable_Query.Nivel2;
                        MyBalanceComprobacion_Record.nivel3 = MyBalanceComprobacion_Record.nivel2 + MyComprobanteContable_Query.Nivel3;
                        MyBalanceComprobacion_Record.nivel4 = MyBalanceComprobacion_Record.nivel3 + MyComprobanteContable_Query.Nivel4;
                        MyBalanceComprobacion_Record.nivel5 = MyBalanceComprobacion_Record.nivel4 + MyComprobanteContable_Query.Nivel5;
                        break;
                    case 7:
                        MyBalanceComprobacion_Record.nivel1 = MyComprobanteContable_Query.Nivel1;
                        MyBalanceComprobacion_Record.nivel2 = MyBalanceComprobacion_Record.nivel1 + MyComprobanteContable_Query.Nivel2;
                        MyBalanceComprobacion_Record.nivel3 = MyBalanceComprobacion_Record.nivel2 + MyComprobanteContable_Query.Nivel3;
                        MyBalanceComprobacion_Record.nivel4 = MyBalanceComprobacion_Record.nivel3 + MyComprobanteContable_Query.Nivel4;
                        MyBalanceComprobacion_Record.nivel5 = MyBalanceComprobacion_Record.nivel4 + MyComprobanteContable_Query.Nivel5;
                        MyBalanceComprobacion_Record.nivel6 = MyBalanceComprobacion_Record.nivel5 + MyComprobanteContable_Query.Nivel6;
                        break; 
                }
             
                MyBalanceComprobacion_Lista.Add(MyBalanceComprobacion_Record);

                // --------------------------------------------------------------------------------------
                // ... para reportar el progreso al usuario; la página ejecuta un ws que lee el valor de
                // estas session variables
                nRegistroActual += 1;
                nProgreesPercentaje = nRegistroActual * 100 / nCantidadRegistros;

                Session["Progress_Percentage"] = nProgreesPercentaje;
                Session["Progress_SelectedRecs"] = (int)Session["Progress_SelectedRecs"] + 1;
            }

            // ---------------------------------------------------------------------------------
            // recorremos la lista para determinar saldo anterior, debe, haber y saldo actual

            // -----------------------------------------------------------------
            // determinamos la cantidad de registros para el progress al usuario
            nCantidadRegistros = MyBalanceComprobacion_Lista.Count();
            // -----------------------------------------------------------------

            nRegistroActual = 0;
            Session["Progress_Percentage"] = 0;

            int nCiaContabAnterior = -999999;

            int nMesFiscal = 0;
            int nAnoFiscal = 0;
            int nMesCalendario = 0;
            int nAnoCalendario = 0;
            string sNombreMes = "";
            System.DateTime dFechaSaldoInicial;

            Session["Progress_SelectedRecs"] = 0;

            foreach (BalanceComprobacion_Item MyBalanceComprobacion_Record2 in MyBalanceComprobacion_Lista.OrderBy(b => b.Cia))
            {
                if (MyBalanceComprobacion_Record2.Cia != nCiaContabAnterior) 
                {
                    // buscamos el mes y año fiscal solo cuando cambian las compañías
                    MyGetMesFiscalContable = new GetMesFiscalContable(dFechaInicialPeriodoIndicado, MyBalanceComprobacion_Record2.Cia);

                    sErrorMessage = "";
                    MyGetMesFiscalContable.dbContabDataContext = ContabDB;
                    if (!MyGetMesFiscalContable.DeterminarMesFiscal(ref sErrorMessage)) 
                    {
                        ContabDB.Dispose();

                        ErrMessage_Span.InnerHtml = sErrorMessage;
                        ErrMessage_Span.Style["display"] = "block";

                        return;
                    }

                    nMesFiscal = MyGetMesFiscalContable.MesFiscal;
                    nAnoFiscal = MyGetMesFiscalContable.AnoFiscal;
                    nMesCalendario = MyGetMesFiscalContable.MesCalendario;
                    nAnoCalendario = MyGetMesFiscalContable.AnoCalendario;
                    sNombreMes = MyGetMesFiscalContable.NombreMes;
                    dFechaSaldoInicial = MyGetMesFiscalContable.FechaSaldo;

                    nCiaContabAnterior = MyBalanceComprobacion_Record2.Cia;
                }

                // determinamos el saldo anterior de cada cuenta (GetSaldoContable es una clase que está en: old_app_code/Generales2.cs) 
                GetSaldoContable MyGetSaldoContable = new GetSaldoContable(MyBalanceComprobacion_Record2.CuentaContableID, 
                                                                            nMesFiscal, 
                                                                            nAnoFiscal, 
                                                                            dFechaInicialPeriodoIndicado, 
                                                                            MyBalanceComprobacion_Record2.Moneda, 
                                                                            MyBalanceComprobacion_Record2.Cia, bReconvertirCifrasAntes_01Oct2021, monedaNacional.Moneda);

                MyGetSaldoContable.bLeerSaldoCuenta(); 

                decimal nSaldoAnteriorContable = MyGetSaldoContable.SaldoAnterior;

                MyBalanceComprobacion_Record2.SaldoAnterior = nSaldoAnteriorContable;

                // este método lee los movimientos para la cuenta, la moneda y el período 
                var result = determinarMovimientoCuentaContable.leerMovimientoCuentaContable(MyBalanceComprobacion_Record2.CuentaContableID, MyBalanceComprobacion_Record2.Moneda); 

                MyBalanceComprobacion_Record2.Debe = result.sumDebe;
                MyBalanceComprobacion_Record2.Haber = result.sumHaber;
                MyBalanceComprobacion_Record2.CantidadMovimientos = result.recCount;

                // --------------------------------------------------------------------------------------------------------------------
                // por último, leemos la descripción del 'nivel previo' de la cuenta
                string selectDescripcionNivelPrevio = "Select Descripcion From CuentasContables Where Cuenta = {0} And Cia = {1}";

                object[] parameters = { MyBalanceComprobacion_Record2.NivelPrevioCuentaContable, MyBalanceComprobacion_Record2.Cia };
                string sCuentaContable_NivelPrevio_Descripcion = dbContext.ExecuteStoreQuery<string>(selectDescripcionNivelPrevio, parameters).FirstOrDefault();

                MyBalanceComprobacion_Record2.NivelPrevioCuentaContable_Nombre = sCuentaContable_NivelPrevio_Descripcion;
                MyBalanceComprobacion_Record2.SaldoActual = MyBalanceComprobacion_Record2.SaldoAnterior + MyBalanceComprobacion_Record2.Debe - MyBalanceComprobacion_Record2.Haber;

                // --------------------------------------------------------------------------------------
                // para mostrar el progreso al usuario

                nRegistroActual += 1;
                nProgreesPercentaje = nRegistroActual * 100 / nCantidadRegistros;

                Session["Progress_Percentage"] = nProgreesPercentaje;
                Session["Progress_SelectedRecs"] = (int)Session["Progress_SelectedRecs"] + 1;
            }

            // tenemos los niveles 'previos' de cada cuenta; vamos a crear una lista con las descripciones de cada cuenta, para luego 
            // leer las mismas y completar los niveles previos en la lista. Para cada nivel, ej: 0101002, quedará así: 0101002 - <su descripción> ... 

            var queryCuentasContables = dbContext.CuentasContables.Where(c => c.TotDet == "T" && c.Cia == ciaContabSeleccionada).Select(c => new { c.Cuenta, c.Descripcion });
            List<Cuenta_Nombre> listaCuentasYNombres = new List<Cuenta_Nombre>();

            foreach (var cuenta in queryCuentasContables)
            {
                listaCuentasYNombres.Add(new Cuenta_Nombre { cuenta = cuenta.Cuenta, descripcion = cuenta.Descripcion }); 
            }

            // ahora recorremos la lista y buscamos la descripción de cada cuenta contable 
            foreach (BalanceComprobacion_Item item in MyBalanceComprobacion_Lista)
            {
                if (item.nivel1 != null)
                    if (listaCuentasYNombres.Where(c => c.cuenta == item.nivel1).Count() > 0)
                        item.nivel1 += " - " + listaCuentasYNombres.Where(c => c.cuenta == item.nivel1).First().descripcion;

                if (item.nivel2 != null)
                    if (listaCuentasYNombres.Where(c => c.cuenta == item.nivel2).Count() > 0)
                        item.nivel2 += " - " + listaCuentasYNombres.Where(c => c.cuenta == item.nivel2).First().descripcion;

                if (item.nivel3 != null)
                    if (listaCuentasYNombres.Where(c => c.cuenta == item.nivel3).Count() > 0)
                        item.nivel3 += " - " + listaCuentasYNombres.Where(c => c.cuenta == item.nivel3).First().descripcion;

                if (item.nivel4 != null)
                    if (listaCuentasYNombres.Where(c => c.cuenta == item.nivel4).Count() > 0)
                        item.nivel4 += " - " + listaCuentasYNombres.Where(c => c.cuenta == item.nivel4).First().descripcion;

                if (item.nivel5 != null)
                    if (listaCuentasYNombres.Where(c => c.cuenta == item.nivel5).Count() > 0)
                        item.nivel5 += " - " + listaCuentasYNombres.Where(c => c.cuenta == item.nivel5).First().descripcion;

                if (item.nivel6 != null)
                    if (listaCuentasYNombres.Where(c => c.cuenta == item.nivel6).Count() > 0)
                        item.nivel6 += " - " + listaCuentasYNombres.Where(c => c.cuenta == item.nivel6).First().descripcion; 
            }

            // agregamos el contenido de la lista a la tabla 
            Contab_BalanceComprobacion contabBalanceComprobacionItem;

            foreach (BalanceComprobacion_Item item in MyBalanceComprobacion_Lista)
            {
                contabBalanceComprobacionItem = new Contab_BalanceComprobacion()
                {
                    CuentaContableID = item.CuentaContableID, 
                    Moneda = item.Moneda, 
                    CuentaContable_NivelPrevio = item.NivelPrevioCuentaContable,
                    CuentaContable_NivelPrevio_Descripcion = item.NivelPrevioCuentaContable_Nombre,
                    nivel1 = item.nivel1,
                    nivel2 = item.nivel2,
                    nivel3 = item.nivel3,
                    nivel4 = item.nivel4,
                    nivel5 = item.nivel5,
                    nivel6 = item.nivel6, 
                    SaldoAnterior = item.SaldoAnterior,
                    Debe = item.Debe,
                    Haber = item.Haber,
                    SaldoActual = item.SaldoActual,
                    CantidadMovimientos = item.CantidadMovimientos, 
                    NombreUsuario = nombreUsuario
                };

                dbContext.Contab_BalanceComprobacion.AddObject(contabBalanceComprobacionItem); 
            }

            try 
            {
                dbContext.SaveChanges();
            }
            catch (Exception ex) 
            {
                errorMessage = ex.Message;
                if (ex.InnerException != null)
                    errorMessage += "<br />" + ex.InnerException.Message; 

                Session["Thread_ErrorMessage"] = "Ha ocurrido un error al intentar ejecutar una operación de " + 
                    "acceso a la base de datos. <br /> El mensaje específico de error es: " +
                    errorMessage + "<br />";

                Session["Progress_Completed"] = 1;
                Session["Progress_Percentage"] = 0;

                return;
            }

            // ------------------------------------------------------------------------------------------
            // por último, eliminamos las cuentas seleccionadas de acuerdo al criterio indicado en las opciones
            if (!(bool)Session["MostrarCuentasSinSaldoYSinMvtos"]) 
                dbContext.ExecuteStoreCommand("Delete From Contab_BalanceComprobacion Where SaldoAnterior = 0 And CantidadMovimientos = 0 And NombreUsuario = {0}", nombreUsuario);

            if (!(bool)Session["MostrarCuentasConSaldoYSinMvtos"])
                dbContext.ExecuteStoreCommand("Delete From Contab_BalanceComprobacion Where SaldoAnterior <> 0 And CantidadMovimientos = 0 And NombreUsuario = {0}", nombreUsuario);

            if (!(bool)Session["MostrarCuentasSaldosEnCero"])
                dbContext.ExecuteStoreCommand("Delete From Contab_BalanceComprobacion Where SaldoAnterior = 0 And SaldoActual = 0 And NombreUsuario = {0}", nombreUsuario);

            if (!(bool)Session["MostrarCuentasSaldoFinalEnCero"])
                dbContext.ExecuteStoreCommand("Delete From Contab_BalanceComprobacion Where SaldoActual = 0 And NombreUsuario = {0}", nombreUsuario);

            dbContext.Dispose();

            // -----------------------------------------------------
            // por último, inicializamos las variables que se usan
            // para mostrar el progreso de la tarea
            Session["Progress_Completed"] = 1;
            Session["Progress_Percentage"] = 0;
            // -----------------------------------------------------
        }

        private void PageDataBind()
        {
            this.MonedasFilter_DropDownList.DataBind();
            this.CompaniasFilter_DropDownList.DataBind(); 

            BalanceComprobacion_ListView.DataBind();

            // --------------------------------------------------------------------------------
            // para mostrar el período indicado por el usuario como un subtítulo de la página

            HtmlContainerControl MyHtmlSpan = (HtmlContainerControl)Master.FindControl("PageSubTitle_Span");
            if (!(MyHtmlSpan == null))
            {
                DateTime FechaInicialPeriodo = (System.DateTime)Session["FechaInicialPeriodo"]; 
                DateTime FechaFinalPeriodo = (System.DateTime)Session["FechaFinalPeriodo"];  

                MyHtmlSpan.InnerHtml = FechaInicialPeriodo.ToString("dd-MMM-yy") + " / " + FechaFinalPeriodo.ToString("dd-MMM-yy");
            }
        }

        // The return type can be changed to IEnumerable, however to support
        // paging and sorting, the following parameters must be added:
        //     int maximumRows
        //     int startRowIndex
        //     out int totalRowCount
        //     string sortByExpression
        public IQueryable<Contab_BalanceComprobacion> BalanceComprobacion_ListView_GetData()
        {
            string userName = Membership.GetUser().UserName;

            dbContab_Contab_Entities dbContext = new dbContab_Contab_Entities();

            var query = dbContext.Contab_BalanceComprobacion.Include("CuentasContable").Where(c => c.NombreUsuario == userName);

            if (this.CompaniasFilter_DropDownList.SelectedIndex != -1)
            {
                int selectedValue = Convert.ToInt32(this.CompaniasFilter_DropDownList.SelectedValue);
                query = query.Where(c => c.CuentasContable.Cia == selectedValue);
            }

            if (this.MonedasFilter_DropDownList.SelectedIndex != -1)
            {
                int selectedValue = Convert.ToInt32(this.MonedasFilter_DropDownList.SelectedValue);
                query = query.Where(c => c.Moneda == selectedValue);
            }

            if (!string.IsNullOrEmpty(this.CuentaContableFilter_TextBox.Text))
            {
                string filter = this.CuentaContableFilter_TextBox.Text.ToString().Replace("*", ""); 

                // nótese como el usuario puede o no usar '*' para el mini filtro; de usarlo, la busqueda es más precisa ... 
                if (this.CuentaContableFilter_TextBox.Text.ToString().Trim().StartsWith("*") && this.CuentaContableFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.CuentasContable.Cuenta.Contains(filter));
                else if (this.CuentaContableFilter_TextBox.Text.ToString().Trim().StartsWith("*"))
                    query = query.Where(c => c.CuentasContable.Cuenta.EndsWith(filter));
                else if (this.CuentaContableFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.CuentasContable.Cuenta.StartsWith(filter));
                else
                    query = query.Where(c => c.CuentasContable.Cuenta.Contains(filter));
            }


            if (!string.IsNullOrEmpty(this.CuentaContableDescripcionFilter_TextBox.Text))
            {
                string filter = this.CuentaContableDescripcionFilter_TextBox.Text.ToString().Replace("*", "");

                // nótese como el usuario puede o no usar '*' para el mini filtro; de usarlo, la busqueda es más precisa ... 
                if (this.CuentaContableDescripcionFilter_TextBox.Text.ToString().Trim().StartsWith("*") && this.CuentaContableDescripcionFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.CuentasContable.Descripcion.Contains(filter));
                else if (this.CuentaContableDescripcionFilter_TextBox.Text.ToString().Trim().StartsWith("*"))
                    query = query.Where(c => c.CuentasContable.Descripcion.EndsWith(filter));
                else if (this.CuentaContableDescripcionFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.CuentasContable.Descripcion.StartsWith(filter));
                else
                    query = query.Where(c => c.CuentasContable.Descripcion.Contains(filter));
            }


            query = query.OrderBy(c => c.CuentasContable.Cuenta);

            return query;
        }

        public IQueryable<Compania> Companias_DropBox_GetData()
        {
            string userName = Membership.GetUser().UserName;

            dbContab_Contab_Entities dbContext = new dbContab_Contab_Entities();

            var query = dbContext.Companias.Where(c => c.CuentasContables.
                                          Where(ct => ct.Contab_BalanceComprobacion.
                                          Where(m => m.NombreUsuario == userName).Any()).Any()).Select(c => c);
            query = query.OrderBy(c => c.Nombre);
            return query;
        }

        public IQueryable<Moneda> Monedas_DropBox_GetData()
        {
            string userName = Membership.GetUser().UserName;

            dbContab_Contab_Entities dbContext = new dbContab_Contab_Entities();

            var query = dbContext.Monedas.Where(m => m.Contab_BalanceComprobacion.Where(c => c.NombreUsuario == userName).Any()).Select(c => c);
            query = query.OrderBy(c => c.Descripcion);
            return query;
        }

        protected void AplicarMiniFiltro(object sender, EventArgs e)
        {
            // nótese lo que se debe hacer para poner el ListView en su 1ra. página ... 
            DataPager pgr = this.BalanceComprobacion_ListView.FindControl("CuentasContables_DataPager") as DataPager;
            if (pgr != null)
                pgr.SetPageProperties(0, pgr.MaximumRows, false);

            this.BalanceComprobacion_ListView.DataBind();
            BalanceComprobacion_ListView.SelectedIndex = -1;
        }
    }
}
