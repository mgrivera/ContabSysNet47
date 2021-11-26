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
                 this.Sql_Asientos_Cia_Numeric.DataSource = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

                 //  pareciera que si no hacemos el databind para los listboxes aqu�, la clase que regresa el state 
                 //  encuentra estos controles sin sus datos 
                 this.Sql_Asientos_Cia_Numeric.DataBind();
                 this.Sql_Asientos_Moneda_Numeric.DataBind();
                 this.Sql_dAsientos_CentroCosto_Numeric.DataBind();
                 this.Sql_Asientos_ProvieneDe_String.DataBind();
                 this.Sql_Asientos_Usuario_String.DataBind();
                 this.Sql_CuentasContables_Grupo_Numeric.DataBind(); 

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

            this.ReconvertirCifrasAntes_01Oct2021_CheckBox.Checked = false;
        }

        protected void AplicarFiltro_Button_Click(object sender, EventArgs e)
        {
            if (this.Sql_Asientos_Cia_Numeric.SelectedIndex == -1)
            {
                // el usuario debe siempre seleccionar, al menos, una compañía en la lista 
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar una Cia Contab de la lista.";
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            if (this.Sql_Asientos_Moneda_Numeric.SelectedIndex == -1)
            {
                // el usuario debe siempre seleccionar, al menos, una moneda en la lista 
                ErrMessage_Span.InnerHtml = "Ud. debe seleccionar una moneda de la lista.";
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            BuildSqlCriteria MyConstruirCriterioSql = new BuildSqlCriteria();
            //MyConstruirCriterioSql.LinqToEntities = true;       // para que regrese un filtro apropiado para linq to entities ... 
            MyConstruirCriterioSql.ContruirFiltro(this.Controls);
            string sSqlSelectString = MyConstruirCriterioSql.CriterioSql;
            MyConstruirCriterioSql = null;

            //sSqlSelectString = sSqlSelectString + " And (Asientos.Fecha Between '" + Convert.ToDateTime(Desde_TextBox.Text).ToString("yyyy-MM-dd") + "'";
            //sSqlSelectString = sSqlSelectString + " And '" + Convert.ToDateTime(Hasta_TextBox.Text).ToString("yyyy-MM-dd") + "')";

            if (this.ConCentroCosto_RadioButton.Checked)
                sSqlSelectString += " And (dAsientos.CentroCosto Is Not Null)";

            if (this.SinCentroCosto_RadioButton.Checked)
                sSqlSelectString += " And (dAsientos.CentroCosto Is Null)";

            Session["FiltroForma"] = sSqlSelectString;

            // nótese que las fechas van en variables session como dates 
            Session["fechaInicialPeriodo"] = Convert.ToDateTime(Desde_TextBox.Text);
            Session["fechaFinalPeriodo"] = Convert.ToDateTime(Hasta_TextBox.Text);
            Session["monedaSeleccionada"] = Convert.ToInt32(this.Sql_Asientos_Moneda_Numeric.SelectedValue);

            Session["ReconvertirCifrasAntes_01Oct2021"] = this.ReconvertirCifrasAntes_01Oct2021_CheckBox.Checked;

            // -------------------------------------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando se abra la proxima vez 
            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
            MyKeepPageState.SavePageStateInFile(this.Controls);
            MyKeepPageState = null;

            // para cerrar esta página y "refrescar" la que la abrió ... 
            ScriptManager.RegisterStartupScript(this, this.GetType(),
                "CloseWindowScript",
                "<script language='javascript'>window.opener.RefreshPage(); window.close();</script>", false);
            // -------------------------------------------------------------------------------------------------------------------------
        }
    }
}