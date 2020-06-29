using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.Security;
using System.Threading;
using ContabSysNet_Web.ModelosDatos;
using System.Web.Script.Serialization;
using ContabSysNet_Web.Clases;
using System.IO;
using System.Web;
//using ContabSysNet_Web;

//using ContabSysNetWeb.Old_App_Code;

public partial class Contab_Presupuesto_Consultas_Mensual_ConsultaPresupuesto : System.Web.UI.Page
{
    public class PresupuestoMontos
    {
        public string CodigoPresupuesto { get; set; }
        public int CiaContab { get; set; }
        public int Moneda { get; set; }
        public short Ano { get; set; }
        public decimal? Mes01_Est { get; set; }
        public decimal? Mes01_Eje { get; set; }
        public decimal? Mes02_Est { get; set; }
        public decimal? Mes02_Eje { get; set; }
        public decimal? Mes03_Est { get; set; }
        public decimal? Mes03_Eje { get; set; }
        public decimal? Mes04_Est { get; set; }
        public decimal? Mes04_Eje { get; set; }
        public decimal? Mes05_Est { get; set; }
        public decimal? Mes05_Eje { get; set; }
        public decimal? Mes06_Est { get; set; }
        public decimal? Mes06_Eje { get; set; }
        public decimal? Mes07_Est { get; set; }
        public decimal? Mes07_Eje { get; set; }
        public decimal? Mes08_Est { get; set; }
        public decimal? Mes08_Eje { get; set; }
        public decimal? Mes09_Est { get; set; }
        public decimal? Mes09_Eje { get; set; }
        public decimal? Mes10_Est { get; set; }
        public decimal? Mes10_Eje { get; set; }
        public decimal? Mes11_Est { get; set; }
        public decimal? Mes11_Eje { get; set; }
        public decimal? Mes12_Est { get; set; }
        public decimal? Mes12_Eje { get; set; } 
    }

    private class WS_Result
    {
        public short Progress_Completed { get; set; }
        public short Progress_Percentage { get; set; }
        public int Progress_SelectedRecs { get; set; }
        public string Progress_ErrorMessage { get; set; } 
    }

    protected void Page_Init(object sender, EventArgs e)
    {
        // Register control with the data manager.
        //DynamicDataManager1.RegisterControl(PresupuestoCodigos_ListView);
        this.ConsultaPresupuesto_ListView.EnableDynamicData(typeof(tTempWebReport_PresupuestoConsultaMensual));
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        Master.Page.Title = "Control de presupuesto - Consulta del un mes";

        ControlPresupuesto_Reportes_HyperLink.NavigateUrl =
            "javascript:PopupWin('../../../../ReportViewer2.aspx?rpt=ptoconsmes&cantniveles=" +
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

            ErrMessage_Span.InnerHtml = "";
            ErrMessage_Span.Style["display"] = "none";
        }
        else
        {
            // TODO: por ahora, vamos a ejecutar el proceso en forma simple, no en un thread separado; existe un error en el 
            // cliente que hace que este código falle y no logramos determinar como corregir ésto; por ahora, decidimos 
            // ejecutar ésto de forma simple hasta que logremos determinar el error y corregir toda esta situación ... 

            // -------------------------------------------------------------------------
            // la página puede ser 'refrescada' por el popup; en ese caso, ejeucutamos  
            // una función que efectúa alguna funcionalidad y rebind la información 

            // -------------------------------------------------------------------------
            // la página puede ser 'refrescada' por el popup; en ese caso, ejeucutamos
            // una función que efectúa alguna funcionalidad y rebind la información

            if (ExecuteThread_HiddenField.Value == "1")
            {
                ExecuteThread_HiddenField.Value = "0";

                string jsonFileName = "Presupuesto_ConsultaMensual_" + User.Identity.Name + ".json";
                jsonFileName = HttpContext.Current.Server.MapPath(("~/Temp/" + jsonFileName));

                string filtroForma = Session["FiltroForma"] != null ? Session["FiltroForma"].ToString() : "";
                int? mesCalendario = null;
                if (Session["ConsultaPresupuesto_MesCalendario"] != null)
                    mesCalendario = Convert.ToInt32(Session["ConsultaPresupuesto_MesCalendario"].ToString()); 

                BuildReportRecords(mesCalendario, filtroForma, jsonFileName);
                
                // --------------------------------------------------------------------------------------
                //para mostrar un título que describa la consulta, leemos el año (fiscal) y la 
                // descripción del mes en tTempWebReport... 

                dbContabDataContext dbContab = new dbContabDataContext();

                var MySelectedMesAno = (from ma in dbContab.tTempWebReport_PresupuestoConsultaMensuals
                                        where ma.NombreUsuario == User.Identity.Name
                                        select new { ma.NombreMes, ma.AnoFiscal }).FirstOrDefault();

                if (MySelectedMesAno != null)
                    // si MySelectedMesAno es nulls es probable que no se seleccionaron registros para la consulta ... 
                    TituloConsulta_H2.InnerHtml = "Consulta de presupuesto para el mes " + MySelectedMesAno.NombreMes + " - " + MySelectedMesAno.AnoFiscal.ToString();
                else
                {
                    // si se encontró algún error en el proceso, ErrMessage_Span contiene ya algún mensaje; nótese que siempre al comenzar este especio se pone 
                    // en un empty string 

                    // muchas veces se encontró algún error y la tabla que contiene los registros (Temp...) está vacía. La idea es que en este punto 
                    // no se determine que el filtro seleccionó cero records; más bien, como ocurrió algún error, esta tabla puede estar vacía 
                    if (ErrMessage_Span.InnerHtml == "")
                    {
                        ErrMessage_Span.InnerHtml = "No existen registros que cumplan el criterio de selección " +
                        "(filtro) que Ud. ha indicado. <br /> Para regresar registros, Ud. puede intentar " +
                        "un filtro diferente al que ha indicado.";
                    }

                    ErrMessage_Span.Style["display"] = "block";
                }

                dbContab = null;
                PageDataBind();
            }

            // -------------------------------------------------------------------------

            //if (ExecuteThread_HiddenField.Value == "1")
            //{
            //    // cuando este html item es 1, ejecutamos el thread que construye la selección y la graba 
            //    // a una tabla en la base de datos  

            //    ExecuteThread_HiddenField.Value = "0";

            //    // -------------------------------------------------------------------------------
            //    // nótese como ejecutamos el sub que sigue en un thread diferente 

            //    // antes eliminamos el archivo si existe ... 

            //    string jsonFileName = "Presupuesto_ConsultaMensual_" + User.Identity.Name + ".json";
            //    jsonFileName = HttpContext.Current.Server.MapPath(("~/Temp/" + jsonFileName));
                
            //    try
            //    {
            //        File.Delete(jsonFileName);
            //    }
            //    catch (Exception ex)
            //    {
            //        string errorMessage = ex.Message;
            //        if (ex.InnerException != null)
            //            errorMessage += "<br />" + ex.InnerException.Message;

            //        ErrMessage_Span.InnerHtml = errorMessage;
            //        ErrMessage_Span.Style["display"] = "block"; 

            //        return;
            //    }

            //    string filtroForma = Session["FiltroForma"] != null ? Session["FiltroForma"].ToString() : "";
            //    int? mesCalendario = null; 
            //    if (Session["ConsultaPresupuesto_MesCalendario"] != null) 
            //        mesCalendario = Convert.ToInt32(Session["ConsultaPresupuesto_MesCalendario"].ToString()); 

            //    Thread MyThread = new Thread(() => BuildReportRecords(mesCalendario, filtroForma, jsonFileName));
            //    MyThread.Priority = ThreadPriority.Lowest;
            //    MyThread.Start();

            //    // ejecutamos javascript para que lea la variable session y muestre el progreso 

            //    System.Text.StringBuilder sb = new System.Text.StringBuilder();
            //    sb.Append("<script language='javascript'>");
            //    sb.Append("showprogress();");
            //    sb.Append("</script>");

            //    ClientScript.RegisterStartupScript(this.GetType(), "onLoad", sb.ToString());
            //}

            //else
            //{
            //    if (RebindPage_HiddenField.Value == "1")
            //    {
            //        // cuando este html item es 1 terminó el thread que construye la selección. Entonces 
            //        // se hace un refresh de la página y ejecutamos aquí el procedimiento que hace el 
            //        // databind a los controles para que muestren los datos al usuario 

            //        // nótese como leemos la cantidad de registros seleccionados del archivo json 
            //        // allí debe estar esta cantidad, cuando el proceso se ejecuta en forma exitosa ... 

            //        string jsonFileName = "Presupuesto_ConsultaMensual_" + User.Identity.Name + ".json";
            //        jsonFileName = HttpContext.Current.Server.MapPath(("~/Temp/" + jsonFileName));

            //        ReadStringFromFile readStringFromFile = new ReadStringFromFile(jsonFileName);

            //        string jsonFileContent;
            //        string errorMessage;
            //        WS_Result MyWS_Result = new WS_Result();

            //        if (!readStringFromFile.ReadFromDisk(out jsonFileContent, out errorMessage))
            //        {
            //            ErrMessage_Span.InnerHtml = errorMessage;
            //            ErrMessage_Span.Style["display"] = "block"; 
            //        }
            //        else
            //        {
            //            JavaScriptSerializer javaScriptSerializer = new JavaScriptSerializer(); 
            //            MyWS_Result = javaScriptSerializer.Deserialize<WS_Result>(jsonFileContent);

            //            SelectedRecs_HiddenField.Value = MyWS_Result.Progress_SelectedRecs.ToString();  ;

            //            // para mostrar un título que describa la consulta, leemos el año (fiscal) y la 
            //            // descripción del mes en tTempWebReport... 

            //            dbContabDataContext dbContab = new dbContabDataContext();

            //            var MySelectedMesAno = (from ma in dbContab.tTempWebReport_PresupuestoConsultaMensuals
            //                                    where ma.NombreUsuario == User.Identity.Name
            //                                    select new { ma.NombreMes, ma.AnoFiscal }).FirstOrDefault();

            //            if (MySelectedMesAno != null)
            //                // si MySelectedMesAno es nulls es probable que no se seleccionaron registros para la consulta ... 
            //                TituloConsulta_H2.InnerHtml = "Consulta de presupuesto para el mes " + MySelectedMesAno.NombreMes + " - " + 
            //                    MySelectedMesAno.AnoFiscal.ToString();
            //            else
            //            {
            //                ErrMessage_Span.InnerHtml = "No existen registros que cumplan el criterio de selección " +
            //                    "(filtro) que Ud. ha indicado. <br /> Para regresar registros, Ud. puede intentar " +
            //                    "un filtro diferente al que ha indicado.";
            //                ErrMessage_Span.Style["display"] = "block";
            //            }

            //            dbContab = null; 
            //        }


            //        RebindPage_HiddenField.Value = "0";
            //        PageDataBind();

            //        System.Text.StringBuilder sb = new System.Text.StringBuilder();
            //        sb.Append("<script language='javascript'>");
            //        sb.Append("showprogress_displayselectedrecs();");
            //        sb.Append("</script>");

            //        ClientScript.RegisterStartupScript(this.GetType(), "onLoad", sb.ToString());
            //    }
            //}
        }

    }

    private void BuildReportRecords(int? mesCalendario, string filtroForma, string jsonFileName)
    {
        // construímos los registros que se usarán para mostrar la consulta al usuario 
        // jsonFileName es el archivo al cual esta función escribe el progreso, mensajes de error, etc. 
        // desde javascript, usando un ws, este archivo es leído para reportar el progreso de este proceso ... 

        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        // este es el objeto que vamos a serialiar (json) y grabar al disco ... 
        // el ws leerá este file para obtener los valores 

        ContabSysNet_Web.WS_Result wsResult;
        JavaScriptSerializer javaScriptSerializer = new JavaScriptSerializer();     // para serializar (json) el objeto con los resultados para el web service
        string serializedJsonObject;                                                // para serializar el objeto en este string 

        WriteStringToFile writeStringToFile = new WriteStringToFile(jsonFileName);
        string errorMessage; 
            
        if (string.IsNullOrEmpty(filtroForma))
        {
            errorMessage = "Aparentemente, Ud. no ha indicado un filtro aún.<br />Por favor indique y aplique un filtro antes de " + 
                "intentar mostrar el resultado de la consulta.";

            // mientras esta función se ejecuta en forma simple; ie: no en un thread separado (para poder mostrar el progreso en el cliente) 
            ErrMessage_Span.InnerHtml = errorMessage;
            ErrMessage_Span.Style["display"] = "block";

            wsResult = new ContabSysNet_Web.WS_Result() {
                Progress_SelectedRecs = 0,
                Progress_Percentage = 0,
                Progress_Completed = 1,                     // para que el web page detenga el proceso (deje de ejecutar el ws) ... 
                Progress_ErrorMessage = errorMessage
            };

            errorMessage = ""; 

            serializedJsonObject = javaScriptSerializer.Serialize(wsResult);
            writeStringToFile.WriteToDisk(serializedJsonObject, out errorMessage);

            if (!String.IsNullOrEmpty(errorMessage))
            {
                string errorMessage2 = ErrMessage_Span.InnerHtml + "<br />" + errorMessage; 
                ErrMessage_Span.InnerHtml = errorMessage2;
            }

            return; 
        }

        if (mesCalendario == null)
        {
            errorMessage = "Aparentemente, Ud. no ha indicado un filtro aún.<br />Por favor indique y aplique un filtro antes de intentar " + 
                "mostrar el resultado de la consulta.";

            wsResult = new ContabSysNet_Web.WS_Result()
            {
                Progress_SelectedRecs = 0,
                Progress_Percentage = 0,
                Progress_Completed = 1,                     // para que el web page detenga el proceso (deje de ejecutar el ws) ... 
                Progress_ErrorMessage = errorMessage
            };

            serializedJsonObject = javaScriptSerializer.Serialize(wsResult);
            writeStringToFile.WriteToDisk(serializedJsonObject, out errorMessage);

            // mientras esta función se ejecuta en forma simple; ie: no en un thread separado (para poder mostrar el progreso en el cliente) 
            ErrMessage_Span.InnerHtml = errorMessage;
            ErrMessage_Span.Style["display"] = "block";

            return; 
        }

        // --------------------------------------------------------------------------------------------
        // eliminamos el contenido de la tabla temporal 
        dbContabDataContext dbContab = new dbContabDataContext(); 

        try
            {
                dbContab.ExecuteCommand("Delete From tTempWebReport_PresupuestoConsultaMensual Where NombreUsuario = {0}", User.Identity.Name); 
            } 
        catch (Exception ex)
            {
                dbContab = null; 

                errorMessage = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " + 
                    "El mensaje específico de error es: " + ex.Message + "<br /><br />";

                // mientras esta función se ejecuta en forma simple; ie: no en un thread separado (para poder mostrar el progreso en el cliente) 
                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                wsResult = new ContabSysNet_Web.WS_Result()
                {
                    Progress_SelectedRecs = 0,
                    Progress_Percentage = 0,
                    Progress_Completed = 1,                     // para que el web page detenga el proceso (deje de ejecutar el ws) ... 
                    Progress_ErrorMessage = errorMessage
                };

                errorMessage = "";

                serializedJsonObject = javaScriptSerializer.Serialize(wsResult);
                writeStringToFile.WriteToDisk(serializedJsonObject, out errorMessage);

                if (!String.IsNullOrEmpty(errorMessage))
                {
                    string errorMessage2 = ErrMessage_Span.InnerHtml + "<br />" + errorMessage;
                    ErrMessage_Span.InnerHtml = errorMessage2;
                }

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
            "Where " + filtroForma + " Order By Presupuesto_Montos.CiaContab").ToList();

        if (PresupuestoMontos_List.Count() == 0) 
        {
            dbContab = null;

            errorMessage = "No existen registros que cumplan el criterio de selección (filtro) que Ud. ha indicado. <br /> " + 
                "Para regresar registros, Ud. puede intentar un filtro diferente al que ha indicado.";

            // mientras esta función se ejecuta en forma simple; ie: no en un thread separado (para poder mostrar el progreso en el cliente) 
            ErrMessage_Span.InnerHtml = errorMessage;
            ErrMessage_Span.Style["display"] = "block";

            wsResult = new ContabSysNet_Web.WS_Result()
            {
                Progress_SelectedRecs = 0,
                Progress_Percentage = 0,
                Progress_Completed = 1,                     // para que el web page detenga el proceso (deje de ejecutar el ws) ... 
                Progress_ErrorMessage = errorMessage
            };

            errorMessage = "";

            serializedJsonObject = javaScriptSerializer.Serialize(wsResult);
            writeStringToFile.WriteToDisk(serializedJsonObject, out errorMessage);

            if (!String.IsNullOrEmpty(errorMessage))
            {
                string errorMessage2 = ErrMessage_Span.InnerHtml + "<br />" + errorMessage;
                ErrMessage_Span.InnerHtml = errorMessage2;
            }

            return;
        }

        int nCantidadRegistros = PresupuestoMontos_List.Count(); 
        int nRegistroActual = 0;
        short nProgreesPercentaje = 0;

        tTempWebReport_PresupuestoConsultaMensual MyTempWebReportPresupuestoConsultaMensual;
        List<tTempWebReport_PresupuestoConsultaMensual> MyTempWebRepotPresupuestoConsultaMensual_List = new
        List<tTempWebReport_PresupuestoConsultaMensual>();

        // para leer el registro en la tabla MesesAnoFiscal para cada compañía Contab seleccionada 
        MesesDelAnoFiscal MyMesesAnoFiscal;
        MyMesesAnoFiscal = new MesesDelAnoFiscal(); 

        int nCiaContab_Anterior = -9999; 

        foreach (PresupuestoMontos MyPresupuestoMontos in PresupuestoMontos_List)
        {
            // TODO: NOTA IMPORTANTE: este loop debe ser efectuado POR CADA MES (CALENDARIO) 
            // que haya indicado el usuario en la lista en el filtro ... 

            if (MyPresupuestoMontos.CiaContab != nCiaContab_Anterior)
            {
                // para cada compañía seleccionada (puede ser más de una) determinamos el mes fiscal que 
                // corresponde al mes calendario indicado en el ListBox 

                MyMesesAnoFiscal = (from meses in dbContab.MesesDelAnoFiscals
                                  where meses.Cia == MyPresupuestoMontos.CiaContab
                                  && meses.Mes == mesCalendario.Value
                                  select meses).FirstOrDefault();

                if (MyMesesAnoFiscal == null)
                {
                    dbContab = null;

                    errorMessage = "Aparentemente, no existe un registro en la tabla <i>Meses del Año Fiscal<i/> " + 
                        "para alguna de las compañías seleccionada y el mes que se desea consultar.<br /><br />" + 
                        "Por favor revise esta situación. La tabla tabla <i>Meses del Año Fiscal<i/> " + 
                        "debe contener un registro cada una de las compañías registradas en <i>Contab<i/>.";

                    // mientras esta función se ejecuta en forma simple; ie: no en un thread separado (para poder mostrar el progreso en el cliente) 
                    ErrMessage_Span.InnerHtml = errorMessage;
                    ErrMessage_Span.Style["display"] = "block";

                    wsResult = new ContabSysNet_Web.WS_Result()
                    {
                        Progress_SelectedRecs = 0,
                        Progress_Percentage = 0,
                        Progress_Completed = 1,                     // para que el web page detenga el proceso (deje de ejecutar el ws) ... 
                        Progress_ErrorMessage = errorMessage
                    };

                    errorMessage = "";

                    serializedJsonObject = javaScriptSerializer.Serialize(wsResult);
                    writeStringToFile.WriteToDisk(serializedJsonObject, out errorMessage);

                    if (!String.IsNullOrEmpty(errorMessage))
                    {
                        string errorMessage2 = ErrMessage_Span.InnerHtml + "<br />" + errorMessage;
                        ErrMessage_Span.InnerHtml = errorMessage2;
                    }

                    return;
                }

                nCiaContab_Anterior = MyPresupuestoMontos.CiaContab; 
            }

            try
            {
                // preparamos el registro que vamos a agregar a tTempWebReport... 

                MyTempWebReportPresupuestoConsultaMensual= new tTempWebReport_PresupuestoConsultaMensual();

                MyTempWebReportPresupuestoConsultaMensual.CiaContab = MyPresupuestoMontos.CiaContab;
                MyTempWebReportPresupuestoConsultaMensual.Moneda = MyPresupuestoMontos.Moneda;
                MyTempWebReportPresupuestoConsultaMensual.AnoFiscal = MyPresupuestoMontos.Ano;
                MyTempWebReportPresupuestoConsultaMensual.MesFiscal = MyMesesAnoFiscal.MesFiscal; 
                MyTempWebReportPresupuestoConsultaMensual.MesCalendario = MyMesesAnoFiscal.Mes;
                MyTempWebReportPresupuestoConsultaMensual.NombreMes = MyMesesAnoFiscal.NombreMes;
                MyTempWebReportPresupuestoConsultaMensual.CodigoPresupuesto = MyPresupuestoMontos.CodigoPresupuesto;

                // el factor de conversión es inicialmente 1, para que no afecte las cifras determinadas
                // el usuario lo puede cambiar luego para convertir las cifras de la consulta 

                MyTempWebReportPresupuestoConsultaMensual.FactorConversion = 1; 

                switch (MyMesesAnoFiscal.MesFiscal)
                {
                    case 1:

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimado = MyPresupuestoMontos.Mes01_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutado = MyPresupuestoMontos.Mes01_Eje.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimadoAcum = MyPresupuestoMontos.Mes01_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutadoAcum = MyPresupuestoMontos.Mes01_Eje.Value;

                        break;
                    case 2:

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimado = MyPresupuestoMontos.Mes02_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutado = MyPresupuestoMontos.Mes02_Eje.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimadoAcum =
                            MyPresupuestoMontos.Mes01_Est.Value + MyPresupuestoMontos.Mes02_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutadoAcum =
                            MyPresupuestoMontos.Mes01_Eje.Value + MyPresupuestoMontos.Mes02_Eje.Value;

                        break;
                    case 3:

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimado = MyPresupuestoMontos.Mes03_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutado = MyPresupuestoMontos.Mes03_Eje.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimadoAcum =
                            MyPresupuestoMontos.Mes01_Est.Value + MyPresupuestoMontos.Mes02_Est.Value + 
                            MyPresupuestoMontos.Mes03_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutadoAcum =
                            MyPresupuestoMontos.Mes01_Eje.Value + MyPresupuestoMontos.Mes02_Eje.Value + 
                            MyPresupuestoMontos.Mes03_Eje.Value;

                        break;
                    case 4:

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimado = MyPresupuestoMontos.Mes04_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutado = MyPresupuestoMontos.Mes04_Eje.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimadoAcum =
                            MyPresupuestoMontos.Mes01_Est.Value + MyPresupuestoMontos.Mes02_Est.Value +
                            MyPresupuestoMontos.Mes03_Est.Value + MyPresupuestoMontos.Mes04_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutadoAcum =
                            MyPresupuestoMontos.Mes01_Eje.Value + MyPresupuestoMontos.Mes02_Eje.Value +
                            MyPresupuestoMontos.Mes03_Eje.Value + MyPresupuestoMontos.Mes04_Eje.Value;

                        break;
                    case 5:

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimado = MyPresupuestoMontos.Mes05_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutado = MyPresupuestoMontos.Mes05_Eje.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimadoAcum =
                             MyPresupuestoMontos.Mes01_Est.Value + MyPresupuestoMontos.Mes02_Est.Value +
                             MyPresupuestoMontos.Mes03_Est.Value + MyPresupuestoMontos.Mes04_Est.Value +
                             MyPresupuestoMontos.Mes05_Est.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutadoAcum =
                            MyPresupuestoMontos.Mes01_Eje.Value + MyPresupuestoMontos.Mes02_Eje.Value +
                            MyPresupuestoMontos.Mes03_Eje.Value + MyPresupuestoMontos.Mes04_Eje.Value +
                            MyPresupuestoMontos.Mes05_Eje.Value;  

                        break;
                    case 6:

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimado = MyPresupuestoMontos.Mes06_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutado = MyPresupuestoMontos.Mes06_Eje.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimadoAcum =
                             MyPresupuestoMontos.Mes01_Est.Value + MyPresupuestoMontos.Mes02_Est.Value +
                             MyPresupuestoMontos.Mes03_Est.Value + MyPresupuestoMontos.Mes04_Est.Value +
                             MyPresupuestoMontos.Mes05_Est.Value + MyPresupuestoMontos.Mes06_Est.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutadoAcum =
                            MyPresupuestoMontos.Mes01_Eje.Value + MyPresupuestoMontos.Mes02_Eje.Value +
                            MyPresupuestoMontos.Mes03_Eje.Value + MyPresupuestoMontos.Mes04_Eje.Value +
                            MyPresupuestoMontos.Mes05_Eje.Value + MyPresupuestoMontos.Mes06_Eje.Value;  

                        break;
                    case 7:

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimado = MyPresupuestoMontos.Mes07_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutado = MyPresupuestoMontos.Mes07_Eje.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimadoAcum =
                             MyPresupuestoMontos.Mes01_Est.Value + MyPresupuestoMontos.Mes02_Est.Value +
                             MyPresupuestoMontos.Mes03_Est.Value + MyPresupuestoMontos.Mes04_Est.Value +
                             MyPresupuestoMontos.Mes05_Est.Value + MyPresupuestoMontos.Mes06_Est.Value +
                             MyPresupuestoMontos.Mes07_Est.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutadoAcum =
                            MyPresupuestoMontos.Mes01_Eje.Value + MyPresupuestoMontos.Mes02_Eje.Value +
                            MyPresupuestoMontos.Mes03_Eje.Value + MyPresupuestoMontos.Mes04_Eje.Value +
                            MyPresupuestoMontos.Mes05_Eje.Value + MyPresupuestoMontos.Mes06_Eje.Value +
                            MyPresupuestoMontos.Mes07_Eje.Value;  

                        break;
                    case 8:

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimado = MyPresupuestoMontos.Mes08_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutado = MyPresupuestoMontos.Mes08_Eje.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimadoAcum =
                             MyPresupuestoMontos.Mes01_Est.Value + MyPresupuestoMontos.Mes02_Est.Value +
                             MyPresupuestoMontos.Mes03_Est.Value + MyPresupuestoMontos.Mes04_Est.Value +
                             MyPresupuestoMontos.Mes05_Est.Value + MyPresupuestoMontos.Mes06_Est.Value +
                             MyPresupuestoMontos.Mes07_Est.Value + MyPresupuestoMontos.Mes08_Est.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutadoAcum =
                            MyPresupuestoMontos.Mes01_Eje.Value + MyPresupuestoMontos.Mes02_Eje.Value +
                            MyPresupuestoMontos.Mes03_Eje.Value + MyPresupuestoMontos.Mes04_Eje.Value +
                            MyPresupuestoMontos.Mes05_Eje.Value + MyPresupuestoMontos.Mes06_Eje.Value +
                            MyPresupuestoMontos.Mes07_Eje.Value + MyPresupuestoMontos.Mes08_Eje.Value;  

                        break;
                    case 9:

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimado = MyPresupuestoMontos.Mes09_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutado = MyPresupuestoMontos.Mes09_Eje.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimadoAcum =
                             MyPresupuestoMontos.Mes01_Est.Value + MyPresupuestoMontos.Mes02_Est.Value +
                             MyPresupuestoMontos.Mes03_Est.Value + MyPresupuestoMontos.Mes04_Est.Value +
                             MyPresupuestoMontos.Mes05_Est.Value + MyPresupuestoMontos.Mes06_Est.Value +
                             MyPresupuestoMontos.Mes07_Est.Value + MyPresupuestoMontos.Mes08_Est.Value +
                             MyPresupuestoMontos.Mes09_Est.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutadoAcum =
                            MyPresupuestoMontos.Mes01_Eje.Value + MyPresupuestoMontos.Mes02_Eje.Value +
                            MyPresupuestoMontos.Mes03_Eje.Value + MyPresupuestoMontos.Mes04_Eje.Value +
                            MyPresupuestoMontos.Mes05_Eje.Value + MyPresupuestoMontos.Mes06_Eje.Value +
                            MyPresupuestoMontos.Mes07_Eje.Value + MyPresupuestoMontos.Mes08_Eje.Value +
                            MyPresupuestoMontos.Mes09_Eje.Value;  

                        break;
                    case 10:

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimado = MyPresupuestoMontos.Mes10_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutado = MyPresupuestoMontos.Mes10_Eje.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimadoAcum =
                            MyPresupuestoMontos.Mes01_Est.Value + MyPresupuestoMontos.Mes02_Est.Value +
                            MyPresupuestoMontos.Mes03_Est.Value + MyPresupuestoMontos.Mes04_Est.Value +
                            MyPresupuestoMontos.Mes05_Est.Value + MyPresupuestoMontos.Mes06_Est.Value +
                            MyPresupuestoMontos.Mes07_Est.Value + MyPresupuestoMontos.Mes08_Est.Value +
                            MyPresupuestoMontos.Mes09_Est.Value + MyPresupuestoMontos.Mes10_Est.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutadoAcum =
                            MyPresupuestoMontos.Mes01_Eje.Value + MyPresupuestoMontos.Mes02_Eje.Value +
                            MyPresupuestoMontos.Mes03_Eje.Value + MyPresupuestoMontos.Mes04_Eje.Value +
                            MyPresupuestoMontos.Mes05_Eje.Value + MyPresupuestoMontos.Mes06_Eje.Value +
                            MyPresupuestoMontos.Mes07_Eje.Value + MyPresupuestoMontos.Mes08_Eje.Value +
                            MyPresupuestoMontos.Mes09_Eje.Value + MyPresupuestoMontos.Mes10_Eje.Value;  

                        break;
                    case 11:

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimado = MyPresupuestoMontos.Mes11_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutado = MyPresupuestoMontos.Mes11_Eje.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimadoAcum =
                            MyPresupuestoMontos.Mes01_Est.Value + MyPresupuestoMontos.Mes02_Est.Value +
                            MyPresupuestoMontos.Mes03_Est.Value + MyPresupuestoMontos.Mes04_Est.Value +
                            MyPresupuestoMontos.Mes05_Est.Value + MyPresupuestoMontos.Mes06_Est.Value +
                            MyPresupuestoMontos.Mes07_Est.Value + MyPresupuestoMontos.Mes08_Est.Value +
                            MyPresupuestoMontos.Mes09_Est.Value + MyPresupuestoMontos.Mes10_Est.Value +
                            MyPresupuestoMontos.Mes11_Est.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutadoAcum =
                            MyPresupuestoMontos.Mes01_Eje.Value + MyPresupuestoMontos.Mes02_Eje.Value +
                            MyPresupuestoMontos.Mes03_Eje.Value + MyPresupuestoMontos.Mes04_Eje.Value +
                            MyPresupuestoMontos.Mes05_Eje.Value + MyPresupuestoMontos.Mes06_Eje.Value +
                            MyPresupuestoMontos.Mes07_Eje.Value + MyPresupuestoMontos.Mes08_Eje.Value +
                            MyPresupuestoMontos.Mes09_Eje.Value + MyPresupuestoMontos.Mes10_Eje.Value +
                            MyPresupuestoMontos.Mes11_Eje.Value; 


                        break;
                    case 12:

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimado = MyPresupuestoMontos.Mes12_Est.Value;
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutado = MyPresupuestoMontos.Mes12_Eje.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimadoAcum =
                            MyPresupuestoMontos.Mes01_Est.Value + MyPresupuestoMontos.Mes02_Est.Value +
                            MyPresupuestoMontos.Mes03_Est.Value + MyPresupuestoMontos.Mes04_Est.Value + 
                            MyPresupuestoMontos.Mes05_Est.Value + MyPresupuestoMontos.Mes06_Est.Value +
                            MyPresupuestoMontos.Mes07_Est.Value + MyPresupuestoMontos.Mes08_Est.Value + 
                            MyPresupuestoMontos.Mes09_Est.Value + MyPresupuestoMontos.Mes10_Est.Value +
                            MyPresupuestoMontos.Mes11_Est.Value + MyPresupuestoMontos.Mes12_Est.Value;

                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutadoAcum =
                            MyPresupuestoMontos.Mes01_Eje.Value + MyPresupuestoMontos.Mes02_Eje.Value +
                            MyPresupuestoMontos.Mes03_Eje.Value + MyPresupuestoMontos.Mes04_Eje.Value +
                            MyPresupuestoMontos.Mes05_Eje.Value + MyPresupuestoMontos.Mes06_Eje.Value +
                            MyPresupuestoMontos.Mes07_Eje.Value + MyPresupuestoMontos.Mes08_Eje.Value +
                            MyPresupuestoMontos.Mes09_Eje.Value + MyPresupuestoMontos.Mes10_Eje.Value +
                            MyPresupuestoMontos.Mes11_Eje.Value + MyPresupuestoMontos.Mes12_Eje.Value; 

                        break; 
                }

                // determinamos los porcentajes de variación, mensual y acumulado 

                if (MyTempWebReportPresupuestoConsultaMensual.MontoEstimado != 0)
                {
                    decimal diferencia =
                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimado -
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutado;

                    MyTempWebReportPresupuestoConsultaMensual.Variacion = 
                        (float)(diferencia * 100 / 
                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimado);
                }
                else
                    MyTempWebReportPresupuestoConsultaMensual.Variacion = 0;

                if (MyTempWebReportPresupuestoConsultaMensual.MontoEstimadoAcum != 0)
                {
                    decimal diferencia =
                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimadoAcum -
                        MyTempWebReportPresupuestoConsultaMensual.MontoEjecutadoAcum;

                    MyTempWebReportPresupuestoConsultaMensual.VariacionAcum =
                        (float)(diferencia * 100 /
                        MyTempWebReportPresupuestoConsultaMensual.MontoEstimadoAcum);
                }
                else
                    MyTempWebReportPresupuestoConsultaMensual.VariacionAcum = 0; 

                MyTempWebReportPresupuestoConsultaMensual.NombreUsuario = User.Identity.Name; 

                // -------------------------------------------------------------------------------
                // determinamos los niveles previos para cada cuenta de presupuesto y los grabamos 
                // a la tabla (ej: niveles previos para la cuenta 3-01-001: 3-01 y 3)

                string codigoPresupuesto = MyTempWebReportPresupuestoConsultaMensual.CodigoPresupuesto; 

                short cantNivelesPrevios = (short)CountStringOccurrences(codigoPresupuesto, "-");

                // los códigos deben tener al menos un codigo de agrupación (hasta 6) 

                if (cantNivelesPrevios == 0)
                {
                    errorMessage = "El código de presupuesto : " + MyTempWebReportPresupuestoConsultaMensual.CodigoPresupuesto +
                        " no tiene un nivel (previo) que lo agrupe; los códigos de presupuesto deben tener al menos un nivel de agrupación.";

                    // mientras esta función se ejecuta en forma simple; ie: no en un thread separado (para poder mostrar el progreso en el cliente) 
                    ErrMessage_Span.InnerHtml = errorMessage;
                    ErrMessage_Span.Style["display"] = "block";

                    wsResult = new ContabSysNet_Web.WS_Result()
                    {
                        Progress_SelectedRecs = 0,
                        Progress_Percentage = 0,
                        Progress_Completed = 1,                     // para que el web page detenga el proceso (deje de ejecutar el ws) ... 
                        Progress_ErrorMessage = errorMessage
                    };

                    errorMessage = "";

                    serializedJsonObject = javaScriptSerializer.Serialize(wsResult);
                    writeStringToFile.WriteToDisk(serializedJsonObject, out errorMessage);

                    if (!String.IsNullOrEmpty(errorMessage))
                    {
                        string errorMessage2 = ErrMessage_Span.InnerHtml + "<br />" + errorMessage;
                        ErrMessage_Span.InnerHtml = errorMessage2;
                    }

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
                            MyTempWebReportPresupuestoConsultaMensual.Codigo1erNivel = nivelPrevio;
                            break;
                        case 2:
                            MyTempWebReportPresupuestoConsultaMensual.Codigo2doNivel = nivelPrevio;
                            break;
                        case 3:
                            MyTempWebReportPresupuestoConsultaMensual.Codigo3erNivel = nivelPrevio;
                            break;
                        case 4:
                            MyTempWebReportPresupuestoConsultaMensual.Codigo4toNivel = nivelPrevio;
                            break;
                        case 5:
                            MyTempWebReportPresupuestoConsultaMensual.Codigo5toNivel = nivelPrevio;
                            break;
                        case 6:
                            MyTempWebReportPresupuestoConsultaMensual.Codigo6toNivel = nivelPrevio;
                            break; 
                    }
                }


                // -------------------------------------------------------------------------------
                // agregamos el registro a la lista 
                MyTempWebRepotPresupuestoConsultaMensual_List.Add(MyTempWebReportPresupuestoConsultaMensual); 

                // -------------------------------------------------------------------------------
                // para actualizar las variables que se usan para mostrar el meter al usuario 
                nRegistroActual += 1;
                nProgreesPercentaje = Convert.ToInt16(nRegistroActual * 100 / nCantidadRegistros);

                // ----------

                wsResult = new ContabSysNet_Web.WS_Result()
                {
                    Progress_SelectedRecs = 0,
                    Progress_Percentage = nProgreesPercentaje,
                    Progress_Completed = 0,                   
                    Progress_ErrorMessage = ""
                };

                serializedJsonObject = javaScriptSerializer.Serialize(wsResult);
                writeStringToFile.WriteToDisk(serializedJsonObject, out errorMessage); 
                // -------------------------------------------------------------------------------
            }
            catch (Exception ex)
            {
                errorMessage = ex.Message;
                if (ex.InnerException != null)
                    errorMessage += "<br />" + ex.InnerException.Message;

                errorMessage = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " +
                    "El mensaje específico de error es: " + ex.Message + "<br />";

                // mientras esta función se ejecuta en forma simple; ie: no en un thread separado (para poder mostrar el progreso en el cliente) 
                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                wsResult = new ContabSysNet_Web.WS_Result()
                {
                    Progress_SelectedRecs = 0,
                    Progress_Percentage = 0,
                    Progress_Completed = 1,                     // para que el web page detenga el proceso (deje de ejecutar el ws) ... 
                    Progress_ErrorMessage = errorMessage
                };

                errorMessage = "";

                serializedJsonObject = javaScriptSerializer.Serialize(wsResult);
                writeStringToFile.WriteToDisk(serializedJsonObject, out errorMessage);

                if (!String.IsNullOrEmpty(errorMessage))
                {
                    string errorMessage2 = ErrMessage_Span.InnerHtml + "<br />" + errorMessage;
                    ErrMessage_Span.InnerHtml = errorMessage2;
                }

                return;
            }
        }

        try
        {
            // agregamos la lista a la tabla en el db 
            dbContab.tTempWebReport_PresupuestoConsultaMensuals.InsertAllOnSubmit(MyTempWebRepotPresupuestoConsultaMensual_List); 
            dbContab.SubmitChanges(); 

            // finalmente, eliminamos de la tabla los recgistros cuya cuenta de presupuesto haya sido suspendida en la maestra 

            string sqlStatement = "Delete From temp from tTempWebReport_PresupuestoConsultaMensual temp Inner Join Presupuesto_Codigos p " + 
                "on temp.CodigoPresupuesto = p.Codigo And temp.CiaContab = p.CiaContab " + 
                "Where p.SuspendidoFlag = 1 And temp.NombreUsuario = {0} ";

            dbContab.ExecuteCommand(sqlStatement, User.Identity.Name); 
        }
        catch (Exception ex)
        {
            dbContab = null;

            errorMessage = ex.Message;
            if (ex.InnerException != null)
                errorMessage += "<br />" + ex.InnerException.Message; 

            errorMessage = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " + 
                "El mensaje específico de error es: " + ex.Message + "<br />";

            // mientras esta función se ejecuta en forma simple; ie: no en un thread separado (para poder mostrar el progreso en el cliente) 
            ErrMessage_Span.InnerHtml = errorMessage;
            ErrMessage_Span.Style["display"] = "block";

            wsResult = new ContabSysNet_Web.WS_Result()
            {
                Progress_SelectedRecs = 0,
                Progress_Percentage = 0,
                Progress_Completed = 1,                     // para que el web page detenga el proceso (deje de ejecutar el ws) ... 
                Progress_ErrorMessage = errorMessage
            };

            errorMessage = "";

            serializedJsonObject = javaScriptSerializer.Serialize(wsResult);
            writeStringToFile.WriteToDisk(serializedJsonObject, out errorMessage);

            if (!String.IsNullOrEmpty(errorMessage))
            {
                string errorMessage2 = ErrMessage_Span.InnerHtml + "<br />" + errorMessage;
                ErrMessage_Span.InnerHtml = errorMessage2;
            }

            return;
        }

        // -----------------------------------------------------------------------------------------------------------------------

        dbContab = null; 

        // -----------------------------------------------------
        // por último, inicializamos las variables que se usan para mostrar el progreso de la tarea 

        wsResult = new ContabSysNet_Web.WS_Result()
        {
            Progress_SelectedRecs = nCantidadRegistros,
            Progress_Percentage = 0,
            Progress_Completed = 1,                     // para que el web page detenga el proceso (deje de ejecutar el ws) ... 
            Progress_ErrorMessage = ""
        };

        serializedJsonObject = javaScriptSerializer.Serialize(wsResult);
        writeStringToFile.WriteToDisk(serializedJsonObject, out errorMessage); 
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


        // establecemos los valores de los parámetros en el LinqDataSource 

        ConsultaPresupuesto_LinqDataSource.WhereParameters["CiaContab"].DefaultValue = "-1"; 
        ConsultaPresupuesto_LinqDataSource.WhereParameters["Moneda"].DefaultValue = "-1"; 
        ConsultaPresupuesto_LinqDataSource.WhereParameters["NombreUsuario"].DefaultValue = User.Identity.Name;
        
        // intentamos usar como parametros del LinqDataSource el primer item en los combos Monedas y CiasContab

        if (this.CiasContab_DropDownList.Items.Count > 0)
        {
            CiasContab_DropDownList.SelectedIndex = 0;
            ConsultaPresupuesto_LinqDataSource.WhereParameters["CiaContab"].DefaultValue = 
                CiasContab_DropDownList.SelectedValue.ToString();
        }


        if (this.Monedas_DropDownList.Items.Count > 0)
        {
            Monedas_DropDownList.SelectedIndex = 0;
            ConsultaPresupuesto_LinqDataSource.WhereParameters["Moneda"].DefaultValue = 
                Monedas_DropDownList.SelectedValue.ToString();
        }
        
        this.ConsultaPresupuesto_ListView.DataBind();
    }

    protected void CiasContab_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        ConsultaPresupuesto_LinqDataSource.WhereParameters["CiaContab"].DefaultValue = CiasContab_DropDownList.SelectedValue.ToString();
        this.ConsultaPresupuesto_ListView.DataBind();
    }
    protected void Monedas_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        ConsultaPresupuesto_LinqDataSource.WhereParameters["Moneda"].DefaultValue = Monedas_DropDownList.SelectedValue.ToString();
        this.ConsultaPresupuesto_ListView.DataBind();
    }

    public string Fix_URL(string sCiaContab, string sCodigoPresupuesto, string sNombreCodigoPresupuesto)
    {
        // Do whatever it takes to change oldURL

        return "javascript:PopupWin('ConsultaPresupuesto_ConsultaCuentasContables.aspx?CiaContab=" + sCiaContab + "&CodigoPresupuesto=" + sCodigoPresupuesto + "&NombreCodigoPresupuesto=" + sNombreCodigoPresupuesto + "', 1000, 680)";
    }

    public string Fix_URL2(string sMesFiscal, string sAnoFiscal, string sCiaContab, string sMoneda, string sCodigoPresupuesto, string sNombreCodigoPresupuesto)
    {
        // Do whatever it takes to change oldURL

        // para construir el NavigateUrl en el HyperLink del monto ejecutado del mes 

        return "javascript:PopupWin('ConsultaPresupuesto_ConsultaMovMes.aspx?MesFiscal=" + sMesFiscal + "&AnoFiscal=" + sAnoFiscal + "&CiaContab=" + sCiaContab + "&Moneda=" + sMoneda + "&CodigoPresupuesto=" + sCodigoPresupuesto + "&NombreCodigoPresupuesto=" + sNombreCodigoPresupuesto + "', 1000, 680)";
    }

    public string Fix_URL3(string sMesFiscal, string sAnoFiscal, string sCiaContab, string sMoneda, string sCodigoPresupuesto, string sNombreCodigoPresupuesto)
    {
        // Do whatever it takes to change oldURL

        // para construir el NavigateUrl en el HyperLink del monto ejecutado del mes 

        return "javascript:PopupWin('ConsultaPresupuesto_ConsultaMovAcum.aspx?MesFiscal=" + sMesFiscal + "&AnoFiscal=" + sAnoFiscal + "&CiaContab=" + sCiaContab + "&Moneda=" + sMoneda + "&CodigoPresupuesto=" + sCodigoPresupuesto + "&NombreCodigoPresupuesto=" + sNombreCodigoPresupuesto + "', 1000, 680)";
    }

    protected void AplicarFactorConversion_LinkButton_Click(object sender, EventArgs e)
    {
        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        // leemos el factor de conversión registrado para el mes (calendario) de la consulta 
        // y lo aplicamos a las cifras calculadas 

        // lo primero que hacemos es determinar el año calendario que corresponde a la consulta 
        // (el mes calendario fue registrado en la tabla) 

        dbContabDataContext dbContab = new dbContabDataContext();

        // --------------------------------------------------------------------------------
        // lo primero que hacemos es obtener el mes fiscal de la consulta 

        var query0 = (from t in dbContab.tTempWebReport_PresupuestoConsultaMensuals
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

        // con el mes fiscal, determinamos el mes y año calendario en la tabla de meses fiscales 

        var query = (from mf in dbContab.MesesDelAnoFiscals 
                    where mf.MesFiscal == query0.MesFiscal && 
                    mf.Cia == query0.CiaContab
                         select mf).FirstOrDefault(); 

        if (query == null)
        {
            ErrMessage_Span.InnerHtml = "No existe un registro en la tabla Definición de Meses para " + 
                "el Año Fiscal, para el mes fiscal que corresponde a la consulta. <br /> " + 
                "Por favor revise el contenido de esta tabla y corrija este error antes " + 
                "de intentar continuar con este proceso.";
            ErrMessage_Span.Style["display"] = "block";

            return; 
        }

        int nMesCalendario = query.Mes;
        int nAnoCalendario = query0.AnoFiscal;

        if (query.Ano == 1)
            nAnoCalendario++; 

        // ahora que tenemos el mes y año calendarios, leemos el factor de conversión y lo usamos para 
        // convertir las cifras consultadas 

        var queryFactoresConversion = (from fc in dbContab.FactoresConversionAnoMes 
                                 where fc.Mes == nMesCalendario && 
                                 fc.Ano == nAnoCalendario
                                 select fc).FirstOrDefault();

        if (queryFactoresConversion == null)
        {
            ErrMessage_Span.InnerHtml = "No existe un factor de conversión registrado en la tabla " +
                "Factores de Conversión por Mes, para el mes indicado para la consulta. <br /> " +
                "Ud. debe agregar un registro a la tabla mencionada que contenga el factor de convesión " +
                "para el mes indicado a esta consulta.";
            ErrMessage_Span.Style["display"] = "block";

            return; 
        }

        if (queryFactoresConversion.FactorConversion == 0)
        {
            ErrMessage_Span.InnerHtml = "El factor de conversión definido para el mes consultado " +
                "es cero. Un factor de conversión igual a cero no puede ser aplicado.<br /> " +
                "Ud. puede revisar y corregir esta situación si revisa el contenido de la tabla " +
                "Factores de Conversión por Mes para el mes indicado para la consulta.";
            ErrMessage_Span.Style["display"] = "block";

            return; 
        }

        // ahora que tenemos el factor de convesión para el mes consultado, lo aplicamos a los montos 
        // de la consulta. Además, lo guardamos en el item que corresponde para que el usuario 
        // pueda observarlo fácilmente 

        var query1 = from tw in dbContab.tTempWebReport_PresupuestoConsultaMensuals
                     where tw.NombreUsuario == User.Identity.Name
                     select tw;

        foreach (var consultaMensualPresupuesto in query1)
        {
            consultaMensualPresupuesto.FactorConversion = queryFactoresConversion.FactorConversion;

            consultaMensualPresupuesto.MontoEstimado /= queryFactoresConversion.FactorConversion;
            consultaMensualPresupuesto.MontoEjecutado /= queryFactoresConversion.FactorConversion;
            consultaMensualPresupuesto.MontoEstimadoAcum /= queryFactoresConversion.FactorConversion;
            consultaMensualPresupuesto.MontoEjecutadoAcum /= queryFactoresConversion.FactorConversion; 
        }

        try
        {
            dbContab.SubmitChanges();
        }
        catch (Exception ex)
        {
            dbContab = null;

            ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de " + 
                "acceso a la base de datos. <br /> El mensaje específico de error es: " + 
                ex.Message + "<br />";
            ErrMessage_Span.Style["display"] = "block";
        }
        finally
        {
            dbContab = null;
            PageDataBind();
        }
    }
}
