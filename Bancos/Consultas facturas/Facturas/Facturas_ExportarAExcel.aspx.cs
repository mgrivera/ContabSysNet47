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
using ClosedXML.Excel; 

namespace ContabSysNet_Web.Bancos.Consultas_facturas.Facturas
{
    public partial class Facturas_ExportarAExcel : System.Web.UI.Page
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

            Master.Page.Title = "Exportar información de facturas a Microsoft Excel";

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

                Session["ExcelDocument_FileName"] = null;
                this.ExportarMicrosoftExcel_DropDownList.SelectedIndex = 0; 
            }
        }

        protected void ExportarInformacionMicrosoftExcel_Button_Click(object sender, EventArgs e)
        {
            int selectedValue = Convert.ToInt32(this.ExportarMicrosoftExcel_DropDownList.SelectedValue.ToString());

            if (selectedValue == 0)
                return;

            switch (selectedValue)
            {
                case 1:             // libro de ventas 
                    {
                        bool result = LibroVentas_ExportarMicrosoftExcel(); 
                        break;
                    }
                case 2:             // libro de compras 
                    {
                        bool result = LibroCompras_ExportarMicrosoftExcel(); 
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

        protected void DownLoadFile_ImageButton_Click(object sender, ImageClickEventArgs e)
        {
            if (Session["ExcelDocument_FileName"] == null || string.IsNullOrEmpty(Session["ExcelDocument_FileName"].ToString()))
            {
                string errorMessage = "Error: no se ha encontrado un documento Excel que descargar. Recuerde que Ud. debe primero crear el documento y luego descargarlo.";
                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            string fileName = Session["ExcelDocument_FileName"].ToString();

            //Response.Clear();
            //Response.ContentType = "application/vnd.ms-excel";
            //Response.AddHeader("content-Disposition", "attachment;filename=" + fileName);
            //Response.Flush();
            //Response.WriteFile(fileName);

            Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
            Response.ContentType = "application/vnd.ms-excel";
            Response.WriteFile(fileName); 
        }

        protected void DownLoadFile2_LinkButton_Click(object sender, EventArgs e)
        {
            if (Session["ExcelDocument_FileName"] == null || string.IsNullOrEmpty(Session["ExcelDocument_FileName"].ToString()))
            {
                string errorMessage = "Error: no se ha encontrado un documento Excel que descargar. Recuerde que Ud. debe primero crear el documento y luego descargarlo.";
                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                return;
            }

            string fileName = Session["ExcelDocument_FileName"].ToString(); 

            //Response.Clear();
            //Response.ContentType = "application/vnd.ms-excel";
            //Response.AddHeader("content-Disposition", "attachment;filename=" + fileName);
            //Response.Flush();
            //Response.WriteFile(fileName);

            Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName); 
            Response.ContentType = "application/vnd.ms-excel";
            Response.WriteFile(fileName); 
        }

        protected void ExportarMicrosoftExcel_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
        {
            DropDownList combo = (DropDownList)sender;
            int selectedValue = Convert.ToInt32(combo.SelectedValue);
            this.OpcionesReporte_Fieldset.Visible = false;

            switch (selectedValue)
            {
                case 0:
                    {
                        this.OpcionesReporte_Fieldset.Visible = false;
                        break;
                    }
                case 1:
                    {
                        this.OpcionesReporte_Fieldset.Visible = true;
                        break;
                    }
                case 2:
                    {
                        this.OpcionesReporte_Fieldset.Visible = true;
                        break;
                    }
            }
        }

        private bool LibroVentas_ExportarMicrosoftExcel()
        {
            if (User.Identity == null || string.IsNullOrEmpty(User.Identity.Name))
            {
                // un timeout podría hacer que el usuario no esté authenticado ... 
                string errorMessage = "Ud. debe hacer un login en la aplicación antes de continuar. Por vaya a Home e intente hacer un login en la aplicación.";
                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                return false;
            }

            BancosEntities context = new BancosEntities();

            var query = context.tTempWebReport_ConsultaFacturas.Where("it.NombreUsuario == '" + User.Identity.Name + "'");

            if (query.Count() == 0)
            {
                string errorMessage = "No existe información para mostrar el reporte " +
                    "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                    "filtro y seleccionado información aún.";

                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                return false;
            }


            // -----------------------------------------------------------------------------------------------------------------
            // preparamos el documento Excel, para tratarlo con ClosedXML ... 
            string fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/LibroVentas.xlsx");

            XLWorkbook wb;
            IXLWorksheet ws;

            try
            {
                wb = new XLWorkbook(fileName);
                ws = wb.Worksheet(1);
            }
            catch (Exception ex)
            {
                string errorMessage = ex.Message;
                if (ex.InnerException != null)
                    errorMessage += "<br />" + ex.InnerException.Message;

                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                return false;
            }

            var excelTable = ws.Table("Ventas");
            // -----------------------------------------------------------------------------------------------------------------

            int cantidadRows = 0;
            decimal ivaPorc = 0;
            decimal montoImponible = 0;
            decimal montoIva = 0;
            DateTime? fechaComprobanteRetencionIva = null;

            foreach (var factura in query)
            {
                cantidadRows++;

                excelTable.DataRange.LastRow().Field(0).SetValue(cantidadRows);
                excelTable.DataRange.LastRow().Field(1).SetValue(factura.FechaEmision);
                excelTable.DataRange.LastRow().Field(2).SetValue(factura.NombreCompania);
                excelTable.DataRange.LastRow().Field(3).SetValue(factura.RifCompania);

                switch (factura.NcNdFlag)
                {
                    case "NC":
                        {
                            excelTable.DataRange.LastRow().Field(6).SetValue(factura.NumeroFactura);
                            excelTable.DataRange.LastRow().Field(7).SetValue(factura.NumeroFacturaAfectada);
                            break;
                        }
                    case "ND":
                        {
                            excelTable.DataRange.LastRow().Field(5).SetValue(factura.NumeroFactura);
                            break;
                        }
                    default:
                        {
                            excelTable.DataRange.LastRow().Field(4).SetValue(factura.NumeroFactura);
                            break;
                        }

                }

                // calculamos el porcentaje de Iva, que no viene en el registro 

                montoImponible = factura.MontoFacturaConIva != null ? factura.MontoFacturaConIva.Value : 0;
                montoIva = factura.Iva != null ? factura.Iva.Value : 0;
                ivaPorc = 0;
                fechaComprobanteRetencionIva = null;

                if (montoImponible != 0)
                    ivaPorc = Math.Round(montoIva * 100 / montoImponible, 2);

                // para determinar la fecha de recepción del comprobante, tenemos que buscar en la tabla FacturasImpuestos; además, en FacturasImpuestos, 
                // el registro cuyo correspondiente en ImpuestosRetencionesDefinicion tenga 1 en la columna Predefinido ... 

                Facturas_Impuestos impuestoIva = context.Facturas_Impuestos.Where(i => i.FacturaID == factura.ClaveUnicaFactura).
                                                                            Where(i => i.ImpuestosRetencionesDefinicion.Predefinido == 1).
                                                                            FirstOrDefault();

                if (impuestoIva != null)
                    fechaComprobanteRetencionIva = impuestoIva.FechaRecepcionPlanilla;

                excelTable.DataRange.LastRow().Field(10).SetValue(factura.TotalFactura);
                excelTable.DataRange.LastRow().Field(11).SetValue(factura.MontoFacturaConIva != null ? factura.MontoFacturaConIva.Value : 0);
                excelTable.DataRange.LastRow().Field(12).SetValue(factura.MontoFacturaSinIva != null ? factura.MontoFacturaSinIva.Value : 0);

                //excelTable.DataRange.LastRow().Field(13).SetValue();              // no sujetas ... 
                excelTable.DataRange.LastRow().Field(14).SetValue(ivaPorc);
                excelTable.DataRange.LastRow().Field(15).SetValue(factura.Iva != null ? factura.Iva.Value : 0);

                excelTable.DataRange.LastRow().Field(19).SetValue(factura.NumeroComprobante);
                excelTable.DataRange.LastRow().Field(20).SetValue(fechaComprobanteRetencionIva);
                excelTable.DataRange.LastRow().Field(21).SetValue(factura.RetencionSobreIva != null ? factura.RetencionSobreIva.Value : 0);

                excelTable.DataRange.InsertRowsBelow(1);
            }

            // en el libro de ventas, asumimos que el usuario seleccionó una sola empresa (cia contab) y usamos el primer registro 
            // de la lista de items seleccionados para obtenerla ... 

            string nombreCiaContab = "";
            string rifCiaContab = "";
            string direccionCiaContab = "";
            string periodoFechaInicial = this.Periodo_FechaInicial_TextBox.Text;
            string periodoFechaFinal = this.Periodo_FechaFinal_TextBox.Text;

            if (query.Count() > 0)
            {
                var factura = query.FirstOrDefault();
                nombreCiaContab = factura.CiaContabNombre;
                rifCiaContab = factura.CiaContabRif;
                direccionCiaContab = factura.CiaContabDireccion;
            }

            ws.Cell("B2").Value = nombreCiaContab;
            ws.Cell("B3").Value = "Rif: " + rifCiaContab;
            ws.Cell("B4").Value = direccionCiaContab;
            ws.Cell("B6").Value = "Período: " + periodoFechaInicial + " al " + periodoFechaFinal;

            string userName = User.Identity.Name.Replace("@", "_").Replace(".", "_");
            fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/LibroVentas_" + userName + ".xlsx");

            if (File.Exists(fileName))
                File.Delete(fileName);

            try
            {
                wb.SaveAs(fileName);

                string errorMessage = "Ok, la función que exporta los datos a Microsoft Excel se ha ejecutado en forma satisfactoria.<br />" +
                    "En total, se han agregado " + cantidadRows.ToString() + " registros a la tabla en el documento Excel.<br />" +
                    "Ud. debe hacer un <em>click</em> en el botón que permite obtener (<em>download</em>) el documento Excel.";

                Session["ExcelDocument_FileName"] = fileName;

                GeneralMessage_Span.InnerHtml = errorMessage;
                GeneralMessage_Span.Style["display"] = "block";
            }
            catch (Exception ex)
            {
                string errorMessage = ex.Message;
                if (ex.InnerException != null)
                    errorMessage += "<br />" + ex.InnerException.Message;

                errorMessage += "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + errorMessage;

                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                return false;
            }

            return true;
        }





        private bool LibroCompras_ExportarMicrosoftExcel()
        {
            if (User.Identity == null || string.IsNullOrEmpty(User.Identity.Name))
            {
                // un timeout podría hacer que el usuario no esté authenticado ... 
                string errorMessage = "Ud. debe hacer un login en la aplicación antes de continuar. Por vaya a Home e intente hacer un login en la aplicación.";
                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                return false;
            }

            BancosEntities context = new BancosEntities();

            var query = context.tTempWebReport_ConsultaFacturas.Where("it.NombreUsuario == '" + User.Identity.Name + "'");

            if (query.Count() == 0)
            {
                string errorMessage = "No existe información para mostrar el reporte " +
                    "que Ud. ha requerido. <br /><br /> Probablemente Ud. no ha aplicado un " +
                    "filtro y seleccionado información aún.";

                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                return false;
            }


            // -----------------------------------------------------------------------------------------------------------------
            // preparamos el documento Excel, para tratarlo con ClosedXML ... 
            string fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/LibroCompras.xlsx");

            XLWorkbook wb;
            IXLWorksheet ws;

            try
            {
                wb = new XLWorkbook(fileName);
                ws = wb.Worksheet(1);
            }
            catch (Exception ex)
            {
                string errorMessage = ex.Message;
                if (ex.InnerException != null)
                    errorMessage += "<br />" + ex.InnerException.Message;

                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                return false;
            }

            var excelTable = ws.Table("Ventas");
            // -----------------------------------------------------------------------------------------------------------------

            int cantidadRows = 0;
            decimal ivaPorc = 0;
            decimal montoNoImponible = 0; 
            decimal montoImponible = 0;
            decimal montoIva = 0;
            DateTime? fechaComprobanteRetencionIva = null;
            decimal montoRetencionImpuestosIva = 0; 

            foreach (var factura in query.OrderBy(f => f.FechaRecepcion).ThenBy(f => f.NumeroFactura))
            {
                cantidadRows++;

                excelTable.DataRange.LastRow().Field(0).SetValue(cantidadRows);
                excelTable.DataRange.LastRow().Field(1).SetValue(factura.FechaRecepcion);
                excelTable.DataRange.LastRow().Field(2).SetValue(factura.NombreCompania);
                excelTable.DataRange.LastRow().Field(3).SetValue(factura.RifCompania);

                if (factura.ImportacionFlag != null && factura.ImportacionFlag.Value)
                {
                    // importaciones 
                    switch (factura.NcNdFlag)
                    {
                        case "NC":
                            {
                                excelTable.DataRange.LastRow().Field(9).SetValue(factura.NumeroFactura);
                                excelTable.DataRange.LastRow().Field(10).SetValue(factura.NumeroFacturaAfectada);
                                break;
                            }
                        case "ND":
                            {
                                excelTable.DataRange.LastRow().Field(8).SetValue(factura.NumeroFactura);
                                break;
                            }
                        default:
                            {
                                excelTable.DataRange.LastRow().Field(4).SetValue(factura.NumeroFactura);
                                break;
                            }
                    }
                }
                else
                {
                    // compra nacional  
                    switch (factura.NcNdFlag)
                    {
                        case "NC":
                            {
                                excelTable.DataRange.LastRow().Field(7).SetValue(factura.NumeroFactura);
                                excelTable.DataRange.LastRow().Field(10).SetValue(factura.NumeroFacturaAfectada);
                                break;
                            }
                        case "ND":
                            {
                                excelTable.DataRange.LastRow().Field(6).SetValue(factura.NumeroFactura);
                                break;
                            }
                        default:
                            {
                                excelTable.DataRange.LastRow().Field(4).SetValue(factura.NumeroFactura);
                                break;
                            }
                    }
                }

                // calculamos el porcentaje de Iva, que no viene en el registro 

                montoNoImponible = factura.MontoFacturaSinIva != null ? factura.MontoFacturaSinIva.Value : 0; 
                montoImponible = factura.MontoFacturaConIva != null ? factura.MontoFacturaConIva.Value : 0;
                montoIva = factura.Iva != null ? factura.Iva.Value : 0;
                ivaPorc = 0;
                fechaComprobanteRetencionIva = null;
                montoRetencionImpuestosIva = factura.RetencionSobreIva != null ? factura.RetencionSobreIva.Value : 0; 

                if (montoImponible != 0)
                    ivaPorc = Math.Round(montoIva * 100 / montoImponible, 2);

                // para determinar la fecha de recepción del comprobante, tenemos que buscar en la tabla FacturasImpuestos; además, en FacturasImpuestos, 
                // el registro cuyo correspondiente en ImpuestosRetencionesDefinicion tenga 1 en la columna Predefinido ... 

                Facturas_Impuestos impuestoIva = context.Facturas_Impuestos.Where(i => i.FacturaID == factura.ClaveUnicaFactura).
                                                                            Where(i => i.ImpuestosRetencionesDefinicion.Predefinido == 1).
                                                                            FirstOrDefault();

                if (impuestoIva != null)
                    fechaComprobanteRetencionIva = impuestoIva.FechaRecepcionPlanilla;

                if (factura.ImportacionFlag != null && factura.ImportacionFlag.Value)
                {
                    excelTable.DataRange.LastRow().Field(11).SetValue(montoImponible + montoIva);     // gravadas 
                    excelTable.DataRange.LastRow().Field(12).SetValue(montoNoImponible);   // exoneradas
                    excelTable.DataRange.LastRow().Field(13).SetValue(montoImponible);    // base imponible  
                    excelTable.DataRange.LastRow().Field(14).SetValue(ivaPorc);
                    excelTable.DataRange.LastRow().Field(15).SetValue(montoIva);
                }
                else
                {
                    excelTable.DataRange.LastRow().Field(16).SetValue(montoImponible + montoIva);     // gravadas 
                    excelTable.DataRange.LastRow().Field(17).SetValue(montoNoImponible);   // exoneradas
                    excelTable.DataRange.LastRow().Field(18).SetValue(montoImponible);    // base imponible  
                    excelTable.DataRange.LastRow().Field(19).SetValue(ivaPorc);
                    excelTable.DataRange.LastRow().Field(20).SetValue(montoIva);
                }


                excelTable.DataRange.LastRow().Field(21).SetValue(factura.NumeroComprobante);
                excelTable.DataRange.LastRow().Field(22).SetValue(fechaComprobanteRetencionIva);
                excelTable.DataRange.LastRow().Field(23).SetValue(montoRetencionImpuestosIva);

                excelTable.DataRange.InsertRowsBelow(1);
            }

            // en el libro de ventas, asumimos que el usuario seleccionó una sola empresa (cia contab) y usamos el primer registro 
            // de la lista de items seleccionados para obtenerla ... 

            string nombreCiaContab = "";
            string rifCiaContab = "";
            string direccionCiaContab = "";
            string periodoFechaInicial = this.Periodo_FechaInicial_TextBox.Text;
            string periodoFechaFinal = this.Periodo_FechaFinal_TextBox.Text;

            if (query.Count() > 0)
            {
                var factura = query.FirstOrDefault();
                nombreCiaContab = factura.CiaContabNombre;
                rifCiaContab = factura.CiaContabRif;
                direccionCiaContab = factura.CiaContabDireccion;
            }

            ws.Cell("B2").Value = nombreCiaContab;
            ws.Cell("B3").Value = "Rif: " + rifCiaContab;
            ws.Cell("B4").Value = direccionCiaContab;
            ws.Cell("B6").Value = "Período: " + periodoFechaInicial + " al " + periodoFechaFinal;

            string userName = User.Identity.Name.Replace("@", "_").Replace(".", "_");
            fileName = System.Web.HttpContext.Current.Server.MapPath("~/Excel/LibroCompras_" + userName + ".xlsx");

            if (File.Exists(fileName))
                File.Delete(fileName);

            try
            {
                wb.SaveAs(fileName);

                string errorMessage = "Ok, la función que exporta los datos a Microsoft Excel se ha ejecutado en forma satisfactoria.<br />" +
                    "En total, se han agregado " + cantidadRows.ToString() + " registros a la tabla en el documento Excel.<br />" +
                    "Ud. debe hacer un <em>click</em> en el botón que permite obtener (<em>download</em>) el documento Excel.";

                Session["ExcelDocument_FileName"] = fileName;

                GeneralMessage_Span.InnerHtml = errorMessage;
                GeneralMessage_Span.Style["display"] = "block";
            }
            catch (Exception ex)
            {
                string errorMessage = ex.Message;
                if (ex.InnerException != null)
                    errorMessage += "<br />" + ex.InnerException.Message;

                errorMessage += "Se producido un error mientras se ejecutaba el proceso. El mensaje específico del error es:<br />" + errorMessage;

                ErrMessage_Span.InnerHtml = errorMessage;
                ErrMessage_Span.Style["display"] = "block";

                return false;
            }

            return true;
        }
    }
}