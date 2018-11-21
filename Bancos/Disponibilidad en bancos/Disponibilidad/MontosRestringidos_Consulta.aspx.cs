using System;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.Security; 

public partial class Bancos_Disponibilidad_en_bancos_Disponibilidad_MontosRestringidos_Consulta : System.Web.UI.Page
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

        ConsultaMontosRestringidos_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue =
            User.Identity.Name; 
        ConsultaMontosRestringidos_ListView.DataBind();

        ChequesNoEntregados_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue =
            User.Identity.Name;
        ChequesNoEntregados_ListView.DataBind(); 
        
        // -----------------------------------------------------------------------------------------

        Master.Page.Title = "Consulta de disponibilidad bancaria - consulta de montos restringidos";

        if (!Page.IsPostBack)
        {
            HtmlGenericControl MyHtmlH2;

            MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
            if (MyHtmlH2 != null)
                MyHtmlH2.InnerHtml = "";
        }
        else
        {
        }
    }
}
