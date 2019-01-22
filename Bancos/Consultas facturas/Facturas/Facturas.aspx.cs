using System;
using System.Collections;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Collections.Generic;
//using ContabSysNetWeb.Old_App_Code;
using System.Linq;
using ContabSysNet_Web.ModelosDatos;
using ContabSysNet_Web.old_app_code;
using MongoDB.Driver;
using ContabSysNet_Web.Areas.Bancos.Models.mongodb;
using ContabSysNet_Web.ModelosDatos_EF.Bancos;
using ContabSysNet_Web.ModelosDatos_EF.CajaChica; 


public partial class Bancos_Facturas_Facturas : System.Web.UI.Page
{

private class Facturas_Object
    {
    public int Moneda { get; set; }
    public string MonedaSimbolo { get; set; }
    public string MonedaNombre { get; set; }

    public int CiaContab { get; set; }
    public string CiaContabNombre { get; set; }
    public string CiaContabDireccion { get; set; }
    public string CiaContabCiudad { get; set; } 
    public string CiaContabRif { get; set; }
    public string CiaContabTelefono1 { get; set; }
    public string CiaContabTelefono2 { get; set; }
    public string CiaContabFax { get; set; }

    public int Compania { get; set; }

    public string CompaniaDomicilio { get; set; }
    public string CompaniaTelefono { get; set; }
    public string CompaniaFax { get; set; }
    public string CompaniaCiudad { get; set; }
    public short CompaniaNatJurFlag { get; set; }

    public string NombreCompania { get; set; }
    public string AbreviaturaCompania { get; set; }
    public string RifCompania { get; set; }
    public string NitCompania { get; set; }
    public bool? ContribuyenteFlag { get; set; }
    public string NumeroFactura { get; set; }
    public string NumeroControl { get; set; } 
    public int ClaveUnica { get; set; }
    public bool ImportacionFlag { get; set; }
    public string NumeroPlanillaImportacion { get; set; }
    public String NcNdFlag { get; set; } 
    public string NumeroFacturaAfectada { get; set; } 
    public string NumeroComprobante { get; set; } 
    public Nullable<short> NumeroOperacion { get; set; } 
    public int Tipo { get; set; }
    public string NombreTipo { get; set; }
    public int CondicionesDePago { get; set; }

    public string CondicionesDePagoNombre { get; set; } 

    public DateTime FechaEmision { get; set; } 
    public DateTime FechaRecepcion { get; set; }
    public string Concepto { get; set; }

    public string NotasFactura1 { get; set; }
    public string NotasFactura2 { get; set; }
    public string NotasFactura3 { get; set; } 

    public Nullable<decimal> MontoFacturaSinIva { get; set; }
    public Nullable<decimal> MontoFacturaConIva { get; set; }

    public decimal MontoTotalFactura { get; set; }

    public Nullable<char> TipoAlicuota { get; set; } 
    public Nullable<decimal> IvaPorc { get; set; }
    public Nullable<decimal> Iva { get; set; } 
    public decimal TotalFactura { get; set; }
    public string CodigoConceptoRetencion { get; set; } 
    public Nullable<decimal> MontoSujetoARetencion { get; set; }
    public Nullable<decimal> ImpuestoRetenidoPorc { get; set; }

    public Nullable<decimal> ImpuestoRetenidoISLRAntesSustraendo { get; set; }
    public Nullable<decimal> ImpuestoRetenidoISLRSustraendo { get; set; }

    public Nullable<decimal> ImpuestoRetenido { get; set; }
    public Nullable<DateTime> FRecepcionRetencionISLR { get; set; }
    public Nullable<decimal> RetencionSobreIvaPorc { get; set; }
    public Nullable<decimal> RetencionSobreIva { get; set; }
    public Nullable<DateTime> FRecepcionRetencionIVA { get; set; }

    public Nullable<decimal> OtrosImpuestos { get; set; }
    public Nullable<decimal> OtrasRetenciones { get; set; }

    public decimal TotalAPagar { get; set; }
    public Nullable<decimal> Anticipo { get; set; } 
    public decimal Saldo { get; set; }
    public short Estado { get; set; } 
    public string NombreEstado { get; set; }

    // estas dos propiedades (columnas) ya no existen en la tabla en el db ... 

    //public Nullable<Int16> NumeroDeCuotas { get; set; }
    //public Nullable<DateTime> FechaUltimoVencimiento { get; set; } 

    public short CxCCxPFlag { get; set; } 
    public string NombreCxCCxPFlag { get; set; }
    public Nullable<int> Comprobante { get; set; } 
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        this.Page.Header.DataBind();    // NOTE: this resolves any <%# ... %> tags in <head>

        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }
   
        ErrMessage_Span.InnerHtml = "";
        ErrMessage_Span.Style["display"] = "none";

        // -----------------------------------------------------------------------------------------

        Master.Page.Title = "Consulta General de Facturas";

        if (!Page.IsPostBack)
        {
            //Gets a reference to a Label control that is not in a 
            //ContentPlaceHolder control

            HtmlContainerControl MyHtmlSpan;

            MyHtmlSpan = (HtmlContainerControl)(Master.FindControl("AppName_Span"));
            if (MyHtmlSpan != null)
                MyHtmlSpan.InnerHtml = "Bancos";

            HtmlGenericControl MyHtmlH2;

            MyHtmlH2 = (HtmlGenericControl)(Master.FindControl("PageTitle_TableCell"));
            if (MyHtmlH2 != null)
                MyHtmlH2.InnerHtml = "Consulta General de Facturas";

            //--------------------------------------------------------------------------------------------
            //para asignar la página que corresponde al help de la página 
            
            HtmlAnchor MyHtmlHyperLink;
            MyHtmlHyperLink = (HtmlAnchor)Master.FindControl("Help_HyperLink");

            MyHtmlHyperLink.HRef = "javascript:PopupWin('../../../Doc/Bancos/Facturas/Consulta facturas/consulta_general_de_facturas.htm', 1000, 680)"; 

            Session["FiltroForma"] = null;
        }
        else
        {
            //-------------------------------------------------------------------------
            // la página puede ser 'refrescada' por el popup; en ese caso, ejeucutamos  
            // una función que efectúa alguna funcionalidad y rebind la información 

            if (this.RebindFlagHiddenField.Value == "1")
            {
                RebindFlagHiddenField.Value = "0";
                RefreshAndBindInfo(); 
            }
            // -------------------------------------------------------------------------
        }
    }

    private void RefreshAndBindInfo()
    {
        if (!User.Identity.IsAuthenticated)
        {
            FormsAuthentication.SignOut();
            return;
        }

        if (Session["FiltroForma"] == null)
        {
            ErrMessage_Span.InnerHtml = "Aparentemente, Ud. no ha indicado un filtro aún.<br />Por favor indique y aplique un filtro antes " + 
                "de intentar mostrar el resultado de la consulta.";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        this.cantRegistrosSeleccionados_Label.Text = ""; 

        //dbBancosDataContext BancosDB = new dbBancosDataContext();
        BancosEntities BancosDB = new BancosEntities(); 

        // --------------------------------------------------------------------------------------------
        // determinamos el mes y año fiscales, para usarlos como criterio para buscar el saldo en la tabla 
        // SaldosContables. En esta table, los saldos están para el mes fiscal y no para el mes calendario. 
        // Los meses solo varían cuando el año fiscal no es igual al año calendario 

        // --------------------------------------------------------------------------------------------
        // eliminamos el contenido de la tabla temporal 

        try
        {
            BancosDB.ExecuteStoreCommand("Delete From tTempWebReport_ConsultaFacturas Where NombreUsuario = {0}", Membership.GetUser().UserName);
        }
        catch (Exception ex)
        {
            BancosDB.Dispose();

            ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br />" + 
                "El mensaje específico de error es: " + 
                ex.Message + "<br />";
            ErrMessage_Span.Style["display"] = "block";

            return;
        }

        // usamos el criterio que indico el usuario para leer las facturas de proveedores y grabarlas a una tabla 
        // en la base de datos temporal (tTempWebReport_ConsultaFacturas)

        string sSqlQueryString = "SELECT Facturas.Moneda, Monedas.Simbolo As MonedaSimbolo, Monedas.Descripcion As MonedaNombre, " + 
            "Facturas.Cia AS CiaContab, " +
            "Companias.Nombre As CiaContabNombre, " + 
            "Companias.Direccion As CiaContabDireccion, " +
            "Companias.Ciudad As CiaContabCiudad, " + 
            "Companias.Rif As CiaContabRif, " + 
            "Companias.Telefono1 As CiaContabTelefono1, " +
            "Companias.Telefono2 As CiaContabTelefono2, " + 
            "Companias.Fax As CiaContabFax, " +

            "Facturas.Proveedor AS Compania, " +

            "Proveedores.Direccion + ', ' + tCiudades.Descripcion As CompaniaDomicilio, " + 
            "Proveedores.Telefono1 As CompaniaTelefono, " + 
            "Proveedores.Fax As CompaniaFax, " +
            "tCiudades.Descripcion As CompaniaCiudad, Proveedores.NatJurFlag as CompaniaNatJurFlag, " +

            "Proveedores.Nombre As NombreCompania, Proveedores.Abreviatura As AbreviaturaCompania, " +
            "Proveedores.Rif As RifCompania, " +
            "Proveedores.Nit As NitCompania, " +
            "Proveedores.ContribuyenteFlag, " + 
            "NumeroFactura, NumeroControl, ClaveUnica, IsNull(ImportacionFlag, 0) As ImportacionFlag, NumeroPlanillaImportacion, " + 
            "NcNdFlag, NumeroFacturaAfectada, NumeroComprobante, NumeroOperacion, " +  
            "Facturas.Tipo, TiposProveedor.Descripcion As NombreTipo, " + 
            "CondicionesDePago, " +
 
            "FormasDePago.Descripcion As CondicionesDePagoNombre, " + 

            "FechaEmision, FechaRecepcion, Facturas.Concepto, " +

            "ParametrosBancos.FooterFacturaImpresa_L1 As NotasFactura1, " +
            "ParametrosBancos.FooterFacturaImpresa_L2 As NotasFactura2, " +
            "ParametrosBancos.FooterFacturaImpresa_L3 As NotasFactura3, " + 
            
            "MontoFacturaSinIva, MontoFacturaConIva, (IsNull(MontoFacturaSinIva, 0) + IsNull(MontoFacturaConIva, 0)) As MontoTotalFactura, " + 
            "TipoAlicuota, IvaPorc, Iva, TotalFactura, " + 
            "Facturas.CodigoConceptoRetencion, " + 
            "MontoSujetoARetencion, ImpuestoRetenidoPorc, ImpuestoRetenidoISLRAntesSustraendo, ImpuestoRetenidoISLRSustraendo, ImpuestoRetenido, FRecepcionRetencionISLR, " + 
            "Facturas.RetencionSobreIvaPorc, RetencionSobreIva, FRecepcionRetencionIVA, " + 
            "OtrosImpuestos, OtrasRetenciones, TotalAPagar, Anticipo, Saldo, " +   
			"Estado, Case Estado When 1 Then 'Pendiente' When 2 Then 'Parcial' When 3 Then 'Pagada' When 4 Then 'Anulada' Else 'Indefinido' End As NombreEstado, " +

            "CxCCxPFlag, Case CxCCxPFlag When 1 Then 'CxP' When 2 Then 'CxC' Else 'Indf' End As NombreCxCCxPFlag, " +   
			"Comprobante " + 
            "FROM Facturas Inner Join Proveedores On Facturas.Proveedor = Proveedores.Proveedor " + 
            "Inner Join TiposProveedor On Facturas.Tipo = TiposProveedor.Tipo " +
            "Inner Join Companias On Facturas.Cia = Companias.Numero " +
            "Inner Join Monedas On Facturas.Moneda = Monedas.Moneda " + 
            "Inner Join tCiudades On Proveedores.Ciudad = tCiudades.Ciudad " + 
            "Inner Join FormasDePago On Facturas.CondicionesDePago = FormasDePago.FormaDePago " + 
            "Inner Join ParametrosBancos On Facturas.Cia = ParametrosBancos.Cia " + 
            "Where " + Session["FiltroForma"].ToString();

        List<tTempWebReport_ConsultaFacturas> MyFacturas_List = new List<tTempWebReport_ConsultaFacturas>();
        tTempWebReport_ConsultaFacturas MyFactura;

        DateTime fechaMin_sqlServer = new DateTime(1753, 1, 1);
        DateTime fechaMax_sqlServer = new DateTime(9999, 12, 31); 


        try
        {
            var query = BancosDB.ExecuteStoreQuery<Facturas_Object>(sSqlQueryString);

            foreach (Facturas_Object MyFactura_Object in query)
            {
                MyFactura = new tTempWebReport_ConsultaFacturas();

                MyFactura.Moneda = MyFactura_Object.Moneda;
                MyFactura.MonedaSimbolo = MyFactura_Object.MonedaSimbolo;
                MyFactura.MonedaDescripcion = MyFactura_Object.MonedaNombre; 

                MyFactura.CiaContab = MyFactura_Object.CiaContab;

                MyFactura.CiaContabNombre = MyFactura_Object.CiaContabNombre;
                MyFactura.CiaContabDireccion = MyFactura_Object.CiaContabDireccion;
                MyFactura.CiaContabCiudad = MyFactura_Object.CiaContabCiudad; 
                MyFactura.CiaContabRif = MyFactura_Object.CiaContabRif;
                MyFactura.CiaContabTelefono1 = MyFactura_Object.CiaContabTelefono1;
                MyFactura.CiaContabTelefono2 = MyFactura_Object.CiaContabTelefono2;
                MyFactura.CiaContabFax = MyFactura_Object.CiaContabFax;

                MyFactura.Compania = MyFactura_Object.Compania;

                MyFactura.CompaniaDomicilio = MyFactura_Object.CompaniaDomicilio;
                MyFactura.CompaniaTelefono = MyFactura_Object.CompaniaTelefono;
                MyFactura.CompaniaFax = MyFactura_Object.CompaniaFax;
                MyFactura.CompaniaCiudad = MyFactura_Object.CompaniaCiudad;

                MyFactura.NatJurFlag = MyFactura_Object.CompaniaNatJurFlag;

                MyFactura.NatJurFlagDescripcion = "Jurídico";

                if (MyFactura.NatJurFlag == 1)
                    MyFactura.NatJurFlagDescripcion = "Natural";

                MyFactura.NombreCompania = MyFactura_Object.NombreCompania;
                MyFactura.AbreviaturaCompania = MyFactura_Object.AbreviaturaCompania; 

                MyFactura.RifCompania = MyFactura_Object.RifCompania;
                MyFactura.NitCompania = MyFactura_Object.NitCompania;
                MyFactura.ContribuyenteFlag = MyFactura_Object.ContribuyenteFlag; 

                MyFactura.NumeroFactura = MyFactura_Object.NumeroFactura;
                MyFactura.NumeroControl = MyFactura_Object.NumeroControl;
                MyFactura.ClaveUnicaFactura = MyFactura_Object.ClaveUnica;

                MyFactura.ImportacionFlag = MyFactura_Object.ImportacionFlag;
                MyFactura.NumeroPlanillaImportacion = MyFactura_Object.NumeroPlanillaImportacion; 

                MyFactura.Importacion_CompraNacional = "Compras nacionales"; 

                if (MyFactura_Object.ImportacionFlag)
                    MyFactura.Importacion_CompraNacional = "Importaciones"; 


                MyFactura.NcNdFlag = MyFactura_Object.NcNdFlag;

                MyFactura.Compra_NotaCredito = "Compras"; 
                if (MyFactura_Object.TotalFactura < 0)
                    MyFactura.Compra_NotaCredito = "Notas de crédito"; 

                MyFactura.NumeroFacturaAfectada = MyFactura_Object.NumeroFacturaAfectada;
                MyFactura.NumeroComprobante = MyFactura_Object.NumeroComprobante;
                MyFactura.NumeroOperacion = MyFactura_Object.NumeroOperacion;
                MyFactura.Tipo = MyFactura_Object.Tipo;
                MyFactura.NombreTipo = MyFactura_Object.NombreTipo;
                MyFactura.CondicionesDePago = MyFactura_Object.CondicionesDePago;

                MyFactura.CondicionesDePagoNombre = MyFactura_Object.CondicionesDePagoNombre;

                // válidamos que el valor indicado en las fechas se corresponda con el aceptado por sql server ... 
                if (MyFactura_Object.FechaEmision < fechaMin_sqlServer || MyFactura_Object.FechaEmision > fechaMax_sqlServer)
                {
                    ErrMessage_Span.InnerHtml = "Aparentemente, el valor registrado para alguna de las fechas en la factura # '" +
                        MyFactura.NumeroFactura + "', en la Cia Contab " + MyFactura.CiaContabNombre + ", no es correcto. <br />" +
                        "Por favor revise esta factura en la Cia Contab indicada, y corrija alguno de sus datos que pueda no ser correcto. ";
                    ErrMessage_Span.Style["display"] = "block";
                    return;
                }

                if (MyFactura_Object.FechaRecepcion < fechaMin_sqlServer || MyFactura_Object.FechaRecepcion > fechaMax_sqlServer)
                {
                    ErrMessage_Span.InnerHtml = "Aparentemente, el valor registrado para alguna de las fechas en la factura # '" +
                        MyFactura.NumeroFactura + "', en la Cia Contab " + MyFactura.CiaContabNombre + ", no es correcto. <br />" +
                        "Por favor revise esta factura en la Cia Contab indicada, y corrija alguno de sus datos que pueda no ser correcto. ";
                    ErrMessage_Span.Style["display"] = "block";
                    return;
                }

                MyFactura.FechaEmision = MyFactura_Object.FechaEmision;
                MyFactura.FechaRecepcion = MyFactura_Object.FechaRecepcion;

                MyFactura.Concepto = MyFactura_Object.Concepto;

                MyFactura.NotasFactura1 = MyFactura_Object.NotasFactura1;
                MyFactura.NotasFactura2 = MyFactura_Object.NotasFactura2;
                MyFactura.NotasFactura3 = MyFactura_Object.NotasFactura3;

                MyFactura.MontoFacturaSinIva = MyFactura_Object.MontoFacturaSinIva.HasValue ? MyFactura_Object.MontoFacturaSinIva : 0;
                MyFactura.MontoFacturaConIva = MyFactura_Object.MontoFacturaConIva.HasValue ? MyFactura_Object.MontoFacturaConIva : 0;

                MyFactura.MontoTotalFactura = MyFactura_Object.MontoTotalFactura;

                if (MyFactura_Object.MontoFacturaConIva != null && MyFactura_Object.MontoFacturaConIva != 0)
                {
                    // leemos la tabla 'FacturasImpuestos' para obtener montos de impuestos iva y retenciones; ahora ésto se hace 
                    // necesario pues puede haber más de un impuesto iva (varias tasas) y más de una retención (una para cada monto de Iva) 
                    MyFactura.TipoAlicuota = MyFactura_Object.TipoAlicuota.ToString();

                    if (string.IsNullOrEmpty(MyFactura.TipoAlicuota))
                        MyFactura.TipoAlicuota = "G";

                    var queryImpuestosRetenciones = BancosDB.Facturas_Impuestos.Where(i => (i.FacturaID == MyFactura_Object.ClaveUnica) && 
                                                                                           (i.ImpuestosRetencionesDefinicion.Predefinido == 1 || 
                                                                                            i.ImpuestosRetencionesDefinicion.Predefinido == 2)).
                                                                                Select(i => new 
                                                                                    { 
                                                                                        i.TipoAlicuota, 
                                                                                        i.MontoBase, 
                                                                                        i.Porcentaje, 
                                                                                        i.Monto, 
                                                                                        i.ImpuestosRetencionesDefinicion.Predefinido 
                                                                                    });
                    string tipoAlicuota_ImpIvaLeido = ""; 

                    // nótese como el programa, al menos por ahora, maneja solo hasta tres tipos de tasa de impuestos Iva (red/gen/adic) 
                    foreach(var impRet in queryImpuestosRetenciones)
                    {
                        // cada monto de impuesto Iva es seguido de inmediato por su retención Iva (si existe una!); la idea es leer el monto Iva y 
                        // luego, para el prox item, obtener la retención ... 
                        if (impRet.Predefinido == 1)
                        {
                            switch (impRet.TipoAlicuota)
                            {
                                case "R":
                                    MyFactura.IvaPorc_Reducido = impRet.Porcentaje;
                                    MyFactura.BaseImponible_Reducido = impRet.MontoBase;
                                    MyFactura.Iva_Reducido = impRet.Monto;
                                    MyFactura.TipoAlicuota_Reducido = impRet.TipoAlicuota; 
                                    MyFactura.ImpuestoRetenido_Reducido = 0;        // la retención Iva, si existe, es leída con el próximo registro en la tabla

                                    tipoAlicuota_ImpIvaLeido = impRet.TipoAlicuota;

                                    break;
                                case "G":
                                    MyFactura.IvaPorc_General = impRet.Porcentaje;
                                    MyFactura.BaseImponible_General = impRet.MontoBase;
                                    MyFactura.Iva_General = impRet.Monto;
                                    MyFactura.TipoAlicuota_General = impRet.TipoAlicuota; 
                                    MyFactura.ImpuestoRetenido_General = 0;         // la retención Iva, si existe, es leída con el próximo registro en la tabla

                                    tipoAlicuota_ImpIvaLeido = impRet.TipoAlicuota;

                                    break;
                                case "A":
                                    MyFactura.IvaPorc_Adicional = impRet.Porcentaje;
                                    MyFactura.BaseImponible_Adicional = impRet.MontoBase;
                                    MyFactura.Iva_Adicional = impRet.Monto;
                                    MyFactura.TipoAlicuota_Adicional = impRet.TipoAlicuota; 
                                    MyFactura.ImpuestoRetenido_Adicional = 0;       // la retención Iva, si existe, es leída con el próximo registro en la tabla

                                    tipoAlicuota_ImpIvaLeido = impRet.TipoAlicuota;

                                    break;
                            }
                        }
                        else
                        {
                            // Ok, el registro es del tipo RetIva; agregamos el monto retenido en base al tipo de alícuota leído con el registro anterior 
                            switch (tipoAlicuota_ImpIvaLeido)
                            {
                                case "R":
                                    MyFactura.ImpuestoRetenido_Reducido = impRet.Monto; 
                                    tipoAlicuota_ImpIvaLeido = "";
                                    break;
                                case "G":
                                    MyFactura.ImpuestoRetenido_General = impRet.Monto; 
                                    tipoAlicuota_ImpIvaLeido = "";
                                    break;
                                case "A":
                                    MyFactura.ImpuestoRetenido_Adicional = impRet.Monto; 
                                    tipoAlicuota_ImpIvaLeido = "";
                                    break;
                            }
                        } 
                    }
                }

                MyFactura.IvaPorc = MyFactura_Object.IvaPorc;
                MyFactura.Iva = MyFactura_Object.Iva;

                // a veces el %Iva no viene con la factura ... lo calculamos 
                // (siempre viene como un (o varios) registro separado en Facturas_Impuestos; sin embargo, casi siempre se resume en la factura 
                // como un todo ... 
                if (MyFactura.IvaPorc == null && MyFactura.Iva != null && MyFactura.MontoFacturaConIva != null && MyFactura.MontoFacturaConIva != 0)
                {
                    MyFactura.IvaPorc = MyFactura.Iva * 100 / MyFactura.MontoFacturaConIva;
                    MyFactura.IvaPorc = Math.Round(MyFactura.IvaPorc.Value, 2, MidpointRounding.AwayFromZero);
                }

                MyFactura.TotalFactura = MyFactura_Object.TotalFactura;

                // datos que corresonden a la retención del islr ... NOTA: si existe una retención (islr) debemos leerla en Facturas_Impuestos ... 
                if (MyFactura_Object.ImpuestoRetenido != null && MyFactura_Object.ImpuestoRetenido.Value != 0)
                {
                    // leemos el registro que corresponde, en forma específica, a la retención del islr 
                    //var retencion = BancosDB.Facturas_Impuestos.
                    //    Where(i => i.FacturaID == MyFactura_Object.ClaveUnica && i.ImpuestosRetencionesDefinicion.Predefinido == 3).
                    //    FirstOrDefault();

                    MyFactura.CodigoConceptoRetencion = "";
                    MyFactura.MontoSujetoARetencion = 0;
                    MyFactura.ImpuestoRetenidoPorc = 0;
                    MyFactura.ImpuestoRetenidoISLRAntesSustraendo = 0;
                    MyFactura.ImpuestoRetenidoISLRSustraendo = 0;
                    MyFactura.ImpuestoRetenido = 0;
                    MyFactura.FRecepcionRetencionISLR = null; 

                    var retencionIslr_query = BancosDB.Facturas_Impuestos.
                        Where(i => i.FacturaID == MyFactura_Object.ClaveUnica && i.ImpuestosRetencionesDefinicion.Predefinido == 3); 

                    foreach(var retIslr in retencionIslr_query) 
                    {
                        MyFactura.CodigoConceptoRetencion = MyFactura.CodigoConceptoRetencion == "" ? MyFactura.CodigoConceptoRetencion = retIslr.Codigo : MyFactura.CodigoConceptoRetencion += ", " + retIslr.Codigo;
                        MyFactura.MontoSujetoARetencion += retIslr.MontoBase;
                        MyFactura.ImpuestoRetenidoISLRAntesSustraendo += retIslr.MontoAntesSustraendo;
                        MyFactura.ImpuestoRetenidoISLRSustraendo += retIslr.Sustraendo;
                        MyFactura.ImpuestoRetenido += retIslr.Monto;
                        
                        // el porcentaje es calculado, pues pueden existir varias retenciones; cuando efectivamente existan, este porcentaje no será 
                        // exacto, pues deberían, realmente, mostrarse por separado ... 
                        if (MyFactura.MontoSujetoARetencion != 0)
                            MyFactura.ImpuestoRetenidoPorc = retIslr.MontoAntesSustraendo * 100 / MyFactura.MontoSujetoARetencion;
                        else
                            MyFactura.ImpuestoRetenidoPorc = 0;     // creo que ésto no debería ocurrir nunca (???) 

                        // cuando hay más de una retención de islr, mostramos solo la última de las fechas de recepción de la planilla; 
                        // luego revisaremos y corregiremos ésto (???!!!) 
                        MyFactura.FRecepcionRetencionISLR = retIslr.FechaRecepcionPlanilla;
                    }
                }

                MyFactura.RetencionSobreIvaPorc = MyFactura_Object.RetencionSobreIvaPorc;
                MyFactura.RetencionSobreIva = MyFactura_Object.RetencionSobreIva;
                MyFactura.FRecepcionRetencionIVA = MyFactura_Object.FRecepcionRetencionIVA; 

                // calculamos el porcentaje de retención, pues ahora no viene con la factura (pueden haber 
                // más de una retención) 

                MyFactura.RetencionSobreIvaPorc = 0;

                if (MyFactura.RetencionSobreIva != null && MyFactura.Iva != null && MyFactura.Iva.Value != 0)
                    MyFactura.RetencionSobreIvaPorc = (MyFactura.RetencionSobreIva.Value * 100) / MyFactura.Iva.Value; 

                MyFactura.ImpuestosVarios = MyFactura_Object.OtrosImpuestos;
                MyFactura.RetencionesVarias = MyFactura_Object.OtrasRetenciones; 

                MyFactura.TotalAPagar = MyFactura_Object.TotalAPagar;
                MyFactura.Anticipo = MyFactura_Object.Anticipo;
                MyFactura.Saldo = MyFactura_Object.Saldo;
                MyFactura.Estado = MyFactura_Object.Estado;
                MyFactura.NombreEstado = MyFactura_Object.NombreEstado;

                MyFactura.CxCCxPFlag = MyFactura_Object.CxCCxPFlag;
                MyFactura.NombreCxCCxPFlag = MyFactura_Object.NombreCxCCxPFlag;
                MyFactura.Comprobante = MyFactura_Object.Comprobante;

                MyFactura.NombreUsuario = Membership.GetUser().UserName;

                // -----------------------------------------------------------------------------
                // leemos el monto pagado para cada factura; si existe, actualizamos el registro 

                var dFechaPagoFactura = (from Pagos in BancosDB.dPagos
                                         where Pagos.CuotasFactura.ClaveUnicaFactura == MyFactura_Object.ClaveUnica
                                         select (DateTime?)Pagos.Pago.Fecha).Max();

                var nMontoPagado = (from Pagos in BancosDB.dPagos
                                    where Pagos.CuotasFactura.ClaveUnicaFactura == MyFactura_Object.ClaveUnica
                                    select (decimal?)Pagos.MontoPagado).Sum();

                if (dFechaPagoFactura.HasValue)
                    MyFactura.FechaPago = dFechaPagoFactura;

                if (nMontoPagado.HasValue)
                    MyFactura.MontoPagado = nMontoPagado;
                // -----------------------------------------------------------------------------

                MyFacturas_List.Add(MyFactura);

            }

            // agregamos todos los registros leídos y que están ahora en la lista 
            foreach (var f in MyFacturas_List)
            {
                BancosDB.tTempWebReport_ConsultaFacturas.AddObject(f);
            }
        }
        catch (Exception ex) 
        {
            BancosDB.Dispose();

            ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> Es probable que el filtro que Ud. ha indicado no esté bien formado. Por favor revise el filtro indicado a ver si está correctamente construido. <br />El mensaje específico de error es: " + ex.Message + "<br /><br />";
            ErrMessage_Span.Style["display"] = "block";
            return;
        }


        try
        {
            BancosDB.SaveChanges();
        }

        catch (Exception ex)
        {
            BancosDB.Dispose();

            string errorMessage = ex.Message;
            if (ex.InnerException != null)
                errorMessage += "<br />" + ex.InnerException.Message;

            ErrMessage_Span.InnerHtml = "Ha ocurrido un error al intentar ejecutar una operación de acceso a la base de datos. <br /> El mensaje específico de error es: " + errorMessage + "<br /><br />";
            ErrMessage_Span.Style["display"] = "block";
            return;
        }


        // ---------------------------------------------------------------------------------------
        // si el usuario indico que deseaba incluir facturas desde el control de caja chica, 
        // intentamos agregarlas ahora 

        MyFacturas_List.Clear(); 

        if (Session["FiltroForma_LeerFacturasCCCh"].ToString() == "")
            Session["FiltroForma_LeerFacturasCCCh"] = "1 = 2";

        string filtroFacturasCajaChica = Session["FiltroForma_LeerFacturasCCCh"].ToString();
        filtroFacturasCajaChica = filtroFacturasCajaChica.Replace("CajaChica_Reposiciones_Gastos.CiaContab", "CiaContab"); 

         IEnumerable<CajaChica_Reposiciones_Gasto> queryCCCh =
            BancosDB.ExecuteStoreQuery<CajaChica_Reposiciones_Gasto>(
            "Select CajaChica_Reposiciones_Gastos.* " + 
            "From CajaChica_Reposiciones_Gastos " +
            "Inner Join CajaChica_Reposiciones On " +
            "CajaChica_Reposiciones.Reposicion = CajaChica_Reposiciones_Gastos.Reposicion " +
            "Inner Join CajaChica_CajasChicas On " +
            "CajaChica_Reposiciones.CajaChica = CajaChica_CajasChicas.CajaChica " +
            //" And " +
            //"CajaChica_Reposiciones.CajaChica = CajaChica_Reposiciones_Gastos.CajaChica And " +
            //"CajaChica_Reposiciones.CiaContab = CajaChica_Reposiciones_Gastos.CiaContab " + 
            "Where " + filtroFacturasCajaChica
            + " And " + 
            "CajaChica_Reposiciones_Gastos.AfectaLibroCompras = 1 And " + 
            "CajaChica_Reposiciones.EstadoActual <> 'AN'"
            );

        // las reposiciones de caja chica no tienen moneda; asumimos que la 'moneda local' debe 
        // ser usada  

         Moneda monedaLocal = (from m in BancosDB.Monedas
                               where m.NacionalFlag == true
                               select m).FirstOrDefault();

         if (monedaLocal == null)
         {
             BancosDB.Dispose();

             ErrMessage_Span.InnerHtml = "Aparentemente, no se ha definico una moneda 'nacional' en la " + 
                 "tabla <i>Monedas</i>. <br /> Por favor abra la tabla <i>Monedas</i> y defina una moneda " + 
                 "como 'moneda nacional'.<br /><br />";
             ErrMessage_Span.Style["display"] = "block";
             return;
         }

         ControlCajaChicaEntities ControlCajaChicaContext = new ControlCajaChicaEntities(); 

        // para simular una clave unica para cada factura que viene desde el control de caja chica y 
        // que pueda ser encontrada cuando el usuario hace un click en el link 'detalles' 

         int nClaveUnicaFactura = 0; 

         foreach (CajaChica_Reposiciones_Gasto facCCCh in queryCCCh)
         {
             if (facCCCh.Proveedor == null && string.IsNullOrEmpty(facCCCh.Nombre))
             {
                 // el gasto en la reposición de caja chica debe tener un proveedor (ID) o un nombre ... 
                 string errorMessage1 =
                     "Error: hemos encontrado una situación que debe ser corregida, antes de intentar obtener esta consulta " +
                     "en forma adecuada. <br /> " +
                     "El gasto en alguna reposición de caja chica, con estas características: " +
                     "reposición: " + facCCCh.Reposicion.ToString() +
                     ", descripción: " + facCCCh.Descripcion +
                     ", fecha del documento: " + (facCCCh.FechaDocumento.HasValue ? facCCCh.FechaDocumento.Value.ToString("dd-MMM-yyyy") : "Indefinida") +
                     ", monto total: " + facCCCh.Total.ToString("N2") + ", <br /> " +
                     "debe tener un proveedor asignado o un nombre para el mismo; ahora ambos están en blanco.";


                 ErrMessage_Span.InnerHtml = errorMessage1;
                 ErrMessage_Span.Style["display"] = "block";

                 return;
             }
             MyFactura = new tTempWebReport_ConsultaFacturas();

             MyFactura.Moneda = monedaLocal.Moneda1;
             MyFactura.MonedaSimbolo = monedaLocal.Simbolo;
             MyFactura.MonedaDescripcion = monedaLocal.Descripcion; 

             var ciaContabID = (from c in ControlCajaChicaContext.CajaChica_Reposiciones
                              where c.Reposicion == facCCCh.Reposicion
                              select new { c.CajaChica_CajasChicas.CiaContab }).FirstOrDefault();

             MyFactura.CiaContab = ciaContabID.CiaContab;

             // leemos los datos de la compañía Contab 
             var ciaContab = (from c in BancosDB.Companias
                              where c.Numero == ciaContabID.CiaContab
                              select new { c.Nombre, 
                                           c.Abreviatura, 
                                           c.Direccion, 
                                           c.Ciudad, 
                                           c.Rif, 
                                           c.Telefono1, 
                                           c.Telefono2, 
                                           c.Fax 
                                         }).FirstOrDefault();

             if (ciaContab != null)
             {
                 MyFactura.CiaContabNombre = ciaContab.Nombre;
                 MyFactura.CiaContabDireccion = ciaContab.Direccion + ", " + ciaContab.Ciudad;
                 MyFactura.CiaContabRif = ciaContab.Rif;
                 MyFactura.CiaContabTelefono1 = ciaContab.Telefono1;
                 MyFactura.CiaContabTelefono2 = ciaContab.Telefono2;
                 MyFactura.CiaContabFax = ciaContab.Fax; 
             }


             // en el CCCh el usuario puede indicar un proveedor desde la maestra o, simplemente, un 
             // nombre y rif 
             if (facCCCh.Proveedor != null)
             {
                 var datosProveedor = (from p in BancosDB.Proveedores
                                       where p.Proveedor == facCCCh.Proveedor
                                       select new
                                       {
                                           p.Proveedor,
                                           p.Nombre,
                                           p.Abreviatura, 
                                           p.CodigoConceptoRetencion,
                                           p.Rif, 
                                           p.ContribuyenteFlag
                                       }).FirstOrDefault();

                 if (datosProveedor != null)
                 {
                     MyFactura.Compania = datosProveedor.Proveedor;
                     MyFactura.NombreCompania = datosProveedor.Nombre;
                     MyFactura.AbreviaturaCompania = datosProveedor.Abreviatura; 
                     MyFactura.CodigoConceptoRetencion = datosProveedor.CodigoConceptoRetencion; 
                     MyFactura.RifCompania = datosProveedor.Rif;
                     MyFactura.ContribuyenteFlag = datosProveedor.ContribuyenteFlag; 
                 }
             }
             else
             {
                 // el usuario no indico un proveedor registrado en la maestra; seguramente indico 
                 // un nombre y número de rif     

                 MyFactura.Compania = 0;
                 MyFactura.NombreCompania = facCCCh.Nombre;
                 MyFactura.AbreviaturaCompania = facCCCh.Nombre.Length <= 10 ? facCCCh.Nombre.Substring(0, facCCCh.Nombre.Length) : facCCCh.Nombre.Substring(0, 10); 
                 MyFactura.RifCompania = facCCCh.Rif;
                 MyFactura.ContribuyenteFlag = false; 
             }

             MyFactura.NumeroFactura = facCCCh.NumeroDocumento;
             MyFactura.NumeroControl = facCCCh.NumeroControl;

             // nótese como asignamos un número único negativo ... 
             nClaveUnicaFactura -= 1;

             MyFactura.ClaveUnicaFactura = nClaveUnicaFactura;

             // asumimos que todas las facturas son compras nacionales 
             MyFactura.ImportacionFlag = false;

             MyFactura.Importacion_CompraNacional = "Compras nacionales";

      
             MyFactura.NcNdFlag = "";
             MyFactura.Compra_NotaCredito = "Compras";

             if (facCCCh.Total < 0)
             {
                 MyFactura.NcNdFlag = "NC";
                 MyFactura.Compra_NotaCredito = "Notas de crédito";
             }

             MyFactura.NumeroFacturaAfectada = "";
             MyFactura.NumeroComprobante = "";
             MyFactura.NumeroOperacion = null;
             MyFactura.Tipo = 0;
             MyFactura.NombreTipo = "Control de Caja Chica";
             MyFactura.CondicionesDePago = 0;
             MyFactura.FechaEmision = facCCCh.FechaDocumento.Value;
             MyFactura.FechaRecepcion = facCCCh.FechaDocumento.Value;
             MyFactura.Concepto = facCCCh.Descripcion;
             MyFactura.MontoFacturaSinIva = facCCCh.MontoNoImponible;
             MyFactura.MontoFacturaConIva = facCCCh.Monto;

            MyFactura.MontoTotalFactura = 0;

            if (MyFactura.MontoFacturaSinIva.HasValue)
                MyFactura.MontoTotalFactura += MyFactura.MontoFacturaSinIva.Value;

            if (MyFactura.MontoFacturaConIva.HasValue)
                MyFactura.MontoTotalFactura += MyFactura.MontoFacturaConIva.Value;

            if (facCCCh.IvaPorc != null && facCCCh.IvaPorc != 0)
             {
                 MyFactura.TipoAlicuota = "G";

                 MyFactura.IvaPorc_General = facCCCh.IvaPorc;
                 MyFactura.BaseImponible_General = facCCCh.Monto;
                 MyFactura.Iva_General = facCCCh.Iva;
                 MyFactura.TipoAlicuota_General = "G"; 
                 MyFactura.ImpuestoRetenido_General = 0;
             }

             if (facCCCh.IvaPorc != null) 
                MyFactura.IvaPorc = facCCCh.IvaPorc;

             MyFactura.Iva = facCCCh.Iva;
             MyFactura.TotalFactura = facCCCh.Total;

             // se lee arriba desde el proveedor (bueno, si se asoció uno a la factua de caja chica) 

             //MyFactura.CodigoConceptoRetencion = null;
             MyFactura.MontoSujetoARetencion = null;
             MyFactura.ImpuestoRetenidoPorc = null;
             MyFactura.ImpuestoRetenido = null;
             MyFactura.FRecepcionRetencionISLR = null;
             MyFactura.RetencionSobreIvaPorc = null;
             MyFactura.RetencionSobreIva = null;
             MyFactura.FRecepcionRetencionIVA = null;
             MyFactura.TotalAPagar = facCCCh.Total;
             MyFactura.Anticipo = null;

             // asumimos que todas las facturas del CCCh están pagadas 
             MyFactura.Saldo = 0;
             MyFactura.Estado = 3;
             MyFactura.NombreEstado = "Pagada";

             MyFactura.CxCCxPFlag = 1;
             MyFactura.NombreCxCCxPFlag = "CxP";
             MyFactura.Comprobante = null;

             MyFactura.NombreUsuario = Membership.GetUser().UserName;
             
             MyFacturas_List.Add(MyFactura);
         }

         if (MyFacturas_List.Count > 0)
         {
            foreach (var f in MyFacturas_List)
            {
                BancosDB.tTempWebReport_ConsultaFacturas.AddObject(f);
            }

             try
             {
                 BancosDB.SaveChanges();
             }

             catch (Exception ex)
             {
                 BancosDB.Dispose();

                 string errorMessage1 = 
                     "Ha ocurrido un error al intentar ejecutar una operación " +
                     "de acceso a la base de datos. <br /> " + 
                     "Razones probables para la ocurrencia de este error son: <br /><br />" +
                     "*) Existen dos o más facturas con el mismo número " +
                     "registradas en el módulo Control de Caja Chica. <br /> " +
                     "*) Alguna de las facturas registradas en el control de caja chica tiene " +
                     "su número en blanco. <br /><br /> " +
                     "El mensaje específico de error es: " + ex.Message + "<br /><br />";


                 // intentamos determinar facturas con problemas; deben estar en la lista con números repetidos o con su número en blanco ... 
                 string errorMessage2 = ""; 

                 if (MyFacturas_List.Where(x => string.IsNullOrEmpty(x.NumeroFactura)).Count() > 0) 
                     errorMessage2 = "Nota: existen " + MyFacturas_List.Where(x => string.IsNullOrEmpty(x.NumeroFactura)).Count().ToString() + 
                         " facturas registradas en Caja Chica con número en blanco."; 

                 var queryFacturasRepetidas = from f in MyFacturas_List 
                                              group f by new { f.Moneda, f.CiaContab, f.Compania, f.NumeroFactura, f.NombreUsuario } 
                                              into g 
                                              select g; 


                 foreach (var f in queryFacturasRepetidas)
                 {
                     if (f.Count() > 1)
                     {
                         if (errorMessage2 == "")
                         {
                             errorMessage2 = "Nota: a continuación mostramos facturas repetidas (para la misma compañía) registradas en Caja Chica; favor corregir: ";
                             errorMessage2 += f.Key.NumeroFactura; 
                         }
                         else
                            errorMessage2 += ", " + f.Key.NumeroFactura; 
                     }
                 }

                 if (errorMessage2 != "")
                     errorMessage2 += ".<br />";


                 ErrMessage_Span.InnerHtml = errorMessage1 + errorMessage2; 
                 ErrMessage_Span.Style["display"] = "block";
                 return;
             }
         }


         // --------------------------------------------------------------------------------------------------------------------------------------
         // ahora que grabamos las facturas a sql server, las grabamos a mongo, pues, en adelante, muchas funciones (consultas) leerán de allí ... 
         string resulMessage = "";
         string userName = Membership.GetUser().UserName;

         if (!GrabarFacturasSeleccionadasMongo(BancosDB, userName, out resulMessage))
         {
             ErrMessage_Span.InnerHtml = resulMessage;
             ErrMessage_Span.Style["display"] = "block";

             return;
         }
         // --------------------------------------------------------------------------------------

        // ------------------------------------------------------------------------------------------------
        // hacemos el databinding de los dos combos 

        this.CiasContab_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;
        this.Monedas_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;
        this.CxCCxP_SqlDataSource.SelectParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;

        CiasContab_DropDownList.DataBind();
        Monedas_DropDownList.DataBind();
        CxCCxP_DropDownList.DataBind();

        // intentamos usar como parametros del LinqDataSource el primer item en los combos Monedas y CiasContab

        if (this.CiasContab_DropDownList.Items.Count > 0)
        {
            CiasContab_DropDownList.SelectedIndex = 0;
        }

        if (this.Monedas_DropDownList.Items.Count > 0)
        {
            Monedas_DropDownList.SelectedIndex = 0;
        }

        if (this.CxCCxP_DropDownList.Items.Count > 0)
        {
            CxCCxP_DropDownList.SelectedIndex = 0;
        }

        // establecemos los valores de los parámetros en el LinqDataSource 
        ConsultaFacturas_LinqDataSource.WhereParameters["CiaContab"].DefaultValue = "-999";
        ConsultaFacturas_LinqDataSource.WhereParameters["Moneda"].DefaultValue = "-99";
        ConsultaFacturas_LinqDataSource.WhereParameters["CxCCxPFlag"].DefaultValue = "-99";
       
        if (CiasContab_DropDownList.SelectedValue != null && CiasContab_DropDownList.SelectedValue.ToString() != "") 
            ConsultaFacturas_LinqDataSource.WhereParameters["CiaContab"].DefaultValue = CiasContab_DropDownList.SelectedValue.ToString();

        if (Monedas_DropDownList.SelectedValue != null && Monedas_DropDownList.SelectedValue.ToString() != "") 
            ConsultaFacturas_LinqDataSource.WhereParameters["Moneda"].DefaultValue = Monedas_DropDownList.SelectedValue.ToString();

        if (CxCCxP_DropDownList.SelectedValue != null && CxCCxP_DropDownList.SelectedValue.ToString() != "") 
            ConsultaFacturas_LinqDataSource.WhereParameters["CxCCxPFlag"].DefaultValue = CxCCxP_DropDownList.SelectedValue.ToString();

        ConsultaFacturas_LinqDataSource.WhereParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;

        // leemos la cantidad de registros escritos a la tabla temporal para mostrar al usuario 
        string nombreUsuario = Membership.GetUser().UserName;
        sSqlQueryString = $"SELECT Count(*) FROM tTempWebReport_ConsultaFacturas Where NombreUsuario = '{nombreUsuario}'";
        int cantRegistros = BancosDB.ExecuteStoreQuery<int>(sSqlQueryString).First();
        this.cantRegistrosSeleccionados_Label.Text = $"({cantRegistros.ToString()} registros seleccionados)"; 

        Facturas_ListView.DataBind();

        BancosDB.Dispose();
    }

    protected void CiasContab_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
       
        // establecemos los valores de los parámetros en el LinqDataSource 

        ConsultaFacturas_LinqDataSource.WhereParameters["CiaContab"].DefaultValue = CiasContab_DropDownList.SelectedValue.ToString();
        ConsultaFacturas_LinqDataSource.WhereParameters["Moneda"].DefaultValue = Monedas_DropDownList.SelectedValue.ToString();
        ConsultaFacturas_LinqDataSource.WhereParameters["CxCCxPFlag"].DefaultValue = CxCCxP_DropDownList.SelectedValue.ToString();
        ConsultaFacturas_LinqDataSource.WhereParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;

        Facturas_ListView.DataBind();
        Facturas_ListView.SelectedIndex = -1; 
    }
    protected void Monedas_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        // establecemos los valores de los parámetros en el LinqDataSource 

        ConsultaFacturas_LinqDataSource.WhereParameters["CiaContab"].DefaultValue = CiasContab_DropDownList.SelectedValue.ToString();
        ConsultaFacturas_LinqDataSource.WhereParameters["Moneda"].DefaultValue = Monedas_DropDownList.SelectedValue.ToString();
        ConsultaFacturas_LinqDataSource.WhereParameters["CxCCxPFlag"].DefaultValue = CxCCxP_DropDownList.SelectedValue.ToString();
        ConsultaFacturas_LinqDataSource.WhereParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;

        Facturas_ListView.DataBind();
        Facturas_ListView.SelectedIndex = -1; 
    }
    protected void CxCCxP_DropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
       
        // establecemos los valores de los parámetros en el LinqDataSource 

        ConsultaFacturas_LinqDataSource.WhereParameters["CiaContab"].DefaultValue = CiasContab_DropDownList.SelectedValue.ToString();
        ConsultaFacturas_LinqDataSource.WhereParameters["Moneda"].DefaultValue = Monedas_DropDownList.SelectedValue.ToString();
        ConsultaFacturas_LinqDataSource.WhereParameters["CxCCxPFlag"].DefaultValue = CxCCxP_DropDownList.SelectedValue.ToString();
        ConsultaFacturas_LinqDataSource.WhereParameters["NombreUsuario"].DefaultValue = Membership.GetUser().UserName;

        Facturas_ListView.DataBind();
        Facturas_ListView.SelectedIndex = -1; 
    }

    public string Fix_URL(string oldURL)
    {

        string res = oldURL;

        // Do whatever it takes to change oldURL

        return "javascript:PopupWin('Facturas_Detalles.aspx?cuf=" + res + "', 1000, 680)";

    }

    public string FacturaCajaChica(int tipo, string nombreTipo) 
    {
        // para mostrar en la lista (ListView) si la factura viene o no del control de caja chica ... 

        if (tipo != 0)
            return ""; 

        if (nombreTipo != "Control de Caja Chica")
            return ""; 

        return "X"; 
    }

    private bool GrabarFacturasSeleccionadasMongo(BancosEntities bancosContext, string userName, out string resultMessage)
    {
        // TODO: ahora que grabamos las facturas a sql server, las grabamos a 
        // mongo, pues, en adelante, muchas funciones (consultas) leerán de allí ...

        resultMessage = "";

        // --------------------------------------------------------------------------------------------------------------------------
        // establecemos una conexión a mongodb 

        var client = new MongoClient("mongodb://localhost");
        var mongoDataBase = client.GetDatabase("dbContab");
        // --------------------------------------------------------------------------------------------------------------------------

        var facturasMongoCollection = mongoDataBase.GetCollection<FacturaSeleccionada_Consultas>("Factura_Consultas");

        try
        {
            // --------------------------------------------------------------------------------------------------------------------------
            // eliminamos las facturas en la tabla 'temporal' que corresponden al usuario 
            var builder = Builders<FacturaSeleccionada_Consultas>.Filter;
            var filter = builder.Eq(x => x.NombreUsuario, userName);

            facturasMongoCollection.DeleteManyAsync(filter);
        }
        catch (Exception ex)
        {
            string message = ex.Message;
            if (ex.InnerException != null)
                message += "<br />" + ex.InnerException.Message;

            resultMessage = "Se producido un error al intentar ejecutar una operación en mongodb.<br />" +
                               "El mensaje específico del error es:<br />" + message;

            return false;       
        }


        // leemos las facturas que, recientemente, se han registrado para el usuario en sql server y las grabamos a mongo ... 
        var query = bancosContext.tTempWebReport_ConsultaFacturas.Where(f => f.NombreUsuario == userName);

        FacturaSeleccionada_Consultas facturaMongo;

        try
        {
            foreach (tTempWebReport_ConsultaFacturas factura in query)
            {
                facturaMongo = new FacturaSeleccionada_Consultas();

                facturaMongo.Moneda = factura.Moneda;
                facturaMongo.MonedaSimbolo = factura.MonedaSimbolo;
                facturaMongo.MonedaDescripcion = factura.MonedaDescripcion;

                facturaMongo.CiaContab = factura.CiaContab;
                facturaMongo.CiaContabCiudad = factura.CiaContabCiudad; 
                facturaMongo.CiaContabNombre = factura.CiaContabNombre;
                facturaMongo.CiaContabDireccion = factura.CiaContabDireccion;
                facturaMongo.CiaContabRif = factura.CiaContabRif;
                facturaMongo.CiaContabTelefono1 = factura.CiaContabTelefono1;
                facturaMongo.CiaContabTelefono2 = factura.CiaContabTelefono2;
                facturaMongo.CiaContabFax = factura.CiaContabFax;

                facturaMongo.Compania = factura.Compania;
                facturaMongo.NombreCompania = factura.NombreCompania;
                facturaMongo.AbreviaturaCompania = factura.AbreviaturaCompania;
                facturaMongo.CodigoConceptoRetencion = factura.CodigoConceptoRetencion;
                facturaMongo.RifCompania = factura.RifCompania;
                facturaMongo.NitCompania = factura.NitCompania;
                facturaMongo.CompaniaDomicilio = factura.CompaniaDomicilio;
                facturaMongo.CompaniaTelefono = factura.CompaniaTelefono;
                facturaMongo.CompaniaCiudad = factura.CompaniaCiudad;
                facturaMongo.ContribuyenteFlag = factura.ContribuyenteFlag; 

                facturaMongo.NumeroFactura = factura.NumeroFactura;
                facturaMongo.NumeroControl = factura.NumeroControl;

                facturaMongo.ClaveUnicaFactura = factura.ClaveUnicaFactura;
                facturaMongo.ImportacionFlag = factura.ImportacionFlag.HasValue ? factura.ImportacionFlag.Value : false;
                facturaMongo.Importacion_CompraNacional = factura.Importacion_CompraNacional;
                facturaMongo.NumeroPlanillaImportacion = factura.NumeroPlanillaImportacion; 

                facturaMongo.NcNdFlag = factura.NcNdFlag;
                facturaMongo.Compra_NotaCredito = factura.Compra_NotaCredito;

                facturaMongo.NumeroFacturaAfectada = factura.NumeroFacturaAfectada;
                facturaMongo.NumeroComprobante = factura.NumeroComprobante;
                facturaMongo.NumeroOperacion = factura.NumeroOperacion;
                facturaMongo.Tipo = factura.Tipo;
                facturaMongo.NombreTipo = factura.NombreTipo;
                facturaMongo.CondicionesDePago = factura.CondicionesDePago;
                facturaMongo.CondicionesDePagoNombre = factura.CondicionesDePagoNombre;
                facturaMongo.FechaEmision = factura.FechaEmision;
                facturaMongo.FechaRecepcion = factura.FechaRecepcion;
                facturaMongo.Concepto = factura.Concepto;
                facturaMongo.NotasFactura1 = factura.NotasFactura1;
                facturaMongo.NotasFactura2 = factura.NotasFactura2;
                facturaMongo.NotasFactura3 = factura.NotasFactura3; 

                facturaMongo.MontoFacturaSinIva = factura.MontoFacturaSinIva;
                facturaMongo.MontoFacturaConIva = factura.MontoFacturaConIva;
                facturaMongo.MontoTotalFactura = factura.MontoTotalFactura; 

                facturaMongo.TipoAlicuota = !string.IsNullOrEmpty(factura.TipoAlicuota) ? factura.TipoAlicuota.ToString() : "";

                facturaMongo.IvaPorc_Reducido = factura.IvaPorc_Reducido;
                facturaMongo.IvaPorc_General = factura.IvaPorc_General;
                facturaMongo.IvaPorc_Adicional = factura.IvaPorc_Adicional;

                facturaMongo.BaseImponible_General = factura.BaseImponible_General;
                facturaMongo.BaseImponible_Adicional = factura.BaseImponible_Adicional.HasValue ? factura.BaseImponible_Adicional.Value : 0;
                facturaMongo.BaseImponible_Reducido = factura.BaseImponible_Reducido.HasValue ? factura.BaseImponible_Reducido.Value : 0;

                facturaMongo.Iva_Reducido = factura.Iva_Reducido;
                facturaMongo.Iva_General = factura.Iva_General;
                facturaMongo.Iva_Adicional = factura.Iva_Adicional;

                facturaMongo.ImpuestoRetenido_General = factura.ImpuestoRetenido_General;
                facturaMongo.IvaPorc = factura.IvaPorc;
                facturaMongo.Iva = factura.Iva;
                facturaMongo.TotalFactura = factura.TotalFactura;

                // se lee arriba desde el proveedor (bueno, si se asoció uno a la factua de caja chica) 

                
                facturaMongo.MontoSujetoARetencion = factura.MontoSujetoARetencion;

                facturaMongo.ImpuestoRetenidoISLRAntesSustraendo = factura.ImpuestoRetenidoISLRAntesSustraendo;
                facturaMongo.ImpuestoRetenidoISLRSustraendo = factura.ImpuestoRetenidoISLRSustraendo;
                facturaMongo.ImpuestoRetenido_Reducido = factura.ImpuestoRetenido_Reducido;
                facturaMongo.ImpuestoRetenido_General = factura.ImpuestoRetenido_General;
                facturaMongo.ImpuestoRetenido_Adicional = factura.ImpuestoRetenido_Adicional;

                facturaMongo.ImpuestoRetenidoPorc = factura.ImpuestoRetenidoPorc;
                facturaMongo.ImpuestoRetenido = factura.ImpuestoRetenido;
                facturaMongo.FRecepcionRetencionISLR = factura.FRecepcionRetencionISLR;

                facturaMongo.RetencionSobreIvaPorc = factura.RetencionSobreIvaPorc;
                facturaMongo.RetencionSobreIva = factura.RetencionSobreIva;
                facturaMongo.FRecepcionRetencionIVA = factura.FRecepcionRetencionIVA;

                facturaMongo.ImpuestosVarios = factura.ImpuestosVarios;
                facturaMongo.RetencionesVarias = factura.RetencionesVarias;

                facturaMongo.TotalAPagar = factura.TotalAPagar;
                facturaMongo.Anticipo = factura.Anticipo;

                facturaMongo.Saldo = factura.Saldo;
                facturaMongo.Estado = factura.Estado;
                facturaMongo.NombreEstado = factura.NombreEstado;

                facturaMongo.CxCCxPFlag = factura.CxCCxPFlag;
                facturaMongo.NombreCxCCxPFlag = factura.NombreCxCCxPFlag;

                facturaMongo.Comprobante = factura.Comprobante;

                facturaMongo.FechaPago = factura.FechaPago;
                facturaMongo.MontoPagado = factura.MontoPagado;

                facturaMongo.NombreUsuario = factura.NombreUsuario;

                // finalmente, grabamos el registro a mongo ... 
                facturasMongoCollection.InsertOneAsync(facturaMongo);
            }
        }
        catch(Exception ex)
        {
            string message = ex.Message;
            if (ex.InnerException != null)
                message += "<br />" + ex.InnerException.Message;

            resultMessage = "Se producido un error al intentar ejecutar una operación en mongodb.<br />" +
                               "El mensaje específico del error es:<br />" + message;

            return false;       
        }

        return true;
    }
}
