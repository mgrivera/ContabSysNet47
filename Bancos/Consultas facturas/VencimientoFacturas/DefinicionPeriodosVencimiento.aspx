<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="Bancos_VencimientoFacturas_DefinicionPeriodosVencimiento" Codebehind="DefinicionPeriodosVencimiento.aspx.cs" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div>


    <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="errmessage_background generalfont errmessage" DisplayMode="List" />
    <span id="ErrorMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display:none; text-align:left; "></span>

<h3 style="margin:5px;">Definición de períodos de vencimiento</h3>
    <asp:ListView ID="PeriodosVencimiento_ListView" runat="server" 
        DataKeyNames="CantidadDias" 
        DataSourceID="PeriodosVencimiento_LinqDataSource" InsertItemPosition="LastItem" 
        oniteminserted="PeriodosVencimiento_ListView_ItemInserted">
        <LayoutTemplate>
            <table id="Table1" runat="server" class="generalfont">
                <tr id="Tr1" runat="server">
                    <td id="Td1" runat="server">
                        <table ID="itemPlaceholderContainer" runat="server" border="0" style="" cellspacing="0">
                            <tr id="Tr2" runat="server" style="" class="ListViewHeader_Suave">
                                <th id="Th1" runat="server" class="ListViewColHeader">
                                    Acción
                                </th>
                                <th id="Th2" runat="server" class="ListViewColHeader" style="text-align:center;">
                                    Cantidad <br />de días
                                </th>
                            </tr>
                            <tr ID="itemPlaceholder" runat="server">
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="Tr3" runat="server">
                    <td id="Td2" runat="server" style="">
                        <asp:DataPager ID="DataPager1" runat="server">
                            <Fields>
                                    <asp:NextPreviousPagerField ButtonType="Link" FirstPageImageUrl="~/pictures/first_16x16.gif"
                                        FirstPageText="&lt;&lt;" NextPageText="&gt;" PreviousPageImageUrl="~/pictures/left_16x16.gif"
                                        PreviousPageText="&lt;" ShowFirstPageButton="True" ShowNextPageButton="False"
                                        ShowPreviousPageButton="True" />
                                    <asp:NumericPagerField />
                                    <asp:NextPreviousPagerField ButtonType="Link" LastPageImageUrl="~/pictures/last_16x16.gif"
                                        LastPageText="&gt;&gt;" NextPageImageUrl="~/pictures/right_16x16.gif" NextPageText="&gt;"
                                        PreviousPageText="&lt;" ShowLastPageButton="True" ShowNextPageButton="True" ShowPreviousPageButton="False" />
                                </Fields>
                        </asp:DataPager>
                    </td>
                </tr>
            </table>
        </LayoutTemplate>
        <ItemTemplate>
            <tr style="">
                <td class="ListViewNormalCell">
                        <asp:ImageButton ID="Delete_Button" runat="server" CommandName="Delete" Text="Delete"
                            ImageUrl="~/pictures/ListView_Buttons/delete_14x14.png" CausesValidation="False"  ToolTip="Eliminar"/>
                        <cc1:ConfirmButtonExtender ID="ConfirmButtonExtender1" runat="server" TargetControlID="Delete_Button"
                            ConfirmText="¿Desea eliminar el registro?">
                        </cc1:ConfirmButtonExtender>
                </td>
                <td class="ListViewNormalCell" style="text-align:center;">
                    <asp:Label ID="CuentaBancariaLabel" runat="server" Text='<%# Eval("CantidadDias") %>' />
                </td>
            </tr>
        </ItemTemplate>
        <InsertItemTemplate>
            <tr style="">
                <td style="padding-left: 15px;">
                    <asp:ImageButton ID="Insert_Button" runat="server" CommandName="Insert" Text="Insert"
                        ImageUrl="~/pictures/ListView_Buttons/add_14x14.png" ValidationGroup="InsertMode" ToolTip="Agregar"/>
                    <asp:ImageButton ID="Cancel_Button" runat="server" CommandName="Cancel" Text="Clear"
                        ImageUrl="~/pictures/ListView_Buttons/undo1_14x14.png" CausesValidation="False" ToolTip="Cancelar"/>
                </td>
                <td style="padding-left: 15px; text-align: left;">
                    <asp:TextBox ID="CantidadDias_TextBox" runat="server" Style="width: 50px;" Text='<%# Bind("CantidadDias") %>' />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Ud. debe indicar un valor en este campo!" ValidationGroup="InsertMode" ControlToValidate="CantidadDias_TextBox">*</asp:RequiredFieldValidator>
                </td>
            </tr>
        </InsertItemTemplate>
        <EmptyDataTemplate>
            <table id="Table2" runat="server" style="">
                <tr>
                    <td>
                        No data was returned.</td>
                </tr>
            </table>
        </EmptyDataTemplate>
    </asp:ListView>
   
<asp:LinqDataSource ID="PeriodosVencimiento_LinqDataSource" 
    runat="server" ContextTypeName="ContabSysNet_Web.Old_App_Code.dbBancosDataContext" 
    TableName="PeriodosVencimientos" EnableDelete="True" EnableInsert="True" 
        EnableUpdate="True" OrderBy="CantidadDias">
</asp:LinqDataSource>

</div>
</asp:Content>

