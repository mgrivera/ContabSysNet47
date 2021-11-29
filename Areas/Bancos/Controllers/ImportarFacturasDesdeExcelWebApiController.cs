
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using Newtonsoft.Json;
using MongoDB.Driver;
using ContabSysNet_Web.Areas.Bancos.Models.mongodb;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;

using MongoDB.Driver.Linq;
using ContabSysNet_Web.Clases;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using System.Globalization;
using ContabSysNet_Web.Areas.Bancos.Models.ImportarFacturasSimpleDesdeExcel;

namespace ContabSysNet_Web.Areas.Bancos.Controllers
{
    public class ImportarFacturasDesdeExcelWebApiController : ApiController
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
        public HttpResponseMessage GrabarExcelDataAMongoDB([FromUri]int ciaContabSeleccionada, [FromBody]string value)
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

            List<FacturaSimpleExcelRow> filtroJson;

            // --------------------------------------------------------------------------------------------------------------------------
            // establecemos una conexión a mongodb 
            string contabm_mongodb_connection = System.Web.Configuration.WebConfigurationManager.AppSettings["contabm_mongodb_connectionString"];
            string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

            var client = new MongoClient(contabm_mongodb_connection);
            // var server = client.GetServer();
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            var mongoDataBase = client.GetDatabase(contabM_mongodb_name);

            var facturaSimpleImportarDesdeExcel = mongoDataBase.GetCollection<Temp_FacturaSimpleImportarDesdeExcel>("Temp_FacturaSimpleImportarDesdeExcel");

            try
            {
                filtroJson = JsonConvert.DeserializeObject<List<FacturaSimpleExcelRow>>(value);

                // --------------------------------------------------------------------------------------------------------------------------
                // primero que todo, eliminamos (en mongo) los registros que puedan existir para el usuario 
                var builder = Builders<Temp_FacturaSimpleImportarDesdeExcel>.Filter;
                var filter = builder.Eq(x => x.Usuario, User.Identity.Name);

                facturaSimpleImportarDesdeExcel.DeleteManyAsync(filter);
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

            Temp_FacturaSimpleImportarDesdeExcel facturaSimpleFromExcelMongoDocument;

            foreach (FacturaSimpleExcelRow excelRow in filtroJson)
            {
                facturaSimpleFromExcelMongoDocument = new Temp_FacturaSimpleImportarDesdeExcel();

                int codigo;
                decimal monto;
                string errorMessage = "";

                if (string.IsNullOrEmpty(excelRow.NumeroCliente) || string.IsNullOrEmpty(excelRow.MontoFactura) || string.IsNullOrEmpty(excelRow.ConceptoFactura))
                    errorMessage = "Hemos encontrado que, al menos para uno de los registros en el documento Excel, " + 
                        "el valor indicado como monto, descripción o número de cliente " +
                        "es un valor vacío. Por favor indique valores correctos para estos campos.";
                else
                {
                    if (!int.TryParse(excelRow.NumeroCliente, out codigo))
                        // el código no es un integer ... 
                        errorMessage = "El valor '" + excelRow.NumeroCliente + 
                            "', indicado como código de cliente no es valido; debe ser un valor entero. ";

                    // el valos viene formateado en forma usa (ej: 1,350.75); quitamos la coma para que el valor pueda ser convertido a decimal ... 

                    if (!decimal.TryParse(excelRow.MontoFactura.Replace(",", ""), out monto))
                        // el monto no es un decimal ... 
                        errorMessage = "El valor '" + excelRow.MontoFactura + 
                            "', indicado como el monto de una factura no es valido; debe ser un valor decimal (ej: 10.550,75). "; 
                }


                if (!string.IsNullOrEmpty(errorMessage))
                {
                    string message = errorMessage;
                    
                    var errorResult = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + message
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }


                try
                {
                    facturaSimpleFromExcelMongoDocument.Codigo = Convert.ToInt32(excelRow.NumeroCliente);
                    facturaSimpleFromExcelMongoDocument.Nombre = excelRow.NombreCliente;

                    // el monto viene formateado desde la hoja Excel en formato Usa; por ejemplo: 1,500.75; indicamos InvariantCulture aquí, para que 
                    // el '.' sea asumido como punto decimal, como en Usa ... 

                    facturaSimpleFromExcelMongoDocument.Monto = Convert.ToDecimal(excelRow.MontoFactura.Replace(",", ""), CultureInfo.InvariantCulture);
                    facturaSimpleFromExcelMongoDocument.Descripcion = excelRow.ConceptoFactura;

                    facturaSimpleFromExcelMongoDocument.Usuario = User.Identity.Name;

                    facturaSimpleImportarDesdeExcel.InsertOneAsync(facturaSimpleFromExcelMongoDocument);
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

            dbContab_Contab_Entities contabContext = new dbContab_Contab_Entities();

            var tiposAsiento = contabContext.Asientos.Where(a => a.Cia == ciaContabSeleccionada).Select(a => a.Tipo).Distinct().ToList(); 


            var result = new
            {
                ErrorFlag = false,
                ErrorMessage = "",
                ResultMessage = "Ok, los registros importados desde el documento Excel han sido grabados al servidor;<br />" +
                    "en total, hemos registrado al servidor " + filtroJson.Count().ToString() + " registros.<br />" +
                    "Ahora Ud. puede continuar con el siguiente paso de este proceso.", 
                tiposAsiento
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


            BancosEntities bancosContext = new BancosEntities();

            // ------------------------------------------------------------------------------------------------------------------
            // TODO: debe venir una Cia contab seleccionada (???); creo que tenemos que comenzar con ésto en el cliente ... 
            // ------------------------------------------------------------------------------------------------------------------

            string errorMessage = "";

            ContabSysNet_Web.ModelosDatos_EF.Bancos.Compania ciaContabSeleccionada = bancosContext.Companias.Where(c => c.Numero == ciaContabSeleccionadaID).
                                                                                                             FirstOrDefault();

            if (ciaContabSeleccionada == null)
                errorMessage = "Error: no hemos podido leer la compañía (Contab) que corresponde a la compañía Contab seleccionada en esta función. Por favor revise.";

            // para agregar el monto de impuestos Iva necesitamos una definición para este rubro (en la tabla ImpuestosRetencionesDefinicion); 
            // en esta tabla se predefinen configuraciones para impuestos y retenciones usados en las facturas ... 

            ImpuestosRetencionesDefinicion definicionImpuestosIva = bancosContext.ImpuestosRetencionesDefinicions.Where(i => i.Predefinido == 1).FirstOrDefault();

            if (definicionImpuestosIva == null)
            {
                errorMessage = "Error: no hemos podido leer un registro de definición para el impuesto Iva. <br />" +
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

            FuncionesBancos funcionesBancos = new FuncionesBancos(bancosContext);

            if (!funcionesBancos.DeterminarProxNumeroFacturaClientes(ciaContabSeleccionadaID, out numeroFactura, out numeroControl, out errorMessage))
                errorMessage = "Error: ha ocurrido un error al intentar determinar el próximo número de factura y/o control. " +
                    "El mensaje específico del error es: <br />" + errorMessage;

            DateTime fechaEmision; 

            if (!DateTime.TryParse(fechaEmisionFactura, out fechaEmision))
                errorMessage = "Error: aparentemente, la fecha pasada a esta función no corresonde a un valor válido: '" + fechaEmisionFactura + "'. Por favor revise."; 


            if (!string.IsNullOrEmpty(errorMessage))
            {
                var errorResult = new
                {
                    ErrorFlag = true,
                    ErrorMessage = errorMessage
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            // ------------------------------------------------------------------------------------------------------------------------------------

            Factura facturaNueva;

            int cantidadFacturasLeidas = 0;
            int cantidadFacturasAgregadas = 0;

            // para asegurarnos que el ingreso en todas las facturas será el mismo 
            // nótese como usamos un valor 'simple'; sin segundos ni milisegundos ... 

            DateTime fechaRegistro = Convert.ToDateTime(DateTime.Now.ToString("dd-MM-yyyy hh:mm tt"));          
            string lote = fechaRegistro.ToString("dd-MM-yyyy hh:mm tt").Trim() + " " + User.Identity.Name;

            // leemos las facturas (Excel rows) que se han cargado a mongo para el usuario ... 

            // --------------------------------------------------------------------------------------------------------------------------
            // establecemos una conexión a mongodb 
            string contabm_mongodb_connection = System.Web.Configuration.WebConfigurationManager.AppSettings["contabm_mongodb_connectionString"];
            string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

            var client = new MongoClient(contabm_mongodb_connection);
            // var server = client.GetServer();
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            var mongoDataBase = client.GetDatabase(contabM_mongodb_name);

            var facturasImportarDesdeExcel = mongoDataBase.GetCollection<Temp_FacturaSimpleImportarDesdeExcel>("Temp_FacturaSimpleImportarDesdeExcel");

            var query = facturasImportarDesdeExcel.AsQueryable<Temp_FacturaSimpleImportarDesdeExcel>().Where(f => f.Usuario == User.Identity.Name);
            
            foreach (var factura in query)
            {
                cantidadFacturasLeidas++;

                // revisamos que la compañía haya sido cargada antes ... 

                var compania = bancosContext.Proveedores.Where(c => c.Proveedor == factura.Codigo).FirstOrDefault();

                if (compania == null)
                {
                    message = "Error: la compañía cuyo código es '" + factura.Codigo + "' y de nombre " + factura.Nombre +
                        " no existe en la tabla de compañías.<br />" +
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
                    CxCCxPFlag = 2,     // cxc
                    NumeroFactura = numeroFactura.ToString(),
                    NumeroControl = numeroControl.ToString(),
                    CondicionesDePago = compania.FormaDePagoDefault.Value,
                    Moneda = compania.MonedaDefault.Value,
                    Tipo = compania.Tipo,
                    Concepto = factura.Descripcion,
                    Estado = 1,                         // pendiente 
                    Ingreso = fechaRegistro,
                    UltAct = fechaRegistro,
                    Usuario = User.Identity.Name, 
                    Lote = lote
                };

                facturaNueva.MontoFacturaSinIva = 0;
                facturaNueva.IvaPorc = porcentajeImpuestosIva * 100;
                facturaNueva.MontoFacturaConIva = Math.Round(factura.Monto, 2);

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

                // -----------------------------------------------------------------------------------------------------------------------------
                // para cada factura que intentamos registrar, debemos revisar que exista una cuenta contable de compras (CxC); de otra manera, 
                // este error podría surgir luego que las facturas fueron agregadas y cuando el usuario intente registrar sus asientos contables 

                facturaNueva.Proveedore = bancosContext.Proveedores.Where(p => p.Proveedor == facturaNueva.Proveedor).FirstOrDefault();
                facturaNueva.TiposProveedor = bancosContext.TiposProveedors.Where(p => p.Tipo == facturaNueva.Tipo).FirstOrDefault();
                facturaNueva.Moneda1 = bancosContext.Monedas.Where(p => p.Moneda1 == facturaNueva.Moneda).FirstOrDefault();
                facturaNueva.Compania = bancosContext.Companias.Where(p => p.Numero == facturaNueva.Cia).FirstOrDefault();

                message = "";
                if (!ValidarCuentasContablesAsientoFactura(bancosContext, facturaNueva, factura.Nombre, out message))
                {
                    var errorResult = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = message
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }
                // ---------------------------------------------------------------------------------------------------------------------------------


                bancosContext.Facturas.AddObject(facturaNueva);

                cantidadFacturasAgregadas++;

                numeroControl++;
                numeroFactura++;

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

                message = "Ok, las facturas se han cargado a la base de datos en forma satisfactoria.<br />" +
                          "La cantidad de facturas leídas desde la hoja Excel es: " + cantidadFacturasLeidas.ToString() + "<br />" +
                          "La cantidad de facturas agregadas a la base de datos es: " + cantidadFacturasAgregadas.ToString() + "<br />" +
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

        [HttpPost]
        public HttpResponseMessage GrabarAsientosContables(string numeroLote,
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

            BancosEntities bancosContext = new BancosEntities();
            //dbContab_Contab_Entities contabContext = new dbContab_Contab_Entities();

            string message = "";

            int cantidadFacturasLeidas = 0;
            int cantidadAsientosContablesAgregados = 0;

            if (string.IsNullOrEmpty(numeroLote))
                numeroLote = "*****";

            // leemos las facturas que corresponden al lote 
            var queryFacturas = bancosContext.Facturas.Include("Proveedore").
                                                       Include("TiposProveedor").
                                                       Include("Moneda1").
                                                       Include("Compania").
                                                       Where(f => f.Lote == numeroLote);

            // funciones genéricas en Contab (ej: validar mes cerrado en Contab) 
            dbContab_Contab_Entities contabContext = new dbContab_Contab_Entities();
            FuncionesContab2 funcionesContab = new FuncionesContab2(contabContext);


            // para asegurarnos que el Ingreso y UltAct en todos los asientos será el mismo 
            // nótese como usamos un valor 'simple'; sin segundos ni milisegundos ... 

            DateTime fechaRegistro = Convert.ToDateTime(DateTime.Now.ToString("dd-MM-yyyy hh:mm"));         

            foreach (Factura factura in queryFacturas)
            {
                Int16 mesFiscal;
                Int16 anoFiscal;

                if (!funcionesContab.ValidarMesCerradoEnContab(factura.FechaEmision, factura.Cia, out mesFiscal, out anoFiscal, out message))
                {
                    var result0 = new
                    {
                        ErrorFlag = true,
                        ErrorMessage = message,
                        ResultMessage = ""
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, result0);
                }

                ContabSysNet_Web.ModelosDatos_EF.Bancos.Asiento asientoContable = null;

                if (!AgregarAsientoContableParaFactura(bancosContext, 
                                                       factura, 
                                                       mesFiscal,
                                                       anoFiscal,
                                                       tipoAsiento,
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

                message = "Ok, los asientos contables se han construído y cargado a la base de datos en forma satisfactoria.<br />" +
                          "La cantidad de facturas leídas para el número de lote indicado es: " + cantidadFacturasLeidas.ToString() + "<br />" +
                          "La cantidad de asientos contables agregados a la base de datos es: " + cantidadAsientosContablesAgregados.ToString() + "<br />" +
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

        private bool AgregarAsientoContableParaFactura(BancosEntities bancosContext, 
                                                        Factura factura,
                                                        short mesFiscal,
                                                        short anoFiscal,
                                                        string tipoAsiento,
                                                        decimal factorCambio,
                                                        DateTime fechaRegistro,
                                                        string nombreUsuario,
                                                        out ContabSysNet_Web.ModelosDatos_EF.Bancos.Asiento asientoContable,
                                                        out string errorMessage)
        {
            errorMessage = "";
            decimal diferenciaAsiento = 0;

            asientoContable = new ContabSysNet_Web.ModelosDatos_EF.Bancos.Asiento();

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

            asientoContable.Compania = factura.Compania;

            decimal montoNoImponible = factura.MontoFacturaSinIva != null ? factura.MontoFacturaSinIva.Value : 0;
            decimal montoImponible = factura.MontoFacturaConIva != null ? factura.MontoFacturaConIva.Value : 0;
            decimal montoIva = factura.Iva != null ? factura.Iva.Value : 0; 

            // ----------------------------------------------------------
            // ahora agregamos las partidas del asiento ... 


            // --------------------------------------------------------------------------------
            // cuenta por cobrar al cliente (o por pagar al proveedor ...) 

            ContabSysNet_Web.ModelosDatos_EF.Bancos.dAsiento partida;

            short numeroPartida = 0;

            numeroPartida = Convert.ToInt16(numeroPartida + 10);

            int cuentaContableDefinidaID = 0;
            int conceptoDefinicionCuentaContable = 0;

            if (factura.CxCCxPFlag == 1)
                conceptoDefinicionCuentaContable = 1;
            else
                conceptoDefinicionCuentaContable = 7;

            cuentaContableDefinidaID = LeerCuentaContableDefinida(
                        bancosContext,
                        conceptoDefinicionCuentaContable,
                        factura.Proveedore.Proveedor,
                        factura.TiposProveedor.Tipo,
                        factura.Moneda1.Moneda1,
                        factura.Compania.Numero,
                        null);

            if (cuentaContableDefinidaID == 0)
            {
                if (factura.CxCCxPFlag == 1)
                    errorMessage = "Error: no se ha encontrado una cuenta contable definida para la compañía (Compañía (CxP)) " +
                        factura.Proveedore.Nombre + " (" + factura.Proveedor.ToString() + ")";
                else
                    errorMessage = "Error: no se ha encontrado una cuenta contable definida para la compañía (Compañía (CxC)) " +
                        factura.Proveedore.Nombre + " (" + factura.Proveedor.ToString() + ")";


                return false;
            }

            partida = new ContabSysNet_Web.ModelosDatos_EF.Bancos.dAsiento()
            {
                Partida = numeroPartida,
                CuentaContableID = cuentaContableDefinidaID,
                Descripcion = factura.Concepto.Length > 75 ? factura.Concepto.Substring(0, 75) : factura.Concepto,
                Referencia = factura.NumeroFactura,
                Debe = montoNoImponible + montoImponible + montoIva,
                Haber = 0
            };

            asientoContable.dAsientos.Add(partida);
            diferenciaAsiento += partida.Debe;

            // -------------------------------------------------------------------------------------
            // 2) ingresos

            cuentaContableDefinidaID = 0;
            conceptoDefinicionCuentaContable = 0;

            if (factura.CxCCxPFlag == 1)
                conceptoDefinicionCuentaContable = 2;
            else
                conceptoDefinicionCuentaContable = 8;


            cuentaContableDefinidaID = LeerCuentaContableDefinida(
                        bancosContext,
                        conceptoDefinicionCuentaContable,
                        factura.Proveedore.Proveedor,
                        factura.TiposProveedor.Tipo,
                        factura.Moneda1.Moneda1,
                        factura.Compania.Numero,
                        null);

            if (cuentaContableDefinidaID == 0)
            {
                if (factura.CxCCxPFlag == 1)
                    errorMessage = "Error: no se ha encontrado una cuenta contable definida para " +
                        "contabilizar las compras (Compras), " +
                        "para la compañía " + factura.Proveedore.Nombre + " (" + factura.Proveedor.ToString() + ")";
                else
                    errorMessage = "Error: no se ha encontrado una cuenta contable definida para " +
                        "contabilizar las ventas (Ventas), " +
                        "para la compañía " + factura.Proveedore.Nombre + " (" + factura.Proveedor.ToString() + ")";

                return false;
            }

            numeroPartida = Convert.ToInt16(numeroPartida + 10);

            partida = new ContabSysNet_Web.ModelosDatos_EF.Bancos.dAsiento()
            {
                Partida = numeroPartida,
                CuentaContableID = cuentaContableDefinidaID,
                Descripcion = factura.Concepto.Length > 75 ? factura.Concepto.Substring(0, 75) : factura.Concepto,
                Referencia = factura.NumeroFactura,
                Debe = 0,
                Haber = montoImponible + montoNoImponible
            };

            asientoContable.dAsientos.Add(partida);
            diferenciaAsiento -= partida.Haber;

            // --------------------------------------------------------------------------------------------
            // 3) impuestos Iva 

            if (montoIva != 0)
            {
                numeroPartida = Convert.ToInt16(numeroPartida + 10);

                cuentaContableDefinidaID = 0;
                conceptoDefinicionCuentaContable = 0;

                if (factura.CxCCxPFlag == 1)
                    conceptoDefinicionCuentaContable = 4;
                else
                    conceptoDefinicionCuentaContable = 9;

                cuentaContableDefinidaID = LeerCuentaContableDefinida(
                            bancosContext,
                            conceptoDefinicionCuentaContable,
                            factura.Proveedore.Proveedor,
                            factura.TiposProveedor.Tipo,
                            factura.Moneda1.Moneda1,
                            factura.Compania.Numero,
                            null);

                if (cuentaContableDefinidaID == 0)
                {
                    if (factura.CxCCxPFlag == 1)
                        errorMessage = "Error: no se ha encontrado una cuenta contable definida para contabilizar el Iva (Iva), " +
                            "para la compañía " + factura.Proveedore.Nombre + " (" + factura.Proveedor.ToString() + ")";
                    else
                        errorMessage = "no se ha encontrado una cuenta contable definida para contabilizar el Iva (Iva), " +
                            "para la compañía " + factura.Proveedore.Nombre + " (" + factura.Proveedor.ToString() + ")";


                    return false;
                }

                partida = new ContabSysNet_Web.ModelosDatos_EF.Bancos.dAsiento()
                {
                    Partida = numeroPartida,
                    CuentaContableID = cuentaContableDefinidaID,
                    Descripcion = factura.Concepto.Length > 75 ? factura.Concepto.Substring(0, 75) : factura.Concepto,
                    Referencia = factura.NumeroFactura,
                    Debe = 0,
                    Haber = montoIva
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

            dbContab_Contab_Entities contabContext = new dbContab_Contab_Entities();
            FuncionesContab2 funcionesContab = new FuncionesContab2(contabContext);

            if (!funcionesContab.ObtenerNumeroAsientoContab(asientoContable.Fecha, factura.Cia, asientoContable.Tipo, out numeroAsientoContable, out errorMessage))
                return false;

            funcionesContab = null;

            asientoContable.Numero = numeroAsientoContable;

            asientoContable.FactorDeCambio = factorCambio;
            asientoContable.Cia = factura.Cia;
            asientoContable.Ingreso = fechaRegistro;
            asientoContable.UltAct = fechaRegistro;
            asientoContable.Lote = factura.Lote; 
            asientoContable.Usuario = nombreUsuario;

            return true;
        }


        private bool ValidarCuentasContablesAsientoFactura(BancosEntities bancosContext, Factura factura, string nombreCompaniaDocExcel, out string errorMessage)
        {
            // para registrar un asiento contable para la factura, deben existir definiciones para las cuentas contables: 
            // cxc, ingresos e iva ... 
            // la idea es asegurarnos que estas cuentas existan, antes de intentar registrar los asientos contables 


            // validamos que exista la cuenta contable del tipo CxC 

            int cuentaContableDefinidaID = 0;
            int conceptoDefinicionCuentaContable = 0;

            if (factura.CxCCxPFlag == 1)
                conceptoDefinicionCuentaContable = 1;
            else
                conceptoDefinicionCuentaContable = 7;

            cuentaContableDefinidaID = LeerCuentaContableDefinida(
                        bancosContext,
                        conceptoDefinicionCuentaContable,
                        factura.Proveedore.Proveedor,
                        factura.TiposProveedor.Tipo,
                        factura.Moneda1.Moneda1,
                        factura.Compania.Numero,
                        null);

            if (cuentaContableDefinidaID == 0)
            {
                if (factura.CxCCxPFlag == 1)
                    errorMessage = "Error: no se ha encontrado una cuenta contable definida para la compañía (Compañía (CxP)) " +
                        nombreCompaniaDocExcel + " (" + factura.Proveedor.ToString() + ")";
                else
                    errorMessage = "Error: no se ha encontrado una cuenta contable definida para la compañía (Compañía (CxC)) " +
                        nombreCompaniaDocExcel + " (" + factura.Proveedor.ToString() + ")";


                return false;
            }


            // --------------------------------------------------------------------------------------
            // partida para registrar la compra o venta (gasto o ingresos por venta) 

            errorMessage = ""; 
            cuentaContableDefinidaID = 0;
            conceptoDefinicionCuentaContable = 0;

            if (factura.CxCCxPFlag == 1)
                conceptoDefinicionCuentaContable = 2;
            else
                conceptoDefinicionCuentaContable = 8;


            cuentaContableDefinidaID = LeerCuentaContableDefinida(
                        bancosContext,
                        conceptoDefinicionCuentaContable,
                        factura.Proveedore.Proveedor,
                        factura.TiposProveedor.Tipo,
                        factura.Moneda1.Moneda1,
                        factura.Compania.Numero,
                        null);

            if (cuentaContableDefinidaID == 0)
            {
                if (factura.CxCCxPFlag == 1)
                    errorMessage = "Error: no se ha encontrado una cuenta contable definida para " +
                        "contabilizar las compras (Compras), " +
                        "para la compañía " + nombreCompaniaDocExcel + " (" + factura.Proveedor.ToString() + ")";
                else
                    errorMessage = "Error: no se ha encontrado una cuenta contable definida para " +
                        "contabilizar las ventas (Ventas), " +
                        "para la compañía " + nombreCompaniaDocExcel + " (" + factura.Proveedor.ToString() + ")";

                return false;
            }

            // validamos que existan cuentas contables definidas para el registro de impuestos Iva 
            cuentaContableDefinidaID = 0;
            conceptoDefinicionCuentaContable = 0;

            if (factura.CxCCxPFlag == 1)
                conceptoDefinicionCuentaContable = 4;
            else
                conceptoDefinicionCuentaContable = 9;

            cuentaContableDefinidaID = LeerCuentaContableDefinida(
                        bancosContext,
                        conceptoDefinicionCuentaContable,
                        factura.Proveedore.Proveedor,
                        factura.TiposProveedor.Tipo,
                        factura.Moneda1.Moneda1,
                        factura.Compania.Numero,
                        null);

            if (cuentaContableDefinidaID == 0)
            {
                if (factura.CxCCxPFlag == 1)
                    errorMessage = "Error: no se ha encontrado una cuenta contable definida para contabilizar el Iva (Iva), " +
                        "para la compañía " + nombreCompaniaDocExcel + " (" + factura.Proveedor.ToString() + ")";
                else
                    errorMessage = "no se ha encontrado una cuenta contable definida para contabilizar el Iva (Iva), " +
                        "para la compañía " + nombreCompaniaDocExcel + " (" + factura.Proveedor.ToString() + ")";


                return false;
            }

            return true; 
        }

        private int LeerCuentaContableDefinida(BancosEntities bancosContext,
                                               int concepto,
                                               int compania,
                                               int rubro,
                                               int moneda,
                                               int ciaContab,
                                               int? concepto2)
        {
            // ahora la Cia Contab es requerida en DefinicionCuentasContables; es decir, esta columna nunca 
            // será null en rows en esta tabla ... 

            // agregamos una nueva forma de definir cuentas contables, cuyos conceptos *no son fijos*, como el Iva, ISLR, 
            // Compras, CxP, etc. Todos los conceptos anteriores son fijos; es decir, tienen un número (concepto) *predefinido* (1, 2, 3, 4, ...). 
            // La nueva definición, permite al usuario registrar los conceptos en una tabla. La primera de estas definiciones, corresponden a los 
            // Impuestos (o retenciones) varias (#13) y se defininen en la tabla ImpuestosRetencionesDefinicion. Para definir la cuenta para alguno de 
            // estos nuevos rubros, el usuario debe indicr el concepto (13: otros impuestos) y el concepto2 (ID del registro en la tabla) 

            DefinicionCuentasContable definicionCuentaContable =
                (from d in bancosContext.DefinicionCuentasContables
                 where d.Concepto == concepto && d.CuentasContable.Compania.Numero == ciaContab &&
                 ((concepto2 == null || concepto2 == d.Concepto2)) &&
                 ((d.Proveedore.Proveedor == compania || d.Proveedore == null)) &&
                 ((d.TiposProveedor.Tipo == rubro || d.TiposProveedor == null)) &&
                 ((d.Moneda1.Moneda1 == moneda || d.Moneda1 == null))
                 orderby d.Proveedore.Proveedor descending,
                         d.TiposProveedor.Tipo descending,
                         d.Moneda1.Moneda1 descending
                 select d).FirstOrDefault();

            if (definicionCuentaContable != null)
                return definicionCuentaContable.CuentasContable.ID;


            return 0;
        }
    }
}