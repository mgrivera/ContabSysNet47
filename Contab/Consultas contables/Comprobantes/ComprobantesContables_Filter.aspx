<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="ComprobantesContables_Filter.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.Comprobantes.ComprobantesContables_Filter" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="../../../radcalendar.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="notsosmallfont" style="padding-left: 25px; padding-right: 25px; padding-bottom: 25px;">

        <asp:ValidationSummary ID="ValidationSummary1" runat="server" class=" errmessage_background generalfont errmessage" ForeColor="" />
        <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="CustomValidator" /> 
        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />

        <asp:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" style="text-align: left;">
            <asp:TabPanel HeaderText="Generales" runat="server" ID="TabPanel1">
                <ContentTemplate>
                    <div style="text-align: left;" class="generalfont">

                        <table>
                            <tr>
                                <td>Número</td>
                                <td>&nbsp;&nbsp;</td>
                                <td><asp:TextBox ID="Sql_Asientos_Numero_Numeric" runat="server" /></td>
                                <td>&nbsp;&nbsp;</td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>Período:</td>
                                <td>&nbsp;&nbsp;</td>
                                <td>
                                    <asp:TextBox ID="Desde_TextBox" runat="server" TextMode="Date" />

                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="Desde_TextBox"
                                        CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="Ud. debe indicar una fecha" Style="color: red; ">*</asp:RequiredFieldValidator>
                                </td>
                                <td>&nbsp;&nbsp;</td>
                                <td>
                                    <asp:TextBox ID="Hasta_TextBox" runat="server" TextMode="Date" />

                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="Hasta_TextBox"
                                        CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="Ud. debe indicar una fecha" Style="color: red; ">*</asp:RequiredFieldValidator>

                                    <asp:CompareValidator ID="CompareValidator3" runat="server" ControlToValidate="Hasta_TextBox"
                                        CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El intervalo indicado no es válido."
                                        Operator="GreaterThanEqual" Type="Date" ControlToCompare="Desde_TextBox" Style="color: red; ">*</asp:CompareValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>Lote:</td>
                                <td>&nbsp;&nbsp;</td>
                                <td><asp:TextBox ID="Sql_Asientos_Lote_String" runat="server" /></td>
                                <td>&nbsp;&nbsp;</td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>Cuenta contable: </td>
                                <td>&nbsp;&nbsp;</td>
                                <td><asp:TextBox ID="Sql_CuentasContables_Cuenta_String" runat="server" /></td>
                                <td>&nbsp;&nbsp;</td>
                                <td>(nota: puede usar * para generalizar; ej: 30101*)</td>
                            </tr>
                        </table>

                        <br />

                        <fieldset>
                            <legend>Asientos de tipo cierre anual: </legend>

                            <asp:CheckBox ID="ExcluirAsientosDeTipoCierreAnual_CheckBox" 
                                          runat="server" 
                                          Text="Excluir asientos de tipo Cierre Anual"
                                          Checked="False" />
                            <br />
                            <asp:CheckBox ID="SoloAsientosTipoCierreAnual_CheckBox" 
                                          runat="server" 
                                          Text="Solo asientos de tipo cierre anual"
                                          Checked="False" />

                            <br />
                            <asp:CheckBox ID="SoloAsientosDescuadrados_CheckBox" 
                                          runat="server" 
                                          Text="Solo asientos descuadrados (no use si va a usar la función <em>Copiar asientos</em>)"
                                          Checked="False" />

                            <br />
                            <asp:CheckBox ID="SoloAsientosConMas2Decimales_CheckBox" 
                                          runat="server" 
                                          Text="Solo asientos con montos con más de dos decimales"
                                          Checked="False" />
            
                        </fieldset>

                    </div>
                </ContentTemplate>
            </asp:TabPanel>
            <asp:TabPanel HeaderText="Compañías, monedas, tipos" runat="server" ID="TabPanel2">
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
                                Tipos de asiento
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:ListBox ID="Sql_Asientos_Cia_Numeric" 
                                             runat="server" 
                                             DataTextField="Nombre" 
                                             DataValueField="Numero" Height="193px" 
                                             SelectionMode="Multiple"
                                             Width="300px" 
                                             CssClass="notsosmallfont" />
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                            <td>
                                <asp:ListBox ID="Sql_Asientos_Moneda_Numeric" 
                                             runat="server" 
                                             DataSourceID="Monedas_SqlDataSource"
                                             DataTextField="Descripcion" 
                                             DataValueField="Moneda" Height="193px" 
                                             SelectionMode="Multiple"
                                             Width="200px" 
                                             CssClass="notsosmallfont" />
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                            <td>
                               <asp:ListBox ID="Sql_Asientos_Tipo_String" 
                                            runat="server" 
                                            DataSourceID="TiposAsiento_SqlDataSource"
                                            DataTextField="Descripcion" 
                                            DataValueField="Tipo" 
                                            Height="193px" 
                                            SelectionMode="Multiple"
                                            Width="250px" 
                                            CssClass="notsosmallfont" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:TabPanel>
            <asp:TabPanel HeaderText="'proviene de' y usuarios" runat="server" ID="TabPanel3">
                <ContentTemplate>
                <table>
                        <tr>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                            <td class="ListViewHeader_Suave generalfont">
                                Proviene de
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                            <td class="ListViewHeader_Suave generalfont">
                                Usuarios
                            </td>
                        </tr>
                        <tr>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                            <td>
                                 <asp:ListBox ID="Sql_Asientos_ProvieneDe_String" 
                                              runat="server" 
                                              DataSourceID="ProvieneDe_SqlDataSource"
                                              DataTextField="ProvieneDe" 
                                              DataValueField="ProvieneDe" 
                                              Height="193px" 
                                              SelectionMode="Multiple"
                                              Width="200px" 
                                              CssClass="notsosmallfont" />
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                            <td>
                                <asp:ListBox ID="Sql_Asientos_Usuario_String" 
                                              runat="server" 
                                              DataSourceID="Usuarios_SqlDataSource"
                                              DataTextField="Usuario" 
                                              DataValueField="Usuario" 
                                              Height="193px" 
                                              SelectionMode="Multiple"
                                              Width="200px" 
                                              CssClass="notsosmallfont" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:TabPanel>
        </asp:TabContainer>
        <br />
        <br />
        <br />
        <div style="text-align: right;">

            <asp:Button ID="LimpiarFiltro_Button" 
                        runat="server" 
                        Text="Limpiar filtro" 
                        CausesValidation="False" 
                        onclick="LimpiarFiltro_Button_Click" />
            
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

            <asp:Button ID="AplicarFiltro_Button" 
                        runat="server" 
                        Text="Aplicar filtro" 
                        onclick="AplicarFiltro_Button_Click" 
                        ClientIDMode="Static" />
            
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </div>

        <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT Descripcion, Moneda FROM Monedas ORDER BY Descripcion">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="TiposAsiento_SqlDataSource" runat="server" 
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
            SelectCommand="SELECT Tipo, Descripcion + ' - ' + Tipo As Descripcion FROM TiposDeAsiento ORDER BY Descripcion">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="ProvieneDe_SqlDataSource" runat="server" 
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
            SelectCommand="Select Distinct ProvieneDe From Asientos Where ProvieneDe &lt;&gt; '' And ProvieneDe Is Not Null Order By ProvieneDe">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="Usuarios_SqlDataSource" runat="server" 
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
            SelectCommand="Select Distinct Usuario From Asientos Order By Usuario">
        </asp:SqlDataSource>
        
    </div>
</asp:Content>
