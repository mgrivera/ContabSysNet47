<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage_1.master" CodeBehind="Bancos_ConsultaDisponibilidad.aspx.cs" Inherits="ContabSysNetWeb.Bancos.Disponibilidad_en_bancos.Disponibilidad.Bancos_ConsultaDisponibilidad" %>

<%@ MasterType VirtualPath="~/MasterPage_1.master" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" runat="Server">

   <%-- <script type="text/javascript">
        function PopupWin(url, w, h) {
            ///Parameters url=page to open, w=width, h=height
            window.open(url, "external", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,top=10px,left=8px");
        }
        function RefreshPage() {
            window.document.getElementById("RebindFlagSpan").firstChild.value = "1";
            window.document.forms(0).submit();
        }
    </script>--%>
    <script src="<%= this.Page.ResolveUrl("~/Scripts/jquery/jquery-1.10.2.js") %>"></script>

    <script type="text/javascript">
        function PopupWin(url, w, h) {
            ///Parameters url=page to open, w=width, h=height
            window.open(url, "external2", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,top=10px,left=8px");
        }
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

    <table style="width: 100%" class="miniminheight">

        <tr>
            <%--   column en la izquierda con links   --%>
            <td style="border: 1px solid #C0C0C0; width: 10%; vertical-align: top; background-color: #F7F7F7; text-align: center;">
                <br />
                <img id="Filter_img" alt="Para definir y aplicar un filtro para seleccionar la información que desea consultar."
                    runat="server" src="~/Pictures/filter_16x16.gif" />
                <a href="javascript:PopupWin('Bancos_ConsultaDisponibilidad_Filter.aspx', 1000, 680)">Definir y aplicar un
                    filtro</a>
                <hr />
                <img id="Img4" runat="server" alt="Consulta de cierres de compañías" src="~/Pictures/application_16x16.gif" />
                <a href="javascript:PopupWin('../../CierresBancariosEfectuados.aspx', 1000, 680)">Fechas de
                    último cierre bancario</a>
                <hr />
                <img id="Img1" runat="server" alt="Consulta de montos restringidos y cheques no entregados" src="~/Pictures/application_16x16.gif" />
                <a href="javascript:PopupWin('MontosRestringidos_Consulta.aspx', 1000, 680)">Consulta de montos restringidos y cheques no entregados</a>
                <hr />
                <img id="Img2" alt="Reporte de disponibilidad" runat="server" src="~/Pictures/print_16x16.gif" />
                <asp:HyperLink ID="DisponibilidadReport_HyperLink" runat="server"
                    CssClass="generalfont" NavigateUrl="Bancos_ConsultaDisponibilidad_OpcionesReportes.aspx"
                    Target="_blank">Reporte de disponibilidad</asp:HyperLink>
                <hr />
                <img id="Img3" alt="Reporte de disponibilidad (resumido)" runat="server" src="~/Pictures/print_16x16.gif" />
                <asp:HyperLink ID="DisponibilidadResumenReport_HyperLink" runat="server"
                    CssClass="generalfont"
                    NavigateUrl="~/ReportViewer.aspx?rpt=disponibilidad_resumen" Target="_blank">Reporte de disponibilidad - resumido</asp:HyperLink>
            </td>
            <td style="vertical-align: top;">

                <cc1:UpdatePanelAnimationExtender ID="UpdatePanelAnimationExtender1" runat="server"
                    TargetControlID="UpdatePanel1" Enabled="True">
                    <Animations>
                        <OnUpdating>
                            <Parallel duration=".5">
                                <%-- fade-out the GridView --%>
                                <FadeOut minimumOpacity=".5" />
                            </Parallel>
                        </OnUpdating>
                        <OnUpdated>
                            <Parallel duration=".5">
                                <%-- fade back in the GridView --%>
                                <FadeIn minimumOpacity=".5" />
                            </Parallel>
                        </OnUpdated>
                    </Animations>
                </cc1:UpdatePanelAnimationExtender>

                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
                            style="display: block;"></span>
                        <cc1:TabContainer ID="ConsultaDisponibilidad_TabContainer" runat="server" ActiveTabIndex="0"
                            ScrollBars="Horizontal">
                            <cc1:TabPanel ID="TabPanel2" runat="server" HeaderText="Disponibilidad">
                                <ContentTemplate>
                                    <h5>Disponibilidad de cuentas bancarias al
                                        <asp:Label ID="FechaDisponibilidadAl_Label" runat="server"></asp:Label></h5>
                                    <asp:ListView ID="ConsultaDisponibilidad_ListView"
                                        runat="server"
                                        DataKeyNames="CuentaInterna,CiaContab"
                                        DataSourceID="SaldosCuentasBancarias_SqlDataSource"
                                        OnSelectedIndexChanged="ConsultaDisponibilidad_ListView_SelectedIndexChanged">
                                        <LayoutTemplate>
                                            <table id="Table1" runat="server">
                                                <tr id="Tr1" runat="server">
                                                    <td id="Td1" runat="server">
                                                        <table id="itemPlaceholderContainer" runat="server" border="0"
                                                            style="border: 1px solid #E6E6E6" class="notsosmallfont"
                                                            cellspacing="0" rules="none">
                                                            <tr id="Tr2" runat="server" class="ListViewHeader">
                                                                <th id="Th0" runat="server" class="padded"></th>
                                                                <th id="SaldoAnterior_ColumHeader" runat="server" class="right padded">Saldo<br />
                                                                    anterior
                                                                </th>
                                                                <th id="Th5" runat="server" class="right padded">Débitos
                                                                </th>
                                                                <th id="Th6" runat="server" class="right padded">Créditos
                                                                </th>
                                                                <th id="SaldoActual_ColumHeader" runat="server" class="right padded">Saldo<br />
                                                                    actual
                                                                </th>
                                                                <th id="Th1" runat="server" class="right padded">Restringido
                                                                </th>
                                                                <th id="Th8" runat="server" class="right padded">Saldo<br />
                                                                    actual
                                                                </th>
                                                                <th id="Th11" runat="server" class="right padded">Cheques no<br />
                                                                    entregados
                                                                </th>
                                                                <th id="Th12" runat="server" class="right padded">Saldo<br />
                                                                    actual
                                                                </th>
                                                            </tr>
                                                            <tr id="itemPlaceholder" runat="server">
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr id="Tr3" runat="server">
                                                    <td id="Td2" runat="server" style="text-align: center; background-color: #CCCCCC; font-family: Verdana, Arial, Helvetica, sans-serif; color: #000000;">
                                                        <asp:DataPager ID="ConsultaDisponibilidad_DataPager" runat="server">
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
                                        <ItemTemplate>
                                            <tr class="ListViewRow">
                                                <tr>
                                                    <td class="padded" rowspan="2">
                                                        <asp:ImageButton ID="SelectCategoryButton" runat="server" AlternateText="***" CommandName="Select"
                                                            ImageUrl="~/Pictures/arrow_right.png" ToolTip="Click para mostrar los movimientos de la cuenta" />
                                                    </td>
                                                    <td class="padded" colspan="8" style="color: #000080; font-weight: bold;">
                                                        <asp:Label ID="NombreCiaContab_Label" runat="server" Style="white-space: nowrap;"
                                                            Text='<%# Eval("NombreCiaContab") %>' />&nbsp;-&nbsp;
                                                            <asp:Label ID="NombreBanco_Label" runat="server" Style="white-space: nowrap;" Text='<%# Eval("NombreBanco") %>' />&nbsp;-&nbsp;
                                                            <asp:Label ID="CuentaBancaria_Label" runat="server" Style="white-space: nowrap;" Text='<%# Eval("CuentaBancaria") %>' />&nbsp;-&nbsp;
                                                            <asp:Label ID="SimboloMoneda_Label" runat="server" Text='<%# Eval("SimboloMoneda") %>' />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="right padded">
                                                        <asp:Label ID="SaldoAnteriorLabel" runat="server" Text='<%# Eval("SaldoAnterior", "{0:N2}") %>' />
                                                    </td>
                                                    <td class="right padded">
                                                        <asp:Label ID="DebitosLabel" runat="server" Text='<%# Eval("Debitos", "{0:N2}") %>' />
                                                    </td>
                                                    <td class="right padded">
                                                        <asp:Label ID="CreditosLabel" runat="server" Text='<%# Eval("Creditos", "{0:N2}") %>' />
                                                    </td>
                                                    <td class="right padded">
                                                        <asp:Label ID="SaldoActualLabel" runat="server" Text='<%# Eval("SaldoActual", "{0:N2}") %>' />
                                                    </td>
                                                    <td class="right padded">
                                                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("MontoRestringido", "{0:N2}") %>' />
                                                    </td>
                                                    <td class="right padded">
                                                        <asp:Label ID="Label6" runat="server" Text='<%# Eval("SaldoActual2", "{0:N2}") %>' />
                                                    </td>
                                                    <td class="right padded">
                                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("MontoChequesNoEntregados", "{0:N2}") %>' />
                                                    </td>
                                                    <td class="right padded">
                                                        <asp:Label ID="Label3" runat="server" Text='<%# Eval("SaldoActual3", "{0:N2}") %>' />
                                                    </td>
                                                </tr>

                                            </tr>
                                        </ItemTemplate>
                                        <AlternatingItemTemplate>
                                            <tr class="ListViewAlternatingRow">
                                                <td class="padded" rowspan="2">
                                                    <asp:ImageButton ID="SelectCategoryButton" runat="server" AlternateText="***" CommandName="Select"
                                                        ImageUrl="~/Pictures/arrow_right.png" ToolTip="Click para mostrar los movimientos de la cuenta" />
                                                </td>
                                                <td class="padded" colspan="8" style="color: #000080; font-weight: bold;">
                                                    <asp:Label ID="NombreCiaContab_Label" runat="server" Style="white-space: nowrap;"
                                                        Text='<%# Eval("NombreCiaContab") %>' />&nbsp;-&nbsp;
                                                            <asp:Label ID="NombreBanco_Label" runat="server" Style="white-space: nowrap;" Text='<%# Eval("NombreBanco") %>' />&nbsp;-&nbsp;
                                                            <asp:Label ID="CuentaBancaria_Label" runat="server" Style="white-space: nowrap;" Text='<%# Eval("CuentaBancaria") %>' />&nbsp;-&nbsp;
                                                            <asp:Label ID="SimboloMoneda_Label" runat="server" Text='<%# Eval("SimboloMoneda") %>' />
                                                </td>
                                            </tr>
                                            <tr class="ListViewAlternatingRow">
                                                <td class="right padded">
                                                    <asp:Label ID="SaldoAnteriorLabel" runat="server" Text='<%# Eval("SaldoAnterior", "{0:N2}") %>' />
                                                </td>
                                                <td class="right padded">
                                                    <asp:Label ID="DebitosLabel" runat="server" Text='<%# Eval("Debitos", "{0:N2}") %>' />
                                                </td>
                                                <td class="right padded">
                                                    <asp:Label ID="CreditosLabel" runat="server" Text='<%# Eval("Creditos", "{0:N2}") %>' />
                                                </td>
                                                <td class="right padded">
                                                    <asp:Label ID="SaldoActualLabel" runat="server" Text='<%# Eval("SaldoActual", "{0:N2}") %>' />
                                                </td>
                                                <td class="right padded">
                                                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("MontoRestringido", "{0:N2}") %>' />
                                                </td>
                                                <td class="right padded">
                                                    <asp:Label ID="Label6" runat="server" Text='<%# Eval("SaldoActual2", "{0:N2}") %>' />
                                                </td>
                                                <td class="right padded">
                                                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("MontoChequesNoEntregados", "{0:N2}") %>' />
                                                </td>
                                                <td class="right padded">
                                                    <asp:Label ID="Label3" runat="server" Text='<%# Eval("SaldoActual3", "{0:N2}") %>' />
                                                </td>
                                            </tr>
                                            </tr>
                                        </AlternatingItemTemplate>
                                        <SelectedItemTemplate>
                                            <tr class="ListViewSelectedRow">
                                                <td class="padded" rowspan="2">
                                                    <asp:ImageButton ID="SelectCategoryButton" runat="server" AlternateText="***" CommandName="Select"
                                                        ImageUrl="~/Pictures/arrow_right.png" ToolTip="Click para mostrar los movimientos de la cuenta" />
                                                </td>
                                                <td class="padded" colspan="8" style="color: #000080; font-weight: bold;">
                                                    <asp:Label ID="NombreCiaContab_Label" runat="server" Style="white-space: nowrap;"
                                                        Text='<%# Eval("NombreCiaContab") %>' />&nbsp;-&nbsp;
                                                            <asp:Label ID="NombreBanco_Label" runat="server" Style="white-space: nowrap;" Text='<%# Eval("NombreBanco") %>' />&nbsp;-&nbsp;
                                                            <asp:Label ID="CuentaBancaria_Label" runat="server" Style="white-space: nowrap;" Text='<%# Eval("CuentaBancaria") %>' />&nbsp;-&nbsp;
                                                            <asp:Label ID="SimboloMoneda_Label" runat="server" Text='<%# Eval("SimboloMoneda") %>' />
                                                </td>
                                            </tr>
                                            <tr class="ListViewSelectedRow">
                                                <td class="right padded">
                                                    <asp:Label ID="SaldoAnteriorLabel" runat="server" Text='<%# Eval("SaldoAnterior", "{0:N2}") %>' />
                                                </td>
                                                <td class="right padded">
                                                    <asp:Label ID="DebitosLabel" runat="server" Text='<%# Eval("Debitos", "{0:N2}") %>' />
                                                </td>
                                                <td class="right padded">
                                                    <asp:Label ID="CreditosLabel" runat="server" Text='<%# Eval("Creditos", "{0:N2}") %>' />
                                                </td>
                                                <td class="right padded">
                                                    <asp:Label ID="SaldoActualLabel" runat="server" Text='<%# Eval("SaldoActual", "{0:N2}") %>' />
                                                </td>
                                                <td class="right padded">
                                                    <asp:Label ID="Label2" runat="server" Text='<%# Eval("MontoRestringido", "{0:N2}") %>' />
                                                </td>
                                                <td class="right padded">
                                                    <asp:Label ID="Label6" runat="server" Text='<%# Eval("SaldoActual2", "{0:N2}") %>' />
                                                </td>
                                                <td class="right padded">
                                                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("MontoChequesNoEntregados", "{0:N2}") %>' />
                                                </td>
                                                <td class="right padded">
                                                    <asp:Label ID="Label3" runat="server" Text='<%# Eval("SaldoActual3", "{0:N2}") %>' />
                                                </td>
                                            </tr>
                                            </tr>
                                            </tr>
                                        </SelectedItemTemplate>
                                        <EmptyDataTemplate>
                                            <table id="Table1" runat="server" style="background-color: #FFFFFF; border-collapse: collapse; border-color: #999999; border-style: none; border-width: 1px;">
                                                <tr>
                                                    <td>No se ha seleccionado información para mostrar
                                                    </td>
                                                </tr>
                                            </table>
                                        </EmptyDataTemplate>
                                    </asp:ListView>
                                    &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;
                                </ContentTemplate>
                            </cc1:TabPanel>
                            <cc1:TabPanel runat="server" HeaderText="Movimientos" ID="TabPanel3">
                                <ContentTemplate>

                                    <table style="width: 100%;">
                                        <tr>
                                            <td style="text-align: left;">
                                                <h5 id="DatosCuenta_H5" runat="server"></h5>
                                            </td>
                                            <td style="text-align: right;"></td>
                                        </tr>
                                    </table>


                                    <asp:ListView ID="Movimientos_ListView"
                                        runat="server"
                                        DataSourceID="Movimientos_SqlDataSource">
                                        <LayoutTemplate>
                                            <table id="Table1" runat="server">
                                                <tr id="Tr1" runat="server">
                                                    <td id="Td1" runat="server">
                                                        <table id="itemPlaceholderContainer" runat="server" border="0"
                                                            style="border: 1px solid #E6E6E6" class="notsosmallfont"
                                                            cellspacing="0" rules="none">
                                                            <tr id="Tr2" runat="server" class="ListViewHeader">
                                                                <th></th>
                                                                <th id="Th3" runat="server" class="padded"
                                                                    style="text-align: left; padding-bottom: 8px; padding-top: 8px;">Beneficiario
                                                                </th>
                                                                <th id="Th4" runat="server" class="padded"
                                                                    style="text-align: left; padding-bottom: 8px; padding-top: 8px;">Concepto
                                                                </th>
                                                                <th id="Th7" runat="server" class="padded"
                                                                    style="text-align: left; padding-bottom: 8px; padding-top: 8px;">Compañía
                                                                </th>
                                                                <th id="Th9" runat="server" class="padded"
                                                                    style="text-align: center; padding-bottom: 8px; padding-top: 8px;">Entregado
                                                                </th>
                                                                <th id="Th10" runat="server" class="padded"
                                                                    style="text-align: right; padding-bottom: 8px; padding-top: 8px;">Monto
                                                                </th>
                                                                <th id="Th2" runat="server" class="padded"
                                                                    style="text-align: center; padding-bottom: 8px; padding-top: 8px;">Conciliado
                                                                </th>
                                                            </tr>
                                                            <tr id="itemPlaceholder" runat="server">
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr id="Tr3" runat="server">
                                                    <td id="Td2" runat="server" style="text-align: center; background-color: #CCCCCC; font-family: Verdana, Arial, Helvetica, sans-serif; color: #000000;">
                                                        <asp:DataPager ID="ConsultaDisponibilidad_DataPager" runat="server">
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
                                        <ItemTemplate>
                                            <tr class="ListViewRow" <%# FormatColorRow((string)Eval("Tipo")) %>>
                                                <tr>
                                                    <td class="padded" style="text-align: left; font-weight: bold; color: #000080;" colspan="7">
                                                        <%#Eval("Tipo") == "IN" | Eval("Tipo") == "SA" | Eval("Tipo") == "MR" | 
                                                               Eval("Tipo") == "TO" | Eval("Tipo") == "NE" | Eval("Tipo") == "TC" ? 
                                                               "" : Eval("Fecha", "{0:dd-MMM-yy}") + "  " + Eval("Tipo") + "  " + 
                                                               Eval("Transaccion")%>
                                                    </td>
                                                </tr>
                                                <tr <%# FormatColorRow((string)Eval("Tipo")) %>>
                                                    <td style="color: #000080">
                                                        <%#Eval("Tipo") == "CH" && Eval("FechaEntregado") == null && !((int)Eval("Monto") == 0) ? "*" : ""%>
                                                    </td>
                                                    <td class="padded" style="text-align: left;">
                                                        <%#Eval("Tipo") == "IN" | Eval("Tipo") == "SA" | Eval("Tipo") == "MR" | 
                                                           Eval("Tipo") == "TO" | Eval("Tipo") == "NE" | Eval("Tipo") == "TC" ?
                                                               Eval("Fecha", "{0:d-MMM-y}") : Eval("Beneficiario")%>
                                                    </td>
                                                    <td class="padded" style="text-align: left;">
                                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("Concepto") %>' />
                                                    </td>
                                                    <td class="padded" style="text-align: left;">
                                                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("NombreProveedorCliente") %>' />
                                                    </td>
                                                    <td class="padded" style="text-align: center;">
                                                        <asp:Label ID="Label3" runat="server" Text='<%# Eval("FechaEntregado", "{0:d-MMM-y}") %>' />
                                                    </td>
                                                    <td class="padded" style="text-align: right; white-space: nowrap;">
                                                        <asp:Label ID="Label4" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                                                    </td>
                                                    <td class="padded" style="text-align: center;">
                                                        <asp:Label ID="Label5" runat="server" Text='<%# Eval("Conciliacion_FechaEjecucion", "{0:0:d-MMM-y}") %>' />
                                                    </td>
                                                </tr>
                                            </tr>
                                        </ItemTemplate>
                                        <AlternatingItemTemplate>
                                            <tr>
                                                <tr class="ListViewAlternatingRow" <%# FormatColorRow((string)Eval("Tipo")) %>>
                                                    <td class="padded" style="text-align: left; font-weight: bold; color: #000080;" colspan="7">
                                                        <%#Eval("Tipo") == "IN" | Eval("Tipo") == "SA" | Eval("Tipo") == "MR" | 
                                                               Eval("Tipo") == "TO" | Eval("Tipo") == "NE" | Eval("Tipo") == "TC" ?
                                                                   "" : Eval("Fecha", "{0:dd-MMM-yy}") + "  " + Eval("Tipo") + "  " +
                                                               Eval("Transaccion")%>
                                                    </td>
                                                </tr>

                                                <tr class="ListViewAlternatingRow" <%# FormatColorRow((string)Eval("Tipo")) %>>
                                                    <td style="color: #000080">
                                                        <%#Eval("Tipo") == "CH" && Eval("FechaEntregado") == null && !((int)Eval("Monto") == 0) ? "*" : ""%>
                                                    </td>
                                                    <td class="padded" style="text-align: left;">
                                                        <%#Eval("Tipo") == "IN" | Eval("Tipo") == "SA" | Eval("Tipo") == "MR" |
                                                           Eval("Tipo") == "TO" | Eval("Tipo") == "NE" | Eval("Tipo") == "TC" ? 
                                                               Eval("Fecha", "{0:d-MMM-y}") : Eval("Beneficiario")%>
                                                    </td>
                                                    <td class="padded" style="text-align: left;">
                                                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("Concepto") %>' />
                                                    </td>
                                                    <td class="padded" style="text-align: left;">
                                                        <asp:Label ID="Label8" runat="server" Text='<%# Eval("NombreProveedorCliente") %>' />
                                                    </td>
                                                    <td class="padded" style="text-align: center;">
                                                        <asp:Label ID="Label9" runat="server" Text='<%# Eval("FechaEntregado", "{0:d-MMM-y}") %>' />
                                                    </td>
                                                    <td class="padded" style="text-align: right; white-space: nowrap;">
                                                        <asp:Label ID="Label10" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                                                    </td>
                                                    <td class="padded" style="text-align: center;">
                                                        <asp:Label ID="Label11" runat="server" Text='<%# Eval("Conciliacion_FechaEjecucion", "{0:0:d-MMM-y}") %>' />
                                                    </td>
                                                </tr>
                                            </tr>
                                        </AlternatingItemTemplate>
                                        <EmptyDataTemplate>
                                            <table id="Table1" runat="server" style="background-color: #FFFFFF; border-collapse: collapse; border-color: #999999; border-style: none; border-width: 1px;">
                                                <tr>
                                                    <td>Seleccione una cuenta para mostrar sus movimientos en esta sección
                                                    </td>
                                                </tr>
                                            </table>
                                        </EmptyDataTemplate>
                                    </asp:ListView>

                                </ContentTemplate>
                            </cc1:TabPanel>
                        </cc1:TabContainer>

                    </ContentTemplate>
                </asp:UpdatePanel>
            </td>
        </tr>
    </table>
    <%--  varios sql datasources y popup de compañías (y sus cierres bancarios) --%>
    <div>
        <asp:SqlDataSource ID="Companias_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT Numero, Nombre FROM Companias ORDER BY Nombre"></asp:SqlDataSource>

        <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT Moneda, Descripcion FROM Monedas ORDER BY Descripcion"></asp:SqlDataSource>

        <asp:SqlDataSource ID="CuentasBancarias_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT CuentasBancarias.CuentaInterna, Bancos.NombreCorto + ' - ' + Monedas.Simbolo + ' - ' + CuentasBancarias.CuentaBancaria + ' - ' + Companias.NombreCorto AS NombreCuentaBancaria FROM CuentasBancarias INNER JOIN Bancos ON CuentasBancarias.Banco = Bancos.Banco INNER JOIN Monedas ON CuentasBancarias.Moneda = Monedas.Moneda INNER JOIN Companias ON CuentasBancarias.Cia = Companias.Numero WHERE (Bancos.NombreCorto IS NOT NULL) AND (Monedas.Simbolo IS NOT NULL) AND (CuentasBancarias.CuentaBancaria IS NOT NULL) And (Estado = 'AC') ORDER BY Bancos.NombreCorto, Monedas.Simbolo, CuentasBancarias.CuentaBancaria"></asp:SqlDataSource>

        <asp:SqlDataSource ID="SaldosCuentasBancarias_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT NombreCiaContab, NombreBanco, CuentaInterna, CuentaBancaria, SimboloMoneda, FechaSaldoAnterior, SaldoAnterior, Debitos, Creditos, SaldoActual, MontoRestringido, SaldoActual2, MontoChequesNoEntregados, SaldoActual3, FechaSaldoActual, CiaContab FROM tTempWebReport_DisponibilidadBancos WHERE (NombreUsuario = @NombreUsuario)">
            <SelectParameters>
                <asp:Parameter Name="NombreUsuario" />
            </SelectParameters>
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="Movimientos_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT tTempWebReport_DisponibilidadBancos2.Orden, tTempWebReport_DisponibilidadBancos2.Transaccion, tTempWebReport_DisponibilidadBancos2.Tipo, tTempWebReport_DisponibilidadBancos2.Fecha, tTempWebReport_DisponibilidadBancos2.Beneficiario, tTempWebReport_DisponibilidadBancos2.Concepto, tTempWebReport_DisponibilidadBancos2.Monto, tTempWebReport_DisponibilidadBancos2.FechaEntregado, tTempWebReport_DisponibilidadBancos2.Conciliacion_FechaEjecucion, tTempWebReport_DisponibilidadBancos2.NombreProveedorCliente, tTempWebReport_DisponibilidadBancos.CuentaBancaria, tTempWebReport_DisponibilidadBancos.SimboloMoneda, tTempWebReport_DisponibilidadBancos.NombreBanco, tTempWebReport_DisponibilidadBancos.NombreCiaContab AS NombreCompania FROM tTempWebReport_DisponibilidadBancos2 INNER JOIN tTempWebReport_DisponibilidadBancos ON tTempWebReport_DisponibilidadBancos2.CuentaInterna = tTempWebReport_DisponibilidadBancos.CuentaInterna And tTempWebReport_DisponibilidadBancos2.NombreUsuario = tTempWebReport_DisponibilidadBancos.NombreUsuario AND tTempWebReport_DisponibilidadBancos2.CiaContab = tTempWebReport_DisponibilidadBancos.CiaContab WHERE (tTempWebReport_DisponibilidadBancos2.CuentaInterna = @CuentaInterna) AND (tTempWebReport_DisponibilidadBancos2.NombreUsuario = @NombreUsuario) AND (tTempWebReport_DisponibilidadBancos2.CiaContab = @Cia) ORDER BY tTempWebReport_DisponibilidadBancos2.Orden, tTempWebReport_DisponibilidadBancos2.Fecha">
            <SelectParameters>
                <asp:Parameter Name="CuentaInterna" />
                <asp:Parameter Name="NombreUsuario" />
                <asp:Parameter Name="Cia" />
            </SelectParameters>
        </asp:SqlDataSource>

    </div>
</asp:Content>
<%--  footer place holder --%>
<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" runat="Server">
    <br />
</asp:Content>
