using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security; 

namespace ContabSysNetWeb
{
    public partial class LoginForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ErrMessage_Span.InnerHtml = "";
            ErrMessage_Span.Style["display"] = "none";

            // -------------------------------------------------------------------------------------------
            // buscamos el rol Administradores y verificamos que tenga usuarios ... de no ser así, lo más 
            // probable es que el sistema se haya recién instalado y estas credenciales son necesarias para 
            // poder iniciar el uso de la aplicación

            if (!Roles.RoleExists("Administradores") || 
                Roles.GetUsersInRole("Administradores").Count() == 0)
            {
                if (!Roles.RoleExists("Administradores"))
                    Roles.CreateRole("Administradores");



                if (Membership.GetUser("Administrador") == null)
                {
                    MembershipUser newUser = Membership.CreateUser("Administrador", "administrador", "adm@server.com");
                }

                Roles.AddUserToRole("Administrador", "Administradores");

                ErrMessage_Span.InnerHtml = "<br />" +
                    "NOTA IMPORTANTE: hemos encontrado que no existe el rol Administradores o el mismo no " +
                    "tiene usuarios asociados.<br />" +
                    "La razón de esta situación es, probablemente, que se está iniciando el uso de la aplicación.<br />" +
                    "Se ha creado un rol 'Administradores' y se ha agregado el usuario 'Administrador' " + 
                    "(password: administrador) al mismo.<br />" +
                    "De resultar adecuado, Ud. puede hacer un login ahora usando este usuario.<br /><br />";
                ErrMessage_Span.Style["display"] = "block";
            }

            if (!(Membership.GetAllUsers().Count == 0))
            {
                // solo cuando no existen usuarios registrados, permitimos agregar un usuario a la aplicación
                Login1.CreateUserText = "";
            }

            TextBox tb = (TextBox)Login1.FindControl("UserName");
            tb.Focus();
        }

        protected void Login1_LoggedIn(object sender, EventArgs e)
        {
            // we shouldn't have to do this
            // but I'm finding that the page doesn't always redirect
            Response.Redirect(Login1.DestinationPageUrl);
        }
    }
}
