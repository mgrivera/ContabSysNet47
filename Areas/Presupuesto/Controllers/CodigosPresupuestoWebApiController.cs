using ContabSysNet_Web.Areas.Presupuesto.Models;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace ContabSysNet_Web.Areas.Presupuesto.Controllers
{
    public class CodigosPresupuestoWebApiController : ApiController
    {
        [HttpGet]
        public HttpResponseMessage LeerCiaContabSeleccionada()
        {
            if (!User.Identity.IsAuthenticated)
            {
                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            int ciaContabSeleccionada;
            string nombreCiaContabSeleccionada;

            using (dbContab_Contab_Entities context = new dbContab_Contab_Entities())
            {
                try
                {
                    var cia = context.tCiaSeleccionadas.Where(s => s.UsuarioLS == User.Identity.Name).
                                                        Select(c => new { ciaContabSeleccionada = c.Compania.Numero, ciaContabSeleccionadaNombre = c.Compania.Nombre }).
                                                        FirstOrDefault();

                    if (cia == null)
                    {
                        var errorResult = new
                        {
                            ErrorFlag = true,
                            ErrorMessage = "Error: aparentemente, no se ha seleccionado una <em>Cia Contab</em>.<br />" +
                                    "Por favor seleccione una <em>Cia Contab</em> y luego regrese y continúe con la ejecución de esta función."
                        };

                        return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                    }

                    nombreCiaContabSeleccionada = cia.ciaContabSeleccionadaNombre;
                    ciaContabSeleccionada = cia.ciaContabSeleccionada;
                }
                catch (Exception ex)
                {
                    string message = ex.Message;
                    if (ex.InnerException != null)
                        message += "<br />" + ex.InnerException.Message;

                    var errorResult = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                       "El mensaje específico de error es: <br />" + message
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }
            }

            var result = new
            {
                ErrorFlag = false,
                ErrorMessage = "",
                ciaContabSeleccionada = ciaContabSeleccionada,
                ciaContabSeleccionadaNombre = nombreCiaContabSeleccionada,
                nombreUsuario = User.Identity.Name
            };

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }


        [HttpGet]
        [Route("api/CodigosPresupuestoWebApi/LeerCodigosPresupuesto")]
        public HttpResponseMessage LeerCodigosPresupuesto(string filter, int ciaContabSeleccionada)
        {
            if (!User.Identity.IsAuthenticated)
            {
                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            try
            {
                // el criterio es un json, pero viene como un string 
                var filtro = new FiltroCriterios();
                filtro = JsonConvert.DeserializeObject<FiltroCriterios>(filter);

                dbContab_Contab_Entities context = new dbContab_Contab_Entities();

                var query = context.Presupuesto_Codigos.Include("CuentasContables").Where(c => c.CiaContab == ciaContabSeleccionada);

                if (!string.IsNullOrEmpty(filtro.Codigo))
                    if (filtro.Codigo.StartsWith("*"))
                        query = query.Where(c => c.Codigo.EndsWith(filtro.Codigo.Replace("*", "")));
                    else if (filtro.Codigo.EndsWith("*"))
                        query = query.Where(c => c.Codigo.StartsWith(filtro.Codigo.Replace("*", "")));
                    else 
                        query = query.Where(c => c.Codigo.Contains(filtro.Codigo));


                if (!string.IsNullOrEmpty(filtro.Descripcion))
                    if (filtro.Codigo.StartsWith("*"))
                        query = query.Where(c => c.Descripcion.EndsWith(filtro.Descripcion.Replace("*", "")));
                    else if (filtro.Codigo.EndsWith("*"))
                        query = query.Where(c => c.Descripcion.StartsWith(filtro.Descripcion.Replace("*", "")));
                    else
                        query = query.Where(c => c.Descripcion.Contains(filtro.Descripcion));

                if (filtro.CantNiveles != null)
                    query = query.Where(c => c.CantNiveles == filtro.CantNiveles.Value);

                if (!string.IsNullOrEmpty(filtro.Grupo) && filtro.Grupo != "todos")
                    if (filtro.Grupo == "si")
                        query = query.Where(c => c.GrupoFlag);
                    else
                        query = query.Where(c => !c.GrupoFlag);

                if (!string.IsNullOrEmpty(filtro.Suspendido) && filtro.Suspendido != "todos")
                    if (filtro.Suspendido == "si")
                        query = query.Where(c => c.SuspendidoFlag);
                    else
                        query = query.Where(c => !c.SuspendidoFlag);


                CodigoPresupuesto codigoPresupuesto;
                List<CodigoPresupuesto> codigosPreupuesto = new List<CodigoPresupuesto>();

                foreach (var codigo in query)
                {
                    codigoPresupuesto = new CodigoPresupuesto()
                    {
                        Codigo = codigo.Codigo,
                        Descripcion = codigo.Descripcion,
                        CantNiveles = codigo.CantNiveles,
                        GrupoFlag = codigo.GrupoFlag,
                        SuspendidoFlag = codigo.SuspendidoFlag
                    };

                    foreach (var cuentaContable in codigo.CuentasContables)
                    {
                        codigoPresupuesto.CuentasContables.Add(new CodigoPresupuesto_CuentaContable
                        {
                            ID = cuentaContable.ID,
                            Cuenta = cuentaContable.CuentaEditada,
                            Descripcion = cuentaContable.Descripcion
                        });
                    }

                    codigosPreupuesto.Add(codigoPresupuesto);
                }

                var result = new
                {
                    ErrorFlag = false,
                    ErrorMessage = "",
                    CodigosPresupuesto = codigosPreupuesto.OrderBy(c => c.Codigo)
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                   "El mensaje específico de error es: <br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }
        }


        [HttpPost]
        [Route("api/CodigosPresupuestoWebApi/GrabarItemsEditados")]
        public HttpResponseMessage GrabarItemsEditados([FromUri] int ciaContabSeleccionada, [FromBody] List<CodigoPresupuestoEditado> data)
        {
            if (!User.Identity.IsAuthenticated)
            {
                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            try
            {
                // el criterio es un json, pero viene como un string 
                //List<CodigoPresupuestoEditado> codigosPresupuestoEditados = new List<CodigoPresupuestoEditado>();
                //codigosPresupuestoEditados = JsonConvert.DeserializeObject<List<CodigoPresupuestoEditado>>(data);

                dbContab_Contab_Entities context = new dbContab_Contab_Entities();

                var itemsAgregados = 0;
                var itemsEditados = 0;
                var itemsEliminados = 0;

                string message = ""; 

                foreach (var item in data) 
                {
                    // -----------------------------------------------------------------------------------------------------------
                    // nótese como validamos cada cuenta de presupuesto usando los atributos que definimos en la clase (poco) ... 

                    // Use the ValidationContext to validate the Product model against the product data annotations
                    // before saving it to the database
                    var validationContext = new ValidationContext(item, serviceProvider: null, items: null);
                    var validationResults = new List<ValidationResult>();

                    bool isValid = true;

                    if (!(item.isDeleted.HasValue && item.isDeleted.Value))
                        // no validamos los items que el usuario decida eliminar ... 
                        isValid = Validator.TryValidateObject(item, validationContext, validationResults, true);

                    // If there any exception return them in the return result
                    if (!isValid)
                    {
                        foreach (ValidationResult validationResult in validationResults)
                        {
                            if (message == "")
                                message = "<li>" + validationResult.ErrorMessage + "</li>"; 
                            else
                                message += "<li>" + validationResult.ErrorMessage + "</li>"; 
                        }

                        var errorResult = new
                        {
                            ErrorFlag = true,
                            ErrorMessage = "<b>Error:</b> se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                           "<b>El mensaje específico de error es:</b><ul>" + message + "</ul>"
                        };

                        return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                    }
                    // -----------------------------------------------------------------------------------------------------------


                    if (item.isDeleted.HasValue && item.isDeleted.Value)
                    {

                        var codigoPresupuesto = context.Presupuesto_Codigos.Where(p => p.Codigo == item.CodigoOriginal && p.CiaContab == ciaContabSeleccionada).
                                                                            FirstOrDefault();

                        if (codigoPresupuesto != null)
                        {
                            context.Presupuesto_Codigos.DeleteObject(codigoPresupuesto);
                            itemsEliminados++;
                        }
                    };

                    if (item.isEdited.HasValue && item.isEdited.Value) {

                        // nótese como usamos el código 'original', pues permitimos al usuario cambiar el código (el cual es la clave del registro) 

                        var codigoPresupuesto = context.Presupuesto_Codigos.Where(p => p.Codigo == item.CodigoOriginal && p.CiaContab == ciaContabSeleccionada).
                                                                            FirstOrDefault(); 
                        if (codigoPresupuesto != null)
                        {
                            codigoPresupuesto.Codigo = item.Codigo;
                            codigoPresupuesto.Descripcion = item.Descripcion;
                            codigoPresupuesto.CantNiveles = item.CantNiveles.Value;
                            codigoPresupuesto.SuspendidoFlag = item.Suspendido.Value;
                            codigoPresupuesto.GrupoFlag = item.Grupo.Value;

                            // ----------------------------------------------------------------------------------------
                            // actualizamos las cuentas contables asociadas al código de presupuesto ... 

                            var cuentasContablesCount = codigoPresupuesto.CuentasContables.Count(); 

                            for (int i = 0; i < cuentasContablesCount; i++)
                            {
                                var cuentaContable = codigoPresupuesto.CuentasContables.First();
                                codigoPresupuesto.CuentasContables.Remove(cuentaContable); 
                            }

                            foreach (var cuentaContable in item.CuentasContables)
                            {
                                var cuentaContable2 = context.CuentasContables.Where(c => c.ID == cuentaContable.ID).FirstOrDefault();
                                if (cuentaContable2 != null)
                                    codigoPresupuesto.CuentasContables.Add(cuentaContable2); 
                            }

                            itemsEditados++;
                        }
                    };

                    if (item.isNew.HasValue && item.isNew.Value)
                    {

                        var codigoPresupuesto = new Presupuesto_Codigos();

                        codigoPresupuesto.Codigo = item.Codigo;
                        codigoPresupuesto.Descripcion = item.Descripcion;
                        codigoPresupuesto.CantNiveles = item.CantNiveles.Value;
                        codigoPresupuesto.SuspendidoFlag = item.Suspendido.Value;
                        codigoPresupuesto.GrupoFlag = item.Grupo.Value;
                        codigoPresupuesto.CiaContab = ciaContabSeleccionada;

                        // ----------------------------------------------------------------------------------------
                        // actualizamos las cuentas contables asociadas al código de presupuesto ... 

                        foreach (var cuentaContable in item.CuentasContables)
                        {
                            var cuentaContable2 = context.CuentasContables.Where(c => c.ID == cuentaContable.ID).FirstOrDefault();
                            if (cuentaContable2 != null)
                                codigoPresupuesto.CuentasContables.Add(cuentaContable2);
                        }

                        context.Presupuesto_Codigos.AddObject(codigoPresupuesto);

                        itemsAgregados++;
                    }
                }

                context.SaveChanges();

                message = "Ok, " + itemsAgregados.ToString() + " registros han sido agregados; " +
                          itemsEditados.ToString() + " registros han sido modificados; " +
                          itemsEliminados.ToString() + " registros han sido eliminados. ";

                var result = new
                {
                    ErrorFlag = false,
                    ErrorMessage = "",
                    ResultMessage = message
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                   "El mensaje específico de error es: <br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }
        }


        [HttpGet]
        [Route("api/CodigosPresupuestoWebApi/actualizarCatalogos")]
        public HttpResponseMessage ActualizarCatalogos(int ciaContabSeleccionada)
        {
            if (!User.Identity.IsAuthenticated)
            {
                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            try
            {
                dbContab_Contab_Entities context = new dbContab_Contab_Entities();

                var query = context.CuentasContables.Where(c => c.Cia == ciaContabSeleccionada).
                                                     Where(c => c.TotDet == "D").
                                                     Where(c => c.ActSusp == "A").
                                                     OrderBy(c => c.Cuenta). 
                                                     Select(c => new 
                                                     { 
                                                         ID = c.ID, 
                                                         CuentaContable = c.CuentaEditada, 
                                                         Descripcion = c.Descripcion, 
                                                         CiaAbreviatura = c.Compania.Abreviatura 
                                                     });

                var result = new
                {
                    ErrorFlag = false,
                    ErrorMessage = "",
                    CuentasContables = query.ToList()
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                   "El mensaje específico de error es: <br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }
        }
    }
}
