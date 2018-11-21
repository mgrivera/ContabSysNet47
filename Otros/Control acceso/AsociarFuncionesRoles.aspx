<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple_WithButtons.master" AutoEventWireup="true" Inherits="Otros_Control_acceso_AsociarFuncionesRoles" Codebehind="AsociarFuncionesRoles.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

 <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
   
    <table class="notsosmallfont>
        <tr>
            <td colspan="2">
            <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
                    style="display: block;"></span>
            </td>
        </tr>
        <tr>
            <td colspan="2">
            <span id="Message_Span" runat="server" class="generalfont" style="display: block;">
                </span>
            </td>
        </tr>
        <tr>
            <td style="vertical-align: top; ">
                <table>
                    <tr>
                        <td class="ListViewHeader_Suave generalfont">
                            Roles
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ListBox ID="Roles_ListBox" runat="server" 
                                    Height="193px" SelectionMode="Single"
                                    Width="200px" CssClass="notsosmallfont" AutoPostBack="True" 
                                onselectedindexchanged="Roles_ListBox_SelectedIndexChanged" />
                        </td>
                    </tr>
                </table>
            </td>
            <td style="vertical-align: top; ">
                <table>
                    <tr>
                        <td class="ListViewHeader_Suave generalfont">
                            Funciones de la aplicación
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left; ">
                            <div style="border-style: ridge; border-width: 1px; height: 250px; overflow: auto; ">
                                <asp:TreeView ID="TreeView1" runat="server" 
                                DataSourceID="SiteMapDataSource1" CssClass="notsosmallfont" ExpandDepth="FullyExpand" ShowCheckBoxes="All">
                                </asp:TreeView>
                            </div>    
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
                <asp:LinkButton ID="LimpiarSeleccion_LinkButton" runat="server" 
                    onclick="LimpiarSeleccion_LinkButton_Click">Limpiar selección</asp:LinkButton>
                &nbsp;&nbsp;&nbsp;
                <asp:LinkButton ID="MarcarTodo_LinkButton" runat="server" 
                    onclick="MarcarTodo_LinkButton_Click">Marcar todo</asp:LinkButton>
            </td>
            <td>
                <br />
                <asp:Button ID="RegistrarAsociaciones_Button" runat="server" 
                    Text="Registrar asociaciones" onclick="RegistrarAsociaciones_Button_Click" />
            </td>
        </tr>
    </table>
    <asp:SiteMapDataSource ID="SiteMapDataSource1" runat="server" />
    
    </ContentTemplate>
        </asp:UpdatePanel>
        
</asp:Content>

