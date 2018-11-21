using System;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.UI.HtmlControls;
//using ContabSysNet_Web.ModelosDatos;

using System.Linq;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using ContabSysNet_Web.ModelosDatos_EF.Contab;
using System.Collections.Generic;
using System.Text;

namespace ContabSysNet_Web.Bancos.Consultas_facturas.Facturas
{
    public partial class Facturas_Cuotas : System.Web.UI.Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            this.FacturasCuotas_ListView.EnableDynamicData(typeof(CuotasFactura));
            this.DynamicDataManager1.RegisterControl(this.FacturasCuotas_ListView);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    MyHtmlH2.InnerHtml = "Facturas - Cuotas - Consulta";
                }

                this.FacturasCuotas_EntityDataSource.WhereParameters["FacturaID"].DefaultValue = Page.Request.QueryString["FacturaID"].ToString();
            }
        }
    }
}
