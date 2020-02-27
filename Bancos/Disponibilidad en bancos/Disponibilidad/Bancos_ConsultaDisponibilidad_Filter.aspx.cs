using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Web.UI.HtmlControls;
using ContabSysNet_Web.Clases; 

public partial class Bancos_Disponibilidad_en_bancos_Disponibilidad_Bancos_ConsultaDisponibilidad_Filter : System.Web.UI.Page
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
            this.Sql_CuentasBancarias_Cia_Numeric.DataSource = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

            //  pareciera que si no hacemos el databind para los listboxes aqu�, la clase que regresa el state 
            //  encuentra estos controles sin sus datos 
            this.Sql_CuentasBancarias_Cia_Numeric.DataBind();
            this.Sql_CuentasBancarias_CuentaInterna_Numeric.DataBind();
            Sql_CuentasBancarias_CuentaInterna_Numeric.DataBind();
            
            //  intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros 

            if (!(Membership.GetUser().UserName == null))
            {
                KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
                MyKeepPageState.ReadStateFromFile(this, this.Controls);
                MyKeepPageState = null;
            }

            HtmlGenericControl MyHtmlH2;
            MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
            if (!(MyHtmlH2 == null))
            {
                MyHtmlH2.InnerHtml = "... indique un criterio de selección y haga un click en <b><em>Aplicar filtro</em></b>";
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
        if (this.Sql_CuentasBancarias_Cia_Numeric.SelectedIndex == -1)
        {
            // el usuario debe siempre seleccionar, al menos, una compañía en la lista 
            ErrMessage_Span.InnerHtml = "Ud. debe seleccionar una Cia Contab de la lista.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        // nótese como excluímos el item dPagos.FechaPago, que tratamos en forma separada más adelante 
        BuildSqlCriteria MyConstruirCriterioSql = new BuildSqlCriteria("E", "Sql_dPagos_FechaPago_Date");
        MyConstruirCriterioSql.ContruirFiltro(this.Controls);
        string sSqlSelectString = MyConstruirCriterioSql.CriterioSql;
        MyConstruirCriterioSql = null;

         // Linq es algo restrictivo en estos casos ... 

        while (sSqlSelectString.IndexOf("CuentasBancarias.") >= 0)
            sSqlSelectString = sSqlSelectString.Replace("CuentasBancarias.", "");

        Session["FiltroForma"] = sSqlSelectString;
        Session["FechaDisponibilidadAl"] = Convert.ToDateTime(FechaDisponibilidadAl_TextBox.Text); 

        // -------------------------------------------------------------------------------------------
        // para guardar el contenido de los controles de la página para recuperar el state cuando 
        // se abra la proxima vez 

        KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
        MyKeepPageState.SavePageStateInFile(this.Controls);
        MyKeepPageState = null;

        // ------------------------------------------------------------------------------------------------------
        // nótese lo que hacemos aquí para que RegisterStartupScript funcione cuando ejecutamos en Chrome ... 
        ScriptManager.RegisterStartupScript(this, this.GetType(),
            "CloseWindowScript",
            "<script language='javascript'>window.opener.RefreshPage(); window.close();</script>", false); 
        // ---------------------------------------------------------------------------------------------
    }
    protected void Sql_CuentasBancarias_Cia_Numeric_SelectedIndexChanged(object sender, EventArgs e)
    {
        // para mostrar en el listbox de cuentas bancarias solo las que corresponden a las cias contab 
        // o monedas seleccionadas  
        SeleccionarCuentasBancarias(); 
    }
    protected void Sql_CuentasBancarias_Moneda_Numeric_SelectedIndexChanged(object sender, EventArgs e)
    {
        // para mostrar en el listbox de cuentas bancarias solo las que corresponden a las cias contab 
        // o monedas seleccionadas  
        SeleccionarCuentasBancarias(); 
    }

    private void SeleccionarCuentasBancarias()
    {
        // para mostrar en el ListBox de cuentas bancarias solo las que correspondan a las cias y monedas 
        // seleccionadas 
         String MyWhereString  = ""; 

        foreach (ListItem MyListItem in Sql_CuentasBancarias_Cia_Numeric.Items)
        {
            if (MyListItem.Selected)
                if (MyWhereString == "")
                    MyWhereString = " CuentasBancarias.Cia In (" + MyListItem.Value;
                else
                    MyWhereString = MyWhereString + ", " + MyListItem.Value;
        }

        bool bFirstTime = true; 

        foreach (ListItem MyListItem in Sql_CuentasBancarias_Moneda_Numeric.Items)
        {
            if (MyListItem.Selected)

                if (MyWhereString == "") 
                {
                    MyWhereString = " CuentasBancarias.Moneda In (" + MyListItem.Value;
                    bFirstTime = false;
                }
                else
                    if (bFirstTime)
                    {
                        MyWhereString += ") And CuentasBancarias.Moneda In (" + MyListItem.Value;
                        bFirstTime = false;
                    }
                    else
                        MyWhereString = MyWhereString + ", " + MyListItem.Value;
        }

        if (MyWhereString != "")
            MyWhereString = MyWhereString + ")";
        else
            MyWhereString = "1 = 1";
        
        // nótese como reconstruímos todo el select command del listbox de monedas 

        CuentasBancarias_SqlDataSource.SelectCommand = 
        "SELECT CuentasBancarias.CuentaInterna, Bancos.Abreviatura + ' - ' + Monedas.Simbolo + ' - ' + " +
        "CuentasBancarias.CuentaBancaria + ' - ' + Companias.Abreviatura AS NombreCuentaBancaria " +
        "FROM CuentasBancarias Inner Join Agencias On CuentasBancarias.Agencia = Agencias.Agencia " +
        "INNER JOIN Bancos ON Agencias.Banco = Bancos.Banco INNER JOIN " +
        "Monedas ON CuentasBancarias.Moneda = Monedas.Moneda INNER JOIN Companias ON " +
        "CuentasBancarias.Cia = Companias.Numero WHERE (Bancos.NombreCorto IS NOT NULL) AND " +
        "(Monedas.Simbolo IS NOT NULL) AND (CuentasBancarias.CuentaBancaria IS NOT NULL) And " +
        "(Estado = 'AC') And " + MyWhereString + " " +
        "ORDER BY Bancos.NombreCorto, Monedas.Simbolo, CuentasBancarias.CuentaBancaria";

        Sql_CuentasBancarias_CuentaInterna_Numeric.DataBind();
    }
}
