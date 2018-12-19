<%@ Page Language="C#" MasterPageFile="~/MasterPage_1.master" AutoEventWireup="true" Inherits="Bancos_Facturas_Facturas" Title="Untitled Page" Codebehind="Facturas.aspx.cs" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" Runat="Server">

   <script type="text/javascript">
       function PopupWin(url, w, h) {
           ///Parameters url=page to open, w=width, h=height
           var left = parseInt((screen.availWidth / 2) - (w / 2));
           var top = parseInt((screen.availHeight / 2) - (h / 2));
           window.open(url, "external", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,left=" + left + ",top=" + top + "screenX=" + left + ",screenY=" + top);
       }
        function RefreshPage() {
            // nótese como usamos jquery para asignar el valor al field ... 
            $("#RebindFlagHiddenField").val("1");
            $("form").submit();
        }
    </script>

    <script runat="server">
        protected String GetApplicationName()
        {
            return HttpContext.Current.Request.ApplicationPath.ToString();
        }

        protected String GetFacturasExportarExcel_UriAddress()
        {
            // este es la dirección que espera mvc; notamos que debemos agregar el nombre de la aplicación (ej: ContabSysNet46) cuando no estamos en 
            // ambiente de desarrollo; es decir, cuando ejecutamos desde iis ... 
            string pagePath = GetApplicationName() + "/Bancos/FacturasConsultasExportarExcel/Index";
            pagePath = pagePath.Replace("//", "/");

            return pagePath;
        }
    </script>

    <%--  para refrescar la página cuando el popup se cierra (y saber que el refresh es por eso) --%>
    <span id="RebindFlagSpan">
        <%-- clientIdMode 'static' para que el id permanezca hasta el cliente (browser) --%>
        <asp:HiddenField ID="RebindFlagHiddenField" runat="server" Value="0" ClientIDMode="Static" />
    </span>
    <%--  --%>
    <%-- div en la izquierda para mostrar funciones de la página --%>
    <%--  --%>
    <div class="notsosmallfont" style="width: 10%; border: 1px solid #C0C0C0; vertical-align: top;
        background-color: #F7F7F7; float: left; text-align: center; ">
        <br />
        <br />

         <a runat="server" 
            href="javascript:PopupWin('Facturas_Filter.aspx', 1000, 600)">
                <img id="Img4" 
                        border="0" 
                        runat="server"
                        alt="Para definir y aplicar un filtro que regrese los registros que se desea consultar" 
                        src="~/Pictures/filter_25x25.png" />
                </a>
                <br />
                <a href="javascript:PopupWin('Facturas_Filter.aspx', 1000, 600)">Definir y aplicar<br /> un filtro</a>

                <hr />

                <a runat="server" 
                   id="reportLink"
                   href="javascript:PopupWin('Facturas_OpcionesReportes.aspx', 1000, 600)">
                        <img id="Img5" 
                             runat="server"
                             border="0" 
                             alt="Para obtener diferentes reporte que muestran los registros seleccionados" 
                             src="~/Pictures/print_25x25.png" />
                </a>
                <br />
                <a href="javascript:PopupWin('Facturas_OpcionesReportes.aspx', 1000, 600)">Reportes</a>

                <hr />

                <a runat="server" 
                   id="mailMergeLink"
                   href="javascript:PopupWin('Facturas_MailMergeFile.aspx', 1000, 600)">
                        <img id="Img1" 
                             runat="server"
                             border="0" 
                             alt="Para exportar los datos seleccionados a un archivo (txt) que permita efectuar una combinación con Microsoft Word" 
                             src="~/Pictures/MailMerge_25x25.png" />
                </a>
                <br />
                <a href="javascript:PopupWin('Facturas_MailMergeFile.aspx', 1000, 600)">Exportar a<br />Word</a>

                <hr />

                <a href="javascript:PopupWin('<% = GetFacturasExportarExcel_UriAddress() %>', 1000, 600)">
                    <img id="Img3"
                        runat="server"
                        border="0"
                        alt="Para obtener documentos Excel, usando las facturas que se han seleccionado"
                        src="~/Pictures/Excel_25x25.png" />
                </a>
                <br />
                <a href="javascript:PopupWin('<% = GetFacturasExportarExcel_UriAddress() %>', 1000, 600)">Exportar a<br />Excel</a>

                <hr />

                <a runat="server" 
                   id="A1"
                   href="javascript:PopupWin('Facturas_ObtencionXMLFileISLRRetenido.aspx', 1000, 600)">
                        <img id="Img2" 
                             runat="server"
                             border="0" 
                             alt="Para exportar los datos seleccionados a un archivo de texto" 
                             src="~/Pictures/Disk.png" />
                </a>
                <br />
                <a href="javascript:PopupWin('Facturas_ObtencionXMLFileISLRRetenido.aspx', 1200, 700)">Exportar a<br />archivos de texto</a>

                <hr />

        <br />
    </div>
    
    <div style="text-align: left; float: right; width: 88%;">
        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
            style="display: block;">
        </span>
        <div style="margin-bottom:5px; ">
            &nbsp;&nbsp; <span class="notsosmallfont">Compañías Contab:&nbsp;&nbsp;</span>
            <asp:DropDownList ID="CiasContab_DropDownList" runat="server" DataSourceID="CiasContab_SqlDataSource"
                DataTextField="NombreCorto" DataValueField="CiaContab" Font-Names="Tahoma" Font-Size="8pt"
                OnSelectedIndexChanged="CiasContab_DropDownList_SelectedIndexChanged" AutoPostBack="True">
            </asp:DropDownList>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span class="notsosmallfont">Monedas:&nbsp;&nbsp;</span>
            <asp:DropDownList ID="Monedas_DropDownList" runat="server" DataSourceID="Monedas_SqlDataSource"
                DataTextField="Descripcion" DataValueField="Moneda" Font-Names="Tahoma" Font-Size="8pt"
                OnSelectedIndexChanged="Monedas_DropDownList_SelectedIndexChanged" AutoPostBack="True">
            </asp:DropDownList>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span class="notsosmallfont">CxC / CxP:&nbsp;&nbsp;</span>
            <asp:DropDownList ID="CxCCxP_DropDownList" runat="server" DataSourceID="CxCCxP_SqlDataSource"
                DataTextField="NombreCxCCxpFlag" DataValueField="CxCCxPFlag" Font-Names="Tahoma"
                Font-Size="8pt" OnSelectedIndexChanged="CxCCxP_DropDownList_SelectedIndexChanged"
                AutoPostBack="True">
            </asp:DropDownList>
        </div>
       
         <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
               
                <asp:ListView ID="Facturas_ListView" runat="server" DataSourceID="ConsultaFacturas_LinqDataSource">
                    <LayoutTemplate>
                        <table id="Table1" runat="server">
                            <tr id="Tr1" runat="server">
                                <td id="Td1" runat="server">
                                    <table id="itemPlaceholderContainer" runat="server" border="0" style="border: 1px solid #E6E6E6"
                                        class="smallfont" cellspacing="0" rules="none">
                                        <tr id="Tr2" runat="server" style="" class="ListViewHeader_Suave">
                                            <th id="Th1" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Numero<br />factura
                                            </th>
                                             <th runat="server" class="padded" style="text-align: center; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                 Fecha<br />recepción
                                            </th>
                                            <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px; padding-top: 8px;">
                                                Concepto
                                            </th>
                                            <th id="Th3" runat="server" class="padded" style="text-align: right; white-space: nowrap;
                                                padding-bottom: 8px; padding-top: 8px;">
                                                Monto<br />(Imp+NoImp)
                                            </th>
                                            <th id="Th4" runat="server" class="padded" style="text-align: right; white-space: nowrap;
                                                padding-bottom: 8px; padding-top: 8px;">
                                                Iva
                                            </th>
                                            <th id="Th13" runat="server" class="padded" style="text-align: right; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Impuestos<br />(varios)
                                            </th>
                                            <th id="Th5" runat="server" class="padded" style="text-align: right; white-space: nowrap;
                                                padding-bottom: 8px; padding-top: 8px;">
                                                Total<br />factura
                                            </th>
                                            <th id="Th2" runat="server" class="padded" style="text-align: right; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Retención<br />Islr
                                            </th>
                                             <th id="Th7" runat="server" class="padded" style="text-align: right; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Retención<br />Iva
                                            </th>
                                            <th id="Th12" runat="server" class="padded" style="text-align: right; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Retenciones<br />(varias)
                                            </th>
                                            <th id="Th6" runat="server" class="padded" style="text-align: right; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Anticipo
                                            </th>
                                            <th id="Th14" runat="server" class="padded" style="text-align: right; white-space: nowrap;
                                                padding-bottom: 8px; padding-top: 8px;">
                                                Total a<br />pagar
                                            </th>
                                            <th id="Th8" runat="server" class="padded" style="text-align: right; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Saldo
                                            </th>
                                            <th id="Th9" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Estado
                                            </th>
                                            <th id="Th10" runat="server" class="padded" style="text-align: center; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Caja<br />Chica
                                            </th>
                                        </tr>
                                        <tr id="itemPlaceholder" runat="server" />
                                    </table>
                                </td>
                            </tr>
                            <tr id="Tr3" runat="server">
                                <td id="Td2" runat="server" style="">
                                    <asp:DataPager ID="ConsultaFacturas_DataPager" runat="server">
                                        <Fields>
                                            <asp:NextPreviousPagerField ButtonType="Image" FirstPageText="&lt;&lt;" NextPageText="&gt;"
                                                PreviousPageImageUrl="~/Pictures/ListView_Buttons/PgPrev.gif" PreviousPageText="&lt;"
                                                ShowFirstPageButton="True" ShowNextPageButton="False" ShowPreviousPageButton="True"
                                                FirstPageImageUrl="~/Pictures/ListView_Buttons/PgFirst.gif" />
                                            <asp:NumericPagerField />
                                            <asp:NextPreviousPagerField ButtonType="Image" LastPageImageUrl="~/Pictures/ListView_Buttons/PgLast.gif"
                                                LastPageText="&gt;&gt;" NextPageImageUrl="~/Pictures/ListView_Buttons/PgNext.gif"
                                                NextPageText="&gt;" PreviousPageText="&lt;" ShowLastPageButton="True" ShowNextPageButton="True"
                                                ShowPreviousPageButton="False" />
                                        </Fields>
                                    </asp:DataPager>
                                </td>
                            </tr>
                        </table>
                    </LayoutTemplate>

                    <EmptyDataTemplate>
                        <table id="Table2" runat="server" style="">
                            <tr>
                                <td>
                                    Aplique un filtro para seleccionar información.
                                </td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                    
                    
                    <ItemTemplate>
                        
                        <tr style="">
                            <td class="padded" colspan="9" 
                                style="text-align: left; font-weight: bold; color: #005EBB;">
                                <%# Eval("Key.NombreCompania") %> &nbsp;&nbsp;-&nbsp;&nbsp;<%# Eval("Key.NombreTipo") %> &nbsp;&nbsp;(
                                <%# Eval("Count") %> )
                            </td>
                        </tr>
                        <tr>
                            <asp:ListView ID="Facturas_ListView2" runat="server" DataSource='<%# Eval("Facturas") %>'>
                                <LayoutTemplate>
                                    <tr ID="itemPlaceholder" runat="server" />
                                    </LayoutTemplate>
                                    <ItemTemplate>
                                        <tr style="">
                                            <td class="padded" style="text-align: left;">
                                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Fix_URL(Eval("ClaveUnicaFactura").ToString()) %>'><%# Eval("NumeroFactura") %></asp:HyperLink>
                                            </td>
                                            <td class="padded" style="text-align: center; white-space: nowrap; ">
                                                <asp:Label ID="FechaRecepcionLabel" runat="server" Text='<%# Eval("FechaRecepcion", "{0:d-MMM-y}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: left;">
                                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("Concepto") %>' />
                                            </td>

                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="TotalFacturaLabel" runat="server" Text='<%# Eval("MontoTotalFactura", "{0:N2}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: right;">
                                                <asp:Label ID="IvaLabel" runat="server" Text='<%# Eval("Iva", "{0:N2}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("ImpuestosVarios", "{0:N2}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="TotalAPagarLabel" runat="server" Text='<%# Eval("TotalFactura", "{0:N2}") %>' />
                                            </td>

                                             <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("ImpuestoRetenido", "{0:N2}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("RetencionSobreIva", "{0:N2}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="Label6" runat="server" Text='<%# Eval("RetencionesVarias", "{0:N2}") %>' />
                                            </td>

                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="AnticipoLabel" runat="server" Text='<%# Eval("Anticipo", "{0:N2}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="SaldoLabel" runat="server" Text='<%# Eval("TotalAPagar", "{0:N2}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="Label7" runat="server" Text='<%# Eval("Saldo", "{0:N2}") %>' />
                                            </td>

                                            <td class="padded" style="text-align: left;">
                                                <asp:Label ID="NombreEstadoLabel" runat="server" Text='<%# Eval("NombreEstado") %>' />
                                            </td>
                                            <td class="padded" style="text-align: center; white-space:nowrap; ">
                                                <asp:Label ID="Label4" runat="server" Text='<%# FacturaCajaChica((int)Eval("Tipo"), Eval("NombreTipo").ToString()) %>' />
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    
                                    <AlternatingItemTemplate>
                                        <tr class="ListViewAlternatingRow" style="">
                                            <td class="padded" style="text-align: left;">
                                                <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl='<%# Fix_URL(Eval("ClaveUnicaFactura").ToString()) %>'><%# Eval("NumeroFactura") %></asp:HyperLink>
                                            </td>
                                            <td class="padded" style="text-align: center; white-space: nowrap; ">
                                                <asp:Label ID="FechaRecepcionLabel" runat="server" Text='<%# Eval("FechaRecepcion", "{0:d-MMM-y}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: left;">
                                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("Concepto") %>' />
                                            </td>

                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="TotalFacturaLabel" runat="server" Text='<%# Eval("MontoTotalFactura", "{0:N2}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: right;">
                                                <asp:Label ID="IvaLabel" runat="server" Text='<%# Eval("Iva", "{0:N2}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="Label5" runat="server" Text='<%# Eval("ImpuestosVarios", "{0:N2}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="TotalAPagarLabel" runat="server" Text='<%# Eval("TotalFactura", "{0:N2}") %>' />
                                            </td>

                                             <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("ImpuestoRetenido", "{0:N2}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("RetencionSobreIva", "{0:N2}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="Label6" runat="server" Text='<%# Eval("RetencionesVarias", "{0:N2}") %>' />
                                            </td>

                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="AnticipoLabel" runat="server" Text='<%# Eval("Anticipo", "{0:N2}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="SaldoLabel" runat="server" Text='<%# Eval("TotalAPagar", "{0:N2}") %>' />
                                            </td>
                                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                                <asp:Label ID="Label7" runat="server" Text='<%# Eval("Saldo", "{0:N2}") %>' />
                                            </td>

                                            <td class="padded" style="text-align: left;">
                                                <asp:Label ID="NombreEstadoLabel" runat="server" Text='<%# Eval("NombreEstado") %>' />
                                            </td>
                                            <td class="padded" style="text-align: center; white-space:nowrap; ">
                                                <asp:Label ID="Label4" runat="server" Text='<%# FacturaCajaChica((int)Eval("Tipo"), Eval("NombreTipo").ToString()) %>' />
                                            </td>
                                        </tr>
                                    </AlternatingItemTemplate>
                                    
                                    <EmptyDataTemplate>
                                        <table ID="Table2" runat="server" style="">
                                            <tr>
                                                <td>
                                                    ... sin información
                                                </td>
                                            </tr>
                                        </table>
                                    </EmptyDataTemplate>
                                </asp:ListView>
                        </tr>
                        
                    </ItemTemplate>

                    
                </asp:ListView>

            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="CiasContab_DropDownList" EventName="TextChanged" />
                <asp:AsyncPostBackTrigger ControlID="Monedas_DropDownList" EventName="TextChanged" />
                <asp:AsyncPostBackTrigger ControlID="CxCCxP_DropDownList" EventName="TextChanged" />
            </Triggers>
        </asp:UpdatePanel>
        
    </div>
    
    <div>
    
        <asp:SqlDataSource ID="CiasContab_SqlDataSource" runat="server" 
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
            SelectCommand="SELECT DISTINCT tTempWebReport_ConsultaFacturas.CiaContab, Companias.NombreCorto FROM tTempWebReport_ConsultaFacturas INNER JOIN Companias ON tTempWebReport_ConsultaFacturas.CiaContab = Companias.Numero Where NombreUsuario = @NombreUsuario ORDER BY Companias.NombreCorto">
            <SelectParameters>
                <asp:Parameter DefaultValue="xyz" Name="NombreUsuario" />
            </SelectParameters>
        </asp:SqlDataSource>
        
        <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" 
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
            SelectCommand="SELECT DISTINCT tTempWebReport_ConsultaFacturas.Moneda, Monedas.Descripcion FROM tTempWebReport_ConsultaFacturas INNER JOIN Monedas ON tTempWebReport_ConsultaFacturas.Moneda = Monedas.Moneda Where NombreUsuario = @NombreUsuario ORDER BY Monedas.Descripcion">
            <SelectParameters>
                 <asp:Parameter DefaultValue="xyz" Name="NombreUsuario" />
            </SelectParameters>
        </asp:SqlDataSource>
        
        <asp:SqlDataSource ID="CxCCxP_SqlDataSource" runat="server" 
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
            SelectCommand="SELECT DISTINCT CxCCxPFlag, CASE CxCCxPFlag WHEN 1 THEN 'CxP' WHEN 2 THEN 'CxC' END AS NombreCxCCxpFlag FROM tTempWebReport_ConsultaFacturas Where NombreUsuario = @NombreUsuario">
            <SelectParameters>
                <asp:Parameter DefaultValue="xyz" Name="NombreUsuario" />
            </SelectParameters>
        </asp:SqlDataSource>
        
        <asp:LinqDataSource ID="ConsultaFacturas_LinqDataSource" runat="server" 
            ContextTypeName="ContabSysNet_Web.old_app_code.dbBancosDataContext" 
            GroupBy="new (NombreCompania, NombreTipo)" 
            Select="new (Key, Count() As Count, it As Facturas)" 
            TableName="tTempWebReport_ConsultaFacturas" 
            
            Where="NombreUsuario == @NombreUsuario &amp;&amp; CiaContab == @CiaContab &amp;&amp; Moneda == @Moneda &amp;&amp; CxCCxPFlag == @CxCCxPFlag">
            <WhereParameters>
                <asp:Parameter Name="NombreUsuario" Type="String" DefaultValue="xyz" />
                <asp:Parameter DefaultValue="-99" Name="CiaContab" Type="Int32" />
                <asp:Parameter DefaultValue="-99" Name="Moneda" Type="Int32" />
                <asp:Parameter DefaultValue="-99" Name="CxCCxPFlag" Type="Int16" />
            </WhereParameters>
        </asp:LinqDataSource>
    
    </div>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
    <br />
</asp:Content>

