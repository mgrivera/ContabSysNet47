using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Text;
using ContabSysNet_Web.Clases;
using System.Data;

namespace ContabSysNetWeb.Contab.Consultas_contables.Cuentas_y_movimientos
{
    public partial class CuentasYMovimientos_Filter : System.Web.UI.Page
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
                this.Sql_Asientos_Cia_Numeric.DataSource = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

                // pareciera que si no hacemos el databind para los listboxes aquí, la clase que regresa el state
                // encuentra estos controles sin sus datos

                Sql_Asientos_Cia_Numeric.DataBind();
                Sql_Asientos_Moneda_Numeric.DataBind();
                Sql_Asientos_MonedaOriginal_Numeric.DataBind();
                Sql_dAsientos_CentroCosto_Numeric.DataBind();
                this.Sql_CuentasContables_Grupo_Numeric.DataBind(); 

                // intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros

                if (!(Membership.GetUser().UserName == null))
                {
                    KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
                    MyKeepPageState.ReadStateFromFile(this, this.Controls);
                    MyKeepPageState = null;
                }

                Session["codigoCondi"] = null;
                Session["ciaContabSeleccionada"] = null;
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
            // GET SELECTED ITEMS
            //List<string> myList = new List<string>(); 

            //for (int i = 0; i <= select1.Items.Count - 1; i++)
            //{
            //    if (select1.Items[i].Selected)
            //        myList.Add(select1.Items[i].Text + " | " + select1.Items[i].Value); 
            //}

            // SET SELECTED ITEMS
            //select1.Items[2].Selected = true;
            //select1.Items[4].Selected = true;

            if (Sql_Asientos_Cia_Numeric.SelectedIndex == -1)
            {
                // el usuario debe siempre seleccionar, al menos, una compañía en la lista 
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar una Cia Contab de la lista.";
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            if (this.Sql_Asientos_Cia_Numeric.GetSelectedIndices().Count() > 1 && this.codigoCondi.Text.ToString().Trim() != "")
            {
                // el usuario debe siempre seleccionar, al menos, una compañía en la lista 
                ErrMessage_Span.InnerHtml = "Si Ud. usa <em>codigos condi</em> como criterio en el filtro, debe seleccionar <b>solo una</b> <em>compañía Contab</em>.";
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            BuildSqlCriteria MyConstruirCriterioSql = new BuildSqlCriteria();
            MyConstruirCriterioSql.ContruirFiltro(this.Controls);
            string sSqlSelectString = MyConstruirCriterioSql.CriterioSql;
            MyConstruirCriterioSql = null;

            sSqlSelectString = sSqlSelectString.Replace("CuentasContables2", "CuentasContables");

            Session["FiltroForma"] = sSqlSelectString;
            // ------------------------------------------------------------------------------------------------
            // ahora intentamos crear un filtro solo para la lectura de los movimientos en la tabla
            // dAsientos

            MyConstruirCriterioSql = new BuildSqlCriteria("I", "Sql_Asientos_Moneda_Numeric, Sql_Asientos_MonedaOriginal_Numeric, Sql_dAsientos_Descripcion_String, Sql_dAsientos_Referencia_String, Sql_dAsientos_CentroCosto_Numeric, Sql_Asientos_Numero_Numeric, Sql_CuentasContables_Grupo_Numeric");
            MyConstruirCriterioSql.ContruirFiltro(this.Controls);
            sSqlSelectString = MyConstruirCriterioSql.CriterioSql;
            MyConstruirCriterioSql = null;

            sSqlSelectString = sSqlSelectString + " And Asientos.Fecha Between '" + 
                Convert.ToDateTime(Desde_TextBox.Text).ToString("yyyyMMdd") + 
                "' And '" +
                Convert.ToDateTime(Hasta_TextBox.Text).ToString("yyyyMMdd") + 
                "'";

            Session["FiltroForma_Movimientos"] = sSqlSelectString;
            Session["FechaInicialPeriodo"] = Convert.ToDateTime(Desde_TextBox.Text);
            Session["FechaFinalPeriodo"] = Convert.ToDateTime(Hasta_TextBox.Text);
            Session["ExcluirCuentasSinMovimientos"] = ExcluirCuentasSinMovimientos_CheckBox.Checked;
            Session["ExcluirCuentasConSaldoCeroYSinMovtos"] = ExcluirCuentasSinSaldoYSinMovtos_CheckBox.Checked;
            Session["ExcluirMovimientosDeAsientosDeTipoCierreAnual"] =
                ExcluirMovimientosDeAsientosDeTipoCierreAnual_CheckBox.Checked;

            Session["ExcluirCuentasConSaldosInicialFinalCero"] = ExcluirCuentasConSaldosInicialFinalCero_CheckBox.Checked;
            Session["ExcluirCuentasConSaldoFinalCero"] = ExcluirCuentasConSaldoFinalCero_CheckBox.Checked;
 
            // guardamos en un session el valor de un parámetro que usará el reporte 

            DateTime desde; 
            DateTime hasta;

            Session["Report_Param_MG_Periodo"] = "Período: indefinido"; 

            if (DateTime.TryParse(Desde_TextBox.Text.ToString(), out desde))
                if (DateTime.TryParse(Hasta_TextBox.Text.ToString(), out hasta))
                    Session["Report_Param_MG_Periodo"] = desde.ToString("d-MMM-yyyy") + " al " + hasta.ToString("d-MMM-yyyy"); 

            // guardamos algún filtro por moneda original, para luego usarlo al deteminar el saldo inicial de la cuenta 
            Session["ctasYMovtos_MonOrig_Filter"] = null;

            if (this.Sql_Asientos_MonedaOriginal_Numeric.SelectedIndex != -1)
                Session["ctasYMovtos_MonOrig_Filter"] = this.Sql_Asientos_MonedaOriginal_Numeric.SelectedValue; 



            Session["ctasYMovtos_SinSaldoInicialCuentasContables"] = false;

            if (this.NoMostrarSaldoInicialPeriodo_CheckBox.Checked)
                Session["ctasYMovtos_SinSaldoInicialCuentasContables"] = true;

            // el código condi que pueda indicar el usuario lo pasamos a la página principal. Esta construirá un subquery para seleccionar *solo* 
            // las cuentas que correspondan al código condi 
            if (this.codigoCondi.Text.ToString().Trim() != "")
            {
                Session["codigoCondi"] = this.codigoCondi.Text;
                // nota: arriba nos aseguramos que al seleccionar por códigos condi, se seleccionara una sola compañía 
                Session["ciaContabSeleccionada"] = this.Sql_Asientos_Cia_Numeric.SelectedValue.ToString(); 
            }
                

            // -------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando
            // se abra la proxima vez

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
            MyKeepPageState.SavePageStateInFile(this.Controls);

            MyKeepPageState = null;
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
    }
}
