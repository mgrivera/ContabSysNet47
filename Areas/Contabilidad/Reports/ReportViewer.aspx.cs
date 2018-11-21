using System;
using System.Web.Security;
using Microsoft.Reporting.WebForms;
using System.Linq;
using MongoDB.Driver;
using ContabSysNet_Web.Areas.Contabilidad.Models.mongodb.dbContab;

namespace ContabSysNet_Web.Areas.Contabilidad.Reports
{
    public partial class ReportViewer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.errorMessage_div.Visible = false; 

            if (!User.Identity.IsAuthenticated)
            {
                errorMessage_div.InnerHtml = "Error: aparentemente, Ud. no ha hecho un login a la aplicación, o ha " + 
                    "pasado mucho tiempo desde que hizo uno.<br /><br />" +
                    "Ud. debe hacer un login en esta aplicación antes de intentar ejecutar esta función.";
                this.errorMessage_div.Visible = true; 
                return;
            }

            if (!Page.IsPostBack)
            {
                switch (Request.QueryString["report"].ToString())
                {
                    case "centrosCosto":
                        {
                            try
                            {
                                if (Request.QueryString["periodo"] == null ||
                                    Request.QueryString["ciaContab"] == null ||
                                    Request.QueryString["versionResumen"] == null) 
                                {
                                    string message = "Error: esta función esperaba parámetros (ie: queryString) " + 
                                        "que no se han recibido (ej: periodo, ciaContab, versionResumen).";

                                    errorMessage_div.InnerHtml = message;
                                    this.errorMessage_div.Visible = true; 
                                    return;
                                }

                                // --------------------------------------------------------------------------------------------------------------------------
                                // establecemos una conexión a mongodb 
                                var client = new MongoClient("mongodb://localhost");
                                var mongoDataBase = client.GetDatabase("dbContab");

                                var consultaGeneralCentrosCosto = mongoDataBase.GetCollection<Temp_CentrosCosto_Consulta>("Temp_CentrosCosto_Consulta");

                                var query = consultaGeneralCentrosCosto.AsQueryable<Temp_CentrosCosto_Consulta>().Where(r => r.Usuario == User.Identity.Name).ToList();

                                this.ReportViewer1.LocalReport.ReportPath = "Areas/Contabilidad/Reports/CentrosCosto.rdlc";

                                ReportDataSource myReportDataSource = new ReportDataSource();

                                myReportDataSource.Name = "DataSet1";
                                myReportDataSource.Value = query;

                                this.ReportViewer1.LocalReport.DataSources.Add(myReportDataSource);

                                this.ReportViewer1.LocalReport.Refresh();

                                ReportParameter[] MyReportParameters = 
                                    { 
                                        new ReportParameter("periodo", Request.QueryString["periodo"].ToString()), 
                                        new ReportParameter("ciaContab", Request.QueryString["ciaContab"].ToString()),
                                        new ReportParameter("versionResumen", Request.QueryString["versionResumen"].ToString())
                                    };

                                this.ReportViewer1.LocalReport.SetParameters(MyReportParameters);
                            }
                            catch (Exception ex)
                            {
                                string message = ex.Message;
                                if (ex.InnerException != null)
                                    message += "<br />" + ex.InnerException.Message;

                                message = "Se producido un error mientras se ejecutaba este proceso. El mensaje específico del error es:<br />" + message;

                                errorMessage_div.InnerHtml = message;
                                this.errorMessage_div.Visible = true; 
                                return;

                            };

                            break;
                        }
                }

            }
        }
    }
}
