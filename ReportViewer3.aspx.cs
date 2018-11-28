using System;
using System.Web.Security;
using Microsoft.Reporting.WebForms;
using System.Linq; 

// namespace para el modelo de datos (EF) 
using ContabSysNet_Web.ModelosDatos_EF;
// using ContabSysNet_Web.Nomina.Empleados;
using System.Collections.Generic;
using System.Web.Configuration;
using System.Data.SqlClient;
using System.Data;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using ContabSysNet_Web.Bancos.ConsultasBancos.MovimientosBancarios;
using ContabSysNet_Web.Bancos.ConsultasFacturas.Pagos;

namespace ContabSysNetWeb
{
    public partial class ReportViewer3 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            if (!Page.IsPostBack)
            {

                switch (Request.QueryString["rpt"].ToString())
                {
                    case "activosFijosDepreciacion":
                        {
                            if (!User.Identity.IsAuthenticated)
                            {
                                FormsAuthentication.SignOut();
                                return;
                            }

                            if (Request.QueryString["tit"] == null ||
                                Request.QueryString["subtit"] == null ||
                                Request.QueryString["mes"] == null ||
                                Request.QueryString["ano"] == null ||
                                Request.QueryString["soloTotales"] == null)
                            {
                                ErrMessage_Cell.InnerHtml = "Aparentemente, Ud. no ha seleccionado aún información para la obtención de este reporte.<br /><br />" +
                                    "Probablemente, Ud. no ha definido y aplicado un filtro que permita seleccionar información apropiada para la obtención " +
                                    "de este reporte.";
                                break;
                            }


                            // nótese como mantenemos los items mes y año como texto; no necesitamos que sean números en el reporte ... 
                            string titutlo = Request.QueryString["tit"].ToString();
                            string subTitulo = Request.QueryString["subtit"].ToString();
                            string mes = Request.QueryString["mes"].ToString();
                            string ano = Request.QueryString["ano"].ToString();
                            bool soloTotales = Convert.ToBoolean(Request.QueryString["soloTotales"].ToString());

                            // string que muestra el período (en meses) que va desde el inicio del año fiscal hasta el mes de la consulta; ej: Mar-Ago ... 

                            string periodo = "";

                            if (Request.QueryString["periodo"] != null)
                                periodo = Request.QueryString["periodo"].ToString();


                            string connectionString = WebConfigurationManager.ConnectionStrings["dbContabConnectionString"].ConnectionString;
                            string query = "Select * From vtTempActivosFijos_ConsultaDepreciacion Where NombreUsuario = @NombreUsuario";

                            SqlCommand sqlCommand = new SqlCommand(query);
                            sqlCommand.Parameters.AddWithValue("@NombreUsuario", User.Identity.Name);

                            SqlConnection sqlConnnection = new SqlConnection(connectionString);

                            sqlCommand.Connection = sqlConnnection;

                            SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);

                            DataSet dataSet = new DataSet();

                            try
                            {
                                sqlConnnection.Open();
                                sqlDataAdapter.Fill(dataSet, "vtTempActivosFijos_ConsultaDepreciacion");

                                if (dataSet.Tables[0].Rows.Count == 0)
                                {
                                    ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
                                    return;
                                }
                            }
                            catch (Exception ex)
                            {
                                string errorMessage = ex.Message;
                                if (ex.InnerException != null)
                                    errorMessage += "<br /><br />" + ex.InnerException.Message;

                                ErrMessage_Cell.InnerHtml = "Hemos obtenido un error al intentar efectuar una operación de base de datos. <br />" +
                                    "El mensaje específico del error es: <br /><br />" +
                                    errorMessage;
                                return;
                            }
                            finally
                            {
                                sqlConnnection.Close();
                            }


                            this.ReportViewer1.LocalReport.ReportPath = "ActivosFijos/Consultas/DepreciacionMensual/ConsultaDepreciacion.rdlc";

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "DataSet1";
                            myReportDataSource.Value = dataSet.Tables["vtTempActivosFijos_ConsultaDepreciacion"];

                            this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            this.ReportViewer1.LocalReport.Refresh();

                            List<ReportParameter> reportParameterCollection = new List<ReportParameter>();

                            reportParameterCollection.Add(new ReportParameter("tituloReporte", titutlo));
                            reportParameterCollection.Add(new ReportParameter("subTituloReporte", subTitulo));
                            reportParameterCollection.Add(new ReportParameter("mes", mes));
                            reportParameterCollection.Add(new ReportParameter("ano", ano));
                            reportParameterCollection.Add(new ReportParameter("soloTotales", soloTotales.ToString()));
                            reportParameterCollection.Add(new ReportParameter("periodo", periodo));

                            this.ReportViewer1.LocalReport.SetParameters(reportParameterCollection);

                            break;
                        }


                    case "movimientosbancarios":
                        {
                            if (!User.Identity.IsAuthenticated)
                            {
                                FormsAuthentication.SignOut();
                                return;
                            }

                            if (Request.QueryString["tit"] == null ||
                                Request.QueryString["subtit"] == null ||
                                Request.QueryString["filter"] == null)
                            {
                                ErrMessage_Cell.InnerHtml = "Aparentemente, Ud. no ha seleccionado aún información para la obtención de este reporte.<br /><br />" +
                                    "Probablemente, Ud. no ha definido y aplicado un filtro que permita seleccionar información apropiada para la obtención " +
                                    "de este reporte.";
                                break;
                            }

                            string titutlo = Request.QueryString["tit"].ToString();
                            string subTitulo = Request.QueryString["subtit"].ToString();
                            string filter = Request.QueryString["filter"].ToString();


                            BancosEntities bancosContext = new BancosEntities();

                            var query = bancosContext.MovimientosBancarios.
                                Include("Chequera").
                                Include("Chequera.CuentasBancaria").
                                Include("Chequera.CuentasBancaria.Compania").
                                Include("Chequera.CuentasBancaria.Moneda1").
                                Include("Chequera.CuentasBancaria.Agencia1").
                                Include("Chequera.CuentasBancaria.Agencia1.Banco1").
                                Where(filter);

                            if (query.Count() == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte " +
                                    "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                    "filtro y seleccionado información aún.";
                                return;
                            }

                            // ahora preparamos una lista para usarla como DataSource del report ... 

                            List<Bancos_Report_ConsultaMovimientoBancario> myList = new List<Bancos_Report_ConsultaMovimientoBancario>();
                            Bancos_Report_ConsultaMovimientoBancario infoMovimientoBancario;

                            foreach (MovimientosBancario movimiento in query)
                            {
                                infoMovimientoBancario = new Bancos_Report_ConsultaMovimientoBancario();

                                infoMovimientoBancario.NombreMoneda = movimiento.Chequera.CuentasBancaria.Moneda1.Descripcion;
                                infoMovimientoBancario.NombreCiaContab = movimiento.Chequera.CuentasBancaria.Compania.Nombre;
                                infoMovimientoBancario.Transaccion = movimiento.Transaccion;
                                infoMovimientoBancario.Tipo = movimiento.Tipo;
                                infoMovimientoBancario.Fecha = movimiento.Fecha;
                                infoMovimientoBancario.NombreBanco = movimiento.Chequera.CuentasBancaria.Agencia1.Banco1.Nombre;
                                infoMovimientoBancario.CuentaBancaria = movimiento.Chequera.CuentasBancaria.CuentaBancaria;
                                infoMovimientoBancario.Beneficiario = movimiento.Beneficiario;
                                infoMovimientoBancario.Concepto = movimiento.Concepto;
                                infoMovimientoBancario.Monto = movimiento.Monto;
                                infoMovimientoBancario.FechaEntregado = movimiento.FechaEntregado;

                                myList.Add(infoMovimientoBancario);
                            }


                            this.ReportViewer1.LocalReport.ReportPath = "Bancos/ConsultasBancos/MovimientosBancarios/ConsultaMovimientosBancarios.rdlc";

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "DataSet1";
                            myReportDataSource.Value = myList;

                            this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            this.ReportViewer1.LocalReport.Refresh();

                            ReportParameter titulo_ReportParameter = new ReportParameter("tituloReporte", titutlo);
                            ReportParameter subTitulo_ReportParameter = new ReportParameter("subTituloReporte", subTitulo);

                            ReportParameter[] MyReportParameters = { titulo_ReportParameter, subTitulo_ReportParameter };

                            this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                            break;
                        }

                    case "pagos":
                        {
                            if (!User.Identity.IsAuthenticated)
                            {
                                FormsAuthentication.SignOut();
                                return;
                            }

                            if (Request.QueryString["tit"] == null ||
                                Request.QueryString["subtit"] == null ||
                                Request.QueryString["filter"] == null)
                            {
                                ErrMessage_Cell.InnerHtml = "Aparentemente, Ud. no ha seleccionado aún información para la obtención de este reporte.<br /><br />" +
                                    "Probablemente, Ud. no ha definido y aplicado un filtro que permita seleccionar información apropiada para la obtención " +
                                    "de este reporte.";
                                break;
                            }

                            string titutlo = Request.QueryString["tit"].ToString();
                            string subTitulo = Request.QueryString["subtit"].ToString();
                            string filter = Request.QueryString["filter"].ToString();


                            BancosEntities bancosContext = new BancosEntities();

                            var query = bancosContext.Pagos.
                                        Include("Proveedore").
                                        Include("Compania").
                                        Include("Moneda1").
                                        Where(filter);

                            if (query.Count() == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte " +
                                    "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                    "filtro y seleccionado información aún.";
                                return;
                            }

                            // ahora preparamos una lista para usarla como DataSource del report ... 

                            List<Bancos_Report_ConsultaPago> myList = new List<Bancos_Report_ConsultaPago>();
                            Bancos_Report_ConsultaPago infoPago;

                            foreach (Pago pago in query)
                            {
                                infoPago = new Bancos_Report_ConsultaPago();

                                infoPago.NombreMoneda = pago.Moneda1.Descripcion;
                                infoPago.NombreCiaContab = pago.Compania.Nombre;
                                infoPago.Fecha = pago.Fecha;
                                infoPago.NombreCompania = pago.Proveedore.Abreviatura;
                                infoPago.NumeroPago = pago.NumeroPago;
                                infoPago.MiSu = pago.MiSuFlag == 1 ? "Mi" : "Su";
                                infoPago.Concepto = pago.Concepto;
                                infoPago.Monto = pago.Monto != null ? pago.Monto.Value : 0;

                                myList.Add(infoPago);
                            }


                            this.ReportViewer1.LocalReport.ReportPath = "Bancos/Consultas facturas/Pagos/ConsultaPagos.rdlc";

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "DataSet1";
                            myReportDataSource.Value = myList;

                            this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            this.ReportViewer1.LocalReport.Refresh();

                            ReportParameter titulo_ReportParameter = new ReportParameter("tituloReporte", titutlo);
                            ReportParameter subTitulo_ReportParameter = new ReportParameter("subTituloReporte", subTitulo);

                            ReportParameter[] MyReportParameters = { titulo_ReportParameter, subTitulo_ReportParameter };

                            this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                            break;
                        }
                }
            }
        }
    }
}
