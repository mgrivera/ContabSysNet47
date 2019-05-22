
using System;
using System.Linq;
using System.Web.Mvc;

using MongoDB.Driver;

using ContabSysNet_Web.ModelosDatos_EF.Contab;
using ContabSysNet_Web.Areas.Bancos.Models.islr_pagoAnticipado;

using MongoDB.Bson;
using X.PagedList;
using DalSoft.RestClient;
using System.Threading.Tasks;

namespace ContabSysNet_Web.Areas.Bancos.Controllers
{
    public class islr_pagoAnticipadoController : Controller
    {
        // GET: Bancos/islr_pagoAnticipado
        public ActionResult Index()
        {
            if (!User.Identity.IsAuthenticated)
            {
                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return View();
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
                        ViewBag.ErrorInfo = new ErrorInfo()
                        {
                            error = true,
                            message = "Error: aparentemente, no se ha seleccionado una <em>Cia Contab</em>.<br />" +
                                    "Por favor seleccione una <em>Cia Contab</em> y luego regrese y continúe con la ejecución de esta función.<br />" +
                                    "Para seleccionar una <em>compañía Contab</em>, desde la página principal abra el menú <em>Generales</em> y " +
                                    "luego la opción <em>Seleccionar compañía</em>."
                        };

                        return View();
                    }

                    nombreCiaContabSeleccionada = cia.ciaContabSeleccionadaNombre;
                    ciaContabSeleccionada = cia.ciaContabSeleccionada;
                }
                catch (Exception ex)
                {
                    string message = ex.Message;
                    if (ex.InnerException != null)
                        message += "<br />" + ex.InnerException.Message;

                    ViewBag.ErrorInfo = new ErrorInfo()
                    {
                        error = true,
                        message = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                  "El mensaje específico de error es: <br />" + message
                    };

                    return View();
                }
            }

            // --------------------------------------------------------------------------------------------------------------------------
            // establecemos una conexión a mongodb; específicamente, a la base de datos del programa contabM; allí se registrará 
            // todo en un futuro; además, ahora ya están registradas las vacaciones ... 
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            string contabm_mongodb_connection = System.Web.Configuration.WebConfigurationManager.AppSettings["contabm_mongodb_connectionString"];
            string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

            var client = new MongoClient(contabm_mongodb_connection);
            // var server = client.GetServer();
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            var mongoDataBase = client.GetDatabase(contabM_mongodb_name);
            // --------------------------------------------------------------------------------------------------------------------------

            var eventos_pagosAnticipadosIslr = mongoDataBase.GetCollection<EventoPagoAnticipado>("eventos_pagosAnticipadosIslr");

            try
            {
                // --------------------------------------------------------------------------------------------------------------------------
                // ... para revisar si mongodb está disponible 
                var builder = Builders<EventoPagoAnticipado>.Filter;
                var filter = builder.Eq(x => x.Usuario, "xyzxyz--999");

                eventos_pagosAnticipadosIslr.DeleteManyAsync(filter);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                string resultMessage = "Se producido un error al intentar ejecutar una operación en mongodb.<br />" +
                                   "El mensaje específico del error es:<br />" + message;

                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = resultMessage
                };

                return View();
            }

            ViewBag.PageInfo = null;
            ViewBag.ErrorInfo = null;
            ViewBag.ciaContabID = ciaContabSeleccionada;        // pasamos el id de la compañía seleccionada 

            return View();
        }

        // GET: Bancos/InformarPagoImpuesto
        [HttpGet]
        public ActionResult InformarPagoImpuesto()
        {
            if (!User.Identity.IsAuthenticated)
            {
                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return View();
            }

            var context = new dbContab_Contab_Entities();

            int ciaContabSeleccionada;
            string nombreCiaContabSeleccionada;

            try
            {
                var cia = context.tCiaSeleccionadas.Where(s => s.UsuarioLS == User.Identity.Name).
                                                    Select(c => new { ciaContabSeleccionada = c.Compania.Numero, ciaContabSeleccionadaNombre = c.Compania.Nombre }).
                                                    FirstOrDefault();

                if (cia == null)
                {
                    ViewBag.ErrorInfo = new ErrorInfo()
                    {
                        error = true,
                        message = "Error: aparentemente, no se ha seleccionado una <em>Cia Contab</em>.<br />" +
                                "Por favor seleccione una <em>Cia Contab</em> y luego regrese y continúe con la ejecución de esta función.<br />" +
                                "Para seleccionar una <em>compañía Contab</em>, desde la página principal abra el menú <em>Generales</em> y " +
                                "luego la opción <em>Seleccionar compañía</em>."
                    };

                    return View();
                }

                nombreCiaContabSeleccionada = cia.ciaContabSeleccionadaNombre;
                ciaContabSeleccionada = cia.ciaContabSeleccionada;
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                "El mensaje específico de error es: <br />" + message
                };

                return View();
            }

            ViewBag.ErrorInfo = null;

            // ahora leemos el rif desde la tabla de compañías 
            var compania = context.Companias.Where(c => c.Numero == ciaContabSeleccionada).FirstOrDefault();

            var pagoAnticipado = new EventoPagoAnticipado()
            {
                _id = ObjectId.GenerateNewId().ToString(), 
                Fecha = DateTime.Today,
                FechaRegistro = DateTime.Now, 
                Rif = compania.Rif,
                Monto = 0,
                Usuario = User.Identity.Name, 
                Cia = compania.Numero
            };

            ViewBag.PageInfo = null; 

            return View(pagoAnticipado);
        }

        // GET: Bancos/InformarPagoImpuesto
        [HttpPost]
        public async Task<ActionResult> InformarPagoImpuesto(EventoPagoAnticipado pagoAnticipado)
        {
            if (!User.Identity.IsAuthenticated)
            {
                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return View();
            }

            if (!ModelState.IsValid)
            {
                // errores de validación; regresamos para que el usuario los corrija y vuelva a postear la forma 
                return View();
            }

            var context = new dbContab_Contab_Entities();

            // --------------------------------------------------------------------------------------------------------------------------
            // establecemos una conexión a mongodb; específicamente, a la base de datos del programa contabM; allí se registrará 
            // todo en un futuro; además, ahora ya están registradas las vacaciones ... 
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            string contabm_mongodb_connection = System.Web.Configuration.WebConfigurationManager.AppSettings["contabm_mongodb_connectionString"];
            string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

            var client = new MongoClient(contabm_mongodb_connection);
            // var server = client.GetServer();
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            var mongoDataBase = client.GetDatabase(contabM_mongodb_name);
            // --------------------------------------------------------------------------------------------------------------------------

            var eventos_pagosAnticipadosIslr = mongoDataBase.GetCollection<EventoPagoAnticipado>("eventos_pagosAnticipadosIslr");

            try
            {
                // --------------------------------------------------------------------------------------------------------------------------
                // solo para revisar si mongodb está disponible ... 
                var result = eventos_pagosAnticipadosIslr.DeleteOne(e => e.Cia == -999888111);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                string resultMessage = "Se producido un error al intentar ejecutar una operación en mongodb.<br />" +
                                   "El mensaje específico del error es:<br />" + message;

                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = resultMessage
                };

                return View();
            }

            // ----------------------------------------------------------------------------------------
            // TODO: de alguna forma, grabar el evento usando el api ...
            // ----------------------------------------------------------------------------------------

            // ahora vamos a simular la obtención de un resultado, true/false, para enviar un mensaje de error/éxito 
            //Random rand = new Random();
            //bool randomTrueFalseValue = rand.Next(2) == 1;

            //if (randomTrueFalseValue)
            //{
            //    pagoAnticipado.EstatusFinal = new EventoPagoAnticipado_ResultStatus(); 

            //    pagoAnticipado.EstatusFinal.Estatus = "Procesada";
            //    pagoAnticipado.EstatusFinal.Mensaje = "Su declaración ha sido registrada satisfactoriamente.";
            //}
            //else
            //{
            //    pagoAnticipado.EstatusFinal = new EventoPagoAnticipado_ResultStatus();

            //    pagoAnticipado.EstatusFinal.Estatus = "Error";
            //    pagoAnticipado.EstatusFinal.Mensaje = "Error: ha ocurrido un error al intentar grabar el evento mediante el api. Por favor revise, corrija e intente nuevamente.";
            //}


            // -----------------------------------------------------------------------------------
            // leemos la dirección del api 
            var eventos_pagosAnticipadosIslr_config = mongoDataBase.GetCollection<EventoPagoAnticipado_Config>("eventos_pagosAnticipadosIslr_config");

            var config = eventos_pagosAnticipadosIslr_config.AsQueryable()
                         .Where(e => e.Cia == pagoAnticipado.Cia)                   // usamos la Cia Contab que viene con el evento que se intentará grabar 
                         .Select(e => e).FirstOrDefault();

            if (config == null)
            {
                string message = "No hemos podido leer un registro en la base de datos con la configuración del api que usa este proceso. <br />" +
                                 "Por favor use la opción <em>documentación</em>, desde la página principal de este proceso, para registrar la dirección " +
                                 "del api. <br /><br />" +
                                 "Luego regrese e intente continuar con este proceso.";

                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = message
                };

                return View();
            }






            // Ok, ahora que tenemos el api address, intentamos hacer el post con el registro que recibe este método 

            // usamos DalSoft RestClient para grabar (post) el evento al api (seniat) 
            dynamic restClient = new RestClient(config.ApiBaseAddress);

            var evento = new { rif = pagoAnticipado.Rif,
                               monto_declaracion = pagoAnticipado.Monto.ToString("0.00").Replace(".", ","),
                               fecha_impuesto = pagoAnticipado.Fecha.ToString("dd/MM/yyyy") };

            //POST { "name":"foo", "email":"foo@bar.com", "userId":10 } https://jsonplaceholder.typicode.com/users
            dynamic result_restClient = null; 
            try
            {
                // nótese que indicamos el nombre del método como parte del comando 
                result_restClient = await restClient.registrar_declaracion.Post(evento);
            }
            catch (Exception ex)
            {
                string message = "<b>Error:</b> ha ocurrido un error al intentar usar el api para informar el monto base del impuesto.<br />" + 
                                 "El mensaje del error obtenido es: <br />" + ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = message
                };

                return View();
            }
            

            //dynamic client = new RestClient("https://jsonplaceholder.typicode.com");
            //var user = new { name = "foo", email = "foo@bar.com", userId = 10 };
            ////POST { "name":"foo", "email":"foo@bar.com", "userId":10 } https://jsonplaceholder.typicode.com/users
            //var result = await client.Users.Post(user);

            // --------------------------------------------------------------------------------------
            // agregamos el registro a mongo (log) 
            try
            {
                // nótese como siempre escribimos el resultado final al evento que se graba a mongo (como un log) 
                pagoAnticipado.EstatusFinal = new EventoPagoAnticipado_ResultStatus();

                pagoAnticipado.EstatusFinal.Estatus = result_restClient.estatus;
                pagoAnticipado.EstatusFinal.Mensaje = result_restClient.mensaje;               

                // generamos un id para el registro 
                pagoAnticipado._id = ObjectId.GenerateNewId().ToString(); 
                eventos_pagosAnticipadosIslr.InsertOne(pagoAnticipado);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = message
                };

                return View();
            }

            ViewBag.ErrorInfo = null;
            ViewBag.PageInfo = null;


            // fiinalmente regresamos al view y mostramos un mensaje de acuerdo al resultado del registro mediante el api 
            if (pagoAnticipado.EstatusFinal.Estatus == "Procesada")
            {
                ViewBag.PageInfo = new PageGeneralInfo()
                {
                    message = "Ok, el proceso se ha ejecutado en forma exitosa.<br />" +
                          "<b>Haga un click en <em>regresar</em> para regresar a la página principal de este proceso.</b>",
                };
            }
            else
            {
                // ha ocurrido un error al usar el api para el registro del evento; intentamos mostrar el mensaje al usuario 
                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = "<b>Error:</b> ha ocurrido un error al intentar grabar el evento mediante el api.<br /> " +
                              "Por favor consulte el evento, mediante la opción <em>Consultas</em>, para que pueda revisar el mensaje de error obtenido. "
                };
            }

            return View();
        }


        [HttpGet]
        public ActionResult ConsultarPagosRegistrados(int ciaContabID, int? page)
        {
            if (!User.Identity.IsAuthenticated)
            {
                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return View();
            }

            // --------------------------------------------------------------------------------------------------------------------------
            // establecemos una conexión a mongodb; específicamente, a la base de datos del programa contabM; allí se registrará 
            // todo en un futuro; además, ahora ya están registradas las vacaciones ... 
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            string contabm_mongodb_connection = System.Web.Configuration.WebConfigurationManager.AppSettings["contabm_mongodb_connectionString"];
            string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

            var client = new MongoClient(contabm_mongodb_connection);
            // var server = client.GetServer();
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            var mongoDataBase = client.GetDatabase(contabM_mongodb_name);
            // --------------------------------------------------------------------------------------------------------------------------
            var eventos_pagosAnticipadosIslr = mongoDataBase.GetCollection<EventoPagoAnticipado>("eventos_pagosAnticipadosIslr");

            try
            {
                // --------------------------------------------------------------------------------------------------------------------------
                // ... para revisar si mongodb está disponible 
                var result = eventos_pagosAnticipadosIslr.DeleteMany(x => x.Usuario == "xyzxyz--999");
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                string resultMessage = "Se producido un error al intentar ejecutar una operación en mongodb.<br />" +
                                   "El mensaje específico del error es:<br />" + message;

                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = resultMessage
                };

                return View();
            }

            // cantidad de registros para la cia seleccionada
            long recCount = eventos_pagosAnticipadosIslr.CountDocuments(f => f.Cia == ciaContabID);

            // determinamos la cantidad de records ... 
            var pageIndex = (page ?? 1) - 1; //MembershipProvider expects a 0 for the first page
            var pageSize = 5;
            int totalRecCount = Convert.ToInt32(recCount);

            var eventos = eventos_pagosAnticipadosIslr.Find(f => f.Cia == ciaContabID).
                                                       Skip(pageIndex * pageSize).
                                                       Limit(pageSize).
                                                       SortByDescending(s => s.FechaRegistro).
                                                       ToList();

            var recordsAsIPagedList = new StaticPagedList<EventoPagoAnticipado>(eventos, pageIndex + 1, pageSize, totalRecCount);
            ViewBag.OnePageOfItems = recordsAsIPagedList;

            ViewBag.PageInfo = null;
            ViewBag.ErrorInfo = null;

            // guardamos en ViewBag la compañía seleccionada 
            ViewBag.ciaContabID = ciaContabID;

            return View();
        }



        [HttpGet]
        public ActionResult Bancos_PrepagoIslr_Doc(int ciaContabID)
        {
            if (!User.Identity.IsAuthenticated)
            {
                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return View();
            }

            // --------------------------------------------------------------------------------------------------------------------------
            // establecemos una conexión a mongodb; específicamente, a la base de datos del programa contabM
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            string contabm_mongodb_connection = System.Web.Configuration.WebConfigurationManager.AppSettings["contabm_mongodb_connectionString"];
            string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

            var client = new MongoClient(contabm_mongodb_connection);
            // var server = client.GetServer();
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            var mongoDataBase = client.GetDatabase(contabM_mongodb_name);
            // --------------------------------------------------------------------------------------------------------------------------
            var eventos_pagosAnticipadosIslr_config = mongoDataBase.GetCollection<EventoPagoAnticipado_Config>("eventos_pagosAnticipadosIslr_config");

            try
            {
                // --------------------------------------------------------------------------------------------------------------------------
                // ... para revisar si mongodb está disponible 
                var result = eventos_pagosAnticipadosIslr_config.DeleteOne(e => e.Cia == -999888111);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                string resultMessage = "Se producido un error al intentar ejecutar una operación en mongodb.<br />" +
                                   "El mensaje específico del error es:<br />" + message;

                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = resultMessage
                };

                return View();
            }

            ViewBag.ErrorInfo = null;
            ViewBag.PageInfo = null;

            // usamos linq para leer la dirección api del seniat; comúnmente existirá, pero no siempre 
            var config = eventos_pagosAnticipadosIslr_config.AsQueryable()
                         .Where(e => e.Cia == ciaContabID)
                         .Select(e => e).FirstOrDefault();

            if (config == null)
            {
                string message = "No hemos podido leer un registro en la base de datos con la configuración del api que usa este proceso. <br />" +
                                 "Por favor indique la dirección de este servicio (api) y haga un click en <b><em>Grabar</em></b>, " +
                                 "para registrar esta configuración.";

                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = message
                };

                // además de construir el mensaje de error, preparamos el objeto (model) que recibirá el View y que permtirá al usuario grabar 
                // un registro config. Nota: básicamente, al menos por ahora, lo realmente importante de este registro (config) es la dirección 
                // Web del api que usa este proceso ... 
                config = new EventoPagoAnticipado_Config() { _id = ObjectId.GenerateNewId().ToString(), ApiBaseAddress = "", Cia = ciaContabID }; 
            }
            else
            {
                string message = "Abajo en esta página Ud. podrá ver la dirección del api que se usa para registrar la información del impuesto.<br />" +
                                 "De ser necesario, Ud. puede cambiar esta dirección y hacer un <em>click</em> en <b><em>Grabar</em></b>, ";

                ViewBag.PageInfo = new PageGeneralInfo()
                {
                    message = message
                };
            }

            // guardamos en ViewBag la compañía seleccionada 
            ViewBag.ciaContabID = ciaContabID;

            return View(config);
        }


        [HttpPost]
        public ActionResult Bancos_PrepagoIslr_Doc(EventoPagoAnticipado_Config config, int ciaContabID)
        {
            if (!User.Identity.IsAuthenticated)
            {
                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return View();
            }

            // --------------------------------------------------------------------------------------------------------------------------
            // establecemos una conexión a mongodb; específicamente, a la base de datos del programa contabM
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            string contabm_mongodb_connection = System.Web.Configuration.WebConfigurationManager.AppSettings["contabm_mongodb_connectionString"];
            string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

            var client = new MongoClient(contabm_mongodb_connection);
            // var server = client.GetServer();
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            var mongoDataBase = client.GetDatabase(contabM_mongodb_name);
            // --------------------------------------------------------------------------------------------------------------------------
            var eventos_pagosAnticipadosIslr_config = mongoDataBase.GetCollection<EventoPagoAnticipado_Config>("eventos_pagosAnticipadosIslr_config");

            try
            {
                // --------------------------------------------------------------------------------------------------------------------------
                // ... para revisar si mongodb está disponible 
                var result = eventos_pagosAnticipadosIslr_config.DeleteOne(e => e.Cia == -999888111);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                string resultMessage = "Se producido un error al intentar ejecutar una operación en mongodb.<br />" +
                                   "El mensaje específico del error es:<br />" + message;

                ViewBag.ErrorInfo = new ErrorInfo()
                {
                    error = true,
                    message = resultMessage
                };

                return View();
            }

            ViewBag.ErrorInfo = null;
            ViewBag.PageInfo = null;

            // hacemos un upsert del registro (model) que recibimos aquí; si el registro es nuevo, lo agregamos; si existe, lo modificamos 
            var filter = Builders<EventoPagoAnticipado_Config>.Filter.Eq(e => e._id, config._id); 
            var result2 = eventos_pagosAnticipadosIslr_config.ReplaceOne(filter, config, new UpdateOptions() { IsUpsert = true });

            string infoMessage = ""; 
            if (result2.IsAcknowledged && result2.IsModifiedCountAvailable && result2.MatchedCount == 0) 
                infoMessage = "Ok, la dirección del api ha sido <em><b>agregada</b></em> en forma satisfactoria.<br />" +
                              "De ahora en adelante, esa será la dirección que usará este proceso para registrar la información de impuestos.";
            else
                infoMessage = "Ok, la dirección del api ha sido <em><b>actualizada</b></em> en forma satisfactoria.<br />" +
                              "De ahora en adelante, esa será la dirección que usará este proceso para registrar la información de impuestos.";

            ViewBag.PageInfo = new PageGeneralInfo()
            {
                message = infoMessage
            };

            // guardamos en ViewBag la compañía seleccionada 
            ViewBag.ciaContabID = ciaContabID;

            // TODO: aquí debemos regresar el registro que se ha recién actualizado ... 
            return View(config);
        }
    }
}