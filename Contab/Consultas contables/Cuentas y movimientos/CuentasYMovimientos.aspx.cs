﻿using System;

using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.Security;
using System.Web.UI.HtmlControls;

using ContabSysNet_Web.ModelosDatos;
using System.Threading;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
//using ContabSysNet_Web.ModelosDatos_EF.Contab;

using MongoDB.Driver;

using ContabSysNet_Web.Areas.Contabilidad.Models.mongodb;
using ContabSysNet_Web.ModelosDatos_EF.code_first.contab;
using System.Reflection;
using ContabSysNet_Web.Clases;

namespace ContabSysNetWeb.Contab.Consultas_contables.Cuentas_y_movimientos
{
    public class MyCuentaContable_object
    {
        public int CuentaContableID { get; set; }  
        public string CuentaContable { get; set; }
        public string NombreCuentaContable { get; set; }
        public string CuentaContableEditada { get; set; }  
        public int Moneda { get; set; }
        public string NombreMoneda { get; set; }
        public string SimboloMoneda { get; set; }  
        public int NumeroCiaContab { get; set; }
        public string NombreCiaContab { get; set; }  
    }

    public class MyCuentaContable_Movimientos_object
    {
        public int NumeroAutomatico { get; set; }
        public int CuentaContableID { get; set; }
        public Int16 Partida { get; set; }
        public DateTime Fecha { get; set;  }
        public string Descripcion { get; set; }
        public string Referencia { get; set; } 
        public decimal Debe { get; set; }
        public decimal Haber { get; set; }
        public string CentroCostoAbreviatura { get; set; }
    }

    public partial class CuentasYMovimientos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            ErrMessage_Span.InnerHtml = "";
            ErrMessage_Span.Style["display"] = "none";

            Master.Page.Title = "Cuentas contables y sus movimientos";

            if (!Page.IsPostBack)
            {
                // Gets a reference to a Label control that is not in a
                // ContentPlaceHolder control
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
                    MyHtmlH2.InnerHtml = "Cuentas contables y sus movimientos";
                }

                // --------------------------------------------------------------------------------------------
                // para asignar la página que corresponde al help de la página

                HtmlAnchor MyHtmlHyperLink;
                MyHtmlHyperLink = (HtmlAnchor)Master.FindControl("Help_HyperLink");

                MyHtmlHyperLink.HRef = "javascript:PopupWin('Doc/Consulta de cuentas contables y sus movimientos.htm', 1000, 680)";

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

                        this.MonedasFilter_DropDownList.DataBind();
                        this.CompaniasFilter_DropDownList.DataBind(); 

                        //BindDataToCuentasListView();
                        this.CuentasContables_ListView.DataBind();
                        this.CuentasContables_ListView.SelectedIndex = -1;

                        UnBindMovimientosListView();

                        System.Text.StringBuilder sb = new System.Text.StringBuilder();
                        sb.Append("<script language='javascript'>");
                        sb.Append("showprogress_displayselectedrecs();");
                        sb.Append("</script>");

                        ClientScript.RegisterStartupScript(this.GetType(), "onLoad", sb.ToString());
                    }
                }
            }
        }

        private void RefreshAndBindInfo()
        {
            if (this.User != null && this.User.Identity != null && !User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            if (Session["FiltroForma"] == null)
            {
                string errMessage = "Aparentemente, Ud. no ha indicado un filtro aún.<br /> " + 
                    "Por favor indique y aplique un filtro antes de intentar mostrar el resultado de " + 
                    "la consulta.";

                Session["Thread_ErrorMessage"] = errMessage;
                Session["Progress_Completed"] = 1;

                return;
            }

            Session["Progress_Percentage"] = 0;

            // parte del filtro que usa el usuario para seleccionar sus registros
            bool bExcluirCuentasSinMovimientos = (bool)Session["ExcluirCuentasSinMovimientos"];
            bool bExcluirCuentasConSaldoCeroYSinMovtos = (bool)Session["ExcluirCuentasConSaldoCeroYSinMovtos"];
            bool excluirMovimientosDeAsientosDeTipoCierreAnual = (bool)Session["ExcluirMovimientosDeAsientosDeTipoCierreAnual"]; 

            // estas son dos nuevas opciones que agregamos al reporte que permiten excluir cuentas contables cuyos saldos estén en cero 
            bool bExcluirCuentasConSaldosInicialFinalCero = (bool)Session["ExcluirCuentasConSaldosInicialFinalCero"];
            bool bExcluirCuentasConSaldoFinalCero = (bool)Session["ExcluirCuentasConSaldoFinalCero"];

            // agregamos este flag luego de la reconversión del 1-Oct-21 
            // la idea es que el usuario pueda decidir si reconvertir montos
            bool bReconvertirCifrasAntes_01Oct2021 = (bool)Session["ReconvertirCifrasAntes_01Oct2021"]; 
            bool bExcluirAsientosReconversion_01Oct2021 = (bool)Session["ExcluirAsientosReconversion_01Oct2021"];

            // ---------------------------------------------------------------------------------------------------------------------------------------------
            // leemos la tabla de monedas para 'saber' cual es la moneda Bs. Nota: la idea es aplicar las opciones de reconversión *solo* a esta moneda 
            var monedaNacional_result = Reconversion.Get_MonedaNacional();

            if (monedaNacional_result.error)
            {
                Session["Thread_ErrorMessage"] = monedaNacional_result.message;
                Session["Progress_Completed"] = 1;

                return;
            }

            Monedas monedaNacional = monedaNacional_result.moneda;
            // ---------------------------------------------------------------------------------------------------------------------------------------------

            var contabContext = new ContabContext(); 

            try
            {
                // eliminamos el contenido de la tabla temporal
                int noOfRowDeleted = contabContext.Database.ExecuteSqlCommand("Delete From Contab_ConsultaCuentasYMovimientos Where NombreUsuario = {0}", Membership.GetUser().UserName);
            }
            catch (Exception ex)
            {
                //dbContab.Dispose();

                string errMessage = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la " + 
                    "base de datos. <br /> El mensaje específico de error es: " + ex.Message + "<br /><br />";
                
                Session["Thread_ErrorMessage"] = errMessage;
                Session["Progress_Completed"] = 1;

                return;
            }

            // el usuario puede ahora filtrar por código 'condi' 
            string sql_filtroCuentasContables_desdeCondi = "(1 = 1)";
            string errorMessage = ""; 

            if (Session["codigoCondi"] != null)
            {
                // este código lee las cuentas contables que corresponden al código condi y regresa un subquery para aplicar al filtro. 
                // Nota: los códigos condi están registrados en mongodb 

                // cuando el usuario selecciona usando el código condi, siempre usa una (sola) compañía Contab en el filtro y viene en Session 
                int ciaContabSeleccionada = Convert.ToInt32(Session["ciaContabSeleccionada"].ToString()); 

                if (!prepararSubQueryPorCodigoCondi(Session["codigoCondi"].ToString(), ciaContabSeleccionada, out sql_filtroCuentasContables_desdeCondi, out errorMessage))
                {
                    string errMessage = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la " +
                                            "base de datos. <br /> El mensaje específico de error es: " + errorMessage + "<br /><br />";

                    Session["Thread_ErrorMessage"] = errMessage;
                    Session["Progress_Completed"] = 1;

                    return;
                }
            }
                
            // usamos el criterio que indico el usuario para leer las cuentas contables y grabarlas a una tabla
            // en la base de datos temporal
            string sSqlQueryString = 
                "SELECT Distinct CuentaContableID, CuentasContables.Cuenta AS CuentaContable, " + 
                "CuentasContables.Descripcion AS NombreCuentaContable, " + 
                "CuentasContables.CuentaEditada AS CuentaContableEditada, Asientos.Moneda, " + 
                "Monedas.Descripcion As NombreMoneda, Monedas.Simbolo As SimboloMoneda, " + 
                "Companias.Numero AS NumeroCiaContab, Companias.NombreCorto AS NombreCiaContab " + 
                "FROM dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico " + 
                "Inner Join CuentasContables ON dAsientos.CuentaContableID = CuentasContables.ID " + 
                "Inner Join Companias ON CuentasContables.Cia = Companias.Numero " + 
                "Inner Join Monedas ON Asientos.Moneda = Monedas.Moneda " + "Where " + Session["FiltroForma"].ToString() +
                // solo si el usuario usa *código condi* en el filtro aplicamos el subQuery
                " And " + sql_filtroCuentasContables_desdeCondi +  " " +   
                "Order by Companias.Numero, Asientos.Moneda, CuentasContables.Cuenta ";

            var query = contabContext.Database.SqlQuery<MyCuentaContable_object>(sSqlQueryString).ToList<MyCuentaContable_object>();

            int nNumeroCompaniaAnterior = -99999;

            System.DateTime dFechaInicialPeriodo = (DateTime)Session["FechaInicialPeriodo"];
            System.DateTime dFechaFinalPeriodo = (DateTime)Session["FechaFinalPeriodo"];

            int nMesFiscal = 0;
            int nAnoFiscal = 0;

            // ---------------------------------------------------------------------------------------------
            // variables usadas para mostrar el meter en la página ... 
            int nCantidadRegistros = query.Count();

            int nRegistroActual = 0;
            int nProgreesPercentaje = 0;

            Session["Progress_SelectedRecs"] = 0;
            // ---------------------------------------------------------------------------------------------

            // si el usuario indicó una moneda original en el filtro, la usamos al determinar el saldo inicial 
            int? monedaOriginalFilter = null;

            if (Session["ctasYMovtos_MonOrig_Filter"] != null)
                monedaOriginalFilter = Convert.ToInt32(Session["ctasYMovtos_MonOrig_Filter"].ToString());

            bool sinSaldoInicialPeriodo = false; 

            if (Convert.ToBoolean(Session["ctasYMovtos_SinSaldoInicialCuentasContables"]))
                sinSaldoInicialPeriodo = true;

            bool soloMovimientosConCentroCostoAsignado = false;
            bool soloMovimientosSinCentroCostoAsignado = false;

            if (Convert.ToBoolean(Session["SoloMovimientosConCentroCostoAsignado"]))
                soloMovimientosConCentroCostoAsignado = true;

            if (Convert.ToBoolean(Session["SoloMovimientosSinCentroCostoAsignado"]))
                soloMovimientosSinCentroCostoAsignado = true;

            // preparamos el fitro para seleccionar los movimientos para cada cuenta
            // nótese como creamos un criterio para seleccionar o no los movimientos que corresponden 
            // a asientos del tipo cierre anual ... 
            string criterioAsientoTipoCierreAnual = "(1 = 1)";

            if (excluirMovimientosDeAsientosDeTipoCierreAnual)
                criterioAsientoTipoCierreAnual = "(Not (Asientos.MesFiscal = 13 Or " +
                                                 "(Asientos.AsientoTipoCierreAnualFlag Is Not Null And " +
                                                 "Asientos.AsientoTipoCierreAnualFlag = 1)))";

            // el usuario puede indicar que desea *solo* movimientos con/sin centro de costo asignado 
            string criterioMovimientosConSinCentroCostoAsignado = "(1 = 1)";

            if (soloMovimientosConCentroCostoAsignado)
                criterioMovimientosConSinCentroCostoAsignado += " And (dAsientos.centroCosto Is Not Null)";

            if (soloMovimientosSinCentroCostoAsignado)
                criterioMovimientosConSinCentroCostoAsignado += " And (dAsientos.centroCosto Is Null)";

            ConsultaCuentasYMovimientos MyMovimiento_Cuenta;
            ConsultaCuentasYMovimientos_Movimientos MyMovimiento_Cuenta_Movimiento;

            // usamos esta fecha para el movimiento que agregamos para cada cuenta como su saldo inicial 
            DateTime fechaInicialPeriodo_1erDiaMes = new DateTime(dFechaInicialPeriodo.Year, dFechaInicialPeriodo.Month, 1);

            foreach (MyCuentaContable_object MyCuentaContable in query)
            {
                // leemos el mes y año fiscal SOLO cuando cambia la compañía
                if (MyCuentaContable.NumeroCiaContab != nNumeroCompaniaAnterior)
                {
                    // determinamos el mes y año fiscales, para usarlos como criterio para buscar el saldo en la tabla
                    // SaldosContables. En esta table, los saldos están para el mes fiscal y no para el mes calendario.
                    // Los meses solo varían cuando el año fiscal no es igual al año calendario

                    // obtenemos el mes y año fiscal del mes anterior, para luego leer los saldos anteriores de las cuentas 
                    if (!ObtenerMesFiscal(dFechaInicialPeriodo, MyCuentaContable.NumeroCiaContab, out nMesFiscal, out nAnoFiscal))
                    {
                        return;
                    }
                    nNumeroCompaniaAnterior = MyCuentaContable.NumeroCiaContab;
                }

                MyMovimiento_Cuenta = new ConsultaCuentasYMovimientos();

                MyMovimiento_Cuenta.ID = 0;
                MyMovimiento_Cuenta.CuentaContableID = MyCuentaContable.CuentaContableID;
                MyMovimiento_Cuenta.Moneda = MyCuentaContable.Moneda;
                MyMovimiento_Cuenta.CantMovtos = 0;         // luego vamos a actualizar con la cantida correcta de movimientos (partidas de asiento) 
                MyMovimiento_Cuenta.NombreUsuario = Membership.GetUser().UserName;

                // --------------------------------------------------------------------------
                // el 1er movimientos que agregamos para cada cuenta es su saldo anterior.
                // leemos el saldo anterior de cada cuenta y grabamos un movimiento para éste
                decimal nSaldoAnteriorCuentaContable = 0;

                if (!bLeerSaldoCuenta(MyCuentaContable.CuentaContableID,
                    nMesFiscal,
                    nAnoFiscal,
                    MyCuentaContable.Moneda,
                    monedaOriginalFilter,
                    ref nSaldoAnteriorCuentaContable))
                {
                    return;
                }

                short nCantidadTotalMovimientos = 0;
                short movimientoSecuencia = 0;

                MyMovimiento_Cuenta_Movimiento = new ConsultaCuentasYMovimientos_Movimientos();

                MyMovimiento_Cuenta_Movimiento.ID = 0;
                MyMovimiento_Cuenta_Movimiento.AsientoID = 0;
                MyMovimiento_Cuenta_Movimiento.CuentaContableID = MyCuentaContable.CuentaContableID;
                MyMovimiento_Cuenta_Movimiento.Secuencia = movimientoSecuencia;
                MyMovimiento_Cuenta_Movimiento.Partida = null;
                MyMovimiento_Cuenta_Movimiento.Fecha = fechaInicialPeriodo_1erDiaMes;
                MyMovimiento_Cuenta_Movimiento.Referencia = "";
                MyMovimiento_Cuenta_Movimiento.Descripcion = "Saldo inicial al " +
                    new DateTime(dFechaInicialPeriodo.Year, dFechaInicialPeriodo.Month, 1).ToString("d-MMM-yy");
                MyMovimiento_Cuenta_Movimiento.Monto = nSaldoAnteriorCuentaContable;

                // ------------------------------------------------------------------------------------------------------------------------------------------------------------
                // reconvertimos *solo* el saldo inicial del mes Oct/2021; este movimiento no se reconvierte abajo pues corresponde al 
                // mes Octubre; los movimientos del mes Oct/21 no se reconvierten; sin embargo, debe hacerse pues no es un movimiento normal; es el saldo incial del mes 
                if (bReconvertirCifrasAntes_01Oct2021 && MyMovimiento_Cuenta.Moneda == monedaNacional.Moneda && MyMovimiento_Cuenta_Movimiento.Descripcion == "Saldo inicial al 1-Oct-21")
                {
                    MyMovimiento_Cuenta_Movimiento.Monto /= 1000000;
                    MyMovimiento_Cuenta_Movimiento.Monto = Math.Round(MyMovimiento_Cuenta_Movimiento.Monto, 2);
                }

                // ---------------------------------------------------------------------------------------------------------
                // el usuario puede indicar que *no desea* el saldo inicial (del período) de las cuentas en la consulta ... 
                if (!sinSaldoInicialPeriodo)
                {
                    MyMovimiento_Cuenta.ConsultaCuentasYMovimientos_Movimientos.Add(MyMovimiento_Cuenta_Movimiento);
                    nCantidadTotalMovimientos += 1;
                }

                // ---------------------------------------------------------------------------------------------
                // SOLO si la fecha inicial es diferente a un 1ro. de mes, determinamos el monto en movimientos
                // que va desde el 1ro. hasta un dia antes de la fecha inicial del período (ejemplo: si el usuario
                // pide la consulta desde el 5 de mayo hasta el 15 de mayo, determinamos aquí el monto en movimientos
                // que va desde el 1ro de mayo hasta el 14 de mayo y lo agregamos como un movimiento más a la
                // cuenta

                if (dFechaInicialPeriodo.Day > 1 && !sinSaldoInicialPeriodo)
                {
                    decimal nMontoMovimientosDiasIniciales = 0;
                    errorMessage = "";

                    if (!DeterminarMontoMovimientosPeriodoInicial(dFechaInicialPeriodo, MyCuentaContable.CuentaContableID, MyCuentaContable.Moneda, monedaOriginalFilter,
                        out nMontoMovimientosDiasIniciales, out errorMessage))
                    {
                        // error: terminamos ... 
                        string errMessage = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la " +
                                            "base de datos. <br /> El mensaje específico de error es: " + errorMessage + "<br /><br />";

                        Session["Thread_ErrorMessage"] = errMessage;
                        Session["Progress_Completed"] = 1;

                        return;
                    }

                    System.DateTime dFecha1erDiaMes = new System.DateTime(dFechaInicialPeriodo.Year, dFechaInicialPeriodo.Month, 1);
                    System.DateTime dFechaDiaAnteriorFechaInicialPeriodo = new System.DateTime(dFechaInicialPeriodo.Year,
                                                                                               dFechaInicialPeriodo.Month,
                                                                                               dFechaInicialPeriodo.AddDays(-1).Day);

                    MyMovimiento_Cuenta_Movimiento = new ConsultaCuentasYMovimientos_Movimientos();

                    movimientoSecuencia++;

                    MyMovimiento_Cuenta_Movimiento.ID = 0;
                    MyMovimiento_Cuenta_Movimiento.AsientoID = 0;
                    MyMovimiento_Cuenta_Movimiento.CuentaContableID = MyCuentaContable.CuentaContableID;
                    MyMovimiento_Cuenta_Movimiento.Secuencia = movimientoSecuencia;
                    MyMovimiento_Cuenta_Movimiento.Partida = null;
                    MyMovimiento_Cuenta_Movimiento.Fecha = dFechaDiaAnteriorFechaInicialPeriodo;
                    MyMovimiento_Cuenta_Movimiento.Referencia = "";
                    MyMovimiento_Cuenta_Movimiento.Descripcion = "Monto asientos desde " +
                        dFecha1erDiaMes.ToString("d-MMM-yy") + " al " + dFechaDiaAnteriorFechaInicialPeriodo.ToString("d-MMM-yy");

                    MyMovimiento_Cuenta_Movimiento.Monto = nSaldoAnteriorCuentaContable;

                    MyMovimiento_Cuenta_Movimiento.Monto = nMontoMovimientosDiasIniciales;

                    MyMovimiento_Cuenta.ConsultaCuentasYMovimientos_Movimientos.Add(MyMovimiento_Cuenta_Movimiento);

                    nCantidadTotalMovimientos += 1;

                    nSaldoAnteriorCuentaContable = nSaldoAnteriorCuentaContable + nMontoMovimientosDiasIniciales;
                }

                // ---------------------------------------------------------------------------------------------
                // para cada cuenta contable que vamos agregando a la tabla temporal, leemos y agregamos sus
                // movimientos (asientos) a otra tabla temporal; nótese que el filtro fue construído en la
                // página ...Filter.aspx y es usado además de la cuenta y cia que viene con este registro

                // reconversión Oct-2021: el usuario puede indicar que quiere excluir asientos de reconversión 
                String filtroExcluirAsientosReconversion = "(1 = 1)";
                if (bExcluirAsientosReconversion_01Oct2021)
                {
                    filtroExcluirAsientosReconversion = "(dAsientos.Referencia <> 'Reconversión 2021' Or dAsientos.Referencia Is Null Or Rtrim(Ltrim(dAsientos.Referencia)) = '')";
                }

                string sSqlQueryString2 = "SELECT dAsientos.NumeroAutomatico, dAsientos.CuentaContableID, dAsientos.Partida, Asientos.Fecha, " +
                    "dAsientos.Descripcion, dAsientos.Referencia, dAsientos.Debe, dAsientos.Haber, CentrosCosto.DescripcionCorta as CentroCostoAbreviatura " +
                    "FROM dAsientos Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico " +
                    "Inner Join CuentasContables On dAsientos.CuentaContableID = CuentasContables.ID " +
                    "Left Outer Join CentrosCosto On dAsientos.CentroCosto = CentrosCosto.CentroCosto " +
                    "Where " + Session["FiltroForma_Movimientos"].ToString() + " And dAsientos.CuentaContableID = " +
                    MyCuentaContable.CuentaContableID.ToString() + " " +
                    "And Asientos.Moneda = " + MyCuentaContable.Moneda.ToString() +
                    " And " + criterioAsientoTipoCierreAnual +
                    " And " + criterioMovimientosConSinCentroCostoAsignado + " And " + filtroExcluirAsientosReconversion + 
                    " Order by Asientos.Fecha, Asientos.Numero, dAsientos.Partida";

                var query2 = contabContext.Database.SqlQuery<MyCuentaContable_Movimientos_object>(sSqlQueryString2).ToList<MyCuentaContable_Movimientos_object>();

                decimal nSaldoActualCuentaContable = nSaldoAnteriorCuentaContable;

                Int16 nCantidadMovimientos = 0;

                foreach (MyCuentaContable_Movimientos_object MyCuentaContable_Movimiento in query2)
                {
                    MyMovimiento_Cuenta_Movimiento = new ConsultaCuentasYMovimientos_Movimientos();

                    movimientoSecuencia++;

                    MyMovimiento_Cuenta_Movimiento.ID = 0; 
                    MyMovimiento_Cuenta_Movimiento.AsientoID = MyCuentaContable_Movimiento.NumeroAutomatico;
                    MyMovimiento_Cuenta_Movimiento.CuentaContableID = MyCuentaContable_Movimiento.CuentaContableID;
                    MyMovimiento_Cuenta_Movimiento.Secuencia = movimientoSecuencia; 
                    MyMovimiento_Cuenta_Movimiento.Partida = MyCuentaContable_Movimiento.Partida;
                    MyMovimiento_Cuenta_Movimiento.Fecha = MyCuentaContable_Movimiento.Fecha; 
                    MyMovimiento_Cuenta_Movimiento.Descripcion = MyCuentaContable_Movimiento.Descripcion;
                    MyMovimiento_Cuenta_Movimiento.Referencia = MyCuentaContable_Movimiento.Referencia; 
                    MyMovimiento_Cuenta_Movimiento.Monto = MyCuentaContable_Movimiento.Debe - MyCuentaContable_Movimiento.Haber;
                    MyMovimiento_Cuenta_Movimiento.CentroCostoAbreviatura = MyCuentaContable_Movimiento.CentroCostoAbreviatura; 

                    MyMovimiento_Cuenta.ConsultaCuentasYMovimientos_Movimientos.Add(MyMovimiento_Cuenta_Movimiento);

                    nSaldoActualCuentaContable += MyCuentaContable_Movimiento.Debe - MyCuentaContable_Movimiento.Haber;

                    // nótese como solo contamos los movimientos 'reales' (partidas de asientos) y no los que construimos para el saldo inicial y final
                    nCantidadMovimientos += 1;

                    // también contamos la cantidad total de movimientos agregados (incluyendo los registros
                    // de saldo inicial y final)
                    nCantidadTotalMovimientos += 1;
                }

                // -----------------------------------------------------------------------------------------
                // el usuario puede establecer criterios para excluir cuentas contables de la consulta 
                if (bExcluirCuentasSinMovimientos && nCantidadMovimientos == 0)
                {
                    nRegistroActual += 1;
                    nProgreesPercentaje = nRegistroActual * 100 / nCantidadRegistros;

                    Session["Progress_Percentage"] = nProgreesPercentaje;
                    Session["Progress_SelectedRecs"] = (int)Session["Progress_SelectedRecs"] + 1;

                    continue; 
                }
                    
                if (bExcluirCuentasConSaldoCeroYSinMovtos && nCantidadMovimientos == 0 && nSaldoActualCuentaContable == 0)
                {
                    nRegistroActual += 1;
                    nProgreesPercentaje = nRegistroActual * 100 / nCantidadRegistros;

                    Session["Progress_Percentage"] = nProgreesPercentaje;
                    Session["Progress_SelectedRecs"] = (int)Session["Progress_SelectedRecs"] + 1;

                    continue;
                }

                if (bExcluirCuentasConSaldosInicialFinalCero && nSaldoAnteriorCuentaContable == 0 && nSaldoActualCuentaContable == 0)
                {
                    nRegistroActual += 1;
                    nProgreesPercentaje = nRegistroActual * 100 / nCantidadRegistros;

                    Session["Progress_Percentage"] = nProgreesPercentaje;
                    Session["Progress_SelectedRecs"] = (int)Session["Progress_SelectedRecs"] + 1;

                    continue;
                }

                if (bExcluirCuentasConSaldoFinalCero && nSaldoActualCuentaContable == 0)
                {
                    nRegistroActual += 1;
                    nProgreesPercentaje = nRegistroActual * 100 / nCantidadRegistros;

                    Session["Progress_Percentage"] = nProgreesPercentaje;
                    Session["Progress_SelectedRecs"] = (int)Session["Progress_SelectedRecs"] + 1;

                    continue;
                }

                // -----------------------------------------------------------------------------------------
                // el usuario puede indicar que quiere reconvertir cifras anteriores al 31/Oct/21 
                if (bReconvertirCifrasAntes_01Oct2021 && MyMovimiento_Cuenta.Moneda == monedaNacional.Moneda)
                {
                    var movimientos = MyMovimiento_Cuenta.ConsultaCuentasYMovimientos_Movimientos.Where(x => (x.Fecha < new DateTime(2021, 10, 1))).ToList();
                    foreach (var movimiento in movimientos)
                    {
                        movimiento.Monto /= 1000000;
                        movimiento.Monto = Math.Round(movimiento.Monto, 2);
                    }
                }

                // -----------------------------------------------------------------------------------------
                // agregamos la cuenta contable y sus movimientos a la lista que será posteriormente agregada a la tabla
                // nótese que, si llegamos aquí, es porqué no aplicó algúna eliminación que indicó el usuario en el filtro 
                // (excluir movimientos con saldos cero, etc) 
                MyMovimiento_Cuenta.CantMovtos = nCantidadMovimientos;

                // agregamos la cuenta leída y sus movimientos al dbContext 
                contabContext.ConsultaCuentasYMovimientos.Add(MyMovimiento_Cuenta); 

                // --------------------------------------------------------------------------------------
                // ... para reportar el progreso al usuario; la página ejecuta un ws que lee el valor de
                // estas session variables
                nRegistroActual += 1;
                nProgreesPercentaje = nRegistroActual * 100 / nCantidadRegistros;

                Session["Progress_Percentage"] = nProgreesPercentaje;
                Session["Progress_SelectedRecs"] = (int)Session["Progress_SelectedRecs"] + 1;
            }

            try
            {
                contabContext.SaveChanges(); 
            }
            catch (Exception ex)
            {
                var message = ex.Message;

                if (ex.InnerException != null)
                    message += $"<br />{ex.InnerException.Message}";

                string errMessage = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la " + 
                    "base de datos. <br /> El mensaje específico de error es: " + message + "<br /><br />";

                Session["Thread_ErrorMessage"] = errMessage;
                Session["Progress_Completed"] = 1;

                return;
            }

            // -----------------------------------------------------
            // por último, inicializamos las variables que se usan
            // para mostrar el progreso de la tarea
            Session["Progress_Completed"] = 1;
            Session["Progress_Percentage"] = 0;
            // -----------------------------------------------------
        }

        private bool prepararSubQueryPorCodigoCondi(string codigosCondi_lista, int ciaContabSeleccionada, out string sql_filtroCuentasContables_desdeCondi, out string message)
        {
            sql_filtroCuentasContables_desdeCondi = "";
            message = "";

            // --------------------------------------------------------------------------------------------------------------------------
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config 
            string contabm_mongodb_connection = System.Web.Configuration.WebConfigurationManager.AppSettings["contabm_mongodb_connectionString"];
            string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

            var client = new MongoClient(contabm_mongodb_connection);
            var mongoDataBase = client.GetDatabase(contabM_mongodb_name);
            // --------------------------------------------------------------------------------------------------------------------------

            // estos son los dos collections que leeremos desde mongo 
            var codificacionesContables_codigos = mongoDataBase.GetCollection<CodificacionesContables_codigos>("codificacionesContables_codigos");
            var codificacionesContables_codigos_cuentasContables = mongoDataBase.GetCollection<CodificacionesContables_codigos_cuentasContables>("codificacionesContables_codigos_cuentasContables");

            try
            {
                // --------------------------------------------------------------------------------------------------------------------------
                // ... para revisar si mongodb está disponible 
                var builder = Builders<CodificacionesContables_codigos>.Filter;
                var filter = builder.Eq(x => x.cia, -99999999);

                codificacionesContables_codigos.DeleteManyAsync(filter);
            }
            catch (Exception ex)
            {
                string resultMessage1 = ex.Message;
                if (ex.InnerException != null)
                    resultMessage1 += "<br />" + ex.InnerException.Message;

                string resultMessage2 = "Se producido un error al intentar ejecutar una operación en mongodb.<br />" +
                                   "El mensaje específico del error es:<br />" + resultMessage1;

                message = resultMessage2; 

                return false;
            }

            // el usuario puede separar los códigos condi con comas; convertimos todo a un array, que luego usaremos para leer desde mongo 
            codigosCondi_lista = codigosCondi_lista.Trim();
            codigosCondi_lista = codigosCondi_lista.Replace(", ", ",");
            codigosCondi_lista = codigosCondi_lista.Replace(" ,", ",");
            
            string[] codigosCondi_array = codigosCondi_lista.Split(',');

            // ahora usamos el array para leer; usamos el operador $in ... 

            // IMongoCollection<Album> _collection = ...
            var builder_codigosCondi = Builders<CodificacionesContables_codigos>.Filter;
            var filter_codigosCondi = builder_codigosCondi.In(x => x.codigo, codigosCondi_array) & 
                                      builder_codigosCondi.Eq(x => x.cia, ciaContabSeleccionada) & 
                                      builder_codigosCondi.Eq(x => x.detalle, true); 

            // nótese lo que hacemos, básicamente, para ejecutar en forma sync el código que no lo es ... 
            var r1 = codificacionesContables_codigos.Find(filter_codigosCondi).Project<CodificacionesContables_codigos>("{ _id: 1 }").ToListAsync();
            r1.Wait();
            var codigosCondi_list = r1.Result.ToList();

            // ahora leemos la 2da tabla, la que contiene las cuentas contables. La idea es leer las que correspondan a los códigos que el usuario 
            // indicó ... 

            // primero construimos el array con los ids de cada código condi 
            string[] codigosCondi_ids_array = codigosCondi_list.Select(x => x._id).ToArray();

            // ahora construimos el filtro para leer en mongo 
            var builder_codigosCondi_cuentasContables = Builders<CodificacionesContables_codigos_cuentasContables>.Filter;
            var filter_codigosCondi_cuentasContables = builder_codigosCondi_cuentasContables.In(x => x.codigoContable_ID, codigosCondi_ids_array) &
                                                       builder_codigosCondi_cuentasContables.Eq(x => x.cia, ciaContabSeleccionada);

            var r2 = codificacionesContables_codigos_cuentasContables.Find(filter_codigosCondi_cuentasContables).Project<CodificacionesContables_codigos_cuentasContables>("{ id: 1 }").ToListAsync();
            r2.Wait();
            var cuentasContables_list = r2.Result.ToList();

            // finalmente, construimos el sql subQuery con las cuentas contables (sus ids) leídas desde la codificación condi 
            string sqlFiltroCuentasContables = ""; 
            if (cuentasContables_list.Count == 0)
                sqlFiltroCuentasContables = "(dAsientos.CuentaContableID In (0";
            else
                sqlFiltroCuentasContables = "(dAsientos.CuentaContableID In (0";


            cuentasContables_list.ForEach(c => sqlFiltroCuentasContables += ", " + c.id.ToString());

            sqlFiltroCuentasContables += "))";

            sql_filtroCuentasContables_desdeCondi = sqlFiltroCuentasContables; 

            return true; 
        }

        private void BindDataToCompaniasSeleccionadasDropDownList()
        {
            // este es el DropDown que le permite al usuario seleccionar una compañía para mostrar sus cuentas
            //CompaniasSeleccionadas_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;
            //CompaniasSeleccionadas_DropDownList.DataBind();

            //if (CompaniasSeleccionadas_DropDownList.Items.Count > 0)
            //{
            //    //inicialmente, seleccionamos siempre el 1er row
            //    CompaniasSeleccionadas_DropDownList.SelectedIndex = 0;
            //}
        }

        protected void CuentasContables_ListView_PagePropertiesChanged(object sender, EventArgs e)
        {
            CuentasContables_ListView.SelectedIndex = -1;
            UnBindMovimientosListView(); 
        }

        protected void CuentasContables_ListView_SelectedIndexChanged(object sender, EventArgs e)
        {
            DataKey MyDataKeys = CuentasContables_ListView.SelectedDataKey;

            int recordID = Convert.ToInt32(MyDataKeys.Values[0].ToString());

            CuentasContables_Movimientos_SqlDataSource.SelectParameters["ParentID"].DefaultValue = recordID.ToString(); 
                
            CuentasContables_Movimientos_ListView.DataBind();

            // ----------------------------------------------------------------------------------------------------
            // cuando el usuario selecciona una cuenta contable para mostrar sus movimientos, leemos el total 
            // del modelo y lo mostramos en la linea (row) de totales ... 

            //dbContab_Contab_Entities contabContext = new dbContab_Contab_Entities();

            //decimal? saldoFinalCuentaContable = (from c in contabContext.Contab_ConsultaCuentasYMovimientos_Movimientos
            //                                    where c.ParentID == recordID
            //                                    select (decimal?) c.Monto).Sum();

            var contabContext = new ContabContext();

            decimal? saldoFinalCuentaContable = (from c in contabContext.ConsultaCuentasYMovimientos_Movimientos
                                                 where c.ParentID == recordID
                                                 select (decimal?)c.Monto).Sum();

            if (saldoFinalCuentaContable == null)
                saldoFinalCuentaContable = 0;

            Label MySumOfMonto_Label = (Label)CuentasContables_Movimientos_ListView.FindControl("SumOfMonto_Label");

            if (MySumOfMonto_Label != null) 
                MySumOfMonto_Label.Text = saldoFinalCuentaContable.Value.ToString("#,##0.00");
        }

        private bool ObtenerMesFiscal(System.DateTime dFechaInicialPeriodo, int nCiaContab, 
            out int nMesFiscal, out int nAnoFiscal) 
        {

            // lo primero que hacemos es determinar el mes anterior a la fecha de incio del período. Este será el
            // mes para el cual buscaremos los saldos. Ej: si el usuario quiere la consulta a partir del
            // 1-7-08, debemos presentar el saldo anterior al mes 6-08.
            nMesFiscal = 0;
            nAnoFiscal = 0; 

            // leemos el mes fiscal que corresponde al mes de la fecha de inicio de la consulta 
            int nMesCalendario = dFechaInicialPeriodo.Month;
            int nAnoCalendario = dFechaInicialPeriodo.Year;

            dbContabDataContext db = new dbContabDataContext();

            var query = (from m in db.MesesDelAnoFiscals
                         where m.Mes == nMesCalendario && m.Cia == nCiaContab
                         select new { m.MesFiscal, m.Ano }).FirstOrDefault();


            if (query == null) {
                db.Dispose();

                ErrMessage_Span.InnerHtml = "Aparentemente, la tabla de Meses Fiscales no esta " + 
                    "correctamente registrada. Debe contener un registro para cada mes del año. " + 
                    "<br /> Por favor revise esta tabla y haga las correcciones que sean necesarias antes " + 
                    "de volver a ejecutar esta consulta.";
                ErrMessage_Span.Style["display"] = "block";

                return false;
            }

            // siempre regresaremos el mismo año fiscal de la consulta, y el mes fiscal anterior (puede ser 0, cuando el mes fiscal de la consulta es 1); 
            // estos valores serán usados para leer los saldos iniciales de la consulta; Nota: para el mes 1, el saldo anterior siempre será el inicial del 
            // año; para el mes 12, el saldo inicial siempre será el mes 11 ... 

            nMesFiscal = query.MesFiscal - 1;

            switch (query.Ano) {
                case 0:
                    // el mes calendario corresponde a un mes del mismo año
                    nAnoFiscal = nAnoCalendario;
                    break; 
                case 1:
                    // el mes calendario corresponde a un mes del año anterior
                    nAnoFiscal = nAnoCalendario - 1;
                    break; 
            }

            db.Dispose();

            return true;
        }

        bool bLeerSaldoCuenta(int cuentaContableID, int nMesFiscal, int nAnoFiscal, int nMoneda, int? monedaOriginal, ref decimal nSaldoAnteriorCuentaContable)
        {
            // leemos el saldo de la cuenta para la moneda y lo regresamos; nótese como puede haber más de un registro,
            // cuando la compañía es multimoneda (ie: la moneda original puede tener varios valores)
            dbContabDataContext db = new dbContabDataContext();

            var query = from s in db.SaldosContables
                        where s.CuentaContableID == cuentaContableID && 
                              s.Ano == nAnoFiscal && 
                              s.Moneda == nMoneda 
                        select s;

            if (monedaOriginal != null)
                query = query.Where(s => s.MonedaOriginal == monedaOriginal.Value); 

            nSaldoAnteriorCuentaContable = 0;

            foreach (var MyRegistroSaldos in query) {

                switch (nMesFiscal) {
                    case 0:
                        nSaldoAnteriorCuentaContable += MyRegistroSaldos.Inicial.Value;
                        break;
                    case 1:
                        nSaldoAnteriorCuentaContable += MyRegistroSaldos.Mes01.Value;
                        break; 
                    case 2:
                        nSaldoAnteriorCuentaContable += MyRegistroSaldos.Mes02.Value;
                        break;
                    case 3:
                        nSaldoAnteriorCuentaContable += MyRegistroSaldos.Mes03.Value;
                        break;
                    case 4:
                        nSaldoAnteriorCuentaContable += MyRegistroSaldos.Mes04.Value;
                        break;
                    case 5:
                        nSaldoAnteriorCuentaContable += MyRegistroSaldos.Mes05.Value;
                        break;
                    case 6:
                        nSaldoAnteriorCuentaContable += MyRegistroSaldos.Mes06.Value;
                        break;
                    case 7:
                        nSaldoAnteriorCuentaContable += MyRegistroSaldos.Mes07.Value;
                        break;
                    case 8:
                        nSaldoAnteriorCuentaContable += MyRegistroSaldos.Mes08.Value;
                        break;
                    case 9:
                        nSaldoAnteriorCuentaContable += MyRegistroSaldos.Mes09.Value;
                        break;
                    case 10:
                        nSaldoAnteriorCuentaContable += MyRegistroSaldos.Mes10.Value;
                        break;
                    case 11:
                        nSaldoAnteriorCuentaContable += MyRegistroSaldos.Mes11.Value;
                        break;
                }
            }

            db.Dispose();
            return true;
        }

        private bool DeterminarMontoMovimientosPeriodoInicial(System.DateTime fechaInicialPeriodo, 
            int cuentaContableID, int moneda, int? monedaOriginal, out decimal montoAsientos, out string errorMessage)
        {

            // esta función lee el monto en movimientos desde el 1ro del mes hasta una fecha posterior. La idea es
            // ejecutarla cuando el usuario indica una fecha inicial para el período diferente de 1ro. Entonces,
            // leemos y regresamos el monto en movimientos desde el 1ro. hasta justo el día anterior a la fecha
            // inicial del período

            montoAsientos = 0;
            errorMessage = ""; 

            System.DateTime dFecha1erDiaMes = new System.DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1);
            System.DateTime dFechaDiaAnteriorFechaInicialPeriodo = new System.DateTime(fechaInicialPeriodo.Year,
                                                                                       fechaInicialPeriodo.Month,
                                                                                       fechaInicialPeriodo.AddDays(-1).Day);

            Object returnValue = null;

            using (SqlConnection sqlConnection = new SqlConnection(ConfigurationManager.ConnectionStrings["dbContabConnectionString"].ConnectionString))
            {
                try
                {

                    sqlConnection.Open();

                    SqlCommand cmd = new SqlCommand();

                    cmd.CommandText = "Select Sum(Debe - Haber) From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico Where d.CuentaContableID = @cuentaContableID And a.Moneda = @moneda And (a.Fecha Between @fechaInicial And @fechaFinal)";

                    if (monedaOriginal != null)
                        cmd.CommandText += " And a.MonedaOriginal = @monedaOriginal"; 

                    cmd.Parameters.Add("@cuentaContableID", SqlDbType.Int).Value = cuentaContableID;
                    cmd.Parameters.Add("@moneda", SqlDbType.Int).Value = moneda;
                    cmd.Parameters.Add("@fechaInicial", SqlDbType.Date).Value = dFecha1erDiaMes;
                    cmd.Parameters.Add("@fechaFinal", SqlDbType.Date).Value = dFechaDiaAnteriorFechaInicialPeriodo;

                    if (monedaOriginal != null) 
                        cmd.Parameters.Add("@monedaOriginal", SqlDbType.Int).Value = monedaOriginal.Value; 
                    
                    
                    cmd.CommandType = CommandType.Text;
                    cmd.Connection = sqlConnection;

                    returnValue = cmd.ExecuteScalar();
                }
                catch (Exception ex)
                {
                    /*Handle error*/
                    errorMessage = ex.Message;
                    if (ex.InnerException != null)
                        errorMessage += ". Inner exception message: " + ex.InnerException.Message;

                    return false; 
                }


                if (returnValue != null)
                    if (decimal.TryParse(returnValue.ToString(), out montoAsientos))
                        return true;

                return true; 
            }
        }

        private void BindDataToCuentasListView()
        {
            // obtenemos el 1er. item en el combo y lo usamos para seleccionar los items en la lista

            //int nCiaContabSeleccionada = 0;

            //if (CompaniasSeleccionadas_DropDownList.SelectedIndex != -1)
            //{
            //    nCiaContabSeleccionada = Convert.ToInt32(CompaniasSeleccionadas_DropDownList.SelectedValue);
            //}
            //else
            //{
            //    nCiaContabSeleccionada = -999;
            //}

            //CuentasContables_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = nCiaContabSeleccionada.ToString();
            //CuentasContables_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;

            //CuentasContables_ListView.DataBind();
            //CuentasContables_ListView.SelectedIndex = -1;
        }

        private void UnBindMovimientosListView()
        {
            // para que el 'child' ListView no muestre información anterior
            CuentasContables_Movimientos_SqlDataSource.SelectParameters["ParentID"].DefaultValue = "-9999";
            CuentasContables_Movimientos_ListView.DataBind();
        }

        // The return type can be changed to IEnumerable, however to support
        // paging and sorting, the following parameters must be added:
        //     int maximumRows
        //     int startRowIndex
        //     out int totalRowCount
        //     string sortByExpression

        public IQueryable<ContabSysNet_Web.ModelosDatos_EF.Contab.Contab_ConsultaCuentasYMovimientos> CuentasContables_ListView_GetData()
        {
            string userName = Membership.GetUser().UserName;

            ContabSysNet_Web.ModelosDatos_EF.Contab.dbContab_Contab_Entities context = new ContabSysNet_Web.ModelosDatos_EF.Contab.dbContab_Contab_Entities(); 

            var query = context.Contab_ConsultaCuentasYMovimientos.Include("CuentasContable").Include("Moneda1").Where(c => c.NombreUsuario == userName);

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

        public IQueryable<ContabSysNet_Web.ModelosDatos_EF.Contab.Compania> Companias_DropBox_GetData()
        {
            string userName = Membership.GetUser().UserName;

            ContabSysNet_Web.ModelosDatos_EF.Contab.dbContab_Contab_Entities context = new ContabSysNet_Web.ModelosDatos_EF.Contab.dbContab_Contab_Entities();

            var query = context.Companias.Where(c => c.CuentasContables.Where(ct => ct.Contab_ConsultaCuentasYMovimientos.Where(m => m.NombreUsuario == userName).Any()).Any()).Select(c => c); 
            query = query.OrderBy(c => c.Nombre);
            return query;
        }

        public IQueryable<ContabSysNet_Web.ModelosDatos_EF.Contab.Moneda> Monedas_DropBox_GetData()
        {
            string userName = Membership.GetUser().UserName;

            ContabSysNet_Web.ModelosDatos_EF.Contab.dbContab_Contab_Entities context = new ContabSysNet_Web.ModelosDatos_EF.Contab.dbContab_Contab_Entities();

            var query = context.Monedas.Where(m => m.Contab_ConsultaCuentasYMovimientos.Where(c => c.NombreUsuario == userName).Any()).Select(c => c); 
            query = query.OrderBy(c => c.Descripcion);
            return query;
        }

        protected void AplicarMiniFiltro(object sender, EventArgs e)
        {
            // nótese lo que se debe hacer para poner el ListView en su 1ra. página ... 
            DataPager pgr = this.CuentasContables_ListView.FindControl("CuentasContables_DataPager") as DataPager;
            if (pgr != null)
                pgr.SetPageProperties(0, pgr.MaximumRows, false);

            this.CuentasContables_ListView.DataBind();
            CuentasContables_ListView.SelectedIndex = -1;

            // para oculatar la lista de movimientos para una cuenta, si ya estaba mostrada en la página ... 
            UnBindMovimientosListView();
        }
    }
}
