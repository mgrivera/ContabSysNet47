<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage_1.master" CodeBehind="Pagos_page.aspx.cs" Inherits="ContabSysNet_Web.Bancos.ConsultasFacturas.Pagos.Pagos_page" %>
<%@ MasterType  virtualPath="~/MasterPage_1.master"%>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" Runat="Server">

   <script type="text/javascript">
       function PopupWin(url, w, h) {
           ///Parameters url=page to open, w=width, h=height
           window.open(url, "_blank", "width=" + w + ",height=" + h + ",resizable=yes,scrollbars=yes,status=no,location=no,toolbar=no,menubar=no,top=10px,left=8px");
       }
       function RefreshPage() {
           window.document.getElementById("RebindFlagSpan").firstChild.value = "1";
           window.document.forms(0).submit();
       }
</script>

<%--  para refrescar la página cuando el popup se cierra (y saber que el refresh es por eso) --%>
<span id="RebindFlagSpan">
    <asp:HiddenField ID="RebindFlagHiddenField" runat="server" Value="0" />
</span>
    
    <table style="width: 100%" class="miniminheight">
    
        <tr>
             <%--   column en la izquierda con links   --%>
            <td style="border: 1px solid #C0C0C0; width: 10%; vertical-align: top; background-color: #F7F7F7; text-align: center; ">
                <br />
               
                <a runat="server" 
                   id="filterLink"
                   href="javascript:PopupWin('Pagos_page_Filter.aspx', 1000, 600)">
                        <img id="Img3" 
                             border="0" 
                             runat="server"
                             alt="Para definir y aplicar un filtro que regrese los registros que se desea consultar" 
                             src="~/Pictures/filter_25x25.png" />
                </a>
                <br />
                <a href="javascript:PopupWin('Pagos_page_Filter.aspx', 1000, 600)">Definir y aplicar<br />un filtro</a>

                <hr />

                 <a runat="server" 
                   id="reportLink"
                   href="javascript:PopupWin('Pagos_OpcionesReportes.aspx', 1000, 600)">
                        <img id="Img4" 
                             runat="server"
                             border="0" 
                             alt="Para obtener un reporte que muestre los registros seleccionados" 
                             src="~/Pictures/print_25x25.png" />
                </a>
                <br />
                <a href="javascript:PopupWin('Pagos_OpcionesReportes.aspx', 1000, 600)">Reporte</a>

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

                        <asp:ListView ID="Pagos_ListView" 
                                      runat="server" 
                                      DataKeyNames="ClaveUnica"
                                      DataSourceID="Pagos_EntityDataSource" 
                                      
                            onpagepropertieschanged="Pagos_ListView_PagePropertiesChanged" 
                            onselectedindexchanging="Pagos_ListView_SelectedIndexChanging">

                            <LayoutTemplate>
                                <table id="Table1" runat="server" >
                                    <tr id="Tr1" runat="server">
                                        <td id="Td1" runat="server">
                                            <table id="itemPlaceholderContainer" runat="server" border="0"  
                                                    style="border: 1px solid #E6E6E6" class="smallfont" 
                                                    cellspacing="0" rules="none">

                                                <tr id="Tr2" runat="server" class="ListViewHeader">
                                                    <th class="padded" />
                                                    <th id="SaldoAnterior_ColumHeader" runat="server" class="padded" style="text-align: center;">
                                                        Fecha
                                                    </th>
                                                    <th id="Th5" runat="server" class="padded" style="text-align: left;">
                                                        Número
                                                    </th>
                                                    <th id="Th6" runat="server" class="padded" style="text-align: left;">
                                                        Compañía
                                                    </th>
                                                    <th id="SaldoActual_ColumHeader" runat="server" class="padded" style="text-align: center;">
                                                        Mi/Su
                                                    </th>
                                                    <th id="Th8" runat="server" class="left padded" style="text-align: center;">
                                                        Mon
                                                    </th>

                                                    <th id="Th11" runat="server" class="padded" style="text-align: left;">
                                                        Concepto
                                                    </th>
                                                    <th id="Th18" runat="server" class="padded" style="text-align: right;">
                                                        Monto
                                                    </th>

                                                    <th id="Th19" runat="server" class="padded" style="text-align: left;">
                                                        Cia contab
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
                                    <td class="center padded">
                                        <asp:DynamicControl ID="DynamicControl02" runat="server" DataField="Fecha" />
                                    </td>
                                    <td class="left padded" style="text-align: left; white-space:nowrap; ">
                                        <a href="javascript:PopupWin('Pago_page.aspx?ID=' + <%# Eval("ClaveUnica") %>, 1000, 680)">
                                            <%# NumeroPago_NoNulls(Eval("NumeroPago"))%>
                                        </a>
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="label01" runat="server" Text='<%# Eval("Proveedore.Abreviatura") %>' />
                                    </td>
                                    <td class="center padded" style="white-space:nowrap; ">
                                        <asp:DynamicControl ID="DynamicControl1" runat="server" DataField="MiSuFlag" />
                                    </td>
                                    <td class="center padded" style="white-space:nowrap; text-align: center; ">
                                         <asp:Label ID="label3" runat="server" Text='<%# Eval("Moneda1.Simbolo") %>' />
                                    </td>
                                    <td class="padded" style="white-space:nowrap; text-align: left; ">
                                        <asp:DynamicControl ID="DynamicControl08" runat="server" DataField="Concepto" />
                                    </td>
                                    <td class="padded" style="text-align: right; ">
                                        <asp:DynamicControl ID="DynamicControl10" runat="server" DataField="Monto" />
                                    </td>
                                    <td class="padded" style="text-align: left; ">
                                        <asp:Label ID="label5" runat="server" Text='<%# Eval("Compania.Abreviatura") %>' />
                                    </td>
                                </tr>     
                            </ItemTemplate>

                            <AlternatingItemTemplate>
                                <tr class="ListViewAlternatingRow">
                                   <td class="padded">
                                        <asp:ImageButton ID="SelectItems_Button" runat="server" AlternateText="***" CommandName="Select"
                                            ImageUrl="~/Pictures/SelectRecord.png" ToolTip="... click para seleccionar el registro" />
                                    </td>
                                    <td class="center padded">
                                        <asp:DynamicControl ID="DynamicControl02" runat="server" DataField="Fecha" />
                                    </td>
                                    <td class="left padded" style="text-align: left; white-space:nowrap; ">
                                        <a href="javascript:PopupWin('Pago_page.aspx?ID=' + <%# Eval("ClaveUnica") %>, 1000, 680)">
                                            <%# NumeroPago_NoNulls(Eval("NumeroPago"))%>
                                        </a>
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="label01" runat="server" Text='<%# Eval("Proveedore.Abreviatura") %>' />
                                    </td>
                                    <td class="center padded" style="white-space:nowrap; ">
                                        <asp:DynamicControl ID="DynamicControl1" runat="server" DataField="MiSuFlag" />
                                    </td>
                                    <td class="center padded" style="white-space:nowrap; text-align: center; ">
                                         <asp:Label ID="label3" runat="server" Text='<%# Eval("Moneda1.Simbolo") %>' />
                                    </td>
                                    <td class="padded" style="white-space:nowrap; text-align: left; ">
                                        <asp:DynamicControl ID="DynamicControl08" runat="server" DataField="Concepto" />
                                    </td>
                                    <td class="padded" style="text-align: right; ">
                                        <asp:DynamicControl ID="DynamicControl10" runat="server" DataField="Monto" />
                                    </td>
                                    <td class="padded" style="text-align: left; ">
                                        <asp:Label ID="label5" runat="server" Text='<%# Eval("Compania.Abreviatura") %>' />
                                    </td>
                                </tr>    
                            </AlternatingItemTemplate>

                            <SelectedItemTemplate>
                                <tr class="ListViewSelectedRow">
                                   <td class="padded">
                                    </td>
                                    <td class="center padded">
                                        <asp:DynamicControl ID="DynamicControl02" runat="server" DataField="Fecha" />
                                    </td>
                                    <td class="left padded" style="text-align: left; white-space:nowrap; ">
                                        <a href="javascript:PopupWin('Pago_page.aspx?ID=' + <%# Eval("ClaveUnica") %>, 1000, 680)">
                                            <%# NumeroPago_NoNulls(Eval("NumeroPago"))%>
                                        </a>
                                    </td>
                                    <td class="left padded">
                                        <asp:Label ID="label01" runat="server" Text='<%# Eval("Proveedore.Abreviatura") %>' />
                                    </td>
                                    <td class="center padded" style="white-space:nowrap; ">
                                        <asp:DynamicControl ID="DynamicControl1" runat="server" DataField="MiSuFlag" />
                                    </td>
                                    <td class="center padded" style="white-space:nowrap; text-align: center; ">
                                         <asp:Label ID="label3" runat="server" Text='<%# Eval("Moneda1.Simbolo") %>' />
                                    </td>
                                    <td class="padded" style="white-space:nowrap; text-align: left; ">
                                        <asp:DynamicControl ID="DynamicControl08" runat="server" DataField="Concepto" />
                                    </td>
                                    <td class="padded" style="text-align: right; ">
                                        <asp:DynamicControl ID="DynamicControl10" runat="server" DataField="Monto" />
                                    </td>
                                    <td class="padded" style="text-align: left; ">
                                        <asp:Label ID="label5" runat="server" Text='<%# Eval("Compania.Abreviatura") %>' />
                                    </td>
                                </tr>    
                            </SelectedItemTemplate>
                            
                            <EmptyDataTemplate>
                                <table id="Table1" runat="server" style="background-color: #FFFFFF; border-collapse: collapse;
                                    border-color: #999999; border-style: none; border-width: 1px;">
                                    <tr>
                                        <td>
                                            No se ha seleccionado información para mostrar; <br />
                                            Defina y aplique un filtro para mostrar información ... 
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

        <asp:EntityDataSource ID="Pagos_EntityDataSource" 
                              runat="server" 
                              ContextTypeName="ContabSysNet_Web.ModelosDatos_EF.Bancos.BancosEntities"
                              EnableFlattening="False" 
                              Include="Moneda1,
                                       Proveedore,
                                       Compania"
                              EntitySetName="Pagos"
                              OrderBy="it.Fecha, it.NumeroPago"
                              Where="1 == 1">
        </asp:EntityDataSource>
        
    </div>
</asp:Content>
<%--  footer place holder --%>
<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
    <br />
</asp:Content>