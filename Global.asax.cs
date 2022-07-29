using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.DynamicData;
using System.Web.Mvc;
using System.Web.Http;
using TiendasWebAppMvc;

namespace ContabSysNet_Web
{
    public class Global : System.Web.HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup

            // Create an instance of the data model. 
            MetaModel DefaultModel = new MetaModel();
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
        }

        void Application_End(object sender, EventArgs e)
        {
            //  Code that runs on application shutdown

        }

        void Application_Error(object sender, EventArgs e)
        {
            // Code that runs when an unhandled error occurs

        }

        void Session_Start(object sender, EventArgs e)
        {
            // Code that runs when a new session is started

        }

        void Session_End(object sender, EventArgs e)
        {
            // Code that runs when a session ends. 
            // Note: The Session_End event is raised only when the sessionstate mode
            // is set to InProc in the Web.config file. If session mode is set to StateServer 
            // or SQLServer, the event is not raised.

        }

        void Application_AuthenticateRequest(object sender, EventArgs e)
        {
            if (Request.IsAuthenticated)
            {
                // Get the role from the ticket  
                string[] role = new string[1];
                role[0] = ((FormsIdentity)Context.User.Identity).Ticket.UserData;

                // Create a new GenericPrincipal with the role information  
                System.Security.Principal.GenericPrincipal newPrincipal = new System.Security.Principal.GenericPrincipal(Context.User.Identity, role);

                // Add the principal to the security context, which replaces the current GenericPrincipal  
                Context.User = newPrincipal;
            }
        }
    }
}
