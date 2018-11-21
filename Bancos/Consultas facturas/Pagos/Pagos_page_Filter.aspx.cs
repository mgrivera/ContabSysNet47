using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos_EF.ActivosFijos;
using ContabSysNet_Web.Clases;

namespace ContabSysNet_Web.Bancos.ConsultasFacturas.Pagos
{
    public partial class Pagos_page_Filter : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
             Master.Page.Title = "... defina un filtro y haga un click en Aplicar Filtro para aplicarlo";

             ErrMessage_Span.InnerHtml = "";
             ErrMessage_Span.Style["display"] = "none";

             if (!User.Identity.IsAuthenticated)
             {
                 FormsAuthentication.SignOut();
                 return;
             }

             if (!Page.IsPostBack)
             {
                 // usamos una clase para construir una lista con las compañías (Contab) que se han asignado al usuario 
                 ConstruirListaCompaniasAsignadas listaCiasContabAsignadas = new ConstruirListaCompaniasAsignadas();
                 this.Sql_it_Cia_Numeric.DataSource = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

                 //  pareciera que si no hacemos el databind para los listboxes aqu�, la clase que regresa el state 
                 //  encuentra estos controles sin sus datos 

                 this.Sql_it_Cia_Numeric.DataBind();
                 this.Sql_it_Proveedor_Numeric.DataBind();
                
                 // -----------------------------------------------------------------------------------------------------------
                 //  intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros 

                 if (!(Membership.GetUser().UserName == null))
                 {
                     KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
                     MyKeepPageState.ReadStateFromFile(this, this.Controls);
                     MyKeepPageState = null;
                 }
                 // -----------------------------------------------------------------------------------------------------------

                 this.AplicarFiltro_Button.Focus(); 
             }
        }

        protected void LimpiarFiltro_Button_Click(object sender, EventArgs e)
        {
            LimpiarFiltro MyLimpiarFiltro = new LimpiarFiltro(this);
            MyLimpiarFiltro.LimpiarControlesPagina();
            MyLimpiarFiltro = null;
        }

        protected void AplicarFiltro_Button_Click(object sender, EventArgs e)
        {
            if (Sql_it_Cia_Numeric.SelectedIndex == -1)
            {
                // el usuario debe siempre seleccionar, al menos, una compañía en la lista 
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar una Cia Contab de la lista.";
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            BuildSqlCriteria MyConstruirCriterioSql = new BuildSqlCriteria();
            MyConstruirCriterioSql.LinqToEntities = true;       // para que regrese un filtro apropiado para linq to entities ... 
            MyConstruirCriterioSql.ContruirFiltro(this.Controls);
            string sSqlSelectString = MyConstruirCriterioSql.CriterioSql;
            MyConstruirCriterioSql = null;


            Session["FiltroForma"] = sSqlSelectString;

            // -------------------------------------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando se abra la proxima vez 

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
            MyKeepPageState.SavePageStateInFile(this.Controls);
            MyKeepPageState = null;


            // para cerrar esta página y "refrescar" la que la abrió ... 
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append("window.opener.RefreshPage();");
            sb.Append("window.close();");
            ClientScript.RegisterClientScriptBlock(this.GetType(), "CloseWindowScript", sb.ToString(), true);
            // ---------------------------------------------------------------------------------------------
        }














        protected void CompaniasFilter_TextBox_TextChanged(object sender, EventArgs e)
        {
            // para seleccionar en el ListBox los registros que quiere filtrar el usuario 
            SelectListBoxItems();
        }


        private void SelectListBoxItems()
        {
            // para mostrar en el ListBox de cuentas contables solo las que correspondan a la cia 
            // seleccionada

            String MyWhereString = "(1 = 1)";

            // nótese como aplicamos el filtro que sigue: si el usuario indica '*', lo usamos en la forma usual; si no lo usa, 
            // siempre hacemos una busqueda genérica usando el texto indicado ... 

            if (!string.IsNullOrEmpty(this.CompaniasFilter_TextBox.Text.ToString().Trim()))
            {
                string value = this.CompaniasFilter_TextBox.Text.Trim();

                if (value.IndexOf("*") >= 0)
                {
                    // si el usuario indica "*", hacemos la búsqueda genérica en la forma usual ... 
                    value = value.Replace("*", "%");
                    MyWhereString += " And (Proveedores.Nombre Like '" + value + "')";
                }
                else
                    // si el usuario no usa "*", siempre hacemos busqueda genérica para el texto indicado ... 
                    MyWhereString += " And (Proveedores.Nombre Like '%" + this.CompaniasFilter_TextBox.Text.ToString().Trim() + "%')";
            }

            // nótese como reconstruímos todo el select command del listbox 

            Proveedores_SqlDataSource.SelectCommand =
                "SELECT Proveedor, Nombre From Proveedores " +
                "Where (ProveedorClienteFlag = 1 Or ProveedorClienteFlag = 3) And " + MyWhereString + " " +
                "Order By Nombre";

            Sql_it_Proveedor_Numeric.DataBind();
        }
    }
}