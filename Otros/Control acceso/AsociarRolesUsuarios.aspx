<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple_WithButtons.master" AutoEventWireup="true" Inherits="Otros_Control_acceso_AsociarRolesUsuarios" Codebehind="AsociarRolesUsuarios.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <table class="notsosmallfont">
        <tr>
            <td colspan="3">
                <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
                    style="display: block;"></span>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                <span id="Message_Span" runat="server" class="generalfont" style="display: block;">
                </span>
            </td>
        </tr>
        <tr>
            <td>
                <table>
                    <tr>
                        <td class="ListViewHeader_Suave generalfont">
                            Roles
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ListBox ID="Roles_ListBox" runat="server" 
                                    Height="193px" SelectionMode="Multiple"
                                    Width="200px" CssClass="notsosmallfont" />
                        </td>
                    </tr>
                </table>
            </td>
            <td>
                <asp:LinkButton ID="LeerUsuarios_LinkButton" runat="server" 
                    CssClass="notsosmallfont" onclick="LeerUsuarios_LinkButton_Click">
                Leer usuarios para el rol seleccionado >>
                </asp:LinkButton>
                <br /><br />
                <asp:LinkButton ID="LeerRoles_LinkButton" runat="server" 
                    CssClass="notsosmallfont" onclick="LeerRoles_LinkButton_Click">
                << Leer roles para el usuario seleccionado
                </asp:LinkButton>
            
            
            </td>
            <td>
                <table>
                    <tr>
                        <td  class="ListViewHeader_Suave generalfont">
                            Usuarios
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ListBox ID="Usuarios_ListBox" runat="server" 
                                    Height="193px" SelectionMode="Multiple"
                                    Width="200px" CssClass="notsosmallfont" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
            Asociar los usuarios seleccionados<br /> al rol seleccionado<br />
                <asp:Button ID="AsociarUsuriosARolSeleccionado_Button" runat="server" 
                    Text="Efectuar asociación" 
                    onclick="AsociarUsuriosARolSeleccionado_Button_Click" />
            </td>
            <td>
            </td>
            <td>
            Asociar los roles seleccionados<br /> al usuario seleccionado<br />
            <asp:Button ID="AsociarRolesAUsurioSeleccionado_Button" runat="server" 
                    Text="Efectuar asociación" 
                    onclick="AsociarRolesAUsurioSeleccionado_Button_Click" />
            
            </td>
        </tr>
         <tr>
            <td colspan="3">
                <br />
                <div style="width: 80%; text-align: left; background-color: #EBEBEB; padding: 10px; ">
                <b>Nota importante:</b> seleccione (haciendo un click en alguno de los dos links) antes de efectuar<br /> la asociación (haciendo un click en alguno de los dos botones).
                </div>
            </td>
        </tr>
    </table>
</asp:Content>

