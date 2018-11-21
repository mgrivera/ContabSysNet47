<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage_Simple.master" CodeBehind="MovimientosBancarios_page_Filter.aspx.cs" Inherits="ContabSysNet_Web.Bancos.ConsultasBancos.MovimientosBancarios.MovimientosBancarios_page_Filter" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<div style="text-align: left; padding: 0px 20px 0px 20px;">

    <asp:ValidationSummary ID="ValidationSummary1" 
                           runat="server" 
                           class="errmessage_background generalfont errmessage"
                           ForeColor="" />

    <span id="ErrMessage_Span" runat="server" 
            class="errmessage errmessage_background generalfont"
            style="display: block;" />

    <cc1:tabcontainer id="TabContainer1" runat="server" activetabindex="0">

        <cc1:TabPanel HeaderText="Generales" runat="server" ID="TabPanel1" >

            <ContentTemplate>

                <table style="font-size: x-small; ">

                    <tr>
                        <td>
                            Fecha: 
                        </td>

                        <td>
                            <asp:TextBox ID="Sql_it_Fecha_Date" runat="server" />
                        </td>
                       
                        <td />
                        <td />

                        <td>
                            Número: 
                        </td>
                       
                        <td />
                            <asp:TextBox ID="Sql_it_Transaccion_Numeric" runat="server" />
                        <td />
                    </tr>

                     <tr>
                        <td>
                            F entrega: 
                        </td>

                        <td>
                            <asp:TextBox ID="Sql_it_FechaEntregado_Date" runat="server" />
                        </td>
                       
                        <td />
                        <td />

                        <td>
                            Beneficiario: 
                        </td>
                       
                        <td />
                            <asp:TextBox ID="Sql_it_Beneficiario_String" runat="server" />
                        <td />
                    </tr>

                     <tr>
                        <td>
                            Concepto: 
                        </td>

                        <td>
                            <asp:TextBox ID="Sql_it_Concepto_String" runat="server" />
                        </td>
                       
                        <td />
                        <td />

                        <td>
                            Monto: 
                        </td>
                       
                        <td />
                            <asp:TextBox ID="Sql_it_Monto_Numeric" runat="server" />
                        <td />
                    </tr>

                </table>

            </ContentTemplate>

            </cc1:TabPanel>


        <cc1:TabPanel HeaderText="Lista (1)" runat="server" ID="TabPanel2" >

            <ContentTemplate>

                <table style="width: 100%; height: 100%;">
                    <tr>
                        <td class="ListViewHeader_Suave generalfont" style="text-align: center;">
                            Cias contab
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td class="ListViewHeader_Suave generalfont" style="text-align: center;">
                            Tipos
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td class="ListViewHeader_Suave generalfont" style="text-align: center;">
                            Compañías
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:ListBox ID="Sql_it_Chequera_CuentasBancaria_Cia_Numeric" 
                                runat="server" 
                                DataTextField="Nombre" DataValueField="Numero" 
                                AutoPostBack="False" 
                                SelectionMode="Multiple" 
                                Rows="20" />
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td>
                            <asp:ListBox ID="Sql_it_Tipo_String" 
                                         runat="server" 
                                         Width="150px" 
                                         DataSourceID="Tipos_SqlDataSource"
                                         DataTextField="Tipo" 
                                         DataValueField="Tipo" 
                                         SelectionMode="Multiple"
                                         Rows="20"
                                         AutoPostBack="False" />
                        </td>
                        <td>
                            &nbsp;&nbsp;
                        </td>
                        <td>
                            <asp:ListBox ID="Sql_it_Proveedore_Proveedor_Numeric" 
                                        runat="server" 
                                        DataSourceID="Proveedores_SqlDataSource"
                                        DataTextField="Nombre" DataValueField="Proveedor" 
                                        AutoPostBack="False" 
                                        SelectionMode="Multiple" 
                                        Rows="20" />
                        </td>

                    </tr>
                </table>

            </ContentTemplate>
        </cc1:TabPanel>

         <cc1:TabPanel HeaderText="Lista (2)" runat="server" ID="TabPanel3" >
            <ContentTemplate>
                    <table style="width: 100%; height: 100%;">
                        <tr>
                            <td class="ListViewHeader_Suave generalfont" style="text-align: center;">
                                Bancos
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                             <td class="ListViewHeader_Suave generalfont" style="text-align: center;">
                                Cuentas bancarias
                            </td>
                             <td>
                                &nbsp;&nbsp;
                            </td>
                             <td class="ListViewHeader_Suave generalfont" style="text-align: center;">
                                Monedas
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:ListBox ID="Sql_it_Chequera_CuentasBancaria_Agencia1_Banco1_Banco1_Numeric" 
                                             runat="server" 
                                             DataSourceID="Bancos_SqlDataSource"
                                             DataTextField="Nombre" DataValueField="Banco" 
                                             AutoPostBack="True" 
                                             OnSelectedIndexChanged="Bancos_ListBox_SelectedIndexChanged"
                                             SelectionMode="Multiple" 
                                             Rows="20" />
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                             <td>
                                <asp:ListBox ID="Sql_it_Chequera_CuentasBancaria_CuentaInterna_Numeric" 
                                             runat="server" 
                                             DataSourceID="CuentasBancarias_SqlDataSource"
                                             DataTextField="CuentaBancariaYBanco" 
                                             DataValueField="CuentaInterna" 
                                             AutoPostBack="False" 
                                             SelectionMode="Multiple" 
                                             Rows="20" />
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                             <td>
                                <asp:ListBox ID="Sql_it_Chequera_CuentasBancaria_Moneda1_Moneda1_Numeric" 
                                             Width="200px"
                                             runat="server" 
                                             DataSourceID="Monedas_SqlDataSource"
                                             DataTextField="Descripcion" 
                                             DataValueField="Moneda" 
                                             AutoPostBack="False" 
                                             SelectionMode="Multiple" 
                                             Rows="20" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </cc1:TabPanel>

            <cc1:TabPanel HeaderText="Lista (3)" runat="server" ID="TabPanel4" >
                <ContentTemplate>
                    <table style="width: 100%; height: 100%;">
                        <tr>
                            <td class="ListViewHeader_Suave generalfont" style="text-align: center;">
                                Usuarios
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                             <td>
                                &nbsp;&nbsp;
                            </td>
                             <td>
                                &nbsp;&nbsp;
                            </td>
                             <td>
                                &nbsp;&nbsp;
                            </td>
                        </tr>

                        <tr>
                            <td>
                                <asp:ListBox ID="Sql_it_Usuario_String" 
                                             Width="200px" 
                                             runat="server" 
                                             DataSourceID="Usuarios_SqlDataSource"
                                             DataTextField="Usuario" 
                                             DataValueField="Usuario" 
                                             AutoPostBack="False" 
                                             SelectionMode="Multiple" 
                                             Rows="20" />
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                             <td>
                                &nbsp;&nbsp;
                            </td>
                            <td>
                                &nbsp;&nbsp;
                            </td>
                             <td>
                                &nbsp;&nbsp;
                            </td>

                        </tr>

                    </table>
            </ContentTemplate>
        </cc1:TabPanel>
    </cc1:tabcontainer>
</div>

<asp:panel style="text-align: right; padding: 20px;" 
           runat="server" DefaultButton="AplicarFiltro_Button">

        <asp:Button ID="LimpiarFiltro_Button" 
                    runat="server" 
                    Text="Limpiar filtro" 
                    CausesValidation="False" 
                    onclick="LimpiarFiltro_Button_Click" />

        <asp:Button ID="AplicarFiltro_Button" 
                    runat="server" 
                    Text="Aplicar filtro" 
                    onclick="AplicarFiltro_Button_Click" />

</asp:panel>
        
<asp:SqlDataSource ID="Proveedores_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
    SelectCommand="SELECT Proveedor, Nombre From Proveedores Where ProveedorClienteFlag = 1 Or ProveedorClienteFlag = 3 Order By Nombre">
</asp:SqlDataSource>

<asp:SqlDataSource ID="Bancos_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
    SelectCommand="SELECT [Banco], [Nombre] FROM [Bancos] ORDER BY [Nombre]">
</asp:SqlDataSource>

<asp:SqlDataSource ID="CuentasBancarias_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
        SelectCommand="SELECT CuentaInterna, CuentasBancarias.CuentaBancaria + ' (' + Bancos.Abreviatura + ')' As CuentaBancariaYBanco 
        FROM CuentasBancarias 
        Inner Join Agencias On CuentasBancarias.Agencia = Agencias.Agencia 
        Inner Join Bancos On Agencias.Banco = Bancos.Banco">
</asp:SqlDataSource>

<asp:SqlDataSource ID="Monedas_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
        SelectCommand="SELECT [Moneda], [Descripcion] FROM [Monedas] ORDER BY [Descripcion]">
</asp:SqlDataSource>

<asp:SqlDataSource ID="Tipos_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
        SelectCommand="Select Distinct Tipo From MovimientosBancarios Order By Tipo">
</asp:SqlDataSource>

<asp:SqlDataSource ID="Usuarios_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
        SelectCommand="Select Distinct Usuario From MovimientosBancarios Order By Usuario">
</asp:SqlDataSource>
                                  
</asp:Content>