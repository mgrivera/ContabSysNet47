using ClosedXML.Excel;
using ContabSysNet_Web.Areas.Bancos.Models.mongodb;
using ContabSysNet_Web.Areas.CajaChica.Models;
using ContabSysNet_Web.Clases;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using ContabSysNet_Web.ModelosDatos_EF.CajaChica;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using MongoDB.Bson;
using MongoDB.Driver;
using MongoDB.Driver.Linq;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web.Http;
using System.Web.Security;

namespace ContabSysNet_Web.Areas.CajaChica.Controllers
{
    public class ActualizarReposicionesCajaChicaWebApiController : ApiController
    {
        [HttpGet]
        [Route("api/ActualizarReposicionesCajaChicaWebApi/LeerCiaContabSeleccionada")]
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
        [Route("api/ActualizarReposicionesCajaChicaWebApi/LeerCatalogos")]
        public HttpResponseMessage LeerCatalogos(int ciaContabSeleccionada)
        {
            // 1) leemos los catálogos necesarios para la ejecución del proceso; 
            // 2) los cargamos a collections en mongo; 
            // 3) los regresamos como listas al client 

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
                // en sql server, leemos los catálogos necesarios para agregar una reposición de caja chica: proveedores, cajas chicas y rubros de caja chica 

                BancosEntities bancosContext = new BancosEntities();

                var proveedores = bancosContext.Proveedores.OrderBy(p => p.Nombre).
                    Select(p => new Compania_mongo { Id = p.Proveedor, nombre = p.Nombre, abreviatura = p.Abreviatura }).ToList();

                ControlCajaChicaEntities controlCajaChicaContext = new ControlCajaChicaEntities();

                var cajasChicas = controlCajaChicaContext.CajaChica_CajasChicas.OrderBy(c => c.Descripcion).
                    Select(c => new CajaChica_mongo { descripcion = c.Descripcion, Id = c.CajaChica, ciaContab = c.CiaContab }).ToList();

                var rubrosCajaChica = controlCajaChicaContext.CajaChica_Rubros.OrderBy(r => r.Descripcion).
                    Select(r => new RubroCajaChica_mongo { descripcion = r.Descripcion, Id = r.Rubro }).ToList();

                // leemos y regresamos la lista de usuarios registrados en el programa; ésto permitirá al usuario enviar un correo a otro usuario 

                MembershipUserCollection usuarios = Membership.GetAllUsers();
                List<string> listaUsuarios = new List<string>(); 

                foreach (MembershipUser usuario in usuarios)
                {
                    listaUsuarios.Add(usuario.UserName); 
                }

                var result = new
                {
                    ErrorFlag = false,
                    ErrorMessage = "",
                    proveedores = proveedores,
                    cajasChicas = cajasChicas,     
                    rubrosCajaChica = rubrosCajaChica,
                    usuarios = listaUsuarios
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
        public HttpResponseMessage AplicarFiltro()
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

            FiltroConsultaReposiciones filtro = new FiltroConsultaReposiciones() { Cia = 55 }; 

            var client = new MongoClient("mongodb://localhost");
            var mongoDataBase = client.GetDatabase("dbContab");

            var reposicionesCajaChica = mongoDataBase.GetCollection<ReposicionCajaChica>("reposicionesCajaChica");

            try
            {
                // leemos, desde mongo, las reposiciones; usamos el filtro indicado por el usuario ... 
                var query = reposicionesCajaChica.AsQueryable<ReposicionCajaChica>().Where(r => r.CiaContabID == filtro.Cia).Select(r => r);

                var listaReposiciones = query.ToList();

                var result = new
                {
                    errorFlag = false,
                    errorMessage = "",
                    resultMessage = "Ok, se han leído " + listaReposiciones.Count().ToString() + " reposiciones de caja chica.",
                    listaReposiciones = listaReposiciones
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
                    errorFlag = true,
                    errorMessage = "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }
        }

        [HttpPost]
        [Route("api/ActualizarReposicionesCajaChicaWebApi/GrabarItemsAMongo")]
        public HttpResponseMessage GrabarItemsAMongo(ReposicionCajaChica reposicionJson)
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

            // --------------------------------------------------------------------------------------------------------------------------
            // establecemos una conexión a mongodb 

            var client = new MongoClient("mongodb://localhost");
            var mongoDataBase = client.GetDatabase("dbContab");

            var reposicionesMongoCollection = mongoDataBase.GetCollection<ReposicionCajaChica>("reposicionesCajaChica");

            string resultMessage = "";

            try
            {
                // usamos un Upsert; si el document existe se actualiza; de otra forma, se agrega 

                reposicionJson.Usuario = User.Identity.Name;

                reposicionesMongoCollection.ReplaceOneAsync(
                    filter: new BsonDocument("_id", reposicionJson.Id),
                    options: new UpdateOptions { IsUpsert = true },
                    replacement: reposicionJson);

                resultMessage = "Ok, los cambios efectuados han sido grabado a la base de datos.";
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                var errorResult = new
                {
                    errorFlag = true,
                    errorMessage = "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            var result = new
            {
                errorFlag = false,
                errorMessage = "",
                resultMessage = resultMessage
            };

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage DeleteReposicion(string itemID)
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

            // --------------------------------------------------------------------------------------------------------------------------
            // establecemos una conexión a mongodb 

            var client = new MongoClient("mongodb://localhost");
            var mongoDataBase = client.GetDatabase("dbContab");

            var reposicionesMongoCollection = mongoDataBase.GetCollection<ReposicionCajaChica>("reposicionesCajaChica");

            string resultMessage = "";

            try
            {
                var builder = Builders<ReposicionCajaChica>.Filter;
                var filter = builder.Eq(x => x.Id, itemID);

                reposicionesMongoCollection.DeleteManyAsync(filter);                    // eliminamos el registro en mongo 

                resultMessage = "Ok, el registro fue eliminado de la base de datos.";
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            var result = new
            {
                ErrorFlag = false,
                ErrorMessage = "",
                ResultMessage = resultMessage
            };

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }


        // nótese que el argumento id que sigue en el método, no es usado; por alguna razón, asp.net web api no encuentra el 
        // metódo usando su nombre, como se indica en WebApiConfig en app_start. Por alguna razón, aunque tenemos el nombre del 
        // método en la definición del route, éste no es usado y el id que sigue es necesario para diferenciar de un 
        // método anterior ... 

        [HttpPost]
        public HttpResponseMessage CerrarReposicionYPasarAContab([FromBody]string value, [FromUri]int id)
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

            // nótese que recibimos el json (object) pero como un string; luego, abajo, lo descerializamos y convertimos al 
            // type que nos interese ... 

            ReposicionCajaChica reposicionJson;

            // --------------------------------------------------------------------------------------------------------------------------
            // establecemos una conexión a mongodb 

            var client = new MongoClient("mongodb://localhost");
            var mongoDataBase = client.GetDatabase("dbContab");

            var reposicionesMongoCollection = mongoDataBase.GetCollection<ReposicionCajaChica>("reposicionesCajaChica");

            string resultMessage = "";
            int itemID = 0;

            try
            {
                reposicionJson = JsonConvert.DeserializeObject<ReposicionCajaChica>(value);

                // TODO: lo primero que hacemos es determinar si el usuario tiene permiso para cerrar una reposición en Contab 

                ControlCajaChicaEntities controlCajaChicaContext = new ControlCajaChicaEntities();

                CajaChica_Usuarios permisoUsuario = controlCajaChicaContext.CajaChica_Usuarios.Where(u => u.CajaChica == reposicionJson.CajaChicaID).
                                                                                               Where(u => u.NombreUsuario == User.Identity.Name).
                                                                                               Where(u => u.Estado == "CE").
                                                                                               FirstOrDefault();

                if (permisoUsuario == null)
                {
                    string message = "Error: aparentemente, Ud. no tiene el permiso necesario para cerrar esta reposición.<br />" +
                        "Ud. puede cerrar y pasar una reposición a Contab, solo si tiene el permiso necesario para hacerlo.";

                    var errorResult = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = message
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }

                // agregamos la reposión a Contab, como una reposición ya cerrada ... 

                CajaChica_Reposiciones reposicion;
                CajaChica_Reposiciones_Gastos gasto;

                reposicion = new CajaChica_Reposiciones()
                {
                    CajaChica = (short)reposicionJson.CajaChicaID,
                    Fecha = reposicionJson.Fecha,
                    Observaciones = reposicionJson.Observaciones,
                    EstadoActual = "CE"
                };

                foreach (var g in reposicionJson.Gastos)
                {
                    gasto = new CajaChica_Reposiciones_Gastos()
                    {
                        Rubro = (short)g.RubroID,
                        Descripcion = g.Descripcion,
                        MontoNoImponible = g.MontoNoImponible,
                        Monto = g.MontoImponible,
                        IvaPorc = g.IvaPorc,
                        Iva = g.Iva,
                        Total = g.Total,
                        FechaDocumento = g.FechaDoc,
                        NumeroDocumento = g.NumeroDoc,
                        NumeroControl = g.NumeroControl,
                        Proveedor = g.ProveedorID,
                        Nombre = g.Proveedor2,
                        Rif = g.Rif,
                        AfectaLibroCompras = g.AfectaLibroCompras,
                        NombreUsuario = User.Identity.Name
                    };

                    reposicion.CajaChica_Reposiciones_Gastos.Add(gasto);
                }

                // finalmente, agregamos un registro a la tabla de registro de estados por los cuales va pasando una reposición 
                CajaChica_Reposiciones_Estados estadoCajaChica = new CajaChica_Reposiciones_Estados()
                {
                    Fecha = DateTime.Now,
                    NombreUsuario = User.Identity.Name,
                    Estado = "CE"
                };

                reposicion.CajaChica_Reposiciones_Estados.Add(estadoCajaChica);

                controlCajaChicaContext.CajaChica_Reposiciones.AddObject(reposicion);

                controlCajaChicaContext.SaveChanges();

                // ------------------------------------------------------------------------------------------------------
                // ahora intentamos guardar los cambios a la reposición, esta vez en mongo, para que la reposición quede 
                // actualizada para cuando el usuario la vea la próxima vez ... 
                reposicionJson.Estado = "CE";
                reposicionJson.ReposicionID = reposicion.Reposicion;

                reposicionesMongoCollection.InsertOneAsync(reposicionJson);
                // ------------------------------------------------------------------------------------------------------


                resultMessage = "Ok, la caja chica ha sido cerrada y pasada a <em>Contab</em> en forma satisfactoria.<br /><br />" +
                    "<b><em>Note</em></b> que la reposición permanecerá en su lista y Ud. podrá, si lo desea, volver a cerrala y " +
                    "pasarla (nuevamente) a Contab, esta vez, con un nuevo número de reposición.";

                itemID = reposicion.Reposicion;
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            var result = new
            {
                ErrorFlag = false,
                ErrorMessage = "",
                ResultMessage = resultMessage,
                ItemID = itemID
            };

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }


        // nótese como, nuevamente, usamos un argumento en este método, para diferenciar este route del anterior
        // todo ésto, pues no sabemos porqué web api no usa el nombre del método como parte para identificar el 
        // route ... 

        [HttpGet]
        [Route("api/ActualizarReposicionesCajaChicaWebApi/notificarReposicionViaEmail")]
        public HttpResponseMessage notificarReposicionViaEmail(string repID, string usuarioEmail)
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

            // --------------------------------------------------------------------------------------------------------------------------
            // establecemos una conexión a mongodb 
            var client = new MongoClient("mongodb://localhost");
            var mongoDataBase = client.GetDatabase("dbContab");

            var reposicionesMongoCollection = mongoDataBase.GetCollection<ReposicionCajaChica>("reposicionesCajaChica");

            string resultMessage = "";

            try
            {
                // intentamos leer la reposición en mongo; debe existir ... 
                var reposicion = reposicionesMongoCollection.AsQueryable<ReposicionCajaChica>().Where(r => r.Id == repID).FirstOrDefault(); 

                if (reposicion == null)
                {
                    var errorResult = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = "Error: no hemos podido leer la reposición indicada en la base de datos; por favor revise."
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }

                // ambos usuarios deben tener un e-mail; tanto el usuario que registra la reposición como el indicado para enviar el correo 

                var usuario = Membership.GetUser(User.Identity.Name);

                if (string.IsNullOrEmpty(usuario.Email))
                {
                    var errorResult = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = "Error: Ud. debe tener una dirección de correo para poder notificar una reposición vía e-mail."
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }

                usuario = null; 
                usuario = Membership.GetUser(usuarioEmail);

                if (string.IsNullOrEmpty(usuario.Email))
                {
                    var errorResult = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = "Error: el usuario indicado debe tener una dirección de correo, para poder notificar una reposición vía e-mail."
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }

                CajaChica_CajasChicas cajaChicaReposicion; 

                using (ControlCajaChicaEntities controlCajaChicaContext = new ControlCajaChicaEntities())
                {
                    cajaChicaReposicion = controlCajaChicaContext.CajaChica_CajasChicas.Where(c => c.CajaChica == reposicion.CajaChicaID).FirstOrDefault();

                    if (cajaChicaReposicion == null)
                    {
                        var errorResult = new
                        {
                            ErrorFlag = true,
                            ErrorMessage = "Error: no hemos podido leer, en la base de datos, la caja chica que corresponde a la reposición; por favor revise."
                        };

                        return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                    }
                }


                // leemos la configuración del servidor de correos en la tabla de compañías 

                using (dbContab_Contab_Entities context = new dbContab_Contab_Entities())
                {
                    try
                    {
                        ContabSysNet_Web.ModelosDatos_EF.Contab.Compania ciaContab = context.Companias.Where(c => c.Numero == reposicion.CiaContabID).FirstOrDefault();

                        if (ciaContab == null)
                        {
                            var errorResult = new
                            {
                                ErrorFlag = true,
                                ErrorMessage = "Error: no hemos podido leer la compañía (Contab) a la cual corresponde la reposición, en la tabla de compañías."
                            };

                            return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                        }

                        if (ciaContab == null ||
                            string.IsNullOrEmpty(ciaContab.EmailServerName) ||
                            string.IsNullOrEmpty(ciaContab.EmailServerCredentialsUserName) ||
                            string.IsNullOrEmpty(ciaContab.EmailServerCredentialsPassword))
                        {
                            var errorResult = new
                            {
                                ErrorFlag = true,
                                ErrorMessage = "Aparentemente, no se ha registrado la configuración necesaria para enviar correos, " +
                                                "para la compañía (CiaContab) usada al seleccionar los registros.<br /><br />" +
                                                "Por favor revise el registro para la compañía (CiaContab) en la tabla Compañías y defina la " +
                                                "configuración necesaria para enviar e-mails."
                            };

                            return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                        }


                        string host = ciaContab.EmailServerName;
                        int? port = ciaContab.EmailServerPort;
                        bool enableSSL = ciaContab.EmailServerSSLFlag != null ? ciaContab.EmailServerSSLFlag.Value : false;
                        string emailCredentialsUserName = ciaContab.EmailServerCredentialsUserName;
                        string emailCredentialsUserPassword = ciaContab.EmailServerCredentialsPassword;

                        string emailUsuarioFrom = Membership.GetUser(User.Identity.Name).Email;
                        string emailUsuarioTo = Membership.GetUser(usuarioEmail).Email;

                        string errorMessage = ""; 

                        if (!EnviarEmail(host, 
                                         port, 
                                         enableSSL, 
                                         emailCredentialsUserName, 
                                         emailCredentialsUserPassword, 
                                         emailUsuarioTo, 
                                         emailUsuarioFrom, 
                                         reposicion, 
                                         ciaContab.Nombre, 
                                         cajaChicaReposicion.Descripcion, 
                                         out errorMessage))
                        {
                            var errorResult = new
                            {
                                ErrorFlag = true,
                                ErrorMessage = "Error inesperado: hemos obtenido un error al intentar enviar el correo de notificación.<br />" +
                                               "El mensaje específico del error es: " + errorMessage
                            };

                            return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                        }
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

                resultMessage = "Ok, el correo de notificación ha sido enviado ...";
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            var result = new
            {
                ErrorFlag = false,
                ErrorMessage = "",
                ResultMessage = resultMessage,
            };

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        private bool EnviarEmail(string host, 
                                 int? port, bool enableSSL, 
                                 string emailCredentialsUserName, 
                                 string emailCredentialsUserPassword, 
                                 string usuarioTO, 
                                 string usuarioCC, 
                                 ReposicionCajaChica reposicion, 
                                 string ciaContabNombre, 
                                 string cajaChicaNombre, 
                                 out string resultMessage)
        {
            resultMessage = ""; 

            SendEmail sendMail = new SendEmail(host, port, enableSSL, emailCredentialsUserName, emailCredentialsUserPassword);

            sendMail.FromAddress = usuarioCC;
            sendMail.ToAddress = usuarioTO;
            sendMail.CCAddress = usuarioCC;

            sendMail.Subject = "Notificación de registro en Contab de reposición de caja chica"; 

            StringBuilder mailBody = new StringBuilder();

            mailBody.Append("<b>" + "Hola estimado (a)" + "</b><br /><br /><br />");

            mailBody.Append("Le escribimos para notificarle el registro, en Contab, de la reposición de caja chica que sigue a continuación: ");
            mailBody.Append("<br /><br /><br />");

            mailBody.Append("<table style='border-collapse: collapse; border: 1px solid black; '><thead><tr>");
            mailBody.Append("<th style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black '>Número</th>");
            mailBody.Append("<th style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>Fecha</th>");
            mailBody.Append("<th style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>Estado</th>");
            mailBody.Append("<th style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>Caja chica</th>");
            mailBody.Append("<th style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>Cia contab</th></tr></thead><tbody><tr>");

            mailBody.Append("<td style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>" + reposicion.ReposicionID.ToString() + "</td>");
            mailBody.Append("<td style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>" + reposicion.Fecha.ToString("dd-MMM-yyyy") + "</td>");
            mailBody.Append("<td style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>" + reposicion.Estado + "</td>");
            mailBody.Append("<td style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>" + cajaChicaNombre + "</td>");
            mailBody.Append("<td style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>" + ciaContabNombre + "</td></tr></tbody></table>");

            mailBody.Append("<br /><br /><br />");

            mailBody.Append("<table style='border-collapse: collapse; border: 1px solid black;'><thead><tr>");
            mailBody.Append("<th style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>Cant<br />líneas</th>");
            mailBody.Append("<th style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>Monto no<br />imponible</th>");
            mailBody.Append("<th style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>Monto<br />imponible</th>");
            mailBody.Append("<th style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>Iva</th>");
            mailBody.Append("<th style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>Total</th></tr></thead><tbody><tr>");

            mailBody.Append("<td style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>" + reposicion.Gastos.Count().ToString() + "</td>");
            mailBody.Append("<td style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>" + reposicion.Gastos.Sum(g => g.MontoNoImponible).Value.ToString("N2") + "</td>");
            mailBody.Append("<td style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>" + reposicion.Gastos.Sum(g => g.MontoImponible).ToString("N2") + "</td>");
            mailBody.Append("<td style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>" + reposicion.Gastos.Sum(g => g.Iva).Value.ToString("N2") + "</td>");
            mailBody.Append("<td style='text-align: center; padding-left: 10px; padding-right: 10px; padding-top: 5px; border: 1px solid black; '>" + reposicion.Gastos.Sum(g => g.Total).ToString("N2") + "</td></tr></tbody></table>");

            mailBody.Append("<br /><br /><br />");
            mailBody.Append("Gracias por su atención ... <br /><br /><br />");
            mailBody.Append("Módulo de administración de caja chica<br />");
            mailBody.Append("<em><b>Contab</b></em>");

            sendMail.Body = mailBody.ToString();

            string errorMessage = "";
            if (!sendMail.Send(out errorMessage))
            {
                resultMessage = errorMessage;
                return false;
            }

            return true; 
        }

        [HttpGet]
        [Route("api/ActualizarReposicionesCajaChicaWebApi/ExportarAExcel")]
        public HttpResponseMessage ExportarAExcel(string itemID)
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

            // --------------------------------------------------------------------------------------------------------------------------
            // establecemos una conexión a mongodb 
            var client = new MongoClient("mongodb://localhost");
            var mongoDataBase = client.GetDatabase("dbContab");

            var reposicionesMongoCollection = mongoDataBase.GetCollection<ReposicionCajaChica>("reposicionesCajaChica");

            string resultMessage = "";

            try
            {
                ReposicionCajaChica reposicion = reposicionesMongoCollection.AsQueryable<ReposicionCajaChica>().Where(r => r.Id == itemID).FirstOrDefault();

                if (reposicion == null)
                {
                    string message = "Error: no hemos podido leer la reposición indicada en la base de datos.";
                    
                    var errorResult = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = message
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }


                string errorMessage = "";
                string excelDocFileName = ""; 

                if (!ExportarReposicionAExcel(reposicion, out excelDocFileName, out errorMessage))
                {
                    var errorResult = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = errorMessage
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }

                resultMessage = "";
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            var result = new
            {
                ErrorFlag = false,
                ErrorMessage = "",
                ResultMessage = resultMessage
            };

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        private bool ExportarReposicionAExcel(ReposicionCajaChica reposicion, out string excelDocFileName, out string errorMessage)
        {
            errorMessage = "";
            excelDocFileName = ""; 

            // debemos leer algunos datos en sql server ... 

            ControlCajaChicaEntities controlCajaChicaContext = new ControlCajaChicaEntities();
            BancosEntities bancosContext = new BancosEntities();

            CajaChica_CajasChicas cajaChica = controlCajaChicaContext.CajaChica_CajasChicas.Where(c => c.CajaChica == reposicion.CajaChicaID).FirstOrDefault(); 

            // -----------------------------------------------------------------------------------------------------------------
            // preparamos el documento Excel, para tratarlo con ClosedXML ... 
            string fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/ReposicionCajaChica.xlsx");

            XLWorkbook wb;
            IXLWorksheet ws;

            try
            {
                wb = new XLWorkbook(fileName);
                ws = wb.Worksheet(1);
            }
            catch (Exception ex)
            {
                errorMessage = ex.Message;
                if (ex.InnerException != null)
                    errorMessage += "<br />" + ex.InnerException.Message;

                return false;
            }

            var excelTable = ws.Table("ReposicionCajaChica");
            // -----------------------------------------------------------------------------------------------------------------

            int cantidadRows = 0;
            CajaChica_Rubros rubroCajaChica; 
            string nombreProveedorContab; 

            foreach (var gasto in reposicion.Gastos)
            {
                cantidadRows++;

                rubroCajaChica = controlCajaChicaContext.CajaChica_Rubros.Where(r => r.Rubro == gasto.RubroID).FirstOrDefault(); 

                nombreProveedorContab = ""; 
                if (gasto.ProveedorID != null)  
                    nombreProveedorContab = bancosContext.Proveedores.Where(p => p.Proveedor == gasto.ProveedorID).FirstOrDefault().Nombre; 

                excelTable.DataRange.LastRow().Field(0).SetValue(rubroCajaChica != null ? rubroCajaChica.Descripcion : "Indefinido");
                excelTable.DataRange.LastRow().Field(1).SetValue(gasto.Descripcion);
                excelTable.DataRange.LastRow().Field(2).SetValue(!string.IsNullOrEmpty(nombreProveedorContab) ? nombreProveedorContab : "");
                excelTable.DataRange.LastRow().Field(3).SetValue(gasto.Proveedor2);

                excelTable.DataRange.LastRow().Field(4).SetValue(gasto.Rif);  
                excelTable.DataRange.LastRow().Field(5).SetValue(Convert.ToDateTime(gasto.FechaDoc.ToString("yyyy-MM-dd")));    // mongo regresa 4:30 a la fecha ... 
                excelTable.DataRange.LastRow().Field(6).SetValue(gasto.NumeroDoc);   
                excelTable.DataRange.LastRow().Field(7).SetValue(gasto.NumeroControl);

                excelTable.DataRange.LastRow().Field(8).SetValue(gasto.MontoNoImponible);
                excelTable.DataRange.LastRow().Field(9).SetValue(gasto.MontoImponible);
                excelTable.DataRange.LastRow().Field(10).SetValue(gasto.IvaPorc);
                excelTable.DataRange.LastRow().Field(11).SetValue(gasto.Iva);
                excelTable.DataRange.LastRow().Field(12).SetValue(gasto.Total);

                excelTable.DataRange.LastRow().Field(13).SetValue(gasto.AfectaLibroCompras ? "si" : "");

                excelTable.DataRange.InsertRowsBelow(1);
            }

            // en el libro de ventas, asumimos que el usuario seleccionó una sola empresa (cia contab) y usamos el primer registro 
            // de la lista de items seleccionados para obtenerla ... 

            string nombreCiaContab = bancosContext.Companias.Where(c => c.Numero == reposicion.CiaContabID).FirstOrDefault().Nombre;
            
            ws.Cell("B3").Value = nombreCiaContab;

            ws.Cell("D4").Value = "Numero: " + reposicion.ReposicionID.ToString();
            ws.Cell("G4").Value = reposicion.Fecha;
            ws.Cell("J4").Value = cajaChica.Descripcion;
            ws.Cell("D5").Value = "Estado: " + reposicion.Estado;
            ws.Cell("G5").Value = reposicion.Observaciones;
            
            string userName = User.Identity.Name.Replace("@", "_").Replace(".", "_");
            fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/ReposicionCajaChica_" + userName + ".xlsx");

            if (File.Exists(fileName))
                File.Delete(fileName);

            try
            {
                wb.SaveAs(fileName);
                excelDocFileName = fileName; 

                //string errorMessage = "Ok, la función que exporta los datos a Microsoft Excel se ha ejecutado en forma satisfactoria.<br />" +
                //    "En total, se han agregado " + cantidadRows.ToString() + " registros a la tabla en el documento Excel.<br />" +
                //    "Ud. debe hacer un <em>click</em> en el botón que permite obtener (<em>download</em>) el documento Excel.";

            }
            catch (Exception ex)
            {
                errorMessage = ex.Message;
                if (ex.InnerException != null)
                    errorMessage += "<br />" + ex.InnerException.Message;

                return false;
            }

            return true;
        }


        [HttpGet]
        [Route("api/ActualizarReposicionesCajaChicaWebApi/DownloadExcelFile")]
        // no necesitamos parámetros aquí, pero si no los agregamos, web api no encuentra la requisición; evidentemente, deberíamos resolver ésto, solo que 
        // es complicado encontrar como hacerlo ... 
        public HttpResponseMessage DownloadExcelFile(int param1, int param2)
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
                string userName = User.Identity.Name.Replace("@", "_").Replace(".", "_");
                string fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/ReposicionCajaChica_" + userName + ".xlsx");

                HttpResponseMessage result2 = new HttpResponseMessage(HttpStatusCode.OK);

                var stream = new FileStream(fileName, FileMode.Open);
                result2.Content = new StreamContent(stream);
                result2.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.ms-excel");
                result2.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
                result2.Content.Headers.ContentDisposition.FileName = fileName;

                return result2;
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }
        }
    }
}