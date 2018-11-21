using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security; 

public partial class Otros_Control_acceso_Roles : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Master.Page.Title = "ContabSysNet  -  Actualizar roles de la aplicación";

        ErrMessage_Span.InnerHtml = "";
        ErrMessage_Span.Style["display"] = "none";

        //if (!User.Identity.IsAuthenticated)
        //{
        //    FormsAuthentication.SignOut();
        //    Response.Redirect("LoginForm.aspx");
        //}
    }
    protected void Roles_ListView_ItemInserted(object sender, ListViewInsertedEventArgs e)
    {
        if (!(e.Exception == null))
        {
            ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar actualizar la información (<b>nota</b>: es probable que la información que Ud. está indicando ya exista).<br />El mensaje específico de error es: <br /><br />" + e.Exception.InnerException.Message;
            ErrMessage_Span.Style["display"] = "block";

            e.ExceptionHandled = true;
            e.KeepInInsertMode = true;
        }
    }
    protected void Roles_ListView_ItemDeleted(object sender, ListViewDeletedEventArgs e)
    {
        if (!(e.Exception == null))
        {
            ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar efectuar una operación en la base de datos.<br />El mensaje específico de error es: <br /><br />" + e.Exception.InnerException.Message;
            ErrMessage_Span.Style["display"] = "block";

            e.ExceptionHandled = true;
        }
    }
}
