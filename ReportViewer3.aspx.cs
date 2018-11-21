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
using ContabSysNet_Web.Bancos.ConciliacionBancaria;

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

                    case "repConcBancosMovBanco":
                        {
                            if (!User.Identity.IsAuthenticated)
                            {
                                FormsAuthentication.SignOut();
                                return;
                            }


                            if (Request.QueryString["concID"] == null ||
                                Request.QueryString["criterio"] == null ||
                                Request.QueryString["d"] == null ||
                                Request.QueryString["h"] == null)
                            {
                                ErrMessage_Cell.InnerHtml = "Los parametros esperados por este proceso no están completos.<br /><br />Por favor revise.";
                                break;
                            }

                            int conciliacionID = Convert.ToInt32(Request.QueryString["concID"].ToString());
                            string criterioSeleccion = Request.QueryString["criterio"].ToString();
                            DateTime desde = Convert.ToDateTime(Request.QueryString["d"].ToString());
                            DateTime hasta = Convert.ToDateTime(Request.QueryString["h"].ToString());

                            // -----------------------------------------------------------------------------------------------
                            // leemos los registros y los agregamos a una lista 

                            BancosEntities db = new BancosEntities();

                            var query = db.MovimientosDesdeBancos.Include("ConciliacionesBancaria").
                                                                  Include("ConciliacionesBancaria.CuentasBancaria").
                                                                  Include("ConciliacionesBancaria.CuentasBancaria.Agencia1").
                                                                  Include("ConciliacionesBancaria.CuentasBancaria.Agencia1.Banco1").
                                                                  Include("ConciliacionesBancaria.CuentasBancaria.Moneda1").
                                                                  Include("ConciliacionesBancaria.CuentasBancaria.Compania").
                                                                  Include("MovimientosBancarios").
                                                                  Include("dAsientos").
                                                                  Include("dAsientos.Asiento").
                                                                  Where(m => m.ConciliacionBancariaID == conciliacionID);

                            if (query.Count() == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte " +
                                    "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                    "filtro y seleccionado información aún.";
                                return;
                            }

                            // aplicamos el criterio ... 

                            switch (criterioSeleccion)
                            {
                                case "0":
                                    // todos 
                                    break;
                                case "1":
                                    // con movimiento bancario encontrado 
                                    query = query.Where(m => m.MovimientosBancarios.Any());
                                    break;
                                case "2":
                                    // con movimiento contable encontrado 
                                    query = query.Where(m => m.dAsientos.Any());
                                    break;
                                case "3":
                                    // con ambos movimientos (bancario y contable) encontrados
                                    query = query.Where(m => m.MovimientosBancarios.Any() && m.dAsientos.Any());
                                    break;
                            }

                            // ahora preparamos una lista para usarla como DataSource del report ... 

                            List<ConciliacionBancaria_Report_ConsultaMovBanco> myList = new List<ConciliacionBancaria_Report_ConsultaMovBanco>();
                            ConciliacionBancaria_Report_ConsultaMovBanco movBanco;

                            foreach (MovimientosDesdeBanco m in query)
                            {
                                movBanco = new ConciliacionBancaria_Report_ConsultaMovBanco();

                                movBanco.NombreMoneda = m.ConciliacionesBancaria.CuentasBancaria.Moneda1.Simbolo;
                                movBanco.NombreCiaContab = m.ConciliacionesBancaria.CuentasBancaria.Compania.Nombre;
                                movBanco.NombreCuentaBancaria = m.ConciliacionesBancaria.CuentasBancaria.CuentaBancaria + " (" + m.ConciliacionesBancaria.CuentasBancaria.Agencia1.Banco1.Nombre + ")";
                                movBanco.Fecha = m.Fecha;
                                movBanco.Descripcion = m.Descripcion;
                                movBanco.Referencia = m.Referencia;
                                movBanco.Monto = m.Monto;
                                movBanco.MovimientoBancarioReferencia = m.MovimientosBancarios.FirstOrDefault() != null ?
                                                                        m.MovimientosBancarios.FirstOrDefault().Transaccion.ToString() :
                                                                        "";
                                movBanco.MovimientoContableReferencia = m.dAsientos.FirstOrDefault() != null ?
                                                                        m.dAsientos.FirstOrDefault().Asiento.Numero.ToString() + "-" +
                                                                        m.dAsientos.FirstOrDefault().Partida.ToString() :
                                                                        "";

                                myList.Add(movBanco);
                            }


                            ReportViewer1.LocalReport.ReportPath = "Bancos/ConciliacionBancaria/MovimientosDesdeElBanco.rdlc";

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "DataSet1";
                            myReportDataSource.Value = myList;

                            ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            ReportViewer1.LocalReport.Refresh();

                            ReportParameter desde_ReportParameter = new ReportParameter("Desde", desde.ToString());
                            ReportParameter hasta_ReportParameter = new ReportParameter("Hasta", hasta.ToString());

                            ReportParameter[] MyReportParameters = { desde_ReportParameter, hasta_ReportParameter, };

                            ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                            break;
                        }

                    case "repConcBancosMovBancarios":
                        {
                            if (!User.Identity.IsAuthenticated)
                            {
                                FormsAuthentication.SignOut();
                                return;
                            }

                            if (Request.QueryString["concID"] == null ||
                                Request.QueryString["criterio"] == null ||
                                Request.QueryString["d"] == null ||
                                Request.QueryString["h"] == null)
                            {
                                ErrMessage_Cell.InnerHtml = "Los parametros esperados por este proceso no están completos.<br /><br />Por favor revise.";
                                break;
                            }

                            int conciliacionID = Convert.ToInt32(Request.QueryString["concID"].ToString());
                            string criterioSeleccion = Request.QueryString["criterio"].ToString();
                            DateTime desde = Convert.ToDateTime(Request.QueryString["d"].ToString());
                            DateTime hasta = Convert.ToDateTime(Request.QueryString["h"].ToString());

                            // lo primero que hacemos es obtener la conciliación, para poder establecer los parámetros (filtro) de busqueda de los 
                            // movimientos bancarios 

                            BancosEntities db = new BancosEntities();

                            ConciliacionesBancaria conciliacion = db.ConciliacionesBancarias.Where(c => c.ID == conciliacionID).FirstOrDefault();

                            if (conciliacion == null)
                            {
                                ErrMessage_Cell.InnerHtml = "Error inesperado: no hemos podido leer los criterios de conciliación bancaria en la base de datos.<br /><br />Por favor seleccione una conciliación bancaria (criterios de conciliación) e intente ejecutar nuevamente este proceso.";
                                break;
                            }

                            // -----------------------------------------------------------------------------------------------
                            // leemos los registros y los agregamos a una lista 

                            var query = db.MovimientosBancarios.Include("Chequera").
                                                                  Include("Chequera.CuentasBancaria").
                                                                  Include("Chequera.CuentasBancaria.Moneda1").
                                                                  Include("Chequera.CuentasBancaria.Compania").
                                                                  Where(m => m.Chequera.CuentasBancaria.CuentaInterna == conciliacion.CuentaBancaria &&
                                                                             m.Fecha >= desde && m.Fecha <= hasta);

                            if (query.Count() == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte " +
                                    "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                    "filtro y seleccionado información aún.";
                                return;
                            }

                            // aplicamos el criterio ... 

                            switch (criterioSeleccion)
                            {
                                case "0":
                                    // todos 
                                    break;
                                case "1":
                                    // encontrados
                                    query = query.Where(m => m.ConciliacionMovimientoID != null);
                                    break;
                                case "2":
                                    // no encontrados
                                    query = query.Where(m => m.ConciliacionMovimientoID == null);
                                    break;
                            }

                            // ahora preparamos una lista para usarla como DataSource del report ... 

                            List<ConciliacionBancaria_Report_ConsultaMovBancario> myList = new List<ConciliacionBancaria_Report_ConsultaMovBancario>();
                            ConciliacionBancaria_Report_ConsultaMovBancario movBanco;

                            foreach (MovimientosBancario m in query)
                            {
                                movBanco = new ConciliacionBancaria_Report_ConsultaMovBancario();

                                movBanco.NombreMoneda = m.Chequera.CuentasBancaria.Moneda1.Simbolo;
                                movBanco.NombreCiaContab = m.Chequera.CuentasBancaria.Compania.Nombre;
                                movBanco.NombreCuentaBancaria = m.Chequera.CuentasBancaria.CuentaBancaria + " (" + m.Chequera.CuentasBancaria.Agencia1.Banco1.Nombre + ")";
                                movBanco.Transaccion = m.Transaccion;
                                movBanco.Fecha = m.Fecha;
                                movBanco.Tipo = m.Tipo;
                                movBanco.Descripcion = m.Concepto;
                                movBanco.Monto = m.Monto;
                                movBanco.ConciliacionMovimientoID = m.ConciliacionMovimientoID;

                                myList.Add(movBanco);
                            }


                            ReportViewer1.LocalReport.ReportPath = "Bancos/ConciliacionBancaria/MovimientosBancarios.rdlc";

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "DataSet1";
                            myReportDataSource.Value = myList;

                            ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            ReportViewer1.LocalReport.Refresh();

                            ReportParameter desde_ReportParameter = new ReportParameter("Desde", desde.ToString());
                            ReportParameter hasta_ReportParameter = new ReportParameter("Hasta", hasta.ToString());

                            ReportParameter[] MyReportParameters = { desde_ReportParameter, hasta_ReportParameter, };

                            ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                            break;
                        }

                    case "repConcBancosMovContables":
                        {
                            if (!User.Identity.IsAuthenticated)
                            {
                                FormsAuthentication.SignOut();
                                return;
                            }

                            if (Request.QueryString["concID"] == null ||
                                Request.QueryString["criterio"] == null ||
                                Request.QueryString["d"] == null ||
                                Request.QueryString["h"] == null)
                            {
                                ErrMessage_Cell.InnerHtml = "Los parametros esperados por este proceso no están completos.<br /><br />Por favor revise.";
                                break;
                            }

                            int conciliacionID = Convert.ToInt32(Request.QueryString["concID"].ToString());
                            string criterioSeleccion = Request.QueryString["criterio"].ToString();
                            DateTime desde = Convert.ToDateTime(Request.QueryString["d"].ToString());
                            DateTime hasta = Convert.ToDateTime(Request.QueryString["h"].ToString());

                            // lo primero que hacemos es obtener la conciliación, para poder establecer los parámetros (filtro) de busqueda de los 
                            // movimientos bancarios 

                            BancosEntities db = new BancosEntities();

                            ConciliacionesBancaria conciliacion = db.ConciliacionesBancarias.Where(c => c.ID == conciliacionID).FirstOrDefault();

                            if (conciliacion == null)
                            {
                                ErrMessage_Cell.InnerHtml = "Error inesperado: no hemos podido leer los criterios de conciliación bancaria en la base de datos." +
                                    "<br /><br />Por favor seleccione una conciliación bancaria (criterios de conciliación) e intente ejecutar nuevamente este proceso.";
                                break;
                            }

                            // -----------------------------------------------------------------------------------------------
                            // leemos los registros y los agregamos a una lista 

                            var query = db.dAsientos.Include("Asiento").
                                                     Include("Asiento.Moneda1").
                                                     Include("Asiento.Compania").
                                                     Include("CuentasContable").
                                                     Where(m => m.CuentaContableID == conciliacion.CuentaContable &&
                                                                m.Asiento.Fecha >= desde && m.Asiento.Fecha <= hasta &&
                                                                m.Asiento.Moneda == conciliacion.CuentasBancaria.Moneda);

                            if (query.Count() == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte " +
                                    "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                    "filtro y seleccionado información aún.";
                                return;
                            }

                            // aplicamos el criterio ... 

                            switch (criterioSeleccion)
                            {
                                case "0":
                                    // todos 
                                    break;
                                case "1":
                                    // encontrados
                                    query = query.Where(m => m.ConciliacionMovimientoID != null);
                                    break;
                                case "2":
                                    // no encontrados
                                    query = query.Where(m => m.ConciliacionMovimientoID == null);
                                    break;
                            }

                            // ahora preparamos una lista para usarla como DataSource del report ... 

                            List<ConciliacionBancaria_Report_ConsultaMovContable> myList = new List<ConciliacionBancaria_Report_ConsultaMovContable>();
                            ConciliacionBancaria_Report_ConsultaMovContable movContab;

                            foreach (dAsiento m in query)
                            {
                                movContab = new ConciliacionBancaria_Report_ConsultaMovContable();

                                movContab.NombreMoneda = m.Asiento.Moneda1.Simbolo;
                                movContab.NombreCiaContab = m.Asiento.Compania.Nombre;
                                movContab.NombreCuentaContable = m.CuentasContable.CuentaEditada + " (" + m.CuentasContable.Descripcion + ")";
                                movContab.Fecha = m.Asiento.Fecha;
                                movContab.Numero = m.Asiento.Numero.ToString() + "-" + m.Partida.ToString();
                                movContab.Descripcion = m.Descripcion;
                                movContab.Referencia = m.Referencia;
                                movContab.Monto = m.Debe - m.Haber;
                                movContab.ConciliacionMovimientoID = m.ConciliacionMovimientoID;

                                myList.Add(movContab);
                            }


                            ReportViewer1.LocalReport.ReportPath = "Bancos/ConciliacionBancaria/MovimientosContables.rdlc";

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "DataSet1";
                            myReportDataSource.Value = myList;

                            ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            ReportViewer1.LocalReport.Refresh();

                            ReportParameter desde_ReportParameter = new ReportParameter("Desde", desde.ToString());
                            ReportParameter hasta_ReportParameter = new ReportParameter("Hasta", hasta.ToString());

                            ReportParameter[] MyReportParameters = { desde_ReportParameter, hasta_ReportParameter, };

                            ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                            break;
                        }
                }
            }
        }
    }
}
