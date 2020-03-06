<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage_1.master" CodeBehind="DepreciacionMensual_Page.aspx.cs" Inherits="ContabSysNet_Web.ActivosFijos.Consultas.DepreciacionMensual.DepreciacionMensual_Page" %>
<%@ MasterType  virtualPath="~/MasterPage_1.master"%>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" Runat="Server">

<script type="text/javascript" src="<%= this.Page.ResolveUrl("~/Scripts/jquery/jquery-1.10.2.js") %>"></script>
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
    <%-- clientIdMode 'static' para que el id permanezca hasta el cliente (browser) --%>
    <asp:HiddenField ID="RebindFlagHiddenField" runat="server" Value="0" ClientIDMode="Static" />
</span>
    
    <table style="width: 100%" class="miniminheight">
    
        <tr>
             <%--   column en la izquierda con links   --%>
            <td style="border: 1px solid #C0C0C0; width: 10%; vertical-align: top; background-color: #F7F7F7; text-align: center; padding-left: 10px; padding-right: 10px; " class="notsosmallfont">
                <br />
                <br />
                <a href="javascript:PopupWin('DepreciacionMensual_Filter.aspx', 1000, 680)">Definir y aplicar<br /> un filtro</a><br />
                <i class="fas fa-filter fa-2x" style="margin-top: 5px; "></i>

                <hr />

                <%-- para mostrar la cantidad de registros seleccinados --%>
                <div id="selectedRecs_div" style="display: none; " runat="server">
                    <p id="selectedRecs_p" style="text-align: center;" runat="server" />
                    <hr />
                </div>
                <%-- --------------------------------- --%>

                <a href="javascript:PopupWin('DepreciacionMensual_OpcionesReportes.aspx', 1000, 680)" >Reporte</a><br />
                <i class="fas fa-print fa-2x" style="margin-top: 5px; "></i>

                <hr />
            </td>

            <td style="vertical-align: top; ">
            
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
                            style="display: block;" />

                        <asp:ListView ID="ConsultaDepreciacion_ListView" 
                                      runat="server" 
                                      DataKeyNames="ID"
                                      DataSourceID="tTempActivosFijos_ConsultaDepreciacion_EntityDataSource" 
                                      
                            onselectedindexchanged="ConsultaDisponibilidad_ListView_SelectedIndexChanged" 
                            onpagepropertieschanged="ConsultaDepreciacion_ListView_PagePropertiesChanged">

                            <LayoutTemplate>
                                <table id="Table1" runat="server" >
                                    <tr id="Tr1" runat="server">
                                        <td id="Td1" runat="server">
                                            <table id="itemPlaceholderContainer" runat="server" border="0"  
                                                    style="border: 1px solid #E6E6E6" class="smallfont" 
                                                    cellspacing="0" rules="none">

                                                <tr id="Tr4" runat="server" class="ListViewHeader">
                                                    <th id="Th9" runat="server" class="padded" style="text-align: left; background-color: transparent; " colspan="10" />

                                                    <th id="Th21" runat="server" 
                                                                  class="padded" 
                                                                  style="text-align: center; border-style: solid; border-width: 1px; border-color: #C0C0C0;" 
                                                                  colspan="2">
                                                        Dep hasta
                                                    </th>

                                                    <th id="Th10" runat="server" 
                                                                  class="padded" 
                                                                  style="text-align: center; border-style: solid; border-width: 1px; border-color: #C0C0C0;" 
                                                                  colspan="4">
                                                        Vida del activo (meses)
                                                    </th>

                                                    <th id="Th17" runat="server" 
                                                                  class="padded" 
                                                                  style="text-align: center; border-style: solid; border-width: 1px; border-color: #C0C0C0;" 
                                                                  colspan="5">
                                                        Información de depreciación (montos)
                                                    </th>
                                                </tr>

                                                <tr id="Tr2" runat="server" class="ListViewHeader">
                                                    <th class="padded" />
                                                    <th id="SaldoAnterior_ColumHeader" runat="server" class="padded" style="text-align: left;">
                                                        Cia contab
                                                    </th>
                                                    <th id="Th22" runat="server" class="padded" style="text-align: center;">
                                                        Mon
                                                    </th>
                                                    <th id="Th5" runat="server" class="padded" style="text-align: left;">
                                                        Departamento
                                                    </th>
                                                    <th id="Th6" runat="server" class="padded" style="text-align: left;">
                                                        Tipo
                                                    </th>
                                                    <th id="SaldoActual_ColumHeader" runat="server" class="padded" style="text-align: left;">
                                                        Proveedor
                                                    </th>
                                                    <th id="Th1" runat="server" class="padded" style="text-align: left;">
                                                        Producto
                                                    </th>
                                                    <th id="Th8" runat="server" class="left padded" style="text-align: left;">
                                                        Descripción
                                                    </th>

                                                    <th id="Th11" runat="server" class="padded" style="text-align: center;">
                                                        FComp
                                                    </th>
                                                    <th id="Th18" runat="server" class="padded" style="text-align: center;">
                                                        FDesc
                                                    </th>

                                                    <th id="Th19" runat="server" class="right padded">
                                                        Mes
                                                    </th>
                                                    <th id="Th20" runat="server" class="right padded">
                                                        Año
                                                    </th>

                                                    <th id="Th13" runat="server" class="padded" style="text-align: center;">
                                                        Útil
                                                    </th>
                                                    <th id="Th14" runat="server" class="padded" style="text-align: center;">
                                                        Año<br />
                                                        <%= this.ConstruirPeriodoTranscurridoAnoFiscal() %>
                                                    </th>
                                                    <th id="Th15" runat="server" class="padded" style="text-align: center;">
                                                        Acum
                                                    </th>
                                                    <th id="Th16" runat="server" class="padded" style="text-align: center;">
                                                        Resta
                                                    </th>

                                                    <th id="Th12" runat="server" class="right padded">
                                                        Total a<br />depreciar
                                                    </th>
                                                    <th id="Th2" runat="server" class="right padded">
                                                        Mensual
                                                    </th>
                                                    <th id="Th3" runat="server" class="right padded">
                                                        Acumulada
                                                    </th>
                                                    <th id="Th4" runat="server" class="right padded">
                                                        Acumulada<br />
                                                        en el año<br />
                                                        <%= this.ConstruirPeriodoTranscurridoAnoFiscal() %>
                                                    </th>
                                                    <th id="Th7" runat="server" class="right padded">
                                                        Resta
                                                    </th>
                                                </tr>
                                                <tr id="itemPlaceholder" runat="server">
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr id="Tr3" runat="server">
                                        <td id="Td2" runat="server" style="text-align: left; background-color: #CCCCCC;
                                            font-family: Verdana, Arial, Helvetica, sans-serif; color: #000000; font-size: small; ">
                                            <asp:DataPager ID="ConsultaDisponibilidad_DataPager" runat="server" PageSize="25">
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
                                    <td class="padded">
                                        <asp:ImageButton ID="SelectItems_Button" runat="server" AlternateText="***" CommandName="Select"
                                            ImageUrl="~/Pictures/SelectRecord.png" ToolTip="... click para seleccionar el registro" />
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="ciaContab" runat="server" Text='<%# Eval("InventarioActivosFijo.Compania.Abreviatura") %>' />
                                    </td>
                                    <td class="center padded">
                                        <asp:Label ID="moneda" runat="server" Text='<%# Eval("InventarioActivosFijo.Moneda1.Simbolo") %>' />
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="DebitosLabel" runat="server" 
                                        Text='<%# Eval("InventarioActivosFijo.tDepartamento.Descripcion").ToString().Length <= 10 ? 
                                                  Eval("InventarioActivosFijo.tDepartamento.Descripcion") : 
                                                  Eval("InventarioActivosFijo.tDepartamento.Descripcion").ToString().Substring(0, 10) %>' />
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="CreditosLabel" runat="server" 
                                        Text='<%# Eval("InventarioActivosFijo.TiposDeProducto.Descripcion").ToString().Length <= 10 ?
                                                  Eval("InventarioActivosFijo.TiposDeProducto.Descripcion") :
                                                  Eval("InventarioActivosFijo.TiposDeProducto.Descripcion").ToString().Substring(0, 10)%>' />
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="SaldoActualLabel" runat="server" Text='<%# Eval("InventarioActivosFijo.Proveedore.Abreviatura") %>' />
                                    </td>
                                    <td class="left padded" style="white-space:nowrap; ">
                                        <a href="javascript:PopupWin('../ConsultaActivosFijos/ActivoFijo_page.aspx?ID=' + <%# Eval("InventarioActivosFijo.ClaveUnica") %>, 1000, 680)">
                                            <%#Eval("InventarioActivosFijo.Producto")%>
                                        </a>
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="Label6" runat="server" 
                                        Text='<%# Eval("InventarioActivosFijo.Descripcion").ToString().Length <= 20 ?
                                                  Eval("InventarioActivosFijo.Descripcion") :
                                                  Eval("InventarioActivosFijo.Descripcion").ToString().Substring(0, 20)%>' />
                                    </td>
                                    <td class="padded" style="white-space:nowrap; text-align: center; ">
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("InventarioActivosFijo.FechaCompra", "{0:M-yy}") %>' />
                                    </td>

                                    <td class="padded" style="white-space:nowrap; text-align: center; ">
                                        <asp:Label ID="Label13" runat="server" Text='<%# Eval("InventarioActivosFijo.FechaDesincorporacion", "{0:M-yy}") %>' />
                                    </td>

                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label14" runat="server" Text='<%# Eval("DepreciarHastaMes") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label15" runat="server" Text='<%# Eval("DepreciarHastaAno") %>' />
                                    </td>

                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label9" runat="server" Text='<%# Eval("InventarioActivosFijo.CantidadMesesADepreciar") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label10" runat="server" Text='<%# Eval("DepAcum_CantMeses_AnoActual") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label11" runat="server" Text='<%# Eval("DepAcum_CantMeses") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label12" runat="server"  
                                                   Text='<%# (short)Eval("CantidadMesesADepreciar") - (short)Eval("DepAcum_CantMeses") %>' />
                                    </td>

                                    <td class="right padded">
                                        <asp:Label ID="Label3" runat="server" Text='<%# Eval("InventarioActivosFijo.MontoADepreciar", "{0:N2}") %>' />
                                    </td>
                                    <td class="right padded">
                                        <asp:Label ID="Label4" runat="server" Text='<%# Eval("DepreciacionMensual", "{0:N2}") %>' />
                                    </td>
                                    <td class="right padded">
                                        <asp:Label ID="Label5" runat="server" Text='<%# Eval("DepAcum_Total", "{0:N2}") %>' />
                                    </td>
                                    <td class="right padded">
                                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("DepAcum_AnoActual", "{0:N2}") %>' />
                                    </td>
                                    <td class="right padded">
                                        <asp:Label ID="Label8" runat="server" 
                                                   Text='<%# ((decimal)Eval("MontoADepreciar") - (decimal)Eval("DepAcum_Total")).ToString("N2") %>' />
                                    </td>
                                </tr>     
                            </ItemTemplate>

                            <AlternatingItemTemplate>
                                <tr class="ListViewAlternatingRow">
                                    <td class="padded">
                                        <asp:ImageButton ID="SelectItems_Button" runat="server" AlternateText="***" CommandName="Select"
                                            ImageUrl="~/Pictures/SelectRecord.png" ToolTip="... click para seleccionar el registro" />
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="ciaContab" runat="server" Text='<%# Eval("InventarioActivosFijo.Compania.Abreviatura") %>' />
                                    </td>
                                    <td class="center padded">
                                        <asp:Label ID="moneda" runat="server" Text='<%# Eval("InventarioActivosFijo.Moneda1.Simbolo") %>' />
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="DebitosLabel" runat="server" 
                                        Text='<%# Eval("InventarioActivosFijo.tDepartamento.Descripcion").ToString().Length <= 10 ? 
                                                  Eval("InventarioActivosFijo.tDepartamento.Descripcion") : 
                                                  Eval("InventarioActivosFijo.tDepartamento.Descripcion").ToString().Substring(0, 10) %>' />
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="CreditosLabel" runat="server" 
                                        Text='<%# Eval("InventarioActivosFijo.TiposDeProducto.Descripcion").ToString().Length <= 10 ?
                                                  Eval("InventarioActivosFijo.TiposDeProducto.Descripcion") :
                                                  Eval("InventarioActivosFijo.TiposDeProducto.Descripcion").ToString().Substring(0, 10)%>' />
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="SaldoActualLabel" runat="server" Text='<%# Eval("InventarioActivosFijo.Proveedore.Abreviatura") %>' />
                                    </td>
                                    <td class="left padded" style="white-space:nowrap; ">
                                        <a href="javascript:PopupWin('../ConsultaActivosFijos/ActivoFijo_page.aspx?ID=' + <%# Eval("InventarioActivosFijo.ClaveUnica") %>, 1000, 680)">
                                            <%#Eval("InventarioActivosFijo.Producto")%>
                                        </a>
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="Label6" runat="server" 
                                        Text='<%# Eval("InventarioActivosFijo.Descripcion").ToString().Length <= 20 ?
                                                  Eval("InventarioActivosFijo.Descripcion") :
                                                  Eval("InventarioActivosFijo.Descripcion").ToString().Substring(0, 20)%>' />
                                    </td>
                                    <td class="padded" style="white-space:nowrap; text-align: center; ">
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("InventarioActivosFijo.FechaCompra", "{0:M-yy}") %>' />
                                    </td>

                                    <td class="padded" style="white-space:nowrap; text-align: center; ">
                                        <asp:Label ID="Label13" runat="server" Text='<%# Eval("InventarioActivosFijo.FechaDesincorporacion", "{0:M-yy}") %>' />
                                    </td>

                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label14" runat="server" Text='<%# Eval("DepreciarHastaMes") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label15" runat="server" Text='<%# Eval("DepreciarHastaAno") %>' />
                                    </td>

                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label9" runat="server" Text='<%# Eval("InventarioActivosFijo.CantidadMesesADepreciar") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label10" runat="server" Text='<%# Eval("DepAcum_CantMeses_AnoActual") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label11" runat="server" Text='<%# Eval("DepAcum_CantMeses") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label12" runat="server"  
                                                   Text='<%# (short)Eval("CantidadMesesADepreciar") - (short)Eval("DepAcum_CantMeses") %>' />
                                    </td>

                                    <td class="right padded">
                                        <asp:Label ID="Label3" runat="server" Text='<%# Eval("InventarioActivosFijo.MontoADepreciar", "{0:N2}") %>' />
                                    </td>
                                    <td class="right padded">
                                        <asp:Label ID="Label4" runat="server" Text='<%# Eval("DepreciacionMensual", "{0:N2}") %>' />
                                    </td>
                                    <td class="right padded">
                                        <asp:Label ID="Label5" runat="server" Text='<%# Eval("DepAcum_Total", "{0:N2}") %>' />
                                    </td>
                                    <td class="right padded">
                                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("DepAcum_AnoActual", "{0:N2}") %>' />
                                    </td>
                                    <td class="right padded">
                                        <asp:Label ID="Label8" runat="server" 
                                                   Text='<%# ((decimal)Eval("MontoADepreciar") - (decimal)Eval("DepAcum_Total")).ToString("N2") %>' />
                                    </td>
                                </tr>    
                            </AlternatingItemTemplate>

                            <SelectedItemTemplate>
                                <tr class="ListViewSelectedRow">
                                    <td class="padded">
                                        <asp:ImageButton ID="SelectItems_Button" runat="server" AlternateText="***" CommandName="Select"
                                            ImageUrl="~/Pictures/SelectedRecord.png" ToolTip="... click para seleccionar el registro" />
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="SaldoAnteriorLabel" runat="server" Text='<%# Eval("InventarioActivosFijo.Compania.Abreviatura") %>' />
                                    </td>
                                    <td class="center padded">
                                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("InventarioActivosFijo.Moneda1.Simbolo") %>' />
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="DebitosLabel" runat="server" 
                                        Text='<%# Eval("InventarioActivosFijo.tDepartamento.Descripcion").ToString().Length <= 10 ? 
                                                    Eval("InventarioActivosFijo.tDepartamento.Descripcion") : 
                                                    Eval("InventarioActivosFijo.tDepartamento.Descripcion").ToString().Substring(0, 10) %>' />
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="CreditosLabel" runat="server" 
                                        Text='<%# Eval("InventarioActivosFijo.TiposDeProducto.Descripcion").ToString().Length <= 10 ?
                                                    Eval("InventarioActivosFijo.TiposDeProducto.Descripcion") :
                                                    Eval("InventarioActivosFijo.TiposDeProducto.Descripcion").ToString().Substring(0, 10)%>' />
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="SaldoActualLabel" runat="server" Text='<%# Eval("InventarioActivosFijo.Proveedore.Abreviatura") %>' />
                                    </td>
                                    <td class="left padded" style="white-space:nowrap; ">
                                        <a href="javascript:PopupWin('../ConsultaActivosFijos/ActivoFijo_page.aspx?ID=' + <%# Eval("InventarioActivosFijo.ClaveUnica") %>, 1000, 680)">
                                            <%#Eval("InventarioActivosFijo.Producto")%>
                                        </a>
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="Label6" runat="server" 
                                        Text='<%# Eval("InventarioActivosFijo.Descripcion").ToString().Length <= 20 ?
                                                    Eval("InventarioActivosFijo.Descripcion") :
                                                    Eval("InventarioActivosFijo.Descripcion").ToString().Substring(0, 20)%>' />
                                    </td>
                                    <td class="padded" style="white-space:nowrap; text-align: center; ">
                                        <asp:Label ID="Label1" runat="server" Text='<%# Eval("InventarioActivosFijo.FechaCompra", "{0:M-yy}") %>' />
                                    </td>

                                    <td class="padded" style="white-space:nowrap; text-align: center; ">
                                        <asp:Label ID="Label13" runat="server" Text='<%# Eval("InventarioActivosFijo.FechaDesincorporacion", "{0:M-yy}") %>' />
                                    </td>

                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label14" runat="server" Text='<%# Eval("DepreciarHastaMes") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label15" runat="server" Text='<%# Eval("DepreciarHastaAno") %>' />
                                    </td>

                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label9" runat="server" Text='<%# Eval("InventarioActivosFijo.CantidadMesesADepreciar") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label10" runat="server" Text='<%# Eval("DepAcum_CantMeses_AnoActual") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label11" runat="server" Text='<%# Eval("DepAcum_CantMeses") %>' />
                                    </td>
                                    <td class="padded" style="text-align: center; ">
                                        <asp:Label ID="Label12" runat="server"  
                                                    Text='<%# (short)Eval("CantidadMesesADepreciar") - (short)Eval("DepAcum_CantMeses") %>' />
                                    </td>
                                    <td class="right padded">
                                        <asp:Label ID="Label3" runat="server" Text='<%# Eval("InventarioActivosFijo.MontoADepreciar", "{0:N2}") %>' />
                                    </td>
                                    <td class="right padded">
                                        <asp:Label ID="Label4" runat="server" Text='<%# Eval("DepreciacionMensual", "{0:N2}") %>' />
                                    </td>
                                    <td class="right padded">
                                        <asp:Label ID="Label5" runat="server" Text='<%# Eval("DepAcum_Total", "{0:N2}") %>' />
                                    </td>
                                    <td class="right padded">
                                        <asp:Label ID="Label7" runat="server" Text='<%# Eval("DepAcum_AnoActual", "{0:N2}") %>' />
                                    </td>
                                    <td class="right padded">
                                        <asp:Label ID="Label8" runat="server" 
                                                    Text='<%# ((decimal)Eval("MontoADepreciar") - (decimal)Eval("DepAcum_Total")).ToString("N2") %>' />
                                    </td>
                                </tr>    
                            </SelectedItemTemplate>
                            
                            <EmptyDataTemplate>
                                <table id="Table1" runat="server" style="background-color: #FFFFFF; border-collapse: collapse;
                                    border-color: #999999; border-style: none; border-width: 1px;">
                                    <tr>
                                        <td>
                                            No se ha seleccionado información para mostrar
                                        </td>
                                    </tr>
                                </table>
                            </EmptyDataTemplate>
                        </asp:ListView>
   
                    </ContentTemplate>
                </asp:UpdatePanel>
            </td>
        </tr>
    </table>

    <%--  varios sql datasources y popup de compañías (y sus cierres bancarios) --%>
    <div>

        <asp:EntityDataSource ID="tTempActivosFijos_ConsultaDepreciacion_EntityDataSource" runat="server" 
                            EnableFlattening="False" 
                            Include="InventarioActivosFijo, 
                                     InventarioActivosFijo.Compania, 
                                     InventarioActivosFijo.Proveedore, 
                                     InventarioActivosFijo.TiposDeProducto, 
                                     InventarioActivosFijo.tDepartamento, 
                                     InventarioActivosFijo.Moneda1"
                            EntitySetName="tTempActivosFijos_ConsultaDepreciacion"
                            Where="it.NombreUsuario = @NombreUsuario" 
                            OrderBy="it.InventarioActivosFijo.Compania.Nombre, 
                                     it.InventarioActivosFijo.tDepartamento.Descripcion, 
                                     it.InventarioActivosFijo.TiposDeProducto.Descripcion, 
                                     it.InventarioActivosFijo.FechaCompra" 
                            ContextTypeName="ContabSysNet_Web.ModelosDatos_EF.ActivosFijos.dbContab_ActFijos_Entities">
                            <WhereParameters>
                                <asp:Parameter Name="NombreUsuario" Type="String" />
                            </WhereParameters>
        </asp:EntityDataSource>
        
    </div>
</asp:Content>
<%--  footer place holder --%>
<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
    <br />
</asp:Content>