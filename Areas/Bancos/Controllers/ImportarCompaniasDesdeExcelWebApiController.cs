
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using Newtonsoft.Json;
using ContabSysNet_Web.Areas.Bancos.Models.ImportarFacturasDesdeExcel;
using MongoDB.Driver;
using ContabSysNet_Web.Areas.Bancos.Models.mongodb;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;

using MongoDB.Driver.Linq;
using ContabSysNet_Web.Clases;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using System.Globalization;

namespace ContabSysNet_Web.Areas.Bancos.Controllers
{
    public class ImportarCompaniasDesdeExcelWebApiController : ApiController
    {
        [HttpGet]
        public HttpResponseMessage LeerCiaContabSeleccionada(string parametros)
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

            // leemos y regresamos el porcentaje del iva; este valor está en la tabla ParametrosGlobalBancos ... 

            Single? ivaPorc; 

            using (BancosEntities bancosContext = new BancosEntities())
            {
                try
                {
                    ivaPorc = bancosContext.ExecuteStoreQuery<Single?>("Select IvaPorc From ParametrosGlobalBancos").FirstOrDefault();

                    if (ivaPorc == null)
                    {
                        var errorResult = new
                        {
                            ErrorFlag = true,
                            ErrorMessage = "Error: no hemos podido leer un porcentaje de Iva en la tabla <em>Parámetros Global Bancos</em>.<br />" +
                                    "Por favor abra esta tabla en Contab y registre un valor para el porcentaje de Iva."
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

            var result = new
                {
                    ErrorFlag = false,
                    ErrorMessage = "", 
                    ciaContabSeleccionada = ciaContabSeleccionada,
                    ciaContabSeleccionadaNombre = nombreCiaContabSeleccionada, 
                    ivaPorc = ivaPorc
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
        }


        [HttpPost]
        public HttpResponseMessage GrabarExcelDataAMongoDB([FromBody]string value)
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

            List<FacturaExcelRow> filtroJson;

            // --------------------------------------------------------------------------------------------------------------------------
            // establecemos una conexión a mongodb 
            string contabm_mongodb_connection = System.Web.Configuration.WebConfigurationManager.AppSettings["contabm_mongodb_connectionString"];
            string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

            var client = new MongoClient(contabm_mongodb_connection);
            // var server = client.GetServer();
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            var mongoDataBase = client.GetDatabase(contabM_mongodb_name);

            var facturasImportarDesdeExcel = mongoDataBase.GetCollection<Temp_FacturaImportarDesdeExcel>("Temp_FacturaImportarDesdeExcel");

            try
            {
                filtroJson = JsonConvert.DeserializeObject<List<FacturaExcelRow>>(value);

                // --------------------------------------------------------------------------------------------------------------------------
                // primero que todo, eliminamos (en mongo) los registros que puedan existir para el usuario 
                var builder = Builders<Temp_FacturaImportarDesdeExcel>.Filter;
                var filter = builder.Eq(x => x.Usuario, User.Identity.Name);

                facturasImportarDesdeExcel.DeleteManyAsync(filter);
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

            // ahora copiamos cada registro que llegó a este método, al collection en mongo ... 

            Temp_FacturaImportarDesdeExcel facturaFromExcelMongoDocument;
            DateTime? nullDateTime = null;

            foreach (FacturaExcelRow excelRow in filtroJson)
            {
                facturaFromExcelMongoDocument = new Temp_FacturaImportarDesdeExcel();

                try
                {
                    facturaFromExcelMongoDocument.Cliente = excelRow.Cliente;
                    facturaFromExcelMongoDocument.Rif = excelRow.Rif;
                    facturaFromExcelMongoDocument.ApellidoPropietario = excelRow.ApellidoPropietario;
                    facturaFromExcelMongoDocument.NombrePropietario = excelRow.NombrePropietario;
                    facturaFromExcelMongoDocument.Telefono = excelRow.Telefono;
                    facturaFromExcelMongoDocument.Celular = excelRow.Celular;
                    facturaFromExcelMongoDocument.Email = excelRow.Email;
                    facturaFromExcelMongoDocument.Direccion = excelRow.Direccion;
                    facturaFromExcelMongoDocument.Ciudad = excelRow.Ciudad;
                    facturaFromExcelMongoDocument.Estado = excelRow.Estado;
                    facturaFromExcelMongoDocument.VigDesde = Convert.ToDateTime(excelRow.VigDesde);
                    facturaFromExcelMongoDocument.VigHasta = Convert.ToDateTime(excelRow.VigHasta);
                    facturaFromExcelMongoDocument.Certificado = excelRow.Certificado;
                    facturaFromExcelMongoDocument.CertAsoc = excelRow.CertAsoc;
                    facturaFromExcelMongoDocument.Representante = excelRow.Representante;
                    facturaFromExcelMongoDocument.MarcaModeloVersion = excelRow.MarcaModeloVersion;
                    facturaFromExcelMongoDocument.Placa = excelRow.Placa;

                    // nótese como usamos 'en-US' culture (ie: locale) para que la conversión tome el '.' como un punto decimal (como es en USA) ... 
                    facturaFromExcelMongoDocument.Membresia = Convert.ToDecimal(excelRow.Membresia, new CultureInfo("en-US"));
                    facturaFromExcelMongoDocument.MembresiaBase = Convert.ToDecimal(excelRow.MembresiaBase, new CultureInfo("en-US"));
                    facturaFromExcelMongoDocument.MembresiaIva = Convert.ToDecimal(excelRow.MembresiaIva, new CultureInfo("en-US"));

                    facturaFromExcelMongoDocument.ArysVial = Convert.ToDecimal(excelRow.ArysVial, new CultureInfo("en-US"));
                    facturaFromExcelMongoDocument.ArysVialBase = Convert.ToDecimal(excelRow.ArysVialBase, new CultureInfo("en-US"));
                    facturaFromExcelMongoDocument.ArysVialIva = Convert.ToDecimal(excelRow.ArysVialIva, new CultureInfo("en-US"));

                    facturaFromExcelMongoDocument.FechaRegistro = Convert.ToDateTime(excelRow.FechaRegistro);
                    facturaFromExcelMongoDocument.Estatus = excelRow.Estatus;
                    facturaFromExcelMongoDocument.FecBaja = !string.IsNullOrEmpty(excelRow.FecBaja) ? Convert.ToDateTime(excelRow.FechaRegistro) : nullDateTime;

                    facturaFromExcelMongoDocument.Usuario = User.Identity.Name;

                    facturasImportarDesdeExcel.InsertOneAsync(facturaFromExcelMongoDocument);
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

            // nótese como aprovechamos para leer y regresar algunos catálogos que necesitamos para registrar las compañías y facturas ... 

            BancosEntities bancosContext = new BancosEntities();

            var tiposCompania = bancosContext.TiposProveedors.OrderBy(t => t.Descripcion).Select(t => new { id = t.Tipo, descripcion = t.Descripcion });
            var monedas = bancosContext.Monedas.OrderBy(t => t.Descripcion).Select(t => new { id = t.Moneda1, descripcion = t.Descripcion });
            var cargos = bancosContext.tCargos.OrderBy(t => t.Descripcion).Select(t => new { id = t.Cargo, descripcion = t.Descripcion });
            var formasPago = bancosContext.FormasDePagoes.OrderBy(t => t.Descripcion).Select(t => new { id = t.FormaDePago, descripcion = t.Descripcion });
            var titulos = bancosContext.Personas.OrderBy(p => p.Titulo).Select(p => new { id = p.Titulo }).Distinct();

            var result = new
            {
                ErrorFlag = false,
                ErrorMessage = "",
                ResultMessage = "Ok, los registros importados desde el documento Excel han sido grabados al servidor;<br />" +
                    "en total, hemos registrado al servidor " + filtroJson.Count().ToString() + " registros.<br />" +
                    "Ahora Ud. puede continuar con el siguiente paso de este proceso.", 
                TiposCompania = tiposCompania.ToList(),
                Monedas = monedas.ToList(), 
                Cargos = cargos.ToList(),
                FormasPago = formasPago.ToList(), 
                Titulos = titulos.ToList()
            };

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }


        [HttpGet]
        public HttpResponseMessage ValidarExistenciaCompanias()
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

            var facturasImportarDesdeExcel = mongoDataBase.GetCollection<Temp_FacturaImportarDesdeExcel>("Temp_FacturaImportarDesdeExcel");

            var query = facturasImportarDesdeExcel.AsQueryable<Temp_FacturaImportarDesdeExcel>().
                                                       Where(f => f.Usuario == User.Identity.Name).
                                                       Select(f => f.Rif);

            BancosEntities bancosContext = new BancosEntities();

            List<string> companiasYaExisten = new List<string>();

            try
            {
                foreach (string numeroRif in query)
                {
                    Proveedore compania = bancosContext.Proveedores.Where(p => p.Rif == numeroRif || p.Rif == numeroRif.Replace("-", "")).FirstOrDefault();

                    if (compania != null)
                        companiasYaExisten.Add(numeroRif);
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
                    ErrorMessage = "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            var result = new
            {
                ErrorFlag = false,
                ErrorMessage = "",
                CompaniasQueExisten = companiasYaExisten,
                ResultMessage = "Ok, la verificación de las compañías en la base de datos en el servidor, ha finalizado.<br />" +
                    "De un total de " + query.Count().ToString() + " registros leídos desde Excel, cada uno para una compañía, " +
                    "hemos encontrado que ya existen " + companiasYaExisten.Count().ToString() + " compañías registradas.<br />" +
                    "Las compañías marcadas en azul fueron encontradas (existen); las mostradas en rojo no existen, y serán grabadas si Ud. " +
                    "ejecuta el próximo paso."
            };

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }


        [HttpPost]
        public HttpResponseMessage GrabarCompaniasQueNoExisten(int tipoCompania, int moneda, int cargo, int formaPago, string titulo)
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

            var facturasImportarDesdeExcel = mongoDataBase.GetCollection<Temp_FacturaImportarDesdeExcel>("Temp_FacturaImportarDesdeExcel");

            var query = facturasImportarDesdeExcel.AsQueryable<Temp_FacturaImportarDesdeExcel>().
                                                       Where(f => f.Usuario == User.Identity.Name);

            BancosEntities bancosContext = new BancosEntities();

            Proveedore compania;
            Persona persona; 


            int cantidadCompaniasGrabadas = 0;
            int cantidadCompaniasYaExistian = 0;
            int cantidadCompaniasLeidas = 0;
            string message; 

            // no tenemos los departamentos en EF; simplemente, leemos el primero para asignarlo a todas las personas registradas aquí ... 

            int? departamento = bancosContext.Personas.Select(p => p.Departamento).First(); 

            try
            {
                foreach (Temp_FacturaImportarDesdeExcel factura in query)
                {
                    cantidadCompaniasLeidas++; 

                    Proveedore ciaExiste = bancosContext.Proveedores.Where(p => p.Rif == factura.Rif || p.Rif == factura.Rif.Replace("-", "")).FirstOrDefault();

                    if (ciaExiste != null)
                    {
                        cantidadCompaniasYaExistian++;
                        continue; 
                    }
                        

                    cantidadCompaniasGrabadas++;

                    // la ciudad debe existir ... 

                    tCiudade ciudad = bancosContext.tCiudades.Where(c => c.Descripcion == factura.Ciudad).FirstOrDefault();

                    if (ciudad == null)
                    {
                        message = "Error: la ciudad '" + factura.Ciudad + "' no existe en la tabla de ciudades.<br />" +
                            "Ud. debe agregar la ciudad a la tabla de ciudades y luego regresar a ejecutar este proceso.";

                        var errorResult = new
                        {
                            ErrorFlag = true,
                            ErrorMessage = message
                        };

                        return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                    }


                    // la compañía no existe en Contab; intentamos registrarla ... 

                    compania = new Proveedore()
                    {
                        Nombre = factura.NombrePropietario + " " + factura.ApellidoPropietario,
                        ProveedorClienteFlag = 2,                           // cliente 
                        Tipo = tipoCompania,
                        MonedaDefault = moneda,
                        Rif = factura.Rif,
                        NacionalExtranjeroFlag = 1,                         // nacional 
                        NatJurFlag = Convert.ToInt16((factura.Rif.Substring(0, 1) != "J" ? 1 : 2)),       // 1: natural; 2: jurídico 
                        Abreviatura = (factura.NombrePropietario.Length >= 10 ? factura.NombrePropietario.Substring(0, 10) : factura.NombrePropietario),
                        FormaDePagoDefault = formaPago,
                        SujetoARetencionFlag = false,
                        CodigoConceptoRetencion = null,
                        PorcentajeDeRetencion = null,
                        BaseRetencionISLR = null,
                        AplicaIvaFlag = null,
                        ContribuyenteEspecialFlag = null,
                        RetencionSobreIvaPorc = null,
                        Beneficiario = factura.NombrePropietario + " " + factura.ApellidoPropietario,
                        Concepto = factura.Placa + " - " + factura.MarcaModeloVersion,
                        Ciudad = ciudad.Ciudad,
                        Direccion = factura.Direccion,
                        Telefono1 = factura.Telefono,
                        Telefono2 = factura.Celular,
                        Ingreso = DateTime.Now,
                        UltAct = DateTime.Now,
                        Usuario = User.Identity.Name
                        //Lote = "TODO: asignar un número de lote ..."
                    };

                    persona = new Persona()
                    {
                        Nombre = factura.NombrePropietario,
                        Apellido = factura.ApellidoPropietario,
                        Telefono = factura.Telefono,
                        Celular = factura.Celular,
                        email = factura.Email,
                        DefaultFlag = true,
                        Cargo = cargo,
                        Departamento = departamento,
                        Titulo = titulo,
                        Ingreso = DateTime.Now,
                        UltAct = DateTime.Now,
                        Usuario = User.Identity.Name
                    };

                    compania.Personas.Add(persona);
                    bancosContext.Proveedores.AddObject(compania); 
                }
            }
            catch (Exception ex)
            {
                message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            try
            {
                bancosContext.SaveChanges();

                message = "Ok, las compañías se han cargado a la base de datos en forma satisfactoria.<br />" +
                          "La cantidad de compañías (líneas del doc Excel) leídas es: " + cantidadCompaniasLeidas.ToString() + "<br />" +
                          "De éstas, ya existían: " + cantidadCompaniasYaExistian.ToString() + "<br />" +
                          "Y fueron cargadas: " + cantidadCompaniasGrabadas.ToString(); 
                          // + "<br />" + "El valor asignado al 'lote' es: '" + lote + "'";
            }
            catch (Exception ex)
            {
                message = ex.Message;
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
                ResultMessage = message
            };

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }

        [HttpPost]
        public HttpResponseMessage GrabarFacturas(int ciaContabSeleccionadaID, 
                                                  decimal porcentajeImpuestosIva, 
                                                  string fechaEmisionFactura,
                                                  int? cantidadFacturasAAgregar)
        {
            string message = "";

            if (!User.Identity.IsAuthenticated)
            {
                message = "Error: Ud. debe hacer un login antes de continuar.<br />Por favor haga un login antes de intentar continuar con esta función.";

                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = message
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

            var facturasImportarDesdeExcel = mongoDataBase.GetCollection<Temp_FacturaImportarDesdeExcel>("Temp_FacturaImportarDesdeExcel");

            BancosEntities bancosContext = new BancosEntities();

            // ------------------------------------------------------------------------------------------------------------------
            // TODO: debe venir una Cia contab seleccionada (???); creo que tenemos que comenzar con ésto en el cliente ... 
            // ------------------------------------------------------------------------------------------------------------------

            ModelosDatos_EF.Bancos.Compania ciaContabSeleccionada = bancosContext.Companias.Where(c => c.Numero == ciaContabSeleccionadaID).
                                                                                            FirstOrDefault();

            if (ciaContabSeleccionada == null)
            {
                message = "Error: no hemos podido leer la compañía (Contab) que corresponde a la compañía Contab seleccionada en esta función. Por favor revise.";

                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            // para agregar el monto de impuestos Iva necesitamos una definición para este rubro (en la tabla ImpuestosRetencionesDefinicion); 
            // en esta tabla se predefinen configuraciones para impuestos y retenciones usados en las facturas ... 

            ImpuestosRetencionesDefinicion definicionImpuestosIva = bancosContext.ImpuestosRetencionesDefinicions.Where(i => i.Predefinido == 1).FirstOrDefault();

            if (definicionImpuestosIva == null)
            {
                message = "Error: no hemos podido leer un registro de definición para el impuesto Iva. <br />" +
                    "Ud. debe agregar una definición para el impuesto Iva en la tabla <em>Definición de impuestos y retenciones</em> (Bancos >> Catálogos).";

                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }


            porcentajeImpuestosIva = porcentajeImpuestosIva / 100;

            // ------------------------------------------------------------------------------------------------------------------
            // TODO: determinar siempre los números de factura y control en forma automática ... 
            // ------------------------------------------------------------------------------------------------------------------

            long numeroFactura = 0;
            long numeroControl = 0;

            // buscamos el próximo número de factura y/o control ... 

            // ----------------------------------------------------------------------------------------------
            // TODO: agregar FuncionesBancos ... 
            // ----------------------------------------------------------------------------------------------

            FuncionesBancos funcionesBancos = new FuncionesBancos(bancosContext);

            string errorMessage = "";

            if (!funcionesBancos.DeterminarProxNumeroFacturaClientes(ciaContabSeleccionadaID, out numeroFactura, out numeroControl, out errorMessage))
            {
                message = "Error: ha ocurrido un error al intentar determinar el próximo número de factura y/o control. " +
                    "El mensaje específico del error es: <br />" + errorMessage;

                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            DateTime fechaEmision; 

            if (!DateTime.TryParse(fechaEmisionFactura, out fechaEmision))
            {
                message = "Error: aparentemente, la fecha pasada a esta función no corresonde a un valor válido: '" + fechaEmisionFactura + "'. Por favor revise."; 

                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }


            Factura facturaNueva;

            int cantidadFacturasLeidas = 0;
            int cantidadFacturasAgregadas = 0;

            // para asegurarnos que el ingreso en todas las facturas será el mismo 
            // nótese como usamos un valor 'simple'; sin segundos ni milisegundos ... 

            DateTime fechaRegistro = Convert.ToDateTime(DateTime.Now.ToString("dd-MM-yyyy hh:mm tt"));          
            string lote = fechaRegistro.ToString("dd-MM-yyyy hh:mm tt").Trim() + " " + User.Identity.Name;

            // leemos las facturas (Excel rows) que se han cargado a mongo para el usuario ... 
            var query = facturasImportarDesdeExcel.AsQueryable<Temp_FacturaImportarDesdeExcel>().Where(f => f.Usuario == User.Identity.Name);
            
            foreach (var factura in query)
            {
                cantidadFacturasLeidas++;

                // revisamos que la compañía haya sido cargada antes ... 

                var compania = bancosContext.Proveedores.Where(p => p.Rif == factura.Rif || p.Rif == factura.Rif.Replace("-", "")).
                                                          FirstOrDefault();

                if (compania == null)
                {
                    message = "Error: la compañía cuyo rif es '" + factura.Rif + "' y de nombre " + factura.NombrePropietario + " " + factura.ApellidoPropietario +
                        " no existe en la tabla de compañías.<br />" +
                        "Esta compañía debería existir, si Ud. ejecutó la 'carga de compañías' *antes* de este paso.<br /> " +
                        "Note que este programa no agregó ninguna factura a la base de datos. <br />" +
                        "Por favor revise este aspecto antes de continuar.";

                    var errorResult = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = message
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }

                // revisamos que no haya una factura con el mismo número ... 

                string numeroFacturaString = numeroFactura.ToString(); 

                var facturaExiste = bancosContext.Facturas.
                    Where(f => f.NumeroFactura == numeroFacturaString && f.CxCCxPFlag == 2 && f.Cia == ciaContabSeleccionada.Numero).
                    FirstOrDefault();

                if (facturaExiste != null)
                {
                    message = "Error: el número asignado por este programa a alguna de las facturas a agregar ya existe. <br />" +
                        "En particular, la factura número '" + numeroFactura.ToString() + "' ya existe para la cia Contab seleccionada.<br />" +
                        "Note que este programa no agregó ninguna factura a la base de datos. <br />" +
                        "Por favor revise este aspecto antes de continuar.";

                    var errorResult = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = message
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }

                facturaNueva = new Factura()
                {
                    Cia = ciaContabSeleccionada.Numero,
                    Proveedor = compania.Proveedor,
                    FechaEmision = fechaEmision,
                    FechaRecepcion = fechaEmision,
                    CxCCxPFlag = 2,
                    NumeroFactura = numeroFactura.ToString(),
                    NumeroControl = numeroControl.ToString(),
                    CondicionesDePago = compania.FormaDePagoDefault.Value,
                    Moneda = compania.MonedaDefault.Value,
                    Tipo = compania.Tipo,
                    Concepto = factura.MarcaModeloVersion + " - " + factura.Certificado + " - " + factura.NombrePropietario + " " + factura.ApellidoPropietario,
                    Estado = 1,                         // pendiente 
                    Ingreso = fechaRegistro,
                    UltAct = fechaRegistro,
                    Usuario = User.Identity.Name
                };

                facturaNueva.MontoFacturaSinIva = 0;
                facturaNueva.MontoFacturaConIva = 0;
                facturaNueva.IvaPorc = porcentajeImpuestosIva * 100;

                facturaNueva.MontoFacturaConIva = 0; 
                facturaNueva.MontoFacturaConIva += Math.Round(factura.MembresiaBase, 2);
                facturaNueva.MontoFacturaConIva += Math.Round(factura.ArysVialBase, 2);

                facturaNueva.Iva = Math.Round(facturaNueva.MontoFacturaConIva.Value * porcentajeImpuestosIva, 2);
                facturaNueva.OtrosImpuestos = null;

                facturaNueva.TotalFactura = facturaNueva.MontoFacturaSinIva.Value + facturaNueva.MontoFacturaConIva.Value + facturaNueva.Iva.Value;

                facturaNueva.TotalAPagar = facturaNueva.TotalFactura;
                facturaNueva.RetencionSobreIva = null;
                facturaNueva.ImpuestoRetenido = null;
                facturaNueva.ImpuestoRetenidoISLRAntesSustraendo = null;
                facturaNueva.OtrasRetenciones = null;
                facturaNueva.Saldo = facturaNueva.TotalAPagar;

                // -------------------------------------------------------------------------------------------------------------
                // agregamos el monto de impuestos Iva en la tabla ImpuestosFacturas (nótese que la 'definición' para este impuesto fue 
                // leída arriba en la tabla ImpuestosRetencionesDefinicion) 

                if (facturaNueva.Iva != null && facturaNueva.Iva.Value != 0)
                {
                    Facturas_Impuestos impuestoIva = new Facturas_Impuestos()
                    {
                        MontoBase = facturaNueva.MontoFacturaConIva,
                        Porcentaje = facturaNueva.IvaPorc,
                        Monto = facturaNueva.Iva.Value,
                        TipoAlicuota = "G",
                        ImpRetID = definicionImpuestosIva.ID
                    };

                    facturaNueva.Facturas_Impuestos.Add(impuestoIva);
                }

                // -------------------------------------------------------------------------------------------------------------
                // muy importante: agregamos una cuota para la factura ... 
                // (asumimos que la forma de pago tiene 1 sola cuota (muy simple) y, por lo tanto, su proporción es siempre 100% 

                CuotasFactura cuota = new CuotasFactura()
                {
                    NumeroCuota = 1,
                    DiasVencimiento = 0,
                    FechaVencimiento = facturaNueva.FechaRecepcion,
                    ProporcionCuota = 100,
                    MontoCuota = facturaNueva.MontoFacturaSinIva.Value + facturaNueva.MontoFacturaConIva.Value,
                    Iva = facturaNueva.Iva,
                    OtrosImpuestos = facturaNueva.OtrosImpuestos,
                    RetencionSobreISLR = facturaNueva.ImpuestoRetenido,
                    RetencionSobreIva = facturaNueva.RetencionSobreIva,
                    OtrasRetenciones = facturaNueva.OtrasRetenciones,
                    Anticipo = facturaNueva.Anticipo,
                    TotalCuota = facturaNueva.TotalAPagar,
                    SaldoCuota = facturaNueva.Saldo,
                    EstadoCuota = facturaNueva.Estado
                };

                facturaNueva.CuotasFacturas.Add(cuota);


                bancosContext.Facturas.AddObject(facturaNueva);

                cantidadFacturasAgregadas++;

                numeroControl++;
                numeroFactura++;


                // -----------------------------------------------------------------------------------------------------------------------
                // actualizamos las facturas en mongo, para agregar número de lote, factura y control ... ésto permitirá poder asociar 
                // cada factura registrada con su correspondiente en mongo; al agregar los asientos contables, necesitaremos identificar 
                // cada factura en mongo, pues allí está separado el monto en: membresía y arisvial ... 
                var update = Builders<Temp_FacturaImportarDesdeExcel>.Update.Set(x => x.NumeroFacturaEnBancos, facturaNueva.NumeroFactura)
                                                                            .Set(x => x.NumeroControlEnBancos, facturaNueva.NumeroControl)
                                                                            .Set(x => x.NumeroLoteEnBancos, lote);

                var builder = Builders<Temp_FacturaImportarDesdeExcel>.Filter;
                var filter = builder.Eq(x => x.Id, factura.Id);

                facturasImportarDesdeExcel.UpdateOneAsync(filter, update);
                // -----------------------------------------------------------------------------------------------------------------------


                if (cantidadFacturasAAgregar != null && cantidadFacturasAAgregar.Value == cantidadFacturasLeidas)
                    // nótese que el usuario puede indicar una cantidad de facturas a agregar ... 
                    break;
            }

            if (cantidadFacturasLeidas == 0)
            {
                message = "Error: no hemos leído facturas registradas para el usuario '" + User.Identity.Name + "'.<br />" +
                          "Es probable que Ud. no haya cargado las facturas desde el documento Excel a la base de datos, " +
                          "antes de ejecutar este proceso.";

                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = message
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            try
            {
                bancosContext.SaveChanges();

                // nótese como usamos la 'fechaRegistro' para leer las facturas recién agregadas y actualizar su número de lote ... 
                // el número de lote es muy importante, pues permitirá identificar las facturas agregadas en forma 'masiva' en forma fácil 

                string sqlTransactCommand = "Update Facturas Set Lote = {0} Where Usuario = {1} And " +
                                            " Ingreso = {2} And UltAct = {2} And Cia = {3} And CxCCxPFlag = 2"; 

                int cantFacturasActualizadas = 
                bancosContext.ExecuteStoreCommand(sqlTransactCommand, new object[] { 
                                                                                        lote, 
                                                                                        User.Identity.Name, 
                                                                                        fechaRegistro, 
                                                                                        ciaContabSeleccionadaID 
                                                                                    }); 


                message = "Ok, las facturas se han cargado a la base de datos en forma satisfactoria.<br />" +
                          "La cantidad de facturas leídas desde la hoja Excel es: " + cantidadFacturasLeidas.ToString() + "<br />" +
                          "La cantidad de facturas agregadas a la base de datos es: " + cantidadFacturasAgregadas.ToString() + "<br />" +
                          "La cantidad de facturas asociadas al número de lote: " + cantFacturasActualizadas.ToString() + "<br />" +
                          "El valor asignado al 'lote' es: '" + lote + "'";

                var result = new
                {
                    ErrorFlag = false,
                    ErrorMessage = "",
                    ResultMessage = message, 
                    numeroLote = lote
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                var result0 = new
                {
                    ErrorFlag = true,
                    ErrorMessage = message
                };

                return Request.CreateResponse(HttpStatusCode.OK, result0);
            }
        }



        [HttpGet]
        public HttpResponseMessage LeerCatalogosGrabarAsientosContables(int ciaContabSeleccionadaID)
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

            dbContab_Contab_Entities contabContext = new dbContab_Contab_Entities();

            var cuentasContables = contabContext.CuentasContables.Where(c => c.TotDet == "D" && c.ActSusp == "A" && c.Cia == ciaContabSeleccionadaID).
                                                                  OrderBy(c => c.Cuenta).
                                                                  Select(c => new { cuenta = c.ID, descripcion = c.Cuenta + " - " + c.Descripcion });

            var tiposAsiento = contabContext.Asientos.Where(a => a.Cia == ciaContabSeleccionadaID).OrderBy(a => a.Tipo).Select(a => a.Tipo).Distinct();

            var result = new
            {
                ErrorFlag = false,
                ErrorMessage = "",
                ResultMessage = "Ok, los catálogos necesarios para efectuar el registro de los asientos contables, han sido cargados.",
                CuentasContables = cuentasContables.ToList(),
                TiposAsiento = tiposAsiento.ToList()
            };

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }


        [HttpPost]
        public HttpResponseMessage GrabarAsientosContables(int ciaContabSeleccionada, 
                                                           string numeroLote,
                                                           int ctaContCxCClientes_ID, 
                                                           int ctaContIngMemb_ID, 
                                                           int ctaContIngGrua_ID, 
                                                           int ctaContImpIva_ID, 
                                                           decimal factorCambio, 
                                                           string tipoAsiento)
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

            var facturasImportarDesdeExcel = mongoDataBase.GetCollection<Temp_FacturaImportarDesdeExcel>("Temp_FacturaImportarDesdeExcel");
            // ------------------------------------------------------------------------------------------------------------------------------
            

            BancosEntities bancosContext = new BancosEntities();
            //dbContab_Contab_Entities contabContext = new dbContab_Contab_Entities();

            string message = "";

            // debe venir una cia contab (seleccionada) correcta ... 

            var companiaContab = bancosContext.Companias.Where(c => c.Numero == ciaContabSeleccionada).FirstOrDefault();

            if (companiaContab == null)
            {
                message = "Error: no hemos podido leer la compañía (Contab) que corresponde a la compañía Contab seleccionada en esta función. Por favor revise.";

                var result0 = new
                {
                    ErrorFlag = true,
                    ErrorMessage = message,
                    ResultMessage = ""
                };

                return Request.CreateResponse(HttpStatusCode.OK, result0);
            }


            // ----------------------------------------------------------------------------
            // obtenemos el id de las cuentas contables indicadas por el usuario 

            int? cuentaContable_CxCClientes = bancosContext.CuentasContables.Where(c => c.ID == ctaContCxCClientes_ID && c.Cia == ciaContabSeleccionada)
                                                                            .Select(c => c.ID)
                                                                            .FirstOrDefault();

            int? cuentaContable_IngresosMembresia = bancosContext.CuentasContables.Where(c => c.ID == ctaContIngMemb_ID && c.Cia == ciaContabSeleccionada)
                                                                            .Select(c => c.ID)
                                                                            .FirstOrDefault();

            int? cuentaContable_IngresosGrua = bancosContext.CuentasContables.Where(c => c.ID == ctaContIngGrua_ID && c.Cia == ciaContabSeleccionada)
                                                                            .Select(c => c.ID)
                                                                            .FirstOrDefault();

            int? cuentaContable_ImpuestosIva = bancosContext.CuentasContables.Where(c => c.ID == ctaContImpIva_ID && c.Cia == ciaContabSeleccionada)
                                                                             .Select(c => c.ID)
                                                                             .FirstOrDefault();


            if ((cuentaContable_CxCClientes == null) ||
                (cuentaContable_IngresosMembresia == null) ||
                (cuentaContable_IngresosGrua == null) ||
                (cuentaContable_ImpuestosIva == null))
            {
                message = "Error: no hemos podido leer, para la cia Contab seleccionada, la cuenta contable para alguna de las cuentas contables indicadas.<br />" +
                    "Por favor intente de nuevo.";

                var result0 = new
                {
                    ErrorFlag = true,
                    ErrorMessage = message,
                    ResultMessage = ""
                };

                return Request.CreateResponse(HttpStatusCode.OK, result0);
            }

            int cantidadFacturasLeidas = 0;
            int cantidadAsientosContablesAgregados = 0;

            if (string.IsNullOrEmpty(numeroLote))
                numeroLote = "*****";

            // TODO: leer usando executeQueryStore ... 

            string sqlString = "Select * From Facturas Where Lote = {0} And Cia = {1}"; 
            var queryFacturas = bancosContext.ExecuteStoreQuery<Factura>(sqlString, new object [] { numeroLote, ciaContabSeleccionada }); 

            // funciones genéricas en Contab (ej: validar mes cerrado en Contab) 

            FuncionesContab2 funcionesContab = new FuncionesContab2();


            // para asegurarnos que el Ingreso y UltAct en todos los asientos será el mismo 
            // nótese como usamos un valor 'simple'; sin segundos ni milisegundos ... 

            DateTime fechaRegistro = Convert.ToDateTime(DateTime.Now.ToString("dd-MM-yyyy hh:mm"));         

            foreach (Factura factura in queryFacturas)
            {
                // leemos la factura en mongo, para obtener los montos membresía y arys en forma separada ... 

                var facturaDeOrigen = facturasImportarDesdeExcel.AsQueryable<Temp_FacturaImportarDesdeExcel>().
                                                                 Where(f => f.Usuario == User.Identity.Name).
                                                                 Where(f => f.NumeroLoteEnBancos == numeroLote).
                                                                 Where(f => f.NumeroFacturaEnBancos == factura.NumeroFactura).
                                                                 Where(f => f.NumeroControlEnBancos == factura.NumeroControl).
                                                                 FirstOrDefault();

                if (facturaDeOrigen == null)
                {
                    message = "Error: no pudimos leer el registro de origen (Excel) para la factura número: " + factura.NumeroFactura + ",<br />" +
                        "cuya descripción (o concepto) es: " + factura.Concepto + ",<br />" +
                        "El registro de originen debe existir, para poder descomponer el monto de la factura en sus montos originales (membresía y grua)";

                    var result0 = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = message,
                        ResultMessage = ""
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, result0);
                }


                // ya tenemos la factura y su registro de origen; ahora, intentamos agregar el asiento ... 
                Int16 mesFiscal;
                Int16 anoFiscal;

                if (!funcionesContab.ValidarMesCerradoEnContab(factura.FechaEmision, ciaContabSeleccionada, out mesFiscal, out anoFiscal, out message))
                {
                    var result0 = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = message,
                        ResultMessage = ""
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, result0);
                }

                // ------------------------------------------------------------------------------------------------------------------------------
                // intentamos leer una definción del impuestos Iva para la factura; el iva, cuando existe, es una partida en el asiento contable 

                //decimal montoImpuestoIvaFactura = 0; 

                //Facturas_Impuestos impuestoIva = bancosContext.Facturas_Impuestos.
                //    Where(i => i.FacturaID == factura.ClaveUnica && i.ImpuestosRetencionesDefinicion.Predefinido == 1).
                //    FirstOrDefault();

                //if (impuestoIva != null)
                //    montoImpuestoIvaFactura = impuestoIva.Monto; 

                ContabSysNet_Web.ModelosDatos_EF.Bancos.Asiento asientoContable = null;

                if (!AgregarAsientoContableParaFactura(factura,
                                                       companiaContab, 
                                                       //facturaDeOrigen,
                                                       mesFiscal,
                                                       anoFiscal,
                                                       cuentaContable_CxCClientes.Value,
                                                       cuentaContable_IngresosMembresia.Value,
                                                       cuentaContable_IngresosGrua.Value,
                                                       cuentaContable_ImpuestosIva.Value,
                                                       tipoAsiento,
                                                       numeroLote,

                                                       facturaDeOrigen.Membresia, 
                                                       facturaDeOrigen.MembresiaBase, 
                                                       facturaDeOrigen.MembresiaIva, 

                                                       facturaDeOrigen.ArysVial, 
                                                       facturaDeOrigen.ArysVialBase, 
                                                       facturaDeOrigen.ArysVialIva, 
                                                       
                                                       factorCambio,
                                                       fechaRegistro,
                                                       User.Identity.Name,
                                                       out asientoContable,
                                                       out message))
                {
                    var result0 = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = message,
                        ResultMessage = ""
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, result0);
                }

                bancosContext.Asientos.AddObject(asientoContable);

                cantidadAsientosContablesAgregados++;
                cantidadFacturasLeidas++;
            }

            if (cantidadFacturasLeidas == 0)
            {
                message = "Error: no hemos podido leer facturas registradas para el número de lote: '" + numeroLote + 
                          "' y la cia Contab seleccionada.<br />" +
                          "Es probable que Ud. no haya cargado las facturas desde el documento Excel a la base de datos, " +
                          "antes de ejecutar este proceso.<br />" +
                          "Por favor revise.";

                var result0 = new
                {
                    ErrorFlag = true,
                    ErrorMessage = message,
                    ResultMessage = ""
                };

                return Request.CreateResponse(HttpStatusCode.OK, result0);
            }

            try
            {
                bancosContext.SaveChanges();

                // nótese como usamos la 'fechaRegistro' para leer las facturas recién agregadas y actualizar su número de lote ... 
                // el número de lote es muy importante, pues permitirá identificar las facturas agregadas en forma 'masiva' en forma fácil 

                string sqlTransactCommand = "Update Asientos Set Lote = {0} Where Usuario = {1} And Ingreso = {2} And UltAct = {2} And Cia = {3}";

                int cantAsientosContablesActualizados =
                bancosContext.ExecuteStoreCommand(sqlTransactCommand, new object[] { 
                                                                                        numeroLote, 
                                                                                        User.Identity.Name, 
                                                                                        fechaRegistro, 
                                                                                        ciaContabSeleccionada 
                                                                                    }); 


                message = "Ok, los asientos contables se han construído y cargado a la base de datos en forma satisfactoria.<br />" +
                          "La cantidad de facturas leídas para el número de lote indicado es: " + cantidadFacturasLeidas.ToString() + "<br />" +
                          "La cantidad de asientos contables agregados a la base de datos es: " + cantidadAsientosContablesAgregados.ToString() + "<br />" +
                          "La cantidad de asientos contables asociados al número de lote es: " + cantAsientosContablesActualizados.ToString() + "<br />" + 
                          "El número de lote asignado a los asientos, es el mismo que el asignado originalmente a las facturas; es decir: '" +
                          numeroLote + "'";

                var result2 = new
                {
                    ErrorFlag = false,
                    ErrorMessage = "",
                    ResultMessage = message
                };

                return Request.CreateResponse(HttpStatusCode.OK, result2);
            }
            catch (Exception ex)
            {
                message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                var result0 = new
                {
                    ErrorFlag = true,
                    ErrorMessage = message,
                    ResultMessage = ""
                };

                return Request.CreateResponse(HttpStatusCode.OK, result0);
            }
        }


        private bool AgregarAsientoContableParaFactura( Factura factura,
                                                        ContabSysNet_Web.ModelosDatos_EF.Bancos.Compania companiaContab, 
                                                        //Temp_FacturaImportarDesdeExcel facturaDeOrigen,         // viene de mongo 
                                                        short mesFiscal,
                                                        short anoFiscal,
                                                        int cuentaContable_CxCClientes,
                                                        int cuentaContable_IngresosMembresia,
                                                        int CuentaContable_IngresosGrua,
                                                        int cuentaContable_ImpuestosIva,
                                                        string tipoAsiento,
                                                        string numeroLote,

                                                        decimal membresia,
                                                        decimal membresiaBase,
                                                        decimal membresiaIva,

                                                        decimal arysVial,
                                                        decimal arysVialBase,
                                                        decimal arysVialIva, 

                                                        decimal factorCambio,
                                                        DateTime fechaRegistro,
                                                        string nombreUsuario,
                                                        out ContabSysNet_Web.ModelosDatos_EF.Bancos.Asiento asientoContable,
                                                        out string errorMessage)
        {
            errorMessage = "";
            decimal diferenciaAsiento = 0;

            asientoContable = new ContabSysNet_Web.ModelosDatos_EF.Bancos.Asiento();

            // nótese como solo inicializamos propiedades que no lo hacen en entity_created y entity_inserting 

            // si alguna propiedad es inicializada en Created y luego aquí, este último valor prevalece 
            // (ej: CiaContab y Moneda) 

            if (factura.CxCCxPFlag == 1)        // proveedores 
                asientoContable.Fecha = factura.FechaRecepcion;
            else
                asientoContable.Fecha = factura.FechaEmision;

            asientoContable.MesFiscal = mesFiscal;
            asientoContable.AnoFiscal = anoFiscal;

            asientoContable.Mes = (byte)asientoContable.Fecha.Month;
            asientoContable.Ano = (short)asientoContable.Fecha.Year;
            asientoContable.AsientoTipoCierreAnualFlag = false;
            asientoContable.CopiableFlag = false;

            asientoContable.Tipo = tipoAsiento;

            asientoContable.Moneda = factura.Moneda;
            asientoContable.MonedaOriginal = factura.Moneda;

            asientoContable.Descripcion = factura.Concepto.Length > 250 ?
                                            factura.Concepto.Substring(0, 250) :
                                            factura.Concepto;

            asientoContable.ConvertirFlag = true;
            asientoContable.ProvieneDe = "Facturas";
            asientoContable.ProvieneDe_ID = factura.ClaveUnica;

            asientoContable.Compania = companiaContab;

            // ----------------------------------------------------------
            // ahora agregamos las partidas del asiento ... 

            ContabSysNet_Web.ModelosDatos_EF.Bancos.dAsiento partida;

            short numeroPartida = 0;

            numeroPartida = Convert.ToInt16(numeroPartida + 10);

            partida = new ContabSysNet_Web.ModelosDatos_EF.Bancos.dAsiento()
            {
                Partida = numeroPartida,
                CuentaContableID = cuentaContable_CxCClientes,
                Descripcion = factura.Concepto.Length > 75 ? factura.Concepto.Substring(0, 75) : factura.Concepto,
                Referencia = factura.NumeroFactura,
                Debe = Math.Round( (membresia + arysVial) , 2),
                Haber = 0
            };

            asientoContable.dAsientos.Add(partida);
            diferenciaAsiento += partida.Debe;


            // 2) ingreso por membresía 
            if (membresiaBase != 0)
            {
                numeroPartida = Convert.ToInt16(numeroPartida + 10);

                partida = new ContabSysNet_Web.ModelosDatos_EF.Bancos.dAsiento()
                {
                    Partida = numeroPartida,
                    CuentaContableID = cuentaContable_IngresosMembresia,
                    Descripcion = factura.Concepto.Length > 75 ? factura.Concepto.Substring(0, 75) : factura.Concepto,
                    Referencia = factura.NumeroFactura,
                    Debe = 0,
                    Haber = Math.Round(membresiaBase, 2)
                };

                asientoContable.dAsientos.Add(partida);
                diferenciaAsiento -= partida.Haber;
            }

            // 3) ingresos por grúa 
            if (arysVialBase != 0)
            {
                numeroPartida = Convert.ToInt16(numeroPartida + 10);

                partida = new ContabSysNet_Web.ModelosDatos_EF.Bancos.dAsiento()
                {
                    Partida = numeroPartida,
                    CuentaContableID = CuentaContable_IngresosGrua,
                    Descripcion = factura.Concepto.Length > 75 ? factura.Concepto.Substring(0, 75) : factura.Concepto,
                    Referencia = factura.NumeroFactura,
                    Debe = 0,
                    Haber = Math.Round(arysVialBase, 2)
                };

                asientoContable.dAsientos.Add(partida);
                diferenciaAsiento -= partida.Haber;
            }

            // 3) impuestos Iva 

            if (membresiaIva != 0 || arysVialIva != 0)
            {
                numeroPartida = Convert.ToInt16(numeroPartida + 10);

                partida = new ContabSysNet_Web.ModelosDatos_EF.Bancos.dAsiento()
                {
                    Partida = numeroPartida,
                    CuentaContableID = cuentaContable_ImpuestosIva,
                    Descripcion = factura.Concepto.Length > 75 ? factura.Concepto.Substring(0, 75) : factura.Concepto,
                    Referencia = factura.NumeroFactura,
                    Debe = 0,
                    Haber = Math.Round( (membresiaIva + arysVialIva) , 2)
                };

                asientoContable.dAsientos.Add(partida);
                diferenciaAsiento -= partida.Haber;
            }

            // -----------------------------------------------------------------------------------------------------------------------------------
            // si acaso hay una diferencia muy pequeña en las partidas del asiento, ajustamos contra el monto de la partida CxC (1ra. partida) 
            // nótese como solo ajustamos si la diferencia es pequeña; si es grande, dejamos así pues debe haber algún error en algún lado ... 

            if (diferenciaAsiento != 0 && Math.Abs(diferenciaAsiento) < 1)
            {
                ContabSysNet_Web.ModelosDatos_EF.Bancos.dAsiento partidaCxC = asientoContable.dAsientos.Where(d => d.Partida == 10).First();

                if (diferenciaAsiento > 0)
                    partidaCxC.Debe -= diferenciaAsiento;
                else
                    partidaCxC.Debe += Math.Abs(diferenciaAsiento);
            }


            // -----------------------------------------------------------------------------------------------------------------------------------
            // finalmente, obtenemos un número para el asiento contable ... nótese como usamos una función definida antes ... 

            short numeroAsientoContable;

            FuncionesContab2 funcionesContab = new FuncionesContab2();

            if (!funcionesContab.ObtenerNumeroAsientoContab(asientoContable.Fecha, factura.Cia, asientoContable.Tipo, out numeroAsientoContable, out errorMessage))
                return false;

            funcionesContab = null;

            asientoContable.Numero = numeroAsientoContable;

            asientoContable.FactorDeCambio = factorCambio;
            asientoContable.Cia = factura.Cia;
            asientoContable.Ingreso = fechaRegistro;
            asientoContable.UltAct = fechaRegistro;
            asientoContable.Usuario = nombreUsuario;

            return true;
        }
    }
}