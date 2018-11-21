using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ContabSysNet_Web.Contab.Consultas_contables.BalanceComprobacion
{
    public partial class BalanceComprobacion_OpcionesReportes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                // intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros
                if (!(Membership.GetUser().UserName == null))
                {
                    KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
                    MyKeepPageState.ReadStateFromFile(this, this.Controls);
                    MyKeepPageState = null;
                }

                // al menos por ahora, el balance de comprobación tiene una sola forma de presentación: horizontal (portrait) 
                this.reportOptionsUserControl.MostrarOrientation = false;

                if (string.IsNullOrEmpty(this.reportOptionsUserControl.Titulo))
                    this.reportOptionsUserControl.Titulo = "Balance de Comprobación"; 
            }
        }

        protected void Ok_Button_Click(object sender, EventArgs e)
        {
            // --------------------------------------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando se abra la proxima vez
            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
            MyKeepPageState.SavePageStateInFile(this.Controls);
            MyKeepPageState = null;
            // --------------------------------------------------------------------------------------------------------------------------

            StringBuilder pageParams = new StringBuilder("rpt=balancecomprobacion");

            pageParams.Append("&tit=" + this.reportOptionsUserControl.Titulo);
            pageParams.Append("&subtit=" + this.reportOptionsUserControl.SubTitulo);
            pageParams.Append("&format=" + this.reportOptionsUserControl.Format);
            pageParams.Append("&orientation=" + this.reportOptionsUserControl.Orientation);
            pageParams.Append("&color=" + this.reportOptionsUserControl.Colors.ToString());
            pageParams.Append("&simpleFont=" + this.reportOptionsUserControl.MatrixPrinter.ToString());
            pageParams.Append("&mostrarTotales=" + (this.Totales_SoloNivelAnterior_RadioButton.Checked ? "nivelAnterior" : "todosLosNiveles"));

            Response.Redirect("~/ReportViewer.aspx?" + pageParams.ToString());
        }
    }
}