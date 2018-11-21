using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

namespace ContabSysNet_Web.Bancos.ConsultasBancos.MovimientosBancarios
{
    public partial class MovimientosBancarios_OpcionesReportes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //  intentamos recuperar el state de esta página ... 

            if (!Page.IsPostBack)
            {
                if (!User.Identity.IsAuthenticated)
                {
                    FormsAuthentication.SignOut();
                    return;
                }

                if (!(Membership.GetUser().UserName == null))
                {
                    KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
                    MyKeepPageState.ReadStateFromFile(this, this.Controls);
                    MyKeepPageState = null;

                    if (string.IsNullOrEmpty(this.TituloReporte_TextBox.Text))
                        this.TituloReporte_TextBox.Text = "Movimientos bancarios - Consulta";
                }
            }
        }

        protected void Ok_Button_Click(object sender, EventArgs e)
        {
            // -------------------------------------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando se abra la proxima vez 

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
            MyKeepPageState.SavePageStateInFile(this.Controls);
            MyKeepPageState = null;

            Response.Redirect("~/ReportViewer3.aspx?rpt=movimientosbancarios&tit=" + 
                TituloReporte_TextBox.Text + "&subtit=" +
                SubTituloReporte_TextBox.Text + "&filter=" + Session["FiltroForma"].ToString());
        }
    }
}