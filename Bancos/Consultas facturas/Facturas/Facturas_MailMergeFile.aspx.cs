using System;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.IO;
using System.Text;
using System.Linq;
using System.Web.UI.WebControls;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using DocumentFormat.OpenXml.Packaging;
using System.Collections.Generic;
using OpenXmlPowerTools; 

namespace ContabSysNet_Web.Bancos.Consultas_facturas.Facturas
{
    public partial class Facturas_MailMergeFile : System.Web.UI.Page
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

            // -----------------------------------------------------------------------------------------

            Master.Page.Title = "Generación de archivo para 'combinación de correspondencia' en Microsoft Word";

            DownloadFile_LinkButton.Visible = false;

            if (!Page.IsPostBack)
            {
                // -------------------------------------------------------------------------------------------------------------------
                //  intentamos recuperar el state de esta página; en general, lo intentamos con popups filtros 

                if (!(Membership.GetUser().UserName == null))
                {
                    KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
                    MyKeepPageState.ReadStateFromFile(this, this.Controls);
                    MyKeepPageState = null;
                }
                // -------------------------------------------------------------------------------------------------------------------


                this.OpcionesMailMerge_DropDownList.SelectedValue = "0";
                Session["FileToDownload"] = null; 
            }

           
        }

        protected void GenerarTextFile_Button_Click(object sender, EventArgs e)
        {
            int selectedValue = Convert.ToInt32(this.OpcionesMailMerge_DropDownList.SelectedValue.ToString());

            if (selectedValue == 0)
                return;

            switch (selectedValue)
            {
                case 1:
                    {
                        GenerarArchivo_FacturasImpresas(); 
                        break;
                    }
                case 2:
                    {
                        GenerarArchivo_CartasISLRRetenido(); 
                        break;
                    }
            }

            // -------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando 
            // se abra la proxima vez 

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
            MyKeepPageState.SavePageStateInFile(this.Controls);
            MyKeepPageState = null;
            // ---------------------------------------------------------------------------------------------
        }

        private void GenerarCartasGenericas()
        {
        }

        private void GenerarArchivo_FacturasImpresas()
        {
            StringBuilder sb;

            // Create the CSV file on the server 

            String fileName = @"Facturas_" + User.Identity.Name + ".txt";
            String filePath = HttpContext.Current.Server.MapPath("~/Temp/" + fileName);

            StreamWriter sw = new StreamWriter(filePath, false);

            // First we will write the headers.

            sb = new StringBuilder();

            sb.Append("\"CiaContabNombre\"");
            sb.Append("\t");
            sb.Append("\"CiaContabDireccion\"");
            sb.Append("\t");
            sb.Append("\"CiaContabRif\"");
            sb.Append("\t");
            sb.Append("\"CiaContabTelefono1\"");
            sb.Append("\t");
            sb.Append("\"CiaContabTelefono2\"");
            sb.Append("\t");
            sb.Append("\"CiaContabFax\"");
            sb.Append("\t");

            sb.Append("\"FacturaNumero\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaEmision\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaRecepcion\"");
            sb.Append("\t");

            sb.Append("\"CompaniaNombre\"");
            sb.Append("\t");
            sb.Append("\"CompaniaRif\"");
            sb.Append("\t");
            sb.Append("\"CompaniaDomicilio\"");
            sb.Append("\t");
            sb.Append("\"CompaniaTelefono\"");
            sb.Append("\t");
            sb.Append("\"CompaniaFax\"");
            sb.Append("\t");

            sb.Append("\"CondicionesDePagoNombre\"");
            sb.Append("\t");

            sb.Append("\"FacturaConcepto\"");
            sb.Append("\t");
            sb.Append("\"FacturaMonto\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoNoImponible\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoImponible\"");
            sb.Append("\t");
            sb.Append("\"FacturaIvaPorc\"");
            sb.Append("\t");
            sb.Append("\"FacturaIva\"");
            sb.Append("\t");
            sb.Append("\"FacturaTotal\"");
            sb.Append("\t");

            sb.Append("\"FacturaNotas1\"");
            sb.Append("\t");
            sb.Append("\"FacturaNotas2\"");
            sb.Append("\t");
            sb.Append("\"FacturaNotas3\"");

            sw.Write(sb.ToString());
            sw.Write(sw.NewLine);

            // Now write all the rows.

            // declaramos el EF context ... 
            BancosEntities bancosContext = new BancosEntities(); 

            // leemos las facturas filtradas por el usuario desde la tabla tTempWebReport_ConsultaFacturas
            var facturasQuery = from f in bancosContext.tTempWebReport_ConsultaFacturas
                                where f.NombreUsuario == User.Identity.Name
                                orderby f.NumeroFactura
                                select f;

            int cantidadRegistrosLeidos = 0;

            foreach (var f in facturasQuery)
            {
                //sw.Write(",");
                //sw.Write(sw.NewLine);

                sb = new StringBuilder();

                if (f.CiaContabNombre != null)
                    sb.Append("\"" + f.CiaContabNombre + "\"");
                sb.Append("\t");
                if (f.CiaContabDireccion != null)
                    sb.Append("\"" + f.CiaContabDireccion + "\"");
                sb.Append("\t");
                if (f.CiaContabRif != null)
                    sb.Append("\"" + f.CiaContabRif + "\"");
                sb.Append("\t");
                if (f.CiaContabTelefono1 != null)
                    sb.Append("\"" + f.CiaContabTelefono1 + "\"");
                sb.Append("\t");
                if (f.CiaContabTelefono2 != null)
                    sb.Append("\"" + f.CiaContabTelefono2 + "\"");
                sb.Append("\t");
                if (f.CiaContabFax != null)
                    sb.Append("\"" + f.CiaContabFax + "\"");
                sb.Append("\t");

                if (f.NumeroFactura != null)
                    sb.Append("\"" + f.NumeroFactura + "\"");
                sb.Append("\t");
                if (f.FechaEmision != null)
                    sb.Append("\"" + f.FechaEmision.ToString("dd-MM-yyyy") + "\"");
                sb.Append("\t");
                if (f.FechaRecepcion != null)
                    sb.Append("\"" + f.FechaRecepcion.ToString("dd-MM-yyyy") + "\"");
                sb.Append("\t");

                if (f.NombreCompania != null)
                    sb.Append("\"" + f.NombreCompania + "\"");
                sb.Append("\t");
                if (f.RifCompania != null)
                    sb.Append("\"" + f.RifCompania + "\"");
                sb.Append("\t");
                if (f.CompaniaDomicilio != null)
                    sb.Append("\"" + f.CompaniaDomicilio + "\"");
                sb.Append("\t");
                if (f.CompaniaTelefono != null)
                    sb.Append("\"" + f.CompaniaTelefono + "\"");
                sb.Append("\t");
                if (f.CompaniaFax != null)
                    sb.Append("\"" + f.CompaniaFax + "\"");
                sb.Append("\t");

                if (f.CondicionesDePagoNombre != null)
                    sb.Append("\"" + f.CondicionesDePagoNombre + "\"");
                sb.Append("\t");

                if (f.Concepto != null)
                    sb.Append("\"" + f.Concepto + "\"");
                sb.Append("\t");

                decimal montoFactura = f.MontoFacturaSinIva.Value + f.MontoFacturaConIva.Value;

                sb.Append("\"" + montoFactura.ToString("N2") + "\"");
                sb.Append("\t");
                if (f.MontoFacturaSinIva != null)
                    sb.Append("\"" + f.MontoFacturaSinIva.Value.ToString("N2") + "\"");
                sb.Append("\t");
                if (f.MontoFacturaConIva != null)
                    sb.Append("\"" + f.MontoFacturaConIva.Value.ToString("N2") + "\"");
                sb.Append("\t");




                if (f.Iva != null && f.Iva != 0)
                {
                    // aunque el monto de Iva está resumido en la factura, lo obtenemos de la tabla 
                    // Facturas_Impuestos ... 

                    Factura factura = bancosContext.Facturas.Include("Facturas_Impuestos").Where(x => x.ClaveUnica == f.ClaveUnicaFactura).FirstOrDefault();

                    if (factura != null)
                    {
                        // la factura siempre debe existir 

                        decimal montoIva = 0;
                        decimal porcIva = 0;

                        foreach (Facturas_Impuestos impuesto in factura.Facturas_Impuestos.Where(i => i.ImpuestosRetencionesDefinicion.Predefinido == 1))
                            montoIva += impuesto.Monto;

                        if (factura.MontoFacturaConIva != null && factura.MontoFacturaConIva.Value != 0)
                            porcIva = montoIva * 100 / factura.MontoFacturaConIva.Value;

                        sb.Append("\"" + porcIva.ToString("N2") + "\"");
                        sb.Append("\t");
                        sb.Append("\"" + montoIva.ToString("N2") + "\"");
                        montoFactura += f.Iva.Value;
                    }
                    else
                    {
                        sb.Append("\"" + "0,00" + "\"");
                        sb.Append("\t");
                        sb.Append("\"" + "0,00" + "\"");
                    }
                }
                else
                {
                    sb.Append("\"" + "0,00" + "\"");
                    sb.Append("\t");
                    sb.Append("\"" + "0,00" + "\"");
                }

                sb.Append("\t");
                sb.Append("\"" + f.TotalFactura.ToString("N2") + "\"");
                sb.Append("\t");

                if (f.NotasFactura1 != null)
                    sb.Append("\"" + f.NotasFactura1 + "\"");
                sb.Append("\t");
                if (f.NotasFactura2 != null)
                    sb.Append("\"" + f.NotasFactura2 + "\"");
                sb.Append("\t");
                if (f.NotasFactura3 != null)
                    sb.Append("\"" + f.NotasFactura3 + "\"");

                sw.Write(sb.ToString());
                sw.Write(sw.NewLine);

                cantidadRegistrosLeidos++;
            }

            // finally close the file 
            sw.Close();

            if (cantidadRegistrosLeidos == 0)
            {
                ErrMessage_Span.InnerHtml = "No existe información para construir el archivo que Ud. ha requerido. " +
                    "<br /><br /> Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
                ErrMessage_Span.Style["display"] = "block";

                bancosContext = null;
                return;
            }

            bancosContext = null;

            GeneralMessage_Span.InnerHtml = "Ok, el archivo requerido ha sido generado en forma satisfactoria. <br />" +
                "La cantidad de lineas que se han grabado al archivo es: " + cantidadRegistrosLeidos.ToString() + ".<br /><br />" +
                "Haga un click al <em>link</em> que existe en la parte izquierda de esta página para obtener (<em>download</em>) el documento."; 
            GeneralMessage_Span.Style["display"] = "block";

            Session["FileToDownload"] = filePath; 

            //DownloadFile_LinkButton.Visible = true;
            //FileName_HiddenField.Value = filePath;
        }

        private void GenerarArchivo_CartasISLRRetenido()
        {
            StringBuilder sb;

            // Create the CSV file on the server 

            String fileName = @"CartaImpuestosRetenidos_" + User.Identity.Name + ".txt";
            String filePath = HttpContext.Current.Server.MapPath("~/Temp/" + fileName);

            StreamWriter sw = new StreamWriter(filePath, false);

            // First we will write the headers.

            sb = new StringBuilder();

            sb.Append("\"FechaConsulta\"");
            sb.Append("\t");
            sb.Append("\"NumeroPagina\"");
            sb.Append("\t");

            sb.Append("\"ProveedorNombre\"");
            sb.Append("\t");
            sb.Append("\"ProveedorRif\"");
            sb.Append("\t");
            sb.Append("\"ProveedorNit\"");
            sb.Append("\t");
            sb.Append("\"ProveedorDomicilio\"");
            sb.Append("\t");
            sb.Append("\"ProveedorCiudad\"");
            sb.Append("\t");

            sb.Append("\"CiaContabNombre\"");
            sb.Append("\t");
            sb.Append("\"CiaContabRif\"");
            sb.Append("\t");
            sb.Append("\"CiaContabDireccion\"");
            sb.Append("\t");
            sb.Append("\"CiaContabCiudad\"");
            sb.Append("\t");

            sb.Append("\"PeriodoRetencion\"");
            sb.Append("\t");

            // campos para totales por proveedor 

            sb.Append("\"Total_CantidadDocumentos\"" + "\t");
            sb.Append("\"Total_CantidadPaginas\"" + "\t");
            sb.Append("\"Total_MontoFactura\"" + "\t");
            sb.Append("\"Total_MontoNoImponible\"" + "\t");
            sb.Append("\"Total_Iva\"" + "\t");
            sb.Append("\"Total_TotalFactura\"" + "\t");
            sb.Append("\"Total_MontoSujetoARetencion\"" + "\t");
            sb.Append("\"Total_RetencionISLRAntesSustraendo\"" + "\t");
            sb.Append("\"Total_ImpuestoISLRSustraendo\"" + "\t");
            sb.Append("\"Total_ImpuestoISLRRetenido\"" + "\t");

            // ahora repetimos las facturas hasta 10, para obtener este número en cada documento ... 

            // linea # 1 
            sb.Append("\"FacturaFechaEmision_1\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaRecepcion_1\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaPago_1\"");
            sb.Append("\t");
            sb.Append("\"FacturaNumero_1\"");
            sb.Append("\t");
            sb.Append("\"FacturaMonto_1\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoNoImponible_1\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoImponible_1\"");
            sb.Append("\t");
            sb.Append("\"FacturaIvaPorc_1\"");
            sb.Append("\t");
            sb.Append("\"FacturaIva_1\"");
            sb.Append("\t");
            sb.Append("\"FacturaTotal_1\"");
            sb.Append("\t");
            sb.Append("\"MontoSujetoARetencion_1\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoPorc_1\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoAntesSustraendo_1\"");
            sb.Append("\t");
            sb.Append("\"Sustraendo_1\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenido_1\"");
            sb.Append("\t");

            // linea # 2 
            sb.Append("\"FacturaFechaEmision_2\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaRecepcion_2\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaPago_2\"");
            sb.Append("\t");
            sb.Append("\"FacturaNumero_2\"");
            sb.Append("\t");
            sb.Append("\"FacturaMonto_2\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoNoImponible_2\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoImponible_2\"");
            sb.Append("\t");
            sb.Append("\"FacturaIvaPorc_2\"");
            sb.Append("\t");
            sb.Append("\"FacturaIva_2\"");
            sb.Append("\t");
            sb.Append("\"FacturaTotal_2\"");
            sb.Append("\t");
            sb.Append("\"MontoSujetoARetencion_2\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoPorc_2\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoAntesSustraendo_2\"");
            sb.Append("\t");
            sb.Append("\"Sustraendo_2\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenido_2\"");
            sb.Append("\t");

            // linea # 3 
            sb.Append("\"FacturaFechaEmision_3\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaRecepcion_3\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaPago_3\"");
            sb.Append("\t");
            sb.Append("\"FacturaNumero_3\"");
            sb.Append("\t");
            sb.Append("\"FacturaMonto_3\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoNoImponible_3\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoImponible_3\"");
            sb.Append("\t");
            sb.Append("\"FacturaIvaPorc_3\"");
            sb.Append("\t");
            sb.Append("\"FacturaIva_3\"");
            sb.Append("\t");
            sb.Append("\"FacturaTotal_3\"");
            sb.Append("\t");
            sb.Append("\"MontoSujetoARetencion_3\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoPorc_3\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoAntesSustraendo_3\"");
            sb.Append("\t");
            sb.Append("\"Sustraendo_3\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenido_3\"");
            sb.Append("\t");

            // linea # 4 
            sb.Append("\"FacturaFechaEmision_4\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaRecepcion_4\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaPago_4\"");
            sb.Append("\t");
            sb.Append("\"FacturaNumero_4\"");
            sb.Append("\t");
            sb.Append("\"FacturaMonto_4\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoNoImponible_4\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoImponible_4\"");
            sb.Append("\t");
            sb.Append("\"FacturaIvaPorc_4\"");
            sb.Append("\t");
            sb.Append("\"FacturaIva_4\"");
            sb.Append("\t");
            sb.Append("\"FacturaTotal_4\"");
            sb.Append("\t");
            sb.Append("\"MontoSujetoARetencion_4\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoPorc_4\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoAntesSustraendo_4\"");
            sb.Append("\t");
            sb.Append("\"Sustraendo_4\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenido_4\"");
            sb.Append("\t");

            // linea # 5 
            sb.Append("\"FacturaFechaEmision_5\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaRecepcion_5\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaPago_5\"");
            sb.Append("\t");
            sb.Append("\"FacturaNumero_5\"");
            sb.Append("\t");
            sb.Append("\"FacturaMonto_5\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoNoImponible_5\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoImponible_5\"");
            sb.Append("\t");
            sb.Append("\"FacturaIvaPorc_5\"");
            sb.Append("\t");
            sb.Append("\"FacturaIva_5\"");
            sb.Append("\t");
            sb.Append("\"FacturaTotal_5\"");
            sb.Append("\t");
            sb.Append("\"MontoSujetoARetencion_5\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoPorc_5\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoAntesSustraendo_5\"");
            sb.Append("\t");
            sb.Append("\"Sustraendo_5\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenido_5\"");
            sb.Append("\t");

            // linea # 6
            sb.Append("\"FacturaFechaEmision_6\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaRecepcion_6\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaPago_6\"");
            sb.Append("\t");
            sb.Append("\"FacturaNumero_6\"");
            sb.Append("\t");
            sb.Append("\"FacturaMonto_6\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoNoImponible_6\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoImponible_6\"");
            sb.Append("\t");
            sb.Append("\"FacturaIvaPorc_6\"");
            sb.Append("\t");
            sb.Append("\"FacturaIva_6\"");
            sb.Append("\t");
            sb.Append("\"FacturaTotal_6\"");
            sb.Append("\t");
            sb.Append("\"MontoSujetoARetencion_6\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoPorc_6\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoAntesSustraendo_6\"");
            sb.Append("\t");
            sb.Append("\"Sustraendo_6\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenido_6\"");
            sb.Append("\t");

            // linea # 7
            sb.Append("\"FacturaFechaEmision_7\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaRecepcion_7\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaPago_7\"");
            sb.Append("\t");
            sb.Append("\"FacturaNumero_7\"");
            sb.Append("\t");
            sb.Append("\"FacturaMonto_7\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoNoImponible_7\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoImponible_7\"");
            sb.Append("\t");
            sb.Append("\"FacturaIvaPorc_7\"");
            sb.Append("\t");
            sb.Append("\"FacturaIva_7\"");
            sb.Append("\t");
            sb.Append("\"FacturaTotal_7\"");
            sb.Append("\t");
            sb.Append("\"MontoSujetoARetencion_7\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoPorc_7\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoAntesSustraendo_7\"");
            sb.Append("\t");
            sb.Append("\"Sustraendo_7\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenido_7\"");
            sb.Append("\t");

            // linea # 8
            sb.Append("\"FacturaFechaEmision_8\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaRecepcion_8\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaPago_8\"");
            sb.Append("\t");
            sb.Append("\"FacturaNumero_8\"");
            sb.Append("\t");
            sb.Append("\"FacturaMonto_8\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoNoImponible_8\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoImponible_8\"");
            sb.Append("\t");
            sb.Append("\"FacturaIvaPorc_8\"");
            sb.Append("\t");
            sb.Append("\"FacturaIva_8\"");
            sb.Append("\t");
            sb.Append("\"FacturaTotal_8\"");
            sb.Append("\t");
            sb.Append("\"MontoSujetoARetencion_8\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoPorc_8\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoAntesSustraendo_8\"");
            sb.Append("\t");
            sb.Append("\"Sustraendo_8\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenido_8\"");
            sb.Append("\t");

            // linea # 9
            sb.Append("\"FacturaFechaEmision_9\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaRecepcion_9\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaPago_9\"");
            sb.Append("\t");
            sb.Append("\"FacturaNumero_9\"");
            sb.Append("\t");
            sb.Append("\"FacturaMonto_9\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoNoImponible_9\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoImponible_9\"");
            sb.Append("\t");
            sb.Append("\"FacturaIvaPorc_9\"");
            sb.Append("\t");
            sb.Append("\"FacturaIva_9\"");
            sb.Append("\t");
            sb.Append("\"FacturaTotal_9\"");
            sb.Append("\t");
            sb.Append("\"MontoSujetoARetencion_9\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoPorc_9\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoAntesSustraendo_9\"");
            sb.Append("\t");
            sb.Append("\"Sustraendo_9\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenido_9\"");
            sb.Append("\t");

            // linea # 10
            sb.Append("\"FacturaFechaEmision_10\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaRecepcion_10\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaPago_10\"");
            sb.Append("\t");
            sb.Append("\"FacturaNumero_10\"");
            sb.Append("\t");
            sb.Append("\"FacturaMonto_10\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoNoImponible_10\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoImponible_10\"");
            sb.Append("\t");
            sb.Append("\"FacturaIvaPorc_10\"");
            sb.Append("\t");
            sb.Append("\"FacturaIva_10\"");
            sb.Append("\t");
            sb.Append("\"FacturaTotal_10\"");
            sb.Append("\t");
            sb.Append("\"MontoSujetoARetencion_10\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoPorc_10\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoAntesSustraendo_10\"");
            sb.Append("\t");
            sb.Append("\"Sustraendo_10\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenido_10\"");
            sb.Append("\t");

            // linea # 11
            sb.Append("\"FacturaFechaEmision_11\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaRecepcion_11\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaPago_11\"");
            sb.Append("\t");
            sb.Append("\"FacturaNumero_11\"");
            sb.Append("\t");
            sb.Append("\"FacturaMonto_11\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoNoImponible_11\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoImponible_11\"");
            sb.Append("\t");
            sb.Append("\"FacturaIvaPorc_11\"");
            sb.Append("\t");
            sb.Append("\"FacturaIva_11\"");
            sb.Append("\t");
            sb.Append("\"FacturaTotal_11\"");
            sb.Append("\t");
            sb.Append("\"MontoSujetoARetencion_11\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoPorc_11\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoAntesSustraendo_11\"");
            sb.Append("\t");
            sb.Append("\"Sustraendo_11\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenido_11\"");
            sb.Append("\t");

            // linea # 12
            sb.Append("\"FacturaFechaEmision_12\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaRecepcion_12\"");
            sb.Append("\t");
            sb.Append("\"FacturaFechaPago_12\"");
            sb.Append("\t");
            sb.Append("\"FacturaNumero_12\"");
            sb.Append("\t");
            sb.Append("\"FacturaMonto_12\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoNoImponible_12\"");
            sb.Append("\t");
            sb.Append("\"FacturaMontoImponible_12\"");
            sb.Append("\t");
            sb.Append("\"FacturaIvaPorc_12\"");
            sb.Append("\t");
            sb.Append("\"FacturaIva_12\"");
            sb.Append("\t");
            sb.Append("\"FacturaTotal_12\"");
            sb.Append("\t");
            sb.Append("\"MontoSujetoARetencion_12\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoPorc_12\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenidoAntesSustraendo_12\"");
            sb.Append("\t");
            sb.Append("\"Sustraendo_12\"");
            sb.Append("\t");
            sb.Append("\"ImpuestoRetenido_12\"");

            // completamos y escribimos la línea al archivo 
            sw.Write(sb.ToString());
            sw.Write(sw.NewLine);


            // ------------------------------------------------------------------------------------------------------------
            // construimos aquí la fecha del documento y el período de retención, para usarlo más adelante ... 

            DateTime fechaConsulta = DateTime.Today;

            if (!string.IsNullOrEmpty(this.FechaConsulta_TextBox.Text))
                if (!DateTime.TryParse(this.FechaConsulta_TextBox.Text, out fechaConsulta))
                    fechaConsulta = DateTime.Today;


            DateTime periodoRetencionDesde = DateTime.Now;
            DateTime periodoRetencionHasta = DateTime.Now;

            DateTime.TryParse(this.PeriodoRetencion_Desde_TextBox.Text, out periodoRetencionDesde);
            DateTime.TryParse(this.PeriodoRetencion_Hasta_TextBox.Text, out periodoRetencionHasta);
            // ------------------------------------------------------------------------------------------------------------



            // Now write all the rows.

            // declaramos el EF context ... 
            BancosEntities bancosContext = new BancosEntities(); 

            // leemos las facturas filtradas por el usuario desde la tabla tTempWebReport_ConsultaFacturas
            var facturasPorProveedorQuery = from f in bancosContext.tTempWebReport_ConsultaFacturas
                                            where f.NombreUsuario == User.Identity.Name
                                            orderby f.NombreCompania, f.FechaRecepcion, f.NumeroFactura
                                            group f by new
                                            {
                                                f.NombreCompania,
                                                f.RifCompania,
                                                f.NitCompania,
                                                f.CompaniaDomicilio,
                                                f.CompaniaCiudad,
                                                f.CiaContabNombre,
                                                f.CiaContabRif,
                                                f.CiaContabDireccion,
                                                f.CiaContabCiudad
                                            }
                                                into g
                                                select new
                                                {
                                                    Key = g.Key,
                                                    Total_CantidadDocumentos = g.Count(),
                                                    Total_MontoFactura = g.Sum(f => f.MontoFacturaConIva + f.MontoFacturaSinIva),
                                                    Total_MontoNoImponible = g.Sum(f => f.MontoFacturaSinIva),
                                                    Total_Iva = g.Sum(f => f.Iva),
                                                    Total_TotalFactura = g.Sum(f => f.TotalFactura),
                                                    Total_MontoSujetoARetencion = g.Sum(f => f.MontoSujetoARetencion),
                                                    Total_RetencionISLRAntesSustraendo = g.Sum(f => f.ImpuestoRetenidoISLRAntesSustraendo),
                                                    Total_ImpuestoISLRSustraendo = g.Sum(f => f.ImpuestoRetenidoISLRSustraendo),
                                                    Total_ImpuestoISLRRetenido = g.Sum(f => f.ImpuestoRetenido),
                                                    Value = g       // aquí vienen todas las facturas para el grupo ... 
                                                };


            int cantidadRegistrosLeidos = 0;
            int numeroPagina = 0;

            foreach (var f in facturasPorProveedorQuery)
            {
                sb = new StringBuilder();

                numeroPagina = 1;

                sb.Append("\"" + string.Format("{0} de {1} de {2}", fechaConsulta.Day.ToString(), fechaConsulta.ToString("MMMM"), fechaConsulta.ToString("yyyy"))
                        + "\"");
                sb.Append("\t");

                sb.Append("\"" + "Página " + numeroPagina.ToString() + "\"");
                sb.Append("\t");

                // -------------------------------------------------------------------------------
                // datos del proveedor ... 

                if (f.Key.NombreCompania != null)
                    sb.Append("\"" + f.Key.NombreCompania + "\"");
                sb.Append("\t");
                if (f.Key.RifCompania != null)
                    sb.Append("\"" + f.Key.RifCompania + "\"");
                sb.Append("\t");
                if (f.Key.NitCompania != null)
                    sb.Append("\"" + f.Key.NitCompania + "\"");
                sb.Append("\t");
                if (f.Key.CompaniaDomicilio != null)
                    sb.Append("\"" + f.Key.CompaniaDomicilio + "\"");
                sb.Append("\t");
                if (f.Key.CompaniaCiudad != null)
                    sb.Append("\"" + f.Key.CompaniaCiudad + "\"");
                sb.Append("\t");

                // -------------------------------------------------------------------------------
                // datos de la cia contab ... 

                if (f.Key.CiaContabNombre != null)
                    sb.Append("\"" + f.Key.CiaContabNombre + "\"");
                sb.Append("\t");
                if (f.Key.CiaContabRif != null)
                    sb.Append("\"" + f.Key.CiaContabRif + "\"");
                sb.Append("\t");
                if (f.Key.CiaContabDireccion != null)
                    sb.Append("\"" + f.Key.CiaContabDireccion + "\"");
                sb.Append("\t");
                if (f.Key.CiaContabCiudad != null)
                    sb.Append("\"" + f.Key.CiaContabCiudad + "\"");
                sb.Append("\t");

                // período de retención ... 

                sb.Append("\"" + string.Format("{0} al {1}", periodoRetencionDesde.ToString("dd-MMM-yyyy"), periodoRetencionHasta.ToString("dd-MMM-yyyy"))
                        + "\"");
                sb.Append("\t");

                // ----------------------------------------------------------------------------
                // cantidades y montos totales para cada proveedor ... 

                int cantidadPaginas = 0;

                decimal p = f.Total_CantidadDocumentos / 12M;
                if (p == Math.Truncate(p))
                    cantidadPaginas = Convert.ToInt32(p);
                else
                    cantidadPaginas = Convert.ToInt32(Math.Truncate(p) + 1);

                sb.Append("\"" + f.Total_CantidadDocumentos.ToString() + "\"" + "\t");
                sb.Append("\"" + cantidadPaginas.ToString() + "\"" + "\t");
                sb.Append("\"" + (f.Total_MontoFactura == null ? "0" : f.Total_MontoFactura.Value.ToString("N2")) + "\"" + "\t");
                sb.Append("\"" + (f.Total_MontoNoImponible == null ? "0" : f.Total_MontoNoImponible.Value.ToString("N2")) + "\"" + "\t");
                sb.Append("\"" + (f.Total_Iva == null ? "0" : f.Total_Iva.Value.ToString("N2")) + "\"" + "\t");
                sb.Append("\"" + f.Total_TotalFactura.ToString("N2") + "\"" + "\t");
                sb.Append("\"" + (f.Total_MontoSujetoARetencion == null ? "0" : f.Total_MontoSujetoARetencion.Value.ToString("N2")) + "\"" + "\t");
                sb.Append("\"" + (f.Total_RetencionISLRAntesSustraendo == null ? "0" : f.Total_RetencionISLRAntesSustraendo.Value.ToString("N2")) + "\"" + "\t");
                sb.Append("\"" + (f.Total_ImpuestoISLRSustraendo == null ? "0" : f.Total_ImpuestoISLRSustraendo.Value.ToString("N2")) + "\"" + "\t");
                sb.Append("\"" + (f.Total_ImpuestoISLRRetenido == null ? "0" : f.Total_ImpuestoISLRRetenido.Value.ToString("N2")) + "\"" + "\t");

                // -----------------------------------------------------------------------------------------------------------------------
                // ahora siguen los datos básicos para *cada* factura ... nótese que para cada página, registramos hasta 10 facturas ... 

                int cantidadFacturasPorProveedor = 0;

                foreach (var factura in f.Value.OrderBy(x => x.FechaRecepcion).ThenBy(x => x.NumeroFactura))
                {
                    if (cantidadFacturasPorProveedor == 12)
                    {
                        // cada página del documento acepta hasta 12 facturas; básicamente, si un proveedor tiene más de 12 facturas, 
                        // comenzamos otro documento con el mismo proveedor y continuamos ... 

                        // completamos y escribimos la línea al archivo 
                        sw.Write(sb.ToString());
                        sw.Write(sw.NewLine);

                        // comenzamos una nueva linea ... 
                        numeroPagina++;

                        sb = new StringBuilder();

                        sb.Append("\"" + string.Format("{0} de {1} de {2}", fechaConsulta.Day.ToString(), fechaConsulta.ToString("MMMM"), fechaConsulta.ToString("yyyy"))
                                + "\"");
                        sb.Append("\t");

                        sb.Append("\"" + "Página " + numeroPagina.ToString() + "\"");
                        sb.Append("\t");

                        // -------------------------------------------------------------------------------
                        // datos del proveedor ... 
                        if (f.Key.NombreCompania != null)
                            sb.Append("\"" + f.Key.NombreCompania + "\"");
                        sb.Append("\t");
                        if (f.Key.RifCompania != null)
                            sb.Append("\"" + f.Key.RifCompania + "\"");
                        sb.Append("\t");
                        if (f.Key.NitCompania != null)
                            sb.Append("\"" + f.Key.NitCompania + "\"");
                        sb.Append("\t");
                        if (f.Key.CompaniaDomicilio != null)
                            sb.Append("\"" + f.Key.CompaniaDomicilio + "\"");
                        sb.Append("\t");
                        if (f.Key.CompaniaCiudad != null)
                            sb.Append("\"" + f.Key.CompaniaCiudad + "\"");
                        sb.Append("\t");

                        // -------------------------------------------------------------------------------
                        // datos de la cia contab ... 
                        if (f.Key.CiaContabNombre != null)
                            sb.Append("\"" + f.Key.CiaContabNombre + "\"");
                        sb.Append("\t");
                        if (f.Key.CiaContabRif != null)
                            sb.Append("\"" + f.Key.CiaContabRif + "\"");
                        sb.Append("\t");
                        if (f.Key.CiaContabDireccion != null)
                            sb.Append("\"" + f.Key.CiaContabDireccion + "\"");
                        sb.Append("\t");
                        if (f.Key.CiaContabCiudad != null)
                            sb.Append("\"" + f.Key.CiaContabCiudad + "\"");
                        sb.Append("\t");

                        // período de retención ... 

                        sb.Append("\"" + string.Format("{0} al {1}", periodoRetencionDesde.ToString("dd-MMM-yyyy"), periodoRetencionHasta.ToString("dd-MMM-yyyy"))
                                + "\"");
                        sb.Append("\t");

                        // ----------------------------------------------------------------------------
                        // cantidades y montos totales para cada proveedor ... 
                        sb.Append("\"" + f.Total_CantidadDocumentos.ToString() + "\"" + "\t");
                        sb.Append("\"" + cantidadPaginas.ToString() + "\"" + "\t");
                        sb.Append("\"" + (f.Total_MontoFactura == null ? "0" : f.Total_MontoFactura.Value.ToString("N2")) + "\"" + "\t");
                        sb.Append("\"" + (f.Total_MontoNoImponible == null ? "0" : f.Total_MontoNoImponible.Value.ToString("N2")) + "\"" + "\t");
                        sb.Append("\"" + (f.Total_Iva == null ? "0" : f.Total_Iva.Value.ToString("N2")) + "\"" + "\t");
                        sb.Append("\"" + f.Total_TotalFactura.ToString("N2") + "\"" + "\t");
                        sb.Append("\"" + (f.Total_MontoSujetoARetencion == null ? "0" : f.Total_MontoSujetoARetencion.Value.ToString("N2")) + "\"" + "\t");
                        sb.Append("\"" + (f.Total_RetencionISLRAntesSustraendo == null ? "0" : f.Total_RetencionISLRAntesSustraendo.Value.ToString("N2")) + "\"" + "\t");
                        sb.Append("\"" + (f.Total_ImpuestoISLRSustraendo == null ? "0" : f.Total_ImpuestoISLRSustraendo.Value.ToString("N2")) + "\"" + "\t");
                        sb.Append("\"" + (f.Total_ImpuestoISLRRetenido == null ? "0" : f.Total_ImpuestoISLRRetenido.Value.ToString("N2")) + "\"" + "\t");

                        cantidadFacturasPorProveedor = 0;
                    }

                    cantidadFacturasPorProveedor++;

                    if (factura.FechaEmision != null)
                        sb.Append("\"" + factura.FechaEmision.ToString("dd-MM-yy") + "\"");
                    sb.Append("\t");
                    if (factura.FechaRecepcion != null)
                        sb.Append("\"" + factura.FechaRecepcion.ToString("dd-MM-yy") + "\"");
                    sb.Append("\t");

                    if (factura.FechaPago != null)
                        sb.Append("\"" + factura.FechaPago.Value.ToString("dd-MM-yy") + "\"");
                    sb.Append("\t");

                    if (factura.NumeroFactura != null)
                        sb.Append("\"" + factura.NumeroFactura + "\"");
                    sb.Append("\t");

                    // -------------------------------------------------------------------------------
                    // por último, siguen los montos de la factura y del islr retenido  
                    decimal montoFactura = factura.MontoFacturaSinIva.Value + factura.MontoFacturaConIva.Value;

                    sb.Append("\"" + montoFactura.ToString("N2") + "\"");
                    sb.Append("\t");
                    if (factura.MontoFacturaSinIva != null)
                        sb.Append("\"" + factura.MontoFacturaSinIva.Value.ToString("N2") + "\"");
                    sb.Append("\t");
                    if (factura.MontoFacturaConIva != null)
                        sb.Append("\"" + factura.MontoFacturaConIva.Value.ToString("N2") + "\"");
                    sb.Append("\t");
                    if (factura.IvaPorc != null)
                        sb.Append("\"" + factura.IvaPorc.Value.ToString("N2") + "\"");
                    sb.Append("\t");
                    if (factura.Iva != null)
                        sb.Append("\"" + factura.Iva.Value.ToString("N2") + "\"");
                    sb.Append("\t");
                    sb.Append("\"" + factura.TotalFactura.ToString("N2") + "\"");
                    sb.Append("\t");

                    if (factura.MontoSujetoARetencion != null)
                        sb.Append("\"" + factura.MontoSujetoARetencion.Value.ToString("N2") + "\"");
                    sb.Append("\t");
                    if (factura.ImpuestoRetenidoPorc != null)
                        sb.Append("\"" + factura.ImpuestoRetenidoPorc.Value.ToString("N2") + "\"");
                    sb.Append("\t");
                    if (factura.ImpuestoRetenidoISLRAntesSustraendo != null)
                        sb.Append("\"" + factura.ImpuestoRetenidoISLRAntesSustraendo.Value.ToString("N2") + "\"");
                    sb.Append("\t");
                    if (factura.ImpuestoRetenidoISLRSustraendo != null)
                        sb.Append("\"" + factura.ImpuestoRetenidoISLRSustraendo.Value.ToString("N2") + "\"");
                    sb.Append("\t");
                    if (factura.ImpuestoRetenido != null)
                        sb.Append("\"" + factura.ImpuestoRetenido.Value.ToString("N2") + "\"");

                    // nota importante: la última factura (#12) no debe ser 'cerrada' con un tab, pues la última linea nunca cierra con un tab ... 
                    if (cantidadFacturasPorProveedor < 12)
                        sb.Append("\t");

                    cantidadRegistrosLeidos++;
                }

                // si el proveedor no llegó a las 12 facturas por página, debemos agregar los tabs que falten ... 
                for (int j = cantidadFacturasPorProveedor + 1; j <= 12; j++)
                {
                    sb.Append("\t");        // f emisión
                    sb.Append("\t");        // f recepción 
                    sb.Append("\t");        // f pago 
                    sb.Append("\t");        // número de factura
                    sb.Append("\t");        // monto 
                    sb.Append("\t");        // monto no imp
                    sb.Append("\t");        // monto imp
                    sb.Append("\t");        // iva porc
                    sb.Append("\t");        // iva
                    sb.Append("\t");        // total 
                    sb.Append("\t");        // monto sujeto a ret
                    sb.Append("\t");        // islr porc
                    sb.Append("\t");        // impuesto retenido antes sust 
                    sb.Append("\t");        // sustraendo 

                    // nota importante: la última factura (#10) no debe ser 'cerrada' con un tab, pues la linea nunca cierra con un tab ... 
                    if (j < 12)
                        sb.Append("\t");    // impuesto retenido (despúes sustraendo)     
                }

                // completamos y escribimos la línea al archivo 
                sw.Write(sb.ToString());
                sw.Write(sw.NewLine);
            }




            // finally close the file 
            sw.Close();

            if (cantidadRegistrosLeidos == 0)
            {
                ErrMessage_Span.InnerHtml = "No existe información para construir el archivo que Ud. ha requerido. " +
                    "<br /><br /> Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
                ErrMessage_Span.Style["display"] = "block";

                bancosContext = null;
                return;
            }



            bancosContext = null;

            GeneralMessage_Span.InnerHtml = "Ok, el archivo requerido ha sido generado en forma satisfactoria. <br />" +
                "La cantidad de lineas que se han grabado al archivo es: " + cantidadRegistrosLeidos.ToString() + ".<br /><br />" +
                "Haga un click al <em>link</em> que existe en la parte izquierda de esta página para obtener (<em>download</em>) el documento."; 
            GeneralMessage_Span.Style["display"] = "block";

            Session["FileToDownload"] = filePath; 

            //DownloadFile_LinkButton.Visible = true;
            //FileName_HiddenField.Value = filePath;
        }


        protected void DownloadFile_LinkButton_Click(object sender, EventArgs e)
        {
            // hacemos un download del archivo recién generado para que pueda ser copiado al disco duro 
            // local por del usuario 

            //if (FileName_HiddenField.Value == null || FileName_HiddenField.Value == "")
            //{
            //    ErrMessage_Span.InnerHtml = "No se ha podido obtener el nombre del archivo generado. <br /><br />" + 
            //        "Genere el archivo nuevamente y luego intente copiarlo a su disco usando esta función.";
            //    ErrMessage_Span.Style["display"] = "block";

            //    return;
            //}


            //FileStream liveStream = new FileStream(FileName_HiddenField.Value, FileMode.Open, FileAccess.Read);

            //byte[] buffer = new byte[(int)liveStream.Length];
            //liveStream.Read(buffer, 0, (int)liveStream.Length);
            //liveStream.Close();

            //Response.Clear();
            //Response.ContentType = "application/octet-stream";
            //Response.AddHeader("Content-Length", buffer.Length.ToString());
            //Response.AddHeader("Content-Disposition", "attachment; filename=" +
            //                   FileName_HiddenField.Value);
            //Response.BinaryWrite(buffer);
            //Response.End();
        }

        protected void OpcionesMailMerge_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList combo = (DropDownList)sender;
            int selectedValue = Convert.ToInt32(combo.SelectedValue);
            GenerarMailMergeFile_Button.Visible = false; 

            switch (selectedValue)
            {
                case 0:
                    {
                        this.DatosCartasRetencionISLR_FieldSet.Visible = false;
                        this.CartasGenericas_Fieldset.Visible = false;
                        GenerarMailMergeFile_Button.Visible = false;

                        break;
                    }
                case 1:
                    {
                        this.DatosCartasRetencionISLR_FieldSet.Visible = false;
                        this.CartasGenericas_Fieldset.Visible = false;
                        GenerarMailMergeFile_Button.Visible = true; 

                        break;
                    }
                case 2:
                    {
                        this.DatosCartasRetencionISLR_FieldSet.Visible = true;
                        this.CartasGenericas_Fieldset.Visible = false;
                        GenerarMailMergeFile_Button.Visible = true; 

                        break;
                    }
                case 3:
                    {
                        // eliminamos los archivos que pudieron haber sido agregados, cuando este proceso fue ejecutado antes ... 
                        // (si el proceso anterior falló, por alguna razón, estos archivos temporales pudieron haber quedado) 

                        string path = Server.MapPath("~/Temp/Facturas_CartasGenericas/");
                        string path_archivosObtenidos = Server.MapPath("~/Temp/Facturas_CartasGenericas/Temp");
                        string userName = Membership.GetUser().UserName;

                        try
                        {
                            // intentamos eliminar los archivos que corresponden al usuario, en el directorio 'temp'; en este directorio solo 
                            // existen los documentos que el usuario ha obtenido en base a las plantillas que existen ... 
                            System.IO.Directory.CreateDirectory(path);                        // plantillas: creamos el directorio si no existe ... 
                            System.IO.Directory.CreateDirectory(path_archivosObtenidos);      // documentos obtenidos: creamos el directorio si no existe ... 

                            string[] filePaths = Directory.GetFiles(path_archivosObtenidos, "*_" + userName + ".docx");
                            foreach (string filePath in filePaths)
                            {
                                File.Delete(filePath);
                            }    
                        }
                        catch (Exception ex)
                        {
                            string errorMessage = "Error: al intentar crear o acceder al directorio '" + path + "', " + 
                                " o al directorio '" + path_archivosObtenidos + "'; <br />" + 
                                "el mensaje específico del error es:<br />" + ex.Message;
                                if (ex.InnerException != null)
                                {
                                    errorMessage += "<br />" + ex.InnerException.Message;
                                }
                                    

                            ErrMessage_Span.InnerHtml = errorMessage;
                            ErrMessage_Span.Style["display"] = "block";

                            return;
                        }

                        this.DatosCartasRetencionISLR_FieldSet.Visible = false;
                        this.CartasGenericas_Fieldset.Visible = true;

                        // mostramos las posibles plantillas en los combos que existen para ello 
                        RefrescarContenidoCombosCartasGenericas();
                        GenerarMailMergeFile_Button.Visible = false; 

                        // el usuario puede hacer un click en Download, para revisar el contenido de la plantilla que se muestra 
                        // en el combo. Si no hacemos lo que sigue, el usuario debería seleccionar cualquier plantilla y luego 
                        // la 1ra. en el combo, para poder hacer su download 

                        Session["FileToDownload"] = null;

                        if (this.DownLoadPlantillas_DropDownList.Items.Count > 0)
                        {
                            Session["FileToDownload"] = path + this.DownLoadPlantillas_DropDownList.Items[0].Value;
                        }

                        break;
                    }
            }
        }

        protected void Submit1_ServerClick(object sender, EventArgs e)
        {
            if ((file1.PostedFile != null) && (file1.PostedFile.ContentLength > 0))
            {
                string fn = System.IO.Path.GetFileName(file1.PostedFile.FileName);

                if (fn == "CartaModelo.docx")
                {
                    this.ErrMessage_Span.InnerHtml = "Error: Ud. no puede guardar un archivo con ese nombre.<br />" +
                                                     "El nombre del archivo indicado corresponde a la plantilla 'genérica' para este proceso.<br />" + 
                                                     "Por favor intente guardar el documento bajo otro nombre, antes de guardarlo con esta función.";
                    this.ErrMessage_Span.Style["display"] = "block";

                    return; 
                }

                if (System.IO.Path.GetExtension(file1.PostedFile.FileName) != ".docx")
                {
                    this.ErrMessage_Span.InnerHtml = "Error: aparentemente, el documento indicado no es un documento Word (2007 o posterior).<br />" +
                                                     "El documento que Ud. intente guardar mediente esta función, debe ser un documento Word (2007 o posterior).";
                    this.ErrMessage_Span.Style["display"] = "block";

                    return; 
                }

                string SaveLocation = Server.MapPath("~/Temp/Facturas_CartasGenericas/") + "\\" + fn;
                try
                {
                    file1.PostedFile.SaveAs(SaveLocation);

                    this.GeneralMessage_Span.InnerHtml = "Ok, el archivo indicado (" + fn + ") ha sido guardado en un directorio de " + 
                        "esta aplicación en el servidor.<br />" +
                        "De ahora en adelante, Ud. puede seleccionar este archivo para obtener las cartas de facturas.";
                    this.GeneralMessage_Span.Style["display"] = "block";

                    // refrescamos el contenido de los combos que muestran las plantillas, para que muestren la plantilla 
                    // que se ha agregado (upload) 
                    RefrescarContenidoCombosCartasGenericas(); 
                }
                catch (Exception ex)
                {
                    string errorMessage = ex.Message;
                    if (ex.InnerException != null)
                        errorMessage += "<br /" + ex.InnerException.Message;

                    this.ErrMessage_Span.InnerHtml = "Error: se ha producido un error al intentar guardar el archivo indicado.<br />" +
                                                     "El mensaje específico del error obtenido es: " + errorMessage;
                    this.ErrMessage_Span.Style["display"] = "block";
                }
            }
            else
            {
                this.ErrMessage_Span.InnerHtml = "Ud. debe seleccionar un archivo. El archivo que Ud. desea guardar debe ser seleccionado.";
                this.ErrMessage_Span.Style["display"] = "block";
            }
        }

        protected void ConstruirCartasGenericas_Button_Click(object sender, EventArgs e)
        {
            // -------------------------------------------------------------------------------------------
            // para guardar el contenido de los controles de la página para recuperar el state cuando 
            // se abra la proxima vez 

            if (this.SeleccionarPlantillaWord_DropDownList.SelectedIndex == -1) 
            {
                ErrMessage_Span.InnerHtml = "Error: Ud. debe seleccionar el documento Word que servirá como plantilla para este proceso.<br />"; 
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            string fileName = this.SeleccionarPlantillaWord_DropDownList.SelectedValue;

            if (string.IsNullOrEmpty(fileName))
            {
                ErrMessage_Span.InnerHtml = "Error: Ud. debe seleccionar el documento Word que servirá como plantilla para este proceso.<br />";
                ErrMessage_Span.Style["display"] = "block";

                return;
            }


            string resultMessage = "";
            string path = Server.MapPath("~/Temp/Facturas_CartasGenericas/");
            string path_archivosObtenidos = Server.MapPath("~/Temp/Facturas_CartasGenericas/Temp/");

            if (!this.ConstruirDocumentosWord(path, path_archivosObtenidos, fileName, out resultMessage))
            {
                ErrMessage_Span.InnerHtml = "Error: hemos obtenido un error al intentar crear el documento (Word).<br />" +
                    "El mensaje específico del error obtenido es: <br />" + resultMessage;
                ErrMessage_Span.Style["display"] = "block";

                return;
            }
            else
            {
                GeneralMessage_Span.InnerHtml = resultMessage; 
                GeneralMessage_Span.Style["display"] = "block";
            }

            KeepPageState MyKeepPageState = new KeepPageState(Membership.GetUser().UserName, this.GetType().Name.ToString());
            MyKeepPageState.SavePageStateInFile(this.Controls);
            MyKeepPageState = null;
            // ---------------------------------------------------------------------------------------------
        }

        private void RefrescarContenidoCombosCartasGenericas()
        {
            // esta función lee los documentos Word que se han cargado al servidor como plantillas, 
            // y los carga como items en los combos que permiten seleccionar estos archivos: 1) para 
            // hacer un download de una plantilla; 2) para seleccionarlo como plantilla y obtener las 
            // cartas en base a ese archivo 

            string path = Server.MapPath("~/Temp/Facturas_CartasGenericas/");
            string[] filePaths = Directory.GetFiles(@path, "*.docx");

            this.SeleccionarPlantillaWord_DropDownList.Items.Clear(); 
            this.DownLoadPlantillas_DropDownList.Items.Clear(); 

            foreach (string filePath in filePaths)
                // no permitimos que el usuario seleccione la plantilla 'modelo' para generar las cartas 
                if (System.IO.Path.GetFileName(filePath) != "CartaModelo.docx")
                    this.SeleccionarPlantillaWord_DropDownList.Items.Add(new ListItem(System.IO.Path.GetFileName(filePath)));

            foreach (string filePath in filePaths)
                // el usuario puede seleccionar la plantilla 'modelo' para hacer un download y revisarla o modificarla ... 
                this.DownLoadPlantillas_DropDownList.Items.Add(new ListItem(System.IO.Path.GetFileName(filePath)));

            this.SeleccionarPlantillaWord_DropDownList.DataBind();
            this.DownLoadPlantillas_DropDownList.DataBind();
        }

        private bool ConstruirDocumentosWord(string path, string path_archivosObtenidos, string documentoWord, out string resultMessage)
        {
            // construimos los documentos Word, usando Power Tools (for OpenXml) 

            resultMessage = ""; 

            // verificamos que el directorio exista (si no, lo agregamos) 
            string userName = Membership.GetUser().UserName;

            // si la plantilla word no existe, lo notificamos al usuario 
            if (!File.Exists(path + documentoWord))
            {
                resultMessage = "Error: no hemos encontrado el documento Word (plantilla) necesario para ejecutar esta función.<br /> " +
                        "Ud. debe copiar la plantilla que corresponde al archivo 'CartaModelo.docx' " +
                        "en un documento nuevo y crear su plantilla a partir de allí; luego, cargarla a este proceso para poder usarla."; 

                return false;
            }

            // eliminamos los archivos que pudieron haber sido agregados por el usuario, cuando este proceso fue ejecutado antes ... 
            // nótese que estos documentos existen en un sub directorio 'temp'... 
            string[] filePaths = Directory.GetFiles(@path_archivosObtenidos, "*_" + userName + ".docx");
            foreach (string filePath in filePaths)
                File.Delete(filePath);

            BancosEntities bancosContext = new BancosEntities(); 

            // leemos las facturas y construimos un filtro para accederlas fácilmente usando un query ... 
            var query = from f in bancosContext.tTempWebReport_ConsultaFacturas
                        where f.NombreUsuario == User.Identity.Name
                        orderby f.NombreCompania, f.NumeroFactura 
                        select f.ClaveUnicaFactura; 

            string filtro = "";

            foreach (int claveUnicaFactura in query)
                if (filtro == "")
                    filtro = "it.ClaveUnica In {" + claveUnicaFactura.ToString();
                else
                    filtro += ", " + claveUnicaFactura.ToString();

            if (filtro != "")
                filtro += "}";
            else
                filtro = "it.ClaveUnica == -999";

            var facturasQuery = bancosContext.Facturas.Include("Compania").Where(filtro).OrderBy(f => f.Compania.Nombre).ThenBy(f => f.NumeroFactura); 

            int cantidadFacturasLeidas = 0;
            WordprocessingDocument doc = null;

            foreach (var factura in facturasQuery)
            {
                // para cada factura, copiamos la plantilla en un nuevo file, en el temp directory; además, para el usuario específico. 
                // creamos un documento Word para cada factura en el filtro y combinamos los cambios; luego, en un paso posterior, se unen todos estos 
                // documentos en uno solo ... 
                string newFile = @path_archivosObtenidos + System.IO.Path.GetFileNameWithoutExtension(documentoWord) + "_" + factura.ClaveUnica.ToString() + "_" + userName + ".docx";
                File.Copy(path + documentoWord, newFile);

                doc = WordprocessingDocument.Open(newFile, true);

                TextReplacer.SearchAndReplace(doc, "<fecha>", this.CiudadFecha_CartasGenericas_TextBox.Text, false);
                TextReplacer.SearchAndReplace(doc, "<rifCompañía>", factura.Proveedore.Rif, false);
                TextReplacer.SearchAndReplace(doc, "<nombreCompañía>", factura.Proveedore.Nombre, false);
                TextReplacer.SearchAndReplace(doc, "<ciudadCompañía>", factura.Proveedore.Ciudad != null ? factura.Proveedore.tCiudade.Descripcion : "", false);
                TextReplacer.SearchAndReplace(doc, "<direcciónCompañía>", factura.Proveedore.Direccion, false);
                TextReplacer.SearchAndReplace(doc, "<contactoCompañía>", factura.Proveedore.Contacto1, false);

                Persona persona = factura.Proveedore.Personas.Where(p => p.DefaultFlag != null && p.DefaultFlag.Value).FirstOrDefault();

                TextReplacer.SearchAndReplace(doc, "<título>", persona != null ? persona.Titulo : "", false);
                TextReplacer.SearchAndReplace(doc, "<nombrePersona>", persona != null ? (persona.Nombre + " " + persona.Apellido) : "", false);
                
                Compania ciaContab = factura.Compania;

                TextReplacer.SearchAndReplace(doc, "<rifCiaContab>", ciaContab.Rif, false);
                TextReplacer.SearchAndReplace(doc, "<nombreCiaContab>", ciaContab.Nombre, false);
                TextReplacer.SearchAndReplace(doc, "<ciudadCiaContab>", ciaContab.Ciudad, false);
                TextReplacer.SearchAndReplace(doc, "<EstadoCiaContab>", ciaContab.EntidadFederal, false);
                TextReplacer.SearchAndReplace(doc, "<direcciónCiaContab>", ciaContab.Direccion, false);
                TextReplacer.SearchAndReplace(doc, "<teléfonoCiaContab>", ciaContab.Telefono1, false);

                TextReplacer.SearchAndReplace(doc, "<fechaEmisión>", factura.FechaEmision.ToString("dd-MMM-yyyy"), false);
                TextReplacer.SearchAndReplace(doc, "<fechaRecepción>", factura.FechaRecepcion.ToString("dd-MMM-yyyy"), false);
                TextReplacer.SearchAndReplace(doc, "<númeroFactura>", factura.NumeroFactura.ToString(), false);
                TextReplacer.SearchAndReplace(doc, "<concepto>", factura.Concepto, false);
                TextReplacer.SearchAndReplace(doc, "<montoNoImponible>", factura.MontoFacturaSinIva != null ? factura.MontoFacturaSinIva.Value.ToString("N2") : "0,00", false);
                TextReplacer.SearchAndReplace(doc, "<montoImponible>", factura.MontoFacturaConIva != null ? factura.MontoFacturaConIva.Value.ToString("N2") : "0,00", false);
                TextReplacer.SearchAndReplace(doc, "<iva>", factura.Iva != null ? factura.Iva.Value.ToString("N2") : "0,00", false);
                TextReplacer.SearchAndReplace(doc, "<totalFactura>", factura.TotalFactura.ToString("N2"), false);

                TextReplacer.SearchAndReplace(doc, "<firmaCarta1>", !string.IsNullOrEmpty(FirmaCarta_Linea1_CartasGenericas_TextBox.Text.Trim()) ? this.FirmaCarta_Linea1_CartasGenericas_TextBox.Text : " ", false);
                TextReplacer.SearchAndReplace(doc, "<firmaCarta2>", !string.IsNullOrEmpty(FirmaCarta_Linea2_CartasGenericas_TextBox.Text.Trim()) ? this.FirmaCarta_Linea2_CartasGenericas_TextBox.Text : " ", false);
                TextReplacer.SearchAndReplace(doc, "<firmaCarta3>", !string.IsNullOrEmpty(FirmaCarta_Linea3_CartasGenericas_TextBox.Text.Trim()) ? this.FirmaCarta_Linea3_CartasGenericas_TextBox.Text : " ", false);

                doc.Close();
                cantidadFacturasLeidas++; 
            }

            if (cantidadFacturasLeidas == 0)
            {
                resultMessage = "No existe información para construir el documento que Ud. ha requerido. " +
                    "<br /><br /> Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";

                return false;
            }

            bancosContext = null;
            doc.Dispose(); 

            string newFileName = "";

            try
            {
                // combinamos todos los documentos individuales en uno solo
                List<OpenXmlPowerTools.Source> sources = new List<OpenXmlPowerTools.Source>();

                filePaths = Directory.GetFiles(@path_archivosObtenidos, System.IO.Path.GetFileNameWithoutExtension(documentoWord) + "*_" + userName + ".docx");

                foreach (string filePath in filePaths)
                    sources.Add(new OpenXmlPowerTools.Source(new WmlDocument(filePath), true));

                newFileName = path_archivosObtenidos + System.IO.Path.GetFileNameWithoutExtension(documentoWord) + "_" + userName + ".docx";

                // intentamos eliminar antes el archivo ... 
                if (File.Exists(newFileName))
                    File.Delete(newFileName);

                DocumentBuilder.BuildDocument(sources, newFileName);

                // finalmente, eliminamos todos los archivos temporales que fueron agregados (uno por cada factura en el filtro) 
                // TODO: cómo eliminar solo los archivos temporales y no el resultado (ie: acuse recibo geh_manuel.docx ??? 
                filePaths = Directory.GetFiles(@path_archivosObtenidos, "*_" + userName + ".docx");
                foreach (string filePath in filePaths)
                {
                    string temporalFile_name = System.IO.Path.GetFileNameWithoutExtension(filePath);
                    string newFile_name = System.IO.Path.GetFileNameWithoutExtension(newFileName);

                    if (temporalFile_name.ToLower() != newFile_name.ToLower())            // el archivo resultado debe permanecer ... 
                        File.Delete(filePath);
                }
            }
            catch (Exception ex)
            {
                resultMessage = "Error: hemos obtenido un error al intentar consolidar los documentos (Word) individuales (por factura) en uno solo.<br />" + 
                    "El mensaje específico del error es: " + ex.Message;
                if (ex.InnerException != null)
                    resultMessage += "<br />" + ex.InnerException.Message;

                return false;
            }

            Session["FileToDownload"] = newFileName; 

            resultMessage = "Ok, el documento requerido ha sido generado en forma satisfactoria.<br />" +
                "En total se han leído <b>" + cantidadFacturasLeidas.ToString() + "</b> facturas, y construido una carta para cada una de ellas.<br /><br />" +
                "Haga un click al <em>link</em> que existe en la parte izquierda de esta página para obtener (<em>download</em>) el documento."; 

            return true; 
        }

        private bool DownLoadFile(string fileName, out string errorMessage)
        {
            errorMessage = ""; 

            if (!File.Exists(fileName))
            {
                errorMessage = "Error: no hemos podido encontrar el documento requerido ('" + fileName + "') en un directorio en el servidor.<br />" +
                    "Aparentemente, no existe (en el servidor) el documento que se ha requerido .<br />" +
                    "Por favor agregue este documento y luego regrese a ejecutar este proceso.";

                return false;
            }

            FileStream liveStream = new FileStream(fileName, FileMode.Open, FileAccess.Read);

            byte[] buffer = new byte[(int)liveStream.Length];
            liveStream.Read(buffer, 0, (int)liveStream.Length);
            liveStream.Close();

            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Length", buffer.Length.ToString());
            Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
            Response.BinaryWrite(buffer);
            Response.End();

            return true; 
        }

        protected void DownLoadFile_ImageButton_Click(object sender, ImageClickEventArgs e)
        {
            string errorMessage = ""; 

            if (Session["FileToDownload"] == null) 
            {
                errorMessage = "Error: aparentemente, Ud. no ha ejecutado el proceso que construye el documento o archivo.<br />" + 
                    "Ud. debe ejecutar un proceso que construya un documento o archivo y luego obtener (download) el mismo usando este mecanismo.";

                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            string file = Session["FileToDownload"].ToString();

            if (!DownLoadFile(file, out errorMessage))
            {
                errorMessage = "Error: hemos obtenido un error al intentar permitir que Ud. haga " + 
                    "un 'download' del documento final de este proceso.<br />" +
                    "El mensaje específico del error es: " + errorMessage;

                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                return;
            }
        }

        protected void DownLoadFile2_LinkButton_Click(object sender, EventArgs e)
        {
            string errorMessage = "";

            if (Session["FileToDownload"] == null)
            {
                errorMessage = "Error: aparentemente, Ud. no ha ejecutado el proceso que construye el documento o archivo.<br />" +
                    "Ud. debe ejecutar un proceso que construya un documento o archivo y luego obtener (download) el mismo usando este mecanismo.";

                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            string file = Session["FileToDownload"].ToString();

            if (!DownLoadFile(file, out errorMessage))
            {
                errorMessage = "Error: hemos obtenido un error al intentar permitir que Ud. haga un 'download' del documento final de este proceso.<br />" +
                               "El mensaje específico del error es: " + errorMessage;

                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                return;
            }
        }

        protected void DownLoadPlantillas_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.DownLoadPlantillas_DropDownList.SelectedValue))
            {
                string path = Server.MapPath("~/Temp/Facturas_CartasGenericas/");
                Session["FileToDownload"] = path + this.DownLoadPlantillas_DropDownList.SelectedValue;
            }
        }
    }
}