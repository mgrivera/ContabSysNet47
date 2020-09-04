using System;
using System.Web;
using System.Web.UI;
using System.Web.Security;
using System.Xml.Linq;
using System.IO;
//using ContabSysNetWeb.Old_App_Code;
using System.Linq;
//using ContabSysNet_Web.old_app_code;
//using ContabSysNet_Web.ModelosDatos_EF;
using System.Collections.Generic;
using System.Web.UI.HtmlControls;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using System.Text;
using System.Globalization;
using ContabSysNet_Web.ModelosDatos_EF.Nomina;
using ContabSysNet_Web.ModelosDatos_EF.Contab;

public partial class Bancos_Consultas_facturas_Facturas_Facturas_ObtencionXMLFileISLRRetenido : System.Web.UI.Page
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

        ErrMessage_RelacionPagosBanco_Span.InnerHtml = "";
        ErrMessage_RelacionPagosBanco_Span.Style["display"] = "none";

        // -----------------------------------------------------------------------------------------

        if (!Page.IsPostBack)
        {
            HtmlGenericControl MyHtmlH2;

            GeneralMessage_RelacionPagosBanco_Span.InnerHtml = "";
            GeneralMessage_RelacionPagosBanco_Span.Style["display"] = "none";

            MyHtmlH2 = (HtmlGenericControl)Master.FindControl("PageTitle_TableCell");
            if (!(MyHtmlH2 == null))
            {
                MyHtmlH2.InnerHtml = "";
            }

            Master.Page.Title = "Generación del archivo xml para el pago del impuesto islr retenido";


            // leemos la cia contab seleccionada; nótese que solo es importante cuando la opción seleccionada por 
            // el usuario es la 'obtención de relación de pagos para el banco" ... 

            int ciaContabSeleccionada = 0;
            string nombreCiaContabSeleccionada = ""; 
            string errorMessage = "";

            if (!CiaContabSeleccionada(out ciaContabSeleccionada, out nombreCiaContabSeleccionada, out errorMessage))
            {
                // nótese que el mensaje de error que sigue solo se muestra si el usuario selecciona, en el dropdownlist, 
                // opción "relación de pagos para el banco" ... 

                ErrMessage_RelacionPagosBanco_Span.InnerHtml = errorMessage;
                ErrMessage_RelacionPagosBanco_Span.Style["display"] = "block";
            }
            else
            {
                GeneralMessage_RelacionPagosBanco_Span.InnerHtml = nombreCiaContabSeleccionada;
                GeneralMessage_RelacionPagosBanco_Span.Style["display"] = "block";
            }


            CiasContab_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = User.Identity.Name;
            CuentasBancarias_SqlDataSource.SelectParameters["Cia"].DefaultValue = ciaContabSeleccionada.ToString();

            this.OpcionesRetencionesIva_Fieldset.Visible = false;
            this.OpcionesRetencionesIslr_Fieldset.Visible = false;
            this.RelacionMontosAPagar_Fieldset.Visible = false; 
        }


        DownloadFile_LinkButton.Visible = false;
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        switch (this.DropDownList1.SelectedIndex)
        {
            case 0:                     // Seleccione una opción ....  
                this.OpcionesRetencionesIva_Fieldset.Visible = false;
                this.OpcionesRetencionesIslr_Fieldset.Visible = false;
                this.RelacionMontosAPagar_Fieldset.Visible = false;

                break;
            case 1:                     // general 
                this.OpcionesRetencionesIslr_Fieldset.Visible = false;
                this.OpcionesRetencionesIva_Fieldset.Visible = true;
                this.RelacionMontosAPagar_Fieldset.Visible = false;

                break;
            case 2:                     // retenciones Iva 
                this.OpcionesRetencionesIslr_Fieldset.Visible = true;
                this.OpcionesRetencionesIva_Fieldset.Visible = false;
                this.RelacionMontosAPagar_Fieldset.Visible = false;

                break;
            case 3:                     // relación de montos a pagar  
                this.OpcionesRetencionesIslr_Fieldset.Visible = false;
                this.OpcionesRetencionesIva_Fieldset.Visible = false;
                this.RelacionMontosAPagar_Fieldset.Visible = true;

                break;
        }
    }

    protected void GenerarXMLFile_Button_Click(object sender, EventArgs e)
    {
        if (PeriodoSeleccion_TextBox.Text == "")
        {
            ErrMessage_Span.InnerHtml = "Ud. debe indicar un período de selección válido. <br /><br />" + 
                "El período de selección que Ud. indique debe tener la forma 'aaaamm'; por ejemplo: 200901.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        if (PeriodoSeleccion_TextBox.Text.ToString().Length != 6)
        {
            ErrMessage_Span.InnerHtml = "Ud. debe indicar un período de selección válido. <br /><br />" + 
                "El período de selección que Ud. indique debe tener la forma 'aaaamm'; por ejemplo: 200901.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        int nPeriodoSeleccion = 0;

        if (!int.TryParse(PeriodoSeleccion_TextBox.Text, out nPeriodoSeleccion))
        {
            ErrMessage_Span.InnerHtml = "Ud. debe indicar un período de selección válido. <br /><br />" + 
                "El período de selección que Ud. indique debe tener la forma 'aaaamm'; por ejemplo: 200901.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        // si el combo no tiene registro seleccionado es porque no hay registros en la tabla
        if (CiaContab_DropDownList.SelectedIndex == -1)
        {
            ErrMessage_Span.InnerHtml = "No existe información para construir el archivo que Ud. ha requerido. <br /><br />" + 
                "Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        BancosEntities dbBancos = new BancosEntities();

        int ciaContab = Convert.ToInt32(CiaContab_DropDownList.SelectedValue); 

        var Facturas = (from f in dbBancos.tTempWebReport_ConsultaFacturas
                        join c in dbBancos.Companias
                        on f.CiaContab equals c.Numero
                        where f.NombreUsuario == User.Identity.Name &&
                        f.CiaContab == ciaContab
                        select new
                        {
                            RifAgente = c.Rif,
                            NombreCiaContab = c.NombreCorto,
                            c.Abreviatura
                        }).ToList();

        if (Facturas.Count == 0)
        {
            ErrMessage_Span.InnerHtml = "No existe información para construir el archivo que Ud. ha requerido. <br /><br /> " + 
                "Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
            ErrMessage_Span.Style["display"] = "block";

            dbBancos = null;
            return;
        }

        string sNombreCiaContab = Facturas[0].Abreviatura;
        string sRifCiaContab = Facturas[0].RifAgente.ToString().Replace("-", "");

        int cantidadFacturas = 0;
        int cantidadRetenciones = 0; 

        Facturas = null;

        // nótese como seleccionamos solo los registros que corresponden a la cia contab seleccinada; 
        // además, solo los que corresponden al usuario 
        XDocument xmldoc = new XDocument(
                        new XElement("RelacionRetencionesISLR",
                        new XAttribute("RifAgente", sRifCiaContab),
                        new XAttribute("Periodo", nPeriodoSeleccion.ToString())));

        xmldoc.Declaration = new XDeclaration("1.0", "ISO-8859-1", "true");



        var facturasQuery = from f in dbBancos.tTempWebReport_ConsultaFacturas
                            where f.NombreUsuario == User.Identity.Name &&
                                  f.CiaContab == ciaContab
                            select f;

        foreach (var f in facturasQuery)
        {
            // nótese lo que hacemos aquí: si el Iva comienza con J (persona jurídica) grabamos el 
            // monto sujeto a retención al archivo; si el rif comienza con otra letra (persona NO juridica) 
            // grabamos el monto total de la factura (ie: imponible más no imponible)  

            // dejamos de aplicar el criterio que sigue pues ahora los empleados vienen siempre desde la 
            // nómina con el sueldo que registre el usuario como monto sujeto a retención para el xml file 

            if (f.RifCompania == null)
            {
                ErrMessage_Span.InnerHtml = "Aparentemente, la compañía " + f.NombreCompania + 
                    " no tiene un número de rif definido en la Maestra de Proveedores. <br /><br />" + 
                    "Por favor revise esta situación; asigne un número de Rif a esta compañía y regrese a ejecutar nuevamente este proceso.";
                ErrMessage_Span.Style["display"] = "block";

                dbBancos = null;
                return;
            }

            // ----------------------------------------------------------------------------------------------------------------------------------------------
            // ahora los impuestos y las retenciones se registran en forma separada en la tabla Facturas_Impuestos; el objetivo principal de este cambio fue, 
            // simplemente, poder registrar *más de una* retención de impuestos para una factura. Aunque no es un caso frecuente, existen proveedores que 
            // hacen facturas en las cuales especifican dos retenciones (islr) diferentes ... ellos ya las indican, para que el cliente sepa que debe hacerlo 
            // así ... por esa razón, ahora buscamos, para cada factura, la retención islr en la tabla Facturas_Impuestos; como dijimos antes, aunque no es 
            // frecuente, puede haber más de una retención islr para una misma factura ... 

            Factura factura = dbBancos.Facturas.Include("Facturas_Impuestos").
                                                Include("Facturas_Impuestos.ImpuestosRetencionesDefinicion").
                                                Where(x => x.ClaveUnica == f.ClaveUnicaFactura).
                                                FirstOrDefault();

            if (factura == null)
                continue;

            foreach (Facturas_Impuestos retencion in factura.Facturas_Impuestos.Where(r => r.ImpuestosRetencionesDefinicion.Predefinido == 3))
            {
                // la factura debe tener un código de retención en el registro de ImpuestosRetenciones ... 
                string codigoConceptoRetencion_islr = retencion.Codigo;

                if (string.IsNullOrEmpty(codigoConceptoRetencion_islr))
                {
                    ErrMessage_Span.InnerHtml = "Aparentemente, la compañía " + f.NombreCompania + " no tiene un 'código de concepto de retención de Islr' " +
                        "en una (o varias) de sus facturas asociadas (ej: " + factura.NumeroFactura + "). " +
                        "<br /><br /> Por favor revise esta situación; asigne un " +
                        "'código de concepto de retención de Islr' a cada una de las facturas asociadas a esta compañía; " + 
                        "luego regrese y ejecute nuevamente este proceso.";
                    ErrMessage_Span.Style["display"] = "block";

                    dbBancos = null;
                    return;
                }

                // ------------------------------------------------------------------------------------------
                // número control - intentamos quitar caracteres especiales y dejar solo números ... 

                string sNumeroControlDefinitivo = factura.NumeroControl;

                if (string.IsNullOrEmpty(sNumeroControlDefinitivo))
                    sNumeroControlDefinitivo = "0";

                Int64 numeroControl = 0;

                if (this.retencionISLR_NumeroControl_ConvertirNumeros_CheckBox.Checked)
                {
                    if (!Int64.TryParse(sNumeroControlDefinitivo, out numeroControl))
                        // excelente como quitamos letras y caracteres especiales del string (tomado de algún lado en la Web) ... 
                        sNumeroControlDefinitivo = new String(sNumeroControlDefinitivo.Where(c => char.IsDigit(c)).ToArray());
                    else
                        sNumeroControlDefinitivo = factura.NumeroControl;
                };
                // ------------------------------------------------------------------------------------------

                decimal montoOperacion = retencion.MontoBase != null ? retencion.MontoBase.Value : 0;
                decimal porcentaje = retencion.Porcentaje != null ? retencion.Porcentaje.Value : 0;

                montoOperacion = decimal.Round(montoOperacion, 2, MidpointRounding.AwayFromZero);
                porcentaje = decimal.Round(porcentaje, 2, MidpointRounding.AwayFromZero);

                XElement x = new XElement("DetalleRetencion",
                                   new XElement("RifRetenido", f.RifCompania.ToString().Replace("-", "")),
                                   new XElement("NumeroFactura", factura.NumeroFactura),
                                   new XElement("NumeroControl", sNumeroControlDefinitivo),
                                   new XElement("FechaOperacion", factura.FechaRecepcion.ToString("dd/MM/yyyy").Replace("-", "/")),
                                   new XElement("CodigoConcepto", codigoConceptoRetencion_islr),
                                   new XElement("MontoOperacion", montoOperacion.ToString()), 
                                   new XElement("PorcentajeRetencion", porcentaje.ToString())
                                );

                xmldoc.Element("RelacionRetencionesISLR").Add(x);

                cantidadRetenciones++; 
            }

            cantidadFacturas++; 
        }

        String fileName = @"ISLR_retenido_" + sNombreCiaContab + ".xml";
        String filePath = HttpContext.Current.Server.MapPath("~/Temp/" + fileName);

        // --------------------------------------------------------------------------------------------------
        // si el usuario así lo indica, leemos retenciones desde la nómina de pago 
        if (!LeerNomina_CheckBox.Checked)
        {
            // Saving to a file, you can also save to streams
            xmldoc.Save(filePath);

            GeneralMessage_Span.InnerHtml = "<br />" + 
                "Ok, el archivo xml ha sido generado en forma satisfactoria. <br />" +
                "Se han leído " + cantidadFacturas.ToString() + " facturas, en base al criterio de selección que Ud. indicó. <br />" +
                "Se han agregado " + cantidadRetenciones.ToString() + " retenciones (registros) al archivo de retenciones. <br />" +
                "El nombre del archivo es: " + filePath + ".<br /><br />";

            GeneralMessage_Span.Style["display"] = "block";

            DownloadFile_LinkButton.Visible = true;
            FileName_HiddenField.Value = filePath;

            return;
        }

        // -----------------------------------------------------------------------------------------------
        // lo primero que hacemos es intentar generar fechas de inicio y fin usando el período indicado 
        int ano = Convert.ToInt32(PeriodoSeleccion_TextBox.Text.ToString().Substring(0, 4));
        int mes = Convert.ToInt32(PeriodoSeleccion_TextBox.Text.ToString().Substring(4, 2));

        if (ano <= 1990 || ano >= 2050)
        {
            ErrMessage_Span.InnerHtml = "El período indicado no está correctamente formado. <br /><br />" + 
                "Recuerde que el período debe formarse de la siguiente manera: aaaamm; ejemplo: 201006.";
            ErrMessage_Span.Style["display"] = "block";

            dbBancos = null;
            return;
        }

        if (mes <= 0 || mes >= 13)
        {
            ErrMessage_Span.InnerHtml = "El período indicado no está correctamente formado. <br /><br />" + 
                "Recuerde que el período debe formarse de la siguiente manera: aaaamm; ejemplo: 201006.";
            ErrMessage_Span.Style["display"] = "block";

            dbBancos = null;
            return;
        }

        // intentamos leer el código de retención para empleados de nómina 

        // declaramos el EF context ... 
        NominaEntities nominaCtx = new NominaEntities();

        ContabSysNet_Web.ModelosDatos_EF.Nomina.ParametrosNomina parametrosNomina = (from c in nominaCtx.ParametrosNominas
                                                                                     where c.Cia == ciaContab
                                                                                     select c).FirstOrDefault();

        if (parametrosNomina == null || string.IsNullOrEmpty(parametrosNomina.CodigoConceptoRetencionISLREmpleados))
        {
            ErrMessage_Span.InnerHtml = "Aparentemente, no se ha definido un código de retención ISLR para empleados en la tabla Parámetros Nómina. <br /><br /> " + 
                "Por favor abra la tabla mencionada y registre el código usado como concepto de retención para retención ISLR de empleados.";
            ErrMessage_Span.Style["display"] = "block";

            dbBancos = null;
            return;
        }

        // rubro que corresponde al ISLR 
        var rubroIslr = nominaCtx.tMaestraRubros.Select(r => new { r.Rubro, r.TipoRubro }).Where(r => r.TipoRubro == 8).FirstOrDefault();         

        if (rubroIslr == null)
        {
            ErrMessage_Span.InnerHtml = "No se ha definido el rubro ISLR en la maestra de rubros " + 
                "(Catálogos --> Maestra de Rubros). <br /><br />" + 
                "Ud. debe definir el rubro ISLR en la Maestra de Rubros.";
            ErrMessage_Span.Style["display"] = "block";

            nominaCtx = null;
            return;
        }

        // leemos la nómina de pago del mes y seleccionamos los rubros que corresponden a la retención de ISLR 
        // recuérdese que arriba validamos que existan rubros marcados como ISLR en la maestra; sin embargo, 
        // puede no haber de éstos en la nómina de pago ... 

        // además, leemos solo los empleados cuya propiedad EscribirArchivoXMLRetencionesISLR es true ... 
        var queryNominaPago = from n in nominaCtx.tNominas
                              where 
                              n.tNominaHeader.FechaNomina.Month == mes &&
                              n.tNominaHeader.FechaNomina.Year == ano &&
                              (n.tEmpleado.EscribirArchivoXMLRetencionesISLR != null &&
                              n.tEmpleado.EscribirArchivoXMLRetencionesISLR == true) &&
                              n.tNominaHeader.tGruposEmpleado.Cia == ciaContab &&
                              n.Rubro == rubroIslr.Rubro                                              // maestraRubro.Rubro
                              group n by n.Empleado into g
                              select new
                              {
                                  empleado = g.Key,
                                  fechaNomina = g.Max(m => m.tNominaHeader.FechaNomina), 
                                  montoISLR = g.Sum(m => m.Monto),
                                  montoBase = g.Sum(m => m.MontoBase)
                              };


        int empleadosAgregadosISLRFile = 0;


        RegistroRetencionISLR registroRetencionISLR;
        List<RegistroRetencionISLR> registroRetencionISLR_List = new List<RegistroRetencionISLR>();

        foreach (var n in queryNominaPago)
        {
            // leemos empleado 

            ContabSysNet_Web.ModelosDatos_EF.Nomina.tEmpleado empleado = (from emp in nominaCtx.tEmpleados
                                                                          where emp.Empleado == n.empleado
                                                                          select emp).FirstOrDefault();

            if (String.IsNullOrEmpty(empleado.Rif))
            {
                ErrMessage_Span.InnerHtml = "Aunque se ha retenido ISLR al empleado " + empleado.Nombre + 
                    " en la nómina de pago, no se ha registrado su número de rif en la Maestra de Empleados. <br /><br />" + 
                    "Por favor abra la tabla mencionada y registre un número de rif para cada empleado que tenga retención de ISLR en la nómina de pago.";
                ErrMessage_Span.Style["display"] = "block";

                dbBancos = null;
                return;
            }

            decimal islrPorc = 0;
            decimal montoBase = 0;
            decimal montoISLR = n.montoISLR;

            if (n.montoBase != null)
                montoBase = n.montoBase.Value;

            if (montoBase < 0)
                // cómo la retención de islr en la nómina es una deducción, este monto viene negativo ... 
                montoBase *= -1;

            if (montoISLR < 0)
                montoISLR *= -1;

            if (montoBase != 0)
                islrPorc = montoISLR * 100 / montoBase;

            registroRetencionISLR = new RegistroRetencionISLR();

            registroRetencionISLR.RifRetenido = empleado.Rif;
            registroRetencionISLR.NumeroFactura = "0";
            registroRetencionISLR.NumeroControl = "NA";
            registroRetencionISLR.FechaOperacion = n.fechaNomina; 
            registroRetencionISLR.CodigoConcepto = parametrosNomina.CodigoConceptoRetencionISLREmpleados;

            // nos aseguramos que el monto tenga siempre 2 decimales
            decimal montoOperacion = decimal.Round(montoBase, 2, MidpointRounding.AwayFromZero);
            decimal porcentaje = decimal.Round(islrPorc, 2, MidpointRounding.AwayFromZero);

            // al convertir el monto a string siempre queda así: 1500.35 
            registroRetencionISLR.MontoOperacion = montoOperacion.ToString();
            registroRetencionISLR.PorcentajeRetencion = porcentaje.ToString();

            registroRetencionISLR_List.Add(registroRetencionISLR);

            empleadosAgregadosISLRFile++;
        }


        // finalmente, agregamos cada item en la lista como un nodo al xml file 
        foreach (RegistroRetencionISLR r in registroRetencionISLR_List)
        {
            XElement x = new XElement("DetalleRetencion",
                               new XElement("RifRetenido", r.RifRetenido.ToString().Replace("-", "")),
                               new XElement("NumeroFactura", r.NumeroFactura),
                               new XElement("NumeroControl", r.NumeroControl),
                               new XElement("FechaOperacion", r.FechaOperacion.ToString("dd/MM/yyyy")),
                               new XElement("CodigoConcepto", r.CodigoConcepto),
                               new XElement("MontoOperacion", r.MontoOperacion),
                               new XElement("PorcentajeRetencion", r.PorcentajeRetencion)
                            );

            xmldoc.Element("RelacionRetencionesISLR").Add(x);
        }

        // Saving to a file, you can also save to streams
        xmldoc.Save(filePath);

        GeneralMessage_Span.InnerHtml = "<br />" + 
            "Ok, el archivo xml ha sido generado en forma satisfactoria. <br />" +
            "Se han leído " + cantidadFacturas.ToString() + " facturas, en base al criterio de selección que Ud. indicó. <br />" +
            "Se han agregado " + cantidadRetenciones.ToString() + " retenciones (registros) al archivo de retenciones. <br />" +
            "El nombre del archivo es: " + filePath + "<br /><br />" +
            "Además, se han agregado " + empleadosAgregadosISLRFile.ToString() + " retenciones (registros) desde la nómina de pago del mes.";
        GeneralMessage_Span.Style["display"] = "block";

        DownloadFile_LinkButton.Visible = true;
        FileName_HiddenField.Value = filePath;
    }

    protected void GenerarArchivoRetencionesIva_Button_Click(object sender, EventArgs e)
    {
        // Create the CSV file on the server 
        String fileName = @"ImpuestoIvaRetenido_" + User.Identity.Name + ".txt";
        String filePath = HttpContext.Current.Server.MapPath("~/Temp/" + fileName);

        if (File.Exists(@filePath))
            File.Delete(@filePath);

        StreamWriter sw; 
        
        try
        {
            sw = new StreamWriter(filePath, false);
        }
        catch (Exception ex)
        {
            string errorMessage = ex.Message;
            if (ex.InnerException != null)
                errorMessage += ex.InnerException.Message;

            ErrMessage_Span.InnerHtml = "Error al intentar escribir al archivo.<br /><br />" +
                                        errorMessage;
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        StringBuilder sb;

        int cantidadLineas = 0;

        if (this.ObtencionArchivoRetencionesIva_AgregarEncabezados_CheckBox.Checked)
        {
            // agregamos una linea de encabezado al archivo ... 

            sb = new StringBuilder();

            // nuestro rif 
            sb.Append("Nuestro rif" + "\t");

            // periodo fiscal 
            sb.Append("Período" + "\t");

            // fecha Doc 
            sb.Append("Fecha doc" + "\t");

            // tipo operación (siempre C) 
            sb.Append("Tipo oper" + "\t");

            // tipo doc (siempre 01) 
            sb.Append("Tipo doc" + "\t");

            // su rif 
            sb.Append("Su rif" + "\t");

            // número documento 
            sb.Append("Número doc" + "\t");

            // número control 
            sb.Append("Control" + "\t");

            // total doc 
            sb.Append("Total doc" + "\t");

            // base imponible 
            sb.Append("Monto imp" + "\t");

            // ret iva 
            sb.Append("Ret iva" + "\t");

            // doc afectado 
            sb.Append("Doc afectado" + "\t");

            // comprobante seniat 
            sb.Append("Comp seniat" + "\t");

            // base no imp
            sb.Append("Monto no imp" + "\t");

            // iva porc 
            sb.Append("Iva%" + "\t");

            // número de expediente (siempre 0) 
            sb.Append("#Exp");

            sw.Write(sb.ToString());
            sw.Write(sw.NewLine);

            cantidadLineas++;
        }

        BancosEntities context = new BancosEntities();

        // nótese como leemos las facturas seleccionadas, en la tabla 'temp...', para construir un filtro para Facturas_Impuestos, que regrese 
        // justamente, las facturas que el usuario ha seleccionado 

        string filtroFacturasSeleccionadas = ""; 

        var facturas = from f in context.tTempWebReport_ConsultaFacturas
                       where f.NombreUsuario == User.Identity.Name
                       select f.ClaveUnicaFactura;

        foreach (int facturaID in facturas)
        {
            if (string.IsNullOrEmpty(filtroFacturasSeleccionadas))
                filtroFacturasSeleccionadas = "(it.FacturaID In {" + facturaID.ToString();
            else
                filtroFacturasSeleccionadas += "," + facturaID.ToString();
        }

        if (string.IsNullOrEmpty(filtroFacturasSeleccionadas))
            filtroFacturasSeleccionadas = "(1 == 2)";
        else
            filtroFacturasSeleccionadas += "})";

        var query = context.Facturas_Impuestos.Include("Factura").
                                               Include("Factura.Proveedore").
                                               Include("Factura.Compania").
                                               Where(filtroFacturasSeleccionadas).
                                               Select(i => i);

        query = query.Where(i => i.ImpuestosRetencionesDefinicion.Predefinido == 2).        // solo retenciones Iva 
                      OrderBy(i => i.Factura.NumeroComprobante);        

        int retencionesIvaAgregadas = 0; 

        foreach (Facturas_Impuestos impuesto in query)
        {
            // lamentablemente, debemos leer la definición del impuesto Iva para la retención que acabamos de leer. La razón es que 
            // en el registro de la retención Iva no está el monto imponible que corresponde; cuando es una sola retención, se puede tomar 
            // de la factura; cuando la factura tiene más de una retención, pueden haber montos imponibles diferentes ... 

            Facturas_Impuestos impuestoIva = context.Facturas_Impuestos.Where(i => i.FacturaID == impuesto.FacturaID && i.ID < impuesto.ID).
                Where(i => i.ImpuestosRetencionesDefinicion.Predefinido == 1).
                OrderByDescending(i => i.ID).                   // para leer *justo* la definición de Iva anterior y no otra que está aún antes ... 
                FirstOrDefault(); 

            string numeroDocumento = "";

            if (!string.IsNullOrEmpty(impuesto.Factura.NcNdFlag))
                numeroDocumento = impuesto.Factura.NcNdFlag + "-" + impuesto.Factura.NumeroFactura;
            else
                numeroDocumento = impuesto.Factura.NumeroFactura;

            // ahora escribimos una linea al archivo de texto, separado por tabs 

            sb = new StringBuilder();

            // nuestro rif 
            sb.Append(string.IsNullOrEmpty(impuesto.Factura.Compania.Rif) ? "" : impuesto.Factura.Compania.Rif.ToString().Replace("-", ""));
            sb.Append("\t");

            // nótese que el usuario indica si desea la fecha de emisión o recepción en el archivo ... 
            if (this.UsarFechaEmision_CheckBox.Checked)
            {
                sb.Append(impuesto.Factura.FechaEmision.ToString("yyyy") + impuesto.Factura.FechaEmision.ToString("MM"));
                sb.Append("\t");

                sb.Append(impuesto.Factura.FechaEmision.ToString("yyyy-MM-dd"));
                sb.Append("\t");
            }
            else
            {
                sb.Append(impuesto.Factura.FechaRecepcion.ToString("yyyy") + impuesto.Factura.FechaRecepcion.ToString("MM"));
                sb.Append("\t");

                sb.Append(impuesto.Factura.FechaRecepcion.ToString("yyyy-MM-dd"));
                sb.Append("\t");
            }
            

            // tipo operación (siempre C) 
            sb.Append("C");
            sb.Append("\t");

            // tipo doc (siempre 01; no, 01 para facturas; 03 para NC) 
            if (string.IsNullOrEmpty(impuesto.Factura.NcNdFlag))
                sb.Append("01");
            else if (impuesto.Factura.NcNdFlag == "NC")
                sb.Append("03");
            else
                sb.Append("01");

            sb.Append("\t");

            // su rif 
            sb.Append(string.IsNullOrEmpty(impuesto.Factura.Proveedore.Rif) ? "" : impuesto.Factura.Proveedore.Rif.ToString().Replace("-", ""));
            sb.Append("\t");

            // número documento 
            sb.Append(numeroDocumento);
            sb.Append("\t");


            // -----------------------------------------------------------------------------------------
            // número control 

            string sNumeroControlDefinitivo = impuesto.Factura.NumeroControl;

            if (string.IsNullOrEmpty(sNumeroControlDefinitivo))
                sNumeroControlDefinitivo = "0"; 

            Int64 numeroControl = 0;

            if (this.NumeroControl_ConvertirSoloNumeros_CheckBox.Checked)
            {
                if (!Int64.TryParse(sNumeroControlDefinitivo, out numeroControl))
                    // excelente como quitamos letras y caracteres especiales del string (tomado de algún lado en la Web) ... 
                    sNumeroControlDefinitivo = new String(sNumeroControlDefinitivo.Where(c => char.IsDigit(c)).ToArray());
                else
                    sNumeroControlDefinitivo = impuesto.Factura.NumeroControl;
            };

            // ---------------------------------------------------------------------------------------------------------------------------------------
            // base imponible: nótese como la tomamos del registro de impuesto Iva (leído antes) 
            decimal montoNoImponible = 0; 
            decimal montoImponible = 0;
            decimal ivaPorc = 0;
            decimal montoIva = 0; 
            decimal totalFactura = 0; 
            

            if (impuesto.Factura.MontoFacturaSinIva != null) 
                montoNoImponible = impuesto.Factura.MontoFacturaSinIva.Value; 

            if (impuestoIva != null && impuestoIva.MontoBase != null)
                montoImponible = impuestoIva.MontoBase.Value;

            if (impuestoIva != null && impuestoIva.Porcentaje != null) { 
                ivaPorc = impuestoIva.Porcentaje.Value;
                montoIva = montoImponible * ivaPorc / 100; 
            }

            totalFactura = montoNoImponible + montoImponible + montoIva; 
                


            sb.Append(sNumeroControlDefinitivo);
            sb.Append("\t");

            // total doc 
            sb.Append(totalFactura.ToString("0.00", CultureInfo.InvariantCulture));
            sb.Append("\t");

            // monto imponible 
            sb.Append(montoImponible.ToString("0.00", CultureInfo.InvariantCulture));
            sb.Append("\t");

            // ret iva 
            sb.Append(impuesto.Monto.ToString("0.00", CultureInfo.InvariantCulture));
            sb.Append("\t");

            // doc afectado 
            sb.Append(string.IsNullOrEmpty(impuesto.Factura.NumeroFacturaAfectada) ? "0" : impuesto.Factura.NumeroFacturaAfectada);
            sb.Append("\t");

            // comprobante seniat 
            sb.Append(impuesto.Factura.NumeroComprobante);
            sb.Append("\t");

            // base no imp
            sb.Append(montoNoImponible.ToString("0.00", CultureInfo.InvariantCulture));
            sb.Append("\t");

            // iva porc 
            sb.Append(ivaPorc.ToString("0.00", CultureInfo.InvariantCulture));
            sb.Append("\t");

            // número de expediente (siempre 0) 
            sb.Append("0");

            sw.Write(sb.ToString());
            sw.Write(sw.NewLine);

            cantidadLineas++;
            retencionesIvaAgregadas++; 
        }

        try
        {
            // finally close the file 
            sw.Close();
            sw = null;
        }
        catch (Exception ex)
        {
            string errorMessage = ex.Message;
            if (ex.InnerException != null)
                errorMessage += ex.InnerException.Message;

            ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar grabar el archivo requerido en el servidor. <br /><br />" +
                                        errorMessage;
            ErrMessage_Span.Style["display"] = "block";

            context = null;
            return;
        }

        if (retencionesIvaAgregadas == 0)
        {
            ErrMessage_Span.InnerHtml = "No existe información para construir el archivo que Ud. ha requerido. <br /><br />" +
                                        "Probablemente Ud. no ha aplicado un filtro y seleccionado información aún.";
            ErrMessage_Span.Style["display"] = "block";

            context = null;
            return;
        }


        GeneralMessage_Span.InnerHtml = "Ok, el archivo de texto ha sido generado en forma satisfactoria. <br />" +
        "La cantidad de facturas que se han grabado al archivo es: " + cantidadLineas.ToString() + ". <br />" +
        "El nombre del archivo es: " + filePath + ".<br /><br />";
        GeneralMessage_Span.Style["display"] = "block";

        ObtencionArchivoRetencionesIva_DownloadFile_LinkButton.Visible = true;
        FileName_HiddenField.Value = filePath;

        return;
    }


    protected void DownloadFile_LinkButton_Click(object sender, EventArgs e)
    {
        // hacemos un download del archivo recién generado para que pueda ser copiado al disco duro 
        // local por del usuario 

        if (FileName_HiddenField.Value == null || FileName_HiddenField.Value == "")
        {
            ErrMessage_Span.InnerHtml = "No se ha podido obtener el nombre del archivo generado. <br /><br /> Genere el archivo nuevamente y luego intente copiarlo a su disco usando esta función.";
            ErrMessage_Span.Style["display"] = "block";

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

    
    private bool CiaContabSeleccionada(out int ciaContabSeleccionada, out string nombreCiaContabSeleccionada, out string errorMessage)
    {
        ciaContabSeleccionada = 0;
        nombreCiaContabSeleccionada = ""; 
        errorMessage = ""; 

        if (!User.Identity.IsAuthenticated)
        {
            errorMessage = "Error: la session se ha desconectado; por favor vuelva a hacer un login a esta aplicación."; 
            return false; 
        }

        using (dbContab_Contab_Entities context = new dbContab_Contab_Entities())
        {
            try
            {
                var cia = context.tCiaSeleccionadas.Where(s => s.UsuarioLS == User.Identity.Name).
                                                    Select(c => new { ciaContabSeleccionada = c.Compania.Numero, ciaContabSeleccionadaNombre = c.Compania.Nombre }).
                                                    FirstOrDefault();

                if (cia == null)
                {
                    errorMessage = "Error: aparentemente, no se ha seleccionado una <em>Cia Contab</em>.<br />" +
                                "Por favor seleccione una <em>Cia Contab</em> y luego regrese y continúe con la ejecución de esta función."; 

                    return false; 
                }

                ciaContabSeleccionada = cia.ciaContabSeleccionada;
                nombreCiaContabSeleccionada = cia.ciaContabSeleccionadaNombre; 

                return true; 
            }
            catch (Exception ex)
            {
                string message = ex.Message;
                if (ex.InnerException != null)
                    message += "<br />" + ex.InnerException.Message;

                errorMessage = "Error: se ha producido un error al intentar efectuar una operación en la base de datos.<br />" +
                                "El mensaje específico de error es: <br />" + message; 

                return false; 
            }
        }
    }
    
    
    
    
    // -------------------------------------------------------------------------------------------------
    // para crear una lista con los registros de islr retenido para agregarlos luego al xml file ... 

    public class RegistroRetencionISLR
    {
        public string RifRetenido { get; set; }
        public string NumeroFactura { get; set; }
        public string NumeroControl { get; set; }
        public DateTime FechaOperacion { get; set; }
        public string CodigoConcepto { get; set; }
        public string MontoOperacion { get; set; }
        public string PorcentajeRetencion { get; set; }
    }
}
