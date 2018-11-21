using System;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.UI.HtmlControls;
//using ContabSysNet_Web.ModelosDatos;

using System.Linq;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using System.Collections.Generic;
using System.Text;
using System.Web.DynamicData;

namespace ContabSysNetWeb.Contab.Consultas_contables.Comprobantes
{
    public partial class ComprobantesContables_Lista : System.Web.UI.Page
    {
        protected MetaTable table;

        protected void Page_Init(object sender, EventArgs e)
        {
            //this.AsientosContables_ListView.EnableDynamicData(typeof(Asiento));
            //this.DynamicDataManager1.RegisterControl(this.AsientosContables_ListView);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    MyHtmlH2.InnerHtml = "Asientos contables - Consulta";
                }

                this.ComprobantesContables_SqlDataSource.SelectParameters["ProvieneDe"].DefaultValue = Page.Request.QueryString["ProvieneDe"].ToString();
                this.ComprobantesContables_SqlDataSource.SelectParameters["ProvieneDe_ID"].DefaultValue = Page.Request.QueryString["ProvieneDe_ID"].ToString();
            }
        }
    }
}
