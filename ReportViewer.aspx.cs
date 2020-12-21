using System;
using System.Linq;
using System.Web.Security;
using Microsoft.Reporting.WebForms;

using ContabSysNet_Web.old_app_code;
using ContabSysNet_Web.report_datasets.Bancos;
using ContabSysNet_Web.report_datasets.Bancos.ReporteDisponibilidad_DataSetTableAdapters;
using ContabSysNet_Web.report_datasets.Bancos.ReporteConciliacion_MovBanco_DataSetTableAdapters;
using ContabSysNet_Web.report_datasets.Bancos.ReporteFacturas_DataSetTableAdapters;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using ContabSysNet_Web.Contab.Consultas_contables.Cuentas_y_movimientos;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Configuration;
using ContabSysNet_Web.Contab.Consultas_contables.Cuentas_y_movimientos.ReporteMayorGeneral_DataSetTableAdapters;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using ContabSysNet_Web.Bancos.Consultas_facturas.Facturas;
using ContabSysNetWeb.Contab.Consultas_contables.Centros_de_costo;
using ContabSysNetWeb.Contab.Consultas_contables.BalanceGeneral;
using System.Data.Objects;
using ContabSysNet_Web.Bancos.Consultas_facturas.VencimientoFacturas;
using System.IO;
using ContabSysNet_Web.Clases;
using System.Text;
using ContabSysNetWeb.Contab.Consultas_contables.BalanceComprobacion;
using ContabSysNet_Web.Bancos.Disponibilidad_en_bancos.Disponibilidad;
using ContabSysNet_Web.ModelosDatos_EF.code_first.contab;

namespace ContabSysNetWeb
{
    public partial class ReportViewer : System.Web.UI.Page
    {
        private class AsientoContable_Report_Item
        {
            public string NombreMoneda { get; set; }
            public string NombreCiaContab { get; set; }
            public DateTime Fecha { get; set; }
            public int NumeroAutomatico { get; set; }
            public short Numero { get; set; }
            public string NombreTipo { get; set; }
            public string SimboloMonedaOriginal { get; set; }
            public short Partida { get; set; }
            public string CuentaContableEditada { get; set; }
            public string NombreCuentaContable { get; set; }
            public string DescripcionPartida { get; set; }
            public string ReferenciaPartida { get; set; }

            public decimal Debe { get; set; }
            public decimal Haber { get; set; }
            public string ProvieneDe { get; set; }
            public string DescripcionAsiento { get; set; }
        }
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated) {
                FormsAuthentication.SignOut();
                return;
            }

            if (!Page.IsPostBack)
            {
                switch (Request.QueryString["rpt"])
                {

                    case "disponibilidad":
                        {
                            string dosCols = Request.QueryString["dosCols"] != null ? Request.QueryString["dosCols"].ToString() : "no"; 

                            switch (dosCols)
                            {
                                case "no":          // versión 'original' del reporte; mostramos una sola columna; los créditos son negativos ... 
                                    {
                                        ReporteDisponibilidad_DataSet MyReportDataSet = new ReporteDisponibilidad_DataSet();
                                        DisponibilidadTableAdapter MyReportTableAdapter = new DisponibilidadTableAdapter();

                                        MyReportTableAdapter.FillByNombreUsuario(MyReportDataSet.Disponibilidad, User.Identity.Name);

                                        if (MyReportDataSet.Disponibilidad.Rows.Count == 0)
                                        {
                                            ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
                                            return;
                                        }

                                        // -----------------------------------------------------------------------------------------------
                                        // leemos el 1er. registro de la tabla 'temporal' para obtener las fechas inicial y final
                                        // del período de consulta

                                        dbBancosDataContext dbBancos = new dbBancosDataContext();

                                        var CuentaBancaria =
                                            (from c in dbBancos.tTempWebReport_DisponibilidadBancos
                                             where c.NombreUsuario == User.Identity.Name
                                             select c).FirstOrDefault();

                                        System.DateTime dFechaInicialPeriodo = CuentaBancaria.FechaSaldoAnterior;
                                        System.DateTime dFechaFinalPeriodo = CuentaBancaria.FechaSaldoActual;

                                        CuentaBancaria = null;

                                        this.ReportViewer1.LocalReport.ReportPath = "Bancos/Disponibilidad en bancos/Disponibilidad/Bancos_Disponibilidad.rdlc";

                                        ReportDataSource myReportDataSource = new ReportDataSource();

                                        myReportDataSource.Name = "ReporteDisponibilidad_DataSet_Disponibilidad";
                                        myReportDataSource.Value = MyReportDataSet.Disponibilidad;

                                        this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                                        this.ReportViewer1.LocalReport.Refresh();

                                        ReportParameter FechaInicialPeriodo_ReportParameter = new
                                            ReportParameter("FechaInicialPeriodo", dFechaInicialPeriodo.ToString());

                                        ReportParameter FechaFinalPeriodo_ReportParameter = new
                                            ReportParameter("FechaFinalPeriodo", dFechaFinalPeriodo.ToString());

                                        ReportParameter[] MyReportParameters = { FechaInicialPeriodo_ReportParameter, FechaFinalPeriodo_ReportParameter };

                                        this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                                        break; 
                                    }
                                case "si":              // versión más nueva del reporte; mostramos dos columnas; tuvimos que crear una lista como datasource del report 
                                    {
                                        string sqlSelect =
                                              "SELECT tTempWebReport_DisponibilidadBancos2.Orden, tTempWebReport_DisponibilidadBancos.CuentaBancaria, " +
                                              "tTempWebReport_DisponibilidadBancos.NombreCiaContab AS NombreCompania, " +
                                              "tTempWebReport_DisponibilidadBancos.NombreBanco, " +
                                              "tTempWebReport_DisponibilidadBancos.SimboloMoneda, tTempWebReport_DisponibilidadBancos2.Fecha, " +
                                              "tTempWebReport_DisponibilidadBancos2.Tipo, tTempWebReport_DisponibilidadBancos2.Transaccion, " +
                                              "tTempWebReport_DisponibilidadBancos2.Concepto, tTempWebReport_DisponibilidadBancos2.Beneficiario, " +
                                              "tTempWebReport_DisponibilidadBancos2.Monto, tTempWebReport_DisponibilidadBancos2.FechaEntregado, " +
                                              "tTempWebReport_DisponibilidadBancos2.Conciliacion_FechaEjecucion " +
                                              "FROM tTempWebReport_DisponibilidadBancos2 INNER JOIN " +
                                              "tTempWebReport_DisponibilidadBancos ON " +
                                              "tTempWebReport_DisponibilidadBancos2.CiaContab = tTempWebReport_DisponibilidadBancos.CiaContab AND " +
                                              "tTempWebReport_DisponibilidadBancos2.CuentaInterna = " +
                                              "tTempWebReport_DisponibilidadBancos.CuentaInterna AND " +
                                              "tTempWebReport_DisponibilidadBancos2.NombreUsuario = " +
                                              "tTempWebReport_DisponibilidadBancos.NombreUsuario " +
                                              "WHERE tTempWebReport_DisponibilidadBancos.NombreUsuario = {0} " +
                                              "Order By tTempWebReport_DisponibilidadBancos.NombreCiaContab, " +
                                              "tTempWebReport_DisponibilidadBancos.CuentaBancaria, " +
                                              "tTempWebReport_DisponibilidadBancos2.Orden"; 

                                        BancosEntities bancosContext = new BancosEntities();

                                        var movimientos = bancosContext.ExecuteStoreQuery<Bancos_ConsultaDisponibilidad_Item>(sqlSelect, User.Identity.Name);

                                        List<Bancos_ConsultaDisponibilidad_Item> list = new List<Bancos_ConsultaDisponibilidad_Item>();
                                        Bancos_ConsultaDisponibilidad_Item item;

                                        short ordenItem = 0;
                                        decimal totalDebitos = 0;
                                        decimal totalCreditos = 0;
                                        string cuentaBancariaAnterior = "-xyzxyzxyz"; 

                                        foreach (var movimiento in movimientos)
                                        {
                                            if (movimiento.CuentaBancaria != cuentaBancariaAnterior)
                                            {
                                                totalDebitos = 0;
                                                totalCreditos = 0;
                                                cuentaBancariaAnterior = movimiento.CuentaBancaria; 
                                            }

                                            if (movimiento.Tipo == "SA")
                                            {
                                                // agregamos un registro justo antes del saldo actual de cada cuenta, con sus totales para el debe y haber 

                                                item = new Bancos_ConsultaDisponibilidad_Item()
                                                {
                                                    Orden = ordenItem,
                                                    CuentaBancaria = movimiento.CuentaBancaria,
                                                    NombreCompania = movimiento.NombreCompania,
                                                    NombreBanco = movimiento.NombreBanco,
                                                    SimboloMoneda = movimiento.SimboloMoneda,
                                                    Fecha = movimiento.Fecha,
                                                    Tipo = "TotDbCr",
                                                    Transaccion = movimiento.Transaccion,
                                                    Concepto = "Total de débitos y créditos",
                                                    Beneficiario = "",
                                                    Monto = totalDebitos - totalCreditos,
                                                    Debe = totalDebitos, 
                                                    Haber = totalCreditos,
                                                    FechaEntregado = null,
                                                    Conciliacion_FechaEjecucion = null
                                                };

                                                ordenItem++;
                                                list.Add(item); 
                                            }

                                            item = new Bancos_ConsultaDisponibilidad_Item()
                                            {
                                                Orden = ordenItem,
                                                CuentaBancaria = movimiento.CuentaBancaria,
                                                NombreCompania = movimiento.NombreCompania,
                                                NombreBanco = movimiento.NombreBanco,
                                                SimboloMoneda = movimiento.SimboloMoneda,
                                                Fecha = movimiento.Fecha,
                                                Tipo = movimiento.Tipo,
                                                Transaccion = movimiento.Transaccion,
                                                Concepto = movimiento.Concepto,
                                                Beneficiario = movimiento.Beneficiario, 
                                                Monto = movimiento.Monto,
                                                FechaEntregado = movimiento.FechaEntregado,
                                                Conciliacion_FechaEjecucion = movimiento.Conciliacion_FechaEjecucion
                                            };

                                            if (movimiento.Monto >= 0)
                                                totalDebitos += movimiento.Monto;
                                            else
                                                totalCreditos += movimiento.Monto * -1; 

                                            ordenItem++; 

                                            list.Add(item); 
                                        }

                                        
                                        if (list.Count == 0)
                                        {
                                            ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br />" +
                                                "Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
                                            return;
                                        }

                                        ReportDataSource myReportDataSource = new ReportDataSource();

                                        myReportDataSource.Name = "DataSet1";
                                        myReportDataSource.Value = list;

                                        this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                                        // -----------------------------------------------------------------------------------------------
                                        // leemos el 1er. registro de la tabla 'temporal' para obtener las fechas inicial y final
                                        // del período de consulta

                                        var CuentaBancaria =
                                            (from c in bancosContext.tTempWebReport_DisponibilidadBancos
                                             where c.NombreUsuario == User.Identity.Name
                                             select c).FirstOrDefault();

                                        System.DateTime dFechaInicialPeriodo = CuentaBancaria.FechaSaldoAnterior;
                                        System.DateTime dFechaFinalPeriodo = CuentaBancaria.FechaSaldoActual;

                                        CuentaBancaria = null;

                                        this.ReportViewer1.LocalReport.ReportPath = "Bancos/Disponibilidad en bancos/Disponibilidad/Bancos_Disponibilidad_DosColumnas.rdlc";

                                        this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                                        this.ReportViewer1.LocalReport.Refresh();

                                        var FechaInicialPeriodo_ReportParameter = new ReportParameter("FechaInicialPeriodo", dFechaInicialPeriodo.ToString());
                                        var FechaFinalPeriodo_ReportParameter = new ReportParameter("FechaFinalPeriodo", dFechaFinalPeriodo.ToString());

                                        ReportParameter[] MyReportParameters = { FechaInicialPeriodo_ReportParameter, FechaFinalPeriodo_ReportParameter };

                                        this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                                        break; 
                                    }
                            }

                            break;
                        }
                    case "disponibilidad_resumen":
                        {
                            ReporteDisponibilidad_DataSet MyReportDataSet = new ReporteDisponibilidad_DataSet();
                            Disponibilidad_ResumenTableAdapter MyReportTableAdapter = new Disponibilidad_ResumenTableAdapter();

                            MyReportTableAdapter.FillByNombreUsuario(MyReportDataSet.Disponibilidad_Resumen, User.Identity.Name);

                            if (MyReportDataSet.Disponibilidad_Resumen.Rows.Count == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
                                return;
                            }

                            // -----------------------------------------------------------------------------------------------
                            // leemos el 1er. registro de la tabla 'temporal' para obtener las fechas inicial y final
                            // del período de consulta

                            dbBancosDataContext dbBancos = new dbBancosDataContext();

                            var CuentaBancaria = (from c in dbBancos.tTempWebReport_DisponibilidadBancos
                                                  where c.NombreUsuario == User.Identity.Name
                                                  select c).FirstOrDefault();

                            System.DateTime dFechaInicialPeriodo = CuentaBancaria.FechaSaldoAnterior;
                            System.DateTime dFechaFinalPeriodo = CuentaBancaria.FechaSaldoActual;

                            CuentaBancaria = null;
                            // -----------------------------------------------------------------------------------------------

                            this.ReportViewer1.LocalReport.ReportPath = "Bancos/Disponibilidad en bancos/Disponibilidad/Bancos_Disponibilidad_Resumen.rdlc";


                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "ReporteDisponibilidad_DataSet_Disponibilidad_Resumen";
                            myReportDataSource.Value = MyReportDataSet.Disponibilidad_Resumen;


                            this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            this.ReportViewer1.LocalReport.Refresh();

                            ReportParameter FechaInicialPeriodo_ReportParameter =
                                new ReportParameter("FechaInicialPeriodo", dFechaInicialPeriodo.ToString());
                            ReportParameter FechaFinalPeriodo_ReportParameter =
                                new ReportParameter("FechaFinalPeriodo", dFechaFinalPeriodo.ToString());

                            ReportParameter[] MyReportParameters = { FechaInicialPeriodo_ReportParameter, FechaFinalPeriodo_ReportParameter };

                            this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                            break;
                        }
                    case "conciliacion_movbanco":
                        {
                            ReporteConciliacion_MovBanco_DataSet MyReportDataSet = new ReporteConciliacion_MovBanco_DataSet();
                            ConciliacionBancaria_MovimientosAConciliarTableAdapter MyReportTableAdapter =
                                new ConciliacionBancaria_MovimientosAConciliarTableAdapter();

                            switch (Request.QueryString["sel"])
                            {
                                case "conc":
                                    MyReportTableAdapter.FillByNombreUsuarioConciliados(MyReportDataSet.ConciliacionBancaria_MovimientosAConciliar, User.Identity.Name);
                                    break;
                                case "noconc":
                                    MyReportTableAdapter.FillByNombreUsuarioNoConciliados(MyReportDataSet.ConciliacionBancaria_MovimientosAConciliar, User.Identity.Name);
                                    break;
                                case "todos":
                                    MyReportTableAdapter.FillByNombreUsuario(MyReportDataSet.ConciliacionBancaria_MovimientosAConciliar, User.Identity.Name);
                                    break;
                            }

                            if (MyReportDataSet.ConciliacionBancaria_MovimientosAConciliar.Rows.Count == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que " +
                                    "Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un filtro y " +
                                    "seleccionado información aún.";
                                return;
                            }

                            this.ReportViewer1.LocalReport.ReportPath = "Bancos/Disponibilidad en bancos/Conciliacion/Bancos_Conciliacion_MovBanco.rdlc";

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "ReporteConciliacion_MovBanco_DataSet_ConciliacionBancaria_MovimientosAConciliar";
                            myReportDataSource.Value = MyReportDataSet.ConciliacionBancaria_MovimientosAConciliar;

                            this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            this.ReportViewer1.LocalReport.Refresh();

                            break;
                        }
                    case "conciliacion_movContab":
                        {
                            ReporteConciliacion_MovBanco_DataSet MyReportDataSet = new ReporteConciliacion_MovBanco_DataSet();
                            ConciliacionBancaria_MovimientosBancariosTableAdapter MyReportTableAdapter =
                                new ConciliacionBancaria_MovimientosBancariosTableAdapter();

                            switch (Request.QueryString["sel"])
                            {
                                case "conc":
                                    MyReportTableAdapter.FillByNombreUsuarioConciliados(MyReportDataSet.ConciliacionBancaria_MovimientosBancarios, User.Identity.Name);
                                    break;
                                case "noconc":
                                    MyReportTableAdapter.FillByNombreUsuarioNoConciliados(MyReportDataSet.ConciliacionBancaria_MovimientosBancarios, User.Identity.Name);
                                    break;
                                case "todos":
                                    MyReportTableAdapter.FillByNombreUsuario(MyReportDataSet.ConciliacionBancaria_MovimientosBancarios, User.Identity.Name);
                                    break;
                            }

                            if (MyReportDataSet.ConciliacionBancaria_MovimientosBancarios.Rows.Count == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
                                return;
                            }

                            this.ReportViewer1.LocalReport.ReportPath = "Bancos/Disponibilidad en bancos/Conciliacion/Bancos_Conciliacion_MovContab.rdlc";

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "ReporteConciliacion_MovBanco_DataSet_ConciliacionBancaria_MovimientosBancarios";
                            myReportDataSource.Value = MyReportDataSet.ConciliacionBancaria_MovimientosBancarios;

                            this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            this.ReportViewer1.LocalReport.Refresh();

                            break;
                        }
                    case "cuentasymovimientos":
                        {
                            switch (Request.QueryString["opc"])
                            {

                                case "0":
                                    {
                                        string tituloReporte = "";
                                        string subtituloReporte = "";
                                        string color = "";
                                        string format = "";
                                        string orientation = "";
                                        string simpleFont = "";
                                        string saltoPagina = "";

                                        if (Request.QueryString["tit"] != null && !string.IsNullOrEmpty(Request.QueryString["tit"].ToString()))
                                            tituloReporte = Request.QueryString["tit"].ToString();

                                        if (Request.QueryString["subtit"] != null && !string.IsNullOrEmpty(Request.QueryString["subtit"].ToString()))
                                            subtituloReporte = Request.QueryString["subtit"].ToString();

                                        if (Request.QueryString["color"] != null && !string.IsNullOrEmpty(Request.QueryString["color"].ToString()))
                                            color = Request.QueryString["color"].ToString();

                                        if (Request.QueryString["format"] != null && !string.IsNullOrEmpty(Request.QueryString["format"].ToString()))
                                            format = Request.QueryString["format"].ToString();

                                        if (Request.QueryString["orientation"] != null && !string.IsNullOrEmpty(Request.QueryString["orientation"].ToString()))
                                            orientation = Request.QueryString["orientation"].ToString();

                                        if (Request.QueryString["simpleFont"] != null && !string.IsNullOrEmpty(Request.QueryString["simpleFont"].ToString()))
                                            simpleFont = Request.QueryString["simpleFont"].ToString();


                                        //ReporteMayorGeneral_DataSet MyReportDataSet = new ReporteMayorGeneral_DataSet();
                                        //vContab_ConsultaCuentasYMovimientosTableAdapter MyReportTableAdapter = new vContab_ConsultaCuentasYMovimientosTableAdapter();

                                        //MyReportTableAdapter.FillByNombreUsuario(MyReportDataSet.vContab_ConsultaCuentasYMovimientos, User.Identity.Name);





                                        var contabContext = new ContabContext();

                                        var cuentasYMovimientos = contabContext.ConsultaCuentasYMovimientos
                                                                               .Where(x => x.NombreUsuario == User.Identity.Name)
                                                                               .Select(x => x)
                                                                               .ToList(); 

                                        CuentasYMovimientos_Report reportItem;
                                        List<CuentasYMovimientos_Report> reportItem_list = new List<CuentasYMovimientos_Report>(); 

                                        foreach (var item in cuentasYMovimientos)
                                        {
                                            var companiaContab = contabContext.ConsultaCuentasYMovimientos.Where(x => x.ID == item.ID)
                                                                                                           .Select(x => new { x.CuentasContables.Companias.Nombre })
                                                                                                           .FirstOrDefault();

                                            foreach (var movimiento in item.ConsultaCuentasYMovimientos_Movimientos)
                                            {
                                                var asiento = contabContext.Asientos.Where(x => x.NumeroAutomatico == movimiento.AsientoID)
                                                                                    .Select(x => new {
                                                                                        numeroComprobante = x.Numero, 
                                                                                        fechaComprobante = x.Fecha, 
                                                                                        simboloMonedaOriginal = x.Monedas1.Simbolo
                                                                                    })
                                                                                    .FirstOrDefault(); 

                                                // TODO2: cómo calcular el total??? 
                                                reportItem = new CuentasYMovimientos_Report() {
                                                    NombreCiaContab = companiaContab.Nombre,
                                                    NombreMoneda = movimiento.ConsultaCuentasYMovimientos.Monedas.Descripcion,
                                                    SimboloMoneda = movimiento.ConsultaCuentasYMovimientos.Monedas.Simbolo,
                                                    CuentaContableEditada = movimiento.ConsultaCuentasYMovimientos.CuentasContables.CuentaEditada,
                                                    NombreCuentaContable = movimiento.ConsultaCuentasYMovimientos.CuentasContables.Descripcion
                                                };

                                                if (asiento != null)
                                                {
                                                    reportItem.NumeroComprobante = asiento.numeroComprobante;
                                                    reportItem.Fecha = asiento.fechaComprobante;
                                                    reportItem.SimboloMonedaOriginal = asiento.simboloMonedaOriginal;
                                                }
       
                                                reportItem.Secuencia = movimiento.Secuencia; 
                                                reportItem.Partida = movimiento.Partida;
                                                reportItem.Descripcion = movimiento.Descripcion;
                                                reportItem.Referencia = movimiento.Referencia;
                                                reportItem.Debe = movimiento.Monto >= 0 ? movimiento.Monto : 0;
                                                reportItem.Haber = movimiento.Monto < 0 ? Math.Abs(movimiento.Monto) : 0;
                                                reportItem.Total = movimiento.Monto;
                                                reportItem.CentroCostoAbreviatura = movimiento.CentroCostoAbreviatura; 
                                                reportItem.NombreUsuario = User.Identity.Name; 

                                                reportItem_list.Add(reportItem);
                                            }
                                        }

                                        if (reportItem_list.Count == 0)
                                        {
                                            ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br />" + 
                                                "Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
                                            return;
                                        }

                                        if (orientation == "v") 
                                            this.ReportViewer1.LocalReport.ReportPath = "Contab/Consultas contables/Cuentas y movimientos/CuentasYMovimientos_Portrait.rdlc";
                                        else
                                            this.ReportViewer1.LocalReport.ReportPath = "Contab/Consultas contables/Cuentas y movimientos/CuentasYMovimientos_Landscape.rdlc";

                                        ReportDataSource myReportDataSource = new ReportDataSource();

                                        myReportDataSource.Name = "DataSet1";
                                        myReportDataSource.Value = reportItem_list;

                                        this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                                        string periodo = ""; 

                                        if (!(Session["Report_Param_MG_Periodo"] == null))
                                            periodo = Session["Report_Param_MG_Periodo"].ToString();
                                        else
                                            periodo = "Período indefinido";


                                        ReportParameter subTituloReportParameter = new ReportParameter("subTitulo", subtituloReporte);
                                        ReportParameter periodoReportParameter = new ReportParameter("periodo", periodo);
                                        ReportParameter tituloReportParameter = new ReportParameter("titulo", tituloReporte);
                                        ReportParameter colorReportParameter = new ReportParameter("color", color);
                                        ReportParameter simpleFontReportParameter = new ReportParameter("simpleFont", simpleFont);

                                        // -----------------------------------------------------------------------------------------------------
                                        // leemos un 'flag' en la tabla Parametros, que permite al usuario indicar si quiere mostrar o 
                                        // no la fecha del día en los reportes de contabilidad ... 

                                        //string nombreCiaContab = MyReportDataSet.vContab_ConsultaCuentasYMovimientos[0].NombreCiaContab; 

                                        //dbContab_Contab_Entities contabContex = new dbContab_Contab_Entities(); 

                                        int? ciaContab = contabContext.Companias.Where(c => c.Nombre == "G.E.H. Asesores, C.A.").Select(c => c.Numero).FirstOrDefault(); 

                                        bool ? noMostrarFechaEnReportesContab = false;

                                        if (ciaContab != null)
                                            noMostrarFechaEnReportesContab = contabContext.ParametrosContab.Where(p => p.Cia == ciaContab.Value).
                                                                                                            Select(p => p.ReportesContab_NoMostrarFechaDia).
                                                                                                            FirstOrDefault();

                                        if (noMostrarFechaEnReportesContab == null)
                                            noMostrarFechaEnReportesContab = false; 

                                        ReportParameter noMostrarFechaDia_ReportParameter = 
                                            new ReportParameter("noMostrarFechaDia", noMostrarFechaEnReportesContab.Value.ToString());
                                        // -----------------------------------------------------------------------------------------------------

                                        if (Request.QueryString["saltoPagina"] != null && !string.IsNullOrEmpty(Request.QueryString["saltoPagina"].ToString()))
                                            saltoPagina = Request.QueryString["saltoPagina"].ToString();

                                        ReportParameter saltoPagina_ReportParameter = new ReportParameter("saltoPagina", saltoPagina);


                                        ReportParameter[] MyReportParameters = 
                                        { 
                                            subTituloReportParameter, 
                                            periodoReportParameter, 
                                            tituloReportParameter, 
                                            colorReportParameter, 
                                            simpleFontReportParameter, 
                                            noMostrarFechaDia_ReportParameter,
                                            saltoPagina_ReportParameter
                                        };

                                        this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                                        this.ReportViewer1.LocalReport.Refresh();

                                        if (format == "pdf")
                                        {
                                            Warning[] warnings;
                                            string[] streamIds;
                                            string mimeType = string.Empty;
                                            string encoding = string.Empty;
                                            string extension = string.Empty;

                                            byte[] bytes = this.ReportViewer1.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);

                                            // Now that you have all the bytes representing the PDF report, buffer it and send it to the client.
                                            Response.Buffer = true;
                                            Response.Clear();
                                            Response.ContentType = mimeType;
                                            Response.AddHeader("content-disposition", "attachment; filename=CuentasContablesYMovimientos.pdf");
                                            Response.BinaryWrite(bytes); // create the file
                                            Response.Flush(); // send it to the client to download
                                        }

                                        break;
                                    }
                            }

                            break;
                        }
                    case "comprobantescontables":
                        {
                            // nótese que en session debe venir el filtro que usó el usuario 
                            if (Session["filtroForma_consultaAsientosContables"] == null)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br />" +
                                    "Probablemente Ud. no ha aplicado un filtro aún, o la sesión ha caducado.";
                                return;
                            }

                            // leemos los parámetros del querystring 

                            string tituloReporte = "";
                            string subtituloReporte = "";
                            string color = "";
                            string format = "";
                            string orientation = "";
                            string simpleFont = "";
                            string debeHaber = "no";

                            bool mostrarFecha = false;
                            bool fechaHoy = false;
                            string fechaPropia = "";

                            string saltoPagina = "";
                            string orderBy = "fecha"; 

                            if (Request.QueryString["tit"] != null && !string.IsNullOrEmpty(Request.QueryString["tit"].ToString()))
                                tituloReporte = Request.QueryString["tit"].ToString();

                            if (Request.QueryString["subtit"] != null && !string.IsNullOrEmpty(Request.QueryString["subtit"].ToString()))
                                subtituloReporte = Request.QueryString["subtit"].ToString();

                            if (Request.QueryString["color"] != null && !string.IsNullOrEmpty(Request.QueryString["color"].ToString()))
                                color = Request.QueryString["color"].ToString();

                            if (Request.QueryString["format"] != null && !string.IsNullOrEmpty(Request.QueryString["format"].ToString()))
                                format = Request.QueryString["format"].ToString();

                            if (Request.QueryString["orientation"] != null && !string.IsNullOrEmpty(Request.QueryString["orientation"].ToString()))
                                orientation = Request.QueryString["orientation"].ToString();

                            if (Request.QueryString["simpleFont"] != null && !string.IsNullOrEmpty(Request.QueryString["simpleFont"].ToString()))
                                simpleFont = Request.QueryString["simpleFont"].ToString();

                            // una o dos columnas (debe/haber) 
                            if (Request.QueryString["debeHaber"] != null && !string.IsNullOrEmpty(Request.QueryString["debeHaber"].ToString()))
                                debeHaber = Request.QueryString["debeHaber"].ToString();

                            // order by ... 
                            if (Request.QueryString["orderBy"] != null && !string.IsNullOrEmpty(Request.QueryString["orderBy"].ToString()))
                                orderBy = Request.QueryString["orderBy"].ToString();


                            // mostrar la fecha de hoy en el listado ... 
                            if (Request.QueryString["mostrarFecha"] != null && !string.IsNullOrEmpty(Request.QueryString["debeHaber"].ToString()) &&
                                Request.QueryString["mostrarFecha"].ToString() == "si")
                            {
                                mostrarFecha = true;

                                if (Request.QueryString["fechaHoy"] != null && !string.IsNullOrEmpty(Request.QueryString["fechaHoy"].ToString()) &&
                                    Request.QueryString["fechaHoy"].ToString() == "si")
                                {
                                    fechaHoy = true;
                                }
                                else
                                {
                                    if (Request.QueryString["fechaPropia"] != null && !string.IsNullOrEmpty(Request.QueryString["fechaPropia"].ToString()))
                                    {
                                        fechaPropia = Request.QueryString["fechaPropia"].ToString(); 
                                    }
                                }
                            }

                            string sSqlQueryString = "";
                            string sSqlQueryString_subquery_soloAsientosDescuadrados = ""; 

                            if (Session["filtroForma_consultaAsientosContables_subQuery"] == null || Session["filtroForma_consultaAsientosContables_subQuery"].ToString() == "1 = 1")
                            {
                                // el usuario no usó criterio por cuenta contable o más de 2 decimales; no usamos sub-query 
                                sSqlQueryString = "SELECT Monedas.Descripcion AS NombreMoneda, Companias.Nombre AS NombreCiaContab, Asientos.Fecha, Asientos.NumeroAutomatico, " +
                                                  "Asientos.Numero, " +
                                                  "TiposDeAsiento.Descripcion AS NombreTipo, Monedas_1.Simbolo AS SimboloMonedaOriginal, dAsientos.Partida, " +
                                                  "CuentasContables.CuentaEditada AS CuentaContableEditada, CuentasContables.Descripcion AS NombreCuentaContable, " +
                                                  "dAsientos.Descripcion as DescripcionPartida, dAsientos.Referencia as ReferenciaPartida, " +
                                                  "dAsientos.Debe, dAsientos.Haber, Asientos.ProvieneDe, Asientos.Descripcion as DescripcionAsiento " +

                                                  "FROM Asientos " +

                                                  "Left Outer Join dAsientos On Asientos.NumeroAutomatico = dAsientos.NumeroAutomatico " +

                                                  "INNER JOIN Companias ON Asientos.Cia = Companias.Numero " +
                                                  "INNER JOIN CuentasContables ON dAsientos.CuentaContableID = CuentasContables.ID " +
                                                  "INNER JOIN Monedas ON Asientos.Moneda = Monedas.Moneda " +
                                                  "INNER JOIN TiposDeAsiento ON Asientos.Tipo = TiposDeAsiento.Tipo " +
                                                  "INNER JOIN Monedas AS Monedas_1 ON Asientos.MonedaOriginal = Monedas_1.Moneda " +

                                                  "Where " + Session["filtroForma_consultaAsientosContables"].ToString();

                                // construimos un subquery que será aplicado solo si el usuario desea fitrar asientos descuadrados 
                                sSqlQueryString_subquery_soloAsientosDescuadrados = "SELECT Asientos.NumeroAutomatico " +
                                                  "FROM Asientos " +
                                                  "Inner Join dAsientos On Asientos.NumeroAutomatico = dAsientos.NumeroAutomatico " +
                                                  "INNER JOIN CuentasContables ON dAsientos.CuentaContableID = CuentasContables.ID " +
                                                  "Where " + Session["filtroForma_consultaAsientosContables"].ToString() + " " + 
                                                  "Group By Asientos.NumeroAutomatico Having Sum(dAsientos.Debe) <> Sum(dAsientos.Haber)"; 

                            }
                            else
                            {
                                // usamos un subquery para que *solo* asientos con ciertas cuentas *o* partidas con montos con más de 2 decimales sean seleccionados
                                sSqlQueryString = "SELECT Monedas.Descripcion AS NombreMoneda, Companias.Nombre AS NombreCiaContab, Asientos.Fecha, Asientos.NumeroAutomatico, " +
                                                  "Asientos.Numero, " +
                                                  "TiposDeAsiento.Descripcion AS NombreTipo, Monedas_1.Simbolo AS SimboloMonedaOriginal, dAsientos.Partida, " +
                                                  "CuentasContables.CuentaEditada AS CuentaContableEditada, CuentasContables.Descripcion AS NombreCuentaContable, " +
                                                  "dAsientos.Descripcion as DescripcionPartida, dAsientos.Referencia as ReferenciaPartida, " +
                                                  "dAsientos.Debe, dAsientos.Haber, Asientos.ProvieneDe, Asientos.Descripcion as DescripcionAsiento " +

                                                  "FROM Asientos " +
                                                  "Left Outer Join dAsientos On Asientos.NumeroAutomatico = dAsientos.NumeroAutomatico " +
                                                  "Left Outer Join CuentasContables On CuentasContables.ID = dAsientos.CuentaContableID " +

                                                  "INNER JOIN Companias ON Asientos.Cia = Companias.Numero " +
                                                  "INNER JOIN Monedas ON Asientos.Moneda = Monedas.Moneda " +
                                                  "INNER JOIN TiposDeAsiento ON Asientos.Tipo = TiposDeAsiento.Tipo " +
                                                  "INNER JOIN Monedas AS Monedas_1 ON Asientos.MonedaOriginal = Monedas_1.Moneda " +

                                                  "Where " + Session["filtroForma_consultaAsientosContables"].ToString() +
                                                  " And (Asientos.NumeroAutomatico In (SELECT Asientos.NumeroAutomatico FROM Asientos " +
                                                  "Left Outer Join dAsientos On Asientos.NumeroAutomatico = dAsientos.NumeroAutomatico " +
                                                  "Left Outer Join CuentasContables On CuentasContables.ID = dAsientos.CuentaContableID " +
                                                  "Where " + Session["filtroForma_consultaAsientosContables"].ToString() + " And " +
                                                  Session["filtroForma_consultaAsientosContables_subQuery"].ToString() + "))";

                                sSqlQueryString_subquery_soloAsientosDescuadrados = "SELECT Asientos.NumeroAutomatico " +
                                                  "FROM Asientos " +
                                                  "Inner Join dAsientos On Asientos.NumeroAutomatico = dAsientos.NumeroAutomatico " +
                                                  "INNER JOIN CuentasContables ON dAsientos.CuentaContableID = CuentasContables.ID " +
                                                  "Where " + Session["filtroForma_consultaAsientosContables"].ToString() +
                                                  " And (Asientos.NumeroAutomatico In (SELECT Asientos.NumeroAutomatico FROM Asientos " +
                                                  "Left Outer Join dAsientos On Asientos.NumeroAutomatico = dAsientos.NumeroAutomatico " +
                                                  "Left Outer Join CuentasContables On CuentasContables.ID = dAsientos.CuentaContableID " +
                                                  "Where " + Session["filtroForma_consultaAsientosContables"].ToString() + " And " +
                                                  Session["filtroForma_consultaAsientosContables_subQuery"].ToString() + ")) " + 
                                                  "Group By Asientos.NumeroAutomatico Having Sum(dAsientos.Debe) <> Sum(dAsientos.Haber)";
                            }

                            if (Session["SoloAsientosDescuadrados"] != null && Convert.ToBoolean(Session["SoloAsientosDescuadrados"]))
                            {
                                sSqlQueryString = sSqlQueryString +
                                    $" And Asientos.NumeroAutomatico In ({sSqlQueryString_subquery_soloAsientosDescuadrados})";
                            }

                            List<Asiento2_Report> list = new List<Asiento2_Report>();

                            dbContab_Contab_Entities context = new dbContab_Contab_Entities();

                            using (context)
                            {
                                List<AsientoContable_Report_Item> query = context.ExecuteStoreQuery<AsientoContable_Report_Item>(sSqlQueryString).ToList();
                                Asiento2_Report asiento;

                                foreach (var partida in query)
                                {
                                    asiento = new Asiento2_Report();

                                    asiento.NombreMoneda = partida.NombreMoneda; 
                                    asiento.NombreCiaContab = partida.NombreCiaContab;
                                    asiento.Fecha = partida.Fecha;
                                    asiento.NumeroAutomatico = partida.NumeroAutomatico;
                                    asiento.Numero = partida.Numero;
                                    asiento.NombreTipo = partida.NombreTipo;
                                    asiento.SimboloMonedaOriginal = partida.SimboloMonedaOriginal;

                                    asiento.Partida = partida.Partida;
                                    asiento.CuentaContableEditada = partida.CuentaContableEditada;
                                    asiento.NombreCuentaContable = partida.NombreCuentaContable;
                                    asiento.Descripcion = partida.DescripcionPartida;
                                    asiento.Referencia = partida.ReferenciaPartida;
                                    asiento.Debe = partida.Debe;
                                    asiento.Haber = partida.Haber; 
                                    asiento.ProvieneDe = partida.ProvieneDe;
                                    asiento.DescripcionGeneralAsientoContable = partida.DescripcionAsiento;

                                    list.Add(asiento);
                                }
                            }

                            if (list.Count == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br />" +
                                    "Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
                                return;
                            }

                            if (orderBy == "fecha")
                            {
                                if (orientation == "v")
                                    // la opción vertical puede o no mostrar dos columnas (debe/haber) 
                                    if (debeHaber == "si")
                                        this.ReportViewer1.LocalReport.ReportPath = "Contab/Consultas contables/Comprobantes/ComprobantesContables_Portrait_debeHaber.rdlc";
                                    else
                                        this.ReportViewer1.LocalReport.ReportPath = "Contab/Consultas contables/Comprobantes/ComprobantesContables_Portrait.rdlc";
                                else
                                    // la opción horizontal, siempre muestra dos columnas 
                                    this.ReportViewer1.LocalReport.ReportPath = "Contab/Consultas contables/Comprobantes/ComprobantesContables_Landscape.rdlc";
                            }
                            else
                            {
                                // estos reports son idénticos a los anteriores, pero ordenan por #Comprobante 
                                if (orientation == "v")
                                    // la opción vertical puede o no mostrar dos columnas (debe/haber) 
                                    if (debeHaber == "si")
                                        this.ReportViewer1.LocalReport.ReportPath = "Contab/Consultas contables/Comprobantes/ComprobantesContables_Portrait_debeHaber_orderByComprobante.rdlc";
                                    else
                                        this.ReportViewer1.LocalReport.ReportPath = "Contab/Consultas contables/Comprobantes/ComprobantesContables_Portrait_orderByComprobante.rdlc";
                                else
                                    // la opción horizontal, siempre muestra dos columnas 
                                    this.ReportViewer1.LocalReport.ReportPath = "Contab/Consultas contables/Comprobantes/ComprobantesContables_Landscape_orderByComprobante.rdlc";
                            }
                            

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "DataSet1";
                            myReportDataSource.Value = list;

                            this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            ReportParameter FechaInicialPeriodo_ReportParameter;
                            ReportParameter FechaFinalPeriodo_ReportParameter;

                            if (Session["FechaInicial"] != null)
                                FechaInicialPeriodo_ReportParameter = new ReportParameter("FechaInicialPeriodo", Session["FechaInicial"].ToString());
                            else
                                FechaInicialPeriodo_ReportParameter = new ReportParameter("FechaInicialPeriodo", "1960-1-1");

                            if (Session["FechaFinal"] != null)
                                FechaFinalPeriodo_ReportParameter = new ReportParameter("FechaFinalPeriodo", Session["FechaFinal"].ToString());
                            else
                                FechaFinalPeriodo_ReportParameter = new ReportParameter("FechaFinalPeriodo", "1960-1-1"); 

                            ReportParameter subTituloReportParameter = new ReportParameter("subTitulo", subtituloReporte);
                            ReportParameter tituloReportParameter = new ReportParameter("titulo", tituloReporte);
                            ReportParameter colorReportParameter = new ReportParameter("color", color);
                            ReportParameter simpleFontReportParameter = new ReportParameter("simpleFont", simpleFont);

                            string fechaReporte = "";

                            if (mostrarFecha)
                            {
                                if (fechaHoy)
                                    fechaReporte = DateTime.Now.ToString("dd-MMM-yyyy");
                                else if (!string.IsNullOrEmpty(fechaPropia))
                                    fechaReporte = fechaPropia;
                            }

                            ReportParameter fechaReporteReportParameter = new ReportParameter("fechaReporte", fechaReporte);

                            if (Request.QueryString["saltoPagina"] != null && !string.IsNullOrEmpty(Request.QueryString["saltoPagina"].ToString()))
                                saltoPagina = Request.QueryString["saltoPagina"].ToString();

                            ReportParameter saltoPagina_ReportParameter = new ReportParameter("saltoPagina", saltoPagina);
                            // -----------------------------------------------------------------------------------------------------

                            ReportParameter[] MyReportParameters = 
                            { 
                                FechaInicialPeriodo_ReportParameter, 
                                FechaFinalPeriodo_ReportParameter, 
                                subTituloReportParameter, 
                                tituloReportParameter,
                                colorReportParameter,
                                simpleFontReportParameter, 
                                fechaReporteReportParameter, 
                                saltoPagina_ReportParameter
                            };

                            this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                            // nótese como elimiamos el subreport; ahora pasamos la información 'flat' y usamos un solo report (sin subreport) 
                            //this.ReportViewer1.LocalReport.SubreportProcessing += Report_SubreportProcessingEventHandler;

                            this.ReportViewer1.LocalReport.Refresh();

                            if (format == "pdf")
                            {
                                Warning[] warnings;
                                string[] streamIds;
                                string mimeType = string.Empty;
                                string encoding = string.Empty;
                                string extension = string.Empty;

                                byte[] bytes = this.ReportViewer1.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);

                                // Now that you have all the bytes representing the PDF report, buffer it and send it to the client.
                                Response.Buffer = true;
                                Response.Clear();
                                Response.ContentType = mimeType;
                                Response.AddHeader("content-disposition", "attachment; filename=ComprobantesContables.pdf");
                                Response.BinaryWrite(bytes); // create the file
                                Response.Flush(); // send it to the client to download
                            }

                            break;
                        }
                    case "unasientocontable":
                        {
                            int numeroAutomaticoAsientoContable; 

                            if (!int.TryParse(Request.QueryString["NumeroAutomatico"], out numeroAutomaticoAsientoContable))
                            {
                                ErrMessage_Cell.InnerHtml = "No se ha pasado un parámetro correcto a esta función. <br /><br />" + 
                                    "Esta función debe recibir como parámetro el ID válido de un asiento contable.";
                                return;
                            }

                            List<Asiento2_Report> list = new List<Asiento2_Report>();

                            string sqlSelect =
                                  "SELECT Monedas.Descripcion AS NombreMoneda, Companias.Nombre AS NombreCiaContab, Asientos.Fecha, Asientos.NumeroAutomatico, Asientos.Numero, " +
                                  "TiposDeAsiento.Descripcion AS NombreTipo, Monedas_1.Simbolo AS SimboloMonedaOriginal, dAsientos.Partida, " +
                                  "CuentasContables.CuentaEditada AS CuentaContableEditada, CuentasContables.Descripcion AS NombreCuentaContable, dAsientos.Descripcion, dAsientos.Referencia, " +
                                  "dAsientos.Debe, dAsientos.Haber, Asientos.ProvieneDe, Asientos.Descripcion " +
                                  "FROM Asientos " +
                                  "INNER JOIN Companias ON Asientos.Cia = Companias.Numero " +
                                  "INNER JOIN dAsientos ON Asientos.NumeroAutomatico = dAsientos.NumeroAutomatico " +
                                  "INNER JOIN CuentasContables ON dAsientos.CuentaContableID = CuentasContables.ID " +
                                  "INNER JOIN Monedas ON Asientos.Moneda = Monedas.Moneda " +
                                  "INNER JOIN TiposDeAsiento ON Asientos.Tipo = TiposDeAsiento.Tipo " +
                                  "INNER JOIN Monedas AS Monedas_1 ON Asientos.MonedaOriginal = Monedas_1.Moneda " +
                                  "Where Asientos.NumeroAutomatico = " + numeroAutomaticoAsientoContable.ToString();

                            SqlConnection connection = new SqlConnection();
                            connection.ConnectionString = ConfigurationManager.ConnectionStrings["dbContabConnectionString"].ConnectionString;

                            using (connection)
                            {
                                SqlCommand command = new SqlCommand(sqlSelect, connection);
                                connection.Open();

                                SqlDataReader reader = command.ExecuteReader();

                                Asiento2_Report asiento;

                                while (reader.Read())
                                {
                                    asiento = new Asiento2_Report();

                                    asiento.NombreMoneda = reader.GetString(0);
                                    asiento.NombreCiaContab = reader.GetString(1);
                                    asiento.Fecha = reader.GetDateTime(2);
                                    asiento.NumeroAutomatico = reader.GetInt32(3);
                                    asiento.Numero = reader.GetInt16(4);
                                    asiento.NombreTipo = reader.GetString(5);
                                    asiento.SimboloMonedaOriginal = reader.GetString(6);

                                    asiento.Partida = reader.GetInt16(7);
                                    asiento.CuentaContableEditada = reader.GetString(8);
                                    asiento.NombreCuentaContable = reader.GetString(9);
                                    asiento.Descripcion = reader.GetString(10);
                                    asiento.Referencia = reader.IsDBNull(11) ? string.Empty : reader.GetString(11);
                                    asiento.Debe = reader.GetDecimal(12);
                                    asiento.Haber = reader.GetDecimal(13);

                                    asiento.ProvieneDe = reader.IsDBNull(14) ? string.Empty : reader.GetString(14);
                                    asiento.DescripcionGeneralAsientoContable = reader.IsDBNull(15) ? string.Empty : reader.GetString(15);

                                    list.Add(asiento);
                                }

                                reader.Close();
                            }

                            if (list.Count == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br />" +
                                    "Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
                                return;
                            }


                            this.ReportViewer1.LocalReport.ReportPath = "Contab/Consultas contables/Comprobantes/ComprobantesContables_Portrait_debeHaber.rdlc";

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "DataSet1";
                            myReportDataSource.Value = list;

                            this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            // pasamos 1-1-1960 para que el reporte no imprima un rango de fechas en el encabezado; cuando se imprimen 
                            // varios comprobantes, si es adecuado hacerlo ... 

                            ReportParameter FechaInicialPeriodo_ReportParameter = new ReportParameter("FechaInicialPeriodo", "1960-1-1");
                            ReportParameter FechaFinalPeriodo_ReportParameter = new ReportParameter("FechaFinalPeriodo", "1960-1-1");

                            ReportParameter subTituloReportParameter = new ReportParameter("subTitulo", "");
                            ReportParameter tituloReportParameter = new ReportParameter("titulo", "Asientos Contables - Consulta");
                            ReportParameter colorReportParameter = new ReportParameter("color", "true");
                            ReportParameter simpleFontReportParameter = new ReportParameter("simpleFont", "false");

                            // -----------------------------------------------------------------------------------------------------
                            // leemos un 'flag' en la tabla Parametros, que permite al usuario indicar si quiere mostrar o 
                            // no la fecha del día en los reportes de contabilidad ... 

                            string nombreCiaContab = list[0].NombreCiaContab;

                            dbContab_Contab_Entities contabContex = new dbContab_Contab_Entities();

                            int? ciaContab = contabContex.Companias.Where(c => c.Nombre == nombreCiaContab).Select(c => c.Numero).FirstOrDefault();

                            bool? noMostrarFechaEnReportesContab = false;

                            if (ciaContab != null)
                                noMostrarFechaEnReportesContab = contabContex.ParametrosContabs.Where(p => p.Cia == ciaContab.Value).
                                                                                                Select(p => p.ReportesContab_NoMostrarFechaDia).
                                                                                                FirstOrDefault();

                            if (noMostrarFechaEnReportesContab == null)
                                noMostrarFechaEnReportesContab = false;

                            //ReportParameter noMostrarFechaDia_ReportParameter =
                            //    new ReportParameter("noMostrarFechaDia", noMostrarFechaEnReportesContab.Value.ToString());

                            ReportParameter fechaReporteReportParameter = new ReportParameter("fechaReporte", DateTime.Now.ToString("dd-MMM-yyyy"));

                            ReportParameter saltoPagina_ReportParameter = new ReportParameter("saltoPagina", "ninguno");
                            // -----------------------------------------------------------------------------------------------------

                            ReportParameter[] MyReportParameters = 
                            { 
                                FechaInicialPeriodo_ReportParameter, 
                                FechaFinalPeriodo_ReportParameter, 
                                subTituloReportParameter, 
                                tituloReportParameter,
                                colorReportParameter,
                                simpleFontReportParameter, 
                                // noMostrarFechaDia_ReportParameter, 
                                fechaReporteReportParameter, 
                                saltoPagina_ReportParameter
                            };

                            this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                            // nótese como elimiamos el subreport; ahora pasamos la información 'flat' y usamos un solo report (sin subreport) 
                            //this.ReportViewer1.LocalReport.SubreportProcessing += Report_SubreportProcessingEventHandler;

                            this.ReportViewer1.LocalReport.Refresh();

                            break;
                        }
                    case "balancecomprobacion":
                        {
                            string tituloReporte = "";
                            string subtituloReporte = "";
                            string color = "";
                            string format = "";
                            string simpleFont = "";
                            string mostrarTotales = "nivelAnterior"; 

                            if (Request.QueryString["tit"] != null && !string.IsNullOrEmpty(Request.QueryString["tit"].ToString()))
                                tituloReporte = Request.QueryString["tit"].ToString();

                            if (Request.QueryString["subtit"] != null && !string.IsNullOrEmpty(Request.QueryString["subtit"].ToString()))
                                subtituloReporte = Request.QueryString["subtit"].ToString();

                            if (Request.QueryString["color"] != null && !string.IsNullOrEmpty(Request.QueryString["color"].ToString()))
                                color = Request.QueryString["color"].ToString();

                            if (Request.QueryString["format"] != null && !string.IsNullOrEmpty(Request.QueryString["format"].ToString()))
                                format = Request.QueryString["format"].ToString();

                            if (Request.QueryString["simpleFont"] != null && !string.IsNullOrEmpty(Request.QueryString["simpleFont"].ToString()))
                                simpleFont = Request.QueryString["simpleFont"].ToString();

                            if (Request.QueryString["mostrarTotales"] != null && !string.IsNullOrEmpty(Request.QueryString["mostrarTotales"].ToString()))
                                mostrarTotales = Request.QueryString["mostrarTotales"].ToString();

                            dbContab_Contab_Entities context = new dbContab_Contab_Entities();

                            var query = context.Contab_BalanceComprobacion.Include("CuentasContable").
                                                                           Include("CuentasContable.Compania").
                                                                           Include("Moneda1").
                                                                           Include("CuentasContable.tGruposContable").
                                                                           Where(v => v.NombreUsuario == User.Identity.Name);

                            // ahora preparamos una lista para usarla como DataSource del report ... 

                            List<Contab_Report_ConsultaBalanceComprobacion> myList = new List<Contab_Report_ConsultaBalanceComprobacion>();
                            Contab_Report_ConsultaBalanceComprobacion item;

                            int cantidadRegistros = 0;

                            foreach (var c in query)
                            {
                                string[] cuentaContable_1erNivel = c.nivel1.Split(' ');

                                item = new Contab_Report_ConsultaBalanceComprobacion()
                                    {
                                        NombreCiaContab = c.CuentasContable.Compania.Nombre,
                                        NombreMoneda = c.Moneda1.Descripcion,
                                        SimboloMoneda = c.Moneda1.Simbolo,

                                        //NombreGrupoContable = c.CuentasContable.tGruposContable.Descripcion,
                                        OrdenGrupoContable = c.CuentasContable.tGruposContable.OrdenBalanceGeneral,     // ordenamos según el orden del grupo contable

                                        // en vez de agrupar por nombre de grupo contable, lo hacemos por el 1er. nivel de cada cuenta ... 

                                        //OrdenGrupoContable = Convert.ToInt32(cuentaContable_1erNivel[0]),
                                        NombreGrupoContable = cuentaContable_1erNivel[cuentaContable_1erNivel.Length - 1],  // mostramos el nombre del 1er. nivel de la cuenta
                                        
                                        CuentaContable = c.CuentasContable.Cuenta,
                                        CuentaContableEditada = c.CuentasContable.CuentaEditada,
                                        CuentaContable_Nombre = c.CuentasContable.Descripcion,
                                        CuentaContable_NivelPrevio = c.CuentaContable_NivelPrevio,
                                        CuentaContable_NivelPrevio_Descripcion = c.CuentaContable_NivelPrevio_Descripcion,

                                        nivel1 = c.nivel1,
                                        nivel2 = c.nivel2,
                                        nivel3 = c.nivel3,
                                        nivel4 = c.nivel4,
                                        nivel5 = c.nivel5,
                                        nivel6 = c.nivel6, 

                                        SaldoAnterior = c.SaldoAnterior,
                                        Debe = c.Debe,
                                        Haber = c.Haber,
                                        SaldoActual = c.SaldoActual, 
                                        CantidadMovimientos = c.CantidadMovimientos
                                    };

                                myList.Add(item);
                                cantidadRegistros++;
                            }


                            if (query.Count() == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte " +
                                    "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                    "filtro y seleccionado información aún.";
                                return;
                            }


                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "DataSet1";
                            myReportDataSource.Value = myList;

                            this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            if (mostrarTotales == "nivelAnterior") 
                                this.ReportViewer1.LocalReport.ReportPath = "Contab/Consultas contables/BalanceComprobacion/BalanceComprobacion.rdlc";
                            else
                                this.ReportViewer1.LocalReport.ReportPath = "Contab/Consultas contables/BalanceComprobacion/BalanceComprobacion_TotalesTodosLosDetalles.rdlc";


                            // asociamos valores a los parámetros del reporte  

                            // cuando el usuario regresa a la consulta puede ver la información consultada la vez anterior; sin embargo, el período solo 
                            // existe cuando se ejecuta un filtro ... 

                            ReportParameter Periodo_ReportParameter;

                            if (Session["FechaInicialPeriodo"] != null && Session["FechaFinalPeriodo"] != null)
                                Periodo_ReportParameter = new ReportParameter("periodo",
                                    Convert.ToDateTime(Session["FechaInicialPeriodo"]).ToString("dd-MMM-yy") +
                                    " al " +
                                    Convert.ToDateTime(Session["FechaFinalPeriodo"]).ToString("dd-MMM-yy")); 
                            else
                                Periodo_ReportParameter = new ReportParameter("periodo", "(Período indefinido)"); 

                            
                            // con estos dos parámetros, pasamos el título y subtítulo del reporte     

                            ReportParameter TituloReporte_ReportParameter = new ReportParameter("TituloReporte", tituloReporte);
                            ReportParameter SubituloReporte_ReportParameter = new ReportParameter("SubtituloReporte", subtituloReporte);
                            ReportParameter UsarColores_ReportParameter = new ReportParameter("UsarColores", color);
                            ReportParameter simpleFontReportParameter = new ReportParameter("simpleFont", simpleFont);

                            // -----------------------------------------------------------------------------------------------------
                            // leemos un 'flag' en la tabla Parametros, que permite al usuario indicar si quiere mostrar o 
                            // no la fecha del día en los reportes de contabilidad ... 

                            string nombreCiaContab = myList[0].NombreCiaContab;

                            dbContab_Contab_Entities contabContex = new dbContab_Contab_Entities();

                            int? ciaContab = contabContex.Companias.Where(c => c.Nombre == nombreCiaContab).Select(c => c.Numero).FirstOrDefault();

                            bool? noMostrarFechaEnReportesContab = false;

                            if (ciaContab != null)
                                noMostrarFechaEnReportesContab = contabContex.ParametrosContabs.Where(p => p.Cia == ciaContab.Value).
                                                                                                Select(p => p.ReportesContab_NoMostrarFechaDia).
                                                                                                FirstOrDefault();

                            if (noMostrarFechaEnReportesContab == null)
                                noMostrarFechaEnReportesContab = false;

                            ReportParameter noMostrarFechaDia_ReportParameter =
                                new ReportParameter("noMostrarFechaDia", noMostrarFechaEnReportesContab.Value.ToString());
                            // -----------------------------------------------------------------------------------------------------

                            ReportParameter[] MyReportParameters = 
                            { 
                                Periodo_ReportParameter, 
                                TituloReporte_ReportParameter, 
                                SubituloReporte_ReportParameter, 
                                UsarColores_ReportParameter, 
                                simpleFontReportParameter, 
                                noMostrarFechaDia_ReportParameter
                            };

                            this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);
                            this.ReportViewer1.LocalReport.Refresh();

                            if (format == "pdf")
                            {
                                Warning[] warnings;
                                string[] streamIds;
                                string mimeType = string.Empty;
                                string encoding = string.Empty;
                                string extension = string.Empty;

                                byte[] bytes = this.ReportViewer1.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);

                                // Now that you have all the bytes representing the PDF report, buffer it and send it to the client.
                                Response.Buffer = true;
                                Response.Clear();
                                Response.ContentType = mimeType;
                                Response.AddHeader("content-disposition", "attachment; filename=BalanceComprobacion.pdf");
                                Response.BinaryWrite(bytes); // create the file
                                Response.Flush(); // send it to the client to download
                            }

                            break;
                        }
                    case "vencimientofacturas":
                        {
                            BancosEntities dbBancos = new BancosEntities();

                            var query = dbBancos.Bancos_VencimientoFacturas.Where(v => v.NombreUsuario == User.Identity.Name); 

                            // ahora preparamos una lista para usarla como DataSource del report ... 
                            List<Bancos_Report_VencimientoFacturas> myList = new List<Bancos_Report_VencimientoFacturas>();
                            Bancos_Report_VencimientoFacturas infoSaldosPendientes;

                            int cantidadRegistros = 0; 

                            foreach (Bancos_VencimientoFacturas v in query)
                            {
                                infoSaldosPendientes = new Bancos_Report_VencimientoFacturas();

                                infoSaldosPendientes.CxCCxPFlag_Descripcion = v.CxCCxPFlag_Descripcion;
                                infoSaldosPendientes.SimboloMoneda = v.SimboloMoneda;
                                infoSaldosPendientes.NombreCiaContab = v.NombreCiaContab;
                                infoSaldosPendientes.NombreCompania = v.NombreCompania;
                                infoSaldosPendientes.NumeroFactura = v.NumeroFactura;
                                infoSaldosPendientes.NumeroCuota = v.NumeroCuota;
                                infoSaldosPendientes.FechaRecepcion = v.FechaRecepcion;
                                infoSaldosPendientes.FechaVencimiento = v.FechaVencimiento; 
                                infoSaldosPendientes.DiasVencimiento = v.DiasVencimiento;
                                infoSaldosPendientes.DiasPorVencerOVencidos = v.DiasPorVencerOVencidos;

                                infoSaldosPendientes.SaldoPendiente_0 = v.SaldoPendiente_0;
                                infoSaldosPendientes.SaldoPendiente_1 = v.SaldoPendiente_1;
                                infoSaldosPendientes.SaldoPendiente_2 = v.SaldoPendiente_2;
                                infoSaldosPendientes.SaldoPendiente_3 = v.SaldoPendiente_3;
                                infoSaldosPendientes.SaldoPendiente_4 = v.SaldoPendiente_4;

                                myList.Add(infoSaldosPendientes);
                                cantidadRegistros++; 
                            }


                            if (query.Count() == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte " +
                                    "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                    "filtro y seleccionado información aún.";
                                return;
                            }


                            // ----------------------------------------------------------------------------------
                            // el reporte depende de estos valores; nos aseguramos que existan

                            if (Session["TipoConsulta"] == null || 
                                Session["FechaConsulta"] == null ||
                                Session["CantDias1"] == null || 
                                Session["CantDias2"] == null ||
                                Session["CantDias3"] == null)
                            {
                                ErrMessage_Cell.InnerHtml = "Aparentemente, la página ha caducado. " +
                                "<br /><br /> Ud. debe generar nuevamente la consulta antes de intentar obtener " +
                                "nuevamente este reporte.";
                                return;
                            }

                            this.ReportViewer1.LocalReport.ReportPath = "Bancos/Consultas facturas/VencimientoFacturas/VencimientoFacturas.rdlc";

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "DataSet1";
                            myReportDataSource.Value = myList;


                            this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            // asociamos valores a los parámetros del reporte
                            Int16 tipoConsulta = Convert.ToInt16(Session["TipoConsulta"]);
                            DateTime? fechaInicialConsulta = Session["FechaConsulta_Inicio"] == null ? (DateTime?)null : Convert.ToDateTime(Session["FechaConsulta_Inicio"]);
                            DateTime fechaConsulta = Convert.ToDateTime(Session["FechaConsulta"]);
                            string subTituloReporte = "";

                            if (tipoConsulta == 1)
                            {
                                if (fechaInicialConsulta == null)
                                    subTituloReporte = $"Saldos por vencer al {fechaConsulta.ToString("dd-MMM-yyy")}";
                                else
                                    subTituloReporte = $"Saldos por vencer - {fechaInicialConsulta.Value.ToString("dd-MMM-yyy")} al {fechaConsulta.ToString("dd-MMM-yyy")}";
                            }
                            else
                            {
                                if (fechaInicialConsulta == null)
                                    subTituloReporte = $"Saldos vencidos al {fechaConsulta.ToString("dd-MMM-yyy")}";
                                else
                                    subTituloReporte = $"Saldos vencidos - {fechaInicialConsulta.Value.ToString("dd-MMM-yyy")} al {fechaConsulta.ToString("dd-MMM-yyy")}";
                            }

                            ReportParameter SubTitulo_ReportParameter = new ReportParameter("SubTitulo", subTituloReporte);
                            ReportParameter TipoConsulta_ReportParameter = new ReportParameter("TipoConsulta", tipoConsulta.ToString());

                            ReportParameter CantDias1_ReportParameter = new ReportParameter("CantDias1", Convert.ToInt16(Session["CantDias1"]).ToString());
                            ReportParameter CantDias2_ReportParameter = new ReportParameter("CantDias2", Convert.ToInt16(Session["CantDias2"]).ToString());
                            ReportParameter CantDias3_ReportParameter = new ReportParameter("CantDias3", Convert.ToInt16(Session["CantDias3"]).ToString());

                            ReportParameter[] MyReportParameters = 
                            { 
                                CantDias1_ReportParameter, 
                                CantDias2_ReportParameter, 
                                CantDias3_ReportParameter,
                                SubTitulo_ReportParameter,
                                TipoConsulta_ReportParameter
                            };

                            this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                            this.ReportViewer1.LocalReport.Refresh();

                            break;

                        }
                    case "facturaimpresa":
                        {
                            // imprimimos la factura para que el usuario pueda enviarla al cliente

                            int nClaveUnicaFactura = Convert.ToInt32(Request.QueryString["cuf"].ToString());

                            // leemos el nombre de la ciudad pues el reporte lo usa como un parámetro

                            dbBancosDataContext dbBancos = new dbBancosDataContext();

                            var sNombreCiudad = (from p in dbBancos.ParametrosGlobalBancos
                                                 select p.NombreCiudadParaCheque).SingleOrDefault();
                            dbBancos = null;

                            ReporteFacturas_DataSet MyReportDataSet = new ReporteFacturas_DataSet();
                            FacturaClientesImpresaTableAdapter MyReportTableAdapter =
                                new FacturaClientesImpresaTableAdapter();

                            MyReportTableAdapter.FillByClaveUnicaFactura(MyReportDataSet.FacturaClientesImpresa, nClaveUnicaFactura);

                            if (MyReportDataSet.FacturaClientesImpresa.Rows.Count == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
                                return;
                            }

                            this.ReportViewer1.LocalReport.ReportPath = "Bancos/Consultas facturas/Facturas/FacturaClientesImpresa.rdlc";

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "ReporteFacturas_DataSet_FacturaClientesImpresa";
                            myReportDataSource.Value = MyReportDataSet.FacturaClientesImpresa;

                            this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);


                            ReportParameter NombreCiudad_ReportParameter = new ReportParameter("NombreCiudad", sNombreCiudad);

                            ReportParameter[] MyReportParameters = { NombreCiudad_ReportParameter };

                            this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                            this.ReportViewer1.LocalReport.Refresh();

                            break;
                        }
                    case "reportefacturas":
                        {
                            switch (Request.QueryString["opc"].ToString())
                            {
                                case "0":
                                    {
                                        // general

                                        BancosEntities context = new BancosEntities();

                                        var query = context.tTempWebReport_ConsultaFacturas.Where("it.NombreUsuario == '" + User.Identity.Name + "'");

                                        if (query.Count() == 0)
                                        {
                                            ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte " +
                                                "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                                "filtro y seleccionado información aún.";
                                            return;
                                        }

                                        // ahora preparamos una lista para usarla como DataSource del report ... 

                                        List<Factura_ConsultaGeneral> myList = new List<Factura_ConsultaGeneral>();
                                        Factura_ConsultaGeneral infoFactura;

                                        foreach (tTempWebReport_ConsultaFacturas factura in query)
                                        {
                                            infoFactura = new Factura_ConsultaGeneral();

                                            infoFactura.MonedaNombre = factura.MonedaDescripcion;
                                            infoFactura.MonedaSimbolo = factura.MonedaSimbolo;

                                            infoFactura.CiaContab_Nombre = factura.CiaContabNombre;
                                            infoFactura.CxPCxC_Literal = factura.NombreCxCCxPFlag;

                                            infoFactura.Compania_Nombre = factura.NombreCompania;
                                            infoFactura.Compania_Abreviatura = factura.AbreviaturaCompania;

                                            infoFactura.NumeroDocumento = factura.NumeroFactura;
                                            infoFactura.NumeroControl = factura.NumeroControl;

                                            infoFactura.FechaEmision = factura.FechaEmision;
                                            infoFactura.FechaRecepcion = factura.FechaRecepcion;

                                            infoFactura.NombreTipo = factura.NombreTipo;
                                            infoFactura.Concepto = factura.Concepto; 

                                            infoFactura.MontoNoImponible = factura.MontoFacturaSinIva != null ? factura.MontoFacturaSinIva.Value : 0;

                                            infoFactura.MontoNoImponible = factura.MontoFacturaSinIva != null ? factura.MontoFacturaSinIva.Value : 0;
                                            infoFactura.MontoImponible = factura.MontoFacturaConIva != null ? factura.MontoFacturaConIva.Value : 0;
                                            infoFactura.IvaPorc = factura.IvaPorc != null ? factura.IvaPorc.Value : 0;
                                            infoFactura.Iva = factura.Iva != null ? factura.Iva.Value : 0;
                                            infoFactura.OtrosImpuestos = factura.ImpuestosVarios; 

                                            infoFactura.TotalFactura = factura.TotalFactura;
                                            infoFactura.Saldo = factura.Saldo;
                                            infoFactura.Estado = factura.NombreEstado;

                                            infoFactura.RetencionIva = factura.RetencionSobreIva != null ? factura.RetencionSobreIva.Value : 0;
                                            infoFactura.RetencionIslr = factura.ImpuestoRetenido != null ? factura.ImpuestoRetenido.Value : 0;
                                            infoFactura.OtrasRetenciones = factura.RetencionesVarias; 

                                            int signo = 1;
                                            if (factura.NcNdFlag == "NC")
                                            {
                                                //infoFactura.NumeroDocumento = "NC-" + factura.NumeroFactura;
                                                //signo = -1;
                                            }

                                            infoFactura.MontoNoImponible *= signo;
                                            infoFactura.MontoImponible *= signo;
                                            infoFactura.Iva *= signo;
                                            infoFactura.TotalFactura *= signo;
                                            infoFactura.Saldo *= signo;

                                            infoFactura.RetencionIva *= signo;
                                            infoFactura.RetencionIslr *= signo;

                                            myList.Add(infoFactura);
                                        }


                                        if (Convert.ToInt16(Request.QueryString["rep"].ToString()) == 1) 
                                            // reporte agrupado por compañía (esta es la versión original) 
                                            this.ReportViewer1.LocalReport.ReportPath = "Bancos/Consultas facturas/Facturas/Facturas_Generales.rdlc";
                                        else
                                            // reporte *no* agrupado por compañía (nueva versión; muestra la abreviatura de la 
                                            // compañía, para un reporte más compacto) 
                                            this.ReportViewer1.LocalReport.ReportPath = "Bancos/Consultas facturas/Facturas/Facturas_Generales2.rdlc";

                                        ReportDataSource myReportDataSource = new ReportDataSource();

                                        myReportDataSource.Name = "DataSet1";
                                        myReportDataSource.Value = myList;

                                        this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                                        this.ReportViewer1.LocalReport.Refresh();

                                        string sSubTitle_ReportParameter = "";

                                        if (!(Session["Report_SubTitle"] == null))
                                        {
                                            sSubTitle_ReportParameter = Session["Report_SubTitle"].ToString();
                                        }


                                        string mostrarConcepto = "no";
                                        if (!(Request.QueryString["concepto"] != null && Request.QueryString["concepto"].ToString() == "si"))
                                            mostrarConcepto = "si";


                                        ReportParameter SubTitle_ReportParameter = new ReportParameter("SubTitle", sSubTitle_ReportParameter);
                                        ReportParameter Concepto_ReportParameter = new ReportParameter("mostrarConcepto", mostrarConcepto);

                                        ReportParameter[] MyReportParameters = { SubTitle_ReportParameter, Concepto_ReportParameter };

                                        this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                                        break;
                                    }
                                case "1":
                                    {
                                        // retenciones iva

                                        //ReporteFacturas_DataSet MyReportDataSet = new ReporteFacturas_DataSet();
                                        //Facturas_RetencionIVATableAdapter MyReportTableAdapter =
                                        //    new Facturas_RetencionIVATableAdapter();

                                        //MyReportTableAdapter.FillByNombreUsuario(MyReportDataSet.Facturas_RetencionIVA, Membership.GetUser().UserName);

                                        //if (MyReportDataSet.Facturas_RetencionIVA.Rows.Count == 0)
                                        //{
                                        //    ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. ha requerido.<br /><br />" + 
                                        //        "Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
                                        //    return;
                                        //}


                                        BancosEntities bancosContext = new BancosEntities();

                                        var query = bancosContext.tTempWebReport_ConsultaFacturas.Where("it.NombreUsuario == '" + User.Identity.Name + "'");

                                        // ahora preparamos una lista para usarla como DataSource del report ... 
                                        List<RetencionesIvaReport_Item> myList = new List<RetencionesIvaReport_Item>();
                                        RetencionesIvaReport_Item infoCompra;

                                        foreach (tTempWebReport_ConsultaFacturas compra in query)
                                        {
                                            // nótese como, a continuación, agregamos un registro por cada monto Iva diferente (reducido/general/adicional) 

                                            bool agregueUnRegistroALaLista = false;

                                            if (compra.BaseImponible_Reducido != null && compra.BaseImponible_Reducido != 0)
                                            {
                                                infoCompra = new RetencionesIvaReport_Item();

                                                infoCompra.CiaContab_Nombre = compra.CiaContabNombre;
                                                infoCompra.CiaContab_Rif = compra.CiaContabRif;
                                                infoCompra.FechaEmision = compra.FechaEmision;
                                                infoCompra.FechaRecepcion = compra.FechaRecepcion;
                                                infoCompra.NumeroDocumento = compra.NumeroFactura;
                                                infoCompra.Compania_Nombre = compra.NombreCompania;

                                                if (!string.IsNullOrEmpty(compra.NumeroComprobante))
                                                {
                                                    infoCompra.ComprobanteSeniat = compra.NumeroComprobante;
                                                    if (compra.NumeroOperacion != null && compra.NumeroOperacion.Value != 0)
                                                        infoCompra.ComprobanteSeniat += "/" + compra.NumeroOperacion.Value.ToString();
                                                }

                                                infoCompra.MontoNoImponible = compra.MontoFacturaSinIva != null ? compra.MontoFacturaSinIva.Value : 0;

                                                infoCompra.MontoImponible = 0;
                                                infoCompra.IvaPorc = 0;
                                                infoCompra.RetencionIvaPorc = 0;
                                                infoCompra.RetencionIva = 0;

                                                // ahora sigue la información propia del monto Iva, para el tipo de alícuota en particular 
                                                infoCompra.MontoImponible = compra.BaseImponible_Reducido.Value;
                                                infoCompra.Iva = compra.Iva_Reducido != null ? compra.Iva_Reducido.Value : 0;
                                                infoCompra.TipoAlicuota = compra.TipoAlicuota_Reducido; 
                                                infoCompra.RetencionIva = compra.ImpuestoRetenido_Reducido != null ? compra.ImpuestoRetenido_Reducido.Value : 0;

                                                infoCompra.IvaPorc = Math.Abs(Math.Round((infoCompra.Iva * 100) / infoCompra.MontoImponible, 0));
                                                infoCompra.RetencionIvaPorc = Math.Abs(Math.Round((infoCompra.RetencionIva * 100) / infoCompra.Iva, 0));

                                                infoCompra.TotalComprasIncIva = 0;
                                                infoCompra.TotalComprasIncIva += infoCompra.MontoNoImponible;
                                                infoCompra.TotalComprasIncIva += infoCompra.MontoImponible;
                                                infoCompra.TotalComprasIncIva += infoCompra.Iva;

                                                myList.Add(infoCompra);
                                                agregueUnRegistroALaLista = true;
                                            }

                                            if (compra.BaseImponible_General != null && compra.BaseImponible_General != 0)
                                            {
                                                infoCompra = new RetencionesIvaReport_Item();

                                                infoCompra.CiaContab_Nombre = compra.CiaContabNombre;
                                                infoCompra.CiaContab_Rif = compra.CiaContabRif;
                                                infoCompra.FechaEmision = compra.FechaEmision;
                                                infoCompra.FechaRecepcion = compra.FechaRecepcion;
                                                infoCompra.NumeroDocumento = compra.NumeroFactura;
                                                infoCompra.Compania_Nombre = compra.NombreCompania;

                                                if (!string.IsNullOrEmpty(compra.NumeroComprobante))
                                                {
                                                    infoCompra.ComprobanteSeniat = compra.NumeroComprobante;
                                                    if (compra.NumeroOperacion != null && compra.NumeroOperacion.Value != 0)
                                                        infoCompra.ComprobanteSeniat += "/" + compra.NumeroOperacion.Value.ToString();
                                                }

                                                infoCompra.MontoNoImponible = compra.MontoFacturaSinIva != null ? compra.MontoFacturaSinIva.Value : 0;

                                                infoCompra.MontoImponible = 0;
                                                infoCompra.IvaPorc = 0;
                                                infoCompra.RetencionIvaPorc = 0;
                                                infoCompra.RetencionIva = 0;

                                                // ahora sigue la información propia del monto Iva, para el tipo de alícuota en particular 
                                                infoCompra.MontoImponible = compra.BaseImponible_General.Value;
                                                infoCompra.Iva = compra.Iva_General != null ? compra.Iva_General.Value : 0;
                                                infoCompra.TipoAlicuota = compra.TipoAlicuota_General; 
                                                infoCompra.RetencionIva = compra.ImpuestoRetenido_General != null ? compra.ImpuestoRetenido_General.Value : 0;

                                                infoCompra.IvaPorc = Math.Abs(Math.Round((infoCompra.Iva * 100) / infoCompra.MontoImponible, 0));
                                                infoCompra.RetencionIvaPorc = Math.Abs(Math.Round((infoCompra.RetencionIva * 100) / infoCompra.Iva, 0));

                                                infoCompra.TotalComprasIncIva = 0;
                                                if (agregueUnRegistroALaLista)
                                                    // para facturas con varios tipos de alícuota (y un monto iva para cada uno), el monto no imponible se 
                                                    // muestra solo para la 1ra. 
                                                    infoCompra.MontoNoImponible = 0;

                                                infoCompra.TotalComprasIncIva += infoCompra.MontoNoImponible;
                                                infoCompra.TotalComprasIncIva += infoCompra.MontoImponible;
                                                infoCompra.TotalComprasIncIva += infoCompra.Iva;

                                                myList.Add(infoCompra);
                                                agregueUnRegistroALaLista = true;
                                            }

                                            if (compra.BaseImponible_Adicional != null && compra.BaseImponible_Adicional != 0)
                                            {
                                                infoCompra = new RetencionesIvaReport_Item();

                                                infoCompra.CiaContab_Nombre = compra.CiaContabNombre;
                                                infoCompra.CiaContab_Rif = compra.CiaContabRif;
                                                infoCompra.FechaEmision = compra.FechaEmision;
                                                infoCompra.FechaRecepcion = compra.FechaRecepcion;
                                                infoCompra.NumeroDocumento = compra.NumeroFactura;
                                                infoCompra.Compania_Nombre = compra.NombreCompania;

                                                if (!string.IsNullOrEmpty(compra.NumeroComprobante))
                                                {
                                                    infoCompra.ComprobanteSeniat = compra.NumeroComprobante;
                                                    if (compra.NumeroOperacion != null && compra.NumeroOperacion.Value != 0)
                                                        infoCompra.ComprobanteSeniat += "/" + compra.NumeroOperacion.Value.ToString();
                                                }

                                                infoCompra.MontoNoImponible = compra.MontoFacturaSinIva != null ? compra.MontoFacturaSinIva.Value : 0;

                                                infoCompra.MontoImponible = 0;
                                                infoCompra.IvaPorc = 0;
                                                infoCompra.RetencionIvaPorc = 0;
                                                infoCompra.RetencionIva = 0;

                                                // ahora sigue la información propia del monto Iva, para el tipo de alícuota en particular 
                                                infoCompra.MontoImponible = compra.BaseImponible_Adicional.Value;
                                                infoCompra.Iva = compra.Iva_Adicional != null ? compra.Iva_Adicional.Value : 0;
                                                infoCompra.TipoAlicuota = compra.TipoAlicuota_Adicional; 
                                                infoCompra.RetencionIva = compra.ImpuestoRetenido_Adicional != null ? compra.ImpuestoRetenido_Adicional.Value : 0;

                                                infoCompra.IvaPorc = Math.Abs(Math.Round((infoCompra.Iva * 100) / infoCompra.MontoImponible, 0));
                                                infoCompra.RetencionIvaPorc = Math.Abs(Math.Round((infoCompra.RetencionIva * 100) / infoCompra.Iva, 0));

                                                infoCompra.TotalComprasIncIva = 0;
                                                if (agregueUnRegistroALaLista)
                                                    // para facturas con varios tipos de alícuota (y un monto iva para cada uno), el monto no imponible se 
                                                    // muestra solo para la 1ra. 
                                                    infoCompra.MontoNoImponible = 0;

                                                infoCompra.TotalComprasIncIva += infoCompra.MontoNoImponible;
                                                infoCompra.TotalComprasIncIva += infoCompra.MontoImponible;
                                                infoCompra.TotalComprasIncIva += infoCompra.Iva;

                                                myList.Add(infoCompra);
                                                agregueUnRegistroALaLista = true;
                                            }


                                            if (!agregueUnRegistroALaLista)
                                            {
                                                // no hay Iva ni retención sobre Iva ... 
                                                infoCompra = new RetencionesIvaReport_Item();

                                                infoCompra.CiaContab_Nombre = compra.CiaContabNombre;
                                                infoCompra.CiaContab_Rif = compra.CiaContabRif;
                                                infoCompra.FechaEmision = compra.FechaEmision;
                                                infoCompra.FechaRecepcion = compra.FechaRecepcion;
                                                infoCompra.NumeroDocumento = compra.NumeroFactura;
                                                infoCompra.Compania_Nombre = compra.NombreCompania;

                                                if (!string.IsNullOrEmpty(compra.NumeroComprobante))
                                                {
                                                    infoCompra.ComprobanteSeniat = compra.NumeroComprobante;
                                                    if (compra.NumeroOperacion != null && compra.NumeroOperacion.Value != 0)
                                                        infoCompra.ComprobanteSeniat += "/" + compra.NumeroOperacion.Value.ToString();
                                                }

                                                infoCompra.TotalComprasIncIva = 0;
                                                if (compra.MontoFacturaSinIva != null)
                                                    infoCompra.TotalComprasIncIva = compra.MontoFacturaSinIva.Value;

                                                infoCompra.MontoNoImponible = compra.MontoFacturaSinIva != null ? compra.MontoFacturaSinIva.Value : 0;

                                                infoCompra.MontoImponible = 0;
                                                infoCompra.IvaPorc = 0;
                                                infoCompra.TipoAlicuota = ""; 
                                                infoCompra.RetencionIvaPorc = 0;
                                                infoCompra.RetencionIva = 0;

                                                myList.Add(infoCompra);
                                            }
                                        }

                                        // solo si este proceso no selecciona ningún registro, agregamos uno con ceros, para que el reporte 
                                        // muestre el resumen, aunque sin montos ... 
                                        if (myList.Count == 0)
                                        {
                                            infoCompra = new RetencionesIvaReport_Item();

                                            infoCompra.CiaContab_Nombre = "";
                                            infoCompra.CiaContab_Rif = "";
                                            infoCompra.FechaEmision = null;
                                            infoCompra.FechaRecepcion = null;
                                            infoCompra.NumeroDocumento = "";
                                            infoCompra.Compania_Nombre = "";
                                            infoCompra.ComprobanteSeniat = "";
                  
                                            infoCompra.TotalComprasIncIva = 0;
                                            infoCompra.MontoNoImponible = 0;
                                            infoCompra.MontoImponible = 0;
                                            infoCompra.IvaPorc = 0;
                                            infoCompra.Iva = 0;
                                            infoCompra.TipoAlicuota = ""; 
                                            infoCompra.RetencionIvaPorc = 0;
                                            infoCompra.RetencionIva = 0;

                                            myList.Add(infoCompra);
                                        }


                                        this.ReportViewer1.LocalReport.ReportPath = "Bancos/Consultas facturas/Facturas/Facturas_RetencionesIVA.rdlc";

                                        ReportDataSource myReportDataSource = new ReportDataSource();

                                        myReportDataSource.Name = "DataSet1";
                                        myReportDataSource.Value = myList;


                                        this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                                        this.ReportViewer1.LocalReport.Refresh();

                                        string sSubTitle_ReportParameter = "";

                                        if (!(Session["Report_SubTitle"] == null))
                                        {
                                            sSubTitle_ReportParameter = Session["Report_SubTitle"].ToString();
                                        }

                                        ReportParameter SubTitle_ReportParameter = new ReportParameter("SubTitle", sSubTitle_ReportParameter);

                                        ReportParameter[] MyReportParameters = { SubTitle_ReportParameter };
                                        this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                                        break;
                                    }
                                case "2":
                                    {
                                        // retenciones islr

                                        ReporteFacturas_DataSet MyReportDataSet = new ReporteFacturas_DataSet();
                                        Facturas_RetencionesISLRTableAdapter MyReportTableAdapter = new Facturas_RetencionesISLRTableAdapter();

                                        MyReportTableAdapter.FillByNombreUsuario(MyReportDataSet.Facturas_RetencionesISLR, Membership.GetUser().UserName);

                                        if (MyReportDataSet.Facturas_RetencionesISLR.Rows.Count == 0)
                                        {
                                            ErrMessage_Cell.InnerHtml = "No existe información para mostrar el " +
                                                "reporte que Ud. ha requerido. <br /><br /> Probablemente Ud. no " +
                                                "ha aplicado un filtro y seleccionado información aún.";
                                            return;
                                        }

                                        this.ReportViewer1.LocalReport.ReportPath = "Bancos/Consultas facturas/Facturas/Facturas.rdlc";

                                        ReportDataSource myReportDataSource = new ReportDataSource();

                                        myReportDataSource.Name = "ReporteFacturas_DataSet_Facturas_RetencionesISLR";
                                        myReportDataSource.Value = MyReportDataSet.Facturas_RetencionesISLR;

                                        this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                                        this.ReportViewer1.LocalReport.Refresh();

                                        string sSubTitle_ReportParameter = "";

                                        if (!(Session["Report_SubTitle"] == null))
                                        {
                                            sSubTitle_ReportParameter = Session["Report_SubTitle"].ToString();
                                        }


                                        ReportParameter SubTitle_ReportParameter = new ReportParameter("SubTitle", sSubTitle_ReportParameter);

                                        ReportParameter[] MyReportParameters = { SubTitle_ReportParameter };

                                        this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                                        break;
                                    }
                                case "3":
                                    {
                                        // Libro de Compras
                                        BancosEntities context = new BancosEntities();

                                        var query = context.tTempWebReport_ConsultaFacturas.Where("it.NombreUsuario == '" + User.Identity.Name + "'");

                                        // ahora preparamos una lista para usarla como DataSource del report ... 
                                        List<Factura_LibroCompra> myList = new List<Factura_LibroCompra>();
                                        Factura_LibroCompra infoCompra;

                                        foreach (tTempWebReport_ConsultaFacturas compra in query)
                                        {
                                            // nótese como, a continuación, agregamos un registro por cada monto Iva diferente (reducido/general/adicional) 

                                            bool agregueUnRegistroALaLista = false;

                                            if (compra.BaseImponible_Reducido != null && compra.BaseImponible_Reducido != 0)
                                            {
                                                infoCompra = new Factura_LibroCompra();

                                                infoCompra.CiaContab_Nombre = compra.CiaContabNombre;
                                                infoCompra.CiaContab_Rif = compra.CiaContabRif;
                                                infoCompra.FechaDocumento = compra.FechaRecepcion;
                                                infoCompra.NumeroDocumento = compra.NumeroFactura;
                                                infoCompra.NumeroControl = compra.NumeroControl;
                                                infoCompra.Compania_Nombre = compra.NombreCompania;
                                                infoCompra.Compania_Rif = compra.RifCompania;

                                                infoCompra.Compra_NotaCredito = compra.NcNdFlag == "NC" ? "Notas de crédito" : "Compras";

                                                infoCompra.TipoDocumento = string.IsNullOrEmpty(compra.NcNdFlag) ? "Fact" : compra.NcNdFlag;
                                                infoCompra.DocumentoAfectado = compra.NumeroFacturaAfectada;

                                                if (!string.IsNullOrEmpty(compra.NumeroComprobante))
                                                {
                                                    infoCompra.ComprobanteSeniat = compra.NumeroComprobante;
                                                    if (compra.NumeroOperacion != null && compra.NumeroOperacion.Value != 0)
                                                        infoCompra.ComprobanteSeniat += "/" + compra.NumeroOperacion.Value.ToString();
                                                }

                                                infoCompra.Importacion_CompraNacional =
                                                    compra.ImportacionFlag != null && compra.ImportacionFlag.Value ? "Importaciones" : "Compras nacionales";

                                                infoCompra.PlanillaImportacion = compra.NumeroPlanillaImportacion;

                                                infoCompra.TotalComprasIncIva = 0;
                                                if (compra.MontoFacturaSinIva != null)
                                                    infoCompra.TotalComprasIncIva = compra.MontoFacturaSinIva.Value;

                                                if (compra.MontoFacturaConIva != null)
                                                    infoCompra.TotalComprasIncIva += compra.MontoFacturaConIva.Value;

                                                if (compra.Iva != null)
                                                    infoCompra.TotalComprasIncIva += compra.Iva.Value;

                                                infoCompra.MontoNoImponible = compra.MontoFacturaSinIva != null ? compra.MontoFacturaSinIva.Value : 0;

                                                infoCompra.MontoImponible = 0;
                                                infoCompra.IvaPorc = 0;
                                                infoCompra.RetencionIvaPorc = 0;
                                                infoCompra.RetencionIva = 0; 

                                                // ahora sigue la información propia del monto Iva, para el tipo de alícuota en particular 
                                                infoCompra.MontoImponible = compra.BaseImponible_Reducido.Value;
                                                infoCompra.Iva = compra.Iva_Reducido != null ? compra.Iva_Reducido.Value : 0;
                                                infoCompra.RetencionIva = compra.ImpuestoRetenido_Reducido != null ? compra.ImpuestoRetenido_Reducido.Value : 0;

                                                try
                                                {
                                                    infoCompra.IvaPorc = Math.Abs(Math.Round((infoCompra.Iva * 100) / infoCompra.MontoImponible, 0));
                                                    infoCompra.RetencionIvaPorc = Math.Abs(Math.Round((infoCompra.RetencionIva * 100) / infoCompra.Iva, 0));
                                                } catch
                                                {
                                                    // prevenimos contra una posible división por cero 
                                                    var message = $"Error: por favor revise la factura número: <em>{infoCompra.NumeroDocumento}</em>, " +
                                                                  $"que corresponde a la compañía: <em>{infoCompra.Compania_Nombre}</em>.<br /> " +
                                                                  $"Es probable que, aunque la misma corresponda a una factura con monto de impuestos Iva, no tenga " +
                                                                  $"todos sus datos inicializados en forma correcta.<br />" +
                                                                  $"Por ejemplo, tal vez la factura no tenga un monto de impuestos Iva o, aunque tenga un porcentaje de retención de " +
                                                                  $"impuestos, no tenga el monto que corresponde al mismo, etc.";
                                                    this.ErrMessage_Cell.InnerHtml = message;
                                                    return; 
                                                }

                                                myList.Add(infoCompra);
                                                agregueUnRegistroALaLista = true; 
                                            }

                                            if (compra.BaseImponible_General != null && compra.BaseImponible_General != 0)
                                            {
                                                infoCompra = new Factura_LibroCompra();

                                                infoCompra.CiaContab_Nombre = compra.CiaContabNombre;
                                                infoCompra.CiaContab_Rif = compra.CiaContabRif;
                                                infoCompra.FechaDocumento = compra.FechaRecepcion;
                                                infoCompra.NumeroDocumento = compra.NumeroFactura;
                                                infoCompra.NumeroControl = compra.NumeroControl;
                                                infoCompra.Compania_Nombre = compra.NombreCompania;
                                                infoCompra.Compania_Rif = compra.RifCompania;

                                                infoCompra.Compra_NotaCredito = compra.NcNdFlag == "NC" ? "Notas de crédito" : "Compras";

                                                infoCompra.TipoDocumento = string.IsNullOrEmpty(compra.NcNdFlag) ? "Fact" : compra.NcNdFlag;
                                                infoCompra.DocumentoAfectado = compra.NumeroFacturaAfectada;

                                                if (!string.IsNullOrEmpty(compra.NumeroComprobante))
                                                {
                                                    infoCompra.ComprobanteSeniat = compra.NumeroComprobante;
                                                    if (compra.NumeroOperacion != null && compra.NumeroOperacion.Value != 0)
                                                        infoCompra.ComprobanteSeniat += "/" + compra.NumeroOperacion.Value.ToString();
                                                }

                                                infoCompra.Importacion_CompraNacional =
                                                    compra.ImportacionFlag != null && compra.ImportacionFlag.Value ? "Importaciones" : "Compras nacionales";

                                                infoCompra.PlanillaImportacion = compra.NumeroPlanillaImportacion;

                                                infoCompra.TotalComprasIncIva = 0;
                                                if (compra.MontoFacturaSinIva != null)
                                                    infoCompra.TotalComprasIncIva = compra.MontoFacturaSinIva.Value;

                                                if (compra.MontoFacturaConIva != null)
                                                    infoCompra.TotalComprasIncIva += compra.MontoFacturaConIva.Value;

                                                if (compra.Iva != null)
                                                    infoCompra.TotalComprasIncIva += compra.Iva.Value;

                                                infoCompra.MontoNoImponible = compra.MontoFacturaSinIva != null ? compra.MontoFacturaSinIva.Value : 0;

                                                if (agregueUnRegistroALaLista)
                                                {
                                                    // el total (incluye Iva) y el monto no imponible solo se muestra para el 1er. registro (puede haber hasta 3) 
                                                    infoCompra.TotalComprasIncIva = 0;
                                                    infoCompra.MontoNoImponible = 0; 
                                                }

                                                infoCompra.MontoImponible = 0;
                                                infoCompra.IvaPorc = 0;
                                                infoCompra.RetencionIvaPorc = 0;
                                                infoCompra.RetencionIva = 0;

                                                // ahora sigue la información propia del monto Iva, para el tipo de alícuota en particular 
                                                infoCompra.MontoImponible = compra.BaseImponible_General.Value;
                                                infoCompra.Iva = compra.Iva_General != null ? compra.Iva_General.Value : 0;
                                                infoCompra.RetencionIva = compra.ImpuestoRetenido_General != null ? compra.ImpuestoRetenido_General.Value : 0;

                                                try
                                                {
                                                    infoCompra.IvaPorc = Math.Abs(Math.Round((infoCompra.Iva * 100) / infoCompra.MontoImponible, 0));
                                                    infoCompra.RetencionIvaPorc = Math.Abs(Math.Round((infoCompra.RetencionIva * 100) / infoCompra.Iva, 0));
                                                }
                                                catch
                                                {
                                                    // prevenimos contra una posible división por cero 
                                                    var message = $"Error: por favor revise la factura número: <em>{infoCompra.NumeroDocumento}</em>, " +
                                                                  $"que corresponde a la compañía: <em>{infoCompra.Compania_Nombre}</em>.<br /> " +
                                                                  $"Es probable que, aunque la misma corresponda a una factura con monto de impuestos Iva, no tenga " +
                                                                  $"todos sus datos inicializados en forma correcta.<br />" +
                                                                  $"Por ejemplo, tal vez la factura no tenga un monto de impuestos Iva o, aunque tenga un porcentaje de retención de " +
                                                                  $"impuestos, no tenga el monto que corresponde al mismo, etc.";
                                                    this.ErrMessage_Cell.InnerHtml = message;
                                                    return;
                                                }

                                                myList.Add(infoCompra);
                                                agregueUnRegistroALaLista = true;
                                            }

                                            if (compra.BaseImponible_Adicional != null && compra.BaseImponible_Adicional != 0)
                                            {
                                                infoCompra = new Factura_LibroCompra();

                                                infoCompra.CiaContab_Nombre = compra.CiaContabNombre;
                                                infoCompra.CiaContab_Rif = compra.CiaContabRif;
                                                infoCompra.FechaDocumento = compra.FechaRecepcion;
                                                infoCompra.NumeroDocumento = compra.NumeroFactura;
                                                infoCompra.NumeroControl = compra.NumeroControl;
                                                infoCompra.Compania_Nombre = compra.NombreCompania;
                                                infoCompra.Compania_Rif = compra.RifCompania;

                                                infoCompra.Compra_NotaCredito = compra.NcNdFlag == "NC" ? "Notas de crédito" : "Compras";

                                                infoCompra.TipoDocumento = string.IsNullOrEmpty(compra.NcNdFlag) ? "Fact" : compra.NcNdFlag;
                                                infoCompra.DocumentoAfectado = compra.NumeroFacturaAfectada;

                                                if (!string.IsNullOrEmpty(compra.NumeroComprobante))
                                                {
                                                    infoCompra.ComprobanteSeniat = compra.NumeroComprobante;
                                                    if (compra.NumeroOperacion != null && compra.NumeroOperacion.Value != 0)
                                                        infoCompra.ComprobanteSeniat += "/" + compra.NumeroOperacion.Value.ToString();
                                                }

                                                infoCompra.Importacion_CompraNacional =
                                                    compra.ImportacionFlag != null && compra.ImportacionFlag.Value ? "Importaciones" : "Compras nacionales";

                                                infoCompra.PlanillaImportacion = compra.NumeroPlanillaImportacion;

                                                infoCompra.TotalComprasIncIva = 0;
                                                if (compra.MontoFacturaSinIva != null)
                                                    infoCompra.TotalComprasIncIva = compra.MontoFacturaSinIva.Value;

                                                if (compra.MontoFacturaConIva != null)
                                                    infoCompra.TotalComprasIncIva += compra.MontoFacturaConIva.Value;

                                                if (compra.Iva != null)
                                                    infoCompra.TotalComprasIncIva += compra.Iva.Value;

                                                infoCompra.MontoNoImponible = compra.MontoFacturaSinIva != null ? compra.MontoFacturaSinIva.Value : 0;

                                                infoCompra.MontoImponible = 0;
                                                infoCompra.IvaPorc = 0;
                                                infoCompra.RetencionIvaPorc = 0;
                                                infoCompra.RetencionIva = 0;

                                                if (agregueUnRegistroALaLista)
                                                {
                                                    // el total (incluye Iva) y el monto no imponible solo se muestra para el 1er. registro (puede haber hasta 3) 
                                                    infoCompra.TotalComprasIncIva = 0;
                                                    infoCompra.MontoNoImponible = 0;
                                                }

                                                // ahora sigue la información propia del monto Iva, para el tipo de alícuota en particular 
                                                infoCompra.MontoImponible = compra.BaseImponible_Adicional.Value;
                                                infoCompra.Iva = compra.Iva_Adicional != null ? compra.Iva_Adicional.Value : 0;
                                                infoCompra.RetencionIva = compra.ImpuestoRetenido_Adicional != null ? compra.ImpuestoRetenido_Adicional.Value : 0;

                                                try
                                                {
                                                    infoCompra.IvaPorc = Math.Abs(Math.Round((infoCompra.Iva * 100) / infoCompra.MontoImponible, 0));
                                                    infoCompra.RetencionIvaPorc = Math.Abs(Math.Round((infoCompra.RetencionIva * 100) / infoCompra.Iva, 0));
                                                }
                                                catch
                                                {
                                                    // prevenimos contra una posible división por cero 
                                                    var message = $"Error: por favor revise la factura número: <em>{infoCompra.NumeroDocumento}</em>, " +
                                                                  $"que corresponde a la compañía: <em>{infoCompra.Compania_Nombre}</em>.<br /> " +
                                                                  $"Es probable que, aunque la misma corresponda a una factura con monto de impuestos Iva, no tenga " +
                                                                  $"todos sus datos inicializados en forma correcta.<br />" +
                                                                  $"Por ejemplo, tal vez la factura no tenga un monto de impuestos Iva o, aunque tenga un porcentaje de retención de " +
                                                                  $"impuestos, no tenga el monto que corresponde al mismo, etc.";
                                                    this.ErrMessage_Cell.InnerHtml = message;
                                                    return;
                                                }

                                                myList.Add(infoCompra);
                                                agregueUnRegistroALaLista = true; 
                                            }


                                            if (!agregueUnRegistroALaLista)
                                            {
                                                // no hay Iva ni retención sobre Iva ... 
                                                infoCompra = new Factura_LibroCompra();

                                                infoCompra.CiaContab_Nombre = compra.CiaContabNombre;
                                                infoCompra.CiaContab_Rif = compra.CiaContabRif;
                                                infoCompra.FechaDocumento = compra.FechaRecepcion;
                                                infoCompra.NumeroDocumento = compra.NumeroFactura;
                                                infoCompra.NumeroControl = compra.NumeroControl;
                                                infoCompra.Compania_Nombre = compra.NombreCompania;
                                                infoCompra.Compania_Rif = compra.RifCompania;

                                                infoCompra.Compra_NotaCredito = compra.NcNdFlag == "NC" ? "Notas de crédito" : "Compras";

                                                infoCompra.TipoDocumento = string.IsNullOrEmpty(compra.NcNdFlag) ? "Fact" : compra.NcNdFlag;
                                                infoCompra.DocumentoAfectado = compra.NumeroFacturaAfectada;

                                                if (!string.IsNullOrEmpty(compra.NumeroComprobante))
                                                {
                                                    infoCompra.ComprobanteSeniat = compra.NumeroComprobante;
                                                    if (compra.NumeroOperacion != null && compra.NumeroOperacion.Value != 0)
                                                        infoCompra.ComprobanteSeniat += "/" + compra.NumeroOperacion.Value.ToString();
                                                }

                                                infoCompra.Importacion_CompraNacional =
                                                    compra.ImportacionFlag != null && compra.ImportacionFlag.Value ? "Importaciones" : "Compras nacionales";

                                                infoCompra.PlanillaImportacion = compra.NumeroPlanillaImportacion;

                                                infoCompra.TotalComprasIncIva = 0;
                                                if (compra.MontoFacturaSinIva != null)
                                                    infoCompra.TotalComprasIncIva = compra.MontoFacturaSinIva.Value;

                                                infoCompra.MontoNoImponible = compra.MontoFacturaSinIva != null ? compra.MontoFacturaSinIva.Value : 0;

                                                infoCompra.MontoImponible = 0;
                                                infoCompra.IvaPorc = 0;
                                                infoCompra.RetencionIvaPorc = 0;
                                                infoCompra.RetencionIva = 0; 

                                                myList.Add(infoCompra);
                                            }
                                        }

                                        // solo si este proceso no selecciona ningún registro, agregamos uno con ceros, para que el reporte 
                                        // muestre el resumen, aunque sin montos ... 
                                        if (myList.Count == 0)
                                        {
                                            infoCompra = new Factura_LibroCompra();

                                            infoCompra.CiaContab_Nombre = "";
                                            infoCompra.CiaContab_Rif = "";
                                            infoCompra.FechaDocumento = null; 
                                            infoCompra.NumeroDocumento = "";
                                            infoCompra.NumeroControl = "";
                                            infoCompra.Compania_Nombre = "";
                                            infoCompra.Compania_Rif = "";

                                            infoCompra.Compra_NotaCredito = "Compras";

                                            infoCompra.TipoDocumento = "";
                                            infoCompra.DocumentoAfectado = "";
                                            infoCompra.ComprobanteSeniat = "";
                                            infoCompra.Importacion_CompraNacional = "Compras nacionales"; 

                                            infoCompra.PlanillaImportacion = "";

                                            infoCompra.TotalComprasIncIva = 0;
                                            infoCompra.MontoNoImponible = 0;
                                            infoCompra.MontoImponible = 0;
                                            infoCompra.IvaPorc = 0;
                                            infoCompra.Iva = 0;
                                            infoCompra.RetencionIvaPorc = 0;
                                            infoCompra.RetencionIva = 0;

                                            myList.Add(infoCompra);
                                        }

                                        this.ReportViewer1.LocalReport.ReportPath = "Bancos/Consultas facturas/Facturas/Facturas_LibroCompras.rdlc";

                                        ReportDataSource myReportDataSource = new ReportDataSource();

                                        myReportDataSource.Name = "DataSet1";
                                        myReportDataSource.Value = myList;

                                        this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                                        this.ReportViewer1.LocalReport.Refresh();

                                        // accedemos y pasamos los parámetros al reporte ... 

                                        string titulo = "";
                                        string subTitulo = "";
                                        string ciaContabNombre = "";
                                        string ciaContabRif = "";
                                        string periodo = "";

                                        if (Request.QueryString["tit"] != null)
                                            titulo = Request.QueryString["tit"].ToString();

                                        if (Request.QueryString["subtit"] != null)
                                            subTitulo = Request.QueryString["subtit"].ToString();

                                        if (Request.QueryString["nombre"] != null)
                                            ciaContabNombre = Server.UrlDecode(Request.QueryString["nombre"]);

                                        if (Request.QueryString["rif"] != null)
                                            ciaContabRif = Request.QueryString["rif"].ToString();

                                        if (Request.QueryString["per"] != null)
                                            periodo = Request.QueryString["per"].ToString();

                                        ReportParameter titulo_ReportParameter = new ReportParameter("Titulo", titulo);
                                        ReportParameter subTitulo_ReportParameter = new ReportParameter("Subtitulo", subTitulo);
                                        ReportParameter ciaContabNombre_ReportParameter = new ReportParameter("CiaContabNombre", ciaContabNombre);
                                        ReportParameter ciaContabRif_ReportParameter = new ReportParameter("CiaContabRif", ciaContabRif);
                                        ReportParameter periodo_ReportParameter = new ReportParameter("Periodo", periodo);

                                        ReportParameter[] MyReportParameters = 
                                        { 
                                            titulo_ReportParameter, 
                                            subTitulo_ReportParameter, 
                                            ciaContabNombre_ReportParameter, 
                                            ciaContabRif_ReportParameter, 
                                            periodo_ReportParameter 
                                        };

                                        this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                                        break;

                                    }
                                case "4":
                                    {
                                        // Libro de Ventas
                                        ReporteFacturas_DataSet MyReportDataSet = new ReporteFacturas_DataSet();
                                        LibroVentasTableAdapter MyReportTableAdapter = new LibroVentasTableAdapter();

                                        MyReportTableAdapter.FillByNombreUsuario(MyReportDataSet.LibroVentas, Membership.GetUser().UserName);

                                        if (MyReportDataSet.LibroVentas.Rows.Count == 0)
                                        {
                                            ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
                                            return;
                                        }

                                        this.ReportViewer1.LocalReport.ReportPath = "Bancos/Consultas facturas/Facturas/Facturas_LibroVentas.rdlc";

                                        ReportDataSource myReportDataSource = new ReportDataSource();

                                        myReportDataSource.Name = "ReporteFacturas_DataSet_LibroVentas";
                                        myReportDataSource.Value = MyReportDataSet.LibroVentas;

                                        this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                                        this.ReportViewer1.LocalReport.Refresh();

                                        string sSubTitle_ReportParameter = "";

                                        if (!(Session["Report_SubTitle"] == null))
                                        {
                                            sSubTitle_ReportParameter = Session["Report_SubTitle"].ToString();
                                        }


                                        ReportParameter SubTitle_ReportParameter = new ReportParameter("SubTitle", sSubTitle_ReportParameter);

                                        ReportParameter[] MyReportParameters = { SubTitle_ReportParameter };

                                        this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                                        break;
                                    }

                                case "5":
                                    {
                                        // Iva: comprobantes de retención .... 

                                        BancosEntities context = new BancosEntities();

                                        var query = context.tTempWebReport_ConsultaFacturas.Where("it.NombreUsuario == '" + User.Identity.Name + "'");

                                        if (query.Count() == 0)
                                        {
                                            ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte " +
                                                "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                                "filtro y seleccionado información aún.";
                                            return;
                                        }

                                        string fechaToday = "";

                                        if (Request.QueryString["ciudad"] != null)
                                            fechaToday = Request.QueryString["ciudad"].ToString() + ", ";

                                        if (Request.QueryString["fecha"] != null)
                                            fechaToday += Request.QueryString["fecha"].ToString();

                                        // ---------------------------------------------------------------------------------------------------------------
                                        // buscamos los archivos que contienen las imagenes; si no existen, inicializamos los parametros en empty strings ... 

                                        // nota: ya sabemos que el query trae registros y que la compañía (CiaContab) existe ... 
                                        int cia = query.First().CiaContab;
                                        string nombreCiaContab = context.Companias.Where(c => c.Numero == cia).FirstOrDefault().Abreviatura;

                                        string logoSuperiorImageAddress = "";
                                        string firmaImageAddress = "";

                                        string path = Server.MapPath("Pictures/" + nombreCiaContab + "/LogoSuperior.png");

                                        if (File.Exists(path))
                                            logoSuperiorImageAddress = path; 


                                        path = Server.MapPath("Pictures/" + nombreCiaContab + "/SelloYFirma.png");

                                        if (File.Exists(path))
                                            firmaImageAddress = path;
                                        // ---------------------------------------------------------------------------------------------------------------
                                        // ahora preparamos una lista para usarla como DataSource del report ... 

                                        List<Factura_ComprobanteRetencionIva> listRetencionesIva;
                                        listRetencionesIva = ConstruirListaRetencionesIvaProveedores(context, User.Identity.Name, fechaToday); 

                                        this.ReportViewer1.LocalReport.ReportPath = "Bancos/Consultas facturas/Facturas/ComprobanteRetencionIva.rdlc";
                                        this.ReportViewer1.LocalReport.Refresh();

                                        ReportDataSource myReportDataSource = new ReportDataSource();

                                        myReportDataSource.Name = "DataSet1";
                                        myReportDataSource.Value = listRetencionesIva;

                                        this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                                        this.ReportViewer1.LocalReport.EnableExternalImages = true;

                                        ReportParameter FechaConsulta_ReportParameter = new ReportParameter("FechaHoy", fechaToday);
                                        ReportParameter LogoSuperiorAddress_ReportParameter = new ReportParameter("LogoSuperior_Address", logoSuperiorImageAddress);
                                        ReportParameter FirmaYSello_ReportParameter = new ReportParameter("Firma_Address", firmaImageAddress);

                                        ReportParameter[] MyReportParameters = 
                                        { 
                                            FechaConsulta_ReportParameter, 
                                            LogoSuperiorAddress_ReportParameter, 
                                            FirmaYSello_ReportParameter 
                                        };

                                        this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                                        break;
                                    }

                                case "6":                   // comprobantes Iva en pdf ... 
                                    {
                                        BancosEntities context = new BancosEntities();

                                        var query = context.tTempWebReport_ConsultaFacturas.Where("it.NombreUsuario == '" + User.Identity.Name + "'");

                                        if (query.Count() == 0)
                                        {
                                            ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte " +
                                                "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                                "filtro y seleccionado información aún.";
                                            return;
                                        }

                                        string fechaToday = "";

                                        if (Request.QueryString["ciudad"] != null)
                                            fechaToday = Request.QueryString["ciudad"].ToString() + ", ";

                                        if (Request.QueryString["fecha"] != null)
                                            fechaToday += Request.QueryString["fecha"].ToString();

                                        // ---------------------------------------------------------------------------------------------------------------
                                        // buscamos los archivos que contienen las imagenes; si no existen, inicializamos los parametros en empty strings ... 

                                        // nota: ya sabemos que el query trae registros y que la compañía (CiaContab) existe ... 
                                        int cia = query.First().CiaContab;
                                        string nombreCiaContab = context.Companias.Where(c => c.Numero == cia).FirstOrDefault().Abreviatura;

                                        string logoSuperiorImageAddress = "";
                                        string firmaImageAddress = "";

                                        string path = Server.MapPath("Pictures/" + nombreCiaContab + "/LogoSuperior.png");

                                        if (File.Exists(path))
                                            logoSuperiorImageAddress = path;


                                        path = Server.MapPath("Pictures/" + nombreCiaContab + "/SelloYFirma.png");

                                        if (File.Exists(path))
                                            firmaImageAddress = path;
                                        // ---------------------------------------------------------------------------------------------------------------

                                        // ahora preparamos una lista para usarla como DataSource del report ... 
                                        List<Factura_ComprobanteRetencionIva> listRetencionesIva;
                                        listRetencionesIva = ConstruirListaRetencionesIvaProveedores(context, User.Identity.Name, fechaToday); 

                                        this.ReportViewer1.LocalReport.ReportPath = "Bancos/Consultas facturas/Facturas/ComprobanteRetencionIva.rdlc";
                                        this.ReportViewer1.LocalReport.EnableExternalImages = true; 

                                        ReportDataSource myReportDataSource = new ReportDataSource();

                                        myReportDataSource.Name = "DataSet1";
                                        myReportDataSource.Value = listRetencionesIva;

                                        this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                                        ReportParameter FechaConsulta_ReportParameter = new ReportParameter("FechaHoy", fechaToday);
                                        ReportParameter LogoSuperiorAddress_ReportParameter = new ReportParameter("LogoSuperior_Address", logoSuperiorImageAddress);
                                        ReportParameter FirmaYSello_ReportParameter = new ReportParameter("Firma_Address", firmaImageAddress);

                                        ReportParameter[] MyReportParameters = 
                                        { 
                                            FechaConsulta_ReportParameter, 
                                            LogoSuperiorAddress_ReportParameter, 
                                            FirmaYSello_ReportParameter 
                                        };
                                        this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                                        this.ReportViewer1.LocalReport.Refresh();

                                        Warning[] warnings;
                                        string[] streamIds;
                                        string mimeType = string.Empty;
                                        string encoding = string.Empty;
                                        string extension = string.Empty;

                                        byte[] bytes = this.ReportViewer1.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);

                                        // Now that you have all the bytes representing the PDF report, buffer it and send it to the client.
                                        Response.Buffer = true;
                                        Response.Clear();
                                        Response.ContentType = mimeType;
                                        Response.AddHeader("content-disposition", "attachment; filename=CompRetIva.pdf");
                                        Response.BinaryWrite(bytes); // create the file
                                        Response.Flush(); // send it to the client to download

                                        break;
                                    }

                                case "7":                   // escribimos los comprobantes de retención iva al disco e intentamos generar correos para éstos ... 
                                    {
                                        // el directorio que usamos es Temp/<nombre del usuario>; lo creamos si no existe ... (Temp debe siempre existir ...) 

                                        string userName = Membership.GetUser().UserName;
                                        string path = Server.MapPath("Temp/ComprobantesRetencionIva/" + userName);

                                        System.IO.Directory.CreateDirectory(path);      // creamos el directorio si no existe ... 

                                        // eliminamos los archivos que puedan existir ... 
                                        string[] filePaths = Directory.GetFiles(@path);
                                        foreach (string filePath in filePaths)
                                            File.Delete(filePath);

                                        // obtenemos el correo del usuario ... 

                                        bool enviarEmailUsuario = false;
                                        string usuarioEmail = "";

                                        bool enviarEmailCompania = false;

                                        if (Request.QueryString["usuario"] != null && Request.QueryString["usuario"] == "si")
                                            enviarEmailUsuario = true;

                                        if (Request.QueryString["compania"] != null && Request.QueryString["compania"] == "si")
                                            enviarEmailCompania = true;

                                        if (!enviarEmailCompania && !enviarEmailUsuario)
                                        {
                                            ErrMessage_Cell.InnerHtml = "Ud. debe indicar si desea enviar correos a la compañía o el usuario.<br />" +
                                                    "Por favor seleccione, al menos, una de las opciones anteriores.";
                                            return;
                                        }

                                        
                                        MembershipUser member = Membership.GetUser(User.Identity.Name);
                                        usuarioEmail = member.Email;

                                        if (string.IsNullOrEmpty(usuarioEmail))
                                        {
                                            ErrMessage_Cell.InnerHtml = "El usuario '" + User.Identity.Name + "' no tiene una dirección de correo registrada.<br />" +
                                                "Por favor registre una dirección de correo para este usuario.";
                                            return;
                                        }

                                        
                                        // agregamos un archivo para cada proveedor ... 

                                        BancosEntities context = new BancosEntities();

                                        // -------------------------------------------------------------------------------------------------------
                                        // verificamos que cada proveedor tenga una persona 'default' con su e-mail ... 

                                        var query0 = from f in context.tTempWebReport_ConsultaFacturas
                                                    where f.NombreUsuario == User.Identity.Name
                                                    group f by new { f.Compania, f.NombreCompania } into g
                                                    select new { Proveedor = g.Key.Compania, NombreProveedor = g.Key.NombreCompania };

                                        foreach (var p in query0)
                                        {
                                            Persona persona = context.Personas.Where(x => x.Compania == p.Proveedor && x.DefaultFlag != null && x.DefaultFlag.Value).
                                                                      FirstOrDefault(); 

                                            if (persona == null || string.IsNullOrEmpty(persona.email))
                                            {
                                                ErrMessage_Cell.InnerHtml = "La compañía '" + p.NombreProveedor + "' no tiene una persona asociada, " +
                                                    "o ninguna de sus personas esta registrada como 'defecto', o la persona registrada como 'defecto' " + 
                                                    "no tiene una dirección de correo registrada.";
                                                return;
                                            }
                                        }
                                        // -------------------------------------------------------------------------------------------------------


                                        var query = from f in context.tTempWebReport_ConsultaFacturas
                                                    where f.NombreUsuario == User.Identity.Name
                                                    group f by f.NombreCompania into g
                                                    select new { Proveedor = g.Key, facturas = g }; 

                                        if (query.Count() == 0)
                                        {
                                            ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte " +
                                                "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                                "filtro y seleccionado información aún.";
                                            return;
                                        }

                                        // -----------------------------------------------------------------------------------------
                                        // la compañía debe tener la configuración necesaria para enviar correos ... 

                                        int ciaContabID = query.First().facturas.FirstOrDefault().CiaContab;

                                        ContabSysNet_Web.ModelosDatos_EF.Bancos.Compania ciaContab = 
                                            context.Companias.Where(c => c.Numero == ciaContabID).FirstOrDefault();

                                        if (ciaContab == null ||
                                            string.IsNullOrEmpty(ciaContab.EmailServerName) ||
                                            string.IsNullOrEmpty(ciaContab.EmailServerCredentialsUserName) ||
                                            string.IsNullOrEmpty(ciaContab.EmailServerCredentialsPassword))
                                        {
                                            ErrMessage_Cell.InnerHtml = "Aparentemente, no se ha registrado la configuración necesaria para enviar correos, " +
                                                "para la compañía (CiaContab) usada al seleccionar los registros.<br /><br />" +
                                                "Por favor revise el registro para la compañía (CiaContab) en la tabla Compañías y defina la " + 
                                                "configuración necesaria para enviar e-mails.";
                                            return;
                                        }

                                        string host = ciaContab.EmailServerName;
                                        int? port = ciaContab.EmailServerPort;
                                        bool enableSSL = ciaContab.EmailServerSSLFlag != null ? ciaContab.EmailServerSSLFlag.Value : false;
                                        string emailCredentialsUserName = ciaContab.EmailServerCredentialsUserName;
                                        string emailCredentialsUserPassword = ciaContab.EmailServerCredentialsPassword;

                                        // ahora que tenemos la configuración para enviar los correos, vamos a inicializar una clase que permite 
                                        // hacerlo ... 

                                        SendEmail sendMail = new SendEmail(host, port, enableSSL, emailCredentialsUserName, emailCredentialsUserPassword); 
                                        // -----------------------------------------------------------------------------------------


                                        string fechaToday = "";

                                        if (Request.QueryString["ciudad"] != null)
                                            fechaToday = Request.QueryString["ciudad"].ToString() + ", ";

                                        if (Request.QueryString["fecha"] != null)
                                            fechaToday += Request.QueryString["fecha"].ToString();

                                        string firmaEmail1 = "";
                                        string firmaEmail2 = "";
                                        string firmaEmail3 = "";
                                        string firmaEmail4 = "";
                                        string firmaEmail5 = "";

                                        if (Request.QueryString["l1"] != null)
                                            firmaEmail1 = Request.QueryString["l1"].ToString();

                                        if (Request.QueryString["l2"] != null)
                                            firmaEmail2 = Request.QueryString["l2"].ToString();

                                        if (Request.QueryString["l3"] != null)
                                            firmaEmail3 = Request.QueryString["l3"].ToString();

                                        if (Request.QueryString["l4"] != null)
                                            firmaEmail4 = Request.QueryString["l4"].ToString();

                                        if (Request.QueryString["l5"] != null)
                                            firmaEmail5 = Request.QueryString["l5"].ToString();

                                        // ---------------------------------------------------------------------------------------------------------------
                                        // buscamos los archivos que contienen las imagenes; si no existen, inicializamos los parametros en empty strings ... 

                                        // nota: ya sabemos que el query trae registros y que la compañía (CiaContab) existe ... 
                                        string nombreCiaContab = context.Companias.Where(c => c.Numero == ciaContabID).FirstOrDefault().Abreviatura;

                                        string logoSuperiorImageAddress = "";
                                        string firmaImageAddress = "";

                                        if (File.Exists(Server.MapPath("Pictures/" + nombreCiaContab + "/LogoSuperior.png")))
                                            logoSuperiorImageAddress = Server.MapPath("Pictures/" + nombreCiaContab + "/LogoSuperior.png");

                                        if (File.Exists(Server.MapPath("Pictures/" + nombreCiaContab + "/SelloYFirma.png")))
                                            firmaImageAddress = Server.MapPath("Pictures/" + nombreCiaContab + "/SelloYFirma.png");
                                        // ---------------------------------------------------------------------------------------------------------------
 
                                        foreach (var prov in query)
                                        {
                                            int proveedor = 0;
                                            int ciacontab = 0;
                                            List<Factura_ComprobanteRetencionIva> listRetencionesIva = null;

                                            var factura = prov.facturas.First();

                                            proveedor = factura.Compania;
                                            ciacontab = factura.CiaContab;

                                            // ahora preparamos una lista para usarla como DataSource del report ... 
                                            // nótese com esta vez, vamos obteniendo la lista para cada proveedor diferente ... 
                                            listRetencionesIva = ConstruirListaRetencionesIvaProveedores(context, User.Identity.Name, fechaToday, proveedor); 

                                            //foreach (tTempWebReport_ConsultaFacturas factura in 
                                            //    prov.facturas.OrderBy(f => f.NumeroComprobante).ThenBy(f => f.NumeroOperacion))
                                            //{
                                            //    proveedor = factura.Compania;
                                            //    ciacontab = factura.CiaContab;

                                            //    // ahora preparamos una lista para usarla como DataSource del report ... 
                                            //    // nótese com esta vez, vamos obteniendo la lista para cada proveedor diferente ... 
                                            //    listRetencionesIva = ConstruirListaRetencionesIvaProveedores(context, User.Identity.Name, fechaToday, proveedor); 
                                            //}

                                            // cada vez que cambia el proveedor, escribimos un archivo al disco; el nombre del archivo es el nombre del 
                                            // proveedor 

                                            this.ReportViewer1 = new Microsoft.Reporting.WebForms.ReportViewer(); 

                                            this.ReportViewer1.LocalReport.ReportPath = "Bancos/Consultas facturas/Facturas/ComprobanteRetencionIva.rdlc";
                                            this.ReportViewer1.LocalReport.EnableExternalImages = true; 

                                            ReportDataSource myReportDataSource = new ReportDataSource();

                                            myReportDataSource.Name = "DataSet1";
                                            myReportDataSource.Value = listRetencionesIva;

                                            this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                                            ReportParameter FechaConsulta_ReportParameter = new ReportParameter("FechaHoy", fechaToday);
                                            ReportParameter LogoSuperiorAddress_ReportParameter = new ReportParameter("LogoSuperior_Address", logoSuperiorImageAddress);
                                            ReportParameter FirmaYSello_ReportParameter = new ReportParameter("Firma_Address", firmaImageAddress);

                                            ReportParameter[] MyReportParameters = 
                                            { 
                                                FechaConsulta_ReportParameter, 
                                                LogoSuperiorAddress_ReportParameter, 
                                                FirmaYSello_ReportParameter 
                                            };
                                            this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                                            this.ReportViewer1.LocalReport.EnableExternalImages = true; 

                                            this.ReportViewer1.LocalReport.Refresh();

                                            Warning[] warnings;
                                            string[] streamIds;
                                            string mimeType = string.Empty;
                                            string encoding = string.Empty;
                                            string extension = string.Empty;

                                            byte[] bytes = this.ReportViewer1.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);


                                            FileStream oFileStream;
                                            string file = path + "/" + prov.Proveedor + "_" + proveedor.ToString() + "_" + ciacontab.ToString() + ".pdf";
                                            using (oFileStream = new FileStream(file, System.IO.FileMode.Create))
                                            {
                                                oFileStream.Write(bytes, 0, bytes.Length);
                                            }

                                            //oFileStream.Close();

                                            listRetencionesIva.Clear(); 
                                        }

                                        // finalmente, recorremos los archivos construídos y generamos y enviamos un correo para cada uno de ellos; 
                                        // nótese que cada archivo contiene en su nombre el id del proveedor y de la cia contab ... 

                                        filePaths = Directory.GetFiles(@path);
                                        string errorMessage; 

                                        foreach (string filePath in filePaths)
                                        {
                                            string[] words = filePath.Split('_');

                                            int proveedor;
                                            int ciacontab;        // quitamos la extensión (.pdf) 

                                            try
                                            {
                                                proveedor = Convert.ToInt32(words[1]);
                                                ciacontab = Convert.ToInt32(words[2].Substring(0, words[2].Length - 4));    // quitamos la extensión (.pdf) 
                                            }
                                            catch (Exception ex)
                                            {
                                                errorMessage = ex.Message;
                                                if (ex.InnerException != null)
                                                    errorMessage += ex.InnerException.Message;

                                                ErrMessage_Cell.InnerHtml = 
                                                    "Hemos obtenido un error al intentar tratar el nombre de archivo '" + filePath + "';<br />" + 
                                                    "probablemente, el nombre de archivo no está bien formado para ser tratado por el programa.";
                                                return;
                                            }

                                            // leemos el e-mail del proveedor
                                            Persona persona = context.Personas.Where(x => x.Compania == proveedor && x.DefaultFlag != null && x.DefaultFlag.Value).
                                                                      FirstOrDefault();

                                            if (persona == null || string.IsNullOrEmpty(persona.email))
                                            {
                                                // nota: ésto ya lo habíamos revisado arriba ... 
                                                ErrMessage_Cell.InnerHtml = "La compañía '" + proveedor + "' no tiene una persona asociada, " +
                                                    "o ninguna de sus personas esta registrada como 'defecto', o la persona registrada como 'defecto' " +
                                                    "no tiene una dirección de correo registrada.";
                                                return;
                                            }

                                            sendMail.FromAddress = usuarioEmail;

                                            if (enviarEmailCompania)
                                                sendMail.ToAddress = persona.email;
                                            else
                                                sendMail.ToAddress = usuarioEmail;

                                            if (enviarEmailCompania && enviarEmailUsuario)
                                                sendMail.CCAddress = usuarioEmail;

                                            sendMail.Subject = "Comprobante de retención de impuesto al valor agregado";

                                            StringBuilder mailBody = new StringBuilder();

                                            mailBody.Append("<b>" + persona.Titulo + " " + persona.Nombre + " " + persona.Apellido + "</b><br />"); 

                                            if (persona.tCargo != null)
                                                mailBody.Append("<b>" + persona.tCargo.Descripcion + "</b><br />");

                                            mailBody.Append("<b>" + persona.Proveedore.Nombre + "</b><br />" + "<br />");

                                            mailBody.Append("Por favor reciba, adjunto a este correo, el (los) <b><em>comprobante de retención de impuestos Iva</b></em> " + "<br />");
                                            mailBody.Append("que corresponden a facturas recibidas por nosotros de su compañía." + "<br />" + "<br />");
                                            mailBody.Append("Sin más que agregar, se despide, " + "<br />" + "<br />");

                                            if (!string.IsNullOrEmpty(firmaEmail1))
                                                mailBody.Append("<b>" + firmaEmail1 + "</b><br />");

                                            if (!string.IsNullOrEmpty(firmaEmail2))
                                                mailBody.Append(firmaEmail2 + "<br />");

                                            if (!string.IsNullOrEmpty(firmaEmail3))
                                                mailBody.Append(firmaEmail3 + "<br />");

                                            if (!string.IsNullOrEmpty(firmaEmail4))
                                                mailBody.Append(firmaEmail4 + "<br />");

                                            if (!string.IsNullOrEmpty(firmaEmail5))
                                                mailBody.Append(firmaEmail5); 


                                            sendMail.Body = mailBody.ToString();

                                            sendMail.AttachmentFileName = filePath; 

                                            errorMessage = "";

                                            if (!sendMail.Send(out errorMessage))
                                            {
                                                ErrMessage_Cell.InnerHtml = "Hemos obtenido un error al intentar enviar el e-mail:<br />" + errorMessage;
                                                return;
                                            }
                                        }

                                        break;
                                    }
                            }
                            break;
                        }

                    case "centroscosto":
                        {
                            // nótese que en session debe venir el filtro que usó el usuario 
                            if (Session["FiltroForma"] == null)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br />" +
                                    "Probablemente Ud. no ha aplicado un filtro aún, o la sesión ha caducado.";
                                return;
                            }

                            // leemos los parámetros del querystring 

                            string tituloReporte = "";
                            string subtituloReporte = "";
                            string color = "";
                            string format = "";
                            string orientation = "";
                            string simpleFont = "";
                            string soloTotales = ""; 

                            if (Request.QueryString["tit"] != null && !string.IsNullOrEmpty(Request.QueryString["tit"].ToString()))
                                tituloReporte = Request.QueryString["tit"].ToString();

                            if (Request.QueryString["subtit"] != null && !string.IsNullOrEmpty(Request.QueryString["subtit"].ToString()))
                                subtituloReporte = Request.QueryString["subtit"].ToString();

                            if (Request.QueryString["color"] != null && !string.IsNullOrEmpty(Request.QueryString["color"].ToString()))
                                color = Request.QueryString["color"].ToString();

                            if (Request.QueryString["format"] != null && !string.IsNullOrEmpty(Request.QueryString["format"].ToString()))
                                format = Request.QueryString["format"].ToString();

                            if (Request.QueryString["orientation"] != null && !string.IsNullOrEmpty(Request.QueryString["orientation"].ToString()))
                                orientation = Request.QueryString["orientation"].ToString();

                            if (Request.QueryString["simpleFont"] != null && !string.IsNullOrEmpty(Request.QueryString["simpleFont"].ToString()))
                                simpleFont = Request.QueryString["simpleFont"].ToString();

                            if (Request.QueryString["st"] != null && !string.IsNullOrEmpty(Request.QueryString["st"].ToString()))
                                soloTotales = Request.QueryString["st"].ToString();

                            string sqlFilter = Session["FiltroForma"].ToString();


                            dbContab_Contab_Entities db = new dbContab_Contab_Entities();

                            var query = db.dAsientos.Include("Asiento").
                                                     Include("Asiento.Moneda1").
                                                     Include("Asiento.Compania").
                                                     Include("CentrosCosto").
                                                     Include("CuentasContable").
                                                     Include("CuentasContable.tGruposContable").
                                                     Where(Session["FiltroForma"].ToString());

                            // ahora preparamos una lista para usarla como DataSource del report ... 

                            List<Contab_Report_ConsultaCentrosCosto> myList = new List<Contab_Report_ConsultaCentrosCosto>();
                            Contab_Report_ConsultaCentrosCosto infoCentroCosto;

                            int cantidadRegistros = 0;

                            foreach (var centroCosto in query)
                            {
                                infoCentroCosto = new Contab_Report_ConsultaCentrosCosto();

                                infoCentroCosto.Moneda = centroCosto.Asiento.Moneda1.Simbolo;
                                infoCentroCosto.CiaContab = centroCosto.Asiento.Compania.Nombre;
                                infoCentroCosto.CentroCosto = centroCosto.CentrosCosto != null ? centroCosto.CentrosCosto.Descripcion : " Sin centro de costo asignado";
                                infoCentroCosto.GrupoContable = centroCosto.CuentasContable.tGruposContable.Descripcion;
                                infoCentroCosto.CuentaContable = centroCosto.CuentasContable.CuentaEditada;
                                infoCentroCosto.Fecha = centroCosto.Asiento.Fecha;
                                infoCentroCosto.NombreCuentaContable = centroCosto.CuentasContable.Descripcion;
                                infoCentroCosto.DescripcionPartidaAsiento = centroCosto.Descripcion;

                                infoCentroCosto.NumeroComprobante = centroCosto.Asiento.Numero;

                                infoCentroCosto.Referencia = centroCosto.Referencia;
                                infoCentroCosto.ProvieneDe = centroCosto.Asiento.ProvieneDe;
                                infoCentroCosto.Debe = centroCosto.Debe;
                                infoCentroCosto.Haber = centroCosto.Haber;
                                infoCentroCosto.Saldo = centroCosto.Debe - centroCosto.Haber;

                                myList.Add(infoCentroCosto);
                                cantidadRegistros++;
                            }

                            if (cantidadRegistros == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte " +
                                    "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                    "filtro y seleccionado información aún.";
                                return;
                            }


                            if (orientation == "v")
                                this.ReportViewer1.LocalReport.ReportPath = "Contab/Consultas contables/Centros de costo/CentrosCosto_Portrait.rdlc";
                            else
                                this.ReportViewer1.LocalReport.ReportPath = "Contab/Consultas contables/Centros de costo/CentrosCosto_Landscape.rdlc";

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "DataSet1";
                            myReportDataSource.Value = myList;

                            this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            this.ReportViewer1.LocalReport.Refresh();

                            ReportParameter subTituloReportParameter = new ReportParameter("subTitulo", subtituloReporte);
                            ReportParameter tituloReportParameter = new ReportParameter("titulo", tituloReporte);
                            ReportParameter colorReportParameter = new ReportParameter("color", color);
                            ReportParameter simpleFontReportParameter = new ReportParameter("simpleFont", simpleFont);
                            ReportParameter soloTotalesReportParameter = new ReportParameter("soloTotales", soloTotales);

                            ReportParameter[] MyReportParameters = 
                            { 
                                subTituloReportParameter, 
                                tituloReportParameter,
                                colorReportParameter,
                                simpleFontReportParameter, 
                                soloTotalesReportParameter
                            };

                            this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                            this.ReportViewer1.LocalReport.Refresh();

                            if (format == "pdf")
                            {
                                Warning[] warnings;
                                string[] streamIds;
                                string mimeType = string.Empty;
                                string encoding = string.Empty;
                                string extension = string.Empty;

                                byte[] bytes = this.ReportViewer1.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);

                                // Now that you have all the bytes representing the PDF report, buffer it and send it to the client.
                                Response.Buffer = true;
                                Response.Clear();
                                Response.ContentType = mimeType;
                                Response.AddHeader("content-disposition", "attachment; filename=ComprobantesContables.pdf");
                                Response.BinaryWrite(bytes); // create the file
                                Response.Flush(); // send it to the client to download
                            }

                            break;
                        }

                    case "balancegeneral":
                        {
                            // Balance General / GyP

                            if (Session["BalanceGeneral_Parametros"] == null)
                            {
                                string errorMessage = "Aparentemente, Ud. no ha definido un filtro para esta consulta. Por favor defina un " + 
                                    "filtro para esta consulta antes de continuar.";

                                ErrMessage_Cell.InnerHtml = errorMessage;
                                return;
                            }

                            string usuario = User.Identity.Name;

                            string tituloReporte = "";
                            string subtituloReporte = "";
                            string color = "";
                            string format = "";
                            string orientation = "";
                            string simpleFont = "";
                            string soloTotales = "";
                            short cantNiveles = -1;         // este es el default (hasta el nivel detalle) 

                            if (Request.QueryString["tit"] != null && !string.IsNullOrEmpty(Request.QueryString["tit"].ToString()))
                                tituloReporte = Request.QueryString["tit"].ToString();

                            if (Request.QueryString["subtit"] != null && !string.IsNullOrEmpty(Request.QueryString["subtit"].ToString()))
                                subtituloReporte = Request.QueryString["subtit"].ToString();

                            if (Request.QueryString["color"] != null && !string.IsNullOrEmpty(Request.QueryString["color"].ToString()))
                                color = Request.QueryString["color"].ToString();

                            if (Request.QueryString["format"] != null && !string.IsNullOrEmpty(Request.QueryString["format"].ToString()))
                                format = Request.QueryString["format"].ToString();

                            if (Request.QueryString["orientation"] != null && !string.IsNullOrEmpty(Request.QueryString["orientation"].ToString()))
                                orientation = Request.QueryString["orientation"].ToString();

                            if (Request.QueryString["simpleFont"] != null && !string.IsNullOrEmpty(Request.QueryString["simpleFont"].ToString()))
                                simpleFont = Request.QueryString["simpleFont"].ToString();

                            if (Request.QueryString["st"] != null && !string.IsNullOrEmpty(Request.QueryString["st"].ToString()))
                                soloTotales = Request.QueryString["st"].ToString();

                            if (Request.QueryString["cantNiveles"] != null)
                                cantNiveles = Convert.ToInt16(Request.QueryString["cantNiveles"].ToString());

                            if (Request.QueryString["simboloMoneda"] != null)
                                cantNiveles = Convert.ToInt16(Request.QueryString["cantNiveles"].ToString());

                            dbContab_Contab_Entities db = new dbContab_Contab_Entities();

                            var query = db.Temp_Contab_Report_BalanceGeneral.Where("it.Usuario == '" + usuario + "'");

                            // ahora preparamos una lista para usarla como DataSource del report ... 

                            List<Contab_Report_BalanceGeneral> myList = new List<Contab_Report_BalanceGeneral>();
                            List<Contab_Report_BalanceGeneral> myList2 = new List<Contab_Report_BalanceGeneral>(); // usada cuenta el usuario quiere menos detalles ...
                            Contab_Report_BalanceGeneral reportItem;

                            int cantidadRegistros = 0;

                            string nombreCiaContab = "";
                            string simboloMoneda = "";
                            string nombreMoneda = "";
                            bool firstTime = true; 

                            foreach (var item in query)
                            {
                                if (firstTime)
                                {
                                    // leemos el nombre de algunas maestras; estos valores no cambian para todo el entitySet 

                                    ContabSysNet_Web.ModelosDatos_EF.Contab.Compania ciaContab = db.Companias.Where(c => c.Numero == item.CuentasContable.Compania.Numero).First();
                                    ContabSysNet_Web.ModelosDatos_EF.Contab.Moneda moneda = item.Moneda1;

                                    nombreCiaContab = ciaContab.Nombre;
                                    simboloMoneda = moneda.Simbolo;
                                    nombreMoneda = moneda.Descripcion;

                                    firstTime = false; 
                                }

                                reportItem = new Contab_Report_BalanceGeneral();

                                reportItem.NombreCiaContab = nombreCiaContab;
                                reportItem.SimboloMoneda = simboloMoneda; 
                                reportItem.NombreMoneda = nombreMoneda;

                                reportItem.CuentaContable = item.CuentaContable.Trim().Replace(" ", ""); // toma menos espacio mostrar la cuenta que la 'editada' ... 
                                reportItem.NombreCuentaContable = item.NombreCuentaContable.Trim(); 
                                reportItem.OrdenBalanceGeneral = item.OrdenBalanceGeneral.Value;
                                reportItem.CantidadNiveles = item.CantidadNiveles;

                                reportItem.Nivel1 = item.Nivel1.Trim(); ;
                                reportItem.NombreNivel1 = item.DescripcionNivel1.Trim(); ;

                                reportItem.Nivel2 = !string.IsNullOrEmpty(item.Nivel2) ? item.Nivel2.Trim() : "no nivel";
                                reportItem.NombreNivel2 = !string.IsNullOrEmpty(item.DescripcionNivel2) ? item.DescripcionNivel2.Trim() : "no nivel";

                                reportItem.Nivel3 = !string.IsNullOrEmpty(item.Nivel3) ? item.Nivel3.Trim() : "no nivel";
                                reportItem.NombreNivel3 = !string.IsNullOrEmpty(item.DescripcionNivel3) ? item.DescripcionNivel3.Trim() : "no nivel";

                                reportItem.Nivel4 = !string.IsNullOrEmpty(item.Nivel4) ? item.Nivel4.Trim() : "no nivel";
                                reportItem.NombreNivel4 = !string.IsNullOrEmpty(item.DescripcionNivel4) ? item.DescripcionNivel4.Trim() : "no nivel";

                                reportItem.Nivel5 = !string.IsNullOrEmpty(item.Nivel5) ? item.Nivel5.Trim() : "no nivel";
                                reportItem.NombreNivel5 = !string.IsNullOrEmpty(item.DescripcionNivel5) ? item.DescripcionNivel5.Trim() : "no nivel";

                                reportItem.Nivel6 = !string.IsNullOrEmpty(item.Nivel6) ? item.Nivel6.Trim() : "no nivel";
                                reportItem.NombreNivel6 = !string.IsNullOrEmpty(item.DescripcionNivel6) ? item.DescripcionNivel6.Trim() : "no nivel";

                                reportItem.SaldoInicial = item.MontoInicioPeriodo + item.SaldoAnterior;
                                reportItem.Debe = item.Debe;
                                reportItem.Haber = item.Haber;
                                reportItem.SaldoActual = item.SaldoActual;
                                reportItem.CantidadMovimientos = item.CantMovimientos;

                                myList.Add(reportItem);
                                cantidadRegistros++;
                            }

                            if (cantidadRegistros == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte " +
                                    "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                                    "filtro y seleccionado información aún.";
                                return;
                            }

                            // si el usuario quiere una cantidad de niveles menor, hacemos dos pasadas a la lista para convertir las cuentas
                            // que ahora son de detalle, al "nuevo" detalle que quiere el usuario ... 

                            // nótese que si el usuario quiere ver hasta el nivel detalle, simplemte no hacemos nada ... 

                            if (cantNiveles == -1)
                                goto defaultOption; 

                            // 1) convertimos las cuentas a la cantidad de niveles que quiere el usuario; es decir, cada cuenta es convertida al 
                            // nivel que indicó el usuario 

                            foreach (var item in myList)
                            {
                                if (cantNiveles == -2)
                                    // el usuario quiere ver las cuentas 1 nivel antes del detalle; restamos 1 al la cantidad de niveles y 
                                    // continuamos con el proceso, para que la cuenta sea convertida a esa cantidad de niveles ... 
                                    item.CantidadNiveles -= 1;
                                else
                                {
                                    // el usuario quiere ver una cantidad específica de niveles; cambiamos la cantidad de niveles de la cuenta 
                                    // a la cantidad que el usuario quiere ver y continuamos con el proceso ... 
                                    if (item.CantidadNiveles > cantNiveles)
                                    {
                                        item.CantidadNiveles = cantNiveles;
                                    }
                                    else
                                    {
                                        continue;
                                    }
                                }

                                switch (item.CantidadNiveles)
                                {
                                    case 1:
                                        {
                                            item.CuentaContable = item.Nivel1;
                                            item.NombreCuentaContable = item.NombreNivel1;

                                            //item.Nivel1 = "no nivel";
                                            //item.NombreNivel1 = "no nivel";

                                            item.Nivel2 = "no nivel";
                                            item.NombreNivel2 = "no nivel";

                                            item.Nivel3 = "no nivel";
                                            item.NombreNivel3 = "no nivel";

                                            item.Nivel4 = "no nivel";
                                            item.NombreNivel4 = "no nivel";

                                            item.Nivel5 = "no nivel";
                                            item.NombreNivel5 = "no nivel";

                                            item.Nivel6 = "no nivel";
                                            item.NombreNivel6 = "no nivel";

                                            break;
                                        }
                                    case 2:
                                        {
                                            item.CuentaContable = item.Nivel2;
                                            item.NombreCuentaContable = item.NombreNivel2;

                                            item.Nivel2 = "no nivel";
                                            item.NombreNivel2 = "no nivel";

                                            item.Nivel3 = "no nivel";
                                            item.NombreNivel3 = "no nivel";

                                            item.Nivel4 = "no nivel";
                                            item.NombreNivel4 = "no nivel";

                                            item.Nivel5 = "no nivel";
                                            item.NombreNivel5 = "no nivel";

                                            item.Nivel6 = "no nivel";
                                            item.NombreNivel6 = "no nivel";

                                            break;
                                        }
                                    case 3:
                                        {
                                            item.CuentaContable = item.Nivel3;
                                            item.NombreCuentaContable = item.NombreNivel3;

                                            item.Nivel3 = "no nivel";
                                            item.NombreNivel3 = "no nivel";

                                            item.Nivel4 = "no nivel";
                                            item.NombreNivel4 = "no nivel";

                                            item.Nivel5 = "no nivel";
                                            item.NombreNivel5 = "no nivel";

                                            item.Nivel6 = "no nivel";
                                            item.NombreNivel6 = "no nivel";

                                            break;
                                        }
                                    case 4:
                                        {
                                            item.CuentaContable = item.Nivel4;
                                            item.NombreCuentaContable = item.NombreNivel4;

                                            item.Nivel4 = "no nivel";
                                            item.NombreNivel4 = "no nivel";

                                            item.Nivel5 = "no nivel";
                                            item.NombreNivel5 = "no nivel";

                                            item.Nivel6 = "no nivel";
                                            item.NombreNivel6 = "no nivel";

                                            break;
                                        }
                                    case 5:
                                        {
                                            item.CuentaContable = item.Nivel5;
                                            item.NombreCuentaContable = item.NombreNivel5;

                                            item.Nivel5 = "no nivel";
                                            item.NombreNivel5 = "no nivel";

                                            item.Nivel6 = "no nivel";
                                            item.NombreNivel6 = "no nivel";

                                            break;
                                        }
                                    case 6:
                                        {
                                            item.CuentaContable = item.Nivel6;
                                            item.NombreCuentaContable = item.NombreNivel6;

                                            item.Nivel6 = "no nivel";
                                            item.NombreNivel6 = "no nivel";

                                            break;
                                        }
                                }

                            }


                            // ----------------------------------------------------------------------------------------------------
                            // 2) ahora sumarizamos las cuentas en la lista, pues, como resultado de 'disminuir' niveles, quedan 
                            // muchas iguales ... (son tantas propiedades, que prefiero hacerlo de la forma 'antigua') 

                            string cuentaContableAnterior = "***";
                            reportItem = null; 

                            foreach (var item in myList.OrderBy(c => c.CuentaContable))
                            {
                                if (cuentaContableAnterior == "***")
                                {
                                    // 1ra. vez ... 
                                    reportItem = item;
                                    cuentaContableAnterior = item.CuentaContable; 
                                }

                                else if (item.CuentaContable != cuentaContableAnterior)
                                {
                                    // la cuenta contable cambia ... 
                                    myList2.Add(reportItem);
                                    cuentaContableAnterior = item.CuentaContable;

                                    reportItem = null;
                                    reportItem = item;
                                }
                                else
                                {
                                    // misma cuenta contable ... 
                                    reportItem.SaldoInicial += item.SaldoInicial;
                                    reportItem.Debe += item.Debe;
                                    reportItem.Haber += item.Haber;
                                    reportItem.SaldoActual += item.SaldoActual;

                                    reportItem.CantidadMovimientos += item.CantidadMovimientos; 
                                }

                            }

                            // agregamos a la lista la última cuenta contable ... 
                            myList2.Add(reportItem);


                            defaultOption: 

                            ReportDataSource myReportDataSource = new ReportDataSource();
                            myReportDataSource.Name = "DataSet1";

                            if (cantNiveles == -1)
                                // default option (el usuario quiere ver *todos* los niveles (hasta el detalle) de las cuentas seleccionadas .... 
                                myReportDataSource.Value = myList;
                            else
                                // el usuario quiere ver una cantidad *menor* de niveles para las cuentas seleccionadas 
                                myReportDataSource.Value = myList2;

                            this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            // resumimos el contenido de la lista, para obtener los totales finales de la consulta ... 

                            List<Contab_Report_BalanceGeneral_Resumen> listaResumen = new List<Contab_Report_BalanceGeneral_Resumen>();
                            Contab_Report_BalanceGeneral_Resumen itemResumen;


                            if (cantNiveles == -1)
                            {
                                // opción default; el usuario quiere las cuentas de tipo detalle; sumarizamos los items en myList ... 
                                var query2 = from c in myList
                                             group c by c.NombreNivel1 into g
                                             select new
                                             {
                                                 key = g, 
                                                 SaldoInicial_SumOf = g.Sum(x => x.SaldoInicial),
                                                 SaldoDebe_SumOf = g.Sum(x => x.Debe),
                                                 SaldoHaber_SumOf = g.Sum(x => x.Haber),
                                                 SaldoActual_SumOf = g.Sum(x => x.SaldoActual), 
                                                 CantMovimientos_SumOf = g.Sum(x => x.CantidadMovimientos)
                                             };

                                foreach (var r in query2)
                                {
                                    itemResumen = new Contab_Report_BalanceGeneral_Resumen();

                                    itemResumen.SimboloMoneda = r.key.First().NombreMoneda;
                                    itemResumen.TipoCuenta = 0;             // bal gen: para dar un sub total para cuentas cuentas: reales / gyp 

                                    itemResumen.NombreNivel1 = r.key.First().NombreNivel1;
                                    itemResumen.SaldoInicial = r.SaldoInicial_SumOf;
                                    itemResumen.Debe = r.SaldoDebe_SumOf;
                                    itemResumen.Haber = r.SaldoHaber_SumOf;
                                    itemResumen.SaldoActual = r.SaldoActual_SumOf;
                                    itemResumen.CantidadMovimientos = Convert.ToInt16(r.CantMovimientos_SumOf);

                                    itemResumen.OrdenBalanceGeneral = r.key.First().OrdenBalanceGeneral;

                                    listaResumen.Add(itemResumen); 
                                }
                            }
                            else
                            {
                                // el usuario quiere menos niveles en el reporte (otras opciones diferentes a la default); sumarizamos los items en myList2 ... 
                                var query2 = from c in myList2
                                             group c by c.NombreNivel1 into g
                                             select new
                                             {
                                                 key = g,
                                                 SaldoInicial_SumOf = g.Sum(x => x.SaldoInicial),
                                                 SaldoDebe_SumOf = g.Sum(x => x.Debe),
                                                 SaldoHaber_SumOf = g.Sum(x => x.Haber),
                                                 SaldoActual_SumOf = g.Sum(x => x.SaldoActual),
                                                 CantMovimientos_SumOf = g.Sum(x => x.CantidadMovimientos)
                                             };

                                foreach (var r in query2)
                                {
                                    itemResumen = new Contab_Report_BalanceGeneral_Resumen();

                                    itemResumen.SimboloMoneda = r.key.First().NombreMoneda;
                                    itemResumen.TipoCuenta = 0;             // bal gen: para dar un sub total para cuentas cuentas: reales / gyp 

                                    itemResumen.NombreNivel1 = r.key.First().NombreNivel1;
                                    itemResumen.SaldoInicial = r.SaldoInicial_SumOf;
                                    itemResumen.Debe = r.SaldoDebe_SumOf;
                                    itemResumen.Haber = r.SaldoHaber_SumOf;
                                    itemResumen.SaldoActual = r.SaldoActual_SumOf;
                                    itemResumen.CantidadMovimientos = Convert.ToInt16(r.CantMovimientos_SumOf);

                                    itemResumen.OrdenBalanceGeneral = r.key.First().OrdenBalanceGeneral;

                                    listaResumen.Add(itemResumen);
                                }
                            }

                            // solo si el tipo de consulta es BalGen y si así lo pidió el usuario, buscamos y mostramos un resumen de 
                            // gastos e ingresos ... 

                            BalanceGeneral_Parametros parametros = Session["BalanceGeneral_Parametros"] as BalanceGeneral_Parametros;

                            if (parametros.BalGen_GyP == "BG")
                            {
                                string errorMessage = "";

                                // determinamos el mes y año fiscal, pues lo necesitamos para ejecutar el sp que sigue ... 

                                var mesFiscal_ObjectParmeter = new ObjectParameter("mesFiscal", typeof(short));
                                var anoFiscal_ObjectParmeter = new ObjectParameter("anoFiscal", typeof(short));
                                var nombreMes_ObjectParmeter = new ObjectParameter("nombreMes", typeof(string));
                                var errorMessage_ObjectParmeter = new ObjectParameter("errorMessage", typeof(string));

                                // nótese como obtenemos el mes fiscal para el mes *anterior* al mes de inicio del período; la idea es obtener (luego) los saldos del mes 
                                // *anterior* al inicio del período; por ejemplo: si el usuario intenta obtener la consulta para Abril, debemos obtener los saldos para 
                                // Marzo, que serán los iniciales para Abril .... 

                                int result = db.spDeterminarMesFiscal(parametros.Desde,
                                                                        parametros.CiaContab,
                                                                        mesFiscal_ObjectParmeter,
                                                                        anoFiscal_ObjectParmeter,
                                                                        nombreMes_ObjectParmeter,
                                                                        errorMessage_ObjectParmeter);

                                if (!string.IsNullOrEmpty(errorMessage_ObjectParmeter.Value.ToString()))
                                {
                                    string functionErrorMessage = errorMessage_ObjectParmeter.Value.ToString();
                                    errorMessage = "Hemos obtenido un error, al intentar obtener obtener el mes y año fiscal para la fecha indicada como criterio de ejecución.<br /> " +
                                            "A continuación, mostramos el mensaje específico de error:<br /> " + functionErrorMessage;

                                    ErrMessage_Cell.InnerHtml = errorMessage;
                                    return;
                                }

                                short mesFiscal = Convert.ToInt16(mesFiscal_ObjectParmeter.Value);
                                short anoFiscal = Convert.ToInt16(anoFiscal_ObjectParmeter.Value);
                                string nombreMes = nombreMes_ObjectParmeter.Value.ToString();

                                // la función que sigue lee y regresa en una lista el ID de las cuentas GyP ... 

                                List<int> cuentasContablesGyP_List;
                                cuentasContablesGyP_List = ConstruirListaCuentasGyP(parametros.CiaContab, db, out errorMessage);

                                if (errorMessage != "")
                                {
                                    ErrMessage_Cell.InnerHtml = errorMessage;
                                    return;
                                }

                                // pasamos cada 1er. nivel de cuentas (gyp) a un stored procedure, para que determine su resumen ... 

                                foreach (int cuentaContable in cuentasContablesGyP_List)
                                {
                                    // para cada cuenta, ejecutamos un sp que determina los montos que corresponden 
                                    // (nóetese que el sp lee y regresa una sumarización para las cuentas contables subordinadas (ie: 5 ->> 5*) 

                                    var nombreCuentaContable_ObjectParmeter = new ObjectParameter("nombreCuentaContable", typeof(string));
                                    var nombreGrupoContable_ObjectParmeter = new ObjectParameter("nombreGrupoContable", typeof(string));

                                    var saldoInicial_ObjectParmeter = new ObjectParameter("saldoInicial", typeof(decimal));
                                    var montoAntesDesde_ObjectParmeter = new ObjectParameter("montoAntesDesde", typeof(decimal));
                                    var debe_ObjectParmeter = new ObjectParameter("debe", typeof(decimal));
                                    var haber_ObjectParmeter = new ObjectParameter("haber", typeof(decimal));
                                    var saldoActual_ObjectParmeter = new ObjectParameter("saldoActual", typeof(decimal));

                                    var cantidadMovimientos_ObjectParmeter = new ObjectParameter("cantidadMovimientos", typeof(short));
                                    var ordenBalanceGeneral_ObjectParmeter = new ObjectParameter("ordenBalanceGeneral", typeof(short));

                                    // nótese como obtenemos el mes fiscal para el mes *anterior* al mes de inicio del período; la idea es obtener (luego) 
                                    // los saldos del mes *anterior* al inicio del período; por ejemplo: si el usuario intenta obtener la consulta para Abril, 
                                    // debemos obtener los saldos para Marzo, que serán los iniciales para Abril .... 

                                    var result2 = db.spGetSaldoAnteriorDebeYHaber(cuentaContable, 
                                                                                    parametros.Moneda, 
                                                                                    parametros.MonedaOriginal, 
                                                                                    mesFiscal, anoFiscal, 
                                                                                    parametros.Desde, 
                                                                                    parametros.Hasta, true, 
                                                                                    parametros.ExcluirAsientosContablesTipoCierreAnual, 
                                                                                    nombreCuentaContable_ObjectParmeter,
                                                                                    nombreGrupoContable_ObjectParmeter,
                                                                                    saldoInicial_ObjectParmeter,
                                                                                    montoAntesDesde_ObjectParmeter,
                                                                                    debe_ObjectParmeter,
                                                                                    haber_ObjectParmeter,
                                                                                    saldoActual_ObjectParmeter,
                                                                                    cantidadMovimientos_ObjectParmeter,
                                                                                    ordenBalanceGeneral_ObjectParmeter,
                                                                                    errorMessage_ObjectParmeter);

                                    // nota: si no materializamos aquí, los outputs parameters no son siempre accesibles !!! 

                                    var spResul = result2.Single(); 


                                    if (!string.IsNullOrEmpty(errorMessage_ObjectParmeter.Value.ToString()))
                                    {
                                        string functionErrorMessage = errorMessage_ObjectParmeter.Value.ToString();
                                        errorMessage = "Hemos obtenido un error, al intentar obtener obtener el saldo anterior, debe y haber " + 
                                            "para alguna de las cuentas contables.<br /> " +
                                            "A continuación, mostramos el mensaje específico de error:<br /> " + functionErrorMessage;

                                        ErrMessage_Cell.InnerHtml = errorMessage;
                                        //return;
                                    }

                                    itemResumen = new Contab_Report_BalanceGeneral_Resumen();

                                    itemResumen.SimboloMoneda = nombreMoneda;
                                    itemResumen.TipoCuenta = 1;             // bal gen: para dar un sub total para cuentas cuentas: reales / gyp 

                                    itemResumen.NombreNivel1 = nombreCuentaContable_ObjectParmeter.Value.ToString();
                                    itemResumen.SaldoInicial = Convert.ToDecimal(saldoInicial_ObjectParmeter.Value) +
                                                                Convert.ToDecimal(montoAntesDesde_ObjectParmeter.Value);
                                    itemResumen.Debe = Convert.ToDecimal(debe_ObjectParmeter.Value);
                                    itemResumen.Haber = Convert.ToDecimal(haber_ObjectParmeter.Value);
                                    itemResumen.SaldoActual = Convert.ToDecimal(saldoActual_ObjectParmeter.Value);

                                    itemResumen.CantidadMovimientos = Convert.ToInt16(cantidadMovimientos_ObjectParmeter.Value);
                                    itemResumen.OrdenBalanceGeneral = Convert.ToInt16(ordenBalanceGeneral_ObjectParmeter.Value);

                                    listaResumen.Add(itemResumen); 
                                }
                            }

                            // el usuario puede indicar que quiere solo la columna de saldo final (no debe/haber, ni saldo inicial) 
                            bool soloSaldoFinal = false;

                            if (Request.QueryString["soloSaldoFinal"] != null && Request.QueryString["soloSaldoFinal"].ToString() == "si")
                                soloSaldoFinal = true; 

                            if (soloSaldoFinal) 
                            {
                                this.ReportViewer1.LocalReport.ReportPath = "Contab/Consultas contables/BalanceGeneral/BalanceGeneral_SoloSaldoFinal.rdlc";
                            }
                            else 
                            {
                                this.ReportViewer1.LocalReport.ReportPath = "Contab/Consultas contables/BalanceGeneral/BalanceGeneral.rdlc";
                            }

                            

                            myReportDataSource = new ReportDataSource();
                            myReportDataSource.Name = "DataSet2";
                            myReportDataSource.Value = listaResumen;
                            this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            this.ReportViewer1.LocalReport.Refresh();


                            // ----------------------------------------------------------------------------------------------------
                            // accedemos y pasamos los parámetros al reporte ... 

                            ReportParameter subTituloReportParameter = new ReportParameter("subTitulo", subtituloReporte);
                            ReportParameter tituloReportParameter = new ReportParameter("titulo", tituloReporte);
                            ReportParameter colorReportParameter = new ReportParameter("color", color);
                            ReportParameter simpleFontReportParameter = new ReportParameter("simpleFont", simpleFont);
                            ReportParameter soloTotalesReportParameter = new ReportParameter("soloTotales", soloTotales);
                            ReportParameter simboloMonedaReportParameter = new ReportParameter("simboloMoneda", simboloMoneda);

                            ReportParameter tipoReporte_ReportParameter = new ReportParameter("TipoReporte", parametros.BalGen_GyP);
                            // -----------------------------------------------------------------------------------------------------
                            // leemos un 'flag' en la tabla Parametros, que permite al usuario indicar si quiere mostrar o 
                            // no la fecha del día en los reportes de contabilidad ... 

                            //string nombreCiaContab = myList[0].NombreCiaContab;

                            dbContab_Contab_Entities contabContex = new dbContab_Contab_Entities();

                            int? numeroCiaContab = contabContex.Companias.Where(c => c.Nombre == nombreCiaContab).Select(c => c.Numero).FirstOrDefault();

                            bool? noMostrarFechaEnReportesContab = false;

                            if (numeroCiaContab != null)
                                noMostrarFechaEnReportesContab = contabContex.ParametrosContabs.Where(p => p.Cia == numeroCiaContab.Value).
                                                                                                Select(p => p.ReportesContab_NoMostrarFechaDia).
                                                                                                FirstOrDefault();

                            if (noMostrarFechaEnReportesContab == null)
                                noMostrarFechaEnReportesContab = false;

                            ReportParameter noMostrarFechaDia_ReportParameter =
                                new ReportParameter("noMostrarFechaDia", noMostrarFechaEnReportesContab.Value.ToString());
                            // -----------------------------------------------------------------------------------------------------

                            ReportParameter[] MyReportParameters = 
                            { 
                                subTituloReportParameter, 
                                tituloReportParameter,
                                colorReportParameter,
                                simpleFontReportParameter, 
                                soloTotalesReportParameter,
                                tipoReporte_ReportParameter, 
                                noMostrarFechaDia_ReportParameter,
                                simboloMonedaReportParameter
                            };

                            this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                            if (format == "pdf")
                            {
                                Warning[] warnings;
                                string[] streamIds;
                                string mimeType = string.Empty;
                                string encoding = string.Empty;
                                string extension = string.Empty;

                                byte[] bytes = this.ReportViewer1.LocalReport.Render("PDF", null, out mimeType, out encoding, out extension, out streamIds, out warnings);

                                // Now that you have all the bytes representing the PDF report, buffer it and send it to the client.
                                Response.Buffer = true;
                                Response.Clear();
                                Response.ContentType = mimeType;
                                Response.AddHeader("content-disposition", "attachment; filename=BalanceGeneral.pdf");
                                Response.BinaryWrite(bytes); // create the file
                                Response.Flush(); // send it to the client to download
                            }

                            break;
                        }
                }
            }
        }

        private List<int> ConstruirListaCuentasGyP(int ciaContab, dbContab_Contab_Entities dbContab, out string errorMessage)
        {
            // esta función lee la tabla ParametrosContab para una Cia en paraticular y construye el filtro adecuado para leer 
            // cuentas de gastos e ingresos (gyp) ... 

            errorMessage = "";
            List<int> list = new List<int>();

            ContabSysNet_Web.ModelosDatos_EF.Contab.ParametrosContab parametrosContab = dbContab.ParametrosContabs.Where(p => p.Cia == ciaContab).FirstOrDefault();

            if (parametrosContab == null)
            {
                errorMessage = "Aparentemente, la tabla de parámetros (Contab) no ha sido inicializada. " +
                    "Por favor inicialize esta tabla con los valores que sean adecuados, para la Cia Contab seleccionada para esta consulta.";

                return list;
            }

            // para GyP siempre excluimos cuentas reales (activo, pasivo, capital) 

            if (parametrosContab.Ingresos1 != null)
                list.Add(parametrosContab.Ingresos1.Value); 


            if (parametrosContab.Ingresos2 != null)
                list.Add(parametrosContab.Ingresos2.Value); 


            if (parametrosContab.Ingresos3 != null)
                list.Add(parametrosContab.Ingresos3.Value); 


            if (parametrosContab.Ingresos4 != null)
                list.Add(parametrosContab.Ingresos4.Value); 


            if (parametrosContab.Ingresos5 != null)
                list.Add(parametrosContab.Ingresos5.Value); 


            if (parametrosContab.Ingresos6 != null)
                list.Add(parametrosContab.Ingresos6.Value); 


            if (parametrosContab.Egresos1 != null)
                list.Add(parametrosContab.Egresos1.Value); 


            if (parametrosContab.Egresos2 != null)
                list.Add(parametrosContab.Egresos2.Value); 


            if (parametrosContab.Egresos3 != null)
                list.Add(parametrosContab.Egresos3.Value); 


            if (parametrosContab.Egresos4 != null)
                list.Add(parametrosContab.Egresos4.Value); 


            if (parametrosContab.Egresos5 != null)
                list.Add(parametrosContab.Egresos5.Value); 


            if (parametrosContab.Egresos6 != null)
                list.Add(parametrosContab.Egresos6.Value); 


            if (list.Count() == 0)
            {
                errorMessage = "Aparentemente, la tabla de parámetros (Contab) no ha sido correctamente inicializada.<br />" +
                    "No hemos podido construir un filtro para leer las cuentas contables de gastos e ingresos.<br />" +
                    "Por favor inicialize esta tabla con los valores que sean adecuados, para la Cia Contab seleccionada para esta consulta.";

                return list;
            }

            return list;
        }

        private void Report_SubreportProcessingEventHandler(object sender, Microsoft.Reporting.WebForms.SubreportProcessingEventArgs e)
        {
            switch (Request.QueryString["rpt"].ToString())
            {
                case "comprobantescontables":
                    {
                        switch (e.ReportPath)
                        {
                            // algún día puede haber más de un subreport !!

                            case "ComprobantesContables_SubReport":
                                {
                                    //ComprobantesContables_DataSet MySubReportDataSet =
                                    //    new ComprobantesContables_DataSet();

                                    //tTempWebReport_ConsultaComprobantesContables_PartidasTableAdapter
                                    //    MySubReportTableAdapter =
                                    //    new tTempWebReport_ConsultaComprobantesContables_PartidasTableAdapter();

                                    int nNumeroAutomatico =
                                        Convert.ToInt32(e.Parameters["NumeroAutomatico"].Values[0]);

                                    //int nCiaContab =
                                    //    Convert.ToInt32(e.Parameters["CiaContab"].Values[0]);

                                    //string sNombreUsuario = e.Parameters["NombreUsuario"].Values[0];


                                    //MySubReportTableAdapter.FillByNumeroAutomaticoAndCiaAndUsuario(MySubReportDataSet.tTempWebReport_ConsultaComprobantesContables_Partidas, nNumeroAutomatico, nCiaContab, sNombreUsuario);

                                    e.DataSources.Clear();

                                    dbContab_Contab_Entities contabContext = new dbContab_Contab_Entities();

                                    List<dAsiento_Report> list = new List<dAsiento_Report>();

                                    var query = from p in contabContext.dAsientos
                                                where p.NumeroAutomatico == nNumeroAutomatico
                                                select p;

                                    dAsiento_Report partida;

                                    foreach (ContabSysNet_Web.ModelosDatos_EF.Contab.dAsiento p in query)
                                    {
                                        partida = new dAsiento_Report();

                                        partida.Partida = p.Partida;
                                        partida.Descripcion = p.Descripcion;
                                        partida.Referencia = p.Referencia;
                                        partida.Debe = p.Debe;
                                        partida.Haber = p.Haber;
                                        partida.NumeroAutomatico = p.NumeroAutomatico;
                                        partida.NombreCuentaContable = p.CuentasContable.Descripcion;
                                        partida.CuentaContableEditada = p.CuentasContable.CuentaEditada;

                                        list.Add(partida);
                                    }

                                    ReportDataSource myReportDataSource = new ReportDataSource();

                                    myReportDataSource.Name = "DataSet1";
                                    myReportDataSource.Value = list;

                                    e.DataSources.Add(myReportDataSource);

                                    break;
                                }
                        }
                        break; 
                    }
 
                case "unasientocontable":
                    {
                    switch (e.ReportPath)
                    {
                        // algún día puede haber más de un subreport !!

                        case "ComprobantesContables_SubReport":
                            {
                                int numeroAutomaticoAsientoContable;

                                if (!int.TryParse(Request.QueryString["NumeroAutomatico"], out numeroAutomaticoAsientoContable))
                                {
                                    ErrMessage_Cell.InnerHtml = "No se ha pasado un parámetro correcto a esta función. <br /><br />" +
                                        "Esta función debe recibir como parámetro el ID válido de un asiento contable.";
                                    return;
                                }

                                e.DataSources.Clear();

                                dbContab_Contab_Entities contabContext = new dbContab_Contab_Entities();

                                List<dAsiento_Report> list = new List<dAsiento_Report>();

                                var query = from p in contabContext.dAsientos
                                            where p.NumeroAutomatico == numeroAutomaticoAsientoContable
                                            select p;

                                dAsiento_Report partida;

                                foreach (ContabSysNet_Web.ModelosDatos_EF.Contab.dAsiento p in query)
                                {
                                    partida = new dAsiento_Report();

                                    partida.Partida = p.Partida;
                                    partida.Descripcion = p.Descripcion;
                                    partida.Referencia = p.Referencia;
                                    partida.Debe = p.Debe;
                                    partida.Haber = p.Haber; 
                                    partida.NumeroAutomatico = p.NumeroAutomatico;
                                    partida.NombreCuentaContable = p.CuentasContable.Descripcion;
                                    partida.CuentaContableEditada = p.CuentasContable.CuentaEditada;

                                    list.Add(partida);
                                }

                                ReportDataSource myReportDataSource = new ReportDataSource();

                                myReportDataSource.Name = "DataSet1";
                                myReportDataSource.Value = list;

                                e.DataSources.Add(myReportDataSource);

                                break;
                            }
                    }

                    break; 
                }
            }

        }

        private List<Factura_ComprobanteRetencionIva> ConstruirListaRetencionesIvaProveedores(
            BancosEntities bancosContext, 
            string userName, 
            string fechaToday, 
            int? proveedor = null)  
        {
            // esta función lee las facturas que el usuario ha filtrado y seleccionado en la consulta general de facturas y produce 
            // una lista con los datos relacionados con la retención iva de las facturas ... 

            // -------------------------------------------------------------------------------------------------------------------
            // leemos las facturas que el usuario ha seleccionado, en el archivo 'Temp...' y construimos un filtro para leer las 
            // retenciones de impuesto de estas facturas 

            string filtroFacturasSeleccionadas = ""; 

            var facturas = from f in bancosContext.tTempWebReport_ConsultaFacturas
                           where f.NombreUsuario == userName
                           where (proveedor == null) || (f.Compania == proveedor.Value) 
                           select f.ClaveUnicaFactura;

            foreach (int facturaID in facturas)
            {
                if (string.IsNullOrEmpty(filtroFacturasSeleccionadas))
                    filtroFacturasSeleccionadas = "(it.FacturaID In {" + facturaID.ToString();
                else
                    filtroFacturasSeleccionadas += "," + facturaID.ToString();
            }

            if (string.IsNullOrEmpty(filtroFacturasSeleccionadas))
                filtroFacturasSeleccionadas = "(1 == 2)";
            else
                filtroFacturasSeleccionadas += "})";
            // ---------------------------------------------------------------------------------------

            var query = bancosContext.Facturas_Impuestos.Include("Factura").
                                                   Include("Factura.Proveedore").
                                                   Include("Factura.Compania").
                                                   Where(filtroFacturasSeleccionadas).
                                                   Select(i => i);

            query = query.Where(i => i.ImpuestosRetencionesDefinicion.Predefinido == 2).        // solo retenciones Iva 
                          OrderBy(i => i.Factura.NumeroComprobante).ThenBy(i => i.Factura.NumeroFactura);

            Factura_ComprobanteRetencionIva infoFactura; 
            List<Factura_ComprobanteRetencionIva> list = new List<Factura_ComprobanteRetencionIva>(); 

            // ponemos en cero algunos montos cuando una factura se repite en un comprobante de retención 
            // nota: una factura se repite en un comprobante cuando tiene más de una retención Iva 
            // ejemplo: una factura con dos montos imponibles, uno a un iva 8% y otro a un iva 12% 

            string comprobanteRetencionAnterior = "-999";
            string numeroFacturaAnterior = "-999"; 

            foreach (Facturas_Impuestos impuesto in query)
            {
                // -----------------------------------------------------------------------------------------------------------------------
                // lamentablemente, debemos leer la definición del impuesto Iva para la retención que acabamos de leer. La razón es que 
                // en el registro de la retención Iva no está el monto imponible que corresponde; cuando es una sola retención, se puede tomar 
                // de la factura; cuando la factura tiene más de una retención, pueden haber montos imponibles diferentes ... 

                Facturas_Impuestos impuestoIva = bancosContext.Facturas_Impuestos.Where(i => i.FacturaID == impuesto.FacturaID && i.ID < impuesto.ID).
                    Where(i => i.ImpuestosRetencionesDefinicion.Predefinido == 1).
                    OrderByDescending(i => i.ID).                   // para leer *justo* la definición de Iva anterior y no otra que está aún antes ... 
                    FirstOrDefault(); 
                // -----------------------------------------------------------------------------------------------------------------------


                infoFactura = new Factura_ComprobanteRetencionIva();

                infoFactura.FechaToday = fechaToday; 
                infoFactura.NombreCia = impuesto.Factura.Compania.Nombre;
                infoFactura.RifCia = impuesto.Factura.Compania.Rif;
                infoFactura.DireccionCia = impuesto.Factura.Compania.Direccion; 

                infoFactura.NombreCompania = impuesto.Factura.Proveedore.Nombre;
                infoFactura.RifCompania = impuesto.Factura.Proveedore.Rif;
                infoFactura.PeriodoFiscal = impuesto.Factura.FechaRecepcion.Month.ToString("00") + "-" + impuesto.Factura.FechaRecepcion.Year.ToString();


                infoFactura.NumeroDocumento = string.IsNullOrEmpty(impuesto.Factura.NcNdFlag) ? impuesto.Factura.NumeroFactura : "";
                infoFactura.NumeroControl = impuesto.Factura.NumeroControl;
                infoFactura.FechaDocumento = impuesto.Factura.FechaRecepcion;

                infoFactura.NotaCredito = impuesto.Factura.NcNdFlag == "NC" ? impuesto.Factura.NumeroFactura : "";
                infoFactura.NotaDebito = impuesto.Factura.NcNdFlag == "ND" ? impuesto.Factura.NumeroFactura : "";
                infoFactura.TipoDocumento = "1";
                infoFactura.FacturaAfectada = impuesto.Factura.NumeroFacturaAfectada;

                infoFactura.ComprobanteSeniat = impuesto.Factura.NumeroComprobante;
                infoFactura.NumeroOperacion = Convert.ToByte(impuesto.Factura.NumeroOperacion != null ? impuesto.Factura.NumeroOperacion.Value : 0); 

                infoFactura.TotalComprasIncIva = 0;
                infoFactura.TotalComprasIncIva = impuesto.Factura.MontoFacturaSinIva != null ? impuesto.Factura.MontoFacturaSinIva.Value : 0;
                infoFactura.TotalComprasIncIva += impuesto.Factura.MontoFacturaConIva != null ? impuesto.Factura.MontoFacturaConIva.Value : 0;
                infoFactura.TotalComprasIncIva += impuesto.Factura.Iva != null ? impuesto.Factura.Iva.Value : 0;

                // base imponible: nótese como la tomamos del registro de impuesto Iva (leído antes) 
                decimal montoImponible = 0;
                decimal ivaPorc = 0;

                if (impuestoIva != null && impuestoIva.MontoBase != null)
                    montoImponible = impuestoIva.MontoBase.Value;

                if (impuestoIva != null && impuestoIva.Porcentaje != null)
                    ivaPorc = impuestoIva.Porcentaje.Value;

                infoFactura.MontoNoImponible = impuesto.Factura.MontoFacturaSinIva != null ? impuesto.Factura.MontoFacturaSinIva.Value : 0;
                infoFactura.MontoImponible = montoImponible;
                infoFactura.IvaPorc = ivaPorc;
                infoFactura.Iva = impuesto.MontoBase != null ? impuesto.MontoBase.Value : 0;
                infoFactura.RetencionIvaPorc = impuesto.Porcentaje != null ? impuesto.Porcentaje.Value : 0;
                infoFactura.RetencionIva = impuesto.Monto;

                if (comprobanteRetencionAnterior == impuesto.Factura.NumeroComprobante && numeroFacturaAnterior == impuesto.Factura.NumeroFactura)
                {
                    // la factura se repite en el comprobante; corresponde a una 2da (o 3ra) retención Iva en la misma factura 
                    infoFactura.TotalComprasIncIva = 0;
                    infoFactura.MontoNoImponible = 0; 
                }

                list.Add(infoFactura);

                comprobanteRetencionAnterior = impuesto.Factura.NumeroComprobante;
                numeroFacturaAnterior = impuesto.Factura.NumeroFactura; 
            }

            return list; 
        }
    }
}
