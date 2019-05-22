using ClosedXML.Excel;
using ContabSysNet_Web.Areas.Bancos.Models.mongodb;
using ContabSysNet_Web.Areas.Bancos.Models.RelacionMontosAPagar;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;

namespace ContabSysNet_Web.Areas.Bancos.Controllers
{
    public class RelacionMontosAPagarWebApiController : ApiController
    {
        [HttpGet]
        [Route("api/RelacionMontosAPagarWebApi/LeerFacturasSeleccionadas")]
        public HttpResponseMessage LeerFacturasSeleccionadas()
        {
            if (!User.Identity.IsAuthenticated)
            {
                var errorResult = new
                {
                    errorFlag = true,
                    resultMessage = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            // leemos la compañía seleccionada por el usuario, para luego usarla en la selección de las facturas; recuérdese que el usuario 
            // puede seleccionar facturas de varias compañías (Contab) en la consulta de facturas ... 

            int ciaContabSeleccionada;

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
                            errorFlag = true,
                            resultMessage = "Error: aparentemente, no se ha seleccionado una <em>Cia Contab</em>.<br />" +
                                    "Por favor seleccione una <em>Cia Contab</em> y luego regrese y continúe con la ejecución de esta función."
                        };

                        return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                    }

                    ciaContabSeleccionada = cia.ciaContabSeleccionada;
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


            try
            {
                // --------------------------------------------------------------------------------------------------------------------------
                // establecemos una conexión a mongodb 
                string contabm_mongodb_connection = System.Web.Configuration.WebConfigurationManager.AppSettings["contabm_mongodb_connectionString"];
                string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

                var client = new MongoClient(contabm_mongodb_connection);
                // var server = client.GetServer();
                // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
                var mongoDataBase = client.GetDatabase(contabM_mongodb_name);
                // --------------------------------------------------------------------------------------------------------------------------

                var facturasMongoCollection = mongoDataBase.GetCollection<FacturaSeleccionada_Consultas>("Factura_Consultas");

                var queryFacturas = from e in facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>()
                                    where e.NombreUsuario == User.Identity.Name && e.CiaContab == ciaContabSeleccionada
                                    select e;

                var facturasSeleccionadas = queryFacturas.Select(f => new
                {
                    selected = false,
                    companiaID = f.Compania,
                    compania = f.AbreviaturaCompania,
                    fechaRecepcion = f.FechaRecepcion,
                    numeroFactura = f.NumeroFactura,
                    numeroControl = f.NumeroControl,
                    concepto = f.Concepto,
                    montoNoImponible = f.MontoFacturaSinIva,
                    montoImponible = f.MontoFacturaConIva,
                    Iva = f.Iva,
                    totalFactura = f.TotalFactura,
                    impuestoRetenido = f.ImpuestoRetenido,
                    retencionSobreIva = f.RetencionSobreIva,
                    totalAPagar = f.TotalAPagar,
                    montoPagado = f.MontoPagado,
                    montoAPagar = f.TotalAPagar -
                                 (f.MontoPagado != null ? f.MontoPagado.Value : 0)
                }).ToList();

                var result = new
                {
                    errorFlag = false,
                    resultMessage = "",
                    facturasSeleccionadas = facturasSeleccionadas
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


        [HttpGet]
        [Route("api/RelacionMontosAPagarWebApi/LeerCiaContabSeleccionada")]
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
                            errorFlag = true,
                            resultMessage = "Error: aparentemente, no se ha seleccionado una <em>Cia Contab</em>.<br />" +
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
                        errorFlag = true,
                        resultMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                       "El mensaje específico de error es: <br />" + message
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }
            }

          
            var result = new
            {
                errorFlag = false,
                resultMessage = "",
                ciaContabSeleccionada = ciaContabSeleccionada,
                ciaContabSeleccionadaNombre = nombreCiaContabSeleccionada
            };

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }



        [HttpPost]
        [Route("api/RelacionMontosAPagarWebApi/leerDatosCompanias")]
        public HttpResponseMessage leerDatosCompanias([FromUri] int? cuentaBancariaID, [FromBody]List<ResumenFacturas> resumenFacturas)
        {
            if (!User.Identity.IsAuthenticated)
            {
                var errorResult = new
                {
                    errorFlag = true,
                    resultMessage = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            try
            {
                // --------------------------------------------------------------------------------------------------------------------------
                // establecemos una conexión a mongodb 
                string contabm_mongodb_connection = System.Web.Configuration.WebConfigurationManager.AppSettings["contabm_mongodb_connectionString"];
                string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

                var client = new MongoClient(contabm_mongodb_connection);
                // var server = client.GetServer();
                // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
                var mongoDataBase = client.GetDatabase(contabM_mongodb_name);

                // vamos a leer todas las compañías y ponerlas en una lista ... la cuenta bancaria (default) para cada compañía, será buscada allí ... 

                var companiasMongoCollection = mongoDataBase.GetCollection<Compania_mongodb>("Compania");

                var mongoQuery = from e in companiasMongoCollection.AsQueryable<Compania_mongodb>()
                                 select e; 

                List < Compania_mongodb > companias = mongoQuery.ToList();

                // --------------------------------------------------------------------------------------------------------------------------

                BancosEntities context = new BancosEntities();

                // antes que nada, leemos la cuenta bancaria y los datos de la cia contab ... 

                ContabSysNet_Web.ModelosDatos_EF.Bancos.Compania ciaContab = null;
                CuentasBancaria cuentaBancariaCiaContab = null;
                string codigoBancoCiaContab = "";

                if (cuentaBancariaID != null)
                {
                    cuentaBancariaCiaContab = context.CuentasBancarias.Where(cta => cta.CuentaInterna == cuentaBancariaID).FirstOrDefault();
                    if (cuentaBancariaCiaContab != null)
                    {
                        ciaContab = context.Companias.Where(cia => cia.Numero == cuentaBancariaCiaContab.Cia).FirstOrDefault();
                        codigoBancoCiaContab = cuentaBancariaCiaContab.Agencia1.Banco1.Codigo;
                    }

                }

                foreach (var c in resumenFacturas)
                {
                    Proveedore compania = context.Proveedores.Include("Personas").Where(p => p.Proveedor == c.companiaID).FirstOrDefault();

                    if (compania != null)
                    {
                        c.tipoPersona = compania.Rif != null ? compania.Rif.Substring(0, 1) : "";
                        c.numeroRif = compania.Rif != null ? compania.Rif.Substring(1, compania.Rif.Length - 1) : "";

                        Persona persona = compania.Personas.Where(p => p.DefaultFlag.HasValue && p.DefaultFlag.Value).FirstOrDefault();

                        if (persona != null)
                        {
                            c.nombreBeneficiario = persona.Nombre + ' ' + persona.Apellido;
                            c.email = persona.email;
                            c.celular = persona.Celular;

                            // solo si la persona posee un Rif registrado, lo usamos 
                            if (!string.IsNullOrEmpty(persona.Rif))
                            {
                                c.tipoPersona = persona.Rif != null ? persona.Rif.Substring(0, 1) : "";
                                c.numeroRif = persona.Rif != null ? persona.Rif.Substring(1, persona.Rif.Length - 1) : "";
                            }
                        }

                        // buscamos la compañía en la lista que leímos desde mongo 

                        var compania2 = companias.Where(x => x.Id == c.companiaID).FirstOrDefault();

                        if (compania2 != null && compania2.cuentasBancarias.Any(x => x.isDefault))
                        {
                            var cuentaBancaria = compania2.cuentasBancarias.Where(x => x.isDefault).FirstOrDefault();
                            var banco = context.Bancos.Where(b => b.Banco1 == cuentaBancaria.banco).FirstOrDefault();

                            c.numeroCuentaBancaria = cuentaBancaria.numero;
                            c.codigoBanco = banco != null ? banco.Codigo : null;

                            c.modalidadPago = "";

                            if (!(cuentaBancaria.tipo == "VI" || cuentaBancaria.tipo == "MA" || cuentaBancaria.tipo == "AM"))
                            {
                                // la cuenta no es una tarjeta; es una cuenta de ahorros o corriente 
                                if (c.codigoBanco == codigoBancoCiaContab)
                                    // cuentas del mismo banco (que nuestro banco) 
                                    c.modalidadPago = "CTA";
                                else
                                    // cuenta de difenrente banco (a nuestro banco) 
                                    c.modalidadPago = "BAN";
                            }
                            else
                            {
                                // tarjetas de crédito 
                                if (cuentaBancaria.tipo == "AM")
                                    c.modalidadPago = "AME";
                                else if (c.codigoBanco == codigoBancoCiaContab)
                                    // visa/master mismo banco 
                                    c.modalidadPago = "V/M";
                                else
                                    // visa/master otros bancos 
                                    c.modalidadPago = "TAR"; 
                            } 
                        }
                    }
                }

                var registroCiaContab = new
                {
                    tipoRegistro = "01",
                    descripcionLote = "Proveedores",
                    tipoPersona = ciaContab.Rif != null ? ciaContab.Rif.Substring(0, 1) : "",
                    numeroRif = ciaContab.Rif != null ? ciaContab.Rif.Replace("-", "").Substring(1, ciaContab.Rif.Replace("-", "").Length - 1) : "",
                    numeroContrato = cuentaBancariaCiaContab.NumeroContrato,
                    numeroLote = 0,
                    fechaEnvio = DateTime.Today,
                    cantidadOperaciones = resumenFacturas.Count(),
                    montoTotal = resumenFacturas.Sum(f => f.monto),
                    moneda = "VEB"
                };

                var result = new
                {
                    errorFlag = false,
                    resultMessage = "",
                    resumenFacturas = resumenFacturas,
                    registroCiaContab
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


        [HttpPost]
        [Route("api/RelacionMontosAPagarWebApi/construirDocumentoExcel")]
        public HttpResponseMessage construirDocumentoExcel([FromUri] int? cuentaBancariaID, [FromBody] ConstruirExcelCollections construirDocExcel_Collections)
        {
            if (!User.Identity.IsAuthenticated)
            {
                var errorResult = new
                {
                    errorFlag = true,
                    resultMessage = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            try
            {
                // --------------------------------------------------------------------------------------------------------------------------
                // establecemos una conexión a mongodb 
                string contabm_mongodb_connection = System.Web.Configuration.WebConfigurationManager.AppSettings["contabm_mongodb_connectionString"];
                string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

                var client = new MongoClient(contabm_mongodb_connection);
                // var server = client.GetServer();
                // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
                var mongoDataBase = client.GetDatabase(contabM_mongodb_name);

                // vamos a leer todas las compañías y ponerlas en una lista ... la cuenta bancaria (default) para cada compañía, será buscada allí ... 

                var companiasMongoCollection = mongoDataBase.GetCollection<Compania_mongodb>("Compania");
                var mongoQuery = from e in companiasMongoCollection.AsQueryable<Compania_mongodb>()
                                 select e; 
                List < Compania_mongodb > companias = mongoQuery.ToList();

                // -----------------------------------------------------------------------------------------------------------------
                // preparamos el documento Excel, para tratarlo con ClosedXML ... 
                string fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/Plantillas/InstruccionesPagoAlBanco/InstruccionesPagoAlBanco.xlsx");

                XLWorkbook wb;
                IXLWorksheet ws;

                try
                {
                    wb = new XLWorkbook(fileName);
                    ws = wb.Worksheet(1);
                }
                catch (Exception ex)
                {
                    string errorMessage = ex.Message;
                    if (ex.InnerException != null)
                        errorMessage += "<br />" + ex.InnerException.Message;

                    var errorResult = new
                    {
                        errorFlag = true,
                        resultMessage = errorMessage
                    };

                    return Request.CreateResponse(HttpStatusCode.OK, errorResult);
                }

                var excelTable = ws.Table("Facturas");
                // -----------------------------------------------------------------------------------------------------------------

                int cantidadRows = 0;

                foreach (var factura in construirDocExcel_Collections.FacturasSeleccionadas_List)
                {
                    cantidadRows++;

                    excelTable.DataRange.LastRow().Field(0).SetValue(factura.companiaID);
                    excelTable.DataRange.LastRow().Field(1).SetValue(factura.compania);
                    excelTable.DataRange.LastRow().Field(2).SetValue(new DateTime(factura.fechaRecepcion.Year, factura.fechaRecepcion.Month, factura.fechaRecepcion.Day));
                    excelTable.DataRange.LastRow().Field(3).SetValue(factura.numeroFactura);
                    excelTable.DataRange.LastRow().Field(4).SetValue(factura.numeroControl);
                    excelTable.DataRange.LastRow().Field(5).SetValue(factura.concepto);

                    excelTable.DataRange.LastRow().Field(6).SetValue(factura.montoNoImponible);
                    excelTable.DataRange.LastRow().Field(7).SetValue(factura.montoImponible);
                    excelTable.DataRange.LastRow().Field(8).SetValue(factura.Iva);
                    excelTable.DataRange.LastRow().Field(9).SetValue(factura.totalFactura);
                    excelTable.DataRange.LastRow().Field(10).SetValue(factura.montoPagado);
                    excelTable.DataRange.LastRow().Field(11).SetValue(factura.montoAPagar);

                    excelTable.DataRange.InsertRowsBelow(1);
                }



                // ---------------------------------------------------------- 
                // ahora escribimos registros a otra tabla en el documento 
                ws = wb.Worksheet(2);
                excelTable = ws.Table("Pagos");

                cantidadRows = 0;

                foreach (var pago in construirDocExcel_Collections.ResumenFacturas_List)
                {
                    cantidadRows++;

                    excelTable.DataRange.LastRow().Field(0).SetValue(pago.companiaID);
                    excelTable.DataRange.LastRow().Field(1).SetValue(pago.compania);
                    excelTable.DataRange.LastRow().Field(2).SetValue(pago.cantidadFacturasAPagar);
                    excelTable.DataRange.LastRow().Field(3).SetValue(pago.tipoPersona + '-' + pago.numeroRif);
                    excelTable.DataRange.LastRow().Field(4).SetValue(pago.nombreBeneficiario);
                    excelTable.DataRange.LastRow().Field(5).SetValue(pago.codigoBanco); 
                    excelTable.DataRange.LastRow().Field(6).SetValue(pago.numeroCuentaBancaria);
                    excelTable.DataRange.LastRow().Field(7).SetValue(new DateTime(pago.fechaValor.Year, pago.fechaValor.Month, pago.fechaValor.Day));
                    excelTable.DataRange.LastRow().Field(8).SetValue(pago.monto);
                    
                    excelTable.DataRange.InsertRowsBelow(1);
                }




                BancosEntities context = new BancosEntities();

                string nombreCiaContab = "";
                string rifCiaContab = "";

                CuentasBancaria cuentaBancaria = context.CuentasBancarias.Where(cta => cta.CuentaInterna == cuentaBancariaID).FirstOrDefault(); 

                if (cuentaBancaria != null)
                {
                    ContabSysNet_Web.ModelosDatos_EF.Bancos.Compania ciaContab = context.Companias.Where(cia => cia.Numero == cuentaBancaria.Cia).FirstOrDefault();

                    nombreCiaContab = ciaContab.Nombre;
                    rifCiaContab = ciaContab.Rif; 
                }


                ws = wb.Worksheet(1);
                ws.Cell("B2").Value = nombreCiaContab;
                ws.Cell("B3").Value = "Rif: " + rifCiaContab;

                string userName = User.Identity.Name.Replace("@", "_").Replace(".", "_");
                fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/InstruccionesPagoAlBanco_" + userName + ".xlsx");

                if (File.Exists(fileName))
                    File.Delete(fileName);

                wb.SaveAs(fileName);

                var errorResult2 = new
                {
                    errorFlag = false,
                    resultMessage = "Ok, el documento Excel se ha construído en forma satisfactoria.<br />" +
                                    "Por favor haga un click en la opción que le permite descargar (download) el documento a su computador."
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult2);
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


        [HttpGet]
        [Route("api/RelacionMontosAPagarWebApi/DocumentoExcelDownload")]
        public HttpResponseMessage DocumentoExcelDownload()
        {
            if (!User.Identity.IsAuthenticated)
            {
                var errorResult = new
                {
                    errorFlag = true,
                    resultMessage = "Error: por favor haga un login a esta aplicación, y luego regrese a ejecutar esta función."
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            string userName = User.Identity.Name.Replace("@", "_").Replace(".", "_");
            string fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/InstruccionesPagoAlBanco_" + userName + ".xlsx");

            if (!File.Exists(fileName))
            {
                string resultMessage = "Error: no hemos podido leer el archivo en el servidor que contiene el documento Excel que Ud. desea.<br /> " +
                    "El nombre del documento que no hemos podido leer es: " + fileName;

                var errorResult = new
                {
                    errorFlag = true,
                    resultMessage = resultMessage
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }

            try
            {
                HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK);

                var stream = new FileStream(fileName, FileMode.Open);
                result.Content = new StreamContent(stream);
                result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.ms-excel");
                result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment");
                result.Content.Headers.ContentDisposition.FileName = fileName;

                return result;
            }
            catch (Exception ex)
            {
                string resultMessage = ex.Message;
                if (ex.InnerException != null)
                    resultMessage += "<br />" + ex.InnerException.Message;

                resultMessage += "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + resultMessage;

                var errorResult = new
                {
                    errorFlag = true,
                    resultMessage = resultMessage
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }
        }
    }
}