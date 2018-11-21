using System;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Web.UI.HtmlControls;
using ContabSysNet_Web.ModelosDatos;

using System.Linq; 

namespace ContabSysNetWeb.ActivosFijos.Consultas.ConsultaActivosFijos
{
    public partial class ActivoFijo_page : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    MyHtmlH2.InnerHtml = "Activos fijos - Consulta";
                }

                this.ActivosFijos_EntityDataSource.WhereParameters["ActivoFijoID"].DefaultValue = Page.Request.QueryString["ID"].ToString();
                this.AtributosAsignados_SqlDataSource.SelectParameters["ActivoFijoID"].DefaultValue = Page.Request.QueryString["ID"].ToString();
            }
        }
    }
}
