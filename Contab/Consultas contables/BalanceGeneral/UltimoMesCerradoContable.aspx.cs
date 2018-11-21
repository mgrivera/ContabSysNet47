using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ContabSysNetWeb.Contab.Consultas_contables.BalanceGeneral
{
    public partial class UltimoMesCerradoContable : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["BalanceGeneral_Parametros"] == null)
            {
                //string errorMessage = "Aparentemente, Ud. no ha definido un filtro para esta consulta. " + 
                //    "Por favor defina un filtro para esta consulta antes de continuar.";

                //CustomValidator1.IsValid = false;
                //CustomValidator1.ErrorMessage = errorMessage;

                //return;
            }
        }
    }
}
