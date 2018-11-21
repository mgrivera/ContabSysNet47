using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security; 

public partial class Otros_CambiarPassword : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.Page.Title = "ContabSysNet  -  Cambiar password"; 

        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            Response.Redirect("LoginForm.aspx");
        }
    }
}
