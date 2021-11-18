using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Text;
using ContabSysNet_Web.Clases; 

namespace ContabSysNetWeb.Contab.Consultas_contables.BalanceComprobacion
{
    public partial class BalanceComprobacion_Filter : System.Web.UI.Page
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
                this.Sql_CuentasContables_Cia_Numeric.DataSource = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

                // pareciera que si no hacemos el databind para los listboxes aquí, la clase que regresa el state
                // encuentra estos controles sin sus datos
                Sql_CuentasContables_Cia_Numeric.DataBind();
                Sql_SaldosContables_Moneda_Numeric.DataBind();

                // intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros

                if (!(Membership.GetUser().UserName == null))
                {
                    KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
                    MyKeepPageState.ReadStateFromFile(this, this.Controls);
                    MyKeepPageState = null;
                }
            }

            this.CustomValidator1.IsValid = true;
            this.CustomValidator1.Visible = false; 
        }

        protected void LimpiarFiltro_Button_Click(object sender, EventArgs e)
        {
            LimpiarFiltro MyLimpiarFiltro = new LimpiarFiltro(this);
            MyLimpiarFiltro.LimpiarControlesPagina();
            MyLimpiarFiltro = null;

            // ------------------------------------------------------------------------------------
            // restituímos los defaults en opciones que no forman parte del filto Sql, pero que
            // representan opciones de ejecución para el listado y tienen valores por defecto
            MostrarCuentasSinSaldoYSinMvtos_CheckBox.Checked = false;
            MostrarCuentasConSaldoYSinMvtos_CheckBox.Checked = true;

            this.ReconvertirCifrasAntes_01Oct2021_CheckBox.Checked = false;
        }

        protected void AplicarFiltro_Button_Click(object sender, EventArgs e)
        {
            // el usuario debe indincar una Cia Contab (solo una) 
            if (Sql_CuentasContables_Cia_Numeric.SelectedIndex == -1)
            {
                // el usuario debe siempre seleccionar, al menos, una compañía en la lista 
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar una Cia Contab de la lista.";
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
            // guardamos las fechas del período para posterior referencia

            Session["FechaInicialPeriodo"] = Convert.ToDateTime(Desde_TextBox.Text);
            Session["FechaFinalPeriodo"] = Convert.ToDateTime(Hasta_TextBox.Text);

            // --------------------------------------------------------------------------------------------
            // guardamos el valor de las opciones en variables Session
            Session["MostrarCuentasSinSaldoYSinMvtos"] = MostrarCuentasSinSaldoYSinMvtos_CheckBox.Checked;
            Session["MostrarCuentasConSaldoYSinMvtos"] = MostrarCuentasConSaldoYSinMvtos_CheckBox.Checked;
            Session["MostrarCuentasSaldosEnCero"] = MostrarCuentasConSaldosEnCero_CheckBox.Checked;
            Session["MostrarCuentasSaldoFinalEnCero"] = MostrarCuentasConSaldoFinalEnCero_CheckBox.Checked;
            Session["ExcluirAsientosTipoCierreAnual"] = ExcluirAsientosTipoCierreAnual_CheckBox.Checked;

            Session["ReconvertirCifrasAntes_01Oct2021"] = this.ReconvertirCifrasAntes_01Oct2021_CheckBox.Checked;

            Session["CiaContabSeleccionada"] = this.Sql_CuentasContables_Cia_Numeric.SelectedValue; 
            // -------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando
            // se abra la proxima vez

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
            MyKeepPageState.SavePageStateInFile(this.Controls);

            MyKeepPageState = null;
            //---------------------------------------------------------------------------------------------
            //lo que sigue son instrucciones para ejecutar una función javascript en el parent page. La
            //función pone un hidden field en 1 y hace un submit (refresh) de la página

            //StringBuilder sb = new StringBuilder();
            //sb.Append("window.opener.RefreshPage();");
            //sb.Append("window.close();");

            //ClientScript.RegisterClientScriptBlock(this.GetType(), "CloseWindowScript", sb.ToString(), true);

            ScriptManager.RegisterStartupScript(this, this.GetType(),
                "CloseWindowScript",
                "<script language='javascript'>window.opener.RefreshPage(); window.close();</script>", false); 
            //---------------------------------------------------------------------------------------------
        }
    }
}
