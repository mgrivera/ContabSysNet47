<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="ConsultaPresupuesto_FactoresConversionAplicados.aspx.cs" Inherits="ContabSysNetWeb.Contab.Presupuesto.Consultas.Anual.ConsultaPresupuesto_FactoresConversionAplicados" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <asp:ListView ID="FactoresConversionAplicados_ListView" runat="server"  
            DataSourceID="FactoresConversionAplicados_SqlDataSource">
            <LayoutTemplate>
                <table id="Table1" runat="server">
                    <tr id="Tr1" runat="server">
                        <td id="Td1" runat="server">
                            <table ID="itemPlaceholderContainer" runat="server"  border="0" style="border: 1px solid #E6E6E6"
                                            class="generalfont" cellspacing="0" rules="none">
                                            
                                <tr id="Tr2" runat="server" style="" class="ListViewHeader">
                                        <th runat="server" class="padded" style="border-width: 0px; border-color: #FFFFFF; text-align: center; padding-top: 4px; padding-bottom: 4px; " colspan="2">
                                            Fiscal</th>
                                        <th runat="server" class="padded" style="border-width: 1px; border-color: #FFFFFF; text-align: center; padding-top: 4px; padding-bottom: 4px; border-left-style: solid; border-right-style: solid;" colspan="3">
                                            Calendario</th>
                                        <th runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; ">
                                            </th>
                                </tr>
                                    
                                <tr id="Tr3" runat="server" style="" class="ListViewHeader_Suave">
                                    <th id="Th0" runat="server" class="padded" style="text-align: center; padding-bottom: 8px;padding-top: 8px;">Mes</th>
                                    <th id="Th1" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; ">Año</th>
                                    <th id="Th2" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; ">Mes</th>
                                    <th id="Th3" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; ">Año</th>
                                    <th id="Th4" runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px; ">Nombre</th>
                                    <th id="Th5" runat="server" class="padded" style="text-align: center; padding-top: 4px; padding-bottom: 4px; ">Factor de conversión</th>
                                </tr>
                                <tr ID="itemPlaceholder" runat="server">
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr id="Tr4" runat="server">
                        <td id="Td2" runat="server" style="text-align: left; ">
                            <asp:DataPager ID="DataPager1" runat="server" PageSize="16">
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
                        <asp:Label ID="Label1" runat="server" 
                            Text='<%# Eval("MesFiscal") %>' />
                    </td>
                    <td class="padded" style="text-align: center;">
                        <asp:Label ID="Label2" runat="server" 
                            Text='<%# Eval("AnoFiscal") %>' />
                    </td>
                    <td class="padded" style="text-align: center;">
                        <asp:Label ID="Label3" runat="server" 
                            Text='<%# Eval("MesCalendario") %>' />
                    </td>
                    <td class="padded" style="text-align: center;">
                        <asp:Label ID="Label4" runat="server" 
                            Text='<%# Eval("AnoCalendario") %>' />
                    </td>
                    <td class="padded" style="text-align: left;">
                        <asp:Label ID="Label5" runat="server" 
                            Text='<%# Eval("NombreMes") %>' />
                    </td>
                    <td class="padded" style="text-align: center;">
                        <asp:Label ID="Label6" runat="server" 
                            Text='<%# Eval("FactorConversion", "{0:N2}") %>' />
                    </td>
                </tr>
            </ItemTemplate>
            <AlternatingItemTemplate>
                <tr style="" class="ListViewAlternatingRow">
                    <td class="padded" style="text-align: center;">
                        <asp:Label ID="Label1" runat="server" 
                            Text='<%# Eval("MesFiscal") %>' />
                    </td>
                    <td class="padded" style="text-align: center;">
                        <asp:Label ID="Label2" runat="server" 
                            Text='<%# Eval("AnoFiscal") %>' />
                    </td>
                    <td class="padded" style="text-align: center;">
                        <asp:Label ID="Label3" runat="server" 
                            Text='<%# Eval("MesCalendario") %>' />
                    </td>
                    <td class="padded" style="text-align: center;">
                        <asp:Label ID="Label4" runat="server" 
                            Text='<%# Eval("AnoCalendario") %>' />
                    </td>
                    <td class="padded" style="text-align: left;">
                        <asp:Label ID="Label5" runat="server" 
                            Text='<%# Eval("NombreMes") %>' />
                    </td>
                    <td class="padded" style="text-align: center;">
                        <asp:Label ID="Label6" runat="server" 
                            Text='<%# Eval("FactorConversion", "{0:N2}") %>' />
                    </td>
                </tr>
            </AlternatingItemTemplate>
            
            <EmptyDataTemplate>
                <table id="Table2" runat="server" style="">
                    <tr>
                        <td>
                            No hay información que mostrar. Probablemente, Ud. no ha ejecutado<br />la función
                            que lee los factores de conversión por mes y año y<br />los aplica a las cifras 
                            de la consulta.
                        </td>
                    </tr>
                </table>
            </EmptyDataTemplate> 
        </asp:ListView>
    
    <asp:SqlDataSource ID="FactoresConversionAplicados_SqlDataSource" 
        runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
            SelectCommand="SELECT MesFiscal, AnoFiscal, MesCalendario, AnoCalendario, NombreMes, 
                FactorConversion FROM FactoresConversionAnoMes_Aplicados 
                WHERE (NombreUsuario = @NombreUsuario)
                Order By MesFiscal, AnoFiscal">
        <SelectParameters>
            <asp:Parameter DefaultValue="xyz" Name="NombreUsuario" />
        </SelectParameters>
    </asp:SqlDataSource>

</asp:Content>