using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using ContabSysNet_Web.ModelosDatos_EF.ActivosFijos;

namespace ContabSysNet_Web.ActivosFijos.Consultas.DepreciacionMensual
{
    public partial class DepreciacionMensual_OpcionesReportes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //  intentamos recuperar el state de esta página ... 

            if (!Page.IsPostBack)
            {
                if (!User.Identity.IsAuthenticated)
                {
                    FormsAuthentication.SignOut();
                    return;
                }

                if (!(Membership.GetUser().UserName == null))
                {
                    KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
                    MyKeepPageState.ReadStateFromFile(this, this.Controls);
                    MyKeepPageState = null;

                    if (string.IsNullOrEmpty(this.TituloReporte_TextBox.Text))
                        this.TituloReporte_TextBox.Text = "Depreciación de Activos Fijos - Consulta";
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

            // -----------------------------------------------------------------------------------------------------------
            // obtenemos en este momento el string que muestra la cantidad de meses transcurridos, desde el inicio del mes 
            // fiscal hasta la fecha de la consulta; por ejemplo: Mar-Ago ... 
            string construirPeriodoTranscurridoAnoFiscal = ConstruirPeriodoTranscurridoAnoFiscal();
            // -----------------------------------------------------------------------------------------------------------

            short mesConsulta = (short)Session["ActFijos_Consulta_Mes"];
            short anoConsulta = (short)Session["ActFijos_Consulta_Ano"];

            Response.Redirect("~/ReportViewer3.aspx?rpt=activosFijosDepreciacion&tit=" + 
                TituloReporte_TextBox.Text + "&subtit=" +
                SubTituloReporte_TextBox.Text + "&mes=" + mesConsulta.ToString() + "&ano=" + anoConsulta.ToString() + 
                "&soloTotales=" + this.VersionSoloTotales_CheckBox.Checked.ToString() + 
                "&periodo=" + construirPeriodoTranscurridoAnoFiscal);
        }

        private string ConstruirPeriodoTranscurridoAnoFiscal()
        {
            // regresamos el período transcurrido (en meses) desde el inicio del año fiscal de la compañía seleccionada (siempre hay una y no más de una), 
            // y la fecha de la consulta; por ejemplo: Mar-Ago, para una compañia que comienza su año fiscal en Marzo y la consulta se pide para Agosto ... 

            // nótese lo que hacemos para obtener la compañía seleccionada para la consulta; no podemos recibir este valor desde el asp.net control, pues 
            // estamos en el encabezado de la tabla y no en un row ... 

            string nombre1erMesAnoFiscal;
            string nombreMesConsulta;

            using (dbContab_ActFijos_Entities ctx = new dbContab_ActFijos_Entities())
            {
                int? ciaContabSeleccionada = ctx.tTempActivosFijos_ConsultaDepreciacion.Where(a => a.NombreUsuario == User.Identity.Name).
                                                                                        Select(a => a.InventarioActivosFijo.Cia).
                                                                                        FirstOrDefault();

                if (ciaContabSeleccionada == null)
                    return "";

                // leemos el mes calendario que corresponde al 1er. mes fiscal de la compañía 

                nombre1erMesAnoFiscal = ctx.MesesDelAnoFiscals.Where(m => m.Cia == ciaContabSeleccionada && m.MesFiscal == 1).
                                                               Select(m => m.NombreMes).
                                                               FirstOrDefault();

                if (string.IsNullOrEmpty(nombre1erMesAnoFiscal))
                    return "";

                // aquí debe venir el nombre del mes de la consulta (que indicó el usuario en el filtro) 

                if (Session["ActFijos_Consulta_NombreMes"] == null)
                    return "";

                if (string.IsNullOrEmpty(Session["ActFijos_Consulta_NombreMes"].ToString()))
                    return "";

                nombreMesConsulta = Session["ActFijos_Consulta_NombreMes"].ToString();
            }

            return "(" + nombre1erMesAnoFiscal.Substring(0, 3) + "-" + nombreMesConsulta.Substring(0, 3) + ")";
        }
    }
}