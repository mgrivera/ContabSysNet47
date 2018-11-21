using System;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.Xml.Linq;
using System.IO;
//using ContabSysNetWeb.Old_App_Code;
using System.Linq;
//using ContabSysNet_Web.old_app_code;
using ContabSysNet_Web.ModelosDatos_EF;
using System.Collections.Generic;
using System.Web.UI.HtmlControls;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using System.Text;
using System.Globalization;
using ContabSysNet_Web.Clases;

namespace ContabSysNetWeb.Contab.Consultas_contables.Comprobantes
{
    public partial class ComprobantesContables_Funciones : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!User.Identity.IsAuthenticated)
            {
                FormsAuthentication.SignOut();
                return;
            }

            GeneralMessage_Span.InnerHtml = "";
            GeneralMessage_Span.Style["display"] = "none";

            // -----------------------------------------------------------------------------------------

            if (!Page.IsPostBack)
            {
                HtmlGenericControl MyHtmlH2;

                MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
                if (!(MyHtmlH2 == null))
                {
                    MyHtmlH2.InnerHtml = "";
                }

                Master.Page.Title = "Asientos contables - Funciones";

                this.AsientosContables_Copiar_Fieldset.Visible = false;
                this.AsientosContables_Exportar_Fieldset.Visible = false;

                //string errorMessage = "Aparentemente, el criterio de ejecucción de esta conciliación no está correctamente establecido.<br /> " +
                //            "Por favor, intente establecer un criterio de ejecución para esta conciliación bancaria.";

                //CustomValidator1.IsValid = false;
                //CustomValidator1.ErrorMessage = errorMessage;
            }
        }

        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            switch (this.DropDownList1.SelectedIndex)
            {
                case 0:                     // Seleccione una opción ....  
                    this.AsientosContables_Copiar_Fieldset.Visible = false;
                    this.AsientosContables_Exportar_Fieldset.Visible = false;
                    this.DownloadFile_LinkButton.Visible = false;

                    break;
                case 1:                     // copiar asientos contables 
                    this.AsientosContables_Copiar_Fieldset.Visible = true;
                    this.AsientosContables_Exportar_Fieldset.Visible = false;
                    this.DownloadFile_LinkButton.Visible = false;

                    break;
                case 2:                     // exportar asientos contables 
                    this.AsientosContables_Copiar_Fieldset.Visible = false;
                    this.AsientosContables_Exportar_Fieldset.Visible = true;
                    this.DownloadFile_LinkButton.Visible = false;

                    break;
            }
        }

        protected void AsientosContables_Copiar_Button_Click(object sender, EventArgs e)
        {
            Page.Validate();
            if (!Page.IsValid)
            {
                return; 
            }

            string ajaxPopUpMessage = "";

            if (Session["filtroForma_consultaAsientosContables"] == null || string.IsNullOrEmpty(Session["filtroForma_consultaAsientosContables"].ToString()))
            {
                ajaxPopUpMessage = "<br />Aparentemente, Ud. no ha indicado un filtro a esta página.<br />" +
                    "Debe hacerlo, para que el programa lea y seleccione registros <em><b>antes que Ud. ejecute esta función</b></em>.";

                this.ModalPopupTitle_span.InnerHtml = "No se ha indicado un filtro a esta página";
                this.ModalPopupBody_span.InnerHtml = ajaxPopUpMessage;

                this.btnOk.Visible = false;
                this.btnCancel.Text = "Ok";

                this.ModalPopupExtender1.Show();

                return;
            }

            FuncionesContab2 funcionesContab = new FuncionesContab2();
            int cantidadAsientosCopiados = 0;
            string resultMessage = "";

            if (!funcionesContab.CopiarAsientosContables(Session["filtroForma_consultaAsientosContables"].ToString(),
                                                         Session["filtroForma_consultaAsientosContables_subQuery"].ToString(), 
                                                         Membership.GetUser().UserName,
                                                         Convert.ToInt32(CiaContab_DropDownList.SelectedValue),
                                                         this.multiplicarPor_textBox.Text, 
                                                         this.dividirPor_textBox.Text, 
                                                         out cantidadAsientosCopiados,
                                                         out resultMessage))
            {
                this.ModalPopupTitle_span.InnerHtml = "Error al intentar ejecutar la función";
                ajaxPopUpMessage = resultMessage;
            }
            else
            {
                this.ModalPopupTitle_span.InnerHtml = "Copia de asientos contables - Ejecución exitosa";

                ajaxPopUpMessage = "Ok, los asientos contables han sido copiados en forma exitosa, a la compañía <em>Contab</em> que se ha indicado.<br /><br />" +
                    "En total, se han copiado <b>" + cantidadAsientosCopiados.ToString() + "</b> asientos contables a la compañía seleccionada.";
            }

            this.ModalPopupBody_span.InnerHtml = ajaxPopUpMessage;
            this.btnOk.Visible = false;
            this.btnCancel.Text = "Ok";

            this.ModalPopupExtender1.Show();

            return;
        }



        protected void AsientosContables_Exportar_Button_Click(object sender, EventArgs e)
        {
            string ajaxPopUpMessage = "";

            if (Session["FiltroForma"] == null || string.IsNullOrEmpty(Session["FiltroForma"].ToString()))
            {
                ajaxPopUpMessage = "<br />Aparentemente, Ud. no ha indicado un filtro a esta página.<br />" +
                    "Debe hacerlo, para que el programa lea y seleccione registros <em><b>antes que Ud. ejecute esta función</b></em>.";

                this.ModalPopupTitle_span.InnerHtml = "No se ha indicado un filtro a esta página";
                this.ModalPopupBody_span.InnerHtml = ajaxPopUpMessage;

                this.btnOk.Visible = false;
                this.btnCancel.Text = "Ok";

                this.ModalPopupExtender1.Show();

                return;
            }

            FuncionesContab2 funcionesContab = new FuncionesContab2();
            int cantidadPartidasLeidas = 0;
            string resultMessage = "";
            string filePath = ""; 

            if (!funcionesContab.Exportar_AsientosContables(Session["FiltroForma"].ToString(),
                                                                  this.Formato_RadioButtonList.SelectedValue, 
                                                                  Membership.GetUser().UserName, 
                                                                  out cantidadPartidasLeidas,
                                                                  out filePath, 
                                                                  out resultMessage))
            {
                this.ModalPopupTitle_span.InnerHtml = "Error al intentar ejecutar la función";
                ajaxPopUpMessage = resultMessage;
            }
            else
            {
                this.ModalPopupTitle_span.InnerHtml = "Copia de asientos contables - Ejecución exitosa";

                ajaxPopUpMessage = "Ok, los asientos contables han sido exportados a un archivo, según el formato indicado por Ud.<br /><br />" +
                    "En total, se han leído y exportado " + cantidadPartidasLeidas.ToString() + " partidas, para los asientos contables seleccionados.<br /><br />" +
                    "Ahora Ud. debe copiar el archivo recién construído a su PC, usando el link que para ello se muestra al cerrar este díalogo.";
            }

            this.ModalPopupBody_span.InnerHtml = ajaxPopUpMessage;
            this.btnOk.Visible = false;
            this.btnCancel.Text = "Ok";

            this.DownloadFile_LinkButton.Visible = true;
            this.FileName_HiddenField.Value = filePath;

            this.ModalPopupExtender1.Show();

            return;
        }


        protected void btnOk_Click(object sender, EventArgs e)
        {

        }

        protected void DownloadFile_LinkButton_Click(object sender, EventArgs e)
        {
            // hacemos un download del archivo recién generado para que pueda ser copiado al disco duro 
            // local por del usuario 

            if (FileName_HiddenField.Value == null || FileName_HiddenField.Value == "")
            {
                this.ModalPopupTitle_span.InnerHtml = "Error al intentar copiar el archivo indicado";
                string ajaxPopUpMessage = "No se ha podido obtener el nombre del archivo generado. <br /><br /> Genere el archivo nuevamente y " + 
                    "luego intente copiarlo a su disco usando esta función."; ;

                this.ModalPopupBody_span.InnerHtml = ajaxPopUpMessage;
                this.btnOk.Visible = false;
                this.btnCancel.Text = "Ok";

                return;
            }


            FileStream liveStream = new FileStream(FileName_HiddenField.Value, FileMode.Open, FileAccess.Read);

            byte[] buffer = new byte[(int)liveStream.Length];
            liveStream.Read(buffer, 0, (int)liveStream.Length);
            liveStream.Close();

            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Length", buffer.Length.ToString());
            Response.AddHeader("Content-Disposition", "attachment; filename=" +
                               FileName_HiddenField.Value);
            Response.BinaryWrite(buffer);
            Response.End();

        }
    }
}
