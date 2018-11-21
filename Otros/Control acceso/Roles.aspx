<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple_WithButtons.master" AutoEventWireup="true" Inherits="Otros_Control_acceso_Roles" Codebehind="Roles.aspx.cs" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<h4>Agregar/actualizar roles</h4>

 <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
        
<span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
            style="display: block;"></span>
    <asp:ListView ID="Roles_ListView" runat="server" 
        DataSourceID="ObjectDataSource1"
        InsertItemPosition="LastItem" DataKeyNames="RoleName" 
        oniteminserted="Roles_ListView_ItemInserted" 
                onitemdeleted="Roles_ListView_ItemDeleted">
        <LayoutTemplate>
            <table id="Table1" runat="server">
                <tr id="Tr1" runat="server">
                    <td id="Td1" runat="server">
                        <table id="itemPlaceholderContainer" runat="server" border="0" style="border: 1px solid #E6E6E6"
                            class="generalfont" cellspacing="0" rules="none">
                            <tr id="Tr2" runat="server" style="" class="ListViewHeader_Suave generalfont">
                                <th id="Th2" runat="server" class="ListViewColHeader">
                                    Acción
                                </th>
                                <th id="Th1" runat="server" class="padded" style="text-align: center; padding-bottom: 10px;">
                                    Nombre
                                </th>
                            </tr>
                            <tr id="itemPlaceholder" runat="server">
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="Tr3" runat="server">
                    <td id="Td2" runat="server" style="" class="generalfont">
                        <asp:DataPager ID="ComprobantesContables_DataPager" runat="server" PageSize="10">
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
                <td>
                    <asp:ImageButton ID="Delete_Button" runat="server" CommandName="Delete" Text="Delete"
                        ImageUrl="~/pictures/ListView_Buttons/delete_14x14.png" CausesValidation="False"
                        ToolTip="Eliminar" />
                    <cc1:ConfirmButtonExtender ID="ConfirmButtonExtender1" runat="server" TargetControlID="Delete_Button"
                        ConfirmText="¿Desea eliminar el registro?">
                    </cc1:ConfirmButtonExtender>
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="NombreTipoLabel" runat="server" Text='<%# Eval("RoleName") %>' />
                </td>
            </tr>
        </ItemTemplate>
        <InsertItemTemplate>
            <tr style="">
                <td>
                    <asp:ImageButton ID="Insert_Button" runat="server" CommandName="Insert" Text="Insert"
                        ImageUrl="~/pictures/ListView_Buttons/add_14x14.png" ValidationGroup="InsertValGroup"
                        ToolTip="Agregar" />
                    <asp:ImageButton ID="Cancel_Button" runat="server" CommandName="Cancel" Text="Clear"
                        ImageUrl="~/pictures/ListView_Buttons/undo1_14x14.png" CausesValidation="False"
                        ToolTip="Cancelar" />
                </td>
                <td>
                    <asp:TextBox runat="server" ID="RoleName_TextBox" Text='<%# Bind("RoleName") %>' />
                </td>
            </tr>
        </InsertItemTemplate>
        <EmptyDataTemplate>
            <table id="Table2" runat="server" style="">
                <tr>
                    <td>
                        <br />
                        Aún no se han definido roles. Comience a registrar roles desde aquí.
                    </td>
                </tr>
            </table>
        </EmptyDataTemplate>
    </asp:ListView>
    
    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
        SelectMethod="GetRoles" TypeName="AppRoles" DeleteMethod="Delete_Role" 
        InsertMethod="Create_Role" OldValuesParameterFormatString="original_{0}" >
        <DeleteParameters>
            <asp:Parameter Name="original_RoleName" Type="String" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="RoleName" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
    
    </ContentTemplate>
        </asp:UpdatePanel>

</asp:Content>

