using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ContabSysNetWeb.Contab.Consultas_contables.Comprobantes
{
    public partial class OpcionesReportes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            ErrMessage_Span.InnerHtml = "";
            ErrMessage_Span.Style["display"] = "none";

            GeneralMessage_Span.InnerHtml = "";
            GeneralMessage_Span.Style["display"] = "none";

            if (!Page.IsPostBack)
            {
                if (!(Membership.GetUser().UserName == null))
                {
                    KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
                    MyKeepPageState.ReadStateFromFile(this, this.Controls);
                    MyKeepPageState = null;
                }

                if (string.IsNullOrEmpty(this.reportOptionsUserControl.Titulo))
                    this.reportOptionsUserControl.Titulo = "Comprobantes Contables";
            }
        }

        protected void Ok_Button_Click(object sender, EventArgs e)
        {
            if (this.Fecha_CheckBox.Checked)
            {
                if (!this.fechaHoy_RadioButton.Checked && !this.fechaPropia_RadioButton.Checked)
                {
                    string errorMessage = "Error: Ud. debe indicar si desea mostrar la fecha del día (automática) o una propia (indicada por Ud.).";
                    ErrMessage_Span.InnerHtml = errorMessage;
                    ErrMessage_Span.Style["display"] = "block";

                    return;
                }
            }

            // --------------------------------------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando se abra la proxima vez
            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, Page.GetType().Name);
            MyKeepPageState.SavePageStateInFile(this.Controls);
            MyKeepPageState = null;
            // --------------------------------------------------------------------------------------------------------------------------

            StringBuilder pageParams = new StringBuilder("rpt=comprobantescontables");

            pageParams.Append("&opc=0");
            pageParams.Append("&tit=" + this.reportOptionsUserControl.Titulo); 
            pageParams.Append("&subtit=" + this.reportOptionsUserControl.SubTitulo);
            pageParams.Append("&format=" + this.reportOptionsUserControl.Format);
            pageParams.Append("&orientation=" + this.reportOptionsUserControl.Orientation);
            pageParams.Append("&color=" + this.reportOptionsUserControl.Colors.ToString());
            pageParams.Append("&simpleFont=" + this.reportOptionsUserControl.MatrixPrinter.ToString()); 

            // una o dos columnas; aunque solo aplica a opción vertical, siempre la pasamos ... 
            if (this.unaColumna_RadioButton.Checked)
                pageParams.Append("&debeHaber=no"); 
            else if (this.dosColumna_RadioButton.Checked) 
                pageParams.Append("&debeHaber=si");


            // el usuario puede mostrar la fecha del día en el listado, o indicar una propia; también puede indicar que no quiere una fecha ... 
            if (this.Fecha_CheckBox.Checked)
            {
                pageParams.Append("&mostrarFecha=si"); 
                if (this.fechaHoy_RadioButton.Checked)
                {
                    pageParams.Append("&fechaHoy=si"); 
                }
                else
                {
                    pageParams.Append("&fechaHoy=no");
                    pageParams.Append("&fechaPropia=" + this.FechaPropia_TextBox.Text); 
                }
            }

            if (this.SaltoPaginaAsiento_RadioButton.Checked)
                pageParams.Append("&saltoPagina=asiento");

            if (this.SaltoPaginaFecha_RadioButton.Checked)
                pageParams.Append("&saltoPagina=fecha");

            if (this.orderByFecha_RadioButton.Checked)
                pageParams.Append("&orderBy=fecha");

            if (this.orderByNumero_RadioButton.Checked)
                pageParams.Append("&orderBy=comprobante");

            // agregamos este flag luego de la reconversión del 1-Oct-21 
            // la idea es que el usuario pueda decidir si reconvertir montos
            bool bReconvertirCifrasAntes_01Oct2021 = (bool)Session["ReconvertirCifrasAntes_01Oct2021"];

            if (bReconvertirCifrasAntes_01Oct2021)
                pageParams.Append("&reconvertir2021=si");

            Response.Redirect("~/ReportViewer.aspx?" + pageParams.ToString());
        }
    }
}