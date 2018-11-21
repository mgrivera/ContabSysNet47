using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ContabSysNetWeb.Contab.Consultas_contables.Cuentas_y_movimientos
{
    public partial class CuentasYMovimientos_OpcionesReportes : System.Web.UI.Page
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

                if (string.IsNullOrEmpty(this.reportOptionsUserControl.Titulo))
                    this.reportOptionsUserControl.Titulo = "Cuentas contables y sus movimientos";
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

            StringBuilder pageParams = new StringBuilder("rpt=cuentasymovimientos");

            pageParams.Append("&opc=0");
            pageParams.Append("&tit=" + this.reportOptionsUserControl.Titulo); 
            pageParams.Append("&subtit=" + this.reportOptionsUserControl.SubTitulo);
            pageParams.Append("&format=" + this.reportOptionsUserControl.Format);
            pageParams.Append("&orientation=" + this.reportOptionsUserControl.Orientation);
            pageParams.Append("&color=" + this.reportOptionsUserControl.Colors.ToString());
            pageParams.Append("&simpleFont=" + this.reportOptionsUserControl.MatrixPrinter.ToString());

            if (this.SaltoPaginaCuentasContables_RadioButton.Checked)
                pageParams.Append("&saltoPagina=cuentaContable");

            Response.Redirect("~/ReportViewer.aspx?" + pageParams.ToString());
        }
    }
}