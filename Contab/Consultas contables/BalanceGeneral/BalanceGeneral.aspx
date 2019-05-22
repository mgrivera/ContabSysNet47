<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage_1.master" CodeBehind="BalanceGeneral.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.BalanceGeneral.BalanceGeneral" %>
<%@ MasterType  virtualPath="~/MasterPage_1.master"%>
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
       function RefreshPage()
       {
           //window.document.getElementById("RebindFlagSpan").firstChild.value = "1";
           //window.document.forms(0).submit();

           // nótese como usamos jquery para asignar el valor al field ... 
           $("#RebindFlagHiddenField").val("1");
           $("form").submit();
       }
</script>

<%--  para refrescar la página cuando el popup se cierra (y saber que el refresh es por eso) --%>
<span id="RebindFlagSpan">
    <asp:HiddenField ID="RebindFlagHiddenField" runat="server" Value="0" ClientIDMode="Static" />
</span>
    
    <div style="text-align: center; ">
        <asp:UpdatePanel ID="UpdatePanelValidationSummaryHome" ChildrenAsTriggers="false" UpdateMode="Conditional" runat="server">
            <ContentTemplate>
                <div ID="errorMessageDiv" runat="server" style="width: 80%; text-align: left; " class="errmessage_background generalfont errmessage" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

    <div class="notsosmallfont" style="width: 10%; border: 1px solid #C0C0C0; vertical-align: top; background-color: #F7F7F7; float: left; text-align: center; ">
        <br />
        <br />

        <a href="javascript:PopupWin('BalanceGeneral_Filter.aspx', 1000, 600)">Definir y aplicar<br /> un filtro</a><br />
        <i class="fas fa-filter fa-2x" style="margin-top: 5px; "></i>

        <hr />

        <a href="javascript:PopupWin('BalanceGeneral_OpcionesReportes.aspx', 1000, 600)">Reporte</a><br />
        <i class="fas fa-print fa-2x" style="margin-top: 5px; "></i>

        <hr />

        <a href="javascript:PopupWin('UltimoMesCerradoContable.aspx', 1000, 600)">Fechas de último<br /> cierre contable</a><br />
        <i class="fas fa-desktop fa-2x" style="margin-top: 5px; "></i>

        <hr />
        <br />
    </div>
    
    <div style="text-align: left; float: right; width: 88%;">
            
                <ajaxToolkit:UpdatePanelAnimationExtender ID="UpdatePanelAnimationExtender1" runat="server"
                    TargetControlID="UpdatePanel1" Enabled="True">
                    <Animations>
                        <OnUpdating>
                            <Parallel duration=".5">
                                <FadeOut minimumOpacity=".5" />
                            </Parallel>
                        </OnUpdating>
                        <OnUpdated>
                            <Parallel duration=".5">
                                <FadeIn minimumOpacity=".5" />
                            </Parallel>
                        </OnUpdated>
                    </Animations>
                </ajaxToolkit:UpdatePanelAnimationExtender>

                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Always">
                    <ContentTemplate>

                        <asp:ValidationSummary ID="ValidationSummary1" 
                                               runat="server" 
                                               class="errmessage_background generalfont errmessage"
                                               ShowModelStateErrors="true"
                                               ForeColor="" />

                        <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="CustomValidator" Display="None" EnableClientScript="False" />

                        <table style="border: 1px solid #C0C0C0; vertical-align: top; background-color: #EEEEEE;">
                            <tr>
                                <td>
                                    &nbsp;
                                    <span class="smallfont">Compañías:&nbsp;
                                        <asp:DropDownList ID="CompaniasFilter_DropDownList" 
                                                          runat="server" 
                                                          ItemType="ContabSysNet_Web.ModelosDatos_EF.Contab.Compania"
                                                          DataTextField="NombreCorto" 
                                                          DataValueField="Numero" 
                                                          AutoPostBack="True"
                                                          CssClass="smallfont" 
                                                          SelectMethod="CompaniasFilter_DropDownList_SelectMethod"
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
                                                          SelectMethod="MonedasFilter_DropDownList_SelectMethod"
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
                                        Nombre de la cuenta contable:&nbsp;
                                        <asp:TextBox ID="CuentaContableDescripcionFilter_TextBox"
                                                     runat="server" 
                                                     CssClass="smallfont"
                                                     AutoPostBack="True"  
                                                     OnTextChanged="AplicarMiniFiltro" />

                                        &nbsp;&nbsp; 
                                        <span class="smallfont">
                                        (<b>10:</b> todo lo que contenga 10; <b>10*:</b> todo lo que comience por 10; <b>*10:</b> todo lo que termine en 10) 
                                        </span>
                                    </span>
                                </td>
                            </tr>
                        </table>

                        <asp:GridView runat="server" 
                                        ID="BalanceGeneral_GridView"
                                        ItemType="ContabSysNet_Web.ModelosDatos_EF.Contab.Temp_Contab_Report_BalanceGeneral" 
                                        DataKeyNames="ID" 
                                        SelectMethod="BalanceGeneral_GridView_GetData"
                                        OnSelectedIndexChanged="BalanceGeneral_GridView_SelectedIndexChanged"
                                        OnPageIndexChanging="BalanceGeneral_GridView_PageIndexChanging"
                                        AutoGenerateColumns="False" 
                                        AllowPaging="True" 
                                        PageSize="15"  
                                        CssClass="Grid">
                            <Columns>
                                <asp:buttonfield CommandName="Select" Text="Select"/>

                                <asp:TemplateField HeaderText="Cuenta contable">
                                    <ItemTemplate>

                                        <a runat="server" 
                                           href='<%# GetDireccionWindowCuentasContables(Item.CuentaContableID, Item.Moneda, Item.CuentasContable.Cia) %>'>
                                        <%# Item.CuentasContable.Cuenta %></a>

                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Nombre">
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Item.CuentasContable.Descripcion %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Left" />
                                    <ItemStyle HorizontalAlign="Left" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Saldo inicial">
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Item.SaldoAnterior.ToString("N2") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Monto inicial<br/>(antes Desde)">
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Item.MontoInicioPeriodo.ToString("N2") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Debe">
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Item.Debe.ToString("N2") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Haber">
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Item.Haber.ToString("N2") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Saldo actual">
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Item.SaldoActual.ToString("N2") %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Right" />
                                    <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Cant<br/>movtos">
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Item.CantMovimientos %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:TemplateField>
                            </Columns>

                            <EmptyDataTemplate>
                                <br />
                                No hay registros que mostrar; probablemente no se han establecido criterios de ejecución y seleccionado registros (movimientos) ...
                            </EmptyDataTemplate> 

                            <SelectedRowStyle backcolor="LightCyan" forecolor="DarkBlue" font-bold="True" />  
                            <AlternatingRowStyle CssClass="GridAltItem" />
				            <RowStyle CssClass="GridItem" />
				            <HeaderStyle CssClass="GridHeader" />
				            <PagerStyle CssClass="GridPager" />
                            <EmptyDataRowStyle CssClass="GridEmptyData" />

                        </asp:GridView>

                        <%--para mostrar un diálogo que permita al usuario continuar/cancelar--%> 
                        <asp:Panel ID="pnlPopup" runat="server" CssClass="modalpopup" style="display:none">
                            <div class="popup_container" style="max-width: 500px; ">
                                <div class="popup_form_header" style="overflow: hidden; ">
                                    <div id="ModalPopupTitle_div" style="width: 85%; margin-top: 5px;  float: left;  ">
                                        <span runat="server" id="ModalPopupTitle_span" style="font-weight: bold; "/> 
                                    </div>
                                    <div style="width: 15%; float: right; ">
                                        <asp:ImageButton ID="ImageButton1" runat="server" OnClientClick="$find('popup').hide(); return false;" ImageUrl="~/Pictures/PopupCloseButton.png" />
                                    </div>
                                </div>
                                <div class="inner_container">
                                    <div class="popup_form_content">
                                        <span runat="server" id="ModalPopupBody_span" /> 
                                    </div>
                                    <div class="popup_form_footer">
                                        <asp:Button ID="btnOk" runat="server" Text="Continuar" OnClick="btnOk_Click" />
                                        <asp:Button ID="btnCancel" runat="server" Text="Cancelar" OnClientClick="$find('popup').hide(); return false;" Width="80px"/>
                                    </div>   
                                </div>                                          
                            </div>
                        </asp:Panel>

                        <asp:HiddenField ID="HiddenField1" runat="server" />
                        <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender1" 
                                                        runat="server" 
                                                        BehaviorID="popup" 
                                                        TargetControlID="HiddenField1" 
                                                        PopupControlID="pnlPopup" 
                                                        BackgroundCssClass="modalBackground" 
                                                        PopupDragHandleControlID="ModalPopupTitle_div" 
                                                        Drag="True" />

                    </ContentTemplate>
                </asp:UpdatePanel>
            <%--</td>
        </tr>
    </table>--%>

    </div>

    <div>
  
    </div>
</asp:Content>

<%--  footer place holder --%>
<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
    <br />
</asp:Content>