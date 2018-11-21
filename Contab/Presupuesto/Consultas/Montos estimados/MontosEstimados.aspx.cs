using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Web.UI.HtmlControls;
using ContabSysNet_Web.ModelosDatos;

public partial class Contab_Presupuesto_Consultas_Montos_estimados_MontosEstimados : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ErrMessage_Span.InnerHtml = "";
        ErrMessage_Span.Style["display"] = "none";

        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        Master.Page.Title = "Control de presupuesto - Consulta de montos estimados";

        if (!Page.IsPostBack)
        {
            //Gets a reference to a Label control that is not in a 
            //ContentPlaceHolder control

            HtmlContainerControl MyHtmlSpan;

            MyHtmlSpan = (HtmlContainerControl)(Master.FindControl("AppName_Span"));
            if (MyHtmlSpan != null)
                MyHtmlSpan.InnerHtml = "Contab";

            HtmlGenericControl MyHtmlH2;

            MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
            if (MyHtmlH2 != null)
                MyHtmlH2.InnerHtml = "Presupuesto - Consulta de montos estimados";

            //--------------------------------------------------------------------------------------------
            //para asignar la página que corresponde al help de la página 

            HtmlAnchor MyHtmlHyperLink;
            MyHtmlHyperLink = (HtmlAnchor)Master.FindControl("Help_HyperLink");

            MyHtmlHyperLink.HRef = "javascript:PopupWin('../../../Doc/Bancos/Facturas/Consulta facturas/consulta_general_de_facturas.htm', 1000, 680)";

            Session["FiltroForma"] = null;
        }
        else 
        {
            // -------------------------------------------------------------------------
            // la página puede ser 'refrescada' por el popup; en ese caso, ejeucutamos  
            // una función que efectúa alguna funcionalidad y rebind la información 

            if (RebindFlagHiddenField.Value == "1")
            {
                RefreshAndBindInfo(); 
                RebindFlagHiddenField.Value = "0"; 
            }
            // -------------------------------------------------------------------------
        }
    }

    private void RefreshAndBindInfo()
    {

        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }


        if (Session["FiltroForma"] == null)
        {
            ErrMessage_Span.InnerHtml = "Aparentemente, Ud. no ha indicado un filtro aún.<br />Por favor indique y " + 
                "aplique un filtro antes de intentar mostrar el resultado de la consulta.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        dbContabDataContext dbContab = new dbContabDataContext();

        // --------------------------------------------------------------------------------------------
        // determinamos el mes y año fiscales, para usarlos como criterio para buscar el saldo en la tabla 
        // SaldosContables. En esta table, los saldos están para el mes fiscal y no para el mes calendario. 
        // Los meses solo varían cuando el año fiscal no es igual al año calendario 

        // --------------------------------------------------------------------------------------------
        // eliminamos el contenido de la tabla temporal 

        try
        {
            dbContab.ExecuteCommand("Delete From tTempWebReport_PresupuestoConsultaMontosEstimados Where NombreUsuario = {0}", Membership.GetUser().UserName);
        }
        catch (Exception ex)
        {
            dbContab.Dispose();

            ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos.<br />" + 
                "El mensaje específico de error es: " + ex.Message + "<br />";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        // usamos el criterio que indico el usuario para leer los códigos de presupuesto y sus montos 
        // estimados y registrar esta información en una tabla 'temporal' (tTempWebReport...) 

        var query = dbContab.ExecuteQuery<Presupuesto_Monto>(
            "Select * From Presupuesto_Montos Where " + 
            Session["FiltroForma"].ToString());

        List<tTempWebReport_PresupuestoConsultaMontosEstimado> TemporalRecords_List =
            new List<tTempWebReport_PresupuestoConsultaMontosEstimado>();
        tTempWebReport_PresupuestoConsultaMontosEstimado TemporalRecord;

        foreach (Presupuesto_Monto record in query)
        {

            TemporalRecord = new tTempWebReport_PresupuestoConsultaMontosEstimado();

            TemporalRecord.Moneda = record.Moneda;
            TemporalRecord.CiaContab = record.CiaContab;
            TemporalRecord.AnoFiscal = record.Ano;
            TemporalRecord.CodigoPresupuesto = record.CodigoPresupuesto;

            TemporalRecord.Mes01_Est = record.Mes01_Est;
            TemporalRecord.Mes02_Est = record.Mes02_Est;
            TemporalRecord.Mes03_Est = record.Mes03_Est;
            TemporalRecord.Mes04_Est = record.Mes04_Est;
            TemporalRecord.Mes05_Est = record.Mes05_Est;
            TemporalRecord.Mes06_Est = record.Mes06_Est;
            TemporalRecord.Mes07_Est = record.Mes07_Est;
            TemporalRecord.Mes08_Est = record.Mes08_Est;
            TemporalRecord.Mes09_Est = record.Mes09_Est;
            TemporalRecord.Mes10_Est = record.Mes10_Est;
            TemporalRecord.Mes11_Est = record.Mes11_Est;
            TemporalRecord.Mes12_Est = record.Mes12_Est;

            TemporalRecord.NombreUsuario = Membership.GetUser().UserName;

            TemporalRecords_List.Add(TemporalRecord);

        }

        try
        {
            dbContab.tTempWebReport_PresupuestoConsultaMontosEstimados.InsertAllOnSubmit(TemporalRecords_List); 
            dbContab.SubmitChanges();
        }

        catch (Exception ex)
        {
            dbContab.Dispose();

            ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> El mensaje específico de error es: " + ex.Message + "<br /><br />";
            ErrMessage_Span.Style["display"] = "block";
            return;
        }

        this.CiasContab_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;
        this.Monedas_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;
        this.Anos_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;
        
        CiasContab_DropDownList.DataBind();
        Monedas_DropDownList.DataBind();
        Anos_DropDownList.DataBind(); 
        
        // intentamos usar como parametros del LinqDataSource el primer item en los combos Monedas y CiasContab

        if (this.CiasContab_DropDownList.Items.Count > 0)
        {
            CiasContab_DropDownList.SelectedIndex = 0;
        }

        if (this.Monedas_DropDownList.Items.Count > 0)
        {
            Monedas_DropDownList.SelectedIndex = 0;
        }

        if (this.Anos_DropDownList.Items.Count > 0)
        {
            Anos_DropDownList.SelectedIndex = 0;
        }

        // establecemos los valores de los parámetros en el LinqDataSource 


        MontosEstimados_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = "-999";
        MontosEstimados_SqlDataSource.SelectParameters["Moneda"].DefaultValue = "-99";
        MontosEstimados_SqlDataSource.SelectParameters["AnoFiscal"].DefaultValue = "-99";

        if (CiasContab_DropDownList.SelectedValue != null && 
            CiasContab_DropDownList.SelectedValue.ToString() != "")
            MontosEstimados_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = 
                CiasContab_DropDownList.SelectedValue.ToString();

        if (Monedas_DropDownList.SelectedValue != null && 
            Monedas_DropDownList.SelectedValue.ToString() != "")
            MontosEstimados_SqlDataSource.SelectParameters["Moneda"].DefaultValue = 
                Monedas_DropDownList.SelectedValue.ToString();

        if (Anos_DropDownList.SelectedValue != null && 
            Anos_DropDownList.SelectedValue.ToString() != "")
            MontosEstimados_SqlDataSource.SelectParameters["AnoFiscal"].DefaultValue = 
                Anos_DropDownList.SelectedValue.ToString();

        MontosEstimados_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;

        MontosEstimados_ListView.DataBind();

        dbContab.Dispose();
    }
    protected void CiasContab_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        // establecemos los valores de los parámetros en el LinqDataSource 

        MontosEstimados_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = CiasContab_DropDownList.SelectedValue.ToString();
        MontosEstimados_SqlDataSource.SelectParameters["Moneda"].DefaultValue = Monedas_DropDownList.SelectedValue.ToString();
        MontosEstimados_SqlDataSource.SelectParameters["AnoFiscal"].DefaultValue = Anos_DropDownList.SelectedValue.ToString();
        MontosEstimados_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;

        MontosEstimados_ListView.DataBind();
        MontosEstimados_ListView.SelectedIndex = -1; 
    }
    protected void Monedas_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        // establecemos los valores de los parámetros en el LinqDataSource 

        MontosEstimados_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = CiasContab_DropDownList.SelectedValue.ToString();
        MontosEstimados_SqlDataSource.SelectParameters["Moneda"].DefaultValue = Monedas_DropDownList.SelectedValue.ToString();
        MontosEstimados_SqlDataSource.SelectParameters["AnoFiscal"].DefaultValue = Anos_DropDownList.SelectedValue.ToString();
        MontosEstimados_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;

        MontosEstimados_ListView.DataBind();
        MontosEstimados_ListView.SelectedIndex = -1; 
    }
    protected void Anos_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        MontosEstimados_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = CiasContab_DropDownList.SelectedValue.ToString();
        MontosEstimados_SqlDataSource.SelectParameters["Moneda"].DefaultValue = Monedas_DropDownList.SelectedValue.ToString();
        MontosEstimados_SqlDataSource.SelectParameters["AnoFiscal"].DefaultValue = Anos_DropDownList.SelectedValue.ToString();
        MontosEstimados_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;

        MontosEstimados_ListView.DataBind();
        MontosEstimados_ListView.SelectedIndex = -1; 
    }
    protected void MontosEstimados_ListView_PagePropertiesChanged(object sender, EventArgs e)
    {
        MontosEstimados_ListView.SelectedIndex = -1; 
    }

    public string Fix_URL(string sCiaContab, string sCodigoPresupuesto, string sNombreCodigoPresupuesto)
    {
        // Do whatever it takes to change oldURL

        return "javascript:PopupWin('../Mensual/ConsultaPresupuesto_ConsultaCuentasContables.aspx?CiaContab=" + sCiaContab + 
            "&CodigoPresupuesto=" + sCodigoPresupuesto + 
            "&NombreCodigoPresupuesto=" + sNombreCodigoPresupuesto + "', 1000, 680)";
    }
}
