using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Security;

using ContabSysNet_Web.ModelosDatos_EF;
using ContabSysNet_Web.ModelosDatos_EF.ActivosFijos;
using ContabSysNet_Web.ModelosDatos_EF.Contab;

namespace ContabSysNet_Web.ActivosFijos.Consultas.DepreciacionMensual
{
    public partial class DepreciacionMensual_Page : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Master.Page.Title = "Activos fijos - Consultas";

            ErrMessage_Span.InnerHtml = "";
            ErrMessage_Span.Style["display"] = "none";

            if (!Page.IsPostBack)
            {
                // Gets a reference to a Label control that is not in a
                // ContentPlaceHolder control
                HtmlContainerControl MyHtmlSpan;

                MyHtmlSpan = (HtmlContainerControl)Master.FindControl("AppName_Span");
                if (!(MyHtmlSpan == null))
                {
                    MyHtmlSpan.InnerHtml = "Activos fijos";
                }

                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    // sub título para la página
                    MyHtmlH2.InnerHtml = "Activos Fijos - Depreciación Mensual - Consulta";
                }
            }

            else
            {
                if (RebindFlagHiddenField.Value == "1")
                {
                    RebindFlagHiddenField.Value = "0";

                    string sqlServerWhereString = Session["FiltroForma"].ToString();

                    short mesConsulta = (short)Session["ActFijos_Consulta_Mes"];
                    short anoConsulta = (short)Session["ActFijos_Consulta_Ano"];
                    bool excluirActivosTotalmenteDepreciadosAnosAnteiores = (bool)Session["ActFijos_ExcluirDepreciadosAnosAnteriores"];
                    bool aplicarInfoDesincorporados = (bool)Session["ActFijos_AplicarInfoDesincorporacion"];

                    CrearInfoReport(sqlServerWhereString, 
                                    mesConsulta, 
                                    anoConsulta, 
                                    excluirActivosTotalmenteDepreciadosAnosAnteiores, 
                                    aplicarInfoDesincorporados);

                    // ------------------------------------------------------------------------------------------------
                    // por último, refrescamos el ListView con la información preparada por la consulta ... 

                    tTempActivosFijos_ConsultaDepreciacion_EntityDataSource.WhereParameters["NombreUsuario"].DefaultValue = User.Identity.Name.ToString();
                    ConsultaDepreciacion_ListView.DataBind(); 
                }

            }
        }

        private void CrearInfoReport(
            string sqlServerWhereString, 
            short mesConsulta, 
            short anoConsulta, 
            bool excluirDepAnosAnteriores, 
            bool aplicarInfoDesincorporados)
        {
            // en este Sub agregamos los registros a la tabla 'temporal' en la base de datos para que la
            // página que sigue los muestre al usuario en un DataGridView

            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            // convertimos el mes y año de la consulta en una fecha (siempre último de cada mes) 

            DateTime fechaConsulta = new DateTime(anoConsulta, mesConsulta, 1).AddMonths(1).AddDays(-1);
            DateTime fechaInicioAno = new DateTime(anoConsulta, 1, 31);

            dbContab_ActFijos_Entities activosFijos_dbcontext = new dbContab_ActFijos_Entities(); 

            try
            {
                // ----------------------------------------------------------------------------------------
                // eliminamos los registros anteriores de la tabla 'temporal'

                string sqlTransactCommand = "Delete From tTempActivosFijos_ConsultaDepreciacion Where NombreUsuario = {0}";
                activosFijos_dbcontext.ExecuteStoreCommand(sqlTransactCommand, new object[] { User.Identity.Name }); 
            }
            catch (Exception ex)
            {
                activosFijos_dbcontext.Dispose();

                ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " + 
                    "El mensaje específico de error es: " + 
                    ex.Message + "<br /><br />";
                ErrMessage_Span.Style["display"] = "block";
                return;
            }


            int cantidadRegistrosAgregados = 0; 

            // nótese como seleccionamos solo los que se deprecien *luego* de la fecha de la consulta ... 

            var query = from a in activosFijos_dbcontext.InventarioActivosFijos.
                            Include("Compania").
                            Include("tDepartamento").
                            Include("TiposDeProducto").
                            Include("Moneda1").
                        Where(sqlServerWhereString)
                        // en escencia, eliminamos los que aún no se comienzan a depreciar ... 
                        where (a.DepreciarDesdeAno < anoConsulta) || 
                              (a.DepreciarDesdeAno == anoConsulta && a.DepreciarDesdeMes <= mesConsulta)
                        select a;


            tTempActivosFijos_ConsultaDepreciacion infoDepreciacion; 

            // para cada activo leído, convertimos su inicio y fin de depreciación en fechas (siempre último de cada mes) 

            DateTime fechaInicioDepreciacion;
            DateTime fechaFinDepreciacion; 

            // solo para activos fijos *desincorporados* y cuando el usuario *marca* la opción que permite aplicar este mecanismo, 
            // recalculamos los valores para: vida útil en meses del activo (CantidadMesesADepreciar) y monto total a depreciar (MontoADepreciar) 

            short cantidadMesesADepreciar = 0;
            decimal montoADepreciar = 0; 

            int ciaContabAnterior = -99999;

            DateTime fechaInicioAnoFiscal = new DateTime();
            string errorMessage = ""; 

            foreach (var a in query.OrderBy(i => i.Cia))
            {
                cantidadMesesADepreciar = a.CantidadMesesADepreciar;            // nóta: hemos encontrado que el usuario puede equivocarse aquí; mejor calculamos
                montoADepreciar = a.MontoADepreciar;
                //fechaCompraActivoFijo = a.FechaCompra; 

                // para que el cálculo de cantidad de meses entre fechas se haga de manera uniforme, nos aseguramos de llevar la fecha 
                // compra al último día del mes; por ejemplo: fecha compra -> 15-4-2014 --> llevamos a --> 30-4-2014 
                // la razón es que las fechas en el programa siempre se calculan al último mes del año .... 

                //fechaCompraActivoFijo = new DateTime(fechaCompraActivoFijo.Year, fechaCompraActivoFijo.Month, 1).AddMonths(1).AddDays(-1); 


                try
                {
                    //fechaInicioDepreciacion = new DateTime(a.DepreciarDesdeAno, a.DepreciarDesdeMes, 1).AddMonths(1).AddDays(-1);

                    // determinamos la fecha de inicio de depreciación, como el 1er. día del mes 'a depreciar'; de esta forma, parece que los 
                    // activos cuya depreciación se inicia en el año de la consulta, se calcula de forma correcta ... 

                    fechaInicioDepreciacion = new DateTime(a.DepreciarDesdeAno, a.DepreciarDesdeMes, 1);    
                    fechaFinDepreciacion = new DateTime(a.DepreciarHastaAno, a.DepreciarHastaMes, 1).AddMonths(1).AddDays(-1);
                    cantidadMesesADepreciar = CantidadMesesEntreFechas(fechaInicioDepreciacion, fechaFinDepreciacion);  // nótese que aquí recalculamos ... 
                }
                catch (Exception ex)
                {
                    errorMessage = ex.Message;
                    if (ex.InnerException != null)
                        errorMessage += "<br />" + ex.InnerException.Message;

                    ErrMessage_Span.InnerHtml = "Ha ocurrido un error mientras se efectuaba el proceso para el activo '" + 
                        a.Producto + "' - " + a.Descripcion + " (en la Cia Contab " + a.Compania.Abreviatura + ").<br />" + 
                        "Por favor revise los datos de registro de este activo y corríjalos de ser necesario. " + 
                        "Luego regrese y reintente ejecutar este proceso.<br /><br />" + 
                        "El mensaje específico de error es: " +
                        errorMessage;
                        ErrMessage_Span.Style["display"] = "block";
                        return;
                }
                

                if (aplicarInfoDesincorporados)
                    if (a.DesincorporadoFlag != null && a.DesincorporadoFlag.Value)
                        // cuando un activo es desincorporado, debe ser depreciado hasta el mes anterior a la desincorporación ... 
                        if (a.FechaDesincorporacion != null) 
                            // nos aseguramos que la fecha de desincorporación sea *anterior* a la fecha de fin de depreciación ... 
                            if ((a.FechaDesincorporacion.Value.Year < a.DepreciarHastaAno) ||
                                 (a.FechaDesincorporacion.Value.Year == a.DepreciarHastaAno && a.FechaDesincorporacion.Value.Month < a.DepreciarHastaMes))
                            {
                                // desincorporados: depreciamos hasta el mes *anterior* a la desincorporación ... 

                                DateTime fechaDepreciarHasta = a.FechaDesincorporacion.Value.AddMonths(-1);

                                // al igual que arriba, calculamos el último día del mes para la fecha anterior ... 
                                fechaFinDepreciacion = new DateTime(fechaDepreciarHasta.Year, fechaDepreciarHasta.Month, 1).AddMonths(1).AddDays(-1);

                                // ahora recalculamos los valores indicados arriba, y que deben ser recalculados para activos desincorporados 
                                // (nótese que un activo desincorporado es, en efecto, depreciado por una cantidad *menor* de meses que los originalmente anticipados)

                                cantidadMesesADepreciar = CantidadMesesEntreFechas(fechaInicioDepreciacion, fechaFinDepreciacion);
                                montoADepreciar = cantidadMesesADepreciar * a.MontoDepreciacionMensual; 
                            }


                // en lo sucesivo, calculamos cantidades de meses ... 

                int cantidadMesesAcumulados;
                int cantidadMesesEnElAno;


                // calculamos la cantidad de meses de vida del activo; 
                // si el activo ha culminado su vida útil, la cantidad de meses de vida es su vida completa; 
                // de otra forma, calculamos la cantidad de meses desde su inicio hasta la fecha de consulta ... 

                if (fechaFinDepreciacion < fechaConsulta)
                    cantidadMesesAcumulados = CantidadMesesEntreFechas(fechaInicioDepreciacion, fechaFinDepreciacion); 
                else
                    cantidadMesesAcumulados = CantidadMesesEntreFechas(fechaInicioDepreciacion, fechaConsulta); 

                // ====================================================================================================================================
                // ahora determinamos la cantidad de meses en el año en curso 
                // TODO: nótese como esta cantidad de meses depende del año fiscal de la empresa. El año puede ser igual al 
                // año calendario, pero también puede ser diferente; ejemplo: Marzo a Febrero ... 
                // 
                // obtenemos la fecha inicial del año fiscal solo cuando cambia la cia contab; nota: en teoría, esta consulta, al menos por ahora, 
                // puede ser obtenida para más de una cia contab 

                if (a.Cia != ciaContabAnterior) 
                {
                    if (!ObtenerFechaInicioAnoFiscal(fechaConsulta, a.Cia, out fechaInicioAnoFiscal, out errorMessage))
                    {
                        ErrMessage_Span.InnerHtml = "Ha ocurrido un error mientras se ejecutaba el proceso para esta consulta. <br /><br />" +
                            "El mensaje específico de error es: " +
                            errorMessage;
                        ErrMessage_Span.Style["display"] = "block";
                        return;

                    }
                    ciaContabAnterior = a.Cia; 
                }

                // ------------------------------------------------------------------------------
                // TODO: sustituir ahora fechaInicioAno por fechaInicioAnoFiscal
                // nota: recuérdese que, al determinar la fecha de inicio del año fiscal, nos aseguramos que fuera siempre 
                // *anterior* a la fecha de la consulta ... 

                DateTime fechaInicioAnoFiscal1erDiaMes = new DateTime(fechaInicioAnoFiscal.Year, fechaInicioAnoFiscal.Month, 1); // porque se calculó el 31 ... 

                if (fechaFinDepreciacion < fechaInicioAnoFiscal1erDiaMes)
                    // el activo se depreció en años (fiscales) anteriores 
                    cantidadMesesEnElAno = 0;
                else
                    // tomamos en cuenta que el activo pudo haberse comprado *luego* del inicio del año ... 
                    if (fechaInicioDepreciacion > fechaInicioAnoFiscal1erDiaMes)
                        if (fechaFinDepreciacion >= fechaConsulta)
                            // el activo se deprecia hasta después de la fecha de la consulta; la cantidad de meses en el año fiscal es simple: 
                            // desde inicio año fiscal hasta fecha consulta ... 
                            cantidadMesesEnElAno = CantidadMesesEntreFechas(fechaInicioDepreciacion, fechaConsulta);
                        else
                            // el activo se deprecia en el período que va: desde el inicio del año fiscal hasta la fecha de la consulta 
                            cantidadMesesEnElAno = CantidadMesesEntreFechas(fechaInicioDepreciacion, fechaFinDepreciacion);
                    else
                        if (fechaFinDepreciacion >= fechaConsulta)
                            // el activo se deprecia hasta después de la fecha de la consulta; la cantidad de meses en el año fiscal es simple: 
                            // desde inicio año fiscal hasta fecha consulta ... 
                            cantidadMesesEnElAno = CantidadMesesEntreFechas(fechaInicioAnoFiscal1erDiaMes, fechaConsulta);
                        else 
                            // el activo se deprecia en el período que va: desde el inicio del año fiscal hasta la fecha de la consulta 
                            cantidadMesesEnElAno = CantidadMesesEntreFechas(fechaInicioAnoFiscal1erDiaMes, fechaFinDepreciacion);
                // ====================================================================================================================================
                

                infoDepreciacion = new tTempActivosFijos_ConsultaDepreciacion();

                // guardamos estos *cuatro* items en la tabla temporal, pues pueden cambiar sus valores originales cuando un 
                // activo es desincorporado ... 

                infoDepreciacion.CantidadMesesADepreciar = cantidadMesesADepreciar;
                infoDepreciacion.MontoADepreciar = montoADepreciar; 

                infoDepreciacion.DepreciarHastaMes = (short)fechaFinDepreciacion.Month;
                infoDepreciacion.DepreciarHastaAno = (short)fechaFinDepreciacion.Year; 

                infoDepreciacion.ActivoFijoID = a.ClaveUnica;

                if (fechaFinDepreciacion < fechaConsulta)
                    infoDepreciacion.DepreciacionMensual = 0; 
                else
                    infoDepreciacion.DepreciacionMensual = a.MontoDepreciacionMensual;


                infoDepreciacion.DepAcum_CantMeses = Convert.ToInt16(cantidadMesesAcumulados);
                infoDepreciacion.DepAcum_CantMeses_AnoActual = Convert.ToInt16(cantidadMesesEnElAno);

                infoDepreciacion.DepAcum_AnoActual = a.MontoDepreciacionMensual * cantidadMesesEnElAno;
                infoDepreciacion.DepAcum_Total = a.MontoDepreciacionMensual * cantidadMesesAcumulados;

                infoDepreciacion.NombreUsuario = User.Identity.Name;

                // el usuario puede indicar que desea excluir los depreciados en años anteriores 

                if (excluirDepAnosAnteriores && cantidadMesesEnElAno == 0)
                    continue; 


                activosFijos_dbcontext.tTempActivosFijos_ConsultaDepreciacion.AddObject(infoDepreciacion);
                cantidadRegistrosAgregados++;
            }


            try
            {
                activosFijos_dbcontext.SaveChanges();
            }
            catch (Exception ex)
            {
                ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " + 
                    "El mensaje específico de error es: " + 
                    ex.Message + "<br /><br />";

                ErrMessage_Span.Style["display"] = "block";
                return;
            }
            finally
            {
                activosFijos_dbcontext.Dispose(); 
            }
        }

        private short CantidadMesesEntreFechas(DateTime dateDesde, DateTime dateHasta)
        {
            //short cantidadMeses = Convert.ToInt16((dateHasta.Year * 12 + dateHasta.Month) - (dateDesde.Year * 12 + dateDesde.Month));
            //return Convert.ToInt16(cantidadMeses + 1); 

            // nota: parece que lo anterior no es absolutamente confiable; simplemente, vamos contando meses, desde la fecha inicial,  
            // hasta que llegamos a la fecha final ... 

            DateTime fecha = dateDesde;
            short cantidadMeses = 0; 

            while (fecha < dateHasta)
            {
                fecha = fecha.AddMonths(1); 
                cantidadMeses++; 
            }

            return cantidadMeses; 
        }

        protected void ConsultaDisponibilidad_ListView_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected string FormatColorRow(string theData)
        {

            switch (theData)
            {
                case "IN":
                case "SA":
                case "TO":
                case "TC":
                    return "style='BACKGROUND-COLOR:#EFF3FF'";
                case "MR":
                    return "style='BACKGROUND-COLOR:#FFE8E5'";
                case "NE":
                    return "style='BACKGROUND-COLOR:#ADC1FF'";
                default:
                    return null;
            }

        }

        protected void ConsultaDepreciacion_ListView_PagePropertiesChanged(object sender, EventArgs e)
        {
            this.ConsultaDepreciacion_ListView.SelectedIndex = -1; 
        }

        private bool ObtenerFechaInicioAnoFiscal(DateTime fechaConsulta, 
                                                 int ciaContab, 
                                                 out DateTime fechaInicioAnoFiscal, 
                                                 out string errorMessage)
        {
            // regresamos el 1er. día del mes inicial del año fiscal. Esta fecha debe siempre ser *anterior* a la fecha indicada a la consulta 

            fechaInicioAnoFiscal = new DateTime(); 
            errorMessage = "";

            ContabSysNet_Web.ModelosDatos_EF.Contab.MesesDelAnoFiscal mesFiscal; 

            using (dbContab_Contab_Entities context = new dbContab_Contab_Entities())
            {
                mesFiscal = context.MesesDelAnoFiscals.Where(m => m.Cia == ciaContab && m.MesFiscal == 1).FirstOrDefault();

                if (mesFiscal == null)
                {
                    errorMessage = "Error: aparentemente, no se ha definido el año fiscal de la cia contab en la tabla de meses del año fiscal. ";
                    return false; 
                }

                fechaInicioAnoFiscal = new DateTime(fechaConsulta.Year, mesFiscal.Mes, 1); 
            }

            // el inicio del año fiscal que regrese esta función, debe ser siempre anterior a la fecha de la consulta 

            if (fechaInicioAnoFiscal > fechaConsulta)
                fechaInicioAnoFiscal = fechaInicioAnoFiscal.AddYears(-1); 

            // por alguna razón determinada en su momento, el inicio del año para estos cálculos se toma como el fin del mes 
            // y no el inicio; por ejemplo: si el inicio del año fiscal es el 1-mar-13, esta función regresa: 31-mar-13 ... 

            fechaInicioAnoFiscal = fechaInicioAnoFiscal.AddMonths(1).AddDays(-1); 

            return true; 
        }

        protected string ConstruirPeriodoTranscurridoAnoFiscal()
        {
            // regresamos el período transcurrido (en meses) desde el inicio del año fiscal de la compañía seleccionada (siempre hay una y no más de una), 
            // y la fecha de la consulta; por ejemplo: Mar-Ago, para una compañia que comienza su año fiscal en Marzo y la consulta se pide para Agosto ... 

            // nótese lo que hacemos para obtener la compañía seleccionada para la consulta; no podemos recibir este valor desde el asp.net control, pues 
            // estamos en el encabezado de la tabla y no en un row ... 

            string nombre1erMesAnoFiscal; 
            string nombreMesConsulta; 

            using (dbContab_ActFijos_Entities ctx = new dbContab_ActFijos_Entities())
            {
                int? ciaContabSeleccionada = ctx.tTempActivosFijos_ConsultaDepreciacion.Where(a => a.NombreUsuario == User.Identity.Name).
                                                                                        Select(a => a.InventarioActivosFijo.Cia).
                                                                                        FirstOrDefault();

                if (ciaContabSeleccionada == null)
                    return ""; 

                // leemos el mes calendario que corresponde al 1er. mes fiscal de la compañía 

                nombre1erMesAnoFiscal = ctx.MesesDelAnoFiscals.Where(m => m.Cia == ciaContabSeleccionada && m.MesFiscal == 1).
                                                               Select(m => m.NombreMes).
                                                               FirstOrDefault();

                if (string.IsNullOrEmpty(nombre1erMesAnoFiscal))
                    return ""; 

                // aquí debe venir el nombre del mes de la consulta (que indicó el usuario en el filtro) 

                if (Session["ActFijos_Consulta_NombreMes"] == null)
                    return ""; 

                if (string.IsNullOrEmpty(Session["ActFijos_Consulta_NombreMes"].ToString())) 
                    return ""; 

                nombreMesConsulta = Session["ActFijos_Consulta_NombreMes"].ToString(); 
            }

            return "(" + nombre1erMesAnoFiscal.Substring(0,3) + "-" + nombreMesConsulta.Substring(0,3) + ")"; 
        }
    }
}