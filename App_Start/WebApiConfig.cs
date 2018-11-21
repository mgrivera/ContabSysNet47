﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Routing;

namespace TiendasWebAppMvc
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            // Web API routes
            config.MapHttpAttributeRoutes();

            // para acceder al session state en web api (usando esta route) ... 
            RouteTable.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{method}/{id}",
                defaults: new { id = RouteParameter.Optional }
            ).RouteHandler = new SessionRouteHandler();         
        }


        // nota: estas dos clases que siguen permiten implementar Session state en web api 
        public class SessionRouteHandler : System.Web.Routing.IRouteHandler
        {
            System.Web.IHttpHandler System.Web.Routing.IRouteHandler.GetHttpHandler(System.Web.Routing.RequestContext requestContext)
            {
                return new SessionControllerHandler(requestContext.RouteData);
            }
        }

        public class SessionControllerHandler : System.Web.Http.WebHost.HttpControllerHandler, System.Web.SessionState.IRequiresSessionState
        {
            public SessionControllerHandler(System.Web.Routing.RouteData routeData)
                : base(routeData)
            { }
        }
    }
}
