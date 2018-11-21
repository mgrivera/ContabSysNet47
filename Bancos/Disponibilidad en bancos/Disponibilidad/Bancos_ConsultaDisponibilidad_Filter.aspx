<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="Bancos_Disponibilidad_en_bancos_Disponibilidad_Bancos_ConsultaDisponibilidad_Filter" Codebehind="Bancos_ConsultaDisponibilidad_Filter.aspx.cs" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../../../radcalendar.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

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

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
                style="display: block;">
            </span>

            <table style="width: 100%;">
                <tr>
                    <td colspan="3" style="padding: 15px; height: 17px;">
                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="errmessage generalfont errmessage_background" />
                        Consultar disponibilidad al &#160;&#160;
                        <asp:TextBox ID="FechaDisponibilidadAl_TextBox" runat="server" Width="105px"></asp:TextBox>
                        <cc1:CalendarExtender
                            ID="FechaDisponibilidadAl_TextBox_CalendarExtender" runat="server" Enabled="True"
                            Format="dd-MM-yy" PopupButtonID="Calendar_PopUpButton" CssClass="radcalendar"
                            TargetControlID="FechaDisponibilidadAl_TextBox">
                        </cc1:CalendarExtender>
                        <asp:ImageButton ID="Calendar_PopUpButton" runat="server" alt="" src="../../../Pictures/Calendar.png" CausesValidation="False" />
                        <asp:RequiredFieldValidator
                            ID="RequiredFieldValidator1" runat="server" ControlToValidate="FechaDisponibilidadAl_TextBox"
                            CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="Ud. debe indicar una fecha">*</asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="FechaDisponibilidadAl_TextBox"
                                CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El valor indicado no es válido. Debe ser una fecha."
                                Operator="DataTypeCheck" Type="Date">*</asp:CompareValidator>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 15px; text-align: left;">
                        Compañías
                        <asp:ListBox ID="Sql_CuentasBancarias_Cia_Numeric" runat="server" 
                            DataTextField="Nombre" DataValueField="Numero" Height="193px" SelectionMode="Multiple"
                            Width="200px" AutoPostBack="True" 
                            onselectedindexchanged="Sql_CuentasBancarias_Cia_Numeric_SelectedIndexChanged"></asp:ListBox>
                    </td>
                    <td style="padding: 15px; text-align: left">
                        Monedas
                        <asp:ListBox ID="Sql_CuentasBancarias_Moneda_Numeric" runat="server" DataSourceID="Monedas_SqlDataSource"
                            DataTextField="Descripcion" DataValueField="Moneda" Height="193px" SelectionMode="Multiple"
                            Width="200px" AutoPostBack="True" 
                            onselectedindexchanged="Sql_CuentasBancarias_Moneda_Numeric_SelectedIndexChanged"></asp:ListBox>
                    </td>
                    <td style="padding: 15px; text-align: left">
                        Cuentas bancarias
                        <asp:ListBox ID="Sql_CuentasBancarias_CuentaInterna_Numeric" runat="server" DataSourceID="CuentasBancarias_SqlDataSource"
                            DataTextField="NombreCuentaBancaria" DataValueField="CuentaInterna" Height="193px"
                            SelectionMode="Multiple" Width="358px" Style="margin-left: 0px" class="notsosmallfont">
                        </asp:ListBox>
                    </td>
                </tr>
            </table>

        </ContentTemplate>
    </asp:UpdatePanel>
    
    <br />
    <br />
    <div style="text-align: right; padding-right: 25px; padding-bottom: 15px;  ">
        <asp:Button ID="LimpiarFiltro_Button" runat="server" Text="Limpiar filtro" 
            CausesValidation="False" onclick="LimpiarFiltro_Button_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Button ID="Button1" runat="server" Text="Aplicar filtro" 
            onclick="AplicarFiltro_Button_Click" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    </div>

    <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
        SelectCommand="SELECT Moneda, Descripcion FROM Monedas ORDER BY Descripcion">
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="CuentasBancarias_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
        SelectCommand="SELECT CuentasBancarias.CuentaInterna, Bancos.Abreviatura + N' - ' + Monedas.Simbolo + N' - ' + CuentasBancarias.CuentaBancaria + N' - ' + Companias.Abreviatura AS NombreCuentaBancaria FROM CuentasBancarias INNER JOIN Agencias On CuentasBancarias.Agencia = Agencias.Agencia Inner Join Bancos ON Agencias.Banco = Bancos.Banco INNER JOIN Monedas ON CuentasBancarias.Moneda = Monedas.Moneda INNER JOIN Companias ON CuentasBancarias.Cia = Companias.Numero WHERE (Bancos.NombreCorto IS NOT NULL) AND (Monedas.Simbolo IS NOT NULL) AND (CuentasBancarias.CuentaBancaria IS NOT NULL) AND (CuentasBancarias.Estado = 'AC') ORDER BY Bancos.NombreCorto, Monedas.Simbolo, CuentasBancarias.CuentaBancaria">
    </asp:SqlDataSource>
                                  
</asp:Content>

