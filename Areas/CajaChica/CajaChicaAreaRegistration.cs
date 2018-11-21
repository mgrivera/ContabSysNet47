using System.Web.Mvc;

namespace ContabSysNet_Web.Areas.CajaChica
{
    public class CajaChicaAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "CajaChica";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                "CajaChica_default",
                "CajaChica/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}