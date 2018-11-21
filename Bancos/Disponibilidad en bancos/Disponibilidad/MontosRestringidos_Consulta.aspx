<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="Bancos_Disponibilidad_en_bancos_Disponibilidad_MontosRestringidos_Consulta" Codebehind="MontosRestringidos_Consulta.aspx.cs" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div style="text-align: left; ">

 <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
                    style="display: block;"></span>
                    
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
        <cc1:TabContainer ID="ConsultaDisponibilidad_TabContainer" runat="server" ActiveTabIndex="0"
        ScrollBars="Horizontal">
        <cc1:TabPanel runat="server" HeaderText="Montos restringidos" ID="TabPanel1">
            <ContentTemplate>
            <div style="text-align: center; ">
            <h5>
                    Consulta de registros de montos restringidos</h5>
                <div style="border: 1px dotted #C0C0C0; width: 70%; background-color: #E0E0E0; font-size: small;
                    text-align: left;">
                    <b>Nota:</b> Ud. debe aplicar un filtro y ejecutar la consulta de disponibildad
                    antes de consultar los registros de montos restringidos. Los registros mostrados
                    corresponden, en forma específica, a la consulta de disponibilidad que Ud. haya
                    efectuado.
                </div>
                <br />
            </div>
               
                <asp:ListView ID="ConsultaMontosRestringidos_ListView" runat="server" DataSourceID="ConsultaMontosRestringidos_SqlDataSource">
                    <LayoutTemplate>
                        <table id="Table1" runat="server">
                            <tr id="Tr1" runat="server">
                                <td id="Td1" runat="server">
                                    <table id="itemPlaceholderContainer" runat="server" border="0" style="border: 1px solid #E6E6E6"
                                        class="notsosmallfont" cellspacing="0" rules="none">
                                        <tr id="Tr2" runat="server" style="" class="ListViewHeader_Suave">
                                            <th id="Th1" runat="server" class="padded" style="text-align: center; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Mon
                                            </th>
                                            <th id="Th2" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Compañía
                                            </th>
                                            <th id="Th3" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Cuenta bancaria
                                            </th>
                                            <th id="Th4" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Banco
                                            </th>
                                            <th id="Th5" runat="server" class="padded" style="text-align: center; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Fecha
                                            </th>
                                            <th id="Th6" runat="server" class="padded" style="text-align: right; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Monto
                                            </th>
                                            <th id="Th7" runat="server" class="padded" style="text-align: center; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Desactivar
                                            </th>
                                            <th id="Th8" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Observaciones
                                            </th>
                                        </tr>
                                        <tr id="itemPlaceholder" runat="server">
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr id="Tr3" runat="server" style="text-align: left; ">
                                <td id="Td2" runat="server">
                                    <asp:DataPager ID="DataPager1" runat="server">
                                        <Fields>
                                            <asp:NextPreviousPagerField ButtonType="Image" FirstPageText="&lt;&lt;" NextPageText="&gt;"
                                                PreviousPageImageUrl="~/Pictures/ListView_Buttons/PgPrev.gif" PreviousPageText="&lt;"
                                                ShowFirstPageButton="True" ShowNextPageButton="False" ShowPreviousPageButton="True"
                                                FirstPageImageUrl="~/Pictures/ListView_Buttons/PgFirst.gif" />
                                            <asp:NumericPagerField />
                                            <asp:NextPreviousPagerField ButtonType="Image" LastPageImageUrl="~/Pictures/ListView_Buttons/PgLast.gif"
                                                LastPageText="&gt;&gt;" NextPageImageUrl="~/Pictures/ListView_Buttons/PgNext.gif"
                                                NextPageText="&gt;" PreviousPageText="&lt;" ShowLastPageButton="True" ShowNextPageButton="True"
                                                ShowPreviousPageButton="False" />
                                        </Fields>
                                    </asp:DataPager>
                                </td>
                            </tr>
                        </table>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <tr style="">
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="SimboloMonedaLabel" runat="server" Text='<%# Eval("SimboloMoneda") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NombreCompaniaLabel" runat="server" Text='<%# Eval("NombreCompania") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="CuentaBancariaLabel" runat="server" Text='<%# Eval("CuentaBancaria") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NombreBancoLabel" runat="server" Text='<%# Eval("NombreBanco") %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space: nowrap;">
                                <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha", "{0:d-MMM-y}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="MontoLabel" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space: nowrap;">
                                <asp:Label ID="DesactivarElLabel" runat="server" Text='<%# Eval("DesactivarEl", "{0:d-MMM-y}") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="ComentariosLabel" runat="server" Text='<%# Eval("Comentarios") %>' />
                            </td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr style="" class="ListViewAlternatingRow">
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="SimboloMonedaLabel" runat="server" Text='<%# Eval("SimboloMoneda") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NombreCompaniaLabel" runat="server" Text='<%# Eval("NombreCompania") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="CuentaBancariaLabel" runat="server" Text='<%# Eval("CuentaBancaria") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NombreBancoLabel" runat="server" Text='<%# Eval("NombreBanco") %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space: nowrap;">
                                <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha", "{0:d-MMM-y}") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="MontoLabel" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space: nowrap;">
                                <asp:Label ID="DesactivarElLabel" runat="server" Text='<%# Eval("DesactivarEl", "{0:d-MMM-y}") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="ComentariosLabel" runat="server" Text='<%# Eval("Comentarios") %>' />
                            </td>
                        </tr>
                    </AlternatingItemTemplate>
                    <EmptyDataTemplate>
                        <table id="Table2" runat="server" style="">
                            <tr>
                                <td>
                                    No existen registros que mostrar en esta consulta.
                                </td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                </asp:ListView>
                <asp:SqlDataSource ID="ConsultaMontosRestringidos_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
                    SelectCommand="SELECT Monedas.Simbolo AS SimboloMoneda, Companias.Abreviatura AS NombreCompania, CuentasBancarias.CuentaBancaria, Bancos.Abreviatura AS NombreBanco, Disponibilidad_MontosRestringidos_ConsultaDisponibilidad.Fecha, Disponibilidad_MontosRestringidos_ConsultaDisponibilidad.Monto, Disponibilidad_MontosRestringidos_ConsultaDisponibilidad.DesactivarEl, Disponibilidad_MontosRestringidos_ConsultaDisponibilidad.Comentarios FROM Disponibilidad_MontosRestringidos_ConsultaDisponibilidad INNER JOIN Companias ON Disponibilidad_MontosRestringidos_ConsultaDisponibilidad.CiaContab = Companias.Numero INNER JOIN Monedas ON Disponibilidad_MontosRestringidos_ConsultaDisponibilidad.Moneda = Monedas.Moneda INNER JOIN CuentasBancarias Inner Join Agencias On CuentasBancarias.Agencia = Agencias.Agencia Inner Join Bancos ON Agencias.Banco = Bancos.Banco ON Disponibilidad_MontosRestringidos_ConsultaDisponibilidad.CuentaBancaria = CuentasBancarias.CuentaInterna WHERE (Disponibilidad_MontosRestringidos_ConsultaDisponibilidad.NombreUsuario = @NombreUsuario)">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="xyz" Name="NombreUsuario" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </ContentTemplate>
        </cc1:TabPanel>
        <cc1:TabPanel runat="server" HeaderText="Cheques no entregados" ID="TabPanel2">
            <ContentTemplate>
            <div style="text-align: center; ">
            <h5>
                    Consulta de cheques aún no entregados</h5>
                <div style="border: 1px dotted #C0C0C0; width: 70%; background-color: #E0E0E0; font-size: small;
                    text-align: left;">
                    <b>Nota:</b> Ud. debe aplicar un filtro y ejecutar la consulta de disponibildad
                    antes de consultar las ocurrencias de cheques aún no entregados. Los registros mostrados
                    corresponden, en forma específica, a la consulta de disponibilidad que Ud. haya
                    efectuado.
                </div>
                <br />
            </div>
                
                <asp:ListView ID="ChequesNoEntregados_ListView" runat="server" DataSourceID="ChequesNoEntregados_SqlDataSource">
                    <LayoutTemplate>
                        <table id="Table1" runat="server">
                            <tr id="Tr1" runat="server">
                                <td id="Td1" runat="server">
                                    <table id="itemPlaceholderContainer" runat="server" border="0" style="border: 1px solid #E6E6E6"
                                        class="smallfont" cellspacing="0" rules="none">
                                        <tr id="Tr2" runat="server" style="" class="ListViewHeader_Suave">
                                            <th id="Th1" runat="server" class="padded" style="text-align: center; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Mon
                                            </th>
                                            <th id="Th2" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Compañía
                                            </th>
                                            <th id="Th9" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Banco
                                            </th>
                                            <th id="Th3" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Cuenta bancaria
                                            </th>
                                            <th id="Th4" runat="server" class="padded" style="text-align: center; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Fecha
                                            </th>
                                            <th id="Th5" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Transacción
                                            </th>
                                             <th id="Th10" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Prov / Clte
                                            </th>
                                            <th id="Th6" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Beneficiario
                                            </th>
                                            <th id="Th7" runat="server" class="padded" style="text-align: left; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Concepto
                                            </th>
                                            <th id="Th8" runat="server" class="padded" style="text-align: right; padding-bottom: 8px;
                                                padding-top: 8px;">
                                                Monto
                                            </th>
                                        </tr>
                                        <tr id="itemPlaceholder" runat="server">
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr id="Tr3" runat="server" style="text-align: left; ">
                                <td id="Td2" runat="server">
                                    <asp:DataPager ID="DataPager1" runat="server">
                                        <Fields>
                                            <asp:NextPreviousPagerField ButtonType="Image" FirstPageText="&lt;&lt;" NextPageText="&gt;"
                                                PreviousPageImageUrl="~/Pictures/ListView_Buttons/PgPrev.gif" PreviousPageText="&lt;"
                                                ShowFirstPageButton="True" ShowNextPageButton="False" ShowPreviousPageButton="True"
                                                FirstPageImageUrl="~/Pictures/ListView_Buttons/PgFirst.gif" />
                                            <asp:NumericPagerField />
                                            <asp:NextPreviousPagerField ButtonType="Image" LastPageImageUrl="~/Pictures/ListView_Buttons/PgLast.gif"
                                                LastPageText="&gt;&gt;" NextPageImageUrl="~/Pictures/ListView_Buttons/PgNext.gif"
                                                NextPageText="&gt;" PreviousPageText="&lt;" ShowLastPageButton="True" ShowNextPageButton="True"
                                                ShowPreviousPageButton="False" />
                                        </Fields>
                                    </asp:DataPager>
                                </td>
                            </tr>
                        </table>
                    </LayoutTemplate>
                    <ItemTemplate>
                        <tr style="">
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="SimboloMonedaLabel" runat="server" Text='<%# Eval("SimboloMoneda") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NombreCompaniaLabel" runat="server" Text='<%# Eval("NombreCiaContab") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="CuentaBancariaLabel" runat="server" Text='<%# Eval("NombreBanco") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NombreBancoLabel" runat="server" Text='<%# Eval("CuentaBancaria") %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space: nowrap;">
                                <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha", "{0:d-MMM-y}") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("Transaccion") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("NombreProveedor") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("Beneficiario") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("Concepto") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="MontoLabel" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                            </td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr style="" class="ListViewAlternatingRow">
                            <td class="padded" style="text-align: center;">
                                <asp:Label ID="SimboloMonedaLabel" runat="server" Text='<%# Eval("SimboloMoneda") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NombreCompaniaLabel" runat="server" Text='<%# Eval("NombreCiaContab") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="CuentaBancariaLabel" runat="server" Text='<%# Eval("NombreBanco") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="NombreBancoLabel" runat="server" Text='<%# Eval("CuentaBancaria") %>' />
                            </td>
                            <td class="padded" style="text-align: center; white-space: nowrap;">
                                <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha", "{0:d-MMM-y}") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label1" runat="server" Text='<%# Eval("Transaccion") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label2" runat="server" Text='<%# Eval("NombreProveedor") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label3" runat="server" Text='<%# Eval("Beneficiario") %>' />
                            </td>
                            <td class="padded" style="text-align: left;">
                                <asp:Label ID="Label4" runat="server" Text='<%# Eval("Concepto") %>' />
                            </td>
                            <td class="padded" style="text-align: right; white-space: nowrap;">
                                <asp:Label ID="MontoLabel" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                            </td>
                        </tr>
                    </AlternatingItemTemplate>
                    <EmptyDataTemplate>
                        <table id="Table2" runat="server" style="">
                            <tr>
                                <td>
                                    No existen registros que mostrar en esta consulta.
                                </td>
                            </tr>
                        </table>
                    </EmptyDataTemplate>
                </asp:ListView>
                    
                 <asp:SqlDataSource ID="ChequesNoEntregados_SqlDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>"
                    
                    SelectCommand="SELECT Monedas.Simbolo AS SimboloMoneda, Companias.Abreviatura AS NombreCiaContab, Bancos.Abreviatura As NombreBanco, CuentasBancarias.CuentaBancaria, Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad.Fecha, Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad.Transaccion, Proveedores.Nombre AS NombreProveedor, Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad.Beneficiario, Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad.Concepto, Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad.Monto FROM Companias INNER JOIN Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad ON Companias.Numero = Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad.CiaContab INNER JOIN CuentasBancarias Inner Join Agencias On CuentasBancarias.Agencia = Agencias.Agencia INNER JOIN Bancos ON Agencias.Banco = Bancos.Banco ON Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad.CuentaBancaria = CuentasBancarias.CuentaInterna INNER JOIN Monedas ON CuentasBancarias.Moneda = Monedas.Moneda LEFT OUTER JOIN Proveedores ON Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad.ProvClte = Proveedores.Proveedor WHERE (Disponibilidad_ChequesNoEntregados_ConsultaDisponibilidad.NombreUsuario = @NombreUsuario)">
                    <SelectParameters>
                        <asp:Parameter DefaultValue="xyz" Name="NombreUsuario" />
                    </SelectParameters>
                </asp:SqlDataSource>
                    
            </ContentTemplate>
        </cc1:TabPanel>
    </cc1:TabContainer>
        </ContentTemplate>
    </asp:UpdatePanel>

    
    
</div>     
</asp:Content>

