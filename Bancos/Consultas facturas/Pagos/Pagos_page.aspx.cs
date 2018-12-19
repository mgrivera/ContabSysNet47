using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Web.Security;

using ContabSysNet_Web.ModelosDatos_EF;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;

namespace ContabSysNet_Web.Bancos.ConsultasFacturas.Pagos
{
    public partial class Pagos_page : System.Web.UI.Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            this.Pagos_ListView.EnableDynamicData(typeof(Pago));
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Master.Page.Title = "Pagos - Consulta";

            ErrMessage_Span.InnerHtml = "";
            ErrMessage_Span.Style["display"] = "none";

            if (!Page.IsPostBack)
            {
                // Gets a reference to a Label control that is not in a
                // ContentPlaceHolder control

                HtmlContainerControl MyHtmlSpan;

                MyHtmlSpan = (HtmlContainerControl)Master.FindControl("AppName_Span");
                if (!(MyHtmlSpan == null))
                {
                    MyHtmlSpan.InnerHtml = "Bancos";
                }

                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    // sub título para la página
                    MyHtmlH2.InnerHtml = "Pagos - Consulta";
                }

                // para que, inicialmente, el entity datasource no traiga registros ... 
                this.Pagos_EntityDataSource.Where = "1 != 1"; 
            }

            else
            {
                if (RebindFlagHiddenField.Value == "1")
                {
                    RebindFlagHiddenField.Value = "0";

                    string sqlServerWhereString = Session["PagosCosulta_FiltroForma"].ToString();

                    // ------------------------------------------------------------------------------------------------
                    // por último, refrescamos el ListView con la información preparada por la consulta ... 
                    Pagos_EntityDataSource.Where = sqlServerWhereString; 
                    Pagos_ListView.DataBind();
                    this.Pagos_ListView.SelectedIndex = -1; 
                }
            }
        }

        protected void Pagos_ListView_SelectedIndexChanging(object sender, ListViewSelectEventArgs e)
        {
            // el datasource no guarda el where clause en viewstate ... 
            string sqlServerWhereString = Session["FiltroForma"].ToString();
            this.Pagos_EntityDataSource.Where = sqlServerWhereString; 
        }

        protected void Pagos_ListView_PagePropertiesChanged(object sender, EventArgs e)
        {
            // el datasource no guarda el where clause en viewstate ... 
            string sqlServerWhereString = Session["FiltroForma"].ToString();
            this.Pagos_EntityDataSource.Where = sqlServerWhereString;

            // con cada página, 'deseleccionamos' el selected row ... 
            this.Pagos_ListView.SelectedIndex = -1; 
        }

        public string NumeroPago_NoNulls(object value)
        {
            if (value == null)
                value = ""; 
            string resultValue = string.IsNullOrEmpty(value.ToString()) ? "sin número" : value.ToString();
            return resultValue; 
        }
    }
}