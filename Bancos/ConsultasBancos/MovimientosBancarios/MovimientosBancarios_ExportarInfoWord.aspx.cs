using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;

namespace ContabSysNet_Web.Bancos.ConsultasBancos.MovimientosBancarios
{
    public partial class MovimientosBancarios_ExportarInfoWord : System.Web.UI.Page
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
            }
        }

        protected void Ok_Button_Click(object sender, EventArgs e)
        {
            // -------------------------------------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando se abra la proxima vez 

            if (this.TipoProceso_DropDownList.SelectedIndex == 0)
                return; 

            ListItem item = this.TipoProceso_DropDownList.SelectedItem;

            switch (item.Text)
            {
                case "Ordenes de pago":
                    {
                        Response.Redirect("MovimientosBancarios_OrdenesPago.aspx");
                        break; 
                    }
            }
        }
    }
}