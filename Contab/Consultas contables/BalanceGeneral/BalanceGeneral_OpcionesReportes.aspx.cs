
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;

using ContabSysNet_Web.ModelosDatos_EF.Contab;

namespace ContabSysNetWeb.Contab.Consultas_contables.BalanceGeneral
{
    public partial class BalanceGeneral_OpcionesReportes : System.Web.UI.Page
    {
        BalanceGeneral_Parametros _parametrosReporte; 

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                // -----------------------------------------------------------------------------------------------------------
                //  intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros 
                if (!(Membership.GetUser().UserName == null))
                {
                    KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
                    MyKeepPageState.ReadStateFromFile(this, this.Controls);
                    MyKeepPageState = null;
                }

                if (Session["BalanceGeneral_Parametros"] == null)
                {
                    string errorMessage = "Aparentemente, Ud. no ha definido un filtro para esta consulta.<br />" +
                        "Por favor defina un filtro para esta consulta antes de continuar.";

                    CustomValidator1.IsValid = false;
                    CustomValidator1.ErrorMessage = errorMessage;

                    return;
                }

                _parametrosReporte = Session["BalanceGeneral_Parametros"] as BalanceGeneral_Parametros;

                // a veces no queremos mostrar todas las opciones que propone el control (user control) 
                this.reportOptionsUserControl.MostrarSoloTotales = false;
                this.reportOptionsUserControl.MostrarOrientation = false;

                if (_parametrosReporte.BalGen_GyP == "BG")
                {
                    string desde = _parametrosReporte.Desde.ToString("dd-MMM-yyyy");
                    string hasta = _parametrosReporte.Hasta.ToString("dd-MMM-yyyy");

                    this.reportOptionsUserControl.Titulo = "Balance General";
                    this.reportOptionsUserControl.SubTitulo = $"Cifras al {hasta}";
                }
                else
                {
                    string desde = _parametrosReporte.Desde.ToString("dd-MMM-yyyy");
                    string hasta = _parametrosReporte.Hasta.ToString("dd-MMM-yyyy");

                    this.reportOptionsUserControl.Titulo = "Estado de Resultados";
                    this.reportOptionsUserControl.SubTitulo = $"Desde {desde} hasta {hasta}";
                }
            }
        }

        protected void Ok_Button_Click(object sender, EventArgs e)
        {
            // -------------------------------------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando se abra la proxima vez 

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
            MyKeepPageState.SavePageStateInFile(this.Controls);
            MyKeepPageState = null;
            // ---------------------------------------------------------------------------------------------
            var parametrosBalanceGeneral = _parametrosReporte = Session["BalanceGeneral_Parametros"] as BalanceGeneral_Parametros;
          
            // leemos la moneda seleccionada para obtener el símbolo y pasar al reporte 
            StringBuilder pageParams = new StringBuilder("rpt=balancegeneral");

            pageParams.Append("&tit=" + this.reportOptionsUserControl.Titulo);
            pageParams.Append("&subtit=" + this.reportOptionsUserControl.SubTitulo);
            pageParams.Append("&format=" + this.reportOptionsUserControl.Format);
            pageParams.Append("&orientation=" + this.reportOptionsUserControl.Orientation);
            pageParams.Append("&color=" + this.reportOptionsUserControl.Colors.ToString());
            pageParams.Append("&simpleFont=" + this.reportOptionsUserControl.MatrixPrinter.ToString());
            pageParams.Append("&st=" + this.reportOptionsUserControl.MostrarSoloTotales.ToString());
            pageParams.Append("&cantniveles=" + this.CantidadNiveles_DropDownList.SelectedValue.ToString());
            pageParams.Append("&soloSaldoFinal=" + (this.SoloColumnaSaldoFinal_CheckBox.Checked ? "si" : "no"));

            Response.Redirect("~/ReportViewer.aspx?" + pageParams.ToString());
        }
    }
}