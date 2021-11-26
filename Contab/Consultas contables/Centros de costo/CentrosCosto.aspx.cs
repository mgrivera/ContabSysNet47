using System;
using System.Collections;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Collections.Generic;
//using ContabSysNetWeb.Old_App_Code;
using System.Linq;
//using ContabSysNet_Web.old_app_code;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using System.Web.UI.WebControls;
using ContabSysNet_Web.ModelosDatos_EF.code_first.contab;
using ContabSysNet_Web.Clases;

namespace ContabSysNetWeb.Contab.Consultas_contables.Centros_de_costo
{
    public partial class CentrosCosto : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            Master.Page.Title = "Consulta de movimientos contables por centro de costo";

            if (!Page.IsPostBack)
            {
                //Gets a reference to a Label control that is not in a ContentPlaceHolder control
                HtmlContainerControl MyHtmlSpan;

                MyHtmlSpan = (HtmlContainerControl)(Master.FindControl("AppName_Span"));
                if (MyHtmlSpan != null)
                    MyHtmlSpan.InnerHtml = "Contab";

                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
                if (MyHtmlH2 != null)
                    MyHtmlH2.InnerHtml = "Consulta de movimientos por centro de costo";

                //--------------------------------------------------------------------------------------------
                //para asignar la página que corresponde al help de la página 
                HtmlAnchor MyHtmlHyperLink;
                MyHtmlHyperLink = (HtmlAnchor)Master.FindControl("Help_HyperLink");

                MyHtmlHyperLink.HRef = "javascript:PopupWin('../../../Doc/Bancos/Facturas/Consulta facturas/consulta_general_de_facturas.htm', 1000, 680)";

                Session["FiltroForma"] = null; 
            }
            else
            {
                // la página puede ser 'refrescada' por el popup; en ese caso, ejeucutamos una función que efectúa alguna funcionalidad y rebind la información 
                if (this.RebindFlagHiddenField.Value == "1")
                {
                    RebindFlagHiddenField.Value = "0";
                    RefreshAndBindInfo();
                }
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
                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = "Aparentemente, Ud. no ha indicado un filtro aún.<br />Por favor indique y aplique un filtro antes " +
                    "de intentar mostrar el resultado de la consulta.";
               
                return;
            }

            // nótese como hacemos también el databinding de los dos combos, cada vez que el usuario cambia el filtro; la 
            // razón es que el contenido de ambos combos depende del resultado del query ... 

            this.MonedasFilter_DropDownList.DataBind();
            this.CompaniasFilter_DropDownList.DataBind();

            // ---------------------------------------------------------------------------------------------------------------------------------------------
            // leemos la tabla de monedas para 'saber' cual es la moneda Bs. Nota: la idea es aplicar las opciones de reconversión *solo* a esta moneda 
            var monedaNacional_result = Reconversion.Get_MonedaNacional();

            if (monedaNacional_result.error)
            {
                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = monedaNacional_result.message;

                return;
            }

            Monedas monedaNacional = monedaNacional_result.moneda;
            // ---------------------------------------------------------------------------------------------------------------------------------------------

            ContabContext contabContext = new ContabContext();

            string filter = ConstruirFiltro(contabContext);

            // el usuario indica en el filtro si desea reconvertir cifras anteriores al 1/Oct/2.021 
            bool bReconvertirCifrasAntes_01Oct2021 = (bool)Session["ReconvertirCifrasAntes_01Oct2021"];
            int moneda = (int)Session["monedaSeleccionada"];

            // las fechas vienen como Dates en el Session; en realidad como Objects; por eso se deben convertir a Dates 
            DateTime fechaInicialPeriodo = (DateTime)Session["fechaInicialPeriodo"];
            DateTime fechaFinalPeriodo = (DateTime)Session["fechaFinalPeriodo"];

            string sFechaInicialPeriodo = fechaInicialPeriodo.ToString("yyyy-MM-dd");
            string sFechaFinalPeriodo = fechaFinalPeriodo.ToString("yyyy-MM-dd");

            string query = "";

            // aplicamos la reconversión *solo* cuando: el usuario lo indicó, la moneda es Bs y la la fecha de inicio es anterior al 1/Oct
            if (!bReconvertirCifrasAntes_01Oct2021 || (moneda != monedaNacional.Moneda) || fechaInicialPeriodo >= new DateTime(2021, 10, 1))
            {
                // no se va a reconvertir: hacemos el query en forma usual 
                query = "Select a.NumeroAutomatico as numeroAutomatico, a.Numero as numero, d.Partida, c.Cuenta as cuentaContable, " +
                            "c.Descripcion as cuentaContableDescripcion, a.Fecha as fecha, d.Descripcion as descripcion, " +
                            "d.Referencia as referencia, a.ProvieneDe as provieneDe, " +
                            "d.Debe as debe, d.Haber as haber, a.Usuario as usuario, " +
                            "m.Simbolo as monedaSimbolo, mo.Simbolo as monedaOriginalSimbolo, " +
                            "d.Debe as debe, d.Haber as haber, " +
                            "cc.DescripcionCorta as centrosCostoDescripcion, comp.Abreviatura as companiaAbreviatura " +
                            "From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico " +
                            "Inner Join CuentasContables c On d.CuentaContableID = c.ID " +
                            "Inner Join Monedas m On a.Moneda = m.Moneda " +
                            "Inner Join Monedas mo On a.MonedaOriginal = mo.Moneda " +
                            "Inner Join Companias comp On a.Cia = comp.Numero " +
                            "Left Outer Join CentrosCosto cc On d.CentroCosto = cc.CentroCosto " +
                       $"Where (a.Fecha Between '{sFechaInicialPeriodo}' And '{sFechaFinalPeriodo}') And " +
                       $"{filter} " + " And (d.Referencia <> 'Reconversión 2021') " + 
                        "Order By a.Fecha, a.Numero";
            }
            else
            {
                // se va a reconvertir: agregamos un Union al query para lograr la reconversión de las cifras anteriores a 1/Oct/21 

                // este es el período *hasta* el 1ro/Oct: reconvertimos 
                query = "Select a.NumeroAutomatico as numeroAutomatico, a.Numero as numero, d.Partida, c.Cuenta as cuentaContable, " +
                            "c.Descripcion as cuentaContableDescripcion, a.Fecha as fecha, d.Descripcion as descripcion, " +
                            "d.Referencia as referencia, a.ProvieneDe as provieneDe, " +
                            "Round((d.Debe / 1000000), 2) as debe, Round((d.Haber / 1000000), 2) as haber, " +
                            "a.Usuario as usuario, " +
                            "m.Simbolo as monedaSimbolo, mo.Simbolo as monedaOriginalSimbolo, " +
                            "d.Debe as debe, d.Haber as haber, " +
                            "cc.DescripcionCorta as centrosCostoDescripcion, comp.Abreviatura as companiaAbreviatura " +
                            "From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico " +
                            "Inner Join CuentasContables c On d.CuentaContableID = c.ID " +
                            "Inner Join Monedas m On a.Moneda = m.Moneda " +
                            "Inner Join Monedas mo On a.MonedaOriginal = mo.Moneda " +
                            "Inner Join Companias comp On a.Cia = comp.Numero " +
                            "Left Outer Join CentrosCosto cc On d.CentroCosto = cc.CentroCosto " +
                       $"Where (a.Fecha Between '{sFechaInicialPeriodo}' And '2021-09-30') And " +
                       $"{filter} " +

                    "Union " +

                    // este es el período *desde* el 1ro/Oct: no reconvertimos 
                    "Select a.NumeroAutomatico as numeroAutomatico, a.Numero as numero, d.Partida, c.Cuenta as cuentaContable, " +
                        "c.Descripcion as cuentaContableDescripcion, a.Fecha as fecha, d.Descripcion as descripcion, " +
                        "d.Referencia as referencia, a.ProvieneDe as provieneDe, " +
                        "d.Debe as debe, d.Haber as haber, a.Usuario as usuario, " +
                        "m.Simbolo as monedaSimbolo, mo.Simbolo as monedaOriginalSimbolo, " +
                        "d.Debe as debe, d.Haber as haber, " +
                        "cc.DescripcionCorta as centrosCostoDescripcion, comp.Abreviatura as companiaAbreviatura " +
                        "From dAsientos d Inner Join Asientos a On d.NumeroAutomatico = a.NumeroAutomatico " +
                        "Inner Join CuentasContables c On d.CuentaContableID = c.ID " +
                        "Inner Join Monedas m On a.Moneda = m.Moneda " +
                        "Inner Join Monedas mo On a.MonedaOriginal = mo.Moneda " +
                        "Inner Join Companias comp On a.Cia = comp.Numero " +
                        "Left Outer Join CentrosCosto cc On d.CentroCosto = cc.CentroCosto " +
                    $"Where (a.Fecha Between '2021-10-1' And '{sFechaFinalPeriodo}') And " +
                    $"{filter} " + " And (d.Referencia <> 'Reconversión 2021') " +
                    "Order By a.Fecha, a.Numero";
            }

            // cambiamos los nombres de las tablas pues se abrevian en el query 
            query = query.Replace("dAsientos.", "d.");
            query = query.Replace("Asientos.", "a.");
            query = query.Replace("CuentasContables.", "c."); 
            query = query.Replace("CentrosCosto.", "cc."); 

            //var partidas = contabContext.dAsientos.SqlQuery(query);

            this.SqlDataSource1.SelectCommand = query;
            this.MovimientosContables_GridView.DataBind(); 
        }

        public string ConstruirFiltro(ContabContext contabContext)
        {
            string filter = Session["FiltroForma"].ToString();

            // aplicamos los minifilters; el usuario puede seleccionar cia y moneda desde ddl en el tope de la página 
            if (!string.IsNullOrEmpty(this.CuentaContableFilter_TextBox.Text))
            {
                string miniFilter = this.CuentaContableFilter_TextBox.Text.ToString().Replace("*", "");
                filter += $" And (CuentasContables.Cuenta Like '%{miniFilter}%')";
            }

            if (!string.IsNullOrEmpty(this.CuentaContableDescripcionFilter_TextBox.Text))
            {
                string miniFilter = this.CuentaContableDescripcionFilter_TextBox.Text.ToString().Replace("*", "");
                filter += $" And (CuentasContables.Descripcion Like '%{miniFilter}%')";
            }

            if (!string.IsNullOrEmpty(this.CentroCostoFilter_TextBox.Text))
            {
                string miniFilter = this.CentroCostoFilter_TextBox.Text.ToString().Replace("*", "");
                filter += $" And (CentrosCosto.DescripcionCorta Like '%{miniFilter}%' Or CentrosCosto.Descripcion Like '%{miniFilter}%' )";
            }

            // aplicamos los minifilters; el usuario puede seleccionar cia y moneda desde ddl en el tope de la página 
            if (this.CompaniasFilter_DropDownList.SelectedIndex != -1)
            {
                int selectedValue = Convert.ToInt32(this.CompaniasFilter_DropDownList.SelectedValue);
                filter += $" And (Asientos.Cia In ({selectedValue}))";
            }

            if (this.MonedasFilter_DropDownList.SelectedIndex != -1)
            {
                int selectedValue = Convert.ToInt32(this.MonedasFilter_DropDownList.SelectedValue);
                filter += $" And (Asientos.Moneda In ({selectedValue}))";
            }

            return filter;
        }

        public string MontoAsiento(object debe, object haber)
        {
            decimal montoDebe = 0;
            decimal montoHaber = 0;

            decimal.TryParse(debe.ToString(), out montoDebe);
            decimal.TryParse(haber.ToString(), out montoHaber);

            return (montoDebe - montoHaber).ToString("N2");
        }

        protected void MovimientosContables_GridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GridView gv = sender as GridView;
            gv.PageIndex = e.NewPageIndex;
            RefreshAndBindInfo();
        }

        public IQueryable<Companias> CompaniasFilter_DropDownList_SelectMethod()
        {
            // ponemos el en ddl las compañías seleccionadas en el filtro; la idea es que el usuario pueda seleccionar cualquiera de ellas 
            // para mostrarlas, separadamente, en la lista 
            if (Session["FiltroForma"] == null)
                return null;

            ContabContext contabContext = new ContabContext();

            string filter = Session["FiltroForma"].ToString();

            var sqlQuery = "Select Asientos.Cia From dAsientos " +
                        "Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico " +
                        "Inner Join CuentasContables On dAsientos.CuentaContableID = CuentasContables.ID " +
                       $"Where {filter} " +
                        "Group By Asientos.Cia";

            List<int> ciasContab = contabContext.Database.SqlQuery<int>(sqlQuery).ToList();

            var query = contabContext.Companias.Where(x => ciasContab.Contains(x.Numero)).Select(x => x).AsQueryable(); 

            return query; 
        }

        public IQueryable<Monedas> MonedasFilter_DropDownList_SelectMethod()
        {
            // ponemos el en ddl las compañías seleccionadas en el filtro; la idea es que el usuario pueda seleccionar cualquiera de ellas 
            // para mostrarlas, separadamente, en la lista 
            if (Session["FiltroForma"] == null)
                return null;

            ContabContext contabContext = new ContabContext();

            string filter = Session["FiltroForma"].ToString();

            var sqlQuery = "Select Asientos.Moneda From dAsientos " +
                        "Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico " +
                        "Inner Join CuentasContables On dAsientos.CuentaContableID = CuentasContables.ID " +
                       $"Where {filter} " +
                        "Group By Asientos.Moneda";

            List<int> monedas = contabContext.Database.SqlQuery<int>(sqlQuery).ToList();

            var query = contabContext.Monedas.Where(x => monedas.Contains(x.Moneda)).Select(x => x).AsQueryable();

            return query;
        }

        protected void AplicarMiniFiltro(object sender, EventArgs e)
        {
            this.MovimientosContables_GridView.PageIndex = 0;
            this.MovimientosContables_GridView.SelectedIndex = -1;
            this.RefreshAndBindInfo();
        }
    }
}
