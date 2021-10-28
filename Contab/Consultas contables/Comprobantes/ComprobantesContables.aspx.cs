using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Web.UI.HtmlControls;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using ContabSysNet_Web.ModelosDatos_EF.code_first.contab;
using ContabSysNet_Web.Clases;

namespace ContabSysNetWeb.Contab.Consultas_contables.Comprobantes
{
    public partial class ComprobantesContables : System.Web.UI.Page
    {
        private class ComprobanteContable_Object
        {
            public int NumeroAutomatico { get; set; }
            public int Moneda { get; set; }
            public DateTime Fecha { get; set; } 
            public int NumPartidas { get; set; }
            public decimal? TotalDebe { get; set; }
            public decimal? TotalHaber { get; set; }
            public int NumLinks { get; set; }
            public string Lote { get; set; }
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

            Master.Page.Title = "Consulta de comprobantes contables";

            if (!Page.IsPostBack)
            {
                Session["filtroForma_consultaAsientosContables"] = null; 

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
                    MyHtmlH2.InnerHtml = "Consulta de comprobantes contables";
                }

                // --------------------------------------------------------------------------------------------
                // para asignar la página que corresponde al help de la página

                HtmlAnchor MyHtmlHyperLink;
                MyHtmlHyperLink = (HtmlAnchor)Master.FindControl("Help_HyperLink");

                MyHtmlHyperLink.HRef = "javascript:PopupWin('../../../Doc/Contab/Comprobantes contables/consulta_de_comprobantes_contabl.htm', 1000, 680)";
            }

            else
            {
                // -------------------------------------------------------------------------
                // la página puede ser 'refrescada' por el popup; en ese caso, ejeucutamos
                // una función que efectúa alguna funcionalidad y rebind la información

                if (RebindFlagHiddenField.Value == "1")
                {
                    RefreshAndBindInfo();
                    RebindFlagHiddenField.Value = "0";
                }
                // -------------------------------------------------------------------------
            }

            // para mostrar el link de funciones solo a usuarios autorizados ... 

            if (!Roles.IsUserInRole(Membership.GetUser().UserName, "Administradores") && 
                !Roles.IsUserInRole(Membership.GetUser().UserName, "Contab_Funciones"))
                this.SoloUsuariosAutorizados_Div.Visible = false; 
        }


        private void RefreshAndBindInfo()
        {

            if (!User.Identity.IsAuthenticated) {
                FormsAuthentication.SignOut();
                return;
            }

            if (Session["filtroForma_consultaAsientosContables"] == null) {
                ErrMessage_Span.InnerHtml = "Aparentemente, Ud. no ha indicado un filtro aún.<br />Por favor indique y aplique un filtro " + 
                    "antes de intentar mostrar el resultado de la consulta.";
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            // --------------------------------------------------------------------------------------------
            // determinamos el mes y año fiscales, para usarlos como criterio para buscar el saldo en la tabla
            // SaldosContables. En esta table, los saldos están para el mes fiscal y no para el mes calendario.
            // Los meses solo varían cuando el año fiscal no es igual al año calendario

            // --------------------------------------------------------------------------------------------
            // eliminamos el contenido de la tabla temporal

            dbContab_Contab_Entities context = new dbContab_Contab_Entities();

            try 
            {
                context.ExecuteStoreCommand("Delete From tTempWebReport_ConsultaComprobantesContables Where NombreUsuario = {0}", Membership.GetUser().UserName);
            }
            catch (Exception ex) 
            {
                context.Dispose();

                ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " + 
                    "El mensaje específico de error es: " + ex.Message + "<br /><br />";
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

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
            // ----------------------------------------------------------------------------------------------------------------------

            // agregamos este flag luego de la reconversión del 1-Oct-21 
            // la idea es que el usuario pueda decidir si reconvertir montos
            bool bReconvertirCifrasAntes_01Oct2021 = (bool)Session["ReconvertirCifrasAntes_01Oct2021"];

            // el usuario puede indicar que desea *solo* asientos con uploads 
            string joinTableAsientosUploads = "Left Outer Join "; 
            if (Session["SoloAsientosConUploads_CheckBox"] != null && Convert.ToBoolean(Session["SoloAsientosConUploads_CheckBox"]))
            {
                joinTableAsientosUploads = "Join ";
            }

            // usamos el criterio que indico el usuario para leer las cuentas contables y grabarlas a una tabla en la base de datos temporal

            // NOTA: *solo* si el usuario usa algunos criterios en el filtro, usamos un subquery en el select a los asientos contables 

            // nótese que el select a la tabla de links (asientos_documentos_links) se hace en un subquery; la idea es evitar que los counts se multipliquen 
            // por la cantidad de registros en el primer join. cuando en sql se hacen counts, sum, etc., y hay más de dos tablas en el select, los montos 
            // se desvirtúan. La solución es usar subqueries para las tablas que siguen a la segunda ... 
            string sSqlQueryString = "";

            if (Session["filtroForma_consultaAsientosContables_subQuery"] == null || Session["filtroForma_consultaAsientosContables_subQuery"].ToString() == "1 = 1")
            {
                sSqlQueryString = "SELECT Asientos.NumeroAutomatico, Asientos.Moneda, Asientos.Fecha, " +
                                "Count(dAsientos.Partida) As NumPartidas, Sum(dAsientos.Debe) As TotalDebe, Sum(dAsientos.Haber) AS TotalHaber, " +
                                "iif(links.NumLinks Is Not Null, links.NumLinks, 0) As NumLinks, Lote As Lote " +
                                "FROM Asientos Left Outer Join dAsientos On Asientos.NumeroAutomatico = dAsientos.NumeroAutomatico " +
                                joinTableAsientosUploads +      // 'join' o 'left join' dependiendo de si el usuario quiere *solo* asientos con uploads 
                                "(SELECT Asientos_Documentos_Links.NumeroAutomatico, Count(Asientos_Documentos_Links.Id) as NumLinks " +
                                "FROM Asientos_Documentos_Links " +
                                "Group By Asientos_Documentos_Links.NumeroAutomatico) as links On Asientos.NumeroAutomatico = links.NumeroAutomatico " + 
                                "Where " + Session["filtroForma_consultaAsientosContables"].ToString() + " " +
                                "Group By Asientos.NumeroAutomatico, Asientos.Moneda, Asientos.Fecha, Asientos.Lote, links.NumLinks";
            } else
            {
                // usamos un subquery para que solo asientos con ciertas cuentas *o* partidas con montos con más de 2 decimales sean seleccionados
                sSqlQueryString = "SELECT Asientos.NumeroAutomatico, Asientos.Moneda, Asientos.Fecha, " +
                                "Count(dAsientos.Partida) As NumPartidas, Sum(dAsientos.Debe) As TotalDebe, Sum(dAsientos.Haber) AS TotalHaber, " +
                                "iif(links.NumLinks Is Not Null, links.NumLinks, 0) As NumLinks, Lote As Lote " +
                                "FROM Asientos " +
                                "Left Outer Join dAsientos On Asientos.NumeroAutomatico = dAsientos.NumeroAutomatico " +
                                "Left Outer Join CuentasContables On CuentasContables.ID = dAsientos.CuentaContableID " +

                                joinTableAsientosUploads +      // 'join' o 'left join' dependiendo de si el usuario quiere *solo* asientos con uploads 
                                "(SELECT Asientos_Documentos_Links.NumeroAutomatico, Count(Asientos_Documentos_Links.Id) as NumLinks " +
                                "FROM Asientos_Documentos_Links " +
                                "Group By Asientos_Documentos_Links.NumeroAutomatico) as links On Asientos.NumeroAutomatico = links.NumeroAutomatico " +

                                "Where " + Session["filtroForma_consultaAsientosContables"].ToString() +
                                " And (Asientos.NumeroAutomatico In (SELECT Asientos.NumeroAutomatico FROM Asientos " +
                                "Left Outer Join dAsientos On Asientos.NumeroAutomatico = dAsientos.NumeroAutomatico " +
                                "Left Outer Join CuentasContables On CuentasContables.ID = dAsientos.CuentaContableID " +
                                "Where " + Session["filtroForma_consultaAsientosContables"].ToString() + " And " +
                                Session["filtroForma_consultaAsientosContables_subQuery"].ToString() + "))" +
                                "Group By Asientos.NumeroAutomatico, Asientos.Moneda, Asientos.Fecha, Asientos.Lote, links.NumLinks";
            }

            if (Session["SoloAsientosDescuadrados"] != null &&  Convert.ToBoolean(Session["SoloAsientosDescuadrados"]))
            {
                sSqlQueryString = sSqlQueryString + " Having Sum(dAsientos.Debe) <> Sum(dAsientos.Haber)"; 
            }


            List<ComprobanteContable_Object> query = context.ExecuteStoreQuery<ComprobanteContable_Object>(sSqlQueryString).ToList();
            tTempWebReport_ConsultaComprobantesContables MyComprobantesContable;

            decimal nTotalDebe = 0;
            decimal nTotalHaber = 0;
            int cantidadRegistros = 0;

            DateTime fechaReconversion2021 = new DateTime(2021, 10, 1);

            foreach (ComprobanteContable_Object a in query)
            {
                decimal totalDebe = a.TotalDebe != null ? a.TotalDebe.Value : 0;
                decimal totalHaber = a.TotalHaber != null ? a.TotalHaber.Value : 0;
                // -----------------------------------------------------------------------------------------
                // el usuario puede indicar que quiere reconvertir cifras anteriores al 31/Oct/21 
                if (bReconvertirCifrasAntes_01Oct2021 && (a.Moneda == monedaNacional.Moneda) && (a.Fecha < fechaReconversion2021))
                {
                    totalDebe /= 1000000;
                    totalDebe = Math.Round(totalDebe, 2);

                    totalHaber /= 1000000;
                    totalHaber = Math.Round(totalHaber, 2);
                }

                MyComprobantesContable = new tTempWebReport_ConsultaComprobantesContables();

                MyComprobantesContable.NumeroAutomatico = a.NumeroAutomatico;
                MyComprobantesContable.NumPartidas = Convert.ToInt16(a.NumPartidas);
                MyComprobantesContable.TotalDebe = totalDebe;
                MyComprobantesContable.TotalHaber = totalHaber;
                MyComprobantesContable.NombreUsuario = Membership.GetUser().UserName;
                MyComprobantesContable.NumUploads = Convert.ToInt16(a.NumLinks);
                MyComprobantesContable.Lote = a.Lote; 

                context.tTempWebReport_ConsultaComprobantesContables.AddObject(MyComprobantesContable);

                nTotalDebe += totalDebe;
                nTotalHaber += totalHaber; 
                cantidadRegistros++; 
            }

            try 
            {
                context.SaveChanges();
            }
            catch (Exception ex) 
            {
                string errorMessage = ex.Message;
                if (ex.InnerException != null)
                    errorMessage += "<br />" + ex.InnerException.Message;
                ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> " + 
                    "El mensaje específico de error es: " + 
                    errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                context.Dispose();
                return;
            }

            context.Dispose();

            this.CompaniasFilter_DropDownList.DataBind();
            this.MonedasFilter_DropDownList.DataBind(); 
            ComprobantesContables_ListView.DataBind();

            // actualizamos los totales en el footer en el ListView 
            Label numberOfRecords_label = (Label)ComprobantesContables_ListView.FindControl("numberOfRecords_label");
            Label MySumOfDebe_Label = (Label)ComprobantesContables_ListView.FindControl("SumOfDebe_Label");
            Label MySumOfHaber_Label = (Label)ComprobantesContables_ListView.FindControl("SumOfHaber_Label");

            if (numberOfRecords_label != null)
                numberOfRecords_label.Text = cantidadRegistros.ToString();

            if (MySumOfDebe_Label != null)
                MySumOfDebe_Label.Text = nTotalDebe.ToString("#,##0.000");

            if (MySumOfHaber_Label != null)
                MySumOfHaber_Label.Text = nTotalHaber.ToString("#,##0.000");
        }

        protected void ComprobantesContables_ListView_PagePropertiesChanged(object sender, EventArgs e)
        {
            ListView lv = sender as ListView;
            lv.SelectedIndex = -1;
        }

        protected void ComprobantesContables_ListView_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        public IQueryable<tTempWebReport_ConsultaComprobantesContables> ComprobantesContables_ListView_GetData()
        {
            string userName = Membership.GetUser().UserName;

            dbContab_Contab_Entities context = new dbContab_Contab_Entities();

            var query = context.tTempWebReport_ConsultaComprobantesContables.Include("Asiento").Include("Asiento.Moneda2").Where(c => c.NombreUsuario == userName);

            if (this.CompaniasFilter_DropDownList.SelectedIndex != -1)
            {
                int selectedValue = Convert.ToInt32(this.CompaniasFilter_DropDownList.SelectedValue);
                query = query.Where(c => c.Asiento.Cia == selectedValue);
            }

            if (this.MonedasFilter_DropDownList.SelectedIndex != -1)
            {
                int selectedValue = Convert.ToInt32(this.MonedasFilter_DropDownList.SelectedValue);
                query = query.Where(c => c.Asiento.Moneda == selectedValue);
            }

            if (!string.IsNullOrEmpty(this.CuentaContableFilter_TextBox.Text))
            {
                string filter = this.CuentaContableFilter_TextBox.Text.ToString().Replace("*", "");

                // nótese como el usuario puede o no usar '*' para el mini filtro; de usarlo, la busqueda es más precisa ... 
                if (this.CuentaContableFilter_TextBox.Text.ToString().Trim().StartsWith("*") && this.CuentaContableFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.Asiento.dAsientos.Where(d => d.CuentasContable.Cuenta.Contains(filter)).Any());
                else if (this.CuentaContableFilter_TextBox.Text.ToString().Trim().StartsWith("*"))
                    query = query.Where(c => c.Asiento.dAsientos.Where(d => d.CuentasContable.Cuenta.EndsWith(filter)).Any());
                else if (this.CuentaContableFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.Asiento.dAsientos.Where(d => d.CuentasContable.Cuenta.StartsWith(filter)).Any());
                else
                    query = query.Where(c => c.Asiento.dAsientos.Where(d => d.CuentasContable.Cuenta.Contains(filter)).Any());
            }

            if (!string.IsNullOrEmpty(this.CuentaContableDescripcionFilter_TextBox.Text))
            {
                string filter = this.CuentaContableDescripcionFilter_TextBox.Text.ToString().Replace("*", "");

                // nótese como el usuario puede o no usar '*' para el mini filtro; de usarlo, la busqueda es más precisa ... 
                if (this.CuentaContableDescripcionFilter_TextBox.Text.ToString().Trim().StartsWith("*") && this.CuentaContableDescripcionFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.Asiento.dAsientos.Where(d => d.CuentasContable.Descripcion.Contains(filter)).Any());
                else if (this.CuentaContableDescripcionFilter_TextBox.Text.ToString().Trim().StartsWith("*"))
                    query = query.Where(c => c.Asiento.dAsientos.Where(d => d.CuentasContable.Descripcion.EndsWith(filter)).Any());
                else if (this.CuentaContableDescripcionFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.Asiento.dAsientos.Where(d => d.CuentasContable.Descripcion.StartsWith(filter)).Any());
                else
                    query = query.Where(c => c.Asiento.dAsientos.Where(d => d.CuentasContable.Descripcion.Contains(filter)).Any());
            }

            query = query.OrderBy(c => c.Asiento.Fecha).ThenBy(c => c.Asiento.Numero);

            return query;
        }

        public IQueryable<Compania> Companias_DropDownList_GetData()
        {
            string userName = Membership.GetUser().UserName;

            dbContab_Contab_Entities context = new dbContab_Contab_Entities();

            var query = context.Companias.Where(c => c.Asientos.Where(a => a.tTempWebReport_ConsultaComprobantesContables.Any(t => t.NombreUsuario == userName)).Any()).Select(c => c);
            query = query.OrderBy(c => c.Nombre);
            return query;
        }

        public IQueryable<Moneda> Monedas_DropDownList_GetData()
        {
            string userName = Membership.GetUser().UserName;

            dbContab_Contab_Entities context = new dbContab_Contab_Entities();

            var query = context.Monedas.Where(m => m.Asientos.Where(a => a.tTempWebReport_ConsultaComprobantesContables.Any(t => t.NombreUsuario == userName)).Any()).Select(c => c);
            query = query.OrderBy(c => c.Descripcion);
            return query;
        }

        protected void AplicarMiniFiltro(object sender, EventArgs e)
        {
            // nótese lo que se debe hacer para poner el ListView en su 1ra. página ... 
            DataPager pgr = this.ComprobantesContables_ListView.FindControl("ComprobantesContables_DataPager") as DataPager;
            if (pgr != null)
                pgr.SetPageProperties(0, pgr.MaximumRows, false);

            this.ComprobantesContables_ListView.DataBind();
            ComprobantesContables_ListView.SelectedIndex = -1;
        }

    }
}
