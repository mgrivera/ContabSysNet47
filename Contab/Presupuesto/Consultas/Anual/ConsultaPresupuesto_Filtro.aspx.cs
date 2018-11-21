using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using ContabSysNet_Web.Clases; 

public partial class Contab_Presupuesto_Consultas_Anual_ConsultaPresupuesto_Filtro : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        if (!Page.IsPostBack)
        {
            // usamos una clase para construir una lista con las compañías (Contab) que se han asignado al usuario 
            ConstruirListaCompaniasAsignadas listaCiasContabAsignadas = new ConstruirListaCompaniasAsignadas();
            this.Sql_PresupuestoMontos_CiaContab_Numeric.DataSource = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

            //  pareciera que si no hacemos el databind para los listboxes aqu�, la clase que regresa el state 
            //  encuentra estos controles sin sus datos 
            this.Sql_PresupuestoMontos_CiaContab_Numeric.DataBind();
            this.Sql_PresupuestoMontos_Moneda_Numeric.DataBind();
            this.Sql_PresupuestoMontos_Ano_Numeric.DataBind();
            
            //  intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros 
            if (!(User.Identity.Name == null))
            {
                KeepPageState MyKeepPageState = new KeepPageState(User.Identity.Name, this.GetType().Name.ToString());
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
        if (!Page.IsValid)
            return;

        BuildSqlCriteria MyConstruirCriterioSql = new BuildSqlCriteria();
        MyConstruirCriterioSql.ContruirFiltro(this.Controls);
        string sSqlSelectString = MyConstruirCriterioSql.CriterioSql;
        MyConstruirCriterioSql = null;

        sSqlSelectString = sSqlSelectString.Replace("PresupuestoMontos", "Presupuesto_Montos");

        Session["FiltroForma"] = sSqlSelectString;

        // -------------------------------------------------------------------------------------------
        // para guardar el contenido de los controles de la página para recuperar el state cuando 
        // se abra la proxima vez 

        KeepPageState MyKeepPageState = new KeepPageState(User.Identity.Name, this.GetType().Name.ToString());
        MyKeepPageState.SavePageStateInFile(this.Controls);
        MyKeepPageState = null;

        //System.Text.StringBuilder sb = new System.Text.StringBuilder();
        //sb.Append("window.opener.RefreshPage();");
        //sb.Append("window.close();");
        //ClientScript.RegisterClientScriptBlock(this.GetType(), "CloseWindowScript", sb.ToString(), true);

        // ------------------------------------------------------------------------------------------------------
        // nótese lo que hacemos aquí para que RegisterStartupScript funcione cuando ejecutamos en Chrome ... 
        ScriptManager.RegisterStartupScript(this, this.GetType(),
            "CloseWindowScript",
            "<script language='javascript'>window.opener.RefreshPage(); window.close();</script>", false);
        // ---------------------------------------------------------------------------------------------
    }

    protected void CustomValidator2_ServerValidate(object source, ServerValidateEventArgs args)
    {
        args.IsValid = (Sql_PresupuestoMontos_Ano_Numeric.SelectedIndex >= 0);
    }

    protected void CustomValidator3_ServerValidate(object source, ServerValidateEventArgs args)
    {
        args.IsValid = (Sql_PresupuestoMontos_CiaContab_Numeric.SelectedIndex >= 0);
    }
}
