using System;
using System.Web.Security;
using Microsoft.Reporting.WebForms;
using System.Linq; 

// para que encuentre la definición de los datasets 

using ContabSysNetWeb.report_datasets.Contab;
using ContabSysNetWeb.report_datasets.Contab.Presupuesto_MontosEstimadosTableAdapters;
using ContabSysNetWeb.report_datasets.Contab.Presupuesto_ConsultaMensualTableAdapters;
using ContabSysNetWeb.report_datasets.Contab.Presupuesto_ConsultaAnualTableAdapters;
using ContabSysNet_Web.ModelosDatos;
using System.Collections.Generic;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using ContabSysNet_Web.Contab.Presupuesto.Consultas.Montos_estimados;

namespace ContabSysNetWeb
{
    public partial class ReportViewer2 : System.Web.UI.Page
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
                    case "ptomtosest":
                        {
                            if (!User.Identity.IsAuthenticated)
                            {
                                FormsAuthentication.SignOut();
                                return;
                            }

                            Presupuesto_MontosEstimados MyReportDataSet = new Presupuesto_MontosEstimados();
                            MontosEstimadosTableAdapter MyReportTableAdapter = new MontosEstimadosTableAdapter();

                            MyReportTableAdapter.FillByNombreUsuario(MyReportDataSet.MontosEstimados, Membership.GetUser().UserName);

                            if (MyReportDataSet.MontosEstimados.Rows.Count == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. " +
                                    "ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un filtro y " +
                                    "seleccionado información aún.";
                                return;
                            }


                            // -----------------------------------------------------------------------------------------------

                            ReportViewer1.LocalReport.ReportPath = "Contab/Presupuesto/Consultas/Montos estimados/MontosEstimados.rdlc";

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "Presupuesto_MontosEstimados_MontosEstimados";
                            myReportDataSource.Value = MyReportDataSet.MontosEstimados;

                            ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            // para ejecutar un procedimiento que procesa el sub report 

                            ReportViewer1.LocalReport.SubreportProcessing += Report_SubreportProcessingEventHandler;

                            ReportViewer1.LocalReport.Refresh();

                            break;
                        }
                    case "ptoconsmes":
                        {

                            if (!User.Identity.IsAuthenticated)
                            {
                                FormsAuthentication.SignOut();
                                return;
                            }

                            string cantNiveles = Request.QueryString["cantniveles"].ToString();

                            Presupuesto_ConsultaMensual MyReportDataSet = new Presupuesto_ConsultaMensual();
                            PresupuestoMensualTableAdapter MyReportTableAdapter = new PresupuestoMensualTableAdapter();

                            MyReportTableAdapter.FillByNombreUsuario(MyReportDataSet.PresupuestoMensual,
                                Membership.GetUser().UserName);

                            if (MyReportDataSet.PresupuestoMensual.Rows.Count == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. " +
                                    "ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un filtro y " +
                                    "seleccionado información aún.";
                                return;
                            }

                            ReportViewer1.LocalReport.ReportPath = "Contab/Presupuesto/Consultas/Mensual/ConsultaMensual.rdlc";

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "Presupuesto_ConsultaMensual_PresupuestoMensual";
                            myReportDataSource.Value = MyReportDataSet.PresupuestoMensual;

                            ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            dbContabDataContext dbContab = new dbContabDataContext();

                            var queryMesAno = (from t in dbContab.tTempWebReport_PresupuestoConsultaMensuals
                                               where t.NombreUsuario == Membership.GetUser().UserName
                                               select new
                                               {
                                                   t.NombreMes,
                                                   t.AnoFiscal,
                                                   t.FactorConversion
                                               })
                                               .FirstOrDefault();

                            if (queryMesAno == null)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. " +
                                    "ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un filtro y " +
                                    "seleccionado información aún.";
                                return;
                            }

                            string mes = queryMesAno.NombreMes;
                            string ano = queryMesAno.AnoFiscal.ToString();
                            string sFactorConversion = queryMesAno.FactorConversion.ToString("N2");

                            dbContab = null;

                            ReportParameter Mes_ReportParameter = new ReportParameter("Mes", mes);
                            ReportParameter Ano_ReportParameter = new ReportParameter("Ano", ano);
                            ReportParameter FactorConversion_ReportParameter =
                                new ReportParameter("FactorConversion", sFactorConversion);
                            ReportParameter CantNiveles_ReportParameter = new ReportParameter("CantNiveles",
                                cantNiveles);

                            ReportParameter[] MyReportParameters = {
                                                        Mes_ReportParameter,
                                                        Ano_ReportParameter,
                                                        FactorConversion_ReportParameter,
                                                        CantNiveles_ReportParameter
                                                        };

                            ReportViewer1.LocalReport.SetParameters(MyReportParameters);

                            ReportViewer1.LocalReport.Refresh();

                            break;
                        }
                    case "ptoconsanual":
                        {
                            if (!User.Identity.IsAuthenticated)
                            {
                                FormsAuthentication.SignOut();
                                return;
                            }

                            string cantNiveles = Request.QueryString["cantniveles"].ToString();

                            Presupuesto_ConsultaAnual MyReportDataSet = new Presupuesto_ConsultaAnual();
                            Presupuesto_ConsultaAnualTableAdapter MyReportTableAdapter = new
                                Presupuesto_ConsultaAnualTableAdapter();

                            MyReportTableAdapter.FillByNombreUsuario(MyReportDataSet._Presupuesto_ConsultaAnual, Membership.GetUser().UserName);

                            if (MyReportDataSet._Presupuesto_ConsultaAnual.Rows.Count == 0)
                            {
                                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. " +
                                    "ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un filtro y " +
                                    "seleccionado información aún.";
                                return;
                            }

                            ReportViewer1.LocalReport.ReportPath = "Contab/Presupuesto/Consultas/Anual/ConsultaAnual.rdlc";

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "Presupuesto_ConsultaAnual_Presupuesto_ConsultaAnual";
                            myReportDataSource.Value = MyReportDataSet._Presupuesto_ConsultaAnual;

                            ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                            dbContabDataContext dbContab = new dbContabDataContext();

                            short nAnoFiscalReporte = (from t in dbContab.tTempWebReport_PresupuestoConsultaAnuals
                                                       where t.NombreUsuario == Membership.GetUser().UserName
                                                       select t.AnoFiscal).FirstOrDefault();

                            dbContab = null;

                            ReportParameter AnoFiscal_ReportParameter = new ReportParameter("AnoFiscal",
                                nAnoFiscalReporte.ToString());

                            ReportParameter CifrasConvertidas_ReportParameter =
                                new ReportParameter("CifrasConvertidas", "0");

                            if (Request.QueryString["conv"] != null && Request.QueryString["conv"].ToString() == "1")
                                CifrasConvertidas_ReportParameter.Values[0] = "1";

                            ReportParameter CantNiveles_ReportParameter = new ReportParameter("CantNiveles",
                                cantNiveles);


                            ReportParameter[] MyReportParameters3 = {   AnoFiscal_ReportParameter,
                                                            CifrasConvertidas_ReportParameter,
                                                            CantNiveles_ReportParameter
                                                        };

                            ReportViewer1.LocalReport.SetParameters(MyReportParameters3);

                            ReportViewer1.LocalReport.Refresh();

                            break;
                        }
                }
            }
        }

        private void Report_SubreportProcessingEventHandler(Object sender, Microsoft.Reporting.WebForms.SubreportProcessingEventArgs e)
        {
            switch (Request.QueryString["rpt"].ToString())
            {
                case "ptomtosest":              // sub report para el reporte de presupuesto - montos estimados

                    switch (e.ReportPath)       // algún día puede haber más de un subreport !!
                    {
                        case "MontosEstimados_CuentasContables":

                            string sCodigoPresupuesto = e.Parameters["CodigoPresupuesto"].Values[0];
                            int nCiaContab = Convert.ToInt32(e.Parameters["CiaContab"].Values[0].ToString());

                            List<MontosEstimados_Consulta_CuentaContable> list = new List<MontosEstimados_Consulta_CuentaContable>();

                            using (dbContab_Contab_Entities contabContext = new dbContab_Contab_Entities())
                            {
                                var query = contabContext.CuentasContables.Where(c => c.Presupuesto_Codigos.Any(p => p.Codigo == sCodigoPresupuesto)).Select(c => c);
                                query = query.Where(c => c.Cia == nCiaContab);

                                MontosEstimados_Consulta_CuentaContable cuentaContable;

                                foreach (var cuenta in query)
                                {
                                    cuentaContable = new MontosEstimados_Consulta_CuentaContable()
                                    {
                                        Cuenta = cuenta.Cuenta,
                                        CuentaEditada = cuenta.CuentaEditada,
                                        Descripcion = cuenta.Descripcion
                                    };

                                    list.Add(cuentaContable);
                                }
                            }

                            e.DataSources.Clear();

                            ReportDataSource myReportDataSource = new ReportDataSource();

                            myReportDataSource.Name = "Presupuesto_MontosEstimados_CuentasContables";
                            myReportDataSource.Value = list;

                            e.DataSources.Add(myReportDataSource);

                            break;
                    }
                    break;
            }
        }
    }
}

