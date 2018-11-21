<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="BalanceComprobacion_Filter.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.BalanceComprobacion.BalanceComprobacion_Filter" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <link href="../../../radcalendar.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="notsosmallfont" style="padding-left: 25px; padding-right: 25px; padding-bottom: 25px;">
        
        <asp:ValidationSummary ID="ValidationSummary1" runat="server" class=" errmessage_background generalfont errmessage" ForeColor="" />
        <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="CustomValidator" /> 
        <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />

        <cc1:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" style="text-align: left; ">
            <cc1:TabPanel HeaderText="Generales" runat="server" ID="TabPanel1">
                <ContentTemplate>
                    <div style="text-align: left;" class="generalfont">
                        &nbsp;&nbsp;Período: &nbsp;&nbsp;
                        <asp:TextBox ID="Desde_TextBox" runat="server" Width="105px"></asp:TextBox>
                        <cc1:CalendarExtender ID="Desde_TextBox_CalendarExtender" runat="server" Enabled="True"
                            Format="dd-MM-yy" PopupButtonID="DesdeCalendar_PopUpButton" CssClass="radcalendar"
                            TargetControlID="Desde_TextBox">
                        </cc1:CalendarExtender>
                        <asp:ImageButton ID="DesdeCalendar_PopUpButton" runat="server" alt="" src="../../../Pictures/Calendar.png"
                            CausesValidation="False" TabIndex="-1" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="Desde_TextBox"
                            CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="Ud. debe indicar una fecha">*</asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToValidate="Desde_TextBox"
                            CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El valor indicado no es válido. Debe ser una fecha."
                            Operator="DataTypeCheck" Type="Date">*</asp:CompareValidator>
                        &nbsp;&nbsp;/&nbsp;&nbsp;
                        <asp:TextBox ID="Hasta_TextBox" runat="server" Width="105px"></asp:TextBox>
                        <cc1:CalendarExtender ID="Hasta_TextBox_CalendarExtender" runat="server" Enabled="True"
                            Format="dd-MM-yy" PopupButtonID="HastaCalendar_PopUpButton" CssClass="radcalendar"
                            TargetControlID="Hasta_TextBox">
                        </cc1:CalendarExtender>
                        <asp:ImageButton ID="HastaCalendar_PopUpButton" runat="server" alt="" src="../../../Pictures/Calendar.png"
                            CausesValidation="False" TabIndex="-1" />
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="Hasta_TextBox"
                            CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="Ud. debe indicar una fecha">*</asp:RequiredFieldValidator>
                        <asp:CompareValidator ID="CompareValidator2" runat="server" ControlToValidate="Hasta_TextBox"
                            CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El valor indicado no es válido. Debe ser una fecha."
                            Operator="DataTypeCheck" Type="Date">*</asp:CompareValidator>
                        <asp:CompareValidator ID="CompareValidator3" runat="server" ControlToValidate="Hasta_TextBox"
                            CssClass="errmessage generalfont" Display="Dynamic" ErrorMessage="El intervalo indicado no es válido."
                            Operator="GreaterThanEqual" Type="Date" ControlToCompare="Desde_TextBox">*</asp:CompareValidator>
                            
                            
                    </div>
                    <br /><br />
                    <fieldset style="text-align:left; " class="generalfont">
                        <legend style="color: Navy; ">Cuentas contables sin movimientos en el período indicado:</legend>
                        <asp:CheckBox ID="MostrarCuentasSinSaldoYSinMvtos_CheckBox" 
                                      cssclass="generalfont"
                                      runat="server" 
                                      Text="Mostrar cuentas con saldo inicial del período igual a cero" />
                        <br />
                        <asp:CheckBox ID="MostrarCuentasConSaldoYSinMvtos_CheckBox" 
                                      cssclass="generalfont"
                                      runat="server" 
                                      Text="Mostrar cuentas con saldo inicial del período diferente a cero"
                                      Checked="True" />
                    </fieldset>
                    <br />
                    <br />
                    <div style="border: 1px solid #C0C0C0; text-align:left; padding:10px; " class="generalfont">

                        <asp:CheckBox ID="MostrarCuentasConSaldosEnCero_CheckBox" 
                                      cssclass="generalfont"
                                      runat="server" 
                                      Checked="False" 
                                      Text="Mostrar cuentas con saldos, inicial y final, en cero " />
                        <br />
                        <asp:CheckBox ID="MostrarCuentasConSaldoFinalEnCero_CheckBox" 
                                      cssclass="generalfont"
                                      runat="server" 
                                      Checked="True" 
                                      Text="Mostrar cuentas con saldo final en cero " />
                        <br />
                        <asp:CheckBox ID="ExcluirAsientosTipoCierreAnual_CheckBox" 
                                      cssclass="generalfont"
                                      runat="server" 
                                      Checked="True" 
                                      Text="Excluir asientos de tipo 'cierre anual' " />
                    </div>
                            
                </ContentTemplate>
            </cc1:TabPanel>
            <cc1:TabPanel HeaderText="Compañías, monedas" runat="server" ID="TabPanel2">
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
                        </tr>
                        <tr>
                            <td>
                                <asp:ListBox ID="Sql_CuentasContables_Cia_Numeric" 
                                runat="server" DataTextField="NombreCorto" 
                                               DataValueField="Numero" 
                                               Height="193px" 
                                               SelectionMode="Single"
                                               Width="200px" 
                                               CssClass="notsosmallfont" />
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                            <td>
                                <asp:ListBox ID="Sql_SaldosContables_Moneda_Numeric" runat="server" DataSourceID="Monedas_SqlDataSource"
                                    DataTextField="Descripcion" DataValueField="Moneda" Height="193px" SelectionMode="Multiple"
                                    Width="200px" CssClass="notsosmallfont"></asp:ListBox>
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </cc1:TabPanel>
            <cc1:TabPanel HeaderText="Cuentas contables" runat="server" ID="TabPanel3">
                <ContentTemplate>
                <table>
                        <tr>
                            <td class="ListViewHeader_Suave generalfont">
                                Cuentas contables
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:ListBox ID="Sql_CuentasContables_Cuenta_String" 
                                             runat="server" 
                                             DataSourceID="CuentasContables_SqlDataSource"
                                             DataTextField="CuentaContableYNombre" 
                                             DataValueField="Cuenta" 
                                             Height="193px"
                                             SelectionMode="Multiple" 
                                             Width="350px" 
                                             CssClass="smallfont" />


                                <cc1:ListSearchExtender ID="ListSearchExtender1" 
                                                        runat="server" 
                                                        TargetControlID="Sql_CuentasContables_Cuenta_String" 
                                                        PromptText="Escriba para buscar ..." 
                                                        QueryPattern="Contains" 
                                                        PromptPosition="Bottom" 
                                                        PromptCssClass="smallfont_blue" />

                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: left;" class="generalfont">
                                <br />
                                Cuenta contable:&nbsp;&nbsp;<asp:TextBox ID="Sql_CuentasContables2_Cuenta_String" runat="server" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </cc1:TabPanel>
        </cc1:TabContainer>
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
                        ClientIDMode="Static"
                        onclick="AplicarFiltro_Button_Click" />
            
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </div>

        <asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT Descripcion, Moneda FROM Monedas ORDER BY Descripcion">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="CuentasContables_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT CuentasContables.Cuenta + ' - ' + CuentasContables.Descripcion + ' (' + Companias.Abreviatura + ')' AS CuentaContableYNombre, CuentasContables.Cuenta FROM CuentasContables INNER JOIN Companias ON CuentasContables.Cia = Companias.Numero WHERE (CuentasContables.TotDet = 'D' And CuentasContables.ActSusp = 'A') ORDER BY Companias.NombreCorto, CuentasContables.Cuenta + N' ' + CuentasContables.Descripcion">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="TiposAsiento_SqlDataSource" runat="server" 
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
            SelectCommand="SELECT Tipo, Descripcion FROM TiposDeAsiento ORDER BY Tipo">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="ProvieneDe_SqlDataSource" runat="server" 
            ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
            SelectCommand="Select Distinct ProvieneDe From Asientos Where ProvieneDe &lt;&gt; '' And ProvieneDe Is Not Null Order By ProvieneDe">
        </asp:SqlDataSource>
        
    </div>
</asp:Content>
