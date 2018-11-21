<%@ Page Language="C#" MasterPageFile="~/MasterPage_Simple.master" AutoEventWireup="true" CodeBehind="UltimoMesCerradoContable.aspx.cs" Inherits="ContabSysNetWeb.Contab.UltimoMesCerradoContable" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div>
   <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource1">
        
        <LayoutTemplate>
            <table id="Table1" runat="server" class="generalfont">
                <tr id="Tr1" runat="server">
                    <td id="Td1" runat="server">
                        <table ID="itemPlaceholderContainer" runat="server" border="0" cellspacing="0" style="">
                            <tr id="Tr2" runat="server" style="" class="ListViewHeader generalfont">
                                <th id="Th5" runat="server"  class="padded" style="text-align: center; margin-bottom: 10px;">
                                    ##</th>
                                <th id="Th1" runat="server"  class="padded" style="text-align: left; margin-bottom: 10px;">
                                    Compañía</th>
                                <th id="Th2" runat="server"  class="padded" style="text-align: left; margin-bottom: 10px;">
                                    Mes</th>
                                <th id="Th3" runat="server"  class="padded" style="text-align: center; margin-bottom: 10px;">
                                    Año</th>
                                <th id="Th4" runat="server"  class="padded" style="text-align: center; margin-bottom: 10px;">
                                    Fecha ejecución</th>
                            </tr>
                            <tr ID="itemPlaceholder" runat="server">
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr id="Tr3" runat="server">
                    <td id="Td2" runat="server" style="text-align:left; ">
                        <asp:DataPager ID="DataPager1" runat="server">
                            <Fields>
                                <asp:NextPreviousPagerField ButtonType="Link" FirstPageImageUrl="../../../Pictures/first_16x16.gif"
                                FirstPageText="&lt;&lt;" NextPageText="&gt;" PreviousPageImageUrl="../../../Pictures/left_16x16.gif"
                                PreviousPageText="&lt;" ShowFirstPageButton="True" ShowNextPageButton="False"
                                ShowPreviousPageButton="True" />
                                <asp:NumericPagerField />
                                <asp:NextPreviousPagerField ButtonType="Link" LastPageImageUrl="../../../Pictures/last_16x16.gif"
                                LastPageText="&gt;&gt;" NextPageImageUrl="../../../Pictures/right_16x16.gif"
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
                <td class="padded" style="text-align: center; ">
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("CiaContabID") %>' />
                </td>
                <td class="padded" style="text-align: left; ">
                    <asp:Label ID="NombreCiaContabLabel" runat="server" Text='<%# Eval("NombreCiaContab") %>' />
                </td>
                <td class="padded" style="text-align: left; ">
                    <asp:Label ID="NombreMesLabel" runat="server" Text='<%# Eval("NombreMes") %>' />
                </td>
                <td class="padded" style="text-align: center; ">
                    <asp:Label ID="AnoLabel" runat="server" Text='<%# Eval("Ano") %>' />
                </td>
                <td class="padded" style="text-align: center; ">
                    <asp:Label ID="UltActLabel" runat="server" Text='<%# Eval("UltAct", "{0:dd-MMM-yy hh:mm tt}") %>' />
                </td>
            </tr>
        </ItemTemplate>
      <AlternatingItemTemplate >
            <tr style="" class="ListViewAlternatingRow">
                <td class="padded" style="text-align: center; ">
                    <asp:Label ID="Label1" runat="server" Text='<%# Eval("CiaContabID") %>' />
                </td>
                <td class="padded" style="text-align: left; ">
                    <asp:Label ID="NombreCiaContabLabel" runat="server" 
                        Text='<%# Eval("NombreCiaContab") %>' />
                </td>
                <td class="padded" style="text-align: left; ">
                    <asp:Label ID="NombreMesLabel" runat="server" Text='<%# Eval("NombreMes") %>' />
                </td>
                <td class="padded" style="text-align: center; ">
                    <asp:Label ID="AnoLabel" runat="server" Text='<%# Eval("Ano") %>' />
                </td>
                <td class="padded" style="text-align: center; ">
                    <asp:Label ID="UltActLabel" runat="server" Text='<%# Eval("UltAct", "{0:dd-MMM-yy hh:mm tt}") %>' />
                </td>
               
            </tr>
        </AlternatingItemTemplate>
        <EmptyDataTemplate>
            <table id="Table2" runat="server" style="">
                <tr>
                    <td>
                        No data has been returned.</td>
                </tr>
            </table>
        </EmptyDataTemplate>
        
       
    </asp:ListView>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:dbContabConnectionString %>" 
        SelectCommand="SELECT MesesDelAnoFiscal.NombreMes, UltimoMesCerradoContab.Ano, UltimoMesCerradoContab.UltAct, Companias.Numero as CiaContabID, Companias.Nombre AS NombreCiaContab FROM UltimoMesCerradoContab INNER JOIN MesesDelAnoFiscal ON UltimoMesCerradoContab.Cia = MesesDelAnoFiscal.Cia AND UltimoMesCerradoContab.Mes = MesesDelAnoFiscal.MesFiscal INNER JOIN Companias ON MesesDelAnoFiscal.Cia = Companias.Numero">
    </asp:SqlDataSource>
</div>

</asp:Content>
