<%@ Page Language="C#" MasterPageFile="~/MasterPage_1.Master" AutoEventWireup="true" CodeBehind="ComprobantesContables.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.Comprobantes.ComprobantesContables" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" Runat="Server">
<%--<script src="<%= this.Page.ResolveUrl("~/Scripts/jquery/jquery-1.10.2.js") %>"></script>--%>

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

<%--  para refrescar la página cuando el popup se cierra (y saber que el refresh es por eso) --%>
<span id="RebindFlagSpan">
    <%--<asp:HiddenField id="RebindFlagHiddenField" runat="server" value="0" />--%>
    <%-- clientIdMode 'static' para que el id permanezca hasta el cliente (browser) --%>
    <asp:HiddenField ID="RebindFlagHiddenField" runat="server" Value="0" ClientIDMode="Static" />
</span>

<%--  --%>
<%-- div en la izquierda para mostrar funciones de la página --%>
<%--  --%>
    <div class="notsosmallfont" style="width: 10%; border: 1px solid #C0C0C0; vertical-align: top; background-color: #F7F7F7; float: left; text-align: center; ">
        <br />
        <br />

        <a href="javascript:PopupWin('ComprobantesContables_Filter.aspx', 1000, 680)">Definir y aplicar<br /> un filtro</a><br />
        <i class="fas fa-filter fa-2x" style="margin-top: 5px; "></i>

        <hr />

        <a href="javascript:PopupWin('OpcionesReportes.aspx', 1000, 680)" >Reporte</a><br />
        <i class="fas fa-print fa-2x" style="margin-top: 5px; "></i>

        <hr />

        <a href="javascript:PopupWin('../../UltimoMesCerradoContable.aspx', 1000, 680)">Fechas de último<br /> cierre contable</a><br />
        <i class="fas fa-desktop fa-2x" style="margin-top: 5px; "></i>

        <div id="SoloUsuariosAutorizados_Div" runat="server">
            <hr />
            <a href="javascript:PopupWin('ComprobantesContables_Funciones.aspx', 1000, 680)">Funciones</a><br />
            <i class="fas fa-cog fa-2x" style="margin-top: 5px; "></i>
        </div>

        <hr />
        <br />
    </div>

    <div style="text-align: left; float: right; width: 88%;">
        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />

        <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional" ChildrenAsTriggers="False">
            <ContentTemplate>
          
                <table>
                    <tr>
                        <td style="border: 1px solid #C0C0C0; vertical-align: top; background-color: #EEEEEE;">
                            &nbsp;
                            <span class="smallfont">Compañías:&nbsp;
                                <asp:DropDownList ID="CompaniasFilter_DropDownList" 
                                                  runat="server" 
                                                  ItemType="ContabSysNet_Web.ModelosDatos_EF.Contab.Compania"
                                                  DataTextField="NombreCorto" 
                                                  DataValueField="Numero" 
                                                  AutoPostBack="True"
                                                  CssClass="smallfont" 
                                                  SelectMethod="Companias_DropDownList_GetData"
                                                  onselectedindexchanged="AplicarMiniFiltro">
                                </asp:DropDownList>
                            </span>

                            &nbsp;&nbsp; 

                            <span class="smallfont">Monedas:&nbsp;
                                <asp:DropDownList ID="MonedasFilter_DropDownList" 
                                                  runat="server" 
                                                  ItemType="ContabSysNet_Web.ModelosDatos_EF.Contab.Moneda"
                                                  DataTextField="Descripcion" 
                                                  DataValueField="Moneda1" 
                                                  AutoPostBack="True"
                                                  CssClass="smallfont" 
                                                  SelectMethod="Monedas_DropDownList_GetData"
                                                  OnSelectedIndexChanged="AplicarMiniFiltro">
                                </asp:DropDownList>

                                &nbsp;&nbsp; 

                                Cuenta contable:&nbsp;
                                <asp:TextBox ID="CuentaContableFilter_TextBox" 
                                             runat="server" 
                                             CssClass="smallfont"
                                             AutoPostBack="True"  
                                             OnTextChanged="AplicarMiniFiltro" />

                                 &nbsp;&nbsp; 
                                Descripción de cuenta contable:&nbsp;
                                <asp:TextBox ID="CuentaContableDescripcionFilter_TextBox"
                                             runat="server" 
                                             CssClass="smallfont"
                                             AutoPostBack="True"  
                                             OnTextChanged="AplicarMiniFiltro" />
                            </span>

                            &nbsp;&nbsp; 

                            <span class="smallfont">
                                (<b>10:</b> todo lo que contenga 10; <b>10*:</b> todo lo que comience por 10; <b>*10:</b> todo lo que termine en 10) 
                            </span>
                            &nbsp;
                        </td>
                    </tr>
                </table>
            
                <asp:ListView ID="ComprobantesContables_ListView" 
                              runat="server" 
                              ItemType="ContabSysNet_Web.ModelosDatos_EF.Contab.tTempWebReport_ConsultaComprobantesContables" 
                              DataKeyNames="ID" 
                              onpagepropertieschanged="ComprobantesContables_ListView_PagePropertiesChanged"
                              onselectedindexchanged="ComprobantesContables_ListView_SelectedIndexChanged"
                              SelectMethod="ComprobantesContables_ListView_GetData">
                    <LayoutTemplate>
                        <table id="Table1" runat="server">
                            <tr id="Tr1" runat="server">
                                <td id="Td1" runat="server">
                                    <table id="itemPlaceholderContainer" 
                                           runat="server" border="0" 
                                           style="border: 1px solid #E6E6E6"
                                           class="smallfont" 
                                           cellspacing="0" 
                                           rules="none">
                                        <tr id="Tr2" runat="server" style="" class="ListViewHeader_Suave">
                                            <th id="Th1" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px; ">
                                                ##
                                            </th>
                                            <th id="Th2" runat="server" class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px; ">
                                                Tipo
                                            </th>
                                            <th id="Th3" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px; ">
                                                Fecha
                                            </th>
                                            <th id="Th4" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px; ">
                                                Mon orig
                                            </th>
                                            <th id="Th5" runat="server" class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px; ">
                                                Descripción
                                            </th>
                                            <th id="Th6" runat="server" class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px; ">
                                                Proviene de
                                            </th>
                                            <th id="Th7" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px; ">
                                                Cant<br />partidas
                                            </th>
                                            <th id="Th8" runat="server" class="padded" style="text-align: right; padding-bottom: 5px; padding-top: 5px; ">
                                                Total debe
                                            </th>
                                            <th id="Th9" runat="server" class="padded" style="text-align: right; padding-bottom: 5px; padding-top: 5px; ">
                                                Total haber
                                            </th>
                                            <th id="Th11" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px; ">
                                                Cierre<br />anual
                                            </th>
                                            <th id="Th13" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px; ">
                                                Cant<br />uploads
                                            </th>
                                            <th id="Th10" runat="server" class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px; ">
                                                Usuario
                                            </th>
                                            <th id="Th12" runat="server" class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px; ">
                                                Lote
                                            </th>
                                        </tr>
                                        <tr id="itemPlaceholder" runat="server">
                                        </tr>

                                        <%--NOTA: aquí iría el footer !!! --%>
                                        <tr id="Tr4" runat="server" class="ListViewFooter smallfont">
                                            <th id="Th19" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px; " /> 
                                            <th id="Th20" runat="server" class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px; " />
                                            <th id="Th21" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px; " />
                                            <th id="Th22" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px; " />
                                            <th id="Th23" runat="server" class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px; " />
                                            <th id="Th24" runat="server" class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px; " />
                                            <th id="Th25" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px; "> 
                                                (<asp:Label ID="numberOfRecords_label" runat="server" />)
                                            </th>
                                            <th id="Th26" runat="server" class="padded" style="text-align: right; padding-bottom: 5px; padding-top: 5px; ">
                                                <asp:Label ID="SumOfDebe_Label" runat="server" />
                                            </th>
                                            <th id="Th27" runat="server" class="padded" style="text-align: right; padding-bottom: 5px; padding-top: 5px; ">
                                                <asp:Label ID="SumOfHaber_Label" runat="server" />
                                            </th>
                                            <th id="Th28" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px; " />
                                            <th id="Th14" runat="server" class="padded" style="text-align: center; padding-bottom: 5px; padding-top: 5px; " />
                                            <th id="Th29" runat="server" class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px; " />  
                                            <th id="Th30" runat="server" class="padded" style="text-align: left; padding-bottom: 5px; padding-top: 5px; " />
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr id="Tr3" runat="server">
                                <td id="Td2" runat="server" style="" class="generalfont">
                                    <asp:DataPager ID="ComprobantesContables_DataPager" runat="server" PageSize="20">
                                        <Fields>
                                            <asp:NextPreviousPagerField ButtonType="Link" FirstPageImageUrl="../../../Pictures/first_16x16.gif"
                                                FirstPageText="&lt;&lt;" NextPageText="&gt;" PreviousPageImageUrl="../../../Pictures/left_16x16.gif"
                                                PreviousPageText="&lt;" ShowFirstPageButton="True" ShowNextPageButton="False"
                                                ShowPreviousPageButton="True" />
                                            <asp:NumericPagerField />
                                            <asp:NextPreviousPagerField ButtonType="Link" LastPageImageUrl="../../../Pictures/last_16x16.gif"
                                                LastPageText="&gt;&gt;" NextPageImageUrl="../../../Pictures/right_16x16.gif"
                                                NextPageText="&gt;" PreviousPageText="&lt;" ShowLastPageButton="True" ShowNextPageButton="True"
                                                ShowPreviousPageButton="False" />
                                        </Fields>
                                    </asp:DataPager>
                                </td>
                            </tr>
                        </table>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <tr style="">
                            <td class="padded" style="text-align: center;">
                                <a href="javascript:PopupWin('../Cuentas y movimientos/CuentasYMovimientos_Comprobantes.aspx?NumeroAutomatico=' + <%# Item.NumeroAutomatico %>, 1000, 680)">
                                    <%# Item.Asiento.Numero.ToString() %></a>
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NombreTipoLabel" runat="server" Text='<%# Item.Asiento.Tipo %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space: nowrap;">
                                <asp:Label ID="FechaLabel" runat="server" Text='<%# Item.Asiento.Fecha.ToString("dd-MMM-yy") %>' />
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="SimboloMonedaOriginalLabel" runat="server" Text='<%# Item.Asiento.Moneda2.Simbolo %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="DescripcionLabel" runat="server" Text='<%# Item.Asiento.Descripcion %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="ProvieneDeLabel" runat="server" Text='<%# Item.Asiento.ProvieneDe %>' />
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="NumPartidasLabel" runat="server" Text='<%# Item.NumPartidas %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="TotalDebeLabel" runat="server" Text='<%# Item.TotalDebe.ToString("N2") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="TotalHaberLabel" runat="server" Text='<%# Item.TotalHaber.ToString("N2") %>' />
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:CheckBox ID="AsientoTipoCierreAnual_CheckBox" runat="server" 
                                    Checked='<%# Item.Asiento.AsientoTipoCierreAnualFlag != null ? Item.Asiento.AsientoTipoCierreAnualFlag.Value : false %>' />
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="Label3" runat="server" Text='<%# Item.NumUploads.ToString("#") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label1" runat="server" Text='<%# Item.Asiento.Usuario %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label2" runat="server" Text='<%# Item.Asiento.Lote %>' />
                            </td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr style="" class="ListViewAlternatingRow">
                            <td class="padded" style="text-align: center;">
                                <a href="javascript:PopupWin('../Cuentas y movimientos/CuentasYMovimientos_Comprobantes.aspx?NumeroAutomatico=' + <%# Item.NumeroAutomatico %>, 1000, 680)">
                                    <%# Item.Asiento.Numero.ToString() %></a>
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NombreTipoLabel" runat="server" Text='<%# Item.Asiento.Tipo %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space: nowrap;">
                                <asp:Label ID="FechaLabel" runat="server" Text='<%# Item.Asiento.Fecha.ToString("dd-MMM-yy") %>' />
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="SimboloMonedaOriginalLabel" runat="server" Text='<%# Item.Asiento.Moneda2.Simbolo %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="DescripcionLabel" runat="server" Text='<%# Item.Asiento.Descripcion %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="ProvieneDeLabel" runat="server" Text='<%# Item.Asiento.ProvieneDe %>' />
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="NumPartidasLabel" runat="server" Text='<%# Item.NumPartidas %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="TotalDebeLabel" runat="server" Text='<%# Item.TotalDebe.ToString("N2") %>' />
                            </td>
                            <td class="padded" style="text-align: right;">
                                <asp:Label ID="TotalHaberLabel" runat="server" Text='<%# Item.TotalHaber.ToString("N2") %>' />
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:CheckBox ID="AsientoTipoCierreAnual_CheckBox" runat="server" 
                                    Checked='<%# Item.Asiento.AsientoTipoCierreAnualFlag != null ? Item.Asiento.AsientoTipoCierreAnualFlag.Value : false %>' />
                            </td>
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="Label3" runat="server" Text='<%# Item.NumUploads.ToString("#") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label1" runat="server" Text='<%# Item.Asiento.Usuario %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label2" runat="server" Text='<%# Item.Asiento.Lote %>' />
                            </td>
                        </tr>
                    </AlternatingItemTemplate>
                    <EmptyDataTemplate>
                        <table id="Table2" runat="server" style="">
                            <tr>
                                <td>
                                    <br />
                                    Aplique un filtro para seleccionar información.
                                </td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                </asp:ListView>

            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="CompaniasFilter_DropDownList" EventName="TextChanged" />
                <asp:AsyncPostBackTrigger ControlID="MonedasFilter_DropDownList" EventName="TextChanged" />
                <asp:AsyncPostBackTrigger ControlID="CuentaContableFilter_TextBox" EventName="TextChanged" />
                <asp:AsyncPostBackTrigger ControlID="CuentaContableDescripcionFilter_TextBox" EventName="TextChanged" />
                <asp:AsyncPostBackTrigger ControlID="ComprobantesContables_ListView" EventName="SelectedIndexChanged" />
                <asp:AsyncPostBackTrigger ControlID="ComprobantesContables_ListView" EventName="PagePropertiesChanged" />
            </Triggers>
        </asp:UpdatePanel>
        
        <asp:SqlDataSource ID="CompaniasSeleccionadas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            
            SelectCommand="SELECT DISTINCT tTempWebReport_ConsultaComprobantesContables.CiaContab, Companias.NombreCorto AS NombreCiaContab FROM tTempWebReport_ConsultaComprobantesContables LEFT OUTER JOIN Companias ON tTempWebReport_ConsultaComprobantesContables.CiaContab = Companias.Numero WHERE (tTempWebReport_ConsultaComprobantesContables.NombreUsuario = @NombreUsuario) ORDER BY Companias.NombreCorto">
            <SelectParameters>
                <asp:Parameter Name="NombreUsuario" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="MonedasSeleccionadas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT DISTINCT tTempWebReport_ConsultaComprobantesContables.Moneda, Monedas.Descripcion As NombreMoneda FROM tTempWebReport_ConsultaComprobantesContables Left Outer Join Monedas 
                            On tTempWebReport_ConsultaComprobantesContables.Moneda = Monedas.Moneda 
                            WHERE (NombreUsuario = @NombreUsuario) ORDER BY NombreMoneda">
            <SelectParameters>
                <asp:Parameter Name="NombreUsuario" Type="String" />
            </SelectParameters>
        </asp:SqlDataSource>

    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
    <br />
</asp:Content>
