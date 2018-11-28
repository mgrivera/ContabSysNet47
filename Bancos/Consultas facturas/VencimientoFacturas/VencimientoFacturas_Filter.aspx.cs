using System;
using System.Web.UI;
using System.Text;
using System.Web.Security;
using ContabSysNet_Web.Clases; 

public partial class Bancos_VencimientoFacturas_VencimientoFacturas_Filter : System.Web.UI.Page
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
                this.Sql_CuotasFactura_Cia_Numeric.DataSource = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

                // pareciera que si no hacemos el databind para los listboxes aquí, la clase que regresa el state 
                // encuentra estos controles sin sus datos 

                this.Sql_CuotasFactura_Moneda_Numeric.DataBind();
                this.Sql_CuotasFactura_Cia_Numeric.DataBind();
                this.Sql_CuotasFactura_Proveedor_String.DataBind();
                this.Sql_CuotasFactura_CxCCxPFlag_Numeric.DataBind();

                // intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros 

                if (Membership.GetUser().UserName != null) 
                {
                    KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
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
        if (Sql_CuotasFactura_Cia_Numeric.SelectedIndex == -1)
        {
            // el usuario debe siempre seleccionar, al menos, una compañía en la lista 
            ErrMessage_Span.InnerHtml = "Ud. debe seleccionar una Cia Contab de la lista.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        BuildSqlCriteria  MyConstruirCriterioSql = new BuildSqlCriteria();
        MyConstruirCriterioSql.ContruirFiltro(this.Controls);
        String sSqlSelectString = MyConstruirCriterioSql.CriterioSql;

        Session["FiltroForma"] = sSqlSelectString;

        // ------------------------------------------------------------------------------------------------
        // guardamos las fechas del período para posterior referencia 

        Session["FechaConsulta_Inicio"] = null; 

        Session["FechaConsulta"] = DateTime.Parse(this.Hasta_TextBox.Text);

        if (!String.IsNullOrEmpty(this.Desde_TextBox.Text.Trim()))
        {
            Session["FechaConsulta_Inicio"] = DateTime.Parse(this.Desde_TextBox.Text);
        }
        
        Session["TipoConsulta"] = TipoConsulta_DropDownList.SelectedValue;


        // el usuario indica si desea o no usar las fechas de recepción de planillas de montos de impuestos retenidos, para 
        // aplicar estos montos o no; si no marca esta opción, estos montos (cuando existan) se restaran siempre al total a pagar; 
        // si marca esta opción, estos montos se aplicaran solo si se han recibido sus planillas ... 

        Session["AplicarFechasRecepcionPlanillasRetencionImpuestos"] = false; 
        if (AplicarFechasRecepcionPlanillasRetencionImpuestos_CheckBox.Checked)
            Session["AplicarFechasRecepcionPlanillasRetencionImpuestos"] = true; 

        // -------------------------------------------------------------------------------------------
        // para guardar el contenido de los controles de la página para recuperar el state cuando 
        // se abra la proxima vez 

        KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name.ToString());
        MyKeepPageState.SavePageStateInFile(this.Controls);

        MyKeepPageState = null;
        //---------------------------------------------------------------------------------------------
        //lo que sigue son instrucciones para ejecutar una función javascript en el parent page. La 
        //función pone un hidden field en 1 y hace un submit (refresh) de la página 

        //StringBuilder  sb = new StringBuilder(); 
        //sb.Append("window.opener.RefreshPage();");
        //sb.Append("window.close();");

        //ClientScript.RegisterClientScriptBlock(this.GetType(), "CloseWindowScript", sb.ToString(), true);
        //---------------------------------------------------------------------------------------------

        // ------------------------------------------------------------------------------------------------------
        // nótese lo que hacemos aquí para que RegisterStartupScript funcione cuando ejecutamos en Chrome ... 
        ScriptManager.RegisterStartupScript(this, this.GetType(),
            "CloseWindowScript",
            "<script language='javascript'>window.opener.RefreshPage(); window.close();</script>", false);
    }
}

