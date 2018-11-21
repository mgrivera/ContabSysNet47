using System;
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using System.Linq;
using System.Globalization;
using System.Web.UI.HtmlControls;

namespace ContabSysNetWeb.Bancos.Disponibilidad_en_bancos.Disponibilidad
{
    public partial class Bancos_ConsultaDisponibilidad_OpcionesReportes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                if (!User.Identity.IsAuthenticated)
                {
                    FormsAuthentication.SignOut();
                    return;
                }

                HtmlGenericControl MyHtmlH2;
                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    MyHtmlH2.InnerHtml = "Reporte - Opciones";
                }

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

        protected void ObtenerReporte_Button_Click(object sender, EventArgs e)
        {
            // -------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando 
            // se abra la proxima vez 

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
            MyKeepPageState.SavePageStateInFile(this.Controls);
            MyKeepPageState = null;
            // ---------------------------------------------------------------------------------------------

            string dosCols = "no";
            if (this.DosColumnas_CheckBox.Checked) dosCols = "si"; 
 
            Response.Redirect("~/ReportViewer.aspx?rpt=disponibilidad&dosCols=" + dosCols);
        }
    }
}
