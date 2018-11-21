using System;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.Security;

public partial class Contab_Presupuesto_Configuracion : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       if (!User.Identity.IsAuthenticated)
       {
            FormsAuthentication.SignOut(); 
            return; 
       }
            
        // -----------------------------------------------------------------------------------------

        Master.Page.Title = "Presupuesto - Configuración del control de presupuesto";

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
                MyHtmlH2.InnerHtml = "Presupuesto - Configuración del control de presupuesto";

            //--------------------------------------------------------------------------------------------
            //para asignar la página que corresponde al help de la página 

            HtmlAnchor MyHtmlHyperLink;
            MyHtmlHyperLink = (HtmlAnchor)Master.FindControl("Help_HyperLink");

            MyHtmlHyperLink.HRef = "javascript:PopupWin('../../../Doc/Bancos/Facturas/Consulta facturas/consulta_general_de_facturas.htm', 1000, 680)";

            Session["FiltroForma"] = null;
        }
        else
        {
        }
    }
}
