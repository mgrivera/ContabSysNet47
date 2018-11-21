using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ContabSysNetWeb.Contab.Consultas_contables.Centros_de_costo
{
    public partial class CentrosCosto_OpcionesReportes : System.Web.UI.Page
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

                // -----------------------------------------------------------------------------------------------------------
                //  intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros 
                if (!(Membership.GetUser().UserName == null))
                {
                    KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
                    MyKeepPageState.ReadStateFromFile(this, this.Controls);
                    MyKeepPageState = null;
                }

                this.reportOptionsUserControl.MostrarSoloTotales = true; 

                if (string.IsNullOrEmpty(this.reportOptionsUserControl.Titulo))
                    this.reportOptionsUserControl.Titulo = "Contabilidad - Centros de Costo - Consulta"; 
                // -----------------------------------------------------------------------------------------------------------
            }
        }

        protected void Ok_Button_Click(object sender, EventArgs e)
        {
            // -------------------------------------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando se abra la proxima vez 

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
            MyKeepPageState.SavePageStateInFile(this.Controls);
            MyKeepPageState = null;
            // ---------------------------------------------------------------------------------------------

            StringBuilder pageParams = new StringBuilder("rpt=centroscosto");

            pageParams.Append("&tit=" + this.reportOptionsUserControl.Titulo);
            pageParams.Append("&subtit=" + this.reportOptionsUserControl.SubTitulo);
            pageParams.Append("&format=" + this.reportOptionsUserControl.Format);
            pageParams.Append("&orientation=" + this.reportOptionsUserControl.Orientation);
            pageParams.Append("&color=" + this.reportOptionsUserControl.Colors.ToString());
            pageParams.Append("&simpleFont=" + this.reportOptionsUserControl.MatrixPrinter.ToString());
            pageParams.Append("&st=" + this.reportOptionsUserControl.MostrarSoloTotales.ToString());

            Response.Redirect("~/ReportViewer.aspx?" + pageParams.ToString());
        }
    }
}