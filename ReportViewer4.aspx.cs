
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
//using ContabSysNet_Web.ModelosDatos_EF;
using MongoDB.Driver;
// using MongoDB.Driver.Builders;
using ContabSysNet_Web.ModelosDatos.mongodb.consultas;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using Microsoft.Reporting.WebForms;

namespace ContabSysNet_Web
{
    public partial class ReportViewer4 : System.Web.UI.Page
    {
        // para establecer una conexión a la base de datos en mongo ... 
        // la idea de esta página es leer tablas (collections) que se han preparado en mongo 
        // y generar reportes para estos datos 
        // private MongoDB.Driver.MongoDatabase contabM_mongodb_conexion = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                string errorMessage = "";

                if (Request.QueryString["user"] == null ||
                    Request.QueryString["cia"] == null ||
                    Request.QueryString["report"] == null)
                {
                    ErrMessage_Cell.InnerHtml = "Aparentemente, los parámetros pasados a esta página no son correctos.<br /><br />" +
                        "Los parámetros que reciba esta página deben ser correctos para su ejecución pueda ser posible.";
                    return;
                }

                string userID = Request.QueryString["user"].ToString();
                int ciaContab = Convert.ToInt32(Request.QueryString["cia"].ToString());
                string report = Request.QueryString["report"].ToString();


                // --------------------------------------------------------------------------------------------------------------------------
                // establecemos una conexión a mongodb; específicamente, a la base de datos del programa contabM; allí se registrará 
                // todo en un futuro; además, ahora ya están registradas las vacaciones ... 
                string contabM_mongodb_name = System.Web.Configuration.WebConfigurationManager.AppSettings["contabM_mongodb_name"];

                var client = new MongoClient("mongodb://localhost");
                // var server = client.GetServer();
                // nótese como el nombre de la base de datos mongo (de contabM) está en el archivo webAppSettings.config; en este db se registran las vacaciones 
                var mongoDataBase = client.GetDatabase(contabM_mongodb_name);
                // --------------------------------------------------------------------------------------------------------------------------

                var mongoCollection = mongoDataBase.GetCollection<contab_cuentasYSusMovimientos>("temp_consulta_contab_cuentasYSusMovimientos");

                try
                {
                    // --------------------------------------------------------------------------------------------------------------------------
                    // solo para que ocura una exception si mongo no está iniciado ... nótese que antes, cuando establecemos mongo, no ocurre un 
                    // exception si mongo no está iniciado ...  

                    // var queryDeleteDocs = Query<contab_cuentasYSusMovimientos>.EQ(x => x.cia, -9999999);
                    var builder = Builders<contab_cuentasYSusMovimientos>.Filter;
                    var filter = builder.Eq(x => x.cia, -99999999);

                    mongoCollection.DeleteManyAsync(filter);
                }
                catch (Exception ex)
                {
                    errorMessage = "Error al intentar establecer una conexión a la base de datos (mongo) de 'contabM'; el mensaje de error es: " +
                                   ex.Message;
                    ErrMessage_Cell.InnerHtml = errorMessage;
                    return;
                }

                dbContab_Contab_Entities dbContab = new dbContab_Contab_Entities();

                switch (report)
                {
                    case "cuentasYMovimientos":
                        {
                            errorMessage = "";

                            if (Request.QueryString["desde"] == null ||
                                Request.QueryString["hasta"] == null)
                            {
                                ErrMessage_Cell.InnerHtml = "Aparentemente, los parámetros pasados a esta página no son correctos.<br /><br />" +
                                    "Los parámetros que reciba esta página deben ser correctos para su ejecución pueda ser posible.";
                                return;
                            }

                            string desde = Request.QueryString["desde"].ToString();
                            string hasta = Request.QueryString["hasta"].ToString();

                            if (!cuentasYSusMovimientos(mongoDataBase, dbContab, ciaContab, userID, desde, hasta, out errorMessage))
                            {
                                errorMessage = "Error: ha ocurrido un error al intentar obtener el reporte: " + errorMessage;
                                ErrMessage_Cell.InnerHtml = errorMessage;
                            }
                            break;
                        }
                    case "listadoAsientos_webReport":
                        {
                            errorMessage = "";

                            if (!listadoAsientos_webReport(mongoDataBase, dbContab, userID, out errorMessage))
                            {
                                errorMessage = "Error: ha ocurrido un error al intentar obtener el reporte: " + errorMessage;
                                ErrMessage_Cell.InnerHtml = errorMessage;
                            }
                            break;
                        }
                    case "reposicionCajaChica":
                        {
                            errorMessage = "";

                            if (!reposicionCajaChica(mongoDataBase, dbContab, ciaContab, userID, out errorMessage))
                            {
                                errorMessage = "Error: ha ocurrido un error al intentar obtener el reporte: " + errorMessage;
                                ErrMessage_Cell.InnerHtml = errorMessage;
                            }
                            break;
                        }
                    default:
                        {
                            errorMessage = "Error: el parámetro 'report' indicado a esta página no corresponde a alguno de los establecidos.";
                            ErrMessage_Cell.InnerHtml = errorMessage;

                            break;
                        }
                }
            }
        }

        private bool cuentasYSusMovimientos(IMongoDatabase mongoDatabase, dbContab_Contab_Entities dbContab,
                                            int ciaContab, string user, string desde, string hasta, out string errorMessage)
        {

            errorMessage = "";

            var monedasList = dbContab.Monedas.ToList();

            var mongoCollection = mongoDatabase.GetCollection<contab_cuentasYSusMovimientos>("temp_consulta_contab_cuentasYSusMovimientos");
            var mongoCollection2 = mongoDatabase.GetCollection<contab_cuentasYMovimientos_movimientos>("temp_consulta_contab_cuentasYSusMovimientos2");

            //var mongoQuery = Query<contab_cuentasYSusMovimientos>.EQ(x => x.user, user);
            //MongoCursor<contab_cuentasYSusMovimientos> mongoCursor = mongoCollection.Find(mongoQuery);

            var query = mongoCollection.AsQueryable<contab_cuentasYSusMovimientos>().Where(m => m.user == user); 

            // var items = query.ToList();

            List<contab_cuentasYSusMovimientos_report> myReportList = new List<contab_cuentasYSusMovimientos_report>();
            contab_cuentasYSusMovimientos_report reportItem;

            int numero = 0;
            int cantidadRegistros = 0;

            foreach (var item in query)
            {
                numero = 0;
                reportItem = new contab_cuentasYSusMovimientos_report();

                reportItem.numero = numero;
                reportItem.moneda = monedasList.Where(m => m.Moneda1 == item.monedaID).Select(m => m.Descripcion).FirstOrDefault();
                reportItem.cuentaContable = item.cuentaContable;
                reportItem.nombreCuentaContable = item.nombreCuentaContable;
                reportItem.fecha = null;
                reportItem.numeroAsiento = null;
                reportItem.simboloMonedaOriginal = "";
                reportItem.descripcion = "Saldo inicial del período";
                reportItem.tipoAsiento = "";
                reportItem.referencia = "";
                reportItem.asientoTipoCierreAnualFlag = false;
                reportItem.saldoInicial = item.saldoInicial;
                reportItem.debe = 0;
                reportItem.haber = 0;
                reportItem.saldoFinal = item.saldoInicial;

                myReportList.Add(reportItem);
                cantidadRegistros++;

                // para cada cuenta, leemos sus movimientos 
                //var mongoQuery2 = Query.And(
                //    Query<contab_cuentasYMovimientos_movimientos>.EQ(x => x.registroCuentaContableID, item._id),
                //    Query<contab_cuentasYMovimientos_movimientos>.EQ(x => x.user, user));
                //MongoCursor<contab_cuentasYMovimientos_movimientos> mongoCursor2 = mongoCollection2.Find(mongoQuery2);

                //var items = mongoCursor.ToList();

                var query2 = mongoCollection2.AsQueryable<contab_cuentasYMovimientos_movimientos>()
                            .Where(d => d.registroCuentaContableID == item._id && d.user == user); 


                foreach (var partida in query2)
                {
                    numero++;

                    reportItem = new contab_cuentasYSusMovimientos_report();

                    reportItem.numero = numero;
                    reportItem.moneda = monedasList.Where(m => m.Moneda1 == item.monedaID).Select(m => m.Descripcion).FirstOrDefault();
                    reportItem.cuentaContable = item.cuentaContable;
                    reportItem.nombreCuentaContable = item.nombreCuentaContable;
                    reportItem.fecha = partida.fecha;
                    reportItem.numeroAsiento = partida.numeroAsiento;
                    reportItem.simboloMonedaOriginal = partida.simboloMonedaOriginal;
                    reportItem.descripcion = partida.descripcion;
                    reportItem.tipoAsiento = partida.tipoAsiento;
                    reportItem.referencia = partida.referencia;
                    reportItem.asientoTipoCierreAnualFlag = partida.asientoTipoCierreAnualFlag;
                    reportItem.saldoInicial = 0;
                    reportItem.debe = partida.debe;
                    reportItem.haber = partida.haber;
                    reportItem.saldoFinal = partida.debe - partida.haber;

                    myReportList.Add(reportItem);
                    cantidadRegistros++;

                }
            }

            if (cantidadRegistros == 0)
            {
                errorMessage = "No existe información para mostrar el reporte " +
                    "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                    "filtro y seleccionado información aún.";
                return false;
            }


            ReportViewer1.LocalReport.ReportPath = "contabm/reports/contab_cuentasYSusMovimientos.rdlc";

            ReportDataSource myReportDataSource = new ReportDataSource();

            myReportDataSource.Name = "DataSet1";
            myReportDataSource.Value = myReportList;

            ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);


            //ReportParameter FechaInicialPeriodo_ReportParameter = new
            //                                ReportParameter("FechaInicialPeriodo", dFechaInicialPeriodo.ToString());

            //ReportParameter FechaFinalPeriodo_ReportParameter = new
            //    ReportParameter("FechaFinalPeriodo", dFechaFinalPeriodo.ToString());

            string nombreCiaContab = dbContab.Companias.Where(x => x.Numero == ciaContab).Select(x => x.Nombre).FirstOrDefault();

            ReportParameter[] MyReportParameters = {
                                                       new ReportParameter("nombreCiaContab", nombreCiaContab),
                                                       new ReportParameter("desde", desde),
                                                       new ReportParameter("hasta", hasta)
                                                   };

            ReportViewer1.LocalReport.SetParameters(MyReportParameters);


            ReportViewer1.LocalReport.Refresh();


            return true;
        }


        private bool listadoAsientos_webReport(IMongoDatabase mongoDatabase, dbContab_Contab_Entities dbContab, string user, out string errorMessage)
        {
            errorMessage = "";

            var mongoCollection = mongoDatabase.GetCollection<contab_asientosContables_webReport>("temp_contab_asientos_webReport");
            var mongoCollection_config = mongoDatabase.GetCollection<contab_asientosContables_webReport_config>("temp_contab_asientos_webReport_config");

            //var mongoQuery = Query<contab_asientosContables_webReport>.EQ(x => x.user, user);
            //MongoCursor<contab_asientosContables_webReport> mongoCursor = mongoCollection.Find(mongoQuery);

            var mongoCursor = mongoCollection.AsQueryable<contab_asientosContables_webReport>().Where(x => x.user == user); 

            var items = mongoCursor.ToList();

            if (items.Count() == 0)
            {
                errorMessage = "No existe información para mostrar el reporte " +
                    "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                    "filtro y seleccionado información aún.";
                return false;
            }

            // leemos también los datos de configuración del reporte (metadata) 
            //var mongoQuery_config = Query<contab_asientosContables_webReport_config>.EQ(x => x.user, user);
            //MongoCursor<contab_asientosContables_webReport_config> mongoCursor_config = mongoCollection_config.Find(mongoQuery_config);

            // var reportConfig = mongoCollection_config.FindOne(mongoQuery_config);
            var reportConfig = mongoCollection_config.AsQueryable<contab_asientosContables_webReport_config>().Where(d => d.user == user).FirstOrDefault(); 

            if (reportConfig == null)
            {
                errorMessage = "Error inesperado: no hemos podido leer un registro de configuración (parámetros) para esta ejecución del reporte.<br />" +
                    "Debe existir un registro de configuración que contenga los parámetros de ejecución del reporte.<br />" +
                    "Probablemente el reporte pueda ser obtenido si intenta su ejecución nuevamente.";
                return false;
            }

            ReportViewer1.LocalReport.ReportPath = "contabm/reports/contab_asientosContables_webReport.rdlc";

            ReportDataSource myReportDataSource = new ReportDataSource();

            myReportDataSource.Name = "DataSet1";
            myReportDataSource.Value = items;

            ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

            // nótese que el valor 'fecha' puede venir en nulls ... 
            ReportParameter[] MyReportParameters = {
                                                       new ReportParameter("desde", reportConfig.reportConfig.desde.ToString("dd-MMM-yyyy")),
                                                       new ReportParameter("hasta", reportConfig.reportConfig.hasta.ToString("dd-MMM-yyyy")),
                                                       new ReportParameter("fecha", reportConfig.reportConfig.fecha.HasValue ? reportConfig.reportConfig.fecha.Value.ToString("dd-MMM-yyyy") : ""),
                                                       new ReportParameter("saltoPaginaPorFecha", reportConfig.reportConfig.saltoPaginaPorFecha.ToString()),
                                                       new ReportParameter("titulo", reportConfig.reportConfig.titulo),
                                                       new ReportParameter("ciaNombre", reportConfig.reportConfig.ciaNombre)
                                                   };

            ReportViewer1.LocalReport.SetParameters(MyReportParameters);

            ReportViewer1.LocalReport.Refresh();

            return true;
        }


        private bool reposicionCajaChica(IMongoDatabase mongoDatabase, dbContab_Contab_Entities dbContab, int ciaContab, string user, out string errorMessage)
        {
            // TODO: vamos a modificar contabm para que, al grabar cada vez la reposición, la registremos en una tabla "temp", lista para ser 
            // impresa. De esa forma, estará disponible para leerla aquí y obtener el reporte. 
            // lo que nos faltará por hacer aquí, es agregar el type para poder leer estos registros.
            errorMessage = "";

            var mongoCollection = mongoDatabase.GetCollection<bancos_cajaChica_reposiciones_webReport>("temp_bancos_cajaChica_webReport");
            
            //var mongoQuery = Query<bancos_cajaChica_reposiciones_webReport>.EQ(x => x.user, user);
            //MongoCursor<bancos_cajaChica_reposiciones_webReport> mongoCursor = mongoCollection.Find(mongoQuery);

            var mongoCursor = mongoCollection.AsQueryable<bancos_cajaChica_reposiciones_webReport>().Where(x => x.user == user); 

            List<bancos_cajaChica_reposiciones_webReport> items = mongoCursor.ToList<bancos_cajaChica_reposiciones_webReport>();
            var items2 = new List<bancos_cajaChica_reposiciones_gastos_webReport>(); 

            foreach(var gasto in items[0].gastos)
            {
                items2.Add(gasto); 
            }

            if (items.Count == 0)
            {
                errorMessage = "No existe información para mostrar el reporte " +
                    "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                    "filtro y seleccionado información aún.";
                return false;
            }

            ReportViewer1.LocalReport.ReportPath = "contabm/reports/bancos_cajaChica_reposiciones_webReport.rdlc";

            ReportDataSource myReportDataSource = new ReportDataSource();
            ReportDataSource myReportDataSource2 = new ReportDataSource();

            myReportDataSource.Name = "DataSet1";
            myReportDataSource.Value = items;

            ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

            myReportDataSource2.Name = "DataSet2";
            myReportDataSource2.Value = items2;

            ReportViewer1.LocalReport.DataSources.Add(myReportDataSource2);

            // nótese que el valor 'fecha' puede venir en nulls ... 

            string nombreCiaContab = dbContab.Companias.Where(x => x.Numero == ciaContab).Select(x => x.Nombre).FirstOrDefault();

            ReportParameter[] MyReportParameters = {
                                                       new ReportParameter("fecha", new DateTime().ToString("dd-MMM-yyyy")),
                                                       new ReportParameter("ciaNombre", nombreCiaContab)
                                                   };

            ReportViewer1.LocalReport.SetParameters(MyReportParameters);

            ReportViewer1.LocalReport.Refresh();

            return true;
        }
    }
}