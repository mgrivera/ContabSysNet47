<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_1.master" AutoEventWireup="true" Inherits="Bancos_Disponibilidad_en_bancos_Disponibilidad_ChequesNoEntregados" Codebehind="ChequesNoEntregados.aspx.cs" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PanelCentral_ContentPlaceHolder" Runat="Server">
 
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
    <%--  --%>
    <%-- div en la izquierda para mostrar funciones de la página --%>
    <%--  --%>
    <div class="notsosmallfont" style="width: 10%; border: 1px solid #C0C0C0; vertical-align: top;
        background-color: #F7F7F7; float: left; text-align: center; ">
        <br />
        <br />
        <img id="Filter_img" alt="Para definir y aplicar un filtro para seleccionar la información que desea consultar."
            runat="server" src="~/Pictures/filter_16x16.gif" />
        <a href="javascript:PopupWin('ChequesNoEntregados_Filter.aspx', 1000, 680)">Definir
            y aplicar un filtro</a>
        <hr />
        <br />
    </div>
    
     <div style="text-align: left; float: right; width: 88%;">
        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
            style="display: block;">
        </span>
        
         <asp:ListView ID="ChequesNoEntregados_ListView" runat="server" 
             DataKeyNames="ClaveUnica" 
             DataSourceID="ChequesNoEntregados_SqlDataSource" 
             onitemupdating="ChequesNoEntregados_ListView_ItemUpdating">
             
              <LayoutTemplate>
                 <table runat="server">
                     <tr runat="server">
                         <td runat="server">
                             <table ID="itemPlaceholderContainer" runat="server"  cellspacing="0" 
                                        class="notsosmallfont" rules="none" style="border: 1px solid #E6E6E6">
                                 <tr runat="server" class="ListViewHeader_Suave" style="">
                                    <th id="Th1" runat="server"></th>
                                     <th runat="server" class="padded" style="text-align: center; padding-bottom: 8px;
                                                padding-top: 8px;">
                                         Banco</th>
                                     <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                         Cuenta</th>
                                     <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                         Número</th>
                                     <th runat="server" class="padded" style="text-align: center; padding-bottom: 8px;
                                                padding-top: 8px;">
                                         Fecha</th>
                                     <th runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                         Beneficiario</th>
                                     <th runat="server" class="padded" style="text-align: right; padding-bottom: 8px;
                                                padding-top: 8px;">
                                         Monto</th>
                                     <th runat="server" class="padded" style="text-align: center; padding-bottom: 8px;
                                                padding-top: 8px;">
                                         F entregado</th>
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
                                        FirstPageImageUrl="~/Pictures/ListView_Buttons/PgFirst.gif" 
                                        FirstPageText="&lt;&lt;" NextPageText="&gt;" 
                                        PreviousPageImageUrl="~/Pictures/ListView_Buttons/PgPrev.gif" 
                                        PreviousPageText="&lt;" ShowFirstPageButton="True" ShowNextPageButton="False" 
                                        ShowPreviousPageButton="True" />
                                    <asp:NumericPagerField />
                                    <asp:NextPreviousPagerField ButtonType="Image" 
                                        LastPageImageUrl="~/Pictures/ListView_Buttons/PgLast.gif" 
                                        LastPageText="&gt;&gt;" 
                                        NextPageImageUrl="~/Pictures/ListView_Buttons/PgNext.gif" NextPageText="&gt;" 
                                        PreviousPageText="&lt;" ShowLastPageButton="True" ShowNextPageButton="True" 
                                        ShowPreviousPageButton="False" />
                                </Fields>
                             </asp:DataPager>
                         </td>
                     </tr>
                 </table>
             </LayoutTemplate>
             <ItemTemplate>
                 <tr style="">
                     <td>
                        <asp:ImageButton ID="Edit_Button" runat="server" CausesValidation="False" CommandName="Edit"
                            ImageUrl="~/Pictures/ListView_Buttons/edit_14x14.png" Text="Edit" ToolTip="Editar" />
                    </td>
                     <td class="padded" style="text-align: center;">
                         <asp:Label ID="NombreBancoLabel" runat="server" 
                             Text='<%# Eval("NombreBanco") %>' />
                     </td>
                    <td class="padded" style="text-align: left;">
                         <asp:Label ID="CuentaBancariaLabel" runat="server" 
                             Text='<%# Eval("CuentaBancaria") %>' />
                     </td>
                     <td class="padded" style="text-align: left;">
                         <asp:Label ID="TransaccionLabel" runat="server" 
                             Text='<%# Eval("Transaccion") %>' />
                     </td>
                     
                     <td class="padded" style="text-align: center;">
                         <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha", "{0:dd-MMM-yy}") %>' />
                     </td>
                     <td class="padded" style="text-align: left;">
                         <asp:Label ID="BeneficiarioLabel" runat="server" 
                             Text='<%# Eval("Beneficiario") %>' />
                     </td>
                     <td class="padded" style="text-align: right;">
                         <asp:Label ID="MontoLabel" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                     </td>
                     <td class="padded" style="text-align: center;">
                         <asp:Label ID="FechaEntregadoLabel" runat="server" 
                             Text='<%# Eval("FechaEntregado", "{0:dd-MMM-yy}") %>' />
                     </td>
                 </tr>
             </ItemTemplate>
            
            <AlternatingItemTemplate>
                <tr style="" class="ListViewAlternatingRow">
                     <td>
                        <asp:ImageButton ID="Edit_Button" runat="server" CausesValidation="False" CommandName="Edit"
                            ImageUrl="~/Pictures/ListView_Buttons/edit_14x14.png" Text="Edit" ToolTip="Editar" />
                    </td>
                     <td class="padded" style="text-align: center;">
                         <asp:Label ID="NombreBancoLabel" runat="server" 
                             Text='<%# Eval("NombreBanco") %>' />
                     </td>
                    <td class="padded" style="text-align: left;">
                         <asp:Label ID="CuentaBancariaLabel" runat="server" 
                             Text='<%# Eval("CuentaBancaria") %>' />
                     </td>
                     <td class="padded" style="text-align: left;">
                         <asp:Label ID="TransaccionLabel" runat="server" 
                             Text='<%# Eval("Transaccion") %>' />
                     </td>
                     
                     <td class="padded" style="text-align: center;">
                         <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha", "{0:dd-MMM-yy}") %>' />
                     </td>
                     <td class="padded" style="text-align: left;">
                         <asp:Label ID="BeneficiarioLabel" runat="server" 
                             Text='<%# Eval("Beneficiario") %>' />
                     </td>
                     <td class="padded" style="text-align: right;">
                         <asp:Label ID="MontoLabel" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                     </td>
                     <td class="padded" style="text-align: center;">
                         <asp:Label ID="FechaEntregadoLabel" runat="server" 
                             Text='<%# Eval("FechaEntregado", "{0:dd-MMM-yy}") %>' />
                     </td>
                 </tr>
            </AlternatingItemTemplate>
            <EditItemTemplate>
             <tr style="">
                      <td>
                        <asp:ImageButton ID="Update_Button" runat="server" CommandName="Update" Text="Update"
                            ImageUrl="~/pictures/ListView_Buttons/ok_14x14.png" ValidationGroup="EditValGroup"
                            ToolTip="Actualizar" />
                        <asp:ImageButton ID="Cancel_Button" runat="server" CommandName="Cancel" Text="Clear"
                            ImageUrl="~/pictures/ListView_Buttons/undo1_14x14.png" CausesValidation="False"
                            ToolTip="Cancelar" />
                    </td>
                     <td class="padded" style="text-align: center;">
                         <asp:Label ID="NombreBancoLabel" runat="server" Text='<%# Eval("NombreBanco") %>' />
                     </td>
                    <td class="padded" style="text-align: left;">
                         <asp:Label ID="CuentaBancariaLabel" runat="server" 
                             Text='<%# Eval("CuentaBancaria") %>' />
                     </td>
                     <td class="padded" style="text-align: left;">
                         <asp:Label ID="TransaccionLabel" runat="server" Text='<%# Eval("Transaccion") %>' />
                     </td>
                     
                     <td class="padded" style="text-align: center;">
                         <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha", "{0:dd-MMM-yy}") %>' />
                     </td>
                     <td class="padded" style="text-align: left;">
                         <asp:Label ID="BeneficiarioLabel" runat="server" Text='<%# Eval("Beneficiario") %>' />
                     </td>
                     <td class="padded" style="text-align: right;">
                         <asp:Label ID="MontoLabel" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                     </td>
                     <td class="padded" style="text-align: center;">
                         <asp:TextBox ID="FechaEntregadoTextBox" runat="server" Width="100px" Text='<%# Bind("FechaEntregado", "{0:dd-MMM-yy}") %>' />
                         <cc1:CalendarExtender
                            ID="FechaTextBox_CalendarExtender" runat="server" Enabled="True"
                            Format="dd-MM-yy" CssClass="radcalendar"
                            TargetControlID="FechaEntregadoTextBox">
                        </cc1:CalendarExtender>
                     </td>
                 </tr>
            </EditItemTemplate>
             <EmptyDataTemplate>
                 <table runat="server" style="">
                     <tr>
                         <td>
                             No hay información para mostrar. <br />Defina y aplique un filtro para mostrar información.</td>
                     </tr>
                 </table>
             </EmptyDataTemplate>
            
         </asp:ListView>
         
         <asp:SqlDataSource ID="ChequesNoEntregados_SqlDataSource" runat="server" 
             ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
             
             SelectCommand="SELECT MovimientosBancarios.ClaveUnica, Bancos.Abreviatura AS NombreBanco, MovimientosBancarios.Transaccion, 
             CuentasBancarias.CuentaBancaria, MovimientosBancarios.Fecha, MovimientosBancarios.Beneficiario, MovimientosBancarios.Monto, 
             MovimientosBancarios.FechaEntregado, MovimientosBancarios.UltMod 
             FROM Bancos 
             Inner Join Agencias On Bancos.Banco = Agencias.Banco
             INNER JOIN CuentasBancarias ON Agencias.Agencia = CuentasBancarias.Agencia 
             INNER JOIN Chequeras On CuentasBancarias.CuentaInterna = Chequeras.NumeroCuenta 
             INNER JOIN MovimientosBancarios ON Chequeras.NumeroChequera = MovimientosBancarios.ClaveUnicaChequera" 
             UpdateCommand="UPDATE MovimientosBancarios SET FechaEntregado = @FechaEntregado WHERE (ClaveUnica = @ClaveUnica)">
             <UpdateParameters>
                 <asp:Parameter Name="FechaEntregado" />
                 <asp:Parameter Name="ClaveUnica" />
             </UpdateParameters>
         </asp:SqlDataSource>
    </div>
    
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Footer_ContentPlaceHolder" Runat="Server">
<br />
</asp:Content>

