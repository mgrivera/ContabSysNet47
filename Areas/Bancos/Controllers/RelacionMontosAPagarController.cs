using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ContabSysNet_Web.Areas.Bancos.Controllers
{
    public class RelacionMontosAPagarController : Controller
    {
        // GET: Bancos/RelacionMontosAPagar
        public ActionResult Index(string cuentaBancaria)
        {

            // pasamos, de una forma muy simple, el código del banco al view 

            ViewData["cuentaBancariaID"] = cuentaBancaria; 
            return View();
        }
    }
}