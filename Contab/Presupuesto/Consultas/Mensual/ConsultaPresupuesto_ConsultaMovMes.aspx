<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="Contab_Presupuesto_Consultas_Mensual_ConsultaPresupuesto_ConsultaMovMes" Codebehind="ConsultaPresupuesto_ConsultaMovMes.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <h4 runat="server" ID="TituloConsulta_H2" style="text-align: left; margin-left: 15px; "></h4>
    
    <span id="ErrMessage_Span" runat="server" class="errmessage errmessage_background generalfont"
            style="display: block;"></span>

    <asp:ListView ID="MovimientosContables_ListView" runat="server" 
                  DataSourceID="MovimientosContables_SqlDataSource">
        <LayoutTemplate>
            <table runat="server">
                <tr runat="server">
                    <td runat="server">
                        <table ID="itemPlaceholderContainer" runat="server" border="0" style="border: 1px solid #E6E6E6"
                                            class="notsosmallfont" cellspacing="0" rules="none">
                            <tr runat="server" style="" class="ListViewHeader_Suave">
                                <th runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; ">
                                    Fecha</th>
                                <th runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; ">
                                    Numero</th>
                                <th runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px; ">
                                    Cuenta contable</th>
                                <th runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px; ">
                                    Nombre</th>
                                <th runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px; ">
                                    Descripción</th>
                                <th runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px; ">
                                    Referencia</th>
                                <th runat="server" class="padded" style="text-align: right; padding-top: 4px; padding-bottom: 4px; ">
                                    Monto</th>
                            </tr>
                            <tr ID="itemPlaceholder" runat="server"></tr>
                            <tr id="Tr1" runat="server" style="background: #E1ECF9; color: #000000;" class="ListViewHeader_Suave">
                                <th id="Th1" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; ">
                                    </th>
                                <th id="Th2" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; ">
                                    </th>
                                <th id="Th3" runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px; ">
                                    </th>
                                <th id="Th4" runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px; ">
                                    </th>
                                <th id="Th5" runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px; ">
                                    </th>
                                <th id="Th6" runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px; ">
                                    Total:</th>
                                <th id="Th7" runat="server" class="padded" style="text-align: right; padding-top: 4px; padding-bottom: 4px; ">
                                    <asp:Label ID="GranTotal_Label" runat="server" Text="Label"></asp:Label></th>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr runat="server">
                    <td id="Td1" runat="server" style="text-align: left; ">
                        <asp:DataPager ID="DataPager1" runat="server" PageSize="20">
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
                <td class="padded" style="text-align: center; white-space: nowrap; ">
                    <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha", "{0:dd-MMM-yy}") %>' />
                </td>
                <td class="padded" style="text-align: center;">
                    <asp:Label ID="NumeroLabel" runat="server" Text='<%# Eval("Numero") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="CuentaEditadaLabel" runat="server" 
                        Text='<%# Eval("CuentaEditada") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="NombreCuentaContableLabel" runat="server" 
                        Text='<%# Eval("NombreCuentaContable") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="DescripcionAsientoLabel" runat="server" 
                        Text='<%# Eval("DescripcionAsiento") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="ReferenciaLabel" runat="server" 
                        Text='<%# Eval("Referencia") %>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label ID="MontoLabel" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                </td>
            </tr>
        </ItemTemplate>
        <AlternatingItemTemplate>
            <tr style="" class="ListViewAlternatingRow">
                <td class="padded" style="text-align: center; white-space: nowrap; ">
                    <asp:Label ID="FechaLabel" runat="server" Text='<%# Eval("Fecha", "{0:dd-MMM-yy}") %>' />
                </td>
                <td class="padded" style="text-align: center;">
                    <asp:Label ID="NumeroLabel" runat="server" Text='<%# Eval("Numero") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="CuentaEditadaLabel" runat="server" 
                        Text='<%# Eval("CuentaEditada") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="NombreCuentaContableLabel" runat="server" 
                        Text='<%# Eval("NombreCuentaContable") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="DescripcionAsientoLabel" runat="server" 
                        Text='<%# Eval("DescripcionAsiento") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="ReferenciaLabel" runat="server" 
                        Text='<%# Eval("Referencia") %>' />
                </td>
                <td class="padded" style="text-align: right;">
                    <asp:Label ID="MontoLabel" runat="server" Text='<%# Eval("Monto", "{0:N2}") %>' />
                </td>
            </tr>
        </AlternatingItemTemplate>
        <EmptyDataTemplate>
            <table runat="server" style="">
                <tr>
                    <td>
                        No data was returned.</td>
                </tr>
            </table>
        </EmptyDataTemplate>
        
    </asp:ListView>
    
    <asp:SqlDataSource ID="MovimientosContables_SqlDataSource" runat="server" 
    ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
    SelectCommand="SELECT Asientos.Fecha, Asientos.Numero, CuentasContables.CuentaEditada, CuentasContables.Descripcion AS NombreCuentaContable, dAsientos.Descripcion AS DescripcionAsiento, dAsientos.Referencia, CASE WHEN dAsientos.Haber &lt;&gt; 0 THEN dAsientos.Haber * -1 ELSE dAsientos.Debe END AS Monto FROM dAsientos INNER JOIN CuentasContables ON dAsientos.CuentaContableID = CuentasContables.ID INNER JOIN Presupuesto_AsociacionCodigosCuentas ON CuentasContables.ID = Presupuesto_AsociacionCodigosCuentas.CuentaContableID 
        Inner Join Asientos On dAsientos.NumeroAutomatico = Asientos.NumeroAutomatico 
Where Asientos.MesFiscal = @MesFiscal And Asientos.AnoFiscal = @AnoFiscal And Asientos.Moneda = @Moneda And Asientos.Cia = @CiaContab And Presupuesto_AsociacionCodigosCuentas.CodigoPresupuesto = 
@CodigoPresupuesto And Presupuesto_AsociacionCodigosCuentas.CiaContab = @CiaContab">
        <SelectParameters>
            <asp:Parameter Name="MesFiscal" />
            <asp:Parameter Name="AnoFiscal" />
            <asp:Parameter Name="Moneda" />
            <asp:Parameter Name="CiaContab" />
            <asp:Parameter Name="CodigoPresupuesto" />
        </SelectParameters>
</asp:SqlDataSource>
</asp:Content>

