using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Text;
using ContabSysNet_Web.Clases;

namespace ContabSysNetWeb.Contab.Consultas_contables.BalanceGeneral
{
    public partial class BalanceGeneral_Filter : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
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
                this.Sql_it_Cia_Numeric.DataSource = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

                // pareciera que si no hacemos el databind para los listboxes aquí, la clase que regresa el state
                // encuentra estos controles sin sus datos
                Sql_it_Cia_Numeric.DataBind();
                Sql_it_ID_Numeric.DataBind();
                Sql_it_Grupo_Numeric.DataBind();
                Monedas_ListBox.DataBind();
                MonedasOriginales_ListBox.DataBind(); 

                // intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros
                if (!(Membership.GetUser().UserName == null))
                {
                    KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
                    MyKeepPageState.ReadStateFromFile(this, this.Controls);
                    MyKeepPageState = null;
                }
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
            if (this.Sql_it_Cia_Numeric.SelectedIndex == -1)
            {
                string errorMessage = "Ud. debe seleccionar una compañía (Contab) de la lista.";

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return;
            }

            if (this.Monedas_ListBox.SelectedIndex == -1)
            {
                string errorMessage = "Ud. debe seleccionar una moneda de la lista.";

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return;
            }

            if (!this.BalanceGeneral_RadioButton.Checked && !this.GyP_RadioButton.Checked)
            {
                string errorMessage = "Ud. debe indicar el tipo de consulta que desea obtener (balance general / ganancias y pérdias).";

                CustomValidator1.IsValid = false;
                CustomValidator1.ErrorMessage = errorMessage;

                return;
            }

            DateTime inicioPeriodo; 

            if (DateTime.TryParse(this.Desde_TextBox.Text, out inicioPeriodo))
            {
                if (inicioPeriodo.Day != 1)
                {
                    string errorMessage = "La fecha de inicio del período debe siempre corresponder a un 1ro. de mes (ej: 1-Mayo-2010).";

                    CustomValidator1.IsValid = false;
                    CustomValidator1.ErrorMessage = errorMessage;

                    return;
                }
            }

            BuildSqlCriteria MyConstruirCriterioSql = new BuildSqlCriteria();
            MyConstruirCriterioSql.LinqToEntities = true;                           // para que el criterio venga apropiado para aplicarlo a LinqToEntities 
            MyConstruirCriterioSql.ContruirFiltro(this.Controls);
            string sSqlSelectString = MyConstruirCriterioSql.CriterioSql;
            MyConstruirCriterioSql = null;

            // -------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando
            // se abra la proxima vez

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
            MyKeepPageState.SavePageStateInFile(this.Controls);

            MyKeepPageState = null;

            // ---------------------------------------------------------------------------------------------
            // registramos los parámetros en un objeto y los persistimos en Session ... 

            BalanceGeneral_Parametros parametros = new BalanceGeneral_Parametros();

            parametros.CiaContab = Convert.ToInt32(this.Sql_it_Cia_Numeric.SelectedValue);
            parametros.Moneda = Convert.ToInt32(this.Monedas_ListBox.SelectedValue);
            parametros.MonedaOriginal = null;

            if (this.MonedasOriginales_ListBox.SelectedIndex != -1 && this.MonedasOriginales_ListBox.SelectedValue != "0")
                parametros.MonedaOriginal = Convert.ToInt32(this.MonedasOriginales_ListBox.SelectedValue); 

            parametros.Desde = Convert.ToDateTime(this.Desde_TextBox.Text);
            parametros.Hasta = Convert.ToDateTime(this.Hasta_TextBox.Text);
            parametros.BalGen_GyP = this.BalanceGeneral_RadioButton.Checked ? "BG" : "GyP"; 
            parametros.BalGen_ExcluirGYP = this.BalGen_ExcluirGastosIngresos_CheckBox.Checked;
            parametros.ExcluirCuentasSaldoYMovtosCero = this.ExcluirCuentasSinSaldoNiMovtos_CheckBox.Checked;
            parametros.ExcluirCuentasSinMovimientos = this.ExcluirCuentasSinMovimientos_CheckBox.Checked;
            parametros.ExcluirAsientosContablesTipoCierreAnual = this.ExcluirAsientosContablesTipoCierreAnual_CheckBox.Checked; 

            parametros.Filtro = sSqlSelectString; 

            Session["BalanceGeneral_Parametros"] = parametros; 


            // la página que muestra los movimientos contables para una cuenta (seleccionada en la lista) 
            // corresponde al proceso que permite obtener el balance de comprobación; esta página usa 
            // estas session variables para delimitar el período; por lo tanto, las inicializamos también aquí ... 

            Session["FechaInicialPeriodo"] = Convert.ToDateTime(Desde_TextBox.Text);
            Session["FechaFinalPeriodo"] = Convert.ToDateTime(Hasta_TextBox.Text);

            // ---------------------------------------------------------------------------------------------
            // lo que sigue son instrucciones para ejecutar una función javascript en el parent page. La
            // función pone un hidden field en 1 y hace un submit (refresh) de la página

            //StringBuilder sb = new StringBuilder();
            //sb.Append("window.opener.RefreshPage();");
            //sb.Append("window.close();");

            //ClientScript.RegisterClientScriptBlock(this.GetType(), "CloseWindowScript", sb.ToString(), true);

            ScriptManager.RegisterStartupScript(this, this.GetType(),
                "CloseWindowScript",
                "<script language='javascript'>window.opener.RefreshPage(); window.close();</script>", false); 
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

            foreach (ListItem MyListItem in Sql_it_Cia_Numeric.Items)
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
                "SELECT ID, CuentasContables.Cuenta + ' - ' + CuentasContables.Descripcion + ' (' + Companias.Abreviatura + ')' AS " +
                "CuentaContableYNombre FROM CuentasContables " + 
                "INNER JOIN Companias ON CuentasContables.Cia = Companias.Numero " +
                "WHERE (CuentasContables.TotDet = 'D' And CuentasContables.ActSusp = 'A') And " + MyWhereString + " " +
                "ORDER BY Companias.NombreCorto, CuentasContables.Cuenta + N' ' + CuentasContables.Descripcion";

            Sql_it_Cuenta_String.DataBind();
        }

        protected void CuentasContablesFilter_TextBox_TextChanged(object sender, EventArgs e)
        {
            // para mostrar en el listbox de cuentas contables solo las que corresponden a las cia contab 
            // seleccionada  

            SeleccionarCuentasContables(); 
        }
    }
}
