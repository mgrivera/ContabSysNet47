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
    public class MontosEstimadosWebApiController : ApiController
    {
        [HttpGet]
        [Route("api/MontosEstimadosWebApi/LeerDatosIniciales")]
        public HttpResponseMessage LeerDatosIniciales()
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
                            ResultMessage = "Error: aparentemente, no se ha seleccionado una <em>Cia Contab</em>.<br />" +
                                    "Por favor seleccione una <em>Cia Contab</em> y luego regrese y continúe con la ejecución de esta función."
                        };

                        return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                    }

                    // ahora leemos la lista de monedas 

                    var monedas = context.Monedas.OrderBy(m => m.Descripcion).
                                                  Select(m => new
                                                  {
                                                      Moneda = m.Moneda1,
                                                      Descripcion = m.Descripcion,
                                                      Simbolo = m.Simbolo
                                                  }).ToList();

                    // leemos y regresamos una lista de años que tienen montos 
                    var anos = context.Presupuesto_Montos.OrderBy(a => a.Ano).Select(a => a.Ano).Distinct().ToList(); 

                    var result = new
                    {
                        ErrorFlag = false,
                        ResultMessage = "",
                        ciaContabSeleccionada = cia,
                        monedas = monedas,
                        anos = anos
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
                        ResultMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                       "El mensaje específico de error es: <br />" + message
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }
            }
        }


        [HttpPost]
        [Route("api/MontosEstimadosWebApi/LeerCodigosPresupuesto")]
        public HttpResponseMessage LeerCodigosPresupuesto(MontosEstimados_Filtro filtro)
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

            using (dbContab_Contab_Entities context = new dbContab_Contab_Entities())
            {
                try
                {
                    context.ContextOptions.LazyLoadingEnabled = false;
                    var query = context.Presupuesto_Montos.Include("Presupuesto_Codigos").
                                                           Include("Moneda1").
                                                           Where(p => p.CiaContab == filtro.Cia); 


                    if (!string.IsNullOrEmpty(filtro.Codigo))
                        if (filtro.Codigo.StartsWith("*"))
                            query = query.Where(c => c.CodigoPresupuesto.EndsWith(filtro.Codigo.Replace("*", "")));
                        else if (filtro.Codigo.EndsWith("*"))
                            query = query.Where(c => c.CodigoPresupuesto.StartsWith(filtro.Codigo.Replace("*", "")));
                        else
                            query = query.Where(c => c.CodigoPresupuesto.Contains(filtro.Codigo));


                    if (!string.IsNullOrEmpty(filtro.Descripcion))
                        if (filtro.Codigo.StartsWith("*"))
                            query = query.Where(c => c.Presupuesto_Codigos.Descripcion.EndsWith(filtro.Descripcion.Replace("*", "")));
                        else if (filtro.Codigo.EndsWith("*"))
                            query = query.Where(c => c.Presupuesto_Codigos.Descripcion.StartsWith(filtro.Descripcion.Replace("*", "")));
                        else
                            query = query.Where(c => c.Presupuesto_Codigos.Descripcion.Contains(filtro.Descripcion));


                    // leemos solo 'no grupos' y 'no suspendidos' 
                    query = query.Where(c => !c.Presupuesto_Codigos.GrupoFlag);
                    query = query.Where(c => !c.Presupuesto_Codigos.SuspendidoFlag);



                    // nótese como usamos las listas de años y monedas, para filtrar los montos estimados 

                    if (filtro.Anos.Count() > 0)
                        query = query.Where(m => filtro.Anos.Contains(m.Ano));

                    if (filtro.Monedas != null && filtro.Monedas.Count() > 0)
                    {
                        var monedas = filtro.Monedas.Select(m => m.Moneda).ToList();
                        query = query.Where(m => monedas.Contains(m.Moneda)); 
                    }
                        

                    MontoEstimado montoEstimado;
                    List<MontoEstimado> montosEstimados = new List<MontoEstimado>();

                    foreach (var monto in query)
                    {
                        montoEstimado = new MontoEstimado()
                        {
                            Codigo = monto.CodigoPresupuesto,
                            Descripcion = monto.Presupuesto_Codigos.Descripcion,
                            Moneda = monto.Moneda1.Moneda1,
                            MonedaSimbolo = monto.Moneda1.Simbolo,
                            Ano = monto.Ano,
                            Mes01_Est = monto.Mes01_Est,
                            Mes02_Est = monto.Mes02_Est,
                            Mes03_Est = monto.Mes03_Est,
                            Mes04_Est = monto.Mes04_Est,
                            Mes05_Est = monto.Mes05_Est,
                            Mes06_Est = monto.Mes06_Est,
                            Mes07_Est = monto.Mes07_Est,
                            Mes08_Est = monto.Mes08_Est,
                            Mes09_Est = monto.Mes09_Est,
                            Mes10_Est = monto.Mes10_Est,
                            Mes11_Est = monto.Mes11_Est,
                            Mes12_Est = monto.Mes12_Est
                        };

                        montosEstimados.Add(montoEstimado); 
                    }


                    var result = new
                    {
                        ErrorFlag = false,
                        ResultMessage = "",
                        MontosEstimados = montosEstimados
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
                        ResultMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                       "El mensaje específico de error es: <br />" + message
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }
            }
        }


        [HttpPost]
        [Route("api/MontosEstimadosWebApi/GrabarItemsEditados")]
        public HttpResponseMessage GrabarItemsEditados([FromUri] int ciaContabSeleccionada, [FromBody] List<MontoEstimadoEditado> data)
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
                    // nótese como validamos cada item usando los atributos que definimos en la clase (poco) ... 

                    // Use the ValidationContext to validate the Product model against the product data annotations
                    // before saving it to the database
                    var validationContext = new ValidationContext(item, serviceProvider: null, items: null);
                    var validationResults = new List<ValidationResult>();

                    var isValid = Validator.TryValidateObject(item, validationContext, validationResults, true);

                    // If there are any exceptions, return them in the return result
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
                            ResultMessage = "<b>Error:</b> se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                           "<b>El mensaje específico de error es:</b><ul>" + message + "</ul>"
                        };

                        return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                    }
                    // -----------------------------------------------------------------------------------------------------------


                    if (item.isDeleted.HasValue && item.isDeleted.Value)
                    {

                        var montoEstimado = context.Presupuesto_Montos
                            .Where(p => p.CodigoPresupuesto == item.Codigo &&
                                        p.Ano == item.Ano &&
                                        p.Moneda == item.Moneda &&
                                        p.CiaContab == ciaContabSeleccionada).
                             FirstOrDefault();

                        if (montoEstimado != null)
                        {
                            context.Presupuesto_Montos.DeleteObject(montoEstimado);
                            itemsEliminados++;
                        }
                    };

                    if (item.isEdited.HasValue && item.isEdited.Value)
                    {
                        var montoEstimado = context.Presupuesto_Montos
                            .Where(p => p.CodigoPresupuesto == item.Codigo &&
                                        p.Ano == item.Ano &&
                                        p.Moneda == item.Moneda &&
                                        p.CiaContab == ciaContabSeleccionada).
                             FirstOrDefault();

                        if (montoEstimado != null)
                        {
                            // nótese que cambiamos solo los montos; otros valores (código, ano, moneda y cia) son parte del pk y entity framework 
                            // no permite cambiarlos 

                            montoEstimado.Mes01_Est = item.Mes01_Est;
                            montoEstimado.Mes02_Est = item.Mes02_Est;
                            montoEstimado.Mes03_Est = item.Mes03_Est;
                            montoEstimado.Mes04_Est = item.Mes04_Est;
                            montoEstimado.Mes05_Est = item.Mes05_Est;
                            montoEstimado.Mes06_Est = item.Mes06_Est;
                            montoEstimado.Mes07_Est = item.Mes07_Est;
                            montoEstimado.Mes08_Est = item.Mes08_Est;
                            montoEstimado.Mes09_Est = item.Mes09_Est;
                            montoEstimado.Mes10_Est = item.Mes10_Est;
                            montoEstimado.Mes11_Est = item.Mes11_Est;
                            montoEstimado.Mes12_Est = item.Mes12_Est;

                            itemsEditados++;
                        }
                    };

                    if (item.isNew.HasValue && item.isNew.Value)
                    {

                        var montoEstimado = new Presupuesto_Montos();

                        montoEstimado.CodigoPresupuesto = item.Codigo;
                        montoEstimado.Moneda = item.Moneda;
                        montoEstimado.Ano = item.Ano;
                        montoEstimado.CiaContab = ciaContabSeleccionada;

                        montoEstimado.Mes01_Est = item.Mes01_Est;
                        montoEstimado.Mes02_Est = item.Mes02_Est;
                        montoEstimado.Mes03_Est = item.Mes03_Est;
                        montoEstimado.Mes04_Est = item.Mes04_Est;
                        montoEstimado.Mes05_Est = item.Mes05_Est;
                        montoEstimado.Mes06_Est = item.Mes06_Est;
                        montoEstimado.Mes07_Est = item.Mes07_Est;
                        montoEstimado.Mes08_Est = item.Mes08_Est;
                        montoEstimado.Mes09_Est = item.Mes09_Est;
                        montoEstimado.Mes10_Est = item.Mes10_Est;
                        montoEstimado.Mes11_Est = item.Mes11_Est;
                        montoEstimado.Mes12_Est = item.Mes12_Est;

                        context.Presupuesto_Montos.AddObject(montoEstimado);

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
                    ResultMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                   "El mensaje específico de error es: <br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }
        }











        [HttpPost]
        [Route("api/MontosEstimadosWebApi/AgregarMontosEstimados")]
        public HttpResponseMessage AgregarMontosEstimados([FromBody] MontosEstimados_Agregar_Parametro data)
        {
            if (!User.Identity.IsAuthenticated)
            {
                var errorResult = new
                {
                    ErrorFlag = true,
                    ResultMessage = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            if (data.AnoCopiarDesde != null && string.IsNullOrEmpty(data.MontosEjecutadosEstimados)) 
            {
                var errorResult = new
                {
                    ErrorFlag = true,
                    ResultMessage = "<b>Error:</b> si Ud. desea inicializar los montos estimados en base a un año, " + 
                                    "debe indicar el <em>tipo de monto base</em>: estimados o ejecutados."
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            try
            {
                dbContab_Contab_Entities context = new dbContab_Contab_Entities();

                int itemsLeidos = 0; 
                int itemsAgregados = 0;
                int itemsYaExistian = 0; 

                string message = "";

                // nos aseguramos de leer solo códigos para la cía seleccionada ... 
                var query = context.Presupuesto_Codigos.Include("Presupuesto_Montos").Where(p => p.CiaContab == data.CiaContabSeleccionada);

                // leemos usando el filtro o año/moneda (nota: si viene un filtro es por 'aplicarSoloItemsSeleccionados'; de otra forma, el filtro es nulls 

                // leemos solo 'no grupos' y 'no suspendidos' 
                query = query.Where(c => !c.GrupoFlag);
                query = query.Where(c => !c.SuspendidoFlag);

                Presupuesto_Montos montoEstimadoAnoBase = null;        // para leer los montos estimados de un año 'base', si el usuario lo indicó 
                Presupuesto_Montos montoEstimado;

                foreach (var codigoPresupuesto in query)
                {
                    // intentamos leer un año monto 'base', para usar como base cuando agreguemos los montos 

                    if (data.AnoCopiarDesde != null)
                        montoEstimadoAnoBase = context.Presupuesto_Montos.Where(m => m.CiaContab == data.CiaContabSeleccionada).
                                                                          Where(m => m.Moneda == data.MonedaID).
                                                                          Where(m => m.Ano == data.AnoCopiarDesde).
                                                                          Where(m => m.CodigoPresupuesto == codigoPresupuesto.Codigo).
                                                                          FirstOrDefault();



                    montoEstimado = codigoPresupuesto.Presupuesto_Montos.Where(m => m.Moneda == data.MonedaID).
                                                                      Where(m => m.Ano == data.Ano).
                                                                      FirstOrDefault();

                    if (montoEstimadoAnoBase != null)
                    {
                        // el usuario indicó un año 'base' y existe un monto para este año y el código tratado 

                        if (montoEstimado != null)
                        {
                            // el monto estimado existe para el código de presupuesto; lo actualizamos en base a los montos del año base 
                            // nótese como usamos los montos estimados o ejecutados, según la definición que el usuario haya indicado 
                            if (data.ActualizarMontosSiExisten.HasValue && data.ActualizarMontosSiExisten.Value)
                            {
                                if (data.MontosEjecutadosEstimados == "ejecutados")
                                {
                                    montoEstimado.Mes01_Est = montoEstimadoAnoBase.Mes01_Eje != null ? montoEstimadoAnoBase.Mes01_Eje : 0; 
                                    montoEstimado.Mes02_Est = montoEstimadoAnoBase.Mes02_Eje != null ? montoEstimadoAnoBase.Mes02_Eje : 0; 
                                    montoEstimado.Mes03_Est = montoEstimadoAnoBase.Mes03_Eje != null ? montoEstimadoAnoBase.Mes03_Eje : 0; 
                                    montoEstimado.Mes04_Est = montoEstimadoAnoBase.Mes04_Eje != null ? montoEstimadoAnoBase.Mes04_Eje : 0; 
                                    montoEstimado.Mes05_Est = montoEstimadoAnoBase.Mes05_Eje != null ? montoEstimadoAnoBase.Mes05_Eje : 0; 
                                    montoEstimado.Mes06_Est = montoEstimadoAnoBase.Mes06_Eje != null ? montoEstimadoAnoBase.Mes06_Eje : 0; 
                                    montoEstimado.Mes07_Est = montoEstimadoAnoBase.Mes07_Eje != null ? montoEstimadoAnoBase.Mes07_Eje : 0; 
                                    montoEstimado.Mes08_Est = montoEstimadoAnoBase.Mes08_Eje != null ? montoEstimadoAnoBase.Mes08_Eje : 0; 
                                    montoEstimado.Mes09_Est = montoEstimadoAnoBase.Mes09_Eje != null ? montoEstimadoAnoBase.Mes09_Eje : 0; 
                                    montoEstimado.Mes10_Est = montoEstimadoAnoBase.Mes10_Eje != null ? montoEstimadoAnoBase.Mes10_Eje : 0; 
                                    montoEstimado.Mes11_Est = montoEstimadoAnoBase.Mes11_Eje != null ? montoEstimadoAnoBase.Mes11_Eje : 0; 
                                    montoEstimado.Mes12_Est = montoEstimadoAnoBase.Mes12_Eje != null ? montoEstimadoAnoBase.Mes12_Eje : 0; 
                                }
                                else
                                {
                                    montoEstimado.Mes01_Est = montoEstimadoAnoBase.Mes01_Est != null ? montoEstimadoAnoBase.Mes01_Est : 0;
                                    montoEstimado.Mes02_Est = montoEstimadoAnoBase.Mes02_Est != null ? montoEstimadoAnoBase.Mes02_Est : 0;
                                    montoEstimado.Mes03_Est = montoEstimadoAnoBase.Mes03_Est != null ? montoEstimadoAnoBase.Mes03_Est : 0;
                                    montoEstimado.Mes04_Est = montoEstimadoAnoBase.Mes04_Est != null ? montoEstimadoAnoBase.Mes04_Est : 0;
                                    montoEstimado.Mes05_Est = montoEstimadoAnoBase.Mes05_Est != null ? montoEstimadoAnoBase.Mes05_Est : 0;
                                    montoEstimado.Mes06_Est = montoEstimadoAnoBase.Mes06_Est != null ? montoEstimadoAnoBase.Mes06_Est : 0;
                                    montoEstimado.Mes07_Est = montoEstimadoAnoBase.Mes07_Est != null ? montoEstimadoAnoBase.Mes07_Est : 0;
                                    montoEstimado.Mes08_Est = montoEstimadoAnoBase.Mes08_Est != null ? montoEstimadoAnoBase.Mes08_Est : 0;
                                    montoEstimado.Mes09_Est = montoEstimadoAnoBase.Mes09_Est != null ? montoEstimadoAnoBase.Mes09_Est : 0;
                                    montoEstimado.Mes10_Est = montoEstimadoAnoBase.Mes10_Est != null ? montoEstimadoAnoBase.Mes10_Est : 0;
                                    montoEstimado.Mes11_Est = montoEstimadoAnoBase.Mes11_Est != null ? montoEstimadoAnoBase.Mes11_Est : 0;
                                    montoEstimado.Mes12_Est = montoEstimadoAnoBase.Mes12_Est != null ? montoEstimadoAnoBase.Mes12_Est : 0;
                                }
                                
                                itemsYaExistian++; 
                            }
                        }
                        else
                        {
                            // el monto estimado no existe, lo creamos en base al año base 

                            montoEstimado = new Presupuesto_Montos();

                            montoEstimado.CodigoPresupuesto = codigoPresupuesto.Codigo;
                            montoEstimado.CiaContab = codigoPresupuesto.CiaContab;
                            montoEstimado.Moneda = data.MonedaID;
                            montoEstimado.Ano = data.Ano;

                            if (data.MontosEjecutadosEstimados == "ejecutados")
                            {
                                montoEstimado.Mes01_Est = montoEstimadoAnoBase.Mes01_Eje != null ? montoEstimadoAnoBase.Mes01_Eje : 0;
                                montoEstimado.Mes02_Est = montoEstimadoAnoBase.Mes02_Eje != null ? montoEstimadoAnoBase.Mes02_Eje : 0;
                                montoEstimado.Mes03_Est = montoEstimadoAnoBase.Mes03_Eje != null ? montoEstimadoAnoBase.Mes03_Eje : 0;
                                montoEstimado.Mes04_Est = montoEstimadoAnoBase.Mes04_Eje != null ? montoEstimadoAnoBase.Mes04_Eje : 0;
                                montoEstimado.Mes05_Est = montoEstimadoAnoBase.Mes05_Eje != null ? montoEstimadoAnoBase.Mes05_Eje : 0;
                                montoEstimado.Mes06_Est = montoEstimadoAnoBase.Mes06_Eje != null ? montoEstimadoAnoBase.Mes06_Eje : 0;
                                montoEstimado.Mes07_Est = montoEstimadoAnoBase.Mes07_Eje != null ? montoEstimadoAnoBase.Mes07_Eje : 0;
                                montoEstimado.Mes08_Est = montoEstimadoAnoBase.Mes08_Eje != null ? montoEstimadoAnoBase.Mes08_Eje : 0;
                                montoEstimado.Mes09_Est = montoEstimadoAnoBase.Mes09_Eje != null ? montoEstimadoAnoBase.Mes09_Eje : 0;
                                montoEstimado.Mes10_Est = montoEstimadoAnoBase.Mes10_Eje != null ? montoEstimadoAnoBase.Mes10_Eje : 0;
                                montoEstimado.Mes11_Est = montoEstimadoAnoBase.Mes11_Eje != null ? montoEstimadoAnoBase.Mes11_Eje : 0;
                                montoEstimado.Mes12_Est = montoEstimadoAnoBase.Mes12_Eje != null ? montoEstimadoAnoBase.Mes12_Eje : 0;
                            }
                            else
                            {
                                montoEstimado.Mes01_Est = montoEstimadoAnoBase.Mes01_Est != null ? montoEstimadoAnoBase.Mes01_Est : 0;
                                montoEstimado.Mes02_Est = montoEstimadoAnoBase.Mes02_Est != null ? montoEstimadoAnoBase.Mes02_Est : 0;
                                montoEstimado.Mes03_Est = montoEstimadoAnoBase.Mes03_Est != null ? montoEstimadoAnoBase.Mes03_Est : 0;
                                montoEstimado.Mes04_Est = montoEstimadoAnoBase.Mes04_Est != null ? montoEstimadoAnoBase.Mes04_Est : 0;
                                montoEstimado.Mes05_Est = montoEstimadoAnoBase.Mes05_Est != null ? montoEstimadoAnoBase.Mes05_Est : 0;
                                montoEstimado.Mes06_Est = montoEstimadoAnoBase.Mes06_Est != null ? montoEstimadoAnoBase.Mes06_Est : 0;
                                montoEstimado.Mes07_Est = montoEstimadoAnoBase.Mes07_Est != null ? montoEstimadoAnoBase.Mes07_Est : 0;
                                montoEstimado.Mes08_Est = montoEstimadoAnoBase.Mes08_Est != null ? montoEstimadoAnoBase.Mes08_Est : 0;
                                montoEstimado.Mes09_Est = montoEstimadoAnoBase.Mes09_Est != null ? montoEstimadoAnoBase.Mes09_Est : 0;
                                montoEstimado.Mes10_Est = montoEstimadoAnoBase.Mes10_Est != null ? montoEstimadoAnoBase.Mes10_Est : 0;
                                montoEstimado.Mes11_Est = montoEstimadoAnoBase.Mes11_Est != null ? montoEstimadoAnoBase.Mes11_Est : 0;
                                montoEstimado.Mes12_Est = montoEstimadoAnoBase.Mes12_Est != null ? montoEstimadoAnoBase.Mes12_Est : 0;
                            }
                                

                            codigoPresupuesto.Presupuesto_Montos.Add(montoEstimado);

                            itemsAgregados++; 
                        }
                    }
                    else
                    {
                        // el monto para el año base no existe o el usuario no indicó uno (el tratamiendo aplicado es el mismo) 

                        if (montoEstimado == null)
                        {
                            // el monto estimado no existe, lo creamos con sus montos en cero 

                            montoEstimado = new Presupuesto_Montos();

                            montoEstimado.CodigoPresupuesto = codigoPresupuesto.Codigo;
                            montoEstimado.CiaContab = codigoPresupuesto.CiaContab;
                            montoEstimado.Moneda = data.MonedaID;
                            montoEstimado.Ano = data.Ano;

                            montoEstimado.Mes01_Est = 0;
                            montoEstimado.Mes02_Est = 0;
                            montoEstimado.Mes03_Est = 0;
                            montoEstimado.Mes04_Est = 0;
                            montoEstimado.Mes05_Est = 0;
                            montoEstimado.Mes06_Est = 0;
                            montoEstimado.Mes07_Est = 0;
                            montoEstimado.Mes08_Est = 0;
                            montoEstimado.Mes09_Est = 0;
                            montoEstimado.Mes10_Est = 0;
                            montoEstimado.Mes11_Est = 0;
                            montoEstimado.Mes12_Est = 0;

                            codigoPresupuesto.Presupuesto_Montos.Add(montoEstimado);
                            itemsAgregados++; 
                        }
                        else
                        {
                            // el monto estimado existe, pero no se ha leído un monto 'base' de otro año; 
                            // tan solo revisamos si existen montos en null, para ponerlos en cero ... 

                            if (montoEstimado.Mes01_Est == null) montoEstimado.Mes01_Est = 0;
                            if (montoEstimado.Mes02_Est == null) montoEstimado.Mes02_Est = 0;
                            if (montoEstimado.Mes03_Est == null) montoEstimado.Mes03_Est = 0;
                            if (montoEstimado.Mes04_Est == null) montoEstimado.Mes04_Est = 0;
                            if (montoEstimado.Mes05_Est == null) montoEstimado.Mes05_Est = 0;
                            if (montoEstimado.Mes06_Est == null) montoEstimado.Mes06_Est = 0;
                            if (montoEstimado.Mes07_Est == null) montoEstimado.Mes07_Est = 0;
                            if (montoEstimado.Mes08_Est == null) montoEstimado.Mes08_Est = 0;
                            if (montoEstimado.Mes09_Est == null) montoEstimado.Mes09_Est = 0;
                            if (montoEstimado.Mes10_Est == null) montoEstimado.Mes10_Est = 0;
                            if (montoEstimado.Mes11_Est == null) montoEstimado.Mes11_Est = 0;
                            if (montoEstimado.Mes12_Est == null) montoEstimado.Mes12_Est = 0;
                        }
                    }

                    itemsLeidos++; 
                }

                context.SaveChanges();
                
                message = "Ok, " + itemsLeidos.ToString() + " códigos de presupuesto han sido leídos;<br />" +
                        "para éstos, " + itemsAgregados.ToString() + " registros (de montos estimados) han sido agregados, pues no existían; <br /> " +
                        itemsYaExistian.ToString() + " han sido actualizados pues existían.";
                
                var result = new
                {
                    ErrorFlag = false,
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
                    ResultMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                   "El mensaje específico de error es: <br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }
        }

    }
}
