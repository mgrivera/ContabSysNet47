using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.Security; 

namespace ContabSysNetWeb.Contab.Presupuesto.Consultas.Anual
{
    public partial class ConsultaPresupuesto_FactoresConversionAplicados : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            FactoresConversionAplicados_SqlDataSource.SelectParameters["NombreUsuario"].
                DefaultValue = User.Identity.Name; 
        }
    }
}
