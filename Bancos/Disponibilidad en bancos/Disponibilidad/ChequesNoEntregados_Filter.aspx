<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="Bancos_Disponibilidad_en_bancos_Disponibilidad_ChequesNoEntregados_Filter" Codebehind="ChequesNoEntregados_Filter.aspx.cs" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<div style="text-align: left; margin-left: 20px; margin-right: 20px;  ">
 
        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
            style="display: block;">
        </span>

    <cc1:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0">
        <cc1:TabPanel ID="TabPanel1" runat="server" HeaderText="Generales" TabIndex="0">
            <ContentTemplate>
                <table cellspacing="10px">
                    <tr>
                        <td>
                            Fecha:
                        </td>
                        <td>
                            <asp:TextBox ID="Sql_MovimientosBancarios_Fecha_Date" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Monto:
                        </td>
                        <td>
                            <asp:TextBox ID="Sql_MovimientosBancarios_Monto_Numeric" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
        </cc1:TabPanel>
        <cc1:TabPanel ID="TabPanel2" runat="server" HeaderText="Listas" TabIndex="1">
            <ContentTemplate>
                <table>
                    <tr>
                        <td class="ListViewHeader_Suave generalfont">
                            Compañías
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td class="ListViewHeader_Suave generalfont">
                            Monedas
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td class="ListViewHeader_Suave generalfont">
                            Cuentas
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ListBox ID="Sql_CuentasBancarias_Cia_Numeric" runat="server"
                                DataTextField="NombreCorto" DataValueField="Numero"
                                Height="193px" SelectionMode="Multiple" Width="200px" CssClass="notsosmallfont">
                            </asp:ListBox>
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td>
                            <asp:ListBox ID="Sql_CuentasBancarias_Moneda_Numeric" runat="server"
                                DataSourceID="Monedas_SqlDataSource" DataTextField="Descripcion" DataValueField="Moneda"
                                Height="193px" SelectionMode="Multiple" Width="200px" CssClass="notsosmallfont">
                            </asp:ListBox>
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td>
                            <asp:ListBox ID="Sql_Chequeras_NumeroCuenta_Numeric" runat="server"
                                DataSourceID="CuentasBancarias_SqlDataSource" DataTextField="NombreCuentaBancaria"
                                DataValueField="CuentaInterna" Height="193px" SelectionMode="Multiple" Width="300px"
                                CssClass="notsosmallfont"></asp:ListBox>
                        </td>
                        <td>
                        </td>
                    </tr>
                </table>

                <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
                    SelectCommand="SELECT Moneda, Descripcion FROM Monedas ORDER BY Descripcion">
                </asp:SqlDataSource>
                <asp:SqlDataSource ID="CuentasBancarias_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
                    SelectCommand="SELECT CuentasBancarias.CuentaInterna, CuentasBancarias.CuentaBancaria + ' - ' + Bancos.Abreviatura AS NombreCuentaBancaria 
                    FROM CuentasBancarias 
                    Inner Join Agencias On CuentasBancarias.Agencia = Agencias.Agencia
                    INNER JOIN Bancos ON Agencias.Banco = Bancos.Banco 
                    ORDER BY Bancos.NombreCorto, CuentasBancarias.CuentaBancaria">
                </asp:SqlDataSource>
            </ContentTemplate>
        </cc1:TabPanel>
    </cc1:TabContainer>
    
     <div style="text-align: right; padding-top: 20px; ">
            <asp:Button ID="LimpiarFiltro_Button" runat="server" Text="Limpiar filtro" 
                CausesValidation="False" onclick="LimpiarFiltro_Button_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:Button ID="AplicarFiltro_Button" runat="server" Text="Aplicar filtro" 
                onclick="AplicarFiltro_Button_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </div>
    
    </div>
    
</asp:Content>

