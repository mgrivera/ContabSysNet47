using ContabSysNet_Web.Clases;
using System;
using System.Web.Security;
using System.Web.UI;

public partial class Bancos_Disponibilidad_en_bancos_Disponibilidad_MontosRestringidos_Filter : System.Web.UI.Page
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
            this.Sql_Companias_Numero_Numeric.DataSource = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

            //  pareciera que si no hacemos el databind para los listboxes aqu�, la clase que regresa el state 
            //  encuentra estos controles sin sus datos 
            this.Sql_Companias_Numero_Numeric.DataBind();
            this.Sql_DisponibilidadMontosRestringidos_CuentaBancaria_Numeric.DataBind();
            this.Sql_Monedas_Moneda_Numeric.DataBind(); 

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

        // ------------------------------------------------------------------------------------
        // restituímos los defaults en opciones que no forman parte del filto Sql, pero que 
        // representan opciones de ejecución para el listado y tienen valores por defecto 

        //MostrarCuentasSinSaldoYSinMvtos_CheckBox.Checked = false;
        //MostrarCuentasConSaldoYSinMvtos_CheckBox.Checked = true; 
    }
    protected void AplicarFiltro_Button_Click(object sender, EventArgs e)
    {
        if (this.Sql_Companias_Numero_Numeric.SelectedIndex == -1)
        {
            // el usuario debe siempre seleccionar, al menos, una compañía en la lista 
            ErrMessage_Span.InnerHtml = "Ud. debe seleccionar una Cia Contab de la lista.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        // nótese como excluímos el item dPagos.FechaPago, que tratamos en forma separada más adelante 
        BuildSqlCriteria MyConstruirCriterioSql = new BuildSqlCriteria();
        MyConstruirCriterioSql.ContruirFiltro(this.Controls);
        string sSqlSelectString = MyConstruirCriterioSql.CriterioSql;
        MyConstruirCriterioSql = null;

        sSqlSelectString = sSqlSelectString.Replace("DisponibilidadMontosRestringidos", "Disponibilidad_MontosRestringidos");

        if (SuspendidaFlag_DropDownList.SelectedItem.ToString() != "")
        {
            switch (SuspendidaFlag_DropDownList.SelectedValue)
            {
                case "1": sSqlSelectString = sSqlSelectString + " And (SuspendidoFlag = 1)"; break;
                case "0": sSqlSelectString = sSqlSelectString + " And (SuspendidoFlag = 0)"; break;
            }
        }

        Session["FiltroForma"] = sSqlSelectString;


        // -------------------------------------------------------------------------------------------
        // para guardar el contenido de los controles de la página para recuperar el state cuando 
        // se abra la proxima vez 

        KeepPageState MyKeepPageState = new KeepPageState(User.Identity.Name, this.GetType().Name.ToString());
        MyKeepPageState.SavePageStateInFile(this.Controls);
        MyKeepPageState = null;

        // ------------------------------------------------------------------------------------------------------
        // nótese lo que hacemos aquí para que RegisterStartupScript funcione cuando ejecutamos en Chrome ... 
        ScriptManager.RegisterStartupScript(this, this.GetType(),
            "CloseWindowScript",
            "<script language='javascript'>window.opener.RefreshPage(); window.close();</script>", false);
        // ---------------------------------------------------------------------------------------------
    }
}
