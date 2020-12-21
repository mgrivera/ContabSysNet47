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

            // -----------------------------------------------------------------------------------------

            Master.Page.Title = "Consulta de movimientos contables por centro de costo";

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

        public IQueryable<dAsiento> MovimientosContables_GridView_GetData()
        {
            dbContab_Contab_Entities db = new dbContab_Contab_Entities();

            if (Session["FiltroForma"] == null)
                return null; 

            string filter = Session["FiltroForma"].ToString();

            var query = db.dAsientos.Where(filter).Select(a => a);

            if (this.CompaniasFilter_DropDownList.SelectedIndex != -1)
            {
                int selectedValue = Convert.ToInt32(this.CompaniasFilter_DropDownList.SelectedValue);
                query = query.Where(d => d.Asiento.Cia == selectedValue);
            }

            if (this.MonedasFilter_DropDownList.SelectedIndex != -1)
            {
                int selectedValue = Convert.ToInt32(this.MonedasFilter_DropDownList.SelectedValue);
                query = query.Where(d => d.Asiento.Moneda == selectedValue);
            }

            if (!string.IsNullOrEmpty(this.CuentaContableFilter_TextBox.Text))
            {
                string miniFilter = this.CuentaContableFilter_TextBox.Text.ToString().Replace("*", "");

                // nótese como el usuario puede o no usar '*' para el mini filtro; de usarlo, la busqueda es más precisa ... 
                if (this.CuentaContableFilter_TextBox.Text.ToString().Trim().StartsWith("*") && this.CuentaContableFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.CuentasContable.Cuenta.Contains(miniFilter));
                else if (this.CuentaContableFilter_TextBox.Text.ToString().Trim().StartsWith("*"))
                    query = query.Where(c => c.CuentasContable.Cuenta.EndsWith(miniFilter));
                else if (this.CuentaContableFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.CuentasContable.Cuenta.StartsWith(miniFilter));
                else
                    query = query.Where(c => c.CuentasContable.Cuenta.Contains(miniFilter));
            }

            if (!string.IsNullOrEmpty(this.CuentaContableDescripcionFilter_TextBox.Text))
            {
                string miniFilter = this.CuentaContableDescripcionFilter_TextBox.Text.ToString().Replace("*", "");

                // nótese como el usuario puede o no usar '*' para el mini filtro; de usarlo, la busqueda es más precisa ... 
                if (this.CuentaContableDescripcionFilter_TextBox.Text.ToString().Trim().StartsWith("*") && this.CuentaContableDescripcionFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.CuentasContable.Descripcion.Contains(miniFilter));
                else if (this.CuentaContableDescripcionFilter_TextBox.Text.ToString().Trim().StartsWith("*"))
                    query = query.Where(c => c.CuentasContable.Descripcion.EndsWith(miniFilter));
                else if (this.CuentaContableDescripcionFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.CuentasContable.Descripcion.StartsWith(miniFilter));
                else
                    query = query.Where(c => c.CuentasContable.Descripcion.Contains(miniFilter));
            }

            if (!string.IsNullOrEmpty(this.CentroCostoFilter_TextBox.Text))
            {
                string miniFilter = this.CentroCostoFilter_TextBox.Text.ToString().Replace("*", "");

                // nótese como el usuario puede o no usar '*' para el mini filtro; de usarlo, la busqueda es más precisa ... 
                if (this.CentroCostoFilter_TextBox.Text.ToString().Trim().StartsWith("*") && this.CuentaContableDescripcionFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.CentrosCosto.DescripcionCorta.Contains(miniFilter));
                else if (this.CentroCostoFilter_TextBox.Text.ToString().Trim().StartsWith("*"))
                    query = query.Where(c => c.CentrosCosto.DescripcionCorta.EndsWith(miniFilter));
                else if (this.CentroCostoFilter_TextBox.Text.Trim().EndsWith("*"))
                    query = query.Where(c => c.CentrosCosto.DescripcionCorta.StartsWith(miniFilter));
                else
                    query = query.Where(c => c.CentrosCosto.DescripcionCorta.Contains(miniFilter));
            }

            // aplicamos el período que el usuario indicó al filtro 
            if (Session["FechaInicialPeriodo"] != null && Session["FechaFinalPeriodo"] != null)
            {
                var fechaInicialPeriodo = (DateTime)Session["FechaInicialPeriodo"];
                var fechaFinalPeriodo = (DateTime)Session["FechaFinalPeriodo"];

                query = query.Where(c => c.Asiento.Fecha >= fechaInicialPeriodo);
                query = query.Where(c => c.Asiento.Fecha <= fechaFinalPeriodo);
            }
            
            query = query.OrderBy(d => d.Asiento.Fecha).ThenBy(d => d.Asiento.Numero); 

            return query; 
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

        public IQueryable<Compania> CompaniasFilter_DropDownList_SelectMethod()
        {
            if (Session["FiltroForma"] == null)
                return null;

            string filter = Session["FiltroForma"].ToString();

            dbContab_Contab_Entities context = new dbContab_Contab_Entities();

            // nótese el subquery: solo monedas que existen en el 1er. query ... 

            var query1 = context.dAsientos.Where(filter).Select(d => d.Asiento.Cia);
            var query2 = from c in context.Companias where query1.Contains(c.Numero) select c;
            query2 = query2.OrderBy(c => c.Nombre);

            return query2; 
        }

        public IQueryable<Moneda> MonedasFilter_DropDownList_SelectMethod()
        {
            if (Session["FiltroForma"] == null)
                return null;

            string filter = Session["FiltroForma"].ToString();

            dbContab_Contab_Entities context = new dbContab_Contab_Entities();

            // nótese el subquery: solo monedas que existen en el 1er. query ... 

            var query1 = context.dAsientos.Where(filter).Select(d => d.Asiento.Moneda);
            var query2 = from m in context.Monedas where query1.Contains(m.Moneda1) select m;
            query2 = query2.OrderBy(m => m.Descripcion);

            return query2; 
        }

        protected void AplicarMiniFiltro(object sender, EventArgs e)
        {
            this.MovimientosContables_GridView.PageIndex = 0;
            this.MovimientosContables_GridView.SelectedIndex = -1; 
            this.MovimientosContables_GridView.DataBind(); 
        }
    }
}
