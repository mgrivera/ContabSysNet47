<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="BalanceGeneral_Filter.aspx.cs" Inherits="ContabSysNetWeb.Contab.Consultas_contables.BalanceGeneral.BalanceGeneral_Filter" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<link href="../../../radcalendar.css" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div class="notsosmallfont" style="padding-left: 25px; padding-right: 25px; padding-bottom: 3px; text-align: left; ">

        <asp:UpdatePanelAnimationExtender ID="UpdatePanelAnimationExtender1" runat="server"
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
        </asp:UpdatePanelAnimationExtender>

        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

                <asp:ValidationSummary ID="ValidationSummary1" 
                                   runat="server" 
                                   class="errmessage_background generalfont errmessage"
                                   ShowModelStateErrors="true"
                                   ForeColor="" />

                <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont" style="display: block;" />

                <asp:CustomValidator ID="CustomValidator1" runat="server" ErrorMessage="CustomValidator" Display="None" EnableClientScript="False" />

                    <asp:tabcontainer id="TabContainer1" runat="server" activetabindex="0" TabStripPlacement="Top">

                        <asp:TabPanel HeaderText="Generales" runat="server" ID="TabPanel1" >

                            <ContentTemplate>
                                <br />
                                <asp:CalendarExtender ID="CalendarExtender1" 
                                    runat="server" 
                                    TodaysDateFormat="dd-MM-yyyy" 
                                    TargetControlID="Desde_TextBox" 
                                    Format="dd-MM-yyyy" Enabled="True" />

                                <asp:CalendarExtender ID="CalendarExtender2" 
                                    runat="server" 
                                    TodaysDateFormat="dd-MM-yyyy" 
                                    TargetControlID="Hasta_TextBox" 
                                    Format="dd-MM-yyyy" Enabled="True" />

                                Desde: 
                                <asp:TextBox ID="Desde_TextBox" runat="server" />
                                &nbsp;&nbsp;&nbsp; 
                                Hasta: 
                                <asp:TextBox ID="Hasta_TextBox" runat="server" />

                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Por favor indique un périodo válido." ControlToValidate="Desde_TextBox" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Por favor indique un périodo válido." ControlToValidate="Hasta_TextBox" Display="Dynamic" ForeColor="Red">*</asp:RequiredFieldValidator>
                                <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="Por favor indique un périodo válido." ControlToValidate="Desde_TextBox" Operator="DataTypeCheck" Type="Date" Display="Dynamic" ForeColor="Red">*</asp:CompareValidator>
                                <asp:CompareValidator ID="CompareValidator2" runat="server" ErrorMessage="Por favor indique un périodo válido." ControlToValidate="Hasta_TextBox" Operator="DataTypeCheck" Type="Date" Display="Dynamic" ForeColor="Red">*</asp:CompareValidator>
                                <asp:CompareValidator ID="CompareValidator3" runat="server" ErrorMessage="Por favor indique un périodo válido." ControlToValidate="Hasta_TextBox" Type="Date" ControlToCompare="Desde_TextBox" Operator="GreaterThanEqual" Display="Dynamic" ForeColor="Red">*</asp:CompareValidator>

                                <br /><br />

                                <fieldset style="border: 1px solid #C0C0C0; padding: 10px; ">
                                    <asp:RadioButton ID="BalanceGeneral_RadioButton" runat="server" GroupName="BalGen_GyP" Text="Balance General" />
                                    <fieldset style="border: 0px solid #C0C0C0; padding: 10px; margin-left: 25px; ">
                                        <%--<legend style="color: #0000FF">Balance general (solo):&nbsp;&nbsp;</legend>--%>
                                        <asp:CheckBox ID="BalGen_ExcluirGastosIngresos_CheckBox" 
                                                       runat="server" 
                                                       Text="Excluir cuentas contables de gastos e ingresos" />
                                        <br />
                                    </fieldset>
                                    <br />
                                    <asp:RadioButton ID="GyP_RadioButton" runat="server" GroupName="BalGen_GyP" Text="Ganancias y Pérdidas" />
                                </fieldset>

                                <br />

                                <ul>
                                    <li  style="list-style: none;"> 
                                        <asp:CheckBox ID="ExcluirCuentasSinSaldoNiMovtos_CheckBox" 
                                                      runat="server" 
                                                      Text="Excluir cuentas contables con saldo inicial, debe y haber en cero, para el período indicado" />
                                    </li>
                                    <li  style="list-style: none;"> 
                                        <asp:CheckBox ID="ExcluirCuentasSinMovimientos_CheckBox" 
                                                      runat="server" 
                                                      Text="Excluir cuentas contables sin movimientos en el período indicado" />
                                    </li>
                                    <li  style="list-style: none;"> 
                                        <asp:CheckBox ID="ExcluirAsientosContablesTipoCierreAnual_CheckBox" 
                                                      runat="server" 
                                                      Text="Excluir asientos contables del tipo cierre anual (si existen)" />
                                    </li>
                                </ul>

                                <br />

                                Cuenta contable:&nbsp; <asp:TextBox ID="Sql_it_Cuenta_String" runat="server"></asp:TextBox>

                            </ContentTemplate>

                        </asp:TabPanel>

                    <asp:TabPanel HeaderText="Lista (1)" runat="server" ID="TabPanel2" >

                        <ContentTemplate>

                            <table style="width: 100%; height: 100%;">
                                <tr>
                                    <td class="ListViewHeader_Suave smallfont2" style="text-align: center;">
                                        Cias contab
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;
                                    </td>
                                    <td class="ListViewHeader_Suave smallfont2" style="text-align: center;">
                                        Monedas
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;
                                    </td>
                                    <td class="ListViewHeader_Suave smallfont2" style="text-align: center;">
                                        Monedas (original)
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:ListBox ID="Sql_it_Cia_Numeric" 
                                                        runat="server" 
                                                        DataTextField="Nombre" 
                                                        DataValueField="Numero" 
                                                        AutoPostBack="true" 
                                                        SelectionMode="Single" 
                                                        onselectedindexchanged="Sql_Asientos_Cia_Numeric_SelectedIndexChanged" 
                                                        Rows="20" 
                                                        CssClass="smallfont" />
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;
                                    </td>
                                    <td>
                                         <asp:ListBox ID="Monedas_ListBox" 
                                                         Width="200px"
                                                         runat="server" 
                                                         DataSourceID="Monedas_SqlDataSource"
                                                         DataTextField="Descripcion" 
                                                         DataValueField="Moneda" 
                                                         AutoPostBack="False" 
                                                         SelectionMode="Single" 
                                                         Rows="20" 
                                                         CssClass="smallfont" />
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;
                                    </td>
                                    <td>
                                        <asp:ListBox ID="MonedasOriginales_ListBox" 
                                                         Width="200px"
                                                         runat="server" 
                                                         DataSourceID="Monedas_SqlDataSource"
                                                         DataTextField="Descripcion" 
                                                         DataValueField="Moneda" 
                                                         AutoPostBack="False" 
                                                         SelectionMode="Single" 
                                                         Rows="20" 
                                                         CssClass="smallfont" AppendDataBoundItems="True">
                                            <asp:ListItem Text="Ninguna" Value="0" />
                                        </asp:ListBox>
                                    </td>

                                </tr>
                            </table>

                        </ContentTemplate>
                    </asp:TabPanel>

                    <asp:TabPanel HeaderText="Lista (2)" runat="server" ID="TabPanel3" >

                        <ContentTemplate>

                            <table style="width: 100%; height: 100%;">
                                <tr>
                                    <td class="ListViewHeader_Suave smallfont2">
                                        <table style="width:100%; ">
                                            <tr>
                                                <td>
                                                    Cuentas contables&nbsp;&nbsp;
                                                </td>
                                                <td style="text-align: right; ">
                                                    <asp:TextBox ID="CuentasContablesFilter_TextBox"
                                                                 CssClass="smallfont"
                                                                 runat="server" 
                                                                 AutoPostBack="True" 
                                                                 ontextchanged="CuentasContablesFilter_TextBox_TextChanged" 
                                                                 style="width: 150px; margin-right: 10px; " />

                                                    <asp:TextBoxWaterMarkExtender ID="TextBoxWaterMarkExtender3" 
                                                                                  runat="server" 
                                                                                  WatermarkText="Escriba (y Enter) para buscar ..." 
                                                                                  TargetControlID="CuentasContablesFilter_TextBox" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>

                                    <td>
                                        &nbsp;&nbsp;
                                    </td>
                                    <td class="ListViewHeader_Suave smallfont2" style="text-align: center;">
                                        Grupos contables
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;
                                    </td>
                                    <td>
                                    </td>

                                </tr>
                                <tr>
                                    <td>
                                        <asp:ListBox ID="Sql_it_ID_Numeric" 
                                                    runat="server" 
                                                    DataSourceID="CuentasContables_SqlDataSource"
                                                    DataTextField="CuentaContableYNombre" 
                                                    DataValueField="ID" 
                                                    SelectionMode="Multiple" 
                                                    Width="350px" 
                                                    Rows="30"
                                                    CssClass="smallfont" />
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;
                                    </td>
                                    <td>
                                        <asp:ListBox ID="Sql_it_Grupo_Numeric" 
                                                    runat="server" 
                                                    DataSourceID="GruposContables_SqlDataSource"
                                                    DataTextField="Descripcion" 
                                                    DataValueField="Grupo" 
                                                    SelectionMode="Multiple" 
                                                    Width="350px" 
                                                    Rows="30"
                                                    CssClass="smallfont" />
                                    </td>
                                    <td>
                                        &nbsp;&nbsp;
                                    </td>
                                    <td>
                                    
                                    </td>

                                </tr>
                            </table>

                        </ContentTemplate>
                    </asp:TabPanel>

                </asp:tabcontainer>

            </ContentTemplate>
        </asp:UpdatePanel>

        <div style="text-align: right; margin-top: 15px; ">
            
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
            SelectCommand="SELECT Descripcion, Moneda FROM Monedas ORDER BY Simbolo">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="CuentasContables_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT ID, CuentasContables.Cuenta + ' - ' + CuentasContables.Descripcion + ' (' + Companias.Abreviatura + ')' AS CuentaContableYNombre FROM CuentasContables INNER JOIN Companias ON CuentasContables.Cia = Companias.Numero WHERE (CuentasContables.TotDet = 'D' And CuentasContables.ActSusp = 'A') ORDER BY Companias.NombreCorto, CuentasContables.Cuenta + N' ' + CuentasContables.Descripcion">
        </asp:SqlDataSource>

        <asp:SqlDataSource ID="GruposContables_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
            SelectCommand="SELECT Grupo, Descripcion FROM tGruposContables Where OrdenBalanceGeneral <> 0 ORDER BY OrdenBalanceGeneral">
        </asp:SqlDataSource>

    </div>
</asp:Content>