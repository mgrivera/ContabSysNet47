using System;
using System.Web.UI;
using Microsoft.Reporting.WebForms;
using System.Web.Security;
using ContabSysNet_Web.report_datasets.Bancos;
using ContabSysNet_Web.report_datasets.Bancos.Disponibilidad_MontosRestringidosTableAdapters;


public partial class Bancos_Disponibilidad_en_bancos_Disponibilidad_MontosRestringidos_ReportViewer : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return; 
        }
        
        if (Session["FiltroForma"] == null)
        {
            ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
            return; 
        }

        if (!Page.IsPostBack)
        {
            Disponibilidad_MontosRestringidos MyReportDataSet = new Disponibilidad_MontosRestringidos();
            Disponibilidad_MontosRestringidosTableAdapter MyReportTableAdapter =
                new Disponibilidad_MontosRestringidosTableAdapter();

            MyReportTableAdapter.Fill(MyReportDataSet._Disponibilidad_MontosRestringidos, Session["FiltroForma"].ToString());

            if (MyReportDataSet._Disponibilidad_MontosRestringidos.Rows.Count == 0)
            {
                ErrMessage_Cell.InnerHtml = "No existe información para mostrar el reporte que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
                return;
            }

            ReportViewer1.LocalReport.ReportPath = "Bancos/Disponibilidad en bancos/Disponibilidad/MontosRestringidos.rdlc";

            ReportDataSource myReportDataSource = new ReportDataSource();

            myReportDataSource.Name = "Disponibilidad_MontosRestringidos_Disponibilidad_MontosRestringidos";
            myReportDataSource.Value = MyReportDataSet._Disponibilidad_MontosRestringidos;

            ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);
            ReportViewer1.LocalReport.Refresh(); 
        }
    }
}
