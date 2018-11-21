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

namespace ContabSysNet_Web.Bancos.ConsultasBancos.MovimientosBancarios
{
    public partial class MovimientosBancarios_page : System.Web.UI.Page
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            this.MovimientosBancarios_ListView.EnableDynamicData(typeof(MovimientosBancario));
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Master.Page.Title = "Movimientos bancarios - Consulta";

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
                    MyHtmlH2.InnerHtml = "Movimientos bancarios - Consulta";
                }

                // para que, inicialmente, el entity datasource no traiga registros ... 
                this.MovimientosBancarios_EntityDataSource.Where = "1 != 1"; 
            }

            else
            {
                if (RebindFlagHiddenField.Value == "1")
                {
                    RebindFlagHiddenField.Value = "0";

                    string sqlServerWhereString = Session["FiltroForma"].ToString();

                    //short mesConsulta = (short)Session["ActFijos_Consulta_Mes"];
                    //short anoConsulta = (short)Session["ActFijos_Consulta_Ano"];
                    //bool excluirActivosTotalmenteDepreciadosAnosAnteiores = (bool)Session["ActFijos_ExcluirDepreciadosAnosAnteriores"];
                    //bool aplicarInfoDesincorporados = (bool)Session["ActFijos_AplicarInfoDesincorporacion"];

                    CrearInfoReport(sqlServerWhereString); 
                                    //mesConsulta, 
                                    //anoConsulta, 
                                    //excluirActivosTotalmenteDepreciadosAnosAnteiores, 
                                    //aplicarInfoDesincorporados);

                    // ------------------------------------------------------------------------------------------------
                    // por último, refrescamos el ListView con la información preparada por la consulta ... 

                    //MovimientosBancarios_EntityDataSource.WhereParameters["NombreUsuario"].DefaultValue = User.Identity.Name.ToString();
                    MovimientosBancarios_ListView.DataBind();
                    this.MovimientosBancarios_ListView.SelectedIndex = -1; 
                }

            }
        }

        private void CrearInfoReport(string sqlServerWhereString)
        {
            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            // aplicamos el filtro indicado al EntityDataSource ... 

            this.MovimientosBancarios_EntityDataSource.Where = sqlServerWhereString; 
        }

        private short CantidadMesesEntreFechas(DateTime dateDesde, DateTime dateHasta)
        {
            short cantidadMeses = Convert.ToInt16((dateHasta.Year * 12 + dateHasta.Month) - (dateDesde.Year * 12 + dateDesde.Month));
            return Convert.ToInt16(cantidadMeses + 1); 
        }

        protected void ConsultaDisponibilidad_ListView_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected string FormatColorRow(string theData)
        {

            switch (theData)
            {
                case "IN":
                case "SA":
                case "TO":
                case "TC":
                    return "style='BACKGROUND-COLOR:#EFF3FF'";
                case "MR":
                    return "style='BACKGROUND-COLOR:#FFE8E5'";
                case "NE":
                    return "style='BACKGROUND-COLOR:#ADC1FF'";
                default:
                    return null;
            }

        }

        protected void ConsultaDepreciacion_ListView_PagePropertiesChanged(object sender, EventArgs e)
        {
            // el datasource no guarda el where clause en viewstate ... 
            string sqlServerWhereString = Session["FiltroForma"].ToString();
            this.MovimientosBancarios_EntityDataSource.Where = sqlServerWhereString; 

            // con cada página, 'deseleccionamos' el selected row ... 
            this.MovimientosBancarios_ListView.SelectedIndex = -1; 
        }

        protected void MovimientosBancarios_ListView_SelectedIndexChanging(object sender, ListViewSelectEventArgs e)
        {
            // el datasource no guarda el where clause en viewstate ... 
            string sqlServerWhereString = Session["FiltroForma"].ToString();
            this.MovimientosBancarios_EntityDataSource.Where = sqlServerWhereString; 
        }
    }
}