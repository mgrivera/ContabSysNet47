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

            // ahora que se hizo el databinding de los combos, hacemos el databinding del grid, pues éste se hace 
            // en base al item seleccionado en los 2 combos ... 

            MovimientosContables_GridView.PageIndex = 0;
            this.MovimientosContables_GridView.SelectedIndex = -1; 
            MovimientosContables_GridView.DataBind(); 
        }

        // The return type can be changed to IEnumerable, however to support
        // paging and sorting, the following parameters must be added:
        //     int maximumRows
        //     int startRowIndex
        //     out int totalRowCount
        //     string sortByExpression

        public IQueryable<dAsientos> MovimientosContables_GridView_GetData()
        {
            ContabContext contabContext = new ContabContext();

            if (Session["FiltroForma"] == null)
                return null; 

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
                filter += $" And (CentrosCosto.DescripcionCorta Like '%{miniFilter}%')";
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

            var query = "Select dAsientos.* From dAsientos " +
                        "Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico " +
                        "Inner Join CuentasContables On dAsientos.CuentaContableID = CuentasContables.ID " +
                        "Left Outer Join CentrosCosto On dAsientos.CentroCosto = CentrosCosto.CentroCosto " + 
                       $"Where {filter} " +
                        "Order By Asientos.Fecha, Asientos.Numero";

            var partidas = contabContext.dAsientos.SqlQuery(query);

            return partidas.AsQueryable(); 
        }


        public string MontoAsiento(object debe, object haber)
        {
            decimal montoDebe = 0;
            decimal montoHaber = 0;

            decimal.TryParse(debe.ToString(), out montoDebe);
            decimal.TryParse(haber.ToString(), out montoHaber);

            return (montoDebe - montoHaber).ToString("N2");
        }

        protected void MovimientosContables_GridView_PageIndexChanged(object sender, EventArgs e)
        {
            GridView gv = sender as GridView;
            gv.SelectedIndex = -1; 
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
            this.MovimientosContables_GridView.DataBind(); 
        }
    }
}
