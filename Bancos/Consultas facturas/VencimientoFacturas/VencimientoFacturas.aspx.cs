using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.Security;
using ContabSysNetWeb.Old_App_Code;
using System.Linq;
using ContabSysNet_Web.old_app_code; 

public partial class Bancos_VencimientoFacturas_VencimientoFacturas : System.Web.UI.Page
    {

    private class CuotaFactura_Entity
    {
        public int ClaveUnica { get; set; }
        public short CxCCxPFlag { get; set; }
        public string CxCCxPFlag_Descripcion { get; set; }
        public int Moneda { get; set; }
        public string NombreMoneda { get; set; }
        public string SimboloMoneda { get; set; }
        public int CiaContab { get; set; }
        public string NombreCiaContab { get; set; }
        public int Compania { get; set; }
        public string NombreCompania { get; set; }
        public string NombreCompaniaAbreviatura { get; set; }
        public string NumeroFactura { get; set; }
        public short NumeroCuota { get; set; }
        public DateTime FechaEmision { get; set; }
        public DateTime FechaRecepcion { get; set; }
        public DateTime FechaVencimiento { get; set; }
        public short DiasVencimiento { get; set; }
        public decimal MontoCuota { get; set; }
        public decimal? Iva { get; set; }
        public decimal? RetencionSobreISLR { get; set; }
        public DateTime? FRecepcionRetencionISLR { get; set; }
        public decimal? RetencionSobreIva { get; set; }
        public DateTime? FRecepcionRetencionIva { get; set; }
        public decimal? Anticipo { get; set; }
    }

    // para leer sql server antes del query principal y determinar si hay facturas repetidas que harían que este proceso falle 
    private class FacturaDatosPK_Entity
    {
        public string CxCCxPFlag_Descripcion { get; set; }
        public int Compania { get; set; }
        public string NumeroFactura { get; set; }
        public short NumeroCuota { get; set; }
        public int UniquePK_Count { get; set; }
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

        Master.Page.Title = "Consulta de Vencimiento de Facturas Pendientes";

        if (!Page.IsPostBack)
        {
            //Gets a reference to a Label control that is not in a 
            //ContentPlaceHolder control

            HtmlContainerControl MyHtmlSpan;   

            MyHtmlSpan = (HtmlContainerControl)(Master.FindControl("AppName_Span"));
            if (MyHtmlSpan != null)
            MyHtmlSpan.InnerHtml = "Bancos"; 

            HtmlGenericControl MyHtmlH2  ; 

            MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
            if ( MyHtmlH2 != null)
                MyHtmlH2.InnerHtml = "Vencimiento de Saldos Pendientes";
           
            //--------------------------------------------------------------------------------------------
            //para asignar la página que corresponde al help de la página 
 
            HtmlAnchor MyHtmlHyperLink; 
            MyHtmlHyperLink = (HtmlAnchor)Master.FindControl("Help_HyperLink");

            MyHtmlHyperLink.HRef = "javascript:PopupWin('../../../Doc/Bancos/Facturas/VencimientoFacturas/VencimientoFacturas.htm', 1000, 680)"; 

            Session["FiltroForma"] = null;
            Session["AplicarFechasRecepcionPlanillasRetencionImpuestos"] = null; 
        }
        else
        {
            //-------------------------------------------------------------------------
            // la página puede ser 'refrescada' por el popup; en ese caso, ejeucutamos  
            // una función que efectúa alguna funcionalidad y rebind la información 

            if (this.RebindFlagHiddenField.Value == "1")
                {
                RebindFlagHiddenField.Value = "0";
                RefreshAndBindInfo(); 
                }
            // -------------------------------------------------------------------------
        }
    }

private void RefreshAndBindInfo()
{

        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }
        

        if (Session["FiltroForma"] == null)
        {
            ErrMessage_Span.InnerHtml = "Aparentemente, Ud. no ha indicado un filtro aún.<br />Por favor indique y aplique un filtro antes de intentar mostrar el resultado de la consulta."; 
            ErrMessage_Span.Style["display"] = "block"; 

            return;
        }

        // el usuario indica o no si quiere determinar los montos de retención de impuestos (iva/islr) en base a sus fechas de 
        // recepción de planillas; si el usuario deja esta opción en false, las retenciones de impuestos *siempre* son 
        // restadas del monto a pagar de la factura; si el usuario marca esta opción, los montos de retención de impuestos 
        // (iva/islr) son restados del monto a pagar *solo* si sus fechas de recepción son *anteriores o iguales* a la fecha de la consulta ... 
        bool aplicarFechasRecepcionPlanillasRetencionImpuestos = false;

        if (Session["AplicarFechasRecepcionPlanillasRetencionImpuestos"] != null)
            aplicarFechasRecepcionPlanillasRetencionImpuestos = Convert.ToBoolean(Session["AplicarFechasRecepcionPlanillasRetencionImpuestos"]);

        // usamos el criterio que indico el usuario para leer las cuentas contables y grabarlas a una tabla 
        // en la base de datos temporal 
        string filtro = Session["FiltroForma"].ToString();
        filtro = filtro.Replace("CuotasFactura", "Facturas");

        dbBancosDataContext BancosDB = new dbBancosDataContext();

        // ----------------------------------------------------------------------------------------------------------------------------------------
        // antes de iniciar el proceso, revisamos que no se produzcan varios items con el mismo pk. Estos registros serán grabados a una tabla 
        // en sql server. Si el pk es duplicado, el proceso fallará. Revisamos antes ... 
        string sSqlQueryString = "SELECT Case Facturas.CxCCxPFlag When 1 Then 'CxP' When 2 Then 'CxC' End As CxCCxPFlag_Descripcion, " +
                                 "Facturas.Proveedor As Compania, " +
                                 "Facturas.NumeroFactura, CuotasFactura.NumeroCuota, Count(*) As UniquePK_Count " +
                                 "FROM CuotasFactura " +
                                 "Inner Join Facturas On CuotasFactura.ClaveUnicaFactura = Facturas.ClaveUnica " +
                                 "Where (Facturas.FechaRecepcion >= {0}) And (Facturas.FechaRecepcion <= {1}) And " + filtro + 
                                 " And (CuotasFactura.EstadoCuota <> 4) " +
                                 "Group By Facturas.CxCCxPFlag, Facturas.Proveedor, Facturas.NumeroFactura, CuotasFactura.NumeroCuota " + 
                                 "Having Count(*) > 1";

        DateTime fechaInicial_consulta = new DateTime(1960, 1, 1);

        // la fecha de inicio de la consulta puede o no venir 
        if (Session["FechaConsulta_Inicio"] != null)
            fechaInicial_consulta = DateTime.Parse(Session["FechaConsulta_Inicio"].ToString()); 

        var queryDuplicados = BancosDB.ExecuteQuery<FacturaDatosPK_Entity>(sSqlQueryString, 
                                        fechaInicial_consulta.ToString("yyyy-MM-dd"), 
                                       DateTime.Parse(Session["FechaConsulta"].ToString()).ToString("yyyy-MM-dd")).ToList();

        if (queryDuplicados.Count() > 0)
        {
            string errorMessage = "Error: hemos encontrado facturas <b>duplicadas</b> (mismo número de factura) para una <b>misma</b> compañía; " +
                                  "por favor resuelva esta situación y regrese a ejecutar esta consulta.<br /><br />"; 

            foreach (var item in queryDuplicados)
            {
                var compania = BancosDB.Proveedores.Where(p => p.Proveedor == item.Compania).Select(p => new { p.Nombre } ).FirstOrDefault();
                errorMessage += $" compañía: {compania.Nombre} - tipo: {item.CxCCxPFlag_Descripcion} - factura: {item.NumeroFactura} - cuota: {item.NumeroCuota}. <br />";
            }

            ErrMessage_Span.InnerHtml = errorMessage; 
            ErrMessage_Span.Style["display"] = "block";

            return;
        }


        // ahora leemos las cantidades de días que el usuario registro en la tabla PeriodosVencimiento; estos 
        // días nos permitirán determinar la antiguedad de un saldo vencido o por vencer 
        var query0 = from pv in BancosDB.PeriodosVencimientos select pv.CantidadDias;
        short i = 0;

        int nCantDias1 = -1, nCantDias2 = -1, nCantDias3 = -1; 

        foreach (int nCantidadDias in query0)
            {
            i++; 
            switch (i) 
                {
                case 1:
                    nCantDias1 = nCantidadDias; 
                    break; 
                case 2: 
                    nCantDias2 = nCantidadDias; 
                    break; 
                case 3: 
                    nCantDias3 = nCantidadDias; 
                    break; 
                }

            }

        // guardamos los valores de la tabla, pues los usaremos al generar el reporte 
        Session["CantDias1"] = nCantDias1;
        Session["CantDias2"] = nCantDias2;
        Session["CantDias3"] = nCantDias3; 

        // --------------------------------------------------------------------------------------------
        // eliminamos el contenido de la tabla temporal 
        ContabSysNet_TempDBDataContext TempDB = new ContabSysNet_TempDBDataContext(); 

        try
            {
                TempDB.ExecuteCommand("Delete From Bancos_VencimientoFacturas Where NombreUsuario = {0}", Membership.GetUser().UserName);
            }
        catch (Exception ex)
            {
                TempDB.Dispose();

                ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> El mensaje específico de error es: " + ex.Message + "<br />";
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

        sSqlQueryString = "SELECT CuotasFactura.ClaveUnica, Facturas.CxCCxPFlag, " +
                          "Case CxCCxPFlag When 1 Then 'CxP' When 2 Then 'CxC' End As CxCCxPFlag_Descripcion, " +
                          "Facturas.Moneda, Monedas.Descripcion As NombreMoneda, Monedas.Simbolo As SimboloMoneda, " +
                          "Facturas.Cia As CiaContab, Companias.NombreCorto As NombreCiaContab, " +
                          "Facturas.Proveedor As Compania, Proveedores.Nombre As NombreCompania, Proveedores.Abreviatura As NombreCompaniaAbreviatura, " +
                          "Facturas.NumeroFactura, CuotasFactura.NumeroCuota, Facturas.FechaEmision, " +
                          "Facturas.FechaRecepcion, CuotasFactura.FechaVencimiento, CuotasFactura.DiasVencimiento, CuotasFactura.MontoCuota, " +
                          "CuotasFactura.Iva, CuotasFactura.RetencionSobreISLR, Facturas.FRecepcionRetencionISLR, " +
                          "CuotasFactura.RetencionSobreIva, Facturas.FRecepcionRetencionIva, " +
                          "CuotasFactura.Anticipo " +
                          "FROM CuotasFactura " + 
                          "Inner Join Facturas On CuotasFactura.ClaveUnicaFactura = Facturas.ClaveUnica " +
                          "Inner Join Companias ON Facturas.Cia = Companias.Numero " +
                          "Inner Join Monedas ON Facturas.Moneda = Monedas.Moneda " +
                          "Inner Join Proveedores ON Facturas.Proveedor = Proveedores.Proveedor " +
                          "Where Facturas.FechaRecepcion >= {0} And Facturas.FechaRecepcion <= {1} And " + filtro + " And " + "CuotasFactura.EstadoCuota <> 4 "; 

                    // dejamos de excluir cuotas de factura que tengan pagos y cuyo estado sea Pagada; 
                    // leemos los pagos de las cuotas más abajo y excluimos las totalmente pagadas allí 
                    // (el proceso será más lento, pero 'transaccional') 

                    //"And CuotasFactura.ClaveUnica Not In " + 
                    //"(Select ClaveUnicaCuotaFactura From dPagos Inner Join Pagos On " + 
                    //"dPagos.ClaveUnicaPago = Pagos.ClaveUnica Inner Join CuotasFactura On " + 
                    //"dPagos.ClaveUnicaCuotaFactura = CuotasFactura.ClaveUnica Where Pagos.Fecha <= {0} And EstadoCuota = 3)";

        var query = BancosDB.ExecuteQuery<CuotaFactura_Entity>(sSqlQueryString, fechaInicial_consulta.ToString("yyyy-MM-dd"), 
                                                                                DateTime.Parse(Session["FechaConsulta"].ToString()).ToString("yyyy-MM-dd")); 

        List<Bancos_VencimientoFactura> MyVencimientosFactura_List = new List<Bancos_VencimientoFactura>();
        Bancos_VencimientoFactura MyVencimientosFactura; 

        foreach (CuotaFactura_Entity MyCuotasFacturas_Object  in query)
            {

            // para cada cuota de factura leída, leemos sus montos pagados, para grabarlos al
            // registro. Luego, con el monto a pagar y el monto pagado determinaremos el vencimiento, 
            // de acuerdo a los períodos indicados por el usuario en la tabla PeriodosVencimiento 
            var nMontoPagado = 
                (from pagos in BancosDB.dPagos
                 where pagos.ClaveUnicaCuotaFactura == MyCuotasFacturas_Object.ClaveUnica &&
                       pagos.Pago.Fecha <= (DateTime)Session["FechaConsulta"] && 
                       pagos.Pago.Fecha >= MyCuotasFacturas_Object.FechaRecepcion // excluimos los anticipos; su fecha es siempre *anterior* a la factura
                 select (decimal?)pagos.MontoPagado).Sum(); 
           
            
            MyVencimientosFactura = new Bancos_VencimientoFactura();

            MyVencimientosFactura.CxCCxPFlag = MyCuotasFacturas_Object.CxCCxPFlag;
            MyVencimientosFactura.CxCCxPFlag_Descripcion = MyCuotasFacturas_Object.CxCCxPFlag_Descripcion;
            MyVencimientosFactura.Moneda = MyCuotasFacturas_Object.Moneda;
            MyVencimientosFactura.NombreMoneda = MyCuotasFacturas_Object.NombreMoneda;
            MyVencimientosFactura.SimboloMoneda = MyCuotasFacturas_Object.SimboloMoneda;
            MyVencimientosFactura.CiaContab = MyCuotasFacturas_Object.CiaContab;
            MyVencimientosFactura.NombreCiaContab = MyCuotasFacturas_Object.NombreCiaContab;
            MyVencimientosFactura.Compania = MyCuotasFacturas_Object.Compania;

            MyVencimientosFactura.NombreCompania = MyCuotasFacturas_Object.NombreCompania;
            MyVencimientosFactura.NombreCompaniaAbreviatura = MyCuotasFacturas_Object.NombreCompaniaAbreviatura;
            MyVencimientosFactura.NumeroFactura = MyCuotasFacturas_Object.NumeroFactura;
            MyVencimientosFactura.NumeroCuota = MyCuotasFacturas_Object.NumeroCuota;
            MyVencimientosFactura.FechaEmision = MyCuotasFacturas_Object.FechaEmision;
            MyVencimientosFactura.FechaRecepcion = MyCuotasFacturas_Object.FechaRecepcion;
            MyVencimientosFactura.FechaVencimiento = MyCuotasFacturas_Object.FechaVencimiento;
            MyVencimientosFactura.DiasVencimiento = MyCuotasFacturas_Object.DiasVencimiento;
            MyVencimientosFactura.MontoCuota = MyCuotasFacturas_Object.MontoCuota;
            MyVencimientosFactura.MontoCuota = MyCuotasFacturas_Object.MontoCuota;

            MyVencimientosFactura.MontoCuotaDespuesIva = MyVencimientosFactura.MontoCuota;

            if (MyCuotasFacturas_Object.Iva != null)
            {
                MyVencimientosFactura.MontoCuotaDespuesIva += MyCuotasFacturas_Object.Iva.Value;
                MyVencimientosFactura.Iva = MyCuotasFacturas_Object.Iva; 
            }

            MyVencimientosFactura.TotalAntesAnticipo = MyVencimientosFactura.MontoCuotaDespuesIva; 

            
            // nótese ahora como calculamos el total de la factura en base a la opción usada por el usuario 

            MyVencimientosFactura.RetencionSobreISLR = MyCuotasFacturas_Object.RetencionSobreISLR;
            MyVencimientosFactura.RetencionSobreIva = MyCuotasFacturas_Object.RetencionSobreIva;

            MyVencimientosFactura.FRecepcionRetencionISLR = MyCuotasFacturas_Object.FRecepcionRetencionISLR;
            MyVencimientosFactura.FRecepcionRetencionIva = MyCuotasFacturas_Object.FRecepcionRetencionIva;

            if (aplicarFechasRecepcionPlanillasRetencionImpuestos)
            {
                // solo consideramos las retenciones de impuesto (islr/iva) si se ha recibido (su planilla) 
                if (MyVencimientosFactura.RetencionSobreISLR != null &&
                    MyVencimientosFactura.RetencionSobreISLR != 0 &&
                    MyVencimientosFactura.FRecepcionRetencionISLR != null)
                    if (MyVencimientosFactura.FRecepcionRetencionISLR.Value <= (DateTime)Session["FechaConsulta"])
                    {
                        // el monto de retención existe y fue recibido ... lo aplicamos 
                        MyVencimientosFactura.TotalAntesAnticipo -= MyVencimientosFactura.RetencionSobreISLR.Value;
                        MyVencimientosFactura.RetencionSobreISLRAplica = true; 
                    }

                if (MyVencimientosFactura.RetencionSobreIva != null &&
                    MyVencimientosFactura.RetencionSobreIva != 0 &&
                    MyVencimientosFactura.FRecepcionRetencionIva != null)
                    if (MyVencimientosFactura.FRecepcionRetencionIva.Value <= (DateTime)Session["FechaConsulta"])
                    {
                        // el monto de retención existe y fue recibido ... lo aplicamos 
                        MyVencimientosFactura.TotalAntesAnticipo -= MyVencimientosFactura.RetencionSobreIva.Value;
                        MyVencimientosFactura.RetencionSobreIvaAplica = true; 
                    }
            }
            else
            {
                // siempre consideramos los montos de retención de impuesto; es decir, siempre se restan del monto a pagar 

                if (MyVencimientosFactura.RetencionSobreISLR != null && MyVencimientosFactura.RetencionSobreISLR != 0)
                {
                    MyVencimientosFactura.TotalAntesAnticipo -= MyVencimientosFactura.RetencionSobreISLR.Value;
                    MyVencimientosFactura.RetencionSobreISLRAplica = true; 
                }

                if (MyVencimientosFactura.RetencionSobreIva != null && MyVencimientosFactura.RetencionSobreIva != 0)
                {
                    MyVencimientosFactura.TotalAntesAnticipo -= MyVencimientosFactura.RetencionSobreIva.Value;
                    MyVencimientosFactura.RetencionSobreIvaAplica = true; 
                }
            }

            MyVencimientosFactura.Total = MyVencimientosFactura.TotalAntesAnticipo; 

            MyVencimientosFactura.Anticipo = MyCuotasFacturas_Object.Anticipo;

            if (MyVencimientosFactura.Anticipo != null)
                MyVencimientosFactura.Total -= MyVencimientosFactura.Anticipo.Value; 

            MyVencimientosFactura.SaldoPendiente = MyVencimientosFactura.Total;

            if (nMontoPagado != null)
            {
                MyVencimientosFactura.MontoPagado = nMontoPagado;
                MyVencimientosFactura.SaldoPendiente -= nMontoPagado.Value;
            }

            
            if (MyVencimientosFactura.SaldoPendiente == 0)
                continue; 

            // el procediemiento que sigue determina la antiguedad del saldo, en base a la fecha de vencimiento 
            // del saldo, la fecha de la consulta y la cantidad de días que el usuario registro en la tabla 
            // PeriodosVencimiento 

            int nDiasTranscurridos = 0;
            decimal nSaldoPendiente0 = 0;
            decimal nSaldoPendiente1 = 0;
            decimal nSaldoPendiente2 = 0;
            decimal nSaldoPendiente3 = 0; 
            decimal nSaldoPendiente4 = 0; 
                

            DeterminarAntiguedadSaldoPendiente((DateTime)(Session["FechaConsulta"]), 
                                                MyVencimientosFactura.FechaVencimiento, 
                                                MyVencimientosFactura.SaldoPendiente, 
                                                nCantDias1, 
                                                nCantDias2, 
                                                nCantDias3, 
                                                out nDiasTranscurridos, 
                                                out nSaldoPendiente0, 
                                                out nSaldoPendiente1, 
                                                out nSaldoPendiente2, 
                                                out nSaldoPendiente3, 
                                                out nSaldoPendiente4);

            MyVencimientosFactura.DiasPorVencerOVencidos = nDiasTranscurridos;
            MyVencimientosFactura.SaldoPendiente_0 = nSaldoPendiente0;
            MyVencimientosFactura.SaldoPendiente_1 = nSaldoPendiente1;
            MyVencimientosFactura.SaldoPendiente_2 = nSaldoPendiente2;
            MyVencimientosFactura.SaldoPendiente_3 = nSaldoPendiente3;
            MyVencimientosFactura.SaldoPendiente_4 = nSaldoPendiente4;

            MyVencimientosFactura.NombreUsuario = Membership.GetUser().UserName; 

            MyVencimientosFactura_List.Add(MyVencimientosFactura);

            }

        BancosDB.Dispose();

        TempDB.Bancos_VencimientoFacturas.InsertAllOnSubmit(MyVencimientosFactura_List);
       
        try
            {
                TempDB.SubmitChanges();
            }
            
        catch (Exception ex)
            {
                TempDB.Dispose();

                ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> El mensaje específico de error es: " + ex.Message + "<br /><br />";
                ErrMessage_Span.Style["display"] = "block";
                return;
            }
            
        TempDB.Dispose();

        // ------------------------------------------------------------------------------------------------
        // hacemos el databinding de los dos combos 

        CiasContabSeleccionadas_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;
        MonedasSeleccionadas_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;
        CxCCxPFlag_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName; 

        CompaniasSeleccionadas_DropDownList.DataBind();
        MonedasSeleccionadas_DropDownList.DataBind();
        CxCCxPFlag_DropDownList.DataBind(); 

        //ComprobantesContables_LinqDataSource.WhereParameters("Moneda").DefaultValue = -999
        //ComprobantesContables_LinqDataSource.WhereParameters("CiaContab").DefaultValue = -999

        // intentamos usar como parametros del LinqDataSource el primer item en los combos Monedas y CiasContab

        if (CompaniasSeleccionadas_DropDownList.Items.Count > 0)
            {
            CompaniasSeleccionadas_DropDownList.SelectedIndex = 0;
            VencimientoSaldosFacturas_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = CompaniasSeleccionadas_DropDownList.SelectedValue;
            }

        if (MonedasSeleccionadas_DropDownList.Items.Count > 0)
            {
            MonedasSeleccionadas_DropDownList.SelectedIndex = 0;
            VencimientoSaldosFacturas_SqlDataSource.SelectParameters["Moneda"].DefaultValue = MonedasSeleccionadas_DropDownList.SelectedValue;
            }

        if (CxCCxPFlag_DropDownList.Items.Count > 0)
            {
            CxCCxPFlag_DropDownList.SelectedIndex = 0;
            VencimientoSaldosFacturas_SqlDataSource.SelectParameters["CxCCxPFlag"].DefaultValue = CxCCxPFlag_DropDownList.SelectedValue;
            }

        VencimientoSaldosFacturas_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName; 
        this.ListView1.DataBind(); 

        // --------------------------------------------------------------------------------
        // para mostrar el período indicado por el usuario como un subtítulo de la página 

         HtmlContainerControl MyHtmlSpan = (HtmlContainerControl)Master.FindControl("PageSubTitle_Span");
         if (MyHtmlSpan != null)
             {
             switch (short.Parse(Session["TipoConsulta"].ToString()))
                 {
                 case 1:             // análisis de montos por vencer { 

                    if (fechaInicial_consulta == new DateTime(1960, 1, 1))
                        MyHtmlSpan.InnerHtml = "Antiguedad de saldos por vencer al: " + DateTime.Parse(Session["FechaConsulta"].ToString()).ToString("dd-MMM-yy");
                        
                    else
                        MyHtmlSpan.InnerHtml = "Antiguedad de saldos por vencer - " +
                                               fechaInicial_consulta.ToString("dd-MMM-yy") + 
                                               " al " + DateTime.Parse(Session["FechaConsulta"].ToString()).ToString("dd-MMM-yy"); 

                    TipoConsulta_Label.Text = "(Nota: una cantidad de días negativa indica un saldo pendiente ya vencido)";
                    break;
                 case 2:             // análisis de montos vencidos 
                   
                    if (fechaInicial_consulta == new DateTime(1960, 1, 1))
                        MyHtmlSpan.InnerHtml = "Antiguedad de saldos vencidos al: " + DateTime.Parse(Session["FechaConsulta"].ToString()).ToString("dd-MMM-yy");

                    else
                        MyHtmlSpan.InnerHtml = "Antiguedad de saldos vencidos - " +
                                               fechaInicial_consulta.ToString("dd-MMM-yy") +
                                               " al " + DateTime.Parse(Session["FechaConsulta"].ToString()).ToString("dd-MMM-yy");

                    TipoConsulta_Label.Text = "(Nota: una cantidad de días positiva indica un saldo pendiente por vencerse)"; 
                    break;
                 }
             }     
}

private void DeterminarAntiguedadSaldoPendiente(
    DateTime dFechaConsulta, 
    DateTime dFechaVencimiento, 
    decimal nSaldoPendiente, 
    int nCantDias1, 
    int nCantDias2, 
    int nCantDias3, 
    out int nDiasTranscurridos, 
    out decimal nSaldoPendiente0, 
    out decimal nSaldoPendiente1, 
    out decimal nSaldoPendiente2, 
    out decimal nSaldoPendiente3, 
    out decimal nSaldoPendiente4)
    {

    nSaldoPendiente0 = 0; 
    nSaldoPendiente1 = 0; 
    nSaldoPendiente2 = 0; 
    nSaldoPendiente3 = 0; 
    nSaldoPendiente4 = 0;
    nDiasTranscurridos = 0;

    TimeSpan ts = dFechaVencimiento - dFechaConsulta; 
    nDiasTranscurridos = ts.Days;

    switch (short.Parse(Session["TipoConsulta"].ToString())) 
        {
        case 1:             // análisis de montos por vencer 

            // facturas con cantidad de días nagativa --> ya vencidas 
            // distribuímos aqueyas con cant días positiva 

            if (nDiasTranscurridos < 0)
                nSaldoPendiente0 = nSaldoPendiente;
            else if (nDiasTranscurridos <= nCantDias1)
                nSaldoPendiente1 = nSaldoPendiente;
            else if (nDiasTranscurridos <= nCantDias2)
                nSaldoPendiente2 = nSaldoPendiente;
            else if (nDiasTranscurridos <= nCantDias3)
                nSaldoPendiente3 = nSaldoPendiente;
            else
                nSaldoPendiente4 = nSaldoPendiente; 

            break; 

        case 2:             // análisis de montos vencidos 

             // facturas con cantidad de días positiva --> por vencerse 
            // distribuímos aqueyas con cant días negativa  

            if (nDiasTranscurridos > 0)
                nSaldoPendiente0 = nSaldoPendiente;
            else if (Math.Abs(nDiasTranscurridos) <= nCantDias1)
                nSaldoPendiente1 = nSaldoPendiente;
            else if (Math.Abs(nDiasTranscurridos) <= nCantDias2)
                nSaldoPendiente2 = nSaldoPendiente;
            else if (Math.Abs(nDiasTranscurridos) <= nCantDias3)
                nSaldoPendiente3 = nSaldoPendiente;
            else
                nSaldoPendiente4 = nSaldoPendiente; 

            break; 
        }
    }

protected void CompaniasSeleccionadas_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        VencimientoSaldosFacturas_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = CompaniasSeleccionadas_DropDownList.SelectedValue;
    ListView1.DataBind(); 
    }
protected void MonedasSeleccionadas_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        VencimientoSaldosFacturas_SqlDataSource.SelectParameters["Moneda"].DefaultValue = MonedasSeleccionadas_DropDownList.SelectedValue;
    ListView1.DataBind(); 
    }
protected void CxCCxPFlag_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        VencimientoSaldosFacturas_SqlDataSource.SelectParameters["CxCCxPFlag"].DefaultValue = CxCCxPFlag_DropDownList.SelectedValue;
    ListView1.DataBind(); 
    }
}

           
           
            
          

    
   