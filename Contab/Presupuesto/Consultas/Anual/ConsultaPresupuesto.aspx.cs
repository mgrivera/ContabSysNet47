using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.Security;
using System.Threading;
using ContabSysNet_Web.ModelosDatos;


public partial class Contab_Presupuesto_Consultas_Anual_ConsultaPresupuesto : System.Web.UI.Page
{

    public class PresupuestoMontos
    {
        public string CodigoPresupuesto { get; set; }
        public int CiaContab { get; set; }
        public int Moneda { get; set; }
        public short Ano { get; set; }
        public decimal Mes01_Est { get; set; }
        public decimal Mes01_Eje { get; set; }
        public decimal Mes02_Est { get; set; }
        public decimal Mes02_Eje { get; set; }
        public decimal Mes03_Est { get; set; }
        public decimal Mes03_Eje { get; set; }
        public decimal Mes04_Est { get; set; }
        public decimal Mes04_Eje { get; set; }
        public decimal Mes05_Est { get; set; }
        public decimal Mes05_Eje { get; set; }
        public decimal Mes06_Est { get; set; }
        public decimal Mes06_Eje { get; set; }
        public decimal Mes07_Est { get; set; }
        public decimal Mes07_Eje { get; set; }
        public decimal Mes08_Est { get; set; }
        public decimal Mes08_Eje { get; set; }
        public decimal Mes09_Est { get; set; }
        public decimal Mes09_Eje { get; set; }
        public decimal Mes10_Est { get; set; }
        public decimal Mes10_Eje { get; set; }
        public decimal Mes11_Est { get; set; }
        public decimal Mes11_Eje { get; set; }
        public decimal Mes12_Est { get; set; }
        public decimal Mes12_Eje { get; set; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        ErrMessage_Span.InnerHtml = "";
        ErrMessage_Span.Style["display"] = "none";

        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        Master.Page.Title = "Control de presupuesto - Consulta anualizada";

        ControlPresupuesto_Reportes_HyperLink.NavigateUrl =
            "javascript:PopupWin('../../../../ReportViewer2.aspx?rpt=ptoconsanual&cantniveles=" +
            CantNiveles_DropDownList.SelectedValue +
            "', 1000, 680)"; 

        if (!Page.IsPostBack)
        {
            //Gets a reference to a Label control that is not in a 
            //ContentPlaceHolder control

            HtmlContainerControl MyHtmlSpan;

            MyHtmlSpan = (HtmlContainerControl)(Master.FindControl("AppName_Span"));
            if (MyHtmlSpan != null)
                MyHtmlSpan.InnerHtml = "Contab";

            HtmlGenericControl MyHtmlH2;

            MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
            if (MyHtmlH2 != null)
                MyHtmlH2.InnerHtml = "Consulta del Control de Presupuesto";

            //--------------------------------------------------------------------------------------------
            //para asignar la página que corresponde al help de la página 

            HtmlAnchor MyHtmlHyperLink;
            MyHtmlHyperLink = (HtmlAnchor)Master.FindControl("Help_HyperLink");

            MyHtmlHyperLink.HRef = "javascript:PopupWin('../../../Doc/Bancos/Facturas/Consulta facturas/consulta_general_de_facturas.htm', 1000, 680)";

            Session["FiltroForma"] = null;

            // eliminamos el contenido de la tabla de factores de conversión 'aplicados', para que esté 
            // vacía cuando el usuario ejecute la función que lee estos factores y convierte las cifras 
            // de esta consulta 

            dbContabDataContext dbContab = new dbContabDataContext();

            dbContab.ExecuteCommand
                ("Delete From FactoresConversionAnoMes_Aplicados Where NombreUsuario = {0}", 
                User.Identity.Name);

            dbContab = null; 
        }
        else
        // -------------------------------------------------------------------------
        // la página puede ser 'refrescada' por el popup; en ese caso, ejeucutamos  
        // una función que efectúa alguna funcionalidad y rebind la información 
        {
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
                // ------------------------------------------------------------------------------

                BuildReportRecords();

                // ------------------------------------------------------------------------------------------------------
                // para mostrar un título que describa la consulta, leemos alguna información desde 
                // la tabla tTempWebReport... 

                dbContabDataContext dbContab = new dbContabDataContext();

                var MySelectedAnoFiscal = (from ma in dbContab.tTempWebReport_PresupuestoConsultaAnuals
                                           where ma.NombreUsuario == User.Identity.Name
                                           select new { ma.AnoFiscal }).FirstOrDefault();

                TituloConsulta_H2.InnerHtml = "Consulta anualizada de presupuesto para el año fiscal " +
                    MySelectedAnoFiscal.AnoFiscal.ToString();

                dbContab = null;

                PageDataBind();

                //Thread MyThread = new Thread(BuildReportRecords);
                //MyThread.Priority = ThreadPriority.Lowest;
                //MyThread.Start();

                //// ejecutamos javascript para que lea la variable session y muestre el progreso 

                //System.Text.StringBuilder sb = new System.Text.StringBuilder();
                //sb.Append("<script language='javascript'>");
                //sb.Append("showprogress();");
                //sb.Append("</script>");

                //ClientScript.RegisterStartupScript(this.GetType(), "onLoad", sb.ToString());
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


                    PageDataBind();

                    // ------------------------------------------------------------------------------------------------------
                    // para mostrar un título que describa la consulta, leemos alguna información desde 
                    // la tabla tTempWebReport... 

                    dbContabDataContext dbContab = new dbContabDataContext();

                    var MySelectedAnoFiscal = (from ma in dbContab.tTempWebReport_PresupuestoConsultaAnuals
                                           where ma.NombreUsuario == User.Identity.Name
                                           select new { ma.AnoFiscal }).FirstOrDefault();

                    TituloConsulta_H2.InnerHtml = "Consulta anualizada de presupuesto para el año fiscal " +
                        MySelectedAnoFiscal.AnoFiscal.ToString();

                    dbContab = null; 

                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    sb.Append("<script language='javascript'>");
                    sb.Append("showprogress_displayselectedrecs();");
                    sb.Append("</script>");

                    ClientScript.RegisterStartupScript(this.GetType(), "onLoad", sb.ToString());
                }
            }
        }
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        if (ConsultaPresupuesto_ListView.HasControls())
        {
            // intentamos leer un registro en la tabla tTempWebReport..., para obtener la compañía Contab
            // usada en el filtro y leer los nombres de meses para ésta. NOTESE QUE si el usuario 
            // selecciona más de una Cia Contab en el filtro y sus años fiscales difieren, los nombres 
            // de meses en el encabezado pueden ser inconsistentes ... 

            dbContabDataContext dbContab = new dbContabDataContext();

            var ciaContab = (from t in dbContab.tTempWebReport_PresupuestoConsultaAnuals
                             where t.NombreUsuario == User.Identity.Name
                             select t.CiaContab).FirstOrDefault();

            if (ciaContab == 0)
                return; 

            // leemos los nombres de cada mes y los monstramos en los encabezados de las columnas 
            // en el ListView. Nótese que el ListView muestra meses fiscales y no calendario 

            

            var meses = from m in dbContab.MesesDelAnoFiscals
                        where m.Mes >= 1 && m.Mes <= 12
                        where m.Cia == ciaContab
                        orderby m.MesFiscal
                        select m;

            foreach (var NombreMes in meses)
            {
                switch (NombreMes.MesFiscal)
                {
                    case 1:
                        {
                            ((HtmlTableCell)ConsultaPresupuesto_ListView.Controls[0]
                                .FindControl("Mes01_th")).InnerHtml = NombreMes.NombreMes;
                            break;
                        }
                    case 2:
                        {
                            ((HtmlTableCell)ConsultaPresupuesto_ListView.Controls[0]
                                .FindControl("Mes02_th")).InnerHtml = NombreMes.NombreMes;
                            break;
                        }
                    case 3:
                        {
                            ((HtmlTableCell)ConsultaPresupuesto_ListView.Controls[0]
                                .FindControl("Mes03_th")).InnerHtml = NombreMes.NombreMes;
                            break;
                        }
                    case 4:
                        {
                            ((HtmlTableCell)ConsultaPresupuesto_ListView.Controls[0]
                                .FindControl("Mes04_th")).InnerHtml = NombreMes.NombreMes;
                            break;
                        }
                    case 5:
                        {
                            ((HtmlTableCell)ConsultaPresupuesto_ListView.Controls[0]
                                .FindControl("Mes05_th")).InnerHtml = NombreMes.NombreMes;
                            break;
                        }
                    case 6:
                        {
                            ((HtmlTableCell)ConsultaPresupuesto_ListView.Controls[0]
                                .FindControl("Mes06_th")).InnerHtml = NombreMes.NombreMes;
                            break;
                        }
                    case 7:
                        {
                            ((HtmlTableCell)ConsultaPresupuesto_ListView.Controls[0]
                                .FindControl("Mes07_th")).InnerHtml = NombreMes.NombreMes;
                            break;
                        }
                    case 8:
                        {
                            ((HtmlTableCell)ConsultaPresupuesto_ListView.Controls[0]
                                .FindControl("Mes08_th")).InnerHtml = NombreMes.NombreMes;
                            break;
                        }
                    case 9:
                        {
                            ((HtmlTableCell)ConsultaPresupuesto_ListView.Controls[0]
                                .FindControl("Mes09_th")).InnerHtml = NombreMes.NombreMes;
                            break;
                        }
                    case 10:
                        {
                            ((HtmlTableCell)ConsultaPresupuesto_ListView.Controls[0]
                                .FindControl("Mes10_th")).InnerHtml = NombreMes.NombreMes;
                            break;
                        }
                    case 11:
                        {
                            ((HtmlTableCell)ConsultaPresupuesto_ListView.Controls[0]
                                .FindControl("Mes11_th")).InnerHtml = NombreMes.NombreMes;
                            break;
                        }
                    case 12:
                        {
                            ((HtmlTableCell)ConsultaPresupuesto_ListView.Controls[0]
                                .FindControl("Mes12_th")).InnerHtml = NombreMes.NombreMes;
                            break;
                        }
                }
            }

            dbContab = null; 
        }
    }

    private void BuildReportRecords()
    {
        // construímos los registros que se usarán para mostrar la consulta al usuario 

        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        if (Session["FiltroForma"] == null)
        {
            ErrMessage_Span.InnerHtml = "Aparentemente, Ud. no ha indicado un filtro aún.<br />Por favor indique y aplique un " + 
                "filtro antes de intentar mostrar el resultado de la consulta.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        // --------------------------------------------------------------------------------------------
        // eliminamos el contenido de la tabla temporal 

        dbContabDataContext dbContab = new dbContabDataContext();

        try
        {
            dbContab.ExecuteCommand("Delete From tTempWebReport_PresupuestoConsultaAnual Where NombreUsuario = {0}", User.Identity.Name);
        }
        catch (Exception ex)
        {
            dbContab = null;

            ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br />" + 
                "El mensaje específico de error es: " + ex.Message + "<br /><br />";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        // leemos la tabla Presupuesto_Montos y construimos los registros en tTempWebReport... 

        IList<PresupuestoMontos> PresupuestoMontos_List = dbContab.ExecuteQuery<PresupuestoMontos>
            (@"Select CodigoPresupuesto, CiaContab, Moneda, Ano, " +
            "IsNull(Mes01_Est, 0) As Mes01_Est, IsNull(Mes01_Eje, 0) As Mes01_Eje, " +
            "IsNull(Mes02_Est, 0) As Mes02_Est, IsNull(Mes02_Eje, 0) As Mes02_Eje, " +
            "IsNull(Mes03_Est, 0) As Mes03_Est, IsNull(Mes03_Eje, 0) As Mes03_Eje, " +
            "IsNull(Mes04_Est, 0) As Mes04_Est, IsNull(Mes04_Eje, 0) As Mes04_Eje, " +
            "IsNull(Mes05_Est, 0) As Mes05_Est, IsNull(Mes05_Eje, 0) As Mes05_Eje, " +
            "IsNull(Mes06_Est, 0) As Mes06_Est, IsNull(Mes06_Eje, 0) As Mes06_Eje, " +
            "IsNull(Mes07_Est, 0) As Mes07_Est, IsNull(Mes07_Eje, 0) As Mes07_Eje, " +
            "IsNull(Mes08_Est, 0) As Mes08_Est, IsNull(Mes08_Eje, 0) As Mes08_Eje, " +
            "IsNull(Mes09_Est, 0) As Mes09_Est, IsNull(Mes09_Eje, 0) As Mes09_Eje, " +
            "IsNull(Mes10_Est, 0) As Mes10_Est, IsNull(Mes10_Eje, 0) As Mes10_Eje, " +
            "IsNull(Mes11_Est, 0) As Mes11_Est, IsNull(Mes11_Eje, 0) As Mes11_Eje, " +
            "IsNull(Mes12_Est, 0) As Mes12_Est, IsNull(Mes12_Eje, 0) As Mes12_Eje " +
            "From Presupuesto_Montos " +
            "Where " + Session["FiltroForma"].ToString() + " Order By Presupuesto_Montos.CiaContab").ToList();

        if (PresupuestoMontos_List.Count() == 0)
        {
            dbContab = null;

            ErrMessage_Span.InnerHtml = "No existen registros que cumplan el criterio de selección (filtro) que Ud. ha indicado. <br />" + 
                                        "Para regresar registros, Ud. puede intentar un filtro diferente al que ha indicado.";
            ErrMessage_Span.Style["display"] = "block";

            Session["Progress_SelectedRecs"] = 0;
            Session["Progress_Completed"] = 1;
            Session["Progress_Percentage"] = 0;

            return;
        }

        int nCantidadRegistros = PresupuestoMontos_List.Count();
        int nRegistroActual = 0;
        int nProgreesPercentaje = 0;

        tTempWebReport_PresupuestoConsultaAnual MyTempWebReportPresupuestoConsultaAnual;
        List<tTempWebReport_PresupuestoConsultaAnual> MyTempWebRepotPresupuestoConsultaAnual_List = new
        List<tTempWebReport_PresupuestoConsultaAnual>();

        foreach (PresupuestoMontos MyPresupuestoMontos in PresupuestoMontos_List)
        {
            // preparamos el registro que vamos a agregar a tTempWebReport... 

            MyTempWebReportPresupuestoConsultaAnual = new tTempWebReport_PresupuestoConsultaAnual();

            MyTempWebReportPresupuestoConsultaAnual.CiaContab = MyPresupuestoMontos.CiaContab;
            MyTempWebReportPresupuestoConsultaAnual.Moneda = MyPresupuestoMontos.Moneda;
            MyTempWebReportPresupuestoConsultaAnual.AnoFiscal = MyPresupuestoMontos.Ano;
            MyTempWebReportPresupuestoConsultaAnual.CodigoPresupuesto = MyPresupuestoMontos.CodigoPresupuesto;

            MyTempWebReportPresupuestoConsultaAnual.Mes01_Eje = MyPresupuestoMontos.Mes01_Eje;
            MyTempWebReportPresupuestoConsultaAnual.Mes02_Eje = MyPresupuestoMontos.Mes02_Eje;
            MyTempWebReportPresupuestoConsultaAnual.Mes03_Eje = MyPresupuestoMontos.Mes03_Eje;
            MyTempWebReportPresupuestoConsultaAnual.Mes04_Eje = MyPresupuestoMontos.Mes04_Eje;
            MyTempWebReportPresupuestoConsultaAnual.Mes05_Eje = MyPresupuestoMontos.Mes05_Eje;
            MyTempWebReportPresupuestoConsultaAnual.Mes06_Eje = MyPresupuestoMontos.Mes06_Eje;
            MyTempWebReportPresupuestoConsultaAnual.Mes07_Eje = MyPresupuestoMontos.Mes07_Eje;
            MyTempWebReportPresupuestoConsultaAnual.Mes08_Eje = MyPresupuestoMontos.Mes08_Eje;
            MyTempWebReportPresupuestoConsultaAnual.Mes09_Eje = MyPresupuestoMontos.Mes09_Eje;
            MyTempWebReportPresupuestoConsultaAnual.Mes10_Eje = MyPresupuestoMontos.Mes10_Eje;
            MyTempWebReportPresupuestoConsultaAnual.Mes11_Eje = MyPresupuestoMontos.Mes11_Eje;
            MyTempWebReportPresupuestoConsultaAnual.Mes12_Eje = MyPresupuestoMontos.Mes12_Eje; 

            MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado =
                MyPresupuestoMontos.Mes01_Est + MyPresupuestoMontos.Mes02_Est +
                MyPresupuestoMontos.Mes03_Est + MyPresupuestoMontos.Mes04_Est +
                MyPresupuestoMontos.Mes05_Est + MyPresupuestoMontos.Mes06_Est +
                MyPresupuestoMontos.Mes07_Est + MyPresupuestoMontos.Mes08_Est +
                MyPresupuestoMontos.Mes09_Est + MyPresupuestoMontos.Mes10_Est +
                MyPresupuestoMontos.Mes11_Est + MyPresupuestoMontos.Mes12_Est;

            decimal totalEjecutado = 
                MyPresupuestoMontos.Mes01_Eje + MyPresupuestoMontos.Mes02_Eje +
                MyPresupuestoMontos.Mes03_Eje + MyPresupuestoMontos.Mes04_Eje +
                MyPresupuestoMontos.Mes05_Eje + MyPresupuestoMontos.Mes06_Eje +
                MyPresupuestoMontos.Mes07_Eje + MyPresupuestoMontos.Mes08_Eje +
                MyPresupuestoMontos.Mes09_Eje + MyPresupuestoMontos.Mes10_Eje +
                MyPresupuestoMontos.Mes11_Eje + MyPresupuestoMontos.Mes12_Eje;

            MyTempWebReportPresupuestoConsultaAnual.TotalEjecutado = totalEjecutado; 

            if (!(MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado == 0))
            {
                MyTempWebReportPresupuestoConsultaAnual.Mes01_Eje_Porc =
                    (float)(MyTempWebReportPresupuestoConsultaAnual.Mes01_Eje * 100 /
                    MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado);

                MyTempWebReportPresupuestoConsultaAnual.Mes02_Eje_Porc =
                    (float)(MyTempWebReportPresupuestoConsultaAnual.Mes02_Eje * 100 /
                    MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado);

                MyTempWebReportPresupuestoConsultaAnual.Mes03_Eje_Porc =
                    (float)(MyTempWebReportPresupuestoConsultaAnual.Mes03_Eje * 100 /
                    MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado);

                MyTempWebReportPresupuestoConsultaAnual.Mes04_Eje_Porc =
                    (float)(MyTempWebReportPresupuestoConsultaAnual.Mes04_Eje * 100 /
                    MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado);

                MyTempWebReportPresupuestoConsultaAnual.Mes05_Eje_Porc =
                    (float)(MyTempWebReportPresupuestoConsultaAnual.Mes05_Eje * 100 /
                    MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado);

                MyTempWebReportPresupuestoConsultaAnual.Mes06_Eje_Porc =
                    (float)(MyTempWebReportPresupuestoConsultaAnual.Mes06_Eje * 100 /
                    MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado);

                MyTempWebReportPresupuestoConsultaAnual.Mes07_Eje_Porc =
                    (float)(MyTempWebReportPresupuestoConsultaAnual.Mes07_Eje * 100 /
                    MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado);

                MyTempWebReportPresupuestoConsultaAnual.Mes08_Eje_Porc =
                    (float)(MyTempWebReportPresupuestoConsultaAnual.Mes08_Eje * 100 /
                    MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado);

                MyTempWebReportPresupuestoConsultaAnual.Mes09_Eje_Porc =
                    (float)(MyTempWebReportPresupuestoConsultaAnual.Mes09_Eje * 100 /
                    MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado);

                MyTempWebReportPresupuestoConsultaAnual.Mes10_Eje_Porc =
                    (float)(MyTempWebReportPresupuestoConsultaAnual.Mes10_Eje * 100 /
                    MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado);

                MyTempWebReportPresupuestoConsultaAnual.Mes11_Eje_Porc =
                    (float)(MyTempWebReportPresupuestoConsultaAnual.Mes11_Eje * 100 /
                    MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado);

                MyTempWebReportPresupuestoConsultaAnual.Mes12_Eje_Porc =
                    (float)(MyTempWebReportPresupuestoConsultaAnual.Mes12_Eje * 100 /
                    MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado);


                //MyTempWebReportPresupuestoConsultaAnual.Variacion =
                //    (float)(MyTempWebReportPresupuestoConsultaAnual.TotalEjecutado * 100 /
                //    MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado);


                // modificamos el calculo de la diferencia, para que sea realmente una diferencia y 
                // no un porcentaje de los ejecutado ... 

                decimal? diferencia =
                    MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado -
                    MyTempWebReportPresupuestoConsultaAnual.TotalEjecutado;

                if (diferencia != null)
                    MyTempWebReportPresupuestoConsultaAnual.Variacion =
                        (float)(diferencia * 100 /
                        MyTempWebReportPresupuestoConsultaAnual.TotalPresupuestado);
            }

            MyTempWebReportPresupuestoConsultaAnual.NombreUsuario = User.Identity.Name;

            // -------------------------------------------------------------------------------
            // determinamos los niveles previos para cada cuenta de presupuesto y los grabamos 
            // a la tabla (ej: niveles previos para la cuenta 3-01-001: 3-01 y 3)

            string codigoPresupuesto = MyTempWebReportPresupuestoConsultaAnual.CodigoPresupuesto;

            short cantNivelesPrevios = (short)CountStringOccurrences(codigoPresupuesto, "-");

            // los códigos deben tener al menos un codigo de agrupación (hasta 6) 

            if (cantNivelesPrevios == 0)
            {
                ErrMessage_Span.InnerHtml = "El código de presupuesto : " +
                    MyTempWebReportPresupuestoConsultaAnual.CodigoPresupuesto +
                    " no tiene un nivel (previo) que lo agrupe; los códigos de presupuesto deben tener" +
                    " al menos un nivel de agrupación.";
                ErrMessage_Span.Style["display"] = "block";

                Session["Progress_Completed"] = 1;
                Session["Progress_Percentage"] = 0;

                return;
            }

            int posProxGuion = -1;

            for (short i = 1; i <= cantNivelesPrevios; i++)
            {
                posProxGuion = codigoPresupuesto.IndexOf("-", posProxGuion + 1);
                string nivelPrevio = codigoPresupuesto.Substring(0, posProxGuion);

                switch (i)
                {
                    case 1:
                        MyTempWebReportPresupuestoConsultaAnual.Codigo1erNivel = nivelPrevio;
                        break;
                    case 2:
                        MyTempWebReportPresupuestoConsultaAnual.Codigo2doNivel = nivelPrevio;
                        break;
                    case 3:
                        MyTempWebReportPresupuestoConsultaAnual.Codigo3erNivel = nivelPrevio;
                        break;
                    case 4:
                        MyTempWebReportPresupuestoConsultaAnual.Codigo4toNivel = nivelPrevio;
                        break;
                    case 5:
                        MyTempWebReportPresupuestoConsultaAnual.Codigo5toNivel = nivelPrevio;
                        break;
                    case 6:
                        MyTempWebReportPresupuestoConsultaAnual.Codigo6toNivel = nivelPrevio;
                        break;
                }
            }

            // -------------------------------------------------------------------------------

            // agregamos el registro a la lista 

            MyTempWebRepotPresupuestoConsultaAnual_List.Add(MyTempWebReportPresupuestoConsultaAnual);

            // -------------------------------------------------------------------------------
            // para actualizar las variables que se usan para mostrar el meter al usuario 
            nRegistroActual += 1;
            nProgreesPercentaje = nRegistroActual * 100 / nCantidadRegistros;

            Session["Progress_Percentage"] = nProgreesPercentaje;
            // -------------------------------------------------------------------------------
        }

        try
        {
            // agregamos la lista a la tabla en el db 
            dbContab.tTempWebReport_PresupuestoConsultaAnuals.InsertAllOnSubmit(MyTempWebRepotPresupuestoConsultaAnual_List);

            dbContab.SubmitChanges();

            // finalmente, eliminamos de la tabla los recgistros cuya cuenta de presupuesto haya sido suspendida en la maestra 

            string sqlStatement = "Delete From temp from tTempWebReport_PresupuestoConsultaAnual temp Inner Join Presupuesto_Codigos p " +
                "on temp.CodigoPresupuesto = p.Codigo And temp.CiaContab = p.CiaContab " +
                "Where p.SuspendidoFlag = 1 And temp.NombreUsuario = {0} ";

            dbContab.ExecuteCommand(sqlStatement, User.Identity.Name); 
        }
        catch (Exception ex)
        {
            dbContab = null;

            ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br />" + 
                "El mensaje específico de error es: " + ex.Message + "<br />";
            ErrMessage_Span.Style["display"] = "block";

            Session["Progress_Completed"] = 1;
            Session["Progress_Percentage"] = 0;

            return;
        }

        dbContab = null;

        // -----------------------------------------------------
        // por último, inicializamos las variables que se usan para mostrar el progreso de la tarea 
        Session["Progress_Completed"] = 1;
        Session["Progress_Percentage"] = 0;
        Session["Progress_SelectedRecs"] = nCantidadRegistros.ToString();
        // -----------------------------------------------------
    }

    private int CountStringOccurrences(string text, string pattern)
    {
        // Loop through all instances of the string 'text'.
        int count = 0;
        int i = 0;
        while ((i = text.IndexOf(pattern, i)) != -1)
        {
            i += pattern.Length;
            count++;
        }
        return count;
    }

    private void PageDataBind()
    {
        // hacemos el databinding de los controles que muestran la consulta al usuario 

        // ------------------------------------------------------------------------------------------------
        // hacemos el databinding de los dos combos 

        this.CiasContab_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = User.Identity.Name;
        this.Monedas_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = User.Identity.Name;

        CiasContab_DropDownList.DataBind();
        Monedas_DropDownList.DataBind();

        // intentamos usar como parametros del LinqDataSource el primer item en los combos Monedas y CiasContab

        if (this.CiasContab_DropDownList.Items.Count > 0)
        {
            CiasContab_DropDownList.SelectedIndex = 0;
        }

        if (this.Monedas_DropDownList.Items.Count > 0)
        {
            Monedas_DropDownList.SelectedIndex = 0;
        }

        // establecemos los valores de los parámetros en el LinqDataSource 

        ConsultaPresupuesto_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = CiasContab_DropDownList.SelectedValue.ToString();
        ConsultaPresupuesto_SqlDataSource.SelectParameters["Moneda"].DefaultValue = Monedas_DropDownList.SelectedValue.ToString();
        ConsultaPresupuesto_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = User.Identity.Name;

        this.ConsultaPresupuesto_ListView.DataBind();
    }
    protected void CiasContab_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        ConsultaPresupuesto_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = CiasContab_DropDownList.SelectedValue.ToString();
        this.ConsultaPresupuesto_ListView.DataBind();
    }
    protected void Monedas_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        ConsultaPresupuesto_SqlDataSource.SelectParameters["Moneda"].DefaultValue = Monedas_DropDownList.SelectedValue.ToString();
        this.ConsultaPresupuesto_ListView.DataBind();
    }

    public string Fix_URL(string sCiaContab, string sCodigoPresupuesto, string sNombreCodigoPresupuesto)
    {
        // Do whatever it takes to change oldURL

        return "javascript:PopupWin('../Mensual/ConsultaPresupuesto_ConsultaCuentasContables.aspx?CiaContab=" + sCiaContab + "&CodigoPresupuesto=" + sCodigoPresupuesto + "&NombreCodigoPresupuesto=" + sNombreCodigoPresupuesto + "', 1000, 680)";
    }

    public string Fix_URL2(string sMesFiscal, string sAnoFiscal, string sCiaContab, string sMoneda, string sCodigoPresupuesto, string sNombreCodigoPresupuesto)
    {
        // Do whatever it takes to change oldURL

        // para construir el NavigateUrl en el HyperLink del monto ejecutado del mes 

        return "javascript:PopupWin('../Mensual/ConsultaPresupuesto_ConsultaMovMes.aspx?MesFiscal=" + sMesFiscal + "&AnoFiscal=" + sAnoFiscal + "&CiaContab=" + sCiaContab + "&Moneda=" + sMoneda + "&CodigoPresupuesto=" + sCodigoPresupuesto + "&NombreCodigoPresupuesto=" + sNombreCodigoPresupuesto + "', 1000, 680)";
    }

    public string Fix_URL3(string sMesFiscal, string sAnoFiscal, string sCiaContab, string sMoneda, string sCodigoPresupuesto, string sNombreCodigoPresupuesto)
    {
        // Do whatever it takes to change oldURL

        // para construir el NavigateUrl en el HyperLink del monto ejecutado del mes 

        return "javascript:PopupWin('../Mensual/ConsultaPresupuesto_ConsultaMovAcum.aspx?MesFiscal=" + sMesFiscal + "&AnoFiscal=" + sAnoFiscal + "&CiaContab=" + sCiaContab + "&Moneda=" + sMoneda + "&CodigoPresupuesto=" + sCodigoPresupuesto + "&NombreCodigoPresupuesto=" + sNombreCodigoPresupuesto + "', 1000, 680)";
    }

    protected void AplicarFactorConversion_LinkButton_Click(object sender, EventArgs e)
    {
        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        // intentamos leer los factores de uno de los 12 meses del año, para guardarlos en la tabla 
        // de la consulta (tTempWebRerpot_PresupuestoConsultaAnual; NOTESE que el año y meses de la 
        // consulta corresponden a meses fiscales y no calendario; tenemos que buscar la correspondencia 
        // en la tabla de meses fiscales de la contabilidad    

        dbContabDataContext dbContab = new dbContabDataContext();

        dbContab.ExecuteCommand
                ("Delete From FactoresConversionAnoMes_Aplicados Where NombreUsuario = {0}",
                User.Identity.Name);

        // --------------------------------------------------------------------------------
        // lo primero que hacemos es obtener el año fiscal de la consulta 

        var query0 = (from t in dbContab.tTempWebReport_PresupuestoConsultaAnuals
                      where t.NombreUsuario == User.Identity.Name
                      select t).FirstOrDefault();

        if (query0 == null)
        {
            ErrMessage_Span.InnerHtml = "Aparentemente, Ud. no ha ejecutado la consulta todavía y, " +
                "por lo tanto, no se han seleccionado registros aún para la misma. <br />" +
                "Ud. debe definir y aplicar un filtro para ejecutar la consulta y seleccionar " +
                "registros, antes de intentar aplicar un factor de conversión a estas cifras.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        Int16 nAnoFiscalConsulta = query0.AnoFiscal; 

        // leemos los meses del año en la tabla de meses, para ir obteniendo cada mes calendario y 
        // luego el factor de conversion; nótese que queremos obtener los factores ordenados por 
        // mes fiscal, pues en ese orden están presentadas las cifras de esta consulta 

        var query = from mf in dbContab.MesesDelAnoFiscals
                     where mf.Cia == query0.CiaContab && 
                     mf.MesFiscal >= 1 && mf.MesFiscal <= 12
                     orderby mf.MesFiscal
                     select mf;

        if (query == null)
        {
            ErrMessage_Span.InnerHtml = "No existe registros en la tabla Definición de Meses para " +
                "el Año Fiscal. <br /> " +
                "Por favor revise el contenido de esta tabla y corrija este error antes " +
                "de intentar continuar con este proceso.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        FactoresConversionAnoMes_Aplicado factoresConversionAplicados; 

        List<FactoresConversionAnoMes_Aplicado> factoresConversionAplicados_List =
            new List<FactoresConversionAnoMes_Aplicado>(); 

        foreach (var registroMes in query)
        {
            int nMesCalendario = registroMes.Mes;
            int nAnoCalendario = nAnoFiscalConsulta;

            if (registroMes.Ano == 1)
                nAnoCalendario++;

            // ahora que tenemos el mes y año calendarios, leemos el factor de conversión y lo 
            // guardamos en el array de factores por mes fiscal 

            var queryFactoresConversion = (from fc in dbContab.FactoresConversionAnoMes
                                           where fc.Mes == nMesCalendario &&
                                           fc.Ano == nAnoCalendario
                                           select fc).FirstOrDefault();


            factoresConversionAplicados = new FactoresConversionAnoMes_Aplicado();

            factoresConversionAplicados.MesFiscal = Convert.ToByte(registroMes.MesFiscal);
            factoresConversionAplicados.AnoFiscal = nAnoFiscalConsulta;
            factoresConversionAplicados.MesCalendario = Convert.ToByte(registroMes.Mes);
            factoresConversionAplicados.AnoCalendario = Convert.ToInt16(nAnoCalendario);
            factoresConversionAplicados.NombreMes = registroMes.NombreMes; 

            if (queryFactoresConversion == null || queryFactoresConversion.FactorConversion == 0)
                factoresConversionAplicados.FactorConversion = 1;
            else
                factoresConversionAplicados.FactorConversion = queryFactoresConversion.FactorConversion;

            factoresConversionAplicados.NombreUsuario = User.Identity.Name;

            factoresConversionAplicados_List.Add(factoresConversionAplicados); 
        }


        if (factoresConversionAplicados_List.Count != 12)
        {
            ErrMessage_Span.InnerHtml = "La tabla Definición de Meses para el Año Fiscal no está completa " +
                "para el año fiscal de la compañía. Esta tabla debe tener una definición para cada " +
                "uno de los 12 meses del año.<br />" + 
                "Por favor revise el contenido de la tabla mencionada y corrija esta situación.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }



        try
        {
            // intentamos agregar la lista a la tabla en la base de datos 

            dbContab.FactoresConversionAnoMes_Aplicados.InsertAllOnSubmit
                (factoresConversionAplicados_List); 
            dbContab.SubmitChanges();

        }
        catch (Exception ex)
        {
            dbContab = null;

            ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de " +
                "acceso a la base de datos. <br /> El mensaje específico de error es: " +
                ex.Message + "<br />";
            ErrMessage_Span.Style["display"] = "block";

            return; 
        }
        
        // TODO: aplicar los factores encontrados a los registros en la tabla tTempWebReport... 

        // ahora leemos la tabla con los registros de la consulta y aplicamos los factores de conversión
        // para cada mes fiscal  

        var consultaPresupuestoQuery = from cp in dbContab.tTempWebReport_PresupuestoConsultaAnuals
                                       where cp.NombreUsuario == User.Identity.Name
                                       select cp;

        foreach (var consultaPresupuesto in consultaPresupuestoQuery)
        {
            // nótese que, desde su creación, la lista de factores está 
            // ordenada por mes fiscal (1, 2, 3, ...)

            consultaPresupuesto.Mes01_Eje /= factoresConversionAplicados_List[0].FactorConversion;
            consultaPresupuesto.Mes02_Eje /= factoresConversionAplicados_List[1].FactorConversion;
            consultaPresupuesto.Mes03_Eje /= factoresConversionAplicados_List[2].FactorConversion;
            consultaPresupuesto.Mes04_Eje /= factoresConversionAplicados_List[3].FactorConversion;
            consultaPresupuesto.Mes05_Eje /= factoresConversionAplicados_List[4].FactorConversion;
            consultaPresupuesto.Mes06_Eje /= factoresConversionAplicados_List[5].FactorConversion;
            consultaPresupuesto.Mes07_Eje /= factoresConversionAplicados_List[6].FactorConversion;
            consultaPresupuesto.Mes08_Eje /= factoresConversionAplicados_List[7].FactorConversion;
            consultaPresupuesto.Mes09_Eje /= factoresConversionAplicados_List[8].FactorConversion;
            consultaPresupuesto.Mes10_Eje /= factoresConversionAplicados_List[9].FactorConversion;
            consultaPresupuesto.Mes11_Eje /= factoresConversionAplicados_List[10].FactorConversion;
            consultaPresupuesto.Mes12_Eje /= factoresConversionAplicados_List[11].FactorConversion;

            // el total ejecutado es la sumarización de todos los meses antes convertidos 

            consultaPresupuesto.TotalEjecutado =
                consultaPresupuesto.Mes01_Eje + consultaPresupuesto.Mes02_Eje +
                consultaPresupuesto.Mes03_Eje + consultaPresupuesto.Mes04_Eje +
                consultaPresupuesto.Mes05_Eje + consultaPresupuesto.Mes06_Eje +
                consultaPresupuesto.Mes07_Eje + consultaPresupuesto.Mes08_Eje +
                consultaPresupuesto.Mes09_Eje + consultaPresupuesto.Mes10_Eje +
                consultaPresupuesto.Mes11_Eje + consultaPresupuesto.Mes12_Eje;

            // para obtener el total presupuestado (estimado) convertido, leemos los montos estimados 
            // para cada mes en la tabla Presupuesto_Montos, para el registro específico; luego, 
            // convertimos cada monto estimado y sumarizamos 

            var presupuesto_MontosEstimadosConvertidos = 
                (from pm in dbContab.Presupuesto_Montos
                  where pm.CodigoPresupuesto == consultaPresupuesto.CodigoPresupuesto &&
                  pm.CiaContab == consultaPresupuesto.CiaContab &&
                  pm.Moneda == consultaPresupuesto.Moneda &&
                  pm.Ano == consultaPresupuesto.AnoFiscal
                  select 
                      pm.Mes01_Est / factoresConversionAplicados_List[0].FactorConversion +
                      pm.Mes02_Est / factoresConversionAplicados_List[1].FactorConversion +
                      pm.Mes03_Est / factoresConversionAplicados_List[2].FactorConversion +
                      pm.Mes04_Est / factoresConversionAplicados_List[3].FactorConversion +
                      pm.Mes05_Est / factoresConversionAplicados_List[4].FactorConversion +
                      pm.Mes06_Est / factoresConversionAplicados_List[5].FactorConversion +
                      pm.Mes07_Est / factoresConversionAplicados_List[6].FactorConversion +
                      pm.Mes08_Est / factoresConversionAplicados_List[7].FactorConversion +
                      pm.Mes09_Est / factoresConversionAplicados_List[8].FactorConversion +
                      pm.Mes10_Est / factoresConversionAplicados_List[9].FactorConversion +
                      pm.Mes11_Est / factoresConversionAplicados_List[10].FactorConversion + 
                      pm.Mes12_Est / factoresConversionAplicados_List[11].FactorConversion 
                  ).FirstOrDefault(); 

            // NOTA IMPORTANTE: el registro DEBE existir en Presupuesto_Montos, pues de allí se obtuvo 
            // el registro en tTempWebReport...; de otra forma, terminamos con un error  

            if (presupuesto_MontosEstimadosConvertidos == null)
            {
                ErrMessage_Span.InnerHtml = "Error inesperado: no se ha encontrado el registro para el " +
                    "código de presupuesto '" + consultaPresupuesto.CodigoPresupuesto + 
                    "' en la tabla Presupuesto_Montos. Por favor revise esta situación y corríjala " + 
                    "antes de ejecutar nuevamente este proceso."; 
                ErrMessage_Span.Style["display"] = "block";

                return; 
            }

            consultaPresupuesto.TotalPresupuestado = presupuesto_MontosEstimadosConvertidos; 
        }


        try
        {
            // persistimos los cambios hechos en tTempWebReport_ConsultaPresupuestoAnual

            dbContab.SubmitChanges();

            dbContab = null;
            PageDataBind();

        }
        catch (Exception ex)
        {
            dbContab = null;

            ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de " +
                "acceso a la base de datos. <br /> El mensaje específico de error es: " +
                ex.Message + "<br />";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        // para indicar al report que las cifras se han convertido; el report muestra un pequeño mensaje 
        // que indica esta situación ... 

        ControlPresupuesto_Reportes_HyperLink.NavigateUrl =
            "javascript:PopupWin('../../../../ReportViewer2.aspx?rpt=ptoconsanual&conv=1', 1000, 680)";

    }
}
