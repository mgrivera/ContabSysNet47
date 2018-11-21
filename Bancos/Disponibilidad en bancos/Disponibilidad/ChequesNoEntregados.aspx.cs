using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls; 
using System.Web.Security;

public partial class Bancos_Disponibilidad_en_bancos_Disponibilidad_ChequesNoEntregados : System.Web.UI.Page
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

        // -----------------------------------------------------------------------------------------

        Master.Page.Title = "Consulta de cheques no entregados";

        if (!Page.IsPostBack)
        {
            //Gets a reference to a Label control that is not in a 
            //ContentPlaceHolder control

            HtmlContainerControl MyHtmlSpan;

            MyHtmlSpan = (HtmlContainerControl)(Master.FindControl("AppName_Span"));
            if (MyHtmlSpan != null)
                MyHtmlSpan.InnerHtml = "Bancos";

            HtmlGenericControl MyHtmlH2;

            MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
            if (MyHtmlH2 != null)
                MyHtmlH2.InnerHtml = "Consulta de cheques no entregados";

            //--------------------------------------------------------------------------------------------
            //para asignar la página que corresponde al help de la página 

            HtmlAnchor MyHtmlHyperLink;
            MyHtmlHyperLink = (HtmlAnchor)Master.FindControl("Help_HyperLink");

            MyHtmlHyperLink.HRef = "javascript:PopupWin('../../../Doc/Bancos/Facturas/Consulta facturas/consulta_general_de_facturas.htm', 1000, 680)";

            Session["FiltroForma"] = null;

            // para que la lista se muestra vacía inicialmente 

            ChequesNoEntregados_SqlDataSource.SelectCommand += " Where 1 = 2"; 

        }
        else
        {
            //-------------------------------------------------------------------------
            // la página puede ser 'refrescada' por el popup; en ese caso, ejeucutamos  
            // una función que efectúa alguna funcionalidad y rebind la información 

            if (this.RebindFlagHiddenField.Value == "1")
            {
                RebindFlagHiddenField.Value = "0";
                RefreshAndBindInfo();
            }
            else
            {
                // nótese como, para cada postback, debemos aplicar el filtro y hacer el databind 
                ChequesNoEntregados_SqlDataSource.SelectCommand +=
                " Where (MovimientosBancarios.Tipo = 'CH') And (MovimientosBancarios.FechaEntregado Is Null) And " + Session["FiltroForma"].ToString();
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
            ErrMessage_Span.InnerHtml = "Aparentemente, Ud. no ha indicado un filtro aún.<br />Por favor indique y aplique un filtro antes de intentar mostrar el resultado de la consulta.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        ChequesNoEntregados_SqlDataSource.SelectCommand +=
                " Where (MovimientosBancarios.Tipo = 'CH') And (MovimientosBancarios.FechaEntregado Is Null) And " + Session["FiltroForma"].ToString();

        ChequesNoEntregados_ListView.DataBind();
    }
    protected void ChequesNoEntregados_ListView_ItemUpdating(object sender, ListViewUpdateEventArgs e)
    {
        // convertimos el valor indicado por el usuario a datetime 

        System.Globalization.CultureInfo culture;
        System.Globalization.DateTimeStyles styles;
        DateTime dateResult;
        String sCultureName = System.Threading.Thread.CurrentThread.CurrentCulture.Name;

        culture = System.Globalization.CultureInfo.CreateSpecificCulture(sCultureName);
        styles = System.Globalization.DateTimeStyles.None;

        if (!(e.NewValues["FechaEntregado"] == null) &&
            DateTime.TryParse(e.NewValues["FechaEntregado"].ToString(), culture, styles, out dateResult))
        {
            e.NewValues["FechaEntregado"] = dateResult;
        }
        else
        {
            ErrMessage_Span.InnerHtml = "Aparentemente, el valor indicado para la fecha no es válido.";
            ErrMessage_Span.Style["display"] = "block";

            e.Cancel = true;
        }
    }
}
