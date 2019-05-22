using ClosedXML.Excel;
using ContabSysNet_Web.Areas.Bancos.Models.mongodb;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;
using System.Web.Security;

namespace ContabSysNet_Web.Areas.Bancos.Controllers
{
    public class FacturasConsultasExportarExcelWebApiController : ApiController
    {
        // métodos para la generación de libros de compra y venta en Excel ... 

        [HttpGet]
        [Route("api/FacturasConsultaExportarExcelWebApi/LeerPlantillasExcelDisponibles")]
        public HttpResponseMessage LeerPlantillasExcelDisponibles()
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

            string basePath_plantillasLibroCompras = System.Web.HttpContext.Current.Server.MapPath("~/Excel/Plantillas/LibroCompras");
            string basePath_plantillasLibroVentas = System.Web.HttpContext.Current.Server.MapPath("~/Excel/Plantillas/LibroVentas");

            // recorremos ambos directorios (plantillas de libros de venta y compra) y cargamos los nombres de los documentos Excel en una lista 

            List<string> librosVenta = new List<string>();
            List<string> librosCompra = new List<string>();

            string[] filePaths = Directory.GetFiles(basePath_plantillasLibroCompras, "*" + ".xlsx");
            foreach (string filePath in filePaths)
                librosCompra.Add(Path.GetFileName(filePath));

            filePaths = Directory.GetFiles(basePath_plantillasLibroVentas, "*" + ".xlsx");
            foreach (string filePath in filePaths)
                librosVenta.Add(Path.GetFileName(filePath));

            var result = new
            {
                errorFlag = false,
                resultMessage = "", 
                plantillasLibrosVenta = librosVenta, 
                plantillasLibroCompras = librosCompra
            };

            return Request.CreateResponse(HttpStatusCode.OK, result);
        }
   



        [HttpGet]
        [Route("api/FacturasConsultaExportarExcelWebApi/ConstruirConsulta")]
        public HttpResponseMessage ConstruirConsulta(string opcionSeleccionada, string plantillaSeleccionada)
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

            string userName = Membership.GetUser().UserName;

            // --------------------------------------------------------------------------------------------------------------------------
            // establecemos una conexión a mongodb 
            string contabm_mongodb_connection = System.Web.Configuration.WebConfigurationManager.AppSettings["contabm_mongodb_connectionString"];
            string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

            var client = new MongoClient(contabm_mongodb_connection);
            // var server = client.GetServer();
            // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
            var mongoDataBase = client.GetDatabase(contabM_mongodb_name);
            // --------------------------------------------------------------------------------------------------------------------------

            IMongoCollection<FacturaSeleccionada_Consultas> facturasMongoCollection = mongoDataBase.GetCollection<FacturaSeleccionada_Consultas>("Factura_Consultas");

            try
            {
                // --------------------------------------------------------------------------------------------------------------------------
                // ... para revisar si mongodb está disponible 
                var builder = Builders<FacturaSeleccionada_Consultas>.Filter;
                var filter = builder.Eq(x => x.NombreUsuario, "xyzxyz--999");

                facturasMongoCollection.DeleteManyAsync(filter);
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                string resultMessage = "Se producido un error al intentar ejecutar una operación en mongodb.<br />" +
                                   "El mensaje específico del error es:<br />" + message;

                var errorResult = new
                {
                    errorFlag = true,
                    resultMessage = resultMessage
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }


            // -----------------------------------------------------------------------------------------------------------------
            // preparamos el documento Excel, para tratarlo con ClosedXML ... 

            string fileName = ""; 

            switch (opcionSeleccionada)
            {
                case "LC":
                    {
                        fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/Plantillas/LibroCompras/" + plantillaSeleccionada);
                        break;
                    }
                case "LV":
                    {
                        fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/Plantillas/LibroVentas/" + plantillaSeleccionada);
                        break;
                    }
            }
            
            BancosEntities bancosContext = new BancosEntities();

            XLWorkbook wb;
            IXLWorksheet ws;

            try
            {
                wb = new XLWorkbook(fileName);
                ws = wb.Worksheet(1);
            }
            catch (Exception ex)
            {
                string resultMessage = ex.Message;
                if (ex.InnerException != null)
                    resultMessage += "<br />" + ex.InnerException.Message;

                var errorResult = new
                {
                    errorFlag = true,
                    resultMessage = resultMessage
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }



            // ahora ejecutamos una función diferente de acuerdo a la opción y plantilla seleccionados por el usuario ... 

            string errorMessage = "";
            bool construirExcelDocResult = false;
            int cantidadRows = 0;

            switch (opcionSeleccionada)
            {
                case "LC":
                    switch (plantillaSeleccionada)
                    {
                        case "LibroCompras.xlsx":
                            construirExcelDocResult = LibroCompras_OpcionOriginal(ws, facturasMongoCollection, bancosContext, userName, out cantidadRows, out errorMessage);
                            break;

                        case "LibroCompras 02.xlsx":
                            construirExcelDocResult = LibroCompras_Opcion_02(ws, facturasMongoCollection, userName, out cantidadRows, out errorMessage);
                            break;

                        case "LibroCompras 03.xlsx":
                            construirExcelDocResult = LibroCompras_Opcion_03(ws, facturasMongoCollection, bancosContext, userName, out cantidadRows, out errorMessage);
                            break;

                        case "LibroCompras 04.xlsx":
                            construirExcelDocResult = LibroCompras_Opcion_04(ws, facturasMongoCollection, bancosContext, userName, out cantidadRows, out errorMessage);
                            break;
                        case "LibroCompras 05.xlsx":
                            construirExcelDocResult = LibroCompras_Opcion_05(ws, facturasMongoCollection, bancosContext, userName, out cantidadRows, out errorMessage);
                            break;
                        case "LibroCompras 06.xlsx":
                            construirExcelDocResult = LibroCompras_Opcion_06(ws, facturasMongoCollection, bancosContext, userName, out cantidadRows, out errorMessage);
                            break;
                    }
                    break; 
                case "LV":
                    switch (plantillaSeleccionada)
                    {
                        case "LibroVentas.xlsx":
                            construirExcelDocResult = LibroVentas_OpcionOriginal(ws, facturasMongoCollection, bancosContext, userName, out cantidadRows, out errorMessage);
                            break;
                    }
                    break; 
            }


            if (!construirExcelDocResult)
            {
                // falló la ejecución de la función que construye el documento Excel ... 
                var errorResult = new
                {
                    errorFlag = true,
                    resultMessage = errorMessage
                };

                return Request.CreateResponse(HttpStatusCode.OK, errorResult);
            }


            userName = User.Identity.Name.Replace("@", "_").Replace(".", "_");
           
            switch (opcionSeleccionada)
            {
                case "LC":
                    {
                        fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/LibroCompras_" + userName + ".xlsx");
                        break;
                    }
                case "LV":
                    {
                        fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/LibroVentas_" + userName + ".xlsx");
                        break;
                    }
            }

            if (File.Exists(fileName))
                File.Delete(fileName);

            try
            {
                wb.SaveAs(fileName);

                string resultMessage = "Ok, la función que exporta los datos a <em>Microsoft Excel</em> se ha ejecutado en forma satisfactoria.<br />" +
                    "En total, se han agregado " + cantidadRows.ToString() + " registros a la tabla en el <em>documento Excel</em>.<br /><br />" +
                    "Ud. debe hacer un <em>click</em> en el botón que permite obtener (<em>download</em>) el documento.";

                var result = new
                {
                    errorFlag = false,
                    resultMessage = resultMessage
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
            catch (Exception ex)
            {
                string resultMessage = ex.Message;
                if (ex.InnerException != null)
                    resultMessage += "<br />" + ex.InnerException.Message;

                resultMessage += "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + resultMessage;

                var result = new
                {
                    errorFlag = false,
                    resultMessage = resultMessage
                };

                return Request.CreateResponse(HttpStatusCode.OK, result);
            }
        }




        // ---------------------------------------------------------------------------------------------------------
        // nótese que usamos una función diferente, para cada opción (plantilla Excel) diferente ... 

        private bool LibroCompras_OpcionOriginal(IXLWorksheet ws,
                                                 IMongoCollection<FacturaSeleccionada_Consultas> facturasMongoCollection,
                                                 BancosEntities bancosContext,
                                                 string userName,
                                                 out int cantidadRows,
                                                 out string errorMessage)
        {
            errorMessage = "";
            var excelTable = ws.Table("Ventas");
            // -----------------------------------------------------------------------------------------------------------------

            cantidadRows = 0;
            decimal ivaPorc = 0;
            decimal montoNoImponible = 0;
            decimal montoImponible = 0;
            decimal montoIva = 0;
            DateTime? fechaComprobanteRetencionIva = null;
            decimal montoRetencionImpuestosIva = 0;

            var query = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().Where(f => f.NombreUsuario == userName);

            foreach (var factura in query.OrderBy(f => f.FechaRecepcion).ThenBy(f => f.NumeroFactura))
            {
                cantidadRows++;

                excelTable.DataRange.LastRow().Field(0).SetValue(cantidadRows);
                excelTable.DataRange.LastRow().Field(1).SetValue(new DateTime(factura.FechaRecepcion.Year, factura.FechaRecepcion.Month, factura.FechaRecepcion.Day));
                excelTable.DataRange.LastRow().Field(2).SetValue(factura.NombreCompania);
                excelTable.DataRange.LastRow().Field(3).SetValue(factura.RifCompania);

                if (factura.ImportacionFlag)
                {
                    // importaciones 
                    switch (factura.NcNdFlag)
                    {
                        case "NC":
                            {
                                excelTable.DataRange.LastRow().Field(9).SetValue(factura.NumeroFactura);
                                excelTable.DataRange.LastRow().Field(10).SetValue(factura.NumeroFacturaAfectada);
                                break;
                            }
                        case "ND":
                            {
                                excelTable.DataRange.LastRow().Field(8).SetValue(factura.NumeroFactura);
                                break;
                            }
                        default:
                            {
                                excelTable.DataRange.LastRow().Field(4).SetValue(factura.NumeroFactura);
                                break;
                            }
                    }
                }
                else
                {
                    // compra nacional  
                    switch (factura.NcNdFlag)
                    {
                        case "NC":
                            {
                                excelTable.DataRange.LastRow().Field(7).SetValue(factura.NumeroFactura);
                                excelTable.DataRange.LastRow().Field(10).SetValue(factura.NumeroFacturaAfectada);
                                break;
                            }
                        case "ND":
                            {
                                excelTable.DataRange.LastRow().Field(6).SetValue(factura.NumeroFactura);
                                break;
                            }
                        default:
                            {
                                excelTable.DataRange.LastRow().Field(4).SetValue(factura.NumeroFactura);
                                break;
                            }
                    }
                }

                excelTable.DataRange.LastRow().Field(5).SetValue(factura.NumeroControl); 

                // calculamos el porcentaje de Iva, que no viene en el registro 

                montoNoImponible = factura.MontoFacturaSinIva != null ? factura.MontoFacturaSinIva.Value : 0;
                montoImponible = factura.MontoFacturaConIva != null ? factura.MontoFacturaConIva.Value : 0;
                montoIva = factura.Iva != null ? factura.Iva.Value : 0;
                ivaPorc = 0;
                fechaComprobanteRetencionIva = null;
                montoRetencionImpuestosIva = factura.RetencionSobreIva != null ? factura.RetencionSobreIva.Value : 0;

                if (montoImponible != 0)
                    ivaPorc = Math.Round(montoIva * 100 / montoImponible, 2);

                // ---------------------------------------------------------------------------------------------------------------------------------------
                // para determinar la fecha de recepción del comprobante, tenemos que buscar en la tabla FacturasImpuestos; además, en FacturasImpuestos, 
                // el registro cuyo correspondiente en ImpuestosRetencionesDefinicion tenga 1 en la columna Predefinido ... 

                Facturas_Impuestos impuestoIva = bancosContext.Facturas_Impuestos.Where(i => i.FacturaID == factura.ClaveUnicaFactura).
                                                                            Where(i => i.ImpuestosRetencionesDefinicion.Predefinido == 2).
                                                                            FirstOrDefault();

                if (impuestoIva != null)
                    fechaComprobanteRetencionIva = impuestoIva.FechaRecepcionPlanilla;

                if (factura.ImportacionFlag)
                {
                    excelTable.DataRange.LastRow().Field(11).SetValue(montoImponible + montoIva);     // gravadas 
                    excelTable.DataRange.LastRow().Field(12).SetValue(montoNoImponible);   // exoneradas
                    excelTable.DataRange.LastRow().Field(13).SetValue(montoImponible);    // base imponible  
                    excelTable.DataRange.LastRow().Field(14).SetValue(ivaPorc);
                    excelTable.DataRange.LastRow().Field(15).SetValue(montoIva);
                }
                else
                {
                    excelTable.DataRange.LastRow().Field(16).SetValue(montoImponible + montoIva);     // gravadas 
                    excelTable.DataRange.LastRow().Field(17).SetValue(montoNoImponible);   // exoneradas
                    excelTable.DataRange.LastRow().Field(18).SetValue(montoImponible);    // base imponible  
                    excelTable.DataRange.LastRow().Field(19).SetValue(ivaPorc);
                    excelTable.DataRange.LastRow().Field(20).SetValue(montoIva);
                }


                excelTable.DataRange.LastRow().Field(21).SetValue(factura.NumeroComprobante);
                excelTable.DataRange.LastRow().Field(22).SetValue(fechaComprobanteRetencionIva);
                excelTable.DataRange.LastRow().Field(23).SetValue(montoRetencionImpuestosIva);

                excelTable.DataRange.InsertRowsBelow(1);
            }


            if (cantidadRows == 0)
            {
                errorMessage = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                      "filtro y seleccionado información aún.";
                return false;
            }

            // en el libro de ventas, asumimos que el usuario seleccionó una sola empresa (cia contab) y usamos el primer registro 
            // de la lista de items seleccionados para obtenerla ... 

            string nombreCiaContab = "";
            string rifCiaContab = "";
            string direccionCiaContab = "";

            // -----------------------------------------------------------------------------------------------------------------------------
            // nótese como obtenemos el período de la consulta usando las fechas miníma y máxima del collection que filtró el usuario ... 

            DateTime fechaInicialPeriodo = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                                   Where(f => f.NombreUsuario == userName).
                                                                   Select(f => f.FechaRecepcion).
                                                                   Min();

            DateTime fechaFinalPeriodo = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                          Where(f => f.NombreUsuario == userName).
                                                          Select(f => f.FechaRecepcion).
                                                          Max();

            fechaInicialPeriodo = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1);
            fechaFinalPeriodo = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1).AddMonths(1).AddDays(-1);

            if (query.Count() > 0)
            {
                var factura = query.FirstOrDefault();
                nombreCiaContab = factura.CiaContabNombre;
                rifCiaContab = factura.CiaContabRif;
                direccionCiaContab = factura.CiaContabDireccion;
            }

            ws.Cell("B2").Value = nombreCiaContab;
            ws.Cell("B3").Value = "Rif: " + rifCiaContab;
            ws.Cell("B4").Value = direccionCiaContab;
            ws.Cell("B6").Value = "Período: " + fechaInicialPeriodo.ToString("dd-MM-yyyy") + " al " + fechaFinalPeriodo.ToString("dd-MM-yyyy");

            return true;
        }





        private bool LibroCompras_Opcion_02(IXLWorksheet ws,
                                            IMongoCollection<FacturaSeleccionada_Consultas> facturasMongoCollection,
                                            string userName,
                                            out int cantidadRows,
                                            out string errorMessage)
        {
            errorMessage = "";
            var excelTable = ws.Table("Ventas");
            // -----------------------------------------------------------------------------------------------------------------

            cantidadRows = 0;

            var query = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().Where(f => f.NombreUsuario == userName);

            foreach (var factura in query.OrderBy(f => f.FechaEmision).ThenBy(f => f.NumeroFactura))
            {
                cantidadRows++;

                excelTable.DataRange.LastRow().Field(0).SetValue(cantidadRows);
                excelTable.DataRange.LastRow().Field(1).SetValue(new DateTime(factura.FechaEmision.Year, factura.FechaEmision.Month, factura.FechaEmision.Day));

                string tipoDocumento = "FAC";
                if (factura.NcNdFlag == "NC")
                    tipoDocumento = "NC";

                excelTable.DataRange.LastRow().Field(2).SetValue(tipoDocumento);

                excelTable.DataRange.LastRow().Field(3).SetValue(factura.NumeroFactura);
                excelTable.DataRange.LastRow().Field(4).SetValue(factura.NumeroControl);
                excelTable.DataRange.LastRow().Field(5).SetValue(factura.NumeroFacturaAfectada);

                excelTable.DataRange.LastRow().Field(6).SetValue(factura.NombreCompania);
                excelTable.DataRange.LastRow().Field(7).SetValue(factura.RifCompania);

                decimal montoNoImponible = factura.MontoFacturaSinIva != null ? factura.MontoFacturaSinIva.Value : 0;
                decimal montoImponible = factura.MontoFacturaConIva != null ? factura.MontoFacturaConIva.Value : 0;
                decimal montoIva = factura.Iva != null ? factura.Iva.Value : 0;
                decimal totalVentasMasIva = montoNoImponible + montoImponible + montoIva;

                excelTable.DataRange.LastRow().Field(8).SetValue(totalVentasMasIva);                // total compras más iva 
                excelTable.DataRange.LastRow().Field(9).SetValue(montoNoImponible);                 // compras exentas 
                excelTable.DataRange.LastRow().Field(10).SetValue(montoImponible);                  // base imponible 
                excelTable.DataRange.LastRow().Field(11).SetValue(montoIva);                        // iva 
               
                excelTable.DataRange.InsertRowsBelow(1);
            }


            if (cantidadRows == 0)
            {
                errorMessage = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                      "filtro y seleccionado información aún.";
                return false;
            }

            // en el libro de ventas, asumimos que el usuario seleccionó una sola empresa (cia contab) y usamos el primer registro 
            // de la lista de items seleccionados para obtenerla ... 

            string nombreCiaContab = "";
            string rifCiaContab = "";
            string direccionCiaContab = "";

            // -----------------------------------------------------------------------------------------------------------------------------
            // nótese como obtenemos el período de la consulta usando las fechas miníma y máxima del collection que filtró el usuario ... 

            DateTime fechaInicialPeriodo = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                                   Where(f => f.NombreUsuario == userName).
                                                                   Select(f => f.FechaRecepcion).
                                                                   Min();

            DateTime fechaFinalPeriodo = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                          Where(f => f.NombreUsuario == userName).
                                                          Select(f => f.FechaRecepcion).
                                                          Max();

            fechaInicialPeriodo = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1);
            fechaFinalPeriodo = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1).AddMonths(1).AddDays(-1);

            if (query.Count() > 0)
            {
                var factura = query.FirstOrDefault();
                nombreCiaContab = factura.CiaContabNombre;
                rifCiaContab = factura.CiaContabRif;
                direccionCiaContab = factura.CiaContabDireccion;
            }

            ws.Cell("B2").Value = "Relación de compras para " + nombreCiaContab;
            ws.Cell("B3").Value = "Rif: " + rifCiaContab;
            ws.Cell("B4").Value = direccionCiaContab;
            ws.Cell("B6").Value = "Período: " + fechaInicialPeriodo.ToString("dd-MM-yyyy") + " al " + fechaFinalPeriodo.ToString("dd-MM-yyyy");

            return true;
        }




        private bool LibroCompras_Opcion_03(IXLWorksheet ws,
                                         IMongoCollection<FacturaSeleccionada_Consultas> facturasMongoCollection,
                                         BancosEntities bancosContext,
                                         string userName,
                                         out int cantidadRows,
                                         out string errorMessage)
        {
            errorMessage = "";
            var excelTable = ws.Table("Ventas");
            // -----------------------------------------------------------------------------------------------------------------

            cantidadRows = 0;
            decimal ivaPorc = 0;
            decimal montoNoImponible = 0;
            decimal montoImponible = 0;
            decimal montoIva = 0;
            DateTime? fechaComprobanteRetencionIva = null;
            decimal montoRetencionImpuestosIva = 0;

            var query = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().Where(f => f.NombreUsuario == userName);

            foreach (var factura in query.OrderBy(f => f.FechaRecepcion).ThenBy(f => f.NumeroFactura))
            {
                cantidadRows++;

                excelTable.DataRange.LastRow().Field(0).SetValue(cantidadRows);
                excelTable.DataRange.LastRow().Field(1).SetValue(new DateTime(factura.FechaRecepcion.Year, factura.FechaRecepcion.Month, factura.FechaRecepcion.Day));
                excelTable.DataRange.LastRow().Field(2).SetValue(factura.NombreCompania);
                excelTable.DataRange.LastRow().Field(3).SetValue(factura.RifCompania);

                if (factura.ImportacionFlag)
                {
                    // en este libro (excel) no mostramos la información de posibles facturas de compras extranjeras ... 

                    //switch (factura.NcNdFlag)
                    //{
                    //    case "NC":
                    //        {
                    //            excelTable.DataRange.LastRow().Field(7).SetValue(factura.NumeroFactura);
                    //            excelTable.DataRange.LastRow().Field(8).SetValue(factura.NumeroFacturaAfectada);
                    //            break;
                    //        }
                    //    case "ND":
                    //        {
                    //            excelTable.DataRange.LastRow().Field(6).SetValue(factura.NumeroFactura);
                    //            break;
                    //        }
                    //    default:
                    //        {
                    //            excelTable.DataRange.LastRow().Field(4).SetValue(factura.NumeroFactura);
                    //            break;
                    //        }
                    //}
                }
                else
                {
                    // compra nacional  
                    switch (factura.NcNdFlag)
                    {
                        case "NC":
                            {
                                excelTable.DataRange.LastRow().Field(7).SetValue(factura.NumeroFactura);
                                excelTable.DataRange.LastRow().Field(8).SetValue(factura.NumeroFacturaAfectada);
                                break;
                            }
                        case "ND":
                            {
                                excelTable.DataRange.LastRow().Field(6).SetValue(factura.NumeroFactura);
                                break;
                            }
                        default:
                            {
                                excelTable.DataRange.LastRow().Field(4).SetValue(factura.NumeroFactura);
                                break;
                            }
                    }
                }

                excelTable.DataRange.LastRow().Field(5).SetValue(factura.NumeroControl);

                // calculamos el porcentaje de Iva, que no viene en el registro 

                montoNoImponible = factura.MontoFacturaSinIva != null ? factura.MontoFacturaSinIva.Value : 0;
                montoImponible = factura.MontoFacturaConIva != null ? factura.MontoFacturaConIva.Value : 0;
                montoIva = factura.Iva != null ? factura.Iva.Value : 0;
                ivaPorc = 0;
                fechaComprobanteRetencionIva = null;
                montoRetencionImpuestosIva = factura.RetencionSobreIva != null ? factura.RetencionSobreIva.Value : 0;

                if (montoImponible != 0)
                    ivaPorc = Math.Round(montoIva * 100 / montoImponible, 2);

                // ---------------------------------------------------------------------------------------------------------------------------------------
                // para determinar la fecha de recepción del comprobante, tenemos que buscar en la tabla FacturasImpuestos; además, en FacturasImpuestos, 
                // el registro cuyo correspondiente en ImpuestosRetencionesDefinicion tenga 1 en la columna Predefinido ... 

                Facturas_Impuestos impuestoIva = bancosContext.Facturas_Impuestos.Where(i => i.FacturaID == factura.ClaveUnicaFactura).
                                                                            Where(i => i.ImpuestosRetencionesDefinicion.Predefinido == 2).
                                                                            FirstOrDefault();

                if (impuestoIva != null)
                    fechaComprobanteRetencionIva = impuestoIva.FechaRecepcionPlanilla;

                if (factura.ImportacionFlag)
                {
                    // en este libro (excel) no mostramos la información de posibles facturas de compras extranjeras ... 

                    //excelTable.DataRange.LastRow().Field(11).SetValue(montoImponible + montoIva);     // gravadas 
                    //excelTable.DataRange.LastRow().Field(12).SetValue(montoNoImponible);   // exoneradas
                    //excelTable.DataRange.LastRow().Field(13).SetValue(montoImponible);    // base imponible  
                    //excelTable.DataRange.LastRow().Field(14).SetValue(ivaPorc);
                    //excelTable.DataRange.LastRow().Field(15).SetValue(montoIva);
                }
                else
                {
                    excelTable.DataRange.LastRow().Field(9).SetValue(montoImponible + montoIva);     // gravadas 
                    excelTable.DataRange.LastRow().Field(10).SetValue(montoNoImponible);   // exoneradas
                    excelTable.DataRange.LastRow().Field(11).SetValue(montoImponible);    // base imponible  
                    excelTable.DataRange.LastRow().Field(12).SetValue(ivaPorc);
                    excelTable.DataRange.LastRow().Field(13).SetValue(montoIva);
                }


                excelTable.DataRange.LastRow().Field(14).SetValue(factura.NumeroComprobante);
                excelTable.DataRange.LastRow().Field(15).SetValue(fechaComprobanteRetencionIva);
                excelTable.DataRange.LastRow().Field(16).SetValue(montoRetencionImpuestosIva);

                excelTable.DataRange.InsertRowsBelow(1);
            }


            if (cantidadRows == 0)
            {
                errorMessage = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                      "filtro y seleccionado información aún.";
                return false;
            }

            // en el libro de ventas, asumimos que el usuario seleccionó una sola empresa (cia contab) y usamos el primer registro 
            // de la lista de items seleccionados para obtenerla ... 

            string nombreCiaContab = "";
            string rifCiaContab = "";
            string direccionCiaContab = "";

            // -----------------------------------------------------------------------------------------------------------------------------
            // nótese como obtenemos el período de la consulta usando las fechas miníma y máxima del collection que filtró el usuario ... 

            DateTime fechaInicialPeriodo = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                                   Where(f => f.NombreUsuario == userName).
                                                                   Select(f => f.FechaRecepcion).
                                                                   Min();

            DateTime fechaFinalPeriodo = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                          Where(f => f.NombreUsuario == userName).
                                                          Select(f => f.FechaRecepcion).
                                                          Max();

            fechaInicialPeriodo = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1);
            fechaFinalPeriodo = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1).AddMonths(1).AddDays(-1);

            if (query.Count() > 0)
            {
                var factura = query.FirstOrDefault();
                nombreCiaContab = factura.CiaContabNombre;
                rifCiaContab = factura.CiaContabRif;
                direccionCiaContab = factura.CiaContabDireccion;
            }

            ws.Cell("B2").Value = nombreCiaContab;
            ws.Cell("B3").Value = "Rif: " + rifCiaContab;
            ws.Cell("B4").Value = direccionCiaContab;
            ws.Cell("B6").Value = "Período: " + fechaInicialPeriodo.ToString("dd-MM-yyyy") + " al " + fechaFinalPeriodo.ToString("dd-MM-yyyy");

            return true;
        }




        private bool LibroCompras_Opcion_04(IXLWorksheet ws,
                                 IMongoCollection<FacturaSeleccionada_Consultas> facturasMongoCollection,
                                 BancosEntities bancosContext,
                                 string userName,
                                 out int cantidadRows,
                                 out string errorMessage)
        {
            errorMessage = "";
            var excelTable = ws.Table("Ventas");
            // -----------------------------------------------------------------------------------------------------------------

            cantidadRows = 0;
            decimal ivaPorc = 0;
            decimal montoNoImponible = 0;
            decimal montoImponible = 0;
            decimal montoIva = 0;
            DateTime? fechaComprobanteRetencionIva = null;
            decimal montoRetencionImpuestosIva = 0;

            var query = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().Where(f => f.NombreUsuario == userName);

            foreach (var factura in query.OrderBy(f => f.FechaRecepcion).ThenBy(f => f.NumeroFactura))
            {
                cantidadRows++;

                excelTable.DataRange.LastRow().Field(0).SetValue(cantidadRows);
                excelTable.DataRange.LastRow().Field(1).SetValue(new DateTime(factura.FechaRecepcion.Year, factura.FechaRecepcion.Month, factura.FechaRecepcion.Day));
                excelTable.DataRange.LastRow().Field(2).SetValue(factura.NombreCompania);
                excelTable.DataRange.LastRow().Field(3).SetValue(factura.RifCompania);

                if (factura.ImportacionFlag)
                {
                    // en este libro (excel) no mostramos la información de posibles facturas de compras extranjeras ... 
                }
                else
                {
                    // compra nacional  
                    switch (factura.NcNdFlag)
                    {
                        case "NC":
                            {
                                excelTable.DataRange.LastRow().Field(10).SetValue(factura.NumeroFactura);
                                excelTable.DataRange.LastRow().Field(12).SetValue(factura.NumeroFacturaAfectada);
                                break;
                            }
                        case "ND":
                            {
                                excelTable.DataRange.LastRow().Field(9).SetValue(factura.NumeroFactura);
                                break;
                            }
                        default:
                            {
                                excelTable.DataRange.LastRow().Field(7).SetValue(factura.NumeroFactura);
                                break;
                            }
                    }
                }

                excelTable.DataRange.LastRow().Field(8).SetValue(factura.NumeroControl);
                excelTable.DataRange.LastRow().Field(11).SetValue("01-REG");

                // calculamos el porcentaje de Iva, que no viene en el registro 

                montoNoImponible = factura.MontoFacturaSinIva != null ? factura.MontoFacturaSinIva.Value : 0;
                montoImponible = factura.MontoFacturaConIva != null ? factura.MontoFacturaConIva.Value : 0;
                montoIva = factura.Iva != null ? factura.Iva.Value : 0;
                ivaPorc = 0;
                fechaComprobanteRetencionIva = null;
                montoRetencionImpuestosIva = factura.RetencionSobreIva != null ? factura.RetencionSobreIva.Value : 0;

                if (montoImponible != 0)
                    ivaPorc = Math.Round(montoIva * 100 / montoImponible, 2);

                // ---------------------------------------------------------------------------------------------------------------------------------------
                // para determinar la fecha de recepción del comprobante, tenemos que buscar en la tabla FacturasImpuestos; además, en FacturasImpuestos, 
                // el registro cuyo correspondiente en ImpuestosRetencionesDefinicion tenga 1 en la columna Predefinido ... 

                Facturas_Impuestos impuestoIva = bancosContext.Facturas_Impuestos.Where(i => i.FacturaID == factura.ClaveUnicaFactura).
                                                                            Where(i => i.ImpuestosRetencionesDefinicion.Predefinido == 2).
                                                                            FirstOrDefault();

                if (impuestoIva != null)
                    fechaComprobanteRetencionIva = impuestoIva.FechaRecepcionPlanilla;

                if (factura.ImportacionFlag)
                {
                    // en este libro (excel) no mostramos la información de posibles facturas de compras extranjeras ... 
                }
                else
                {
                    excelTable.DataRange.LastRow().Field(14).SetValue(montoImponible);    // base imponible  
                    excelTable.DataRange.LastRow().Field(16).SetValue(montoNoImponible);   // exoneradas
                    excelTable.DataRange.LastRow().Field(18).SetValue(montoImponible + montoIva);     // gravadas 
                    excelTable.DataRange.LastRow().Field(19).SetValue(montoNoImponible);   // exoneradas


                    excelTable.DataRange.LastRow().Field(23).SetValue(montoImponible);    // base imponible  
                    excelTable.DataRange.LastRow().Field(24).SetValue(ivaPorc);    // base imponible  
                    excelTable.DataRange.LastRow().Field(25).SetValue(montoIva);    // base imponible  
                    
                    
                    //excelTable.DataRange.LastRow().Field(12).SetValue(ivaPorc);
                    excelTable.DataRange.LastRow().Field(26).SetValue(montoIva);
                }

                
                excelTable.DataRange.LastRow().Field(27).SetValue(fechaComprobanteRetencionIva);
                excelTable.DataRange.LastRow().Field(28).SetValue(factura.NumeroComprobante);
                excelTable.DataRange.LastRow().Field(29).SetValue(montoRetencionImpuestosIva);
                excelTable.DataRange.LastRow().Field(30).SetValue(montoIva - montoRetencionImpuestosIva);

                excelTable.DataRange.InsertRowsBelow(1);
            }


            if (cantidadRows == 0)
            {
                errorMessage = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                      "filtro y seleccionado información aún.";
                return false;
            }

            // en el libro de ventas, asumimos que el usuario seleccionó una sola empresa (cia contab) y usamos el primer registro 
            // de la lista de items seleccionados para obtenerla ... 

            string nombreCiaContab = "";
            string rifCiaContab = "";
            string direccionCiaContab = "";

            // -----------------------------------------------------------------------------------------------------------------------------
            // nótese como obtenemos el período de la consulta usando las fechas miníma y máxima del collection que filtró el usuario ... 

            DateTime fechaInicialPeriodo = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                                   Where(f => f.NombreUsuario == userName).
                                                                   Select(f => f.FechaRecepcion).
                                                                   Min();

            DateTime fechaFinalPeriodo = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                          Where(f => f.NombreUsuario == userName).
                                                          Select(f => f.FechaRecepcion).
                                                          Max();

            fechaInicialPeriodo = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1);
            fechaFinalPeriodo = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1).AddMonths(1).AddDays(-1);

            if (query.Count() > 0)
            {
                var factura = query.FirstOrDefault();
                nombreCiaContab = factura.CiaContabNombre;
                rifCiaContab = factura.CiaContabRif;
                direccionCiaContab = factura.CiaContabDireccion;
            }

            ws.Cell("B2").Value = nombreCiaContab;
            ws.Cell("B3").Value = "Rif: " + rifCiaContab;
            ws.Cell("B4").Value = direccionCiaContab;
            ws.Cell("B6").Value = "Período: " + fechaInicialPeriodo.ToString("dd-MM-yyyy") + " al " + fechaFinalPeriodo.ToString("dd-MM-yyyy");

            ws.Cell("L2").Value = "Libro de Compras para el período: " + fechaInicialPeriodo.ToString("dd-MM-yyyy") + " al " + fechaFinalPeriodo.ToString("dd-MM-yyyy");

            return true;
        }




        private bool LibroCompras_Opcion_05(IXLWorksheet ws,
                                 IMongoCollection<FacturaSeleccionada_Consultas> facturasMongoCollection,
                                 BancosEntities bancosContext,
                                 string userName,
                                 out int cantidadRows,
                                 out string errorMessage)
        {
            errorMessage = "";
            var excelTable = ws.Table("Ventas");
            // -----------------------------------------------------------------------------------------------------------------

            cantidadRows = 0;
            decimal ivaPorc = 0;
            decimal montoNoImponible = 0;
            decimal montoImponible = 0;
            decimal montoIva = 0;
            DateTime? fechaComprobanteRetencionIva = null;
            decimal montoRetencionImpuestosIva = 0;

            var query = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                Where(f => f.NombreUsuario == userName).
                                                OrderBy(f => f.FechaEmision).
                                                ThenBy(f => f.NumeroFactura);

            foreach (var factura in query.OrderBy(f => f.FechaEmision).ThenBy(f => f.NumeroFactura))
            {
                cantidadRows++;

                excelTable.DataRange.LastRow().Field(0).SetValue(cantidadRows);
                excelTable.DataRange.LastRow().Field(1).SetValue(new DateTime(factura.FechaEmision.Year, factura.FechaEmision.Month, factura.FechaEmision.Day));
                excelTable.DataRange.LastRow().Field(2).SetValue(factura.RifCompania);

                // en el registro viene un field que indica si el proveedor es o no contribuyente; nota: si el valor viene en nulls, 
                // consideramos que el proveedor es contribuyente ... 

                if (factura.ContribuyenteFlag.HasValue && !factura.ContribuyenteFlag.Value)
                    // proveedor no contribuyente 
                    excelTable.DataRange.LastRow().Field(4).SetValue(factura.NombreCompania);
                else
                    // proveedor contribuyente 
                    excelTable.DataRange.LastRow().Field(3).SetValue(factura.NombreCompania);


                if (factura.ImportacionFlag)
                {
                    // en este libro (excel) no mostramos la información de posibles facturas de compras extranjeras ... 
                }
                else
                {
                    // compra nacional  
                    switch (factura.NcNdFlag)
                    {
                        case "NC":
                            {
                                excelTable.DataRange.LastRow().Field(10).SetValue(factura.NumeroFactura);
                                excelTable.DataRange.LastRow().Field(12).SetValue(factura.NumeroFacturaAfectada);
                                excelTable.DataRange.LastRow().Field(11).SetValue("02-COM");
                                break;
                            }
                        case "ND":
                            {
                                excelTable.DataRange.LastRow().Field(9).SetValue(factura.NumeroFactura);
                                excelTable.DataRange.LastRow().Field(11).SetValue("01-REG");
                                break;
                            }
                        default:
                            {
                                excelTable.DataRange.LastRow().Field(7).SetValue(factura.NumeroFactura);
                                excelTable.DataRange.LastRow().Field(11).SetValue("01-REG");
                                break;
                            }
                    }
                }

                excelTable.DataRange.LastRow().Field(8).SetValue(factura.NumeroControl);

                // calculamos el porcentaje de Iva, que no viene en el registro 

                montoNoImponible = factura.MontoFacturaSinIva != null ? factura.MontoFacturaSinIva.Value : 0;
                montoImponible = factura.MontoFacturaConIva != null ? factura.MontoFacturaConIva.Value : 0;
                //montoIva = factura.Iva != null ? factura.Iva.Value : 0;

                //ivaPorc = 0;
                fechaComprobanteRetencionIva = null;
                //montoRetencionImpuestosIva = factura.RetencionSobreIva != null ? factura.RetencionSobreIva.Value : 0;

                //if (montoImponible != 0)
                //    ivaPorc = Math.Round(montoIva * 100 / montoImponible, 2);



                if (montoNoImponible != 0)
                    excelTable.DataRange.LastRow().Field(14).SetValue(montoNoImponible);   // exoneradas


                // estos montos son leídos en la tabla de impuestos (Facturas_Impuestos) registrado para la factura ... 
                montoIva = 0;
                montoRetencionImpuestosIva = 0;



                if (factura.ImportacionFlag)
                {
                    // en este libro (excel) no mostramos la información de posibles facturas de compras extranjeras ... 
                }
                else
                {
                    var queryImpuestosIva = bancosContext.Facturas_Impuestos.Where(i => i.FacturaID == factura.ClaveUnicaFactura).
                                                                             Where(i => i.ImpuestosRetencionesDefinicion.Predefinido == 1 ||
                                                                                        i.ImpuestosRetencionesDefinicion.Predefinido == 2);


                    // aunque muy pocas veces, una factura puede tener más de un monto de impuesto iva relacionado. Por ejemplo, 
                    // una base imponible a una tasa de 12% (general) y otra base imponible a una tasa de 8% (reducida). 
                    // En esos casos, leemos varias y las intentamos mostrar en la hoja Excel en su espacio correspondiente ... 
                    foreach (var montoImpuestoIva in queryImpuestosIva)
                    {
                        if (montoImpuestoIva.ImpuestosRetencionesDefinicion.Predefinido == 1)
                        {
                            // el registro corresponde a un monto de impuestos Iva 
                            montoIva += montoImpuestoIva.Monto;
                        }
                        else
                        {
                            // el registro corresponde a un monto de retención sobre el Iva 
                            montoRetencionImpuestosIva += montoImpuestoIva.Monto;

                            // ---------------------------------------------------------------------------------------------------------------------------------------
                            // para determinar la fecha de recepción del comprobante, tenemos que buscar en la tabla FacturasImpuestos; además, en FacturasImpuestos, 
                            // el registro cuyo correspondiente en ImpuestosRetencionesDefinicion tenga dos (2: retención Iva) en la columna Predefinido ... 
                            if (montoImpuestoIva.FechaRecepcionPlanilla != null)
                                fechaComprobanteRetencionIva = montoImpuestoIva.FechaRecepcionPlanilla;
                            else
                                if (!string.IsNullOrEmpty(factura.NumeroComprobante))
                                    // si la fecha del comprobante no se ha registrado, simplemente, usamos la fecha de recepción de la factura 
                                    fechaComprobanteRetencionIva = new DateTime(factura.FechaRecepcion.Year, factura.FechaRecepcion.Month, factura.FechaRecepcion.Day);

                            // solo agregamos a la hoja Excel montos de impuestos Iva (aunque deerminamos la retención del impuesto 
                            // para mostrarlo luego de los montos Iva) 
                            continue;
                        }


                        ivaPorc = montoImpuestoIva.Porcentaje.Value;

                        // nota: la 'm' es para expresar el literal en tipo decimal ... 
                        if (ivaPorc >= 11.5m && ivaPorc <= 12.5m)
                        {
                            excelTable.DataRange.LastRow().Field(15).SetValue(montoImpuestoIva.MontoBase);    // base imponible  
                            excelTable.DataRange.LastRow().Field(16).SetValue(montoImpuestoIva.Porcentaje);
                            excelTable.DataRange.LastRow().Field(17).SetValue(montoImpuestoIva.Monto);
                        }

                        if (ivaPorc >= 7.5m && ivaPorc <= 9.5m)
                        {
                            excelTable.DataRange.LastRow().Field(18).SetValue(montoImpuestoIva.MontoBase);    // base imponible  
                            excelTable.DataRange.LastRow().Field(19).SetValue(montoImpuestoIva.Porcentaje);
                            excelTable.DataRange.LastRow().Field(20).SetValue(montoImpuestoIva.Monto);
                        }

                        if (ivaPorc >= 26.5m && ivaPorc <= 27.5m)
                        {
                            excelTable.DataRange.LastRow().Field(21).SetValue(montoImpuestoIva.MontoBase);    // base imponible  
                            excelTable.DataRange.LastRow().Field(22).SetValue(montoImpuestoIva.Porcentaje);
                            excelTable.DataRange.LastRow().Field(23).SetValue(montoImpuestoIva.Monto);
                        }

                    }

                }

                // el monto Iva solo lo conocemos luego de haberlo leído arriba (en la tabla FacturasImpuestos) ... 
                excelTable.DataRange.LastRow().Field(13).SetValue(montoNoImponible + montoImponible + montoIva);    // total compras (inc Iva) 

                if (montoIva != 0)
                    excelTable.DataRange.LastRow().Field(24).SetValue(montoIva);

                // datos del comprobante de retención 
                excelTable.DataRange.LastRow().Field(25).SetValue(fechaComprobanteRetencionIva);
                excelTable.DataRange.LastRow().Field(26).SetValue(factura.NumeroComprobante);

                if (montoRetencionImpuestosIva != 0)
                    excelTable.DataRange.LastRow().Field(27).SetValue(montoRetencionImpuestosIva);

                if (montoIva != 0 || montoRetencionImpuestosIva != 0)
                    excelTable.DataRange.LastRow().Field(28).SetValue(montoIva - montoRetencionImpuestosIva);

                excelTable.DataRange.InsertRowsBelow(1);
            }


            if (cantidadRows == 0)
            {
                errorMessage = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                      "filtro y seleccionado información aún.";
                return false;
            }

            // en el libro de ventas, asumimos que el usuario seleccionó una sola empresa (cia contab) y usamos el primer registro 
            // de la lista de items seleccionados para obtenerla ... 

            string nombreCiaContab = "";
            string rifCiaContab = "";
            string direccionCiaContab = "";

            // -----------------------------------------------------------------------------------------------------------------------------
            // nótese como obtenemos el período de la consulta usando las fechas miníma y máxima del collection que filtró el usuario ... 

            DateTime fechaInicialPeriodo = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                                   Where(f => f.NombreUsuario == userName).
                                                                   Select(f => f.FechaRecepcion).
                                                                   Min();

            DateTime fechaFinalPeriodo = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                          Where(f => f.NombreUsuario == userName).
                                                          Select(f => f.FechaRecepcion).
                                                          Max();

            fechaInicialPeriodo = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1);
            fechaFinalPeriodo = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1).AddMonths(1).AddDays(-1);

            if (query.Count() > 0)
            {
                var factura = query.FirstOrDefault();
                nombreCiaContab = factura.CiaContabNombre;
                rifCiaContab = factura.CiaContabRif;
                direccionCiaContab = factura.CiaContabDireccion;
            }

            ws.Cell("B2").Value = nombreCiaContab;
            ws.Cell("B3").Value = "Rif: " + rifCiaContab;
            ws.Cell("B4").Value = direccionCiaContab;
            ws.Cell("B6").Value = "Período: " + fechaInicialPeriodo.ToString("dd-MM-yyyy") + " al " + fechaFinalPeriodo.ToString("dd-MM-yyyy");

            ws.Cell("M2").Value = "Libro de Compras para el período: " + fechaInicialPeriodo.ToString("dd-MM-yyyy") + " al " + fechaFinalPeriodo.ToString("dd-MM-yyyy");

            return true;
        }



        private bool LibroCompras_Opcion_06(IXLWorksheet ws,
                         IMongoCollection<FacturaSeleccionada_Consultas> facturasMongoCollection,
                         BancosEntities bancosContext,
                         string userName,
                         out int cantidadRows,
                         out string errorMessage)
        {
            errorMessage = "";
            var excelTable = ws.Table("Ventas");
            // -----------------------------------------------------------------------------------------------------------------

            cantidadRows = 0;
            decimal ivaPorc = 0;
            decimal montoNoImponible = 0;
            decimal montoImponible = 0;
            decimal montoIva = 0;
            decimal montoRetencionImpuestosIva = 0;

            var query = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                Where(f => f.NombreUsuario == userName).
                                                OrderBy(f => f.FechaEmision).
                                                ThenBy(f => f.NumeroFactura);

            foreach (var factura in query.OrderBy(f => f.FechaEmision).ThenBy(f => f.NumeroFactura))
            {
                cantidadRows++;

                //excelTable.DataRange.LastRow().Field(0).SetValue(cantidadRows);
                excelTable.DataRange.LastRow().Field(0).SetValue(new DateTime(factura.FechaRecepcion.Year, factura.FechaRecepcion.Month, factura.FechaRecepcion.Day));
                excelTable.DataRange.LastRow().Field(3).SetValue(factura.NumeroFactura);
                
                excelTable.DataRange.LastRow().Field(7).SetValue(factura.NombreCompania);
                excelTable.DataRange.LastRow().Field(8).SetValue(factura.RifCompania);

                montoNoImponible = factura.MontoFacturaSinIva != null ? factura.MontoFacturaSinIva.Value : 0;
                montoImponible = factura.MontoFacturaConIva != null ? factura.MontoFacturaConIva.Value : 0;

                excelTable.DataRange.LastRow().Field(9).SetValue(montoImponible + montoNoImponible);   // total factura
                excelTable.DataRange.LastRow().Field(10).SetValue(montoImponible);  

                montoIva = 0;
                montoRetencionImpuestosIva = 0;

                var queryImpuestosIva = bancosContext.Facturas_Impuestos.Where(i => i.FacturaID == factura.ClaveUnicaFactura).
                                                                            Where(i => i.ImpuestosRetencionesDefinicion.Predefinido == 1 ||
                                                                                    i.ImpuestosRetencionesDefinicion.Predefinido == 2);


                // aunque muy pocas veces, una factura tiene más de un monto de impuesto iva relacionado (y de retención sobre ese impuesto). 
                // Por ejemplo, una base imponible a una tasa de 12% (general) y otra base imponible a una tasa de 8% (reducida). 
                // En esos casos, leemos varias y las intentamos mostrar en la hoja Excel en su espacio correspondiente ... 
                foreach (var montoImpuestoIva in queryImpuestosIva)
                {
                    if (montoImpuestoIva.ImpuestosRetencionesDefinicion.Predefinido == 1)
                    {
                        // el registro corresponde a un monto de impuestos Iva 
                        ivaPorc = montoImpuestoIva.Porcentaje.Value;
                        montoIva += montoImpuestoIva.Monto;
                    }
                    else
                    {
                        // el registro corresponde a un monto de retención sobre el Iva 
                        montoRetencionImpuestosIva += montoImpuestoIva.Monto;
                    }
                }


                excelTable.DataRange.LastRow().Field(11).SetValue(montoIva);    
                excelTable.DataRange.LastRow().Field(12).SetValue(montoNoImponible);
                excelTable.DataRange.LastRow().Field(13).SetValue(montoRetencionImpuestosIva);    

                // datos del comprobante de retención 
                // nótese como aquí usamos *siempre* la fecha de recepción de la factura como la fecha de su comprobante Iva 
                if (!string.IsNullOrEmpty(factura.NumeroComprobante)) 
                {
                    excelTable.DataRange.LastRow().Field(14).SetValue(factura.FechaRecepcion.ToString("dd-MM-yyyy"));
                    excelTable.DataRange.LastRow().Field(15).SetValue(factura.NumeroComprobante);
                }
                
                excelTable.DataRange.InsertRowsBelow(1);
            }


            if (cantidadRows == 0)
            {
                errorMessage = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                      "filtro y seleccionado información aún.";
                return false;
            }

            // en el libro de ventas, asumimos que el usuario seleccionó una sola empresa (cia contab) y usamos el primer registro 
            // de la lista de items seleccionados para obtenerla ... 

            string nombreCiaContab = "";
            string rifCiaContab = "";
            string direccionCiaContab = "";

            // -----------------------------------------------------------------------------------------------------------------------------
            // nótese como obtenemos el período de la consulta usando las fechas miníma y máxima del collection que filtró el usuario ... 

            DateTime fechaInicialPeriodo = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                                   Where(f => f.NombreUsuario == userName).
                                                                   Select(f => f.FechaRecepcion).
                                                                   Min();

            DateTime fechaFinalPeriodo = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                          Where(f => f.NombreUsuario == userName).
                                                          Select(f => f.FechaRecepcion).
                                                          Max();

            ws.Cell("B6").Value = "Relación de Compras, Bienes y Servicios para el Mes <indique el mes> del Año <indique el año>";

            if (fechaInicialPeriodo != null && fechaFinalPeriodo != null)
            {
                fechaInicialPeriodo = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1);
                fechaFinalPeriodo = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1).AddMonths(1).AddDays(-1);

                ws.Cell("B6").Value = "Relación de Compras, Bienes y Servicios para el Mes " + fechaInicialPeriodo.ToString("MMMM").ToUpper() + 
                                      " del Año " + fechaFinalPeriodo.ToString("yyyy");
            }
            

            if (query.Count() > 0)
            {
                var primeraFactura = query.FirstOrDefault();
                var companiaContab = bancosContext.Companias.Where(c => c.Numero == primeraFactura.CiaContab).FirstOrDefault();
                nombreCiaContab = companiaContab.Nombre;
                rifCiaContab = companiaContab.Rif;
                direccionCiaContab = companiaContab.Direccion;
            }

            ws.Cell("B2").Value = nombreCiaContab;
            ws.Cell("B3").Value = rifCiaContab;
            ws.Cell("B4").Value = direccionCiaContab;

            return true;
        }


        private bool LibroVentas_OpcionOriginal(IXLWorksheet ws,
                                                IMongoCollection<FacturaSeleccionada_Consultas> facturasMongoCollection,
                                                BancosEntities bancosContext,
                                                string userName,
                                                out int cantidadRows,
                                                out string errorMessage)
        {
            errorMessage = "";
            var excelTable = ws.Table("Ventas");
            // -----------------------------------------------------------------------------------------------------------------

            cantidadRows = 0;
            decimal ivaPorc = 0;
            //decimal montoNoImponible = 0;
            decimal montoImponible = 0;
            decimal montoIva = 0;
            DateTime? fechaComprobanteRetencionIva = null;
            //decimal montoRetencionImpuestosIva = 0;

            var query = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().Where(f => f.NombreUsuario == userName);

            foreach (var factura in query)
            {
                cantidadRows++;

                excelTable.DataRange.LastRow().Field(0).SetValue(cantidadRows);
                excelTable.DataRange.LastRow().Field(1).SetValue(new DateTime(factura.FechaEmision.Year, factura.FechaEmision.Month, factura.FechaEmision.Day));
                excelTable.DataRange.LastRow().Field(2).SetValue(factura.NombreCompania);
                excelTable.DataRange.LastRow().Field(3).SetValue(factura.RifCompania);

                switch (factura.NcNdFlag)
                {
                    case "NC":
                        {
                            excelTable.DataRange.LastRow().Field(6).SetValue(factura.NumeroFactura);
                            excelTable.DataRange.LastRow().Field(7).SetValue(factura.NumeroFacturaAfectada);
                            break;
                        }
                    case "ND":
                        {
                            excelTable.DataRange.LastRow().Field(5).SetValue(factura.NumeroFactura);
                            break;
                        }
                    default:
                        {
                            excelTable.DataRange.LastRow().Field(4).SetValue(factura.NumeroFactura);
                            break;
                        }

                }

                // calculamos el porcentaje de Iva, que no viene en el registro 

                montoImponible = factura.MontoFacturaConIva != null ? factura.MontoFacturaConIva.Value : 0;
                montoIva = factura.Iva != null ? factura.Iva.Value : 0;
                ivaPorc = 0;
                fechaComprobanteRetencionIva = null;

                if (montoImponible != 0)
                    ivaPorc = Math.Round(montoIva * 100 / montoImponible, 2);

                // para determinar la fecha de recepción del comprobante, tenemos que buscar en la tabla FacturasImpuestos; además, en FacturasImpuestos, 
                // el registro cuyo correspondiente en ImpuestosRetencionesDefinicion tenga 1 en la columna Predefinido ... 

                Facturas_Impuestos impuestoIva = bancosContext.Facturas_Impuestos.Where(i => i.FacturaID == factura.ClaveUnicaFactura).
                                                                                  Where(i => i.ImpuestosRetencionesDefinicion.Predefinido == 1).
                                                                                  FirstOrDefault();

                if (impuestoIva != null)
                    fechaComprobanteRetencionIva = impuestoIva.FechaRecepcionPlanilla;

                excelTable.DataRange.LastRow().Field(10).SetValue(factura.TotalFactura);
                excelTable.DataRange.LastRow().Field(11).SetValue(factura.MontoFacturaConIva != null ? factura.MontoFacturaConIva.Value : 0);
                excelTable.DataRange.LastRow().Field(12).SetValue(factura.MontoFacturaSinIva != null ? factura.MontoFacturaSinIva.Value : 0);

                //excelTable.DataRange.LastRow().Field(13).SetValue();              // no sujetas ... 
                excelTable.DataRange.LastRow().Field(14).SetValue(ivaPorc);
                excelTable.DataRange.LastRow().Field(15).SetValue(factura.Iva != null ? factura.Iva.Value : 0);

                excelTable.DataRange.LastRow().Field(19).SetValue(factura.NumeroComprobante);
                excelTable.DataRange.LastRow().Field(20).SetValue(fechaComprobanteRetencionIva);
                excelTable.DataRange.LastRow().Field(21).SetValue(factura.RetencionSobreIva != null ? factura.RetencionSobreIva.Value : 0);

                excelTable.DataRange.InsertRowsBelow(1);
            }

            // en el libro de ventas, asumimos que el usuario seleccionó una sola empresa (cia contab) y usamos el primer registro 
            // de la lista de items seleccionados para obtenerla ... 

            // -----------------------------------------------------------------------------------------------------------------------------
            // nótese como obtenemos el período de la consulta usando las fechas miníma y máxima del collection que filtró el usuario ... 

            DateTime fechaInicialPeriodo = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                                   Where(f => f.NombreUsuario == userName).
                                                                   Select(f => f.FechaRecepcion).
                                                                   Min();

            DateTime fechaFinalPeriodo = facturasMongoCollection.AsQueryable<FacturaSeleccionada_Consultas>().
                                                          Where(f => f.NombreUsuario == userName).
                                                          Select(f => f.FechaRecepcion).
                                                          Max();

            fechaInicialPeriodo = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1);
            fechaFinalPeriodo = new DateTime(fechaInicialPeriodo.Year, fechaInicialPeriodo.Month, 1).AddMonths(1).AddDays(-1);

            string nombreCiaContab = "";
            string rifCiaContab = "";
            string direccionCiaContab = "";

            if (query.Count() > 0)
            {
                var factura = query.FirstOrDefault();
                nombreCiaContab = factura.CiaContabNombre;
                rifCiaContab = factura.CiaContabRif;
                direccionCiaContab = factura.CiaContabDireccion;
            }

            ws.Cell("B2").Value = nombreCiaContab;
            ws.Cell("B3").Value = "Rif: " + rifCiaContab;
            ws.Cell("B4").Value = direccionCiaContab;
            ws.Cell("B6").Value = "Período: " + fechaInicialPeriodo.ToString("dd-MMM-yyyy") + " al " + fechaFinalPeriodo.ToString("dd-MMM-yyyy");

            return true;
        }



        [HttpGet]
        [Route("api/FacturasConsultaExportarExcelWebApi/DocumentoExcelDownload")]
        public HttpResponseMessage DocumentoExcelDownload(string opcionSeleccionada, string plantillaSeleccionada)
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

            string userName = Membership.GetUser().UserName;


            userName = User.Identity.Name.Replace("@", "_").Replace(".", "_");
            string fileName = "";

            switch (opcionSeleccionada)
            {
                case "LC":
                    {
                        fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/LibroCompras_" + userName + ".xlsx");
                        break;
                    }
                case "LV":
                    {
                        fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/LibroVentas_" + userName + ".xlsx");
                        break;
                    }
            }



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