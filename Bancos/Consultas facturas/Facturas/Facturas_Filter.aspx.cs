using System;
using System.Web.UI;
using System.Web.Security;
using System.Web.UI.HtmlControls;
using ContabSysNet_Web.ModelosDatos_EF.Users;
using System.Collections.Generic;
using System.Linq;
using ContabSysNet_Web.Clases;

public partial class Bancos_Facturas_Facturas_Filter : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.Page.Title = "... defina un filtro y haga un click en Aplicar Filtro para aplicarlo";
        this.Page.Header.DataBind();    // NOTE: this resolves any <%# ... %> tags in <head>

        ErrMessage_Span.InnerHtml = "";
        ErrMessage_Span.Style["display"] = "none";

        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        if (!Page.IsPostBack)
        {
            // quitamos el asterisco al nombre del proveedor, para que el usuario no lo vea; el asterisco lo pone 
            // en forma automática el programa, para que la busqueda por nombre de proveedor siempre sea 'genérica' ... 

            if (!string.IsNullOrEmpty(this.Sql_Proveedores_Nombre_String.Text))
                this.Sql_Proveedores_Nombre_String.Text = this.Sql_Proveedores_Nombre_String.Text.Replace("*", "");
            // -------------------------------------------------------------------------------------------------------------------

            HtmlGenericControl MyHtmlH2;
            MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
            if (!(MyHtmlH2 == null))
            {
                MyHtmlH2.InnerHtml = "... indique un criterio de selección y haga un click en <b><em>Aplicar filtro</em></b>";
            }

            // usamos una clase para construir una lista con las compañías (Contab) que se han asignado al usuario 
            ConstruirListaCompaniasAsignadas listaCiasContabAsignadas = new ConstruirListaCompaniasAsignadas();
            this.Sql_Facturas_Cia_Numeric.DataSource = listaCiasContabAsignadas.GetListaCompaniasAsignadas();

            //  pareciera que si no hacemos el databind para los listboxes aqu�, la clase que regresa el state 
            //  encuentra estos controles sin sus datos 
            this.Sql_Facturas_Moneda_Numeric.DataBind();
            this.Sql_Facturas_Cia_Numeric.DataBind();
            this.Sql_Facturas_Proveedor_String.DataBind();
            this.Sql_Facturas_Tipo_Numeric.DataBind();
            this.Sql_Facturas_CondicionesDePago_Numeric.DataBind();
            // -------------------------------------------------------------------------------------------------------------------
            //  intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros 

            if (!(Membership.GetUser().UserName == null))
            {
                KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
                MyKeepPageState.ReadStateFromFile(this, this.Controls);
                MyKeepPageState = null;
            }
        }
    }

    protected void LimpiarFiltro_Button_Click(object sender, EventArgs e)
    {
        LimpiarFiltro  MyLimpiarFiltro = new LimpiarFiltro(this); 
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
        if (Sql_Facturas_Cia_Numeric.SelectedIndex == -1)
        {
            // el usuario debe siempre seleccionar, al menos, una compañía en la lista 
            ErrMessage_Span.InnerHtml = "Ud. debe seleccionar una Cia Contab de la lista.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        // nótese como excluímos el item dPagos.FechaPago, que tratamos en forma separada más adelante 

        // para que la busqueda por nombre de compañía siempre sea 'genérica' 

        if (!string.IsNullOrEmpty(this.Sql_Proveedores_Nombre_String.Text))
        {
            this.Sql_Proveedores_Nombre_String.Text = this.Sql_Proveedores_Nombre_String.Text.Replace("*", "");
            this.Sql_Proveedores_Nombre_String.Text = "*" + this.Sql_Proveedores_Nombre_String.Text.Trim() + "*"; 
        }

        BuildSqlCriteria MyConstruirCriterioSql = new BuildSqlCriteria("E", "Sql_pg_Fecha_Date");
        MyConstruirCriterioSql.ContruirFiltro(this.Controls);
        string sSqlSelectString = MyConstruirCriterioSql.CriterioSql;
        MyConstruirCriterioSql = null;

        if (MostrarSoloFacturasRetencionISLR_CheckBox.Checked)
            sSqlSelectString = sSqlSelectString + " And (Facturas.ImpuestoRetenido Is Not Null And Facturas.ImpuestoRetenido <> 0)";

        if (AfectaLibroCompras_CheckBox.Checked)
            sSqlSelectString = sSqlSelectString + " And (Proveedores.AfectaLibroComprasFlag Is Not Null And Proveedores.AfectaLibroComprasFlag = 1)";

        if (MostrarSoloFacturasRetencionIva_CheckBox.Checked)
            sSqlSelectString = sSqlSelectString + " And (Facturas.RetencionSobreIva Is Not Null And Facturas.RetencionSobreIva <> 0)"; 

        if (this.SoloNotasCredito_CheckBox.Checked)
            sSqlSelectString = sSqlSelectString + " And (Facturas.NcNdFlag Is Not Null And Facturas.NcNdFlag = 'NC')"; 
        
        //sSqlSelectString = sSqlSelectString.Replace("Proveedor2", "Proveedor");

        // si el usuario quiere SOLO facturas desde el CCCh, invalidamos este filtro para que 
        // no salgan facturas regulares en la consulta 

        if (LeerSoloFacturasControlCajaChica_CheckBox.Checked)
            sSqlSelectString += " And (1 = 2)"; 

        // tratamos el item dPagos.FechaPago 

        MyConstruirCriterioSql = new BuildSqlCriteria("I", "Sql_pg_Fecha_Date");
        MyConstruirCriterioSql.ContruirFiltro(this.Controls);
        string sSqlSelectString2 = MyConstruirCriterioSql.CriterioSql;
        MyConstruirCriterioSql = null;

        // por ahora, permitirmos al usuario una sola opción para consultar facturas con impuestos o retenciones varias; en un futuro, 
        // deben ser dos opciones separadas ... 
        if (this.MostrarSoloFacturasOtrosImpuestos_CheckBox.Checked)
            sSqlSelectString = sSqlSelectString + " And ((Facturas.OtrosImpuestos Is Not Null And Facturas.OtrosImpuestos <> 0) Or " + 
                "(Facturas.OtrasRetenciones Is Not Null And Facturas.OtrasRetenciones <> 0))"; 

        if (sSqlSelectString2 != "1 = 1")
            sSqlSelectString = sSqlSelectString + " And Facturas.ClaveUnica In " +
                "(Select cf.ClaveUnicaFactura From CuotasFactura cf Inner Join dPagos dp On cf.ClaveUnica = dp.ClaveUnicaCuotaFactura " +
                "Inner Join Pagos pg On dp.ClaveUnicaPago = pg.ClaveUnica Where " + 
                sSqlSelectString2 + ")"; 

        Session["FiltroForma"] = sSqlSelectString;
        Session["Report_SubTitle"] = Report_SubTitle_TextBox.Text; 


        // ------------------------------------------------------------------------------------------- 
        // si el usuario quiere incluir facturas desde el CCCh, debe indicar un período en el item 
        // FPago 

        Session["FiltroForma_LeerFacturasCCCh"] = "";

        if (LeerFacturasControlCajaChica_CheckBox.Checked)
        {
            if (Sql_Facturas_FechaRecepcion_Date.Text == "")
            {
                ErrMessage_Span.InnerHtml = "Ud. debe indicar un período para seleccionar las facturas en el item 'F recepción'.<br /><br />Si Ud. indica que desea incluir las facturas registradas en el control de caja chica, debe indicar un período de selección para las mismas en el item 'F recepción'.";
                ErrMessage_Span.Style["display"] = "block";

                return; 
            }

            // construimos un filtro solo con los items FechaRecepción y CiaContab, para leer las 
            // facturas registradas en el Control de Caja Chica 

            MyConstruirCriterioSql = new BuildSqlCriteria("I", "Sql_Facturas_FechaRecepcion_Date, Sql_Facturas_Cia_Numeric");
            MyConstruirCriterioSql.ContruirFiltro(this.Controls);
            sSqlSelectString2 = MyConstruirCriterioSql.CriterioSql;
            MyConstruirCriterioSql = null;

            sSqlSelectString2 = sSqlSelectString2.Replace("Facturas", "CajaChica_Reposiciones_Gastos");
            sSqlSelectString2 = sSqlSelectString2.Replace("FechaRecepcion", "FechaDocumento");
            sSqlSelectString2 = sSqlSelectString2.Replace("Cia", "CiaContab"); 

            Session["FiltroForma_LeerFacturasCCCh"] = sSqlSelectString2;
        }

        // ------------------------------------------------------------------------------------------- 


        
        // -------------------------------------------------------------------------------------------
        // para guardar el contenido de los controles de la página para recuperar el state cuando 
        // se abra la proxima vez 

        KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
        MyKeepPageState.SavePageStateInFile(this.Controls);
        MyKeepPageState = null;
        // ---------------------------------------------------------------------------------------------

        //System.Text.StringBuilder sb = new System.Text.StringBuilder();
        //sb.Append("window.opener.RefreshPage();");
        //sb.Append("window.close();");

        //ClientScript.RegisterClientScriptBlock(this.GetType(), "CloseWindowScript", sb.ToString(), true); 

        // ------------------------------------------------------------------------------------------------------
        // nótese lo que hacemos aquí para que RegisterStartupScript funcione cuando ejecutamos en Chrome ... 
        ScriptManager.RegisterStartupScript(this, this.GetType(),
            "CloseWindowScript",
            "<script language='javascript'>window.opener.RefreshPage(); window.close();</script>", false); 
        
    }
}
