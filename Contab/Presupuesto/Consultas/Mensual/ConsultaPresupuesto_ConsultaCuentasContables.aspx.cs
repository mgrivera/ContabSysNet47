using System;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.Security; 

public partial class Contab_Presupuesto_Consultas_Mensual_ConsultaPresupuesto_ConsultaCuentasContables : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        ConsultaCuentasContables_SqlDataSource.SelectParameters["CiaContab"].DefaultValue = 
            Request.QueryString["CiaContab"].ToString();
        ConsultaCuentasContables_SqlDataSource.SelectParameters["CodigoPresupuesto"].DefaultValue = 
            Request.QueryString["CodigoPresupuesto"].ToString();

        ConsultaCuentasContables_ListView.DataBind();

        // -----------------------------------------------------------------------------------------

        Master.Page.Title = "Consulta de presupuesto  -  consulta de cuentas contables asociadas a un código de presupuesto";

        if (!Page.IsPostBack)
        {
            HtmlGenericControl MyHtmlH2;

            MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
            if (MyHtmlH2 != null)
                MyHtmlH2.InnerHtml = "";

            TituloConsulta_H2.InnerHtml = "Cuentas contables asociadas al código de presupuesto<br />" +
                            Request.QueryString["CodigoPresupuesto"].ToString() + "&nbsp;&nbsp;&nbsp;" + Request.QueryString["NombreCodigoPresupuesto"].ToString();
        }
        else
        {
        }
    }
}
