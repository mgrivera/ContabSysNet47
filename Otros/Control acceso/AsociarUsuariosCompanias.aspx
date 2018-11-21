<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple_WithButtons.master" AutoEventWireup="true" Inherits="Otros_Control_acceso_AsociarUsuariosCompanias" Codebehind="AsociarUsuariosCompanias.aspx.cs" %>

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
                <span id="Message_Span" runat="server" class="generalfont infomessage infomessage_background" style="display: block;">
                </span>
            </td>
        </tr>
        <tr>
            <td>
                <table>
                    <tr>
                        <td class="ListViewHeader_Suave generalfont">
                            Companias
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ListBox ID="Companias_ListBox" 
                                         runat="server" 
                                         Height="193px" 
                                         SelectionMode="Multiple"
                                         Width="200px" 
                                         CssClass="notsosmallfont" />
                        </td>
                    </tr>
                </table>
            </td>
            <td>
                <asp:LinkButton ID="LeerUsuarios_LinkButton" runat="server" 
                    CssClass="notsosmallfont" onclick="LeerUsuarios_LinkButton_Click">
                Leer usuarios para la compañía seleccionada >>
                </asp:LinkButton>
                <br /><br />
                <asp:LinkButton ID="LeerCompanias_LinkButton" runat="server" 
                    CssClass="notsosmallfont" onclick="LeerCompanias_LinkButton_Click">
                << Leer compañías para el usuario seleccionado
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
                            <asp:ListBox ID="Usuarios_ListBox" 
                                         runat="server" 
                                         Height="193px" 
                                         SelectionMode="Single"
                                         Width="200px" 
                                         CssClass="notsosmallfont" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td>
            
            </td>
            <td>
            </td>
            <td>
            Asociar las compañías seleccionadas<br /> al usuario seleccionado<br />
            <asp:Button ID="AsociarCompaniasAUsurioSeleccionado_Button" 
                        runat="server" 
                        Text="Efectuar asociación" 
                        onclick="AsociarCompaniasAUsurioSeleccionado_Button_Click" />
            
            </td>
        </tr>
         <tr>
            <td colspan="3">
                <br />
                <div style="width: 80%; text-align: left; background-color: #EBEBEB; padding: 10px; ">
                    <p>
                        El objetivo de esta función es asociar compañías a usuarios. Si Ud. asocia una o más compañías a un usuario, éste 
                        solo podrá tener acceso a esa, o esas, compañías en Contab. 
                    </p>
                    <p>
                        <b>Mediante esta opción Ud. puede:</b> 
                    </p>
                    <p>
                        <b>1) </b> Saber cuales son las compañías asociadas a un usuario en particular 
                    </p>
                    <p>
                        <b>2) </b> Saber cuales son los usuarios que se han asociado a una compañía en particular 
                    </p>
                    <p>
                        <b>3) </b> Asociar una o más compañías a un usuario 
                    </p>
                </div>
            </td>
        </tr>
    </table>
</asp:Content>

