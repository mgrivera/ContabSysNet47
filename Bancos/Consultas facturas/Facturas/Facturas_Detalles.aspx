<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple_WithBootStrap.master" AutoEventWireup="true" Inherits="Bancos_Facturas_Facturas_Detalles" Codebehind="Facturas_Detalles.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">

<style type="text/css">

    .fieldset_div
    {
        padding: 6px; 
        text-align: left; 
        display: inline-block;
    }
    
    .label
    {
        font-weight: bold;
        color: #595959;
        margin-right: 10px; 
        font-size: small; 
    }
    
</style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

   <script type="text/javascript">
        function PopupWin(url, w, h) {
            ///Parameters url=page to open, w=width, h=height
            window.open(url, "external", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,top=10px,left=8px");
        }
        function RefreshPage() {
            window.document.getElementById("RebindFlagSpan").firstChild.value = "1";
            window.document.forms(0).submit();
        }
    </script>

    <div style="margin: 10px; text-align: center; ">

        <%--  para refrescar la página cuando el popup se cierra (y saber que el refresh es por eso) --%>
        <span id="RebindFlagSpan">
            <asp:HiddenField ID="RebindFlagHiddenField" runat="server" Value="0" />
        </span>

        <ul class="nav nav-pills" style="margin: 5px 0px 5px 0px; ">
            <li><a href="#" id="MostrarCuotas_HyperLink" runat="server">Cuotas</a></li>
            <li><a href="#" id="MostrarAsientosContables_HyperLink" runat="server">Asientos contables</a></li>
        </ul>

        <div style="clear: both;" />

        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
            style="display: block;"></span>

        <asp:FormView ID="Factura_FormView"
            runat="server"
            ItemType="ContabSysNet_Web.ModelosDatos_EF.Bancos.Factura"
            DataKeyNames="ClaveUnica"
            SelectMethod="Factura_FormView_GetItem">

            <HeaderTemplate>
            </HeaderTemplate>

            <ItemTemplate>

                <fieldset style="background-color: #FBFBFB; border: solid 1px LightGray; display: inline; font-size: small;">
                    <h3 style="background-color: #6495ED; color: White; padding: 5px;">Detalles de la factura</h3>
                    <table style="text-align: left;">
                        <tr>
                            <td><span class="label">Compañía:</span>
                            </td>
                            <td>
                                <asp:Label ID="lblName" runat="server" Text='<%# Item.Proveedore.Nombre %>'></asp:Label>
                            </td>
                            <td></td>
                            <td><span class="label">Factura:</span>
                            </td>
                            <td>
                                <asp:Label ID="Label7" runat="server" Text='<%# Item.NumeroFactura %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td><span class="label">Fecha emisión:</span>
                            </td>
                            <td><%# Item.FechaEmision.ToString("dd-MMM-yyyy") %>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            (
                            <asp:Label ID="Label8" runat="server" Text='<%# NombreCxCCxP(Item.CxCCxPFlag.ToString())%>' />
                                )
                       
                            </td>
                            <td></td>
                            <td><span class="label">Control:</span>
                            </td>
                            <td>
                                <asp:Label ID="Label2" runat="server" Text='<%# Item.NumeroControl %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td><span class="label">Fecha recepción:</span>
                            </td>
                            <td>
                                <%# Item.FechaRecepcion.ToString("dd-MMM-yyyy") %>
                            </td>
                            <td></td>
                            <td><span class="label">Forma de pago:</span>
                            </td>
                            <td>
                                <asp:Label ID="Label4" runat="server" Text='<%# Item.FormasDePago.Descripcion %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td><span class="label">Tipo:</span>
                            </td>
                            <td>
                                <asp:Label ID="Label1" runat="server" Text='<%# Item.TiposProveedor.Descripcion %>'></asp:Label>
                            </td>
                            <td></td>
                            <td><span class="label">NC/ND:</span>
                            </td>
                            <td>
                                <asp:Label ID="Label5" runat="server" Text='<%# Item.NcNdFlag %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td><span class="label">Comprobante Seniat:</span>
                            </td>
                            <td>
                                <asp:Label ID="Label6" runat="server" Text='<%# Item.NumeroComprobante %>'></asp:Label>/
                            <asp:Label ID="Label3" runat="server" Text='<%# Item.NumeroOperacion %>'></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="vertical-align: top;"><span class="label">Concepto:</span></td>
                            <td colspan="2">
                                <div style="width: 300px;">
                                    <%# Item.Concepto %>
                                </div>
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td><span class="label">Monto no imponible:</span></td>
                            <td>
                                <asp:Label ID="Label9" runat="server" Text='<%# FormatDecimal(Item.MontoFacturaSinIva) %>'></asp:Label></td>
                            <td></td>
                            <td><span class="label">Monto imponible:</span></td>
                            <td>
                                <asp:Label ID="Label10" runat="server" Text='<%# FormatDecimal(Item.MontoFacturaConIva) %>'></asp:Label></td>
                        </tr>
                    </table>
                </fieldset>

                <br />

                <fieldset style="display: inline; font-size: small;">
                    <legend>Impuestos y retenciones:&nbsp&nbsp</legend>
                    <asp:Repeater ID="impuestosRetenciones_Repeater"
                        runat="server"
                        ItemType="ContabSysNet_Web.ModelosDatos_EF.Bancos.Facturas_Impuestos"
                        SelectMethod="impuestosRetenciones_Repeater_GetData">
                        <HeaderTemplate>

                            <table cellspacing="0" style="margin-top: 10px;">
                                <thead style="background-color: #6495ED; color: white;">
                                    <tr>
                                        <th style="text-align: left; padding: 0px 10px 0px 10px;">Concepto</th>
                                        <th style="text-align: center; padding: 0px 10px 0px 10px;">Código</th>
                                        <th style="text-align: right; padding: 0px 10px 0px 10px;">Base</th>
                                        <th style="text-align: center; padding: 0px 10px 0px 10px;">%</th>
                                        <th style="text-align: center; padding: 0px 10px 0px 10px;">Tipo<br />
                                            alícuota</th>
                                        <th style="text-align: right; padding: 0px 10px 0px 10px;">Monto</th>
                                        <th style="text-align: right; padding: 0px 10px 0px 10px;">Sustraendo</th>
                                        <th style="text-align: right; padding: 0px 10px 0px 10px;">Monto</th>
                                        <th style="text-align: center; padding: 0px 10px 0px 10px;">F planilla</th>
                                    </tr>
                                </thead>
                                <tbody>
                        </HeaderTemplate>

                        <ItemTemplate>
                            <tr>
                                <td style="text-align: left; padding: 0px 10px 0px 10px;"><%# Item.ImpuestosRetencionesDefinicion.Descripcion %></td>
                                <td style="text-align: center; padding: 0px 10px 0px 10px;"><%# Item.Codigo %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# Item.MontoBase != null ? Item.MontoBase.Value.ToString("N2") : "" %></td>
                                <td style="text-align: center; padding: 0px 10px 0px 10px;"><%# Item.Porcentaje != null ? Item.Porcentaje.Value.ToString("N2") : "" %></td>
                                <td style="text-align: center; padding: 0px 10px 0px 10px;"><%# Item.TipoAlicuota %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# Item.MontoAntesSustraendo != null ? Item.MontoAntesSustraendo.Value.ToString("N2") : "" %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# Item.Sustraendo != null ? Item.Sustraendo.Value.ToString("N2") : "" %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# Item.Monto.ToString("N2") %></td>
                                <td style="text-align: center; padding: 0px 10px 0px 10px;"><%# Item.FechaRecepcionPlanilla != null ? Item.FechaRecepcionPlanilla.Value.ToString("dd-MMM-yy") : "" %></td>
                            </tr>
                        </ItemTemplate>

                        <AlternatingItemTemplate>
                            <tr style="background-color: #EAEAEA;">
                                <td style="text-align: left; padding: 0px 10px 0px 10px;"><%# Item.ImpuestosRetencionesDefinicion.Descripcion %></td>
                                <td style="text-align: center; padding: 0px 10px 0px 10px;"><%# Item.Codigo %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# Item.MontoBase != null ? Item.MontoBase.Value.ToString("N2") : "" %></td>
                                <td style="text-align: center; padding: 0px 10px 0px 10px;"><%# Item.Porcentaje != null ? Item.Porcentaje.Value.ToString("N2") : "" %></td>
                                <td style="text-align: center; padding: 0px 10px 0px 10px;"><%# Item.TipoAlicuota %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# Item.MontoAntesSustraendo != null ? Item.MontoAntesSustraendo.Value.ToString("N2") : "" %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# Item.Sustraendo != null ? Item.Sustraendo.Value.ToString("N2") : "" %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# Item.Monto.ToString("N2") %></td>
                                <td style="text-align: center; padding: 0px 10px 0px 10px;"><%# Item.FechaRecepcionPlanilla != null ? Item.FechaRecepcionPlanilla.Value.ToString("dd-MMM-yy") : "" %></td>
                            </tr>
                        </AlternatingItemTemplate>

                        <FooterTemplate>
                            </tbody>

                            <tfoot>
                            </tfoot>
                            </table>
                        </FooterTemplate>

                    </asp:Repeater>

                </fieldset>

                <fieldset style="font-size: small;">
                    <legend>Resumen:&nbsp&nbsp</legend>
                    <table cellspacing="0" style="margin-top: 10px; margin-bottom: 15px;">

                        <thead style="background-color: #6495ED; color: white;">
                            <tr>
                                <th style="text-align: right; padding: 0px 10px 0px 10px;">Monto</th>
                                <th style="text-align: right; padding: 0px 10px 0px 10px;">Iva</th>
                                <th style="text-align: right; padding: 0px 10px 0px 10px;">Impuestos<br />
                                    (varios)</th>
                                <th style="text-align: right; padding: 0px 10px 0px 10px;">Total<br />
                                    factura</th>
                                <th style="text-align: right; padding: 0px 10px 0px 10px;">Retención<br />
                                    Islr</th>
                                <th style="text-align: right; padding: 0px 10px 0px 10px;">Retención<br />
                                    Iva</th>
                                <th style="text-align: right; padding: 0px 10px 0px 10px;">Retenciones<br />
                                    (varias)</th>
                                <th style="text-align: right; padding: 0px 10px 0px 10px;">Total a<br />
                                    pagar</th>
                                <th style="text-align: right; padding: 0px 10px 0px 10px;">Saldo</th>
                                <th style="text-align: right; padding: 0px 10px 0px 10px;">Anticipo</th>
                                <th style="text-align: left; padding: 0px 10px 0px 10px;">Estado</th>
                            </tr>
                        </thead>

                        <tbody>
                            <tr>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# FormatDecimal((Item.MontoFacturaSinIva != null ? Item.MontoFacturaSinIva.Value : 0) + (Item.MontoFacturaConIva != null ? Item.MontoFacturaConIva.Value : 0)) %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# FormatDecimal(Item.Iva) %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# FormatDecimal(Item.OtrosImpuestos) %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# Item.TotalFactura.ToString("N2") %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# FormatDecimal(Item.ImpuestoRetenido) %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# FormatDecimal(Item.RetencionSobreIva) %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# FormatDecimal(Item.OtrasRetenciones) %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# Item.TotalAPagar.ToString("N2") %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# Item.Saldo.ToString("N2") %></td>
                                <td style="text-align: right; padding: 0px 10px 0px 10px;"><%# FormatDecimal(Item.Anticipo) %></td>
                                <td style="text-align: left; padding: 0px 10px 0px 10px;"><%# NombreEstadoFactura(Item.Estado) %></td>
                            </tr>
                        </tbody>
                    </table>
                </fieldset>

            </ItemTemplate>
        </asp:FormView>

        <fieldset style="display: inline; font-size: small;">
            <legend>Pagos:&nbsp&nbsp</legend>
            <asp:ListView ID="Pagos_ListView" runat="server"
                DataSourceID="Pagos_SqlDataSource">

                <LayoutTemplate>
                    <table runat="server">
                        <tr runat="server">
                            <td runat="server">
                                <table id="itemPlaceholderContainer" runat="server" border="0" style="border: 1px solid #E6E6E6" cellspacing="0" rules="none">
                                    <tr>
                                        <td class="ListViewHeader_Suave" style="font-weight: bold; border-right-style: solid; border-right-width: 1px; border-right-color: white; background-color: #6495ED;" colspan="3">Pago
                                        </td>
                                        <td class="ListViewHeader_Suave" style="font-weight: bold; background-color: #6495ED;" colspan="7">Movimiento bancario
                                        </td>
                                    </tr>
                                    <tr runat="server" style="" class="ListViewHeader_Suave">
                                        <th id="Th2" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;">Número
                                        </th>
                                        <th id="Th1" runat="server" class="padded" style="text-align: center; padding-bottom: 8px;">Fecha
                                        </th>
                                        <th runat="server" class="padded" style="text-align: right; padding-bottom: 8px; border-right-style: solid; border-right-width: 1px; border-right-color: white;">Monto
                                        </th>
                                        <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px;">Número
                                        </th>
                                        <th runat="server" class="padded" style="text-align: center; padding-bottom: 8px;">Tipo
                                        </th>
                                        <th runat="server" class="padded" style="text-align: center; padding-bottom: 8px;">Fecha
                                        </th>
                                        <th runat="server" class="padded" style="text-align: right; padding-bottom: 8px;">Monto
                                        </th>
                                        <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px;">Cuenta
                                        </th>
                                        <th runat="server" class="padded" style="text-align: center; padding-bottom: 8px;">Mon
                                        </th>
                                        <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px;">Banco
                                        </th>
                                    </tr>
                                    <tr id="itemPlaceholder" runat="server">
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>
                </LayoutTemplate>

                <ItemTemplate>
                    <tr style="">
                        <td class="padded" style="text-align: left;">
                            <a href="javascript:PopupWin('../Pagos/Pago_page.aspx?ID=' + <%# Eval("ClaveUnicaPago") %>, 1000, 680)">
                                <%#Eval("NumeroPago")%>
                            </a>
                        </td>
                        <td class="padded" style="text-align: center;">
                            <asp:Label runat="server" Text='<%# Eval("FechaPago", "{0:dd-MMM-yy}") %>' />
                        </td>
                        <td class="padded" style="text-align: right;">
                            <asp:Label runat="server" Text='<%# Eval("MontoPagado", "{0:N2}") %>' />
                        </td>
                        <td class="padded" style="text-align: left;">
                            <a href="javascript:PopupWin('../../ConsultasBancos/MovimientosBancarios/MovimientoBancario_page.aspx?ID=' + <%# Eval("ClaveUnicaMovimientoBancario") %>, 1000, 680)">
                                <%#Eval("Transaccion")%>
                            </a>
                        </td>
                        <td class="padded" style="text-align: center;">
                            <asp:Label ID="Tipo" runat="server" Text='<%# Eval("TipoMovBanco") %>' />
                        </td>
                        <td class="padded" style="text-align: center;">
                            <asp:Label runat="server" Text='<%# Eval("FechaMovBanco", "{0:dd-MMM-yy}") %>' />
                        </td>
                        <td class="padded" style="text-align: right;">
                            <asp:Label runat="server" Text='<%# Eval("MontoMovBanco", "{0:N2}") %>' />
                        </td>
                        <td class="padded" style="text-align: left;">
                            <asp:Label ID="Cuenta" runat="server" Text='<%# Eval("CuentaBancaria") %>' />
                        </td>
                        <td class="padded" style="text-align: center;">
                            <asp:Label ID="Mon" runat="server" Text='<%# Eval("SimboloMoneda") %>' />
                        </td>
                        <td class="padded" style="text-align: left;">
                            <asp:Label ID="Banco" runat="server" Text='<%# Eval("NombreBanco") %>' />
                        </td>
                    </tr>
                </ItemTemplate>

                <EmptyDataTemplate>
                    <table runat="server" style="border: 1px solid #C0C0C0; color: #000080; width: 80%; margin-top: 15px;">
                        <tr>
                            <td>Factura sin pagos registrados.</td>
                        </tr>
                    </table>
                </EmptyDataTemplate>

            </asp:ListView>
        </fieldset>

    </div>
    
    <asp:SqlDataSource ID="Factura_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        
        SelectCommand="SELECT tTempWebReport_ConsultaFacturas.NombreCompania, tTempWebReport_ConsultaFacturas.NumeroFactura, 
                       tTempWebReport_ConsultaFacturas.NumeroControl, tTempWebReport_ConsultaFacturas.FechaEmision, 
                       tTempWebReport_ConsultaFacturas.NombreCxCCxPFlag, tTempWebReport_ConsultaFacturas.FechaRecepcion, 
                       tTempWebReport_ConsultaFacturas.NombreTipo, tTempWebReport_ConsultaFacturas.NcNdFlag, 
                       tTempWebReport_ConsultaFacturas.NumeroComprobante, tTempWebReport_ConsultaFacturas.NumeroOperacion, 
                       tTempWebReport_ConsultaFacturas.Concepto, tTempWebReport_ConsultaFacturas.MontoFacturaSinIva, 
                       tTempWebReport_ConsultaFacturas.MontoFacturaConIva, tTempWebReport_ConsultaFacturas.IvaPorc, 
                       tTempWebReport_ConsultaFacturas.Iva, tTempWebReport_ConsultaFacturas.TotalFactura, 
                       tTempWebReport_ConsultaFacturas.MontoSujetoARetencion, tTempWebReport_ConsultaFacturas.ImpuestoRetenidoPorc, 
                       tTempWebReport_ConsultaFacturas.ImpuestoRetenidoISLRAntesSustraendo, tTempWebReport_ConsultaFacturas.ImpuestoRetenidoISLRSustraendo, 
                       tTempWebReport_ConsultaFacturas.ImpuestoRetenido, tTempWebReport_ConsultaFacturas.FRecepcionRetencionISLR, 
                       tTempWebReport_ConsultaFacturas.RetencionSobreIvaPorc, tTempWebReport_ConsultaFacturas.RetencionSobreIva, 
                       tTempWebReport_ConsultaFacturas.FRecepcionRetencionIVA, tTempWebReport_ConsultaFacturas.TotalAPagar, 
                       tTempWebReport_ConsultaFacturas.Anticipo, tTempWebReport_ConsultaFacturas.Saldo, tTempWebReport_ConsultaFacturas.NombreEstado, 
                       tTempWebReport_ConsultaFacturas.CondicionesDePago, FormasDePago.Descripcion AS NombreFormaPago 
                       FROM tTempWebReport_ConsultaFacturas LEFT OUTER JOIN FormasDePago ON 
                       tTempWebReport_ConsultaFacturas.CondicionesDePago = FormasDePago.FormaDePago 
                       WHERE (tTempWebReport_ConsultaFacturas.NombreUsuario = @NombreUsuario) AND 
                       (tTempWebReport_ConsultaFacturas.ClaveUnicaFactura = @ClaveUnicaFactura)">
        <SelectParameters>
            <asp:Parameter Name="NombreUsuario" />
            <asp:Parameter Name="ClaveUnicaFactura" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="Pagos_SqlDataSource" 
                       runat="server" 
                       ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
                       SelectCommand="SELECT Pagos.ClaveUnica As ClaveUnicaPago, 
                                     Case When Pagos.NumeroPago Is Null Then 'Sin número' Else Pagos.NumeroPago End As NumeroPago , 
                                     Pagos.Fecha As FechaPago, dPagos.MontoPagado, 
                                     MovimientosBancarios.ClaveUnica As ClaveUnicaMovimientoBancario, MovimientosBancarios.Transaccion, 
                                     MovimientosBancarios.Tipo AS TipoMovBanco, MovimientosBancarios.Fecha AS FechaMovBanco, 
                                     MovimientosBancarios.Monto AS MontoMovBanco, CuentasBancarias.CuentaBancaria, Monedas.Simbolo AS SimboloMoneda, 
                                     Bancos.NombreCorto AS NombreBanco 
                                     FROM 
                                     dPagos
                                     Inner Join Pagos On dPagos.ClaveUnicaPago = Pagos.ClaveUnica 
                                     Left Outer Join MovimientosBancarios On Pagos.ClaveUnica = MovimientosBancarios.PagoID
                                     Left Outer Join Chequeras On MovimientosBancarios.ClaveUnicaChequera = Chequeras.NumeroChequera 
                                     Left Outer Join  CuentasBancarias On Chequeras.NumeroCuenta = CuentasBancarias.CuentaInterna
                                     Left Outer Join Agencias On CuentasBancarias.Agencia = Agencias.Agencia 
                                     Left Outer Join Bancos ON Agencias.Banco = Bancos.Banco
                                     Left Outer Join Monedas On CuentasBancarias.Moneda = Monedas.Moneda
                                     Inner Join CuotasFactura On dPagos.ClaveUnicaCuotaFactura = CuotasFactura.ClaveUnica
                                     Where CuotasFactura.ClaveUnicaFactura = @ClaveUnicaFactura">
        <SelectParameters>
            <asp:Parameter Name="ClaveUnicaFactura" />
        </SelectParameters>
    </asp:SqlDataSource>
    
</asp:Content>

