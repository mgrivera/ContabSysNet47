<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="ContabSysNet_Web.Bancos.ConsultasBancos.MovimientosBancarios.MovimientosBancarios_OrdenesPago" Codebehind="MovimientosBancarios_OrdenesPago.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <asp:HiddenField ID="FileName_HiddenField" runat="server" />

    <asp:ValidationSummary ID="ValidationSummary1" 
                           runat="server" 
                           class="errmessage_background generalfont errmessage"
                           ForeColor="" 
                           DisplayMode="SingleParagraph" />

    <asp:CustomValidator ID="CustomValidator1" 
                         runat="server" />

    <span id="Message_Span" 
          runat="server" 
          class="infomessage infomessage_background generalfont" 
          style="display: block; width: 75%; " />

    <div style="margin: 5px;" class="generalfont">

        <h3>&nbsp;&nbsp;&nbsp;Obtención de ordenes de pago para movimientos bancarios&nbsp;&nbsp;&nbsp;</h3>

        <fieldset style="width: 85%; text-align: center; ">
            <legend>Soportes: </legend>

                <asp:CheckBoxList ID="Soportes_CheckBoxList" 
                                  style="text-align: left; "
                                  runat="server"
                                  DataSourceID="Soportes_SqlDataSource" 
                                  DataTextField="Descripcion" 
                                  DataValueField="ID" SelectionMode="Multiple" />

        </fieldset>

        <fieldset style="width: 85%; ">
            <legend>Personas: </legend>
                <table>
                    <tr>
                        <td>
                            Realizado por: 
                        </td>
                        <td>
                            <asp:DropDownList ID="RealizadoPor_DropDownList" 
                                  runat="server" 
                                  DataSourceID="Personas_SqlDataSource" 
                                  DataTextField="Nombre" 
                                  DataValueField="Empleado" 
                                  AppendDataBoundItems="True">
                                <asp:ListItem Text="Indefinido" Value="0" />
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Revisado por: 
                        </td>
                        <td>
                            <asp:DropDownList ID="RevisadoPor_DropDownList" 
                                  runat="server" 
                                  DataSourceID="Personas_SqlDataSource" 
                                  DataTextField="Nombre" 
                                  DataValueField="Empleado"
                                  AppendDataBoundItems="True">
                                  <asp:ListItem Text="Indefinido" Value="0" />
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Autorizado por (1): 
                        </td>
                        <td>
                            <asp:DropDownList ID="AutorizadoPor1_DropDownList" 
                                  runat="server" 
                                  DataSourceID="Personas_SqlDataSource" 
                                  DataTextField="Nombre" 
                                  DataValueField="Empleado" 
                                  AppendDataBoundItems="True">
                                  <asp:ListItem Text="Indefinido" Value="0" />
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Autorizado por (2): 
                        </td>
                        <td>
                            <asp:DropDownList ID="AutorizadoPor2_DropDownList" 
                                  runat="server" 
                                  DataSourceID="Personas_SqlDataSource" 
                                  DataTextField="Nombre" 
                                  DataValueField="Empleado"
                                  AppendDataBoundItems="True">
                                  <asp:ListItem Text="Indefinido" Value="0" />
                            </asp:DropDownList>
                        </td>
                    </tr>
                </table>
                
        </fieldset>

        <div style="margin: 20px 0px 0px 0px; text-align: right; padding-right: 25px; ">

            <asp:LinkButton ID="DownloadFile_LinkButton" 
                            runat="server" 
                            onclick="DownloadFile_LinkButton_Click" 
                            Visible="False" 
                            Text="Copiar el archivo al disco duro local" />
                     
            &nbsp;&nbsp;&nbsp;&nbsp;

            <asp:Button ID="Ok_Button" 
                    runat="server" 
                    Text="Construir archivo" 
                    onclick="Ok_Button_Click" />
        </div>

    </div>

    <asp:SqlDataSource ID="Soportes_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
    SelectCommand="SELECT ID, Descripcion FROM OrdenesPago_DescripcionSoportes ORDER BY Descripcion">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="Personas_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
        SelectCommand="SELECT Empleado, Nombre FROM tEmpleados Where Status = 'A' ORDER BY Nombre">
    </asp:SqlDataSource>
    
</asp:Content>
