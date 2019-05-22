using ContabSysNet_Web.Areas.Bancos.Models.Companias;
using ContabSysNet_Web.Areas.Bancos.Models.mongodb;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace ContabSysNet_Web.Areas.Bancos.Controllers
{
    public class CompaniasWebApiController : ApiController
    {
        [HttpGet]
        [Route("api/CompaniasWebApi/LeerCompanias")]
        public HttpResponseMessage LeerCompanias()
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
            string contabm_mongodb_connection = System.Web.Configuration.WebConfigurationManager.AppSettings["contabm_mongodb_connectionString"];
            string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

            var client = new MongoClient(contabm_mongodb_connection);
            // var server = client.GetServer();
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            var mongoDataBase = client.GetDatabase(contabM_mongodb_name);
            // --------------------------------------------------------------------------------------------------------------------------

            var companiasMongoCollection = mongoDataBase.GetCollection<Compania_mongodb>("Compania");

            try
            {
                // --------------------------------------------------------------------------------------------------------------------------
                // eliminamos las facturas en la tabla 'temporal' que corresponden al usuario 
                var builder = Builders<Compania_mongodb>.Filter;
                var filter = builder.Eq(x => x.Id, -999999999);

                companiasMongoCollection.DeleteManyAsync(filter);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                message = "Se producido un error al intentar ejecutar una operación en mongodb.<br />" +
                          "El mensaje específico del error es:<br />" + message;

                var errorResult = new
                {
                    errorFlag = true,
                    resultMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                   "El mensaje específico de error es: <br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            using (BancosEntities bancosContext = new BancosEntities())
            {
                try
                {
                    List<Compania_ActualizarCuentasBancarias> companias = new List<Compania_ActualizarCuentasBancarias>();
                    Compania_ActualizarCuentasBancarias compania; 

                    var query = bancosContext.Proveedores.Select(c => new
                    {
                        nombre = c.Nombre,
                        id = c.Proveedor,
                        ciudad = c.tCiudade.Descripcion,
                        clienteProveedor = c.ProveedorClienteFlag,
                        tipo = c.TiposProveedor.Descripcion,
                        rif = c.Rif,
                        naturalJuridico = c.NatJurFlag
                    }).ToList();

                    foreach (var c in query)
                    {

                        compania = new Compania_ActualizarCuentasBancarias();

                        compania.nombre = c.nombre;
                        compania.id = c.id;
                        compania.ciudad = c.ciudad;
                        compania.clienteProveedor = c.clienteProveedor;
                        compania.tipo = c.tipo;
                        compania.rif = c.rif;
                        compania.naturalJuridico = c.naturalJuridico;

                        // ahora buscamos la compañía en mongo; si existe, agregamos las cuentas bancarias ... 
                        var companiaMongo = companiasMongoCollection.AsQueryable().Where(e => e.Id == compania.id).FirstOrDefault(); 

                        if (companiaMongo != null)
                        {
                            Compania_ActualizarCuentasBancarias_CuentaBancaria cuentaBancaria; 

                            foreach (var cuentaBancos in companiaMongo.cuentasBancarias)
                            {
                                cuentaBancaria = new Compania_ActualizarCuentasBancarias_CuentaBancaria();

                                cuentaBancaria.numero = cuentaBancos.numero;
                                cuentaBancaria.banco = cuentaBancos.banco;
                                cuentaBancaria.isDefault = cuentaBancos.isDefault;
                                cuentaBancaria.tipo = cuentaBancos.tipo;

                                compania.cuentasBancarias.Add(cuentaBancaria); 
                            }
                        }

                        companias.Add(compania); 
                    }

                    var result = new
                    {
                        errorFlag = false,
                        resultMessage = "",
                        companias = companias
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
                        resultMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                       "El mensaje específico de error es: <br />" + message
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }
            }
        }


        [HttpGet]
        [Route("api/CompaniasWebApi/LeerBancos")]
        public HttpResponseMessage LeerBancos()
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

            using (BancosEntities bancosContext = new BancosEntities())
            {
                try
                {
                    var bancos = bancosContext.Bancos.Select(b => new { id = b.Banco1, nombre = b.Nombre }).ToList();

                    var result = new
                    {
                        errorFlag = false,
                        resultMessage = "",
                        bancos = bancos
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
                        resultMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                       "El mensaje específico de error es: <br />" + message
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }
            }
        }


        [HttpPost]
        [Route("api/CompaniasWebApi/GrabarCompanias")]
        public HttpResponseMessage GrabarCompanias(List<Compania_mongodb> companias)
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
            string contabm_mongodb_connection = System.Web.Configuration.WebConfigurationManager.AppSettings["contabm_mongodb_connectionString"];
            string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

            var client = new MongoClient(contabm_mongodb_connection);
            // var server = client.GetServer();
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            var mongoDataBase = client.GetDatabase(contabM_mongodb_name);
            // --------------------------------------------------------------------------------------------------------------------------

            var companiasMongoCollection = mongoDataBase.GetCollection<Compania_mongodb>("Compania");

            try
            {
                // --------------------------------------------------------------------------------------------------------------------------
                // eliminamos las facturas en la tabla 'temporal' que corresponden al usuario 
                var builder = Builders<Compania_mongodb>.Filter;
                var filter = builder.Eq(x => x.Id, -999999999);

                companiasMongoCollection.DeleteManyAsync(filter);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                message = "Se producido un error al intentar ejecutar una operación en mongodb.<br />" +
                          "El mensaje específico del error es:<br />" + message;

                var errorResult = new
                {
                    errorFlag = true,
                    resultMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                   "El mensaje específico de error es: <br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            try
            {
                int cantidadItemsActualizados = 0; 

                foreach (var compania in companias)
                {
                    foreach (var cuenta in compania.cuentasBancarias)
                    {
                        cuenta.Id = MongoDB.Bson.ObjectId.GenerateNewId();
                    }

                    // companiasMongoCollection.Save<Compania_mongodb>(compania);



                    companiasMongoCollection.ReplaceOneAsync(
                        item => item.Id == compania.Id,
                        compania,
                        new UpdateOptions { IsUpsert = true });

                    cantidadItemsActualizados++; 
                }


                var result = new
                {
                    errorFlag = false,
                    resultMessage = "Ok, " + cantidadItemsActualizados.ToString() + " compañías han sido actualizadas en la base de datos."
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
                    resultMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                    "El mensaje específico de error es: <br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

        }
    }
}