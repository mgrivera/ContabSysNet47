using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace ContabSysNet_Web.Areas.Main.Controllers
{
    public class HomeController : Controller
    {
        // GET: Main/Home
        public ActionResult Index()
        {
            var roles = Roles.GetRolesForUser();
            return View(roles);
        }

        public string logout()
        {
            //WebSecurity.Logout();
            //return RedirectToAction("Index", "Home");

            Session.Abandon();
            Response.Redirect("~/LoginForm.aspx?mode=logout");

            // nota: este return no se ejecutará; que usar en estos casos ??? 
            // recuérdese que, ahora en esta aplicación, se usa web forms, solo algunas páginas usar mvc (???) 
            return "null"; 
        }
    }
}