using System;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.UI.HtmlControls;
using ContabSysNet_Web.ModelosDatos;

using System.Linq; 

namespace ContabSysNetWeb.Contab.Consultas_contables.Cuentas_y_movimientos
{
    public partial class CuentasYMovimientos_Comprobantes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    MyHtmlH2.InnerHtml = "Consulta de Asientos Contables";
                }

                this.AsientosContables_SqlDataSource.SelectParameters["NumeroAutomatico"].DefaultValue = Page.Request.QueryString["NumeroAutomatico"];
                this.Partidas_SqlDataSource.SelectParameters["NumeroAutomatico"].DefaultValue = Page.Request.QueryString["NumeroAutomatico"];
                this.Asientos_Log_SqlDataSource.SelectParameters["NumeroAutomatico"].DefaultValue = Page.Request.QueryString["NumeroAutomatico"];
                this.AsientosLinks_SqlDataSource.SelectParameters["NumeroAutomatico"].DefaultValue = Page.Request.QueryString["NumeroAutomatico"];

                dbContabDataContext dbContab = new dbContabDataContext();

                decimal? nTotalDebe = (from d in dbContab.dAsientos
                                       where d.NumeroAutomatico == Convert.ToInt32(Page.Request.QueryString["NumeroAutomatico"])
                                       select (decimal?)d.Debe).Sum();

                decimal? nTotalHaber = (from d in dbContab.dAsientos
                                        where d.NumeroAutomatico == Convert.ToInt32(Page.Request.QueryString["NumeroAutomatico"])
                                        select (decimal?)d.Haber).Sum();

                Label MySumOfDebe_Label = (Label)Partidas_ListView.FindControl("SumOfDebe_Label");
                Label MySumOfHaber_Label = (Label)Partidas_ListView.FindControl("SumOfHaber_Label");

                if (MySumOfDebe_Label != null) 
                    MySumOfDebe_Label.Text = nTotalDebe != null ? nTotalDebe.Value.ToString("#,##0.000") : "0,000";

                if (MySumOfHaber_Label != null) 
                    MySumOfHaber_Label.Text = nTotalHaber != null ? nTotalHaber.Value.ToString("#,##0.000") : "0,000";

                dbContab = null;

                // establecemos la propiedad del link que permite obtener el reporte para este asiento contable ... 

                string url = "";
                url = "../../../ReportViewer.aspx?rpt=unasientocontable&NumeroAutomatico=" + Page.Request.QueryString["NumeroAutomatico"].ToString();
                ImprimirAsientoContable_HyperLink.HRef = "javascript:PopupWin('" + url + "', 1000, 680)"; 
            }
        }
    }
}
