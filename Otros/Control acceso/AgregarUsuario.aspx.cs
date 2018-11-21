using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security; 

public partial class Otros_Control_acceso_AgregarUsuario : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.Page.Title = "ContabSysNet  -  Actualizar usuarios de la aplicación";

        ErrMessage_Span.InnerHtml = "";
        ErrMessage_Span.Style["display"] = "none";

        if (!(Membership.GetAllUsers().Count == 0)) 
            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                Response.Redirect("~/LoginForm.aspx");
            }
    }
    protected void Usuarios_GridView_RowUpdated(object sender, GridViewUpdatedEventArgs e)
    {
        if (!(e.Exception == null))
        {
            ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar actualizar la información (<b>nota</b>: es probable que la información que Ud. está indicando ya exista para algún otro usuario).<br />El mensaje específico de error es: <br /><br />" + e.Exception.Message;
            ErrMessage_Span.Style["display"] = "block";
            
            e.ExceptionHandled = true;
            e.KeepInEditMode = true;
        }
    }
}
