<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_1.master" AutoEventWireup="true" Inherits="Bancos_VencimientoFacturas_VencimientoFacturas" Codebehind="VencimientoFacturas.aspx.cs" %>
<%@ MasterType  virtualPath="~/MasterPage_1.master"%>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" Runat="Server">
    <script type="text/javascript" src="<%= this.Page.ResolveUrl("~/Scripts/jquery/jquery-1.10.2.js") %>"></script>
    <script type="text/javascript">
        function PopupWin(url, w, h) {
            ///Parameters url=page to open, w=width, h=height
            var left = parseInt((screen.availWidth / 2) - (w / 2));
            var top = parseInt((screen.availHeight / 2) - (h / 2));
            window.open(url, "external", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,left=" + left + ",top=" + top + "screenX=" + left + ",screenY=" + top);
        }
        //function RefreshPage() {
        //    window.document.getElementById("RebindFlagSpan").firstChild.value = "1";
        //    window.document.forms(0).submit();
        //}
        function RefreshPage() {
            // nótese como usamos jquery para asignar el valor al field ... 
            $("#RebindFlagHiddenField").val("1");
            $("form").submit();
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
        <i class="fa fa-filter"></i>
        <a href="javascript:PopupWin('VencimientoFacturas_Filter.aspx', 1000, 680)">Definir
            y aplicar un filtro</a>
        <hr />
       
        <i class="fa fa-print"></i>
        <asp:HyperLink ID="VencimientoFacturas_Reporte_HyperLink" runat="server" CssClass="generalfont"
            NavigateUrl="~/ReportViewer.aspx?rpt=vencimientofacturas" Target="_blank">Análisis de antiguedad de facturas pendientes</asp:HyperLink>
        <hr />
        <i class="fa fa-desktop"></i>
        <a href="javascript:PopupWin('DefinicionPeriodosVencimiento.aspx', 1000, 680)">
            Definición de períodos de vencimiento</a>
        <br />
        <br />
    </div>
    
    <div style="text-align: left; float: right; width: 88%;">
        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
            style="display: block;"></span>
            
         <span class="generalfont">Compañías seleccionadas:&nbsp;
            <asp:DropDownList ID="CompaniasSeleccionadas_DropDownList" runat="server" DataSourceID="CiasContabSeleccionadas_SqlDataSource"
                DataTextField="NombreCiaContab" DataValueField="CiaContab" CssClass="generalfont"
                AutoPostBack="True" 
            onselectedindexchanged="CompaniasSeleccionadas_DropDownList_SelectedIndexChanged" />
            &nbsp;&nbsp;&nbsp; Monedas seleccionadas:&nbsp;
            <asp:DropDownList ID="MonedasSeleccionadas_DropDownList" runat="server" DataSourceID="MonedasSeleccionadas_SqlDataSource"
                DataTextField="NombreMoneda" DataValueField="Moneda" 
            CssClass="generalfont" AutoPostBack="True" 
            onselectedindexchanged="MonedasSeleccionadas_DropDownList_SelectedIndexChanged" />
                
            &nbsp;&nbsp;&nbsp; Tipo:&nbsp;
            <asp:DropDownList ID="CxCCxPFlag_DropDownList" runat="server" DataSourceID="CxCCxPFlag_SqlDataSource"
                DataTextField="CxCCxPFlag_Descripcion" DataValueField="CxCCxPFlag" 
            CssClass="generalfont" AutoPostBack="True" 
            onselectedindexchanged="CxCCxPFlag_DropDownList_SelectedIndexChanged" />
            <br />
             <asp:Label ID="TipoConsulta_Label" runat="server" Text=""></asp:Label>
             
        </span>
            
        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
            
                <asp:ListView ID="ListView1" runat="server" 
                    DataSourceID="VencimientoSaldosFacturas_SqlDataSource">
                    <LayoutTemplate>
                        <table runat="server">
                            <tr runat="server">
                                <td runat="server">
                                     <table ID="itemPlaceholderContainer" 
                                            runat="server" 
                                            border="0" 
                                            style="border: 1px solid #E6E6E6" 
                                            class="smallfont" cellspacing="0" 
                                            rules="none">
                                        <tr id="Tr1" runat="server" style="" class="ListViewHeader_Suave">
                                            <th runat="server" class="padded" style="text-align: left; padding-bottom: 10px;">
                                                Compañía</th>
                                            <th runat="server" class="padded" style="text-align: left; padding-bottom: 10px;">
                                                Factura</th>
                                            <th runat="server" class="padded" style="text-align: center; padding-bottom: 10px; white-space:nowrap; ">
                                                F rec</th>
                                            <th runat="server" class="padded" style="text-align: center; padding-bottom: 10px; white-space:nowrap; ">
                                                F venc</th>
                                            <th runat="server" class="padded" style="text-align: center; padding-bottom: 10px; white-space:nowrap; ">
                                                Días<br />venc</th>




                                            <th id="Th1" runat="server" class="padded" style="text-align: right; padding-bottom: 10px;">
                                                Monto</th>
                                            <th id="Th2" runat="server" class="padded" style="text-align: right; padding-bottom: 10px;">
                                                Iva</th>
                                            <th id="Th3" runat="server" class="padded" style="text-align: right; padding-bottom: 10px;">
                                                Total</th>
                                            <th id="Th4" runat="server" class="padded" style="text-align: right; padding-bottom: 10px;">
                                                Retención<br />ISLR</th>
                                            <th id="Th5" runat="server" class="padded" style="text-align: center; padding-bottom: 10px; white-space:nowrap; ">
                                                Recibida</th>
                                            <th id="Th6" runat="server" class="padded" style="text-align: right; padding-bottom: 10px;">
                                                Retención<br />Iva</th>
                                            <th id="Th7" runat="server" class="padded" style="text-align: right; padding-bottom: 10px;">
                                                Recibida</th>




                                            <th runat="server" class="padded" style="text-align: right; padding-bottom: 10px;">
                                                Total</th>
                                            <th runat="server" class="padded" style="text-align: right; padding-bottom: 10px;">
                                                Anticipo</th>
                                            <th runat="server" class="padded" style="text-align: right; padding-bottom: 10px;">
                                                Total</th>
                                            <th runat="server" class="padded" style="text-align: right; padding-bottom: 10px;">
                                                Monto<br />pagado</th>
                                            <th runat="server" class="padded" style="text-align: center; padding-bottom: 10px; white-space:nowrap; ">
                                                Días por<br /> vencer</th>
                                            <th runat="server" class="padded" style="text-align: right; padding-bottom: 10px;">
                                                Saldo</th>
                                        </tr>
                                        <tr ID="itemPlaceholder" runat="server">
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr runat="server">
                                <td runat="server" style="">
                                    <asp:DataPager ID="DataPager1" runat="server" PageSize="20">
                                       <Fields>
                                            <asp:NextPreviousPagerField ButtonType="Image"
                                                FirstPageText="&lt;&lt;" NextPageText="&gt;" PreviousPageImageUrl="~/Pictures/ListView_Buttons/PgPrev.gif"
                                                PreviousPageText="&lt;" ShowFirstPageButton="True" ShowNextPageButton="False"
                                                ShowPreviousPageButton="True" FirstPageImageUrl="~/Pictures/ListView_Buttons/PgFirst.gif" />
                                            <asp:NumericPagerField />
                                            <asp:NextPreviousPagerField ButtonType="Image" LastPageImageUrl="~/Pictures/ListView_Buttons/PgLast.gif"
                                                LastPageText="&gt;&gt;" NextPageImageUrl="~/Pictures/ListView_Buttons/PgNext.gif" NextPageText="&gt;"
                                                PreviousPageText="&lt;" ShowLastPageButton="True" ShowNextPageButton="True" ShowPreviousPageButton="False" />
                                        </Fields>
                                    </asp:DataPager>
                                </td>
                            </tr>
                        </table>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <tr style="">
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NombreCompaniaLabel" runat="server" 
                                    Text='<%# Eval("NombreCompaniaAbreviatura") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NumeroFacturaLabel" runat="server" 
                                    Text='<%# Eval("NumeroFactura").ToString() + "/" + Eval("NumeroCuota").ToString() %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space:nowrap; ">
                                <asp:Label ID="FechaRecepcionLabel" runat="server" 
                                    Text='<%# Eval("FechaRecepcion", "{0:d-MMM-y}") %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space:nowrap; ">
                                <asp:Label ID="FechaVencimientoLabel" runat="server" 
                                    Text='<%# Eval("FechaVencimiento", "{0:d-MMM-y}") %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space:nowrap; ">
                                <asp:Label ID="DiasVencimientoLabel" runat="server" 
                                    Text='<%# Eval("DiasVencimiento") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="TotalCuotaLabel" runat="server" 
                                    Text='<%# Eval("MontoCuota", "{0:N2}") %>' />
                            </td>

                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label1" runat="server" 
                                    Text='<%# Eval("Iva") == null ? "" : Eval("Iva", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label2" runat="server" 
                                    Text='<%# Eval("MontoCuotaDespuesIva", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label3" runat="server" 
                                    Text='<%# Eval("RetencionSobreISLR", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: Center;">
                                <asp:CheckBox ID="Label4" runat="server" 
                                    Checked='<%#Eval("RetencionSobreISLRAplica") == DBNull.Value ? false : Convert.ToBoolean(Eval("RetencionSobreISLRAplica")) %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label5" runat="server" 
                                    Text='<%# Eval("RetencionSobreIva", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: Center;">
                                <asp:CheckBox ID="CheckBox1" runat="server" 
                                    Checked='<%#Eval("RetencionSobreIvaAplica") == DBNull.Value ? false : Convert.ToBoolean(Eval("RetencionSobreIvaAplica")) %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label7" runat="server" 
                                    Text='<%# Eval("TotalAntesAnticipo", "{0:N2}") %>' />
                            </td>

                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                <asp:Label ID="AnticipoLabel" runat="server" Text='<%# Eval("Anticipo", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                <asp:Label ID="TotalAPagarLabel" runat="server" 
                                    Text='<%# Eval("Total", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                <asp:Label ID="MontoYaPagadoLabel" runat="server" 
                                    Text='<%# Eval("MontoPagado", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space:nowrap; ">
                                <asp:Label ID="DiasPorVencerOVencidosLabel" runat="server" 
                                    Text='<%# Eval("DiasPorVencerOVencidos") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                <asp:Label ID="SaldoPendienteLabel" runat="server" 
                                    Text='<%# Eval("SaldoPendiente", "{0:N4}") %>' />
                            </td>
                        </tr>
                    </ItemTemplate>

                    <AlternatingItemTemplate>
                        <tr style="" class="ListViewAlternatingRow">
                           <td class="padded" style="text-align: left;">
                                <asp:Label ID="NombreCompaniaLabel" runat="server" 
                                    Text='<%# Eval("NombreCompaniaAbreviatura") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NumeroFacturaLabel" runat="server" 
                                    Text='<%# Eval("NumeroFactura").ToString() + "/" + Eval("NumeroCuota").ToString() %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space:nowrap; ">
                                <asp:Label ID="FechaRecepcionLabel" runat="server" 
                                    Text='<%# Eval("FechaRecepcion", "{0:d-MMM-y}") %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space:nowrap; ">
                                <asp:Label ID="FechaVencimientoLabel" runat="server" 
                                    Text='<%# Eval("FechaVencimiento", "{0:d-MMM-y}") %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space:nowrap; ">
                                <asp:Label ID="DiasVencimientoLabel" runat="server" 
                                    Text='<%# Eval("DiasVencimiento") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="TotalCuotaLabel" runat="server" 
                                    Text='<%# Eval("MontoCuota", "{0:N2}") %>' />
                            </td>

                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label1" runat="server" 
                                    Text='<%# Eval("Iva") == null ? "" : Eval("Iva", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label2" runat="server" 
                                    Text='<%# Eval("MontoCuotaDespuesIva", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label3" runat="server" 
                                    Text='<%# Eval("RetencionSobreISLR", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: Center;">
                                <asp:CheckBox ID="Label4" runat="server" 
                                    Checked='<%#Eval("RetencionSobreISLRAplica") == DBNull.Value ? false : Convert.ToBoolean(Eval("RetencionSobreISLRAplica")) %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label5" runat="server" 
                                    Text='<%# Eval("RetencionSobreIva", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: Center;">
                                <asp:CheckBox ID="CheckBox1" runat="server" 
                                    Checked='<%#Eval("RetencionSobreIvaAplica") == DBNull.Value ? false : Convert.ToBoolean(Eval("RetencionSobreIvaAplica")) %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="Label7" runat="server" 
                                    Text='<%# Eval("TotalAntesAnticipo", "{0:N2}") %>' />
                            </td>

                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                <asp:Label ID="AnticipoLabel" runat="server" Text='<%# Eval("Anticipo", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                <asp:Label ID="TotalAPagarLabel" runat="server" 
                                    Text='<%# Eval("Total", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                <asp:Label ID="MontoYaPagadoLabel" runat="server" 
                                    Text='<%# Eval("MontoPagado", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space:nowrap; ">
                                <asp:Label ID="DiasPorVencerOVencidosLabel" runat="server" 
                                    Text='<%# Eval("DiasPorVencerOVencidos") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space:nowrap; ">
                                <asp:Label ID="SaldoPendienteLabel" runat="server" 
                                    Text='<%# Eval("SaldoPendiente", "{0:N4}") %>' />
                            </td>
                        </tr>
                    </AlternatingItemTemplate>

                    <EmptyDataTemplate>
                        <table runat="server" style="">
                            <tr>
                                <td style="color: #0000FF">Aplique un filtro para seleccionar información.</td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                </asp:ListView>
            
            </ContentTemplate>
            <Triggers>
            <asp:AsyncPostBackTrigger ControlID="CompaniasSeleccionadas_DropDownList" EventName="TextChanged"/>
             <asp:AsyncPostBackTrigger ControlID="MonedasSeleccionadas_DropDownList" EventName="TextChanged" />
             <asp:AsyncPostBackTrigger ControlID="CxCCxPFlag_DropDownList" EventName="TextChanged" />
            </Triggers>
        </asp:UpdatePanel>
        
        <asp:SqlDataSource ID="CiasContabSeleccionadas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT DISTINCT CiaContab, NombreCiaContab FROM Bancos_VencimientoFacturas WHERE (NombreUsuario = @NombreUsuario) ORDER BY NombreCiaContab">
            <SelectParameters>
                <asp:Parameter Name="NombreUsuario" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
        
        <asp:SqlDataSource ID="MonedasSeleccionadas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT DISTINCT Moneda, NombreMoneda FROM Bancos_VencimientoFacturas WHERE (NombreUsuario = @NombreUsuario) ORDER BY NombreMoneda">
            <SelectParameters>
                <asp:Parameter Name="NombreUsuario" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
        
        <asp:SqlDataSource ID="CxCCxPFlag_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT DISTINCT CxCCxPFlag, CxCCxPFlag_Descripcion FROM Bancos_VencimientoFacturas WHERE (NombreUsuario = @NombreUsuario) ORDER BY CxCCxPFlag_Descripcion">
            <SelectParameters>
                <asp:Parameter Name="NombreUsuario" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>

         <asp:SqlDataSource ID="VencimientoSaldosFacturas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT * FROM Bancos_VencimientoFacturas  Where NombreUsuario = @NombreUsuario And CiaContab = @CiaContab And Moneda = @Moneda And CxCCxPFlag = @CxCCxPFlag">
            <SelectParameters>
                <asp:Parameter Name="NombreUsuario" Type="String" DefaultValue="xyz" />
                <asp:Parameter DefaultValue="-999" Name="CiaContab" Type="Int32" />
                <asp:Parameter DefaultValue="-999" Name="Moneda" Type="Int32" />
                <asp:Parameter DefaultValue="-1" Name="CxCCxPFlag" Type="Int16" />
            </SelectParameters>
        </asp:SqlDataSource>
        
       <%-- <asp:LinqDataSource ID="VencimientoSaldosFacturas_LinqDataSource" 
            runat="server" ContextTypeName="ContabSysNetWeb.Old_App_Code.ContabSysNet_TempDBDataContext" 
            OrderBy="FechaRecepcion" 
            Select="new (NombreCompania, NumeroFactura, NumeroCuota, FechaRecepcion, FechaVencimiento, DiasVencimiento, TotalCuota, Anticipo, TotalAPagar, MontoYaPagado, DiasPorVencerOVencidos, SaldoPendiente, SaldoPendiente_0, SaldoPendiente_1, SaldoPendiente_2, SaldoPendiente_3, SaldoPendiente_4)" 
            TableName="Bancos_VencimientoFacturas" 
            Where="NombreUsuario == @NombreUsuario &amp;&amp; CiaContab == @CiaContab &amp;&amp; Moneda == @Moneda &amp;&amp; CxCCxPFlag == @CxCCxPFlag">
            <WhereParameters>
                <asp:Parameter Name="NombreUsuario" Type="String" DefaultValue="xyz" />
                <asp:Parameter DefaultValue="-999" Name="CiaContab" Type="Int32" />
                <asp:Parameter DefaultValue="-999" Name="Moneda" Type="Int32" />
                <asp:Parameter DefaultValue="-1" Name="CxCCxPFlag" Type="Int16" />
            </WhereParameters>
        </asp:LinqDataSource>--%>
        
    </div>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
    <br />
</asp:Content>

