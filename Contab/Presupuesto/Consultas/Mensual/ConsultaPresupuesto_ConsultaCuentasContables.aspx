<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" Inherits="Contab_Presupuesto_Consultas_Mensual_ConsultaPresupuesto_ConsultaCuentasContables" Codebehind="ConsultaPresupuesto_ConsultaCuentasContables.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<div style="padding-top: 0px; padding-left: 20px; padding-right: 20px; padding-bottom: 20px; ">

    <h4 runat="server" ID="TituloConsulta_H2" style="text-align: left; "></h4>

    <asp:ListView ID="ConsultaCuentasContables_ListView" runat="server" 
        DataSourceID="ConsultaCuentasContables_SqlDataSource">
        
        <LayoutTemplate>
            <table runat="server">
                <tr runat="server">
                    <td runat="server">
                         <table ID="itemPlaceholderContainer" runat="server" border="0" style="border: 1px solid #E6E6E6"
                                            class="notsosmallfont" cellspacing="0" rules="none">
                            <tr runat="server" style="" class="ListViewHeader_Suave">
                                <th runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px; ">
                                    Cuenta contable</th>
                                <th runat="server" class="padded" style="text-align: left; padding-top: 4px; padding-bottom: 4px; ">
                                    Descripción</th>
                            </tr>
                            <tr ID="itemPlaceholder" runat="server">
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr runat="server">
                    <td runat="server" style="text-align: left; ">
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
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="CuentaEditadaLabel" runat="server" Text='<%# Eval("CuentaEditada") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="DescripcionLabel" runat="server" Text='<%# Eval("Descripcion") %>' />
                </td>
            </tr>
        </ItemTemplate>
        <AlternatingItemTemplate>
            <tr style="" class="ListViewAlternatingRow">
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="CuentaEditadaLabel" runat="server" Text='<%# Eval("CuentaEditada") %>' />
                </td>
                <td class="padded" style="text-align: left;">
                    <asp:Label ID="DescripcionLabel" runat="server" Text='<%# Eval("Descripcion") %>' />
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
    
    <asp:SqlDataSource ID="ConsultaCuentasContables_SqlDataSource" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        SelectCommand="SELECT CuentasContables.CuentaEditada, CuentasContables.Descripcion FROM CuentasContables INNER JOIN Presupuesto_AsociacionCodigosCuentas ON CuentasContables.ID = Presupuesto_AsociacionCodigosCuentas.CuentaContableID WHERE (Presupuesto_AsociacionCodigosCuentas.CiaContab = @CiaContab) AND (Presupuesto_AsociacionCodigosCuentas.CodigoPresupuesto = @CodigoPresupuesto) ORDER BY CuentasContables.CuentaEditada">
        <SelectParameters>
            <asp:Parameter Name="CiaContab" />
            <asp:Parameter Name="CodigoPresupuesto" />
        </SelectParameters>
    </asp:SqlDataSource>
    
    </div>

</asp:Content>

