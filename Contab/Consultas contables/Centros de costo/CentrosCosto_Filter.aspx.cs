using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos_EF.ActivosFijos;
using ContabSysNet_Web.Clases;

namespace ContabSysNetWeb.Contab.Consultas_contables.Centros_de_costo
{
    public partial class CentrosCosto_Filter : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
             Master.Page.Title = "... defina un filtro y haga un click en Aplicar Filtro para aplicarlo";

             if (!User.Identity.IsAuthenticated)
             {
                 FormsAuthentication.SignOut();
                 return;
             }

             ErrMessage_Span.InnerHtml = "";
             ErrMessage_Span.Style["display"] = "none";

             if (!Page.IsPostBack)
             {
                 // usamos una clase para construir una lista con las compañías (Contab) que se han asignado al usuario 
                 ConstruirListaCompaniasAsignadas listaCiasContabAsignadas = new ConstruirListaCompaniasAsignadas();
                 this.Sql_it_Asiento_Cia_Numeric.DataSource = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

                 //  pareciera que si no hacemos el databind para los listboxes aqu�, la clase que regresa el state 
                 //  encuentra estos controles sin sus datos 
                 this.Sql_it_Asiento_Cia_Numeric.DataBind();
                 this.Sql_it_Asiento_Moneda_Numeric.DataBind();
                 this.Sql_it_CentroCosto_Numeric.DataBind();
                 this.Sql_it_Asiento_ProvieneDe_String.DataBind();
                 this.Sql_it_Asiento_Usuario_String.DataBind();
                 this.Sql_it_CuentasContable_Cuenta_String.DataBind();
                 this.Sql_it_CuentasContable_Grupo_Numeric.DataBind(); 

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
            if (Sql_it_Asiento_Cia_Numeric.SelectedIndex == -1)
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

            if (this.ConCentroCostoAsignado_CheckBox.Checked)
                sSqlSelectString += " And (it.CentroCosto Is Not Null)"; 

            Session["FiltroForma"] = sSqlSelectString;

            // -------------------------------------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando se abra la proxima vez 

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
            MyKeepPageState.SavePageStateInFile(this.Controls);
            MyKeepPageState = null;


            // para cerrar esta página y "refrescar" la que la abrió ... 
            //System.Text.StringBuilder sb = new System.Text.StringBuilder();
            //sb.Append("window.opener.RefreshPage();");
            //sb.Append("window.close();");
            //ClientScript.RegisterClientScriptBlock(this.GetType(), "CloseWindowScript", sb.ToString(), true);

            ScriptManager.RegisterStartupScript(this, this.GetType(),
                "CloseWindowScript",
                "<script language='javascript'>window.opener.RefreshPage(); window.close();</script>", false); 
            // ---------------------------------------------------------------------------------------------
        }


        protected void Sql_Asientos_Cia_Numeric_SelectedIndexChanged(object sender, EventArgs e)
        {
            // para mostrar en el listbox de cuentas contables solo las que corresponden a las cia contab 
            // seleccionada  

            SeleccionarCuentasContables();
        }

        private void SeleccionarCuentasContables()
        {
            // para mostrar en el ListBox de cuentas contables solo las que correspondan a la cia 
            // seleccionada

            String MyWhereString = "";

            foreach (ListItem MyListItem in Sql_it_Asiento_Cia_Numeric.Items)
            {
                if (MyListItem.Selected)
                    if (MyWhereString == "")
                        MyWhereString = " CuentasContables.Cia In (" + MyListItem.Value;
                    else
                        MyWhereString = MyWhereString + ", " + MyListItem.Value;
            }

            if (MyWhereString != "")
                MyWhereString = MyWhereString + ")";
            else
                MyWhereString = "1 = 1";

            // nótese como aplicamos el filtro que sigue: si el usuario indica '*', lo usamos en la forma usual; si no lo usa, 
            // siempre hacemos una busqueda genérica usando el texto indicado ... 

            if (!string.IsNullOrEmpty(this.CuentasContablesFilter_TextBox.Text.ToString().Trim()))
            {
                string value = this.CuentasContablesFilter_TextBox.Text.Trim();

                if (value.IndexOf("*") >= 0)
                {
                    // si el usuario indica "*", hacemos la búsqueda genérica en la forma usual ... 
                    value = value.Replace("*", "%");
                    MyWhereString += " And ((CuentasContables.Cuenta Like '" + value + "') Or " +
                                           "(CuentasContables.Descripcion Like '" + value + "'))";
                }
                else
                    // si el usuario no usa "*", siempre hacemos busqueda genérica para el texto indicado ... 
                    MyWhereString += " And (" +
                        "(CuentasContables.Cuenta Like '%" + this.CuentasContablesFilter_TextBox.Text.ToString().Trim() + "%') Or " +
                        "(CuentasContables.Descripcion Like '%" + this.CuentasContablesFilter_TextBox.Text.ToString().Trim() + "%'))";
            }

            // nótese como reconstruímos todo el select command del listbox de monedas 

            CuentasContables_SqlDataSource.SelectCommand =
                "SELECT CuentasContables.Cuenta + ' - ' + CuentasContables.Descripcion + ' (' + Companias.Abreviatura + ')' AS " +
                "CuentaContableYNombre, CuentasContables.Cuenta FROM CuentasContables " +
                "INNER JOIN Companias ON CuentasContables.Cia = Companias.Numero " +
                "WHERE (CuentasContables.TotDet = 'D' And CuentasContables.ActSusp = 'A') And " + MyWhereString + " " +
                "ORDER BY Companias.NombreCorto, CuentasContables.Cuenta + N' ' + CuentasContables.Descripcion";

            Sql_it_CuentasContable_Cuenta_String.DataBind();
        }

        protected void CuentasContablesFilter_TextBox_TextChanged(object sender, EventArgs e)
        {
            // para mostrar en el listbox de cuentas contables solo las que corresponden a las cia contab 
            // seleccionada  

            SeleccionarCuentasContables();
        }
    }
}